/*
 * concolic_mp4_demo.c
 * 
 * Simplified MP4 parser demonstrating why symbolic/concolic execution
 * cannot generate a valid MP4 file to reach codec_id == H264.
 *
 * Compile for KLEE:
 *   clang -emit-llvm -c -g -O0 -Xclang -disable-O0-optnone \
 *       -DKLEE concolic_mp4_demo.c -o concolic_mp4_demo.bc
 *   klee --max-time=300 --max-memory=4096 concolic_mp4_demo.bc
 *
 * Compile for native execution (testing):
 *   gcc -o concolic_mp4_demo concolic_mp4_demo.c
 *   ./concolic_mp4_demo test.mp4
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <assert.h>

#ifdef KLEE
#include <klee/klee.h>
#define LOG(...)  /* disable printf for KLEE */
#else
#define LOG(...) printf(__VA_ARGS__)
#endif

/* ============================================================
 * Constants (matching real FFmpeg/MP4 spec values)
 * ============================================================ */
#define AV_CODEC_ID_H264    0x1B
#define AV_CODEC_ID_HEVC    0xAD
#define AV_CODEC_ID_UNKNOWN 0x00

#define MKTAG(a,b,c,d) ((uint32_t)(a) | ((uint32_t)(b) << 8) | \
                         ((uint32_t)(c) << 16) | ((uint32_t)(d) << 24))

#define TAG_FTYP MKTAG('f','t','y','p')
#define TAG_MOOV MKTAG('m','o','o','v')
#define TAG_TRAK MKTAG('t','r','a','k')
#define TAG_MDIA MKTAG('m','d','i','a')
#define TAG_MINF MKTAG('m','i','n','f')
#define TAG_STBL MKTAG('s','t','b','l')
#define TAG_STSD MKTAG('s','t','s','d')
#define TAG_AVCC MKTAG('a','v','c','C')
#define TAG_MDAT MKTAG('m','d','a','t')

#define FORMAT_AVC1 MKTAG('a','v','c','1')
#define FORMAT_HVC1 MKTAG('h','v','c','1')

#define INPUT_SIZE 512

/* Global flag to track if target was reached */
static int target_reached = 0;

/* ============================================================
 * Helper: Read big-endian 32-bit integer (with bounds check)
 * ============================================================ */
static uint32_t read_be32(const uint8_t *buf, int offset, int buf_size) {
    if (offset < 0 || offset + 4 > buf_size) return 0;
    return ((uint32_t)buf[offset] << 24) | ((uint32_t)buf[offset+1] << 16) |
           ((uint32_t)buf[offset+2] << 8) | (uint32_t)buf[offset+3];
}

/* ============================================================
 * Helper: Read little-endian 32-bit tag (with bounds check)
 * ============================================================ */
static uint32_t read_tag(const uint8_t *buf, int offset, int buf_size) {
    if (offset < 0 || offset + 4 > buf_size) return 0;
    return ((uint32_t)buf[offset]) | ((uint32_t)buf[offset+1] << 8) |
           ((uint32_t)buf[offset+2] << 16) | ((uint32_t)buf[offset+3] << 24);
}

/* ============================================================
 * Atom header reader
 * ============================================================ */
static int read_atom_header(const uint8_t *buf, int buf_size,
                            int pos, uint32_t *tag, uint32_t *size) {
    if (pos < 0 || pos + 8 > buf_size)
        return -1;
    *size = read_be32(buf, pos, buf_size);
    *tag  = read_tag(buf, pos + 4, buf_size);
    if (*size < 8 || pos + (int)*size > buf_size)
        return -1;
    return 0;
}

/* ============================================================
 * Layer 6: Parse avcC box (H.264 decoder configuration)
 * ============================================================ */
static int parse_avcC(const uint8_t *buf, int buf_size,
                      int offset, int size) {
    if (size < 7 || offset < 0 || offset + size > buf_size)
        return -1;

    uint8_t version = buf[offset];
    if (version != 1)
        return -1;

    uint8_t profile = buf[offset + 1];
    if (profile != 66 && profile != 77 && profile != 88 &&
        profile != 100 && profile != 110 && profile != 122)
        return -1;

    uint8_t nal_length_size = (buf[offset + 4] & 0x03) + 1;
    if (nal_length_size != 1 && nal_length_size != 2 && nal_length_size != 4)
        return -1;

    uint8_t num_sps = buf[offset + 5] & 0x1f;
    if (num_sps < 1 || num_sps > 4)
        return -1;

    int sps_offset = offset + 6;
    for (int i = 0; i < num_sps; i++) {
        if (sps_offset + 2 > offset + size)
            return -1;
        uint16_t sps_size = ((uint16_t)buf[sps_offset] << 8) | buf[sps_offset + 1];
        if (sps_size == 0 || sps_size > 128 || sps_offset + 2 + sps_size > offset + size)
            return -1;

        /* Check NAL unit type (should be 7 for SPS) */
        if (sps_offset + 2 >= buf_size)
            return -1;
        uint8_t nal_type = buf[sps_offset + 2] & 0x1f;
        if (nal_type != 7)
            return -1;

        sps_offset += 2 + sps_size;
    }

    LOG("[avcC] Valid H.264 config: profile=%d, %d SPS\n", profile, num_sps);
    return 0;
}

/* ============================================================
 * Layer 5: Parse stsd atom (sample description)
 * ============================================================ */
static int parse_stsd(const uint8_t *buf, int buf_size,
                      int offset, int size, int *codec_id) {
    if (size < 16 || offset < 0 || offset + size > buf_size)
        return -1;

    uint32_t entry_count = read_be32(buf, offset, buf_size);
    if (entry_count < 1 || entry_count > 4)
        return -1;

    int entry_offset = offset + 4;
    for (uint32_t i = 0; i < entry_count; i++) {
        if (entry_offset + 8 > offset + size)
            return -1;

        uint32_t entry_size = read_be32(buf, entry_offset, buf_size);
        uint32_t format     = read_tag(buf, entry_offset + 4, buf_size);

        if (entry_size < 8 || entry_offset + (int)entry_size > offset + size)
            return -1;

        if (format == FORMAT_AVC1) {
            *codec_id = AV_CODEC_ID_H264;
            LOG("[stsd] Found avc1 -> codec_id = H264\n");

            /* Find and parse avcC sub-box */
            int sub_offset = entry_offset + 8;
            while (sub_offset + 8 <= entry_offset + (int)entry_size) {
                uint32_t sub_size, sub_tag;
                if (read_atom_header(buf, buf_size, sub_offset, &sub_tag, &sub_size) < 0)
                    break;
                if (sub_tag == TAG_AVCC) {
                    if (parse_avcC(buf, buf_size, sub_offset + 8, sub_size - 8) < 0)
                        return -1;
                    return 0;  /* success */
                }
                sub_offset += sub_size;
            }
            return -1;  /* avcC not found */
        }

        entry_offset += entry_size;
    }
    return -1;
}

/* ============================================================
 * Find a child atom within a parent atom's body
 * ============================================================ */
static int find_child_atom(const uint8_t *buf, int buf_size,
                           int parent_offset, int parent_size,
                           uint32_t target_tag,
                           int *child_offset, int *child_size) {
    if (parent_offset < 0 || parent_offset + parent_size > buf_size)
        return -1;

    int pos = parent_offset;
    int end = parent_offset + parent_size;
    while (pos + 8 <= end) {
        uint32_t size, tag;
        if (read_atom_header(buf, buf_size, pos, &tag, &size) < 0)
            return -1;
        if (tag == target_tag) {
            *child_offset = pos + 8;
            *child_size = size - 8;
            return 0;
        }
        pos += size;
    }
    return -1;
}

/* ============================================================
 * Layers 1-4: Nested atom parsing
 * moov → trak → mdia → minf → stbl → stsd
 * ============================================================ */
static int parse_moov(const uint8_t *buf, int buf_size,
                      int offset, int size, int *codec_id) {
    int off, sz;

    if (find_child_atom(buf, buf_size, offset, size, TAG_TRAK, &off, &sz) < 0)
        return -1;
    LOG("[moov] Found trak at %d\n", off);

    int mdia_off, mdia_sz;
    if (find_child_atom(buf, buf_size, off, sz, TAG_MDIA, &mdia_off, &mdia_sz) < 0)
        return -1;
    LOG("[trak] Found mdia at %d\n", mdia_off);

    int minf_off, minf_sz;
    if (find_child_atom(buf, buf_size, mdia_off, mdia_sz, TAG_MINF, &minf_off, &minf_sz) < 0)
        return -1;
    LOG("[mdia] Found minf at %d\n", minf_off);

    int stbl_off, stbl_sz;
    if (find_child_atom(buf, buf_size, minf_off, minf_sz, TAG_STBL, &stbl_off, &stbl_sz) < 0)
        return -1;
    LOG("[minf] Found stbl at %d\n", stbl_off);

    int stsd_off, stsd_sz;
    if (find_child_atom(buf, buf_size, stbl_off, stbl_sz, TAG_STSD, &stsd_off, &stsd_sz) < 0)
        return -1;
    LOG("[stbl] Found stsd at %d\n", stsd_off);

    return parse_stsd(buf, buf_size, stsd_off, stsd_sz, codec_id);
}

/* ============================================================
 * Top-level parser: Find ftyp and moov atoms
 * ============================================================ */
static int parse_mp4(const uint8_t *buf, int buf_size, int *codec_id) {
    int pos = 0;
    int found_ftyp = 0, found_moov = 0;

    while (pos + 8 <= buf_size) {
        uint32_t size, tag;
        if (read_atom_header(buf, buf_size, pos, &tag, &size) < 0)
            break;

        if (tag == TAG_FTYP) {
            LOG("[top] Found ftyp at %d (size=%u)\n", pos, size);
            found_ftyp = 1;
        } else if (tag == TAG_MOOV) {
            LOG("[top] Found moov at %d (size=%u)\n", pos, size);
            if (parse_moov(buf, buf_size, pos + 8, size - 8, codec_id) == 0)
                found_moov = 1;
        }
        pos += size;
    }

    if (!found_ftyp || !found_moov)
        return -1;
    return 0;
}

/* ============================================================
 * Target function: ff_rtp_send_h264_hevc (simplified)
 * ============================================================ */
static void ff_rtp_send_h264_hevc(const uint8_t *data, int size) {
    target_reached = 1;
    LOG("=== TARGET REACHED: ff_rtp_send_h264_hevc() ===\n");
}

/* ============================================================
 * Main
 * ============================================================ */
int main(int argc, char *argv[]) {
    uint8_t input[INPUT_SIZE];
    int codec_id = AV_CODEC_ID_UNKNOWN;

#ifdef KLEE
    klee_make_symbolic(input, sizeof(input), "input");
#else
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }
    FILE *f = fopen(argv[1], "rb");
    if (!f) { perror("fopen"); return 1; }
    memset(input, 0, sizeof(input));
    fread(input, 1, sizeof(input), f);
    fclose(f);
#endif

    LOG("--- Parsing MP4 input (%d bytes) ---\n", INPUT_SIZE);

    if (parse_mp4(input, INPUT_SIZE, &codec_id) < 0) {
        LOG("FAILED: Invalid MP4 structure\n");
        return 1;
    }

    /* The branch condition from rtpenc.c */
    if (codec_id == AV_CODEC_ID_H264 ||
        codec_id == AV_CODEC_ID_HEVC) {
        ff_rtp_send_h264_hevc(input + 100, 50);
    } else {
        LOG("FAILED: codec_id (%d) is not H264/HEVC\n", codec_id);
        return 1;
    }

#ifdef KLEE
    /* If KLEE reaches here, it means it found a valid MP4 
       that passes all parsing and reaches the target.
       This assertion will FAIL, creating a visible test case. */
    if (target_reached) {
        assert(0 && "TARGET_REACHED");
    }
#endif

    return 0;
}




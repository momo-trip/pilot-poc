/*
 * concolic_mp4_demo.c
 * 
 * Simplified MP4 parser demonstrating why concolic execution
 * cannot generate a valid MP4 file to reach codec_id == H264.
 *
 * Compile for KLEE:
 *   clang -emit-llvm -c -g -O0 -Xclang -disable-O0-optnone concolic_mp4_demo.c -o concolic_mp4_demo.bc
 *   klee --max-time=300 concolic_mp4_demo.bc
 *
 * Compile for native execution (testing):
 *   gcc -o concolic_mp4_demo concolic_mp4_demo.c
 *   ./concolic_mp4_demo test.mp4
 */

 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <stdint.h>
 
 #ifdef KLEE
 #include <klee/klee.h>
 #endif
 
 /* ============================================================
  * Constants (matching real FFmpeg/MP4 spec values)
  * ============================================================ */
 #define AV_CODEC_ID_H264  0x1B
 #define AV_CODEC_ID_HEVC  0xAD
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
 
 #define INPUT_SIZE 512  /* Small input for KLEE feasibility */
 
 /* ============================================================
  * Helper: Read big-endian 32-bit integer
  * ============================================================ */
 static uint32_t read_be32(const uint8_t *p) {
     return ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16) |
            ((uint32_t)p[2] << 8)  | (uint32_t)p[3];
 }
 
 /* ============================================================
  * Helper: Read little-endian 32-bit tag
  * ============================================================ */
 static uint32_t read_tag(const uint8_t *p) {
     return ((uint32_t)p[0]) | ((uint32_t)p[1] << 8) |
            ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
 }
 
 /* ============================================================
  * Atom header reader
  * Returns atom size, sets *tag. Advances *pos.
  * ============================================================ */
 static int read_atom_header(const uint8_t *buf, int buf_size,
                             int *pos, uint32_t *tag, uint32_t *size) {
     if (*pos + 8 > buf_size)
         return -1;
     *size = read_be32(buf + *pos);       /* branch: depends on input bytes */
     *tag  = read_tag(buf + *pos + 4);    /* branch: depends on input bytes */
     if (*size < 8 || *pos + (int)*size > buf_size)
         return -1;                       /* branch: size validation */
     return 0;
 }
 
 /* ============================================================
  * Layer 6: Parse avcC box (H.264 decoder configuration)
  * This validates SPS/PPS NAL units.
  * ============================================================ */
 static int parse_avcC(const uint8_t *buf, int offset, int size) {
     if (size < 7)
         return -1;
 
     uint8_t version = buf[offset];           /* branch */
     if (version != 1)
         return -1;                           /* branch: must be version 1 */
 
     uint8_t profile = buf[offset + 1];       /* branch */
     /* H.264 profiles: Baseline(66), Main(77), High(100), etc. */
     if (profile != 66 && profile != 77 && profile != 88 &&
         profile != 100 && profile != 110 && profile != 122) {
         return -1;                           /* branch: valid profile check */
     }
 
     uint8_t compat = buf[offset + 2];        /* read compatibility */
     uint8_t level  = buf[offset + 3];        /* read level */
     (void)compat; (void)level;
 
     uint8_t nal_length_size = (buf[offset + 4] & 0x03) + 1;  /* branch */
     if (nal_length_size != 1 && nal_length_size != 2 && nal_length_size != 4)
         return -1;                           /* branch: valid NAL length */
 
     uint8_t num_sps = buf[offset + 5] & 0x1f;   /* branch */
     if (num_sps < 1)
         return -1;                           /* branch: at least one SPS */
 
     /* Validate each SPS - this creates data-dependent loop iterations */
     int sps_offset = offset + 6;
     for (int i = 0; i < num_sps; i++) {          /* loop: iteration count depends on input */
         if (sps_offset + 2 > offset + size)
             return -1;                       /* branch */
         uint16_t sps_size = ((uint16_t)buf[sps_offset] << 8) | buf[sps_offset + 1];
         if (sps_size == 0 || sps_offset + 2 + sps_size > offset + size)
             return -1;                       /* branch: SPS size validation */
 
         /* Check NAL unit type (should be 7 for SPS) */
         uint8_t nal_type = buf[sps_offset + 2] & 0x1f;  /* branch */
         if (nal_type != 7)
             return -1;                       /* branch: NAL type must be SPS */
 
         sps_offset += 2 + sps_size;
     }
 
     printf("[avcC] Valid H.264 configuration found: profile=%d, %d SPS units\n",
            profile, num_sps);
     return 0;
 }
 
 /* ============================================================
  * Layer 5: Parse stsd atom (sample description)
  * This is where codec_id gets determined.
  * ============================================================ */
 static int parse_stsd(const uint8_t *buf, int offset, int size,
                       int *codec_id) {
     if (size < 16)
         return -1;
 
     uint32_t entry_count = read_be32(buf + offset);  /* branch */
     if (entry_count < 1 || entry_count > 4)
         return -1;                                   /* branch: valid count */
 
     int entry_offset = offset + 4;
     for (uint32_t i = 0; i < entry_count; i++) {     /* loop: data-dependent */
         if (entry_offset + 8 > offset + size)
             return -1;
 
         uint32_t entry_size = read_be32(buf + entry_offset);     /* branch */
         uint32_t format     = read_tag(buf + entry_offset + 4);  /* branch */
 
         if (format == FORMAT_AVC1) {            /* KEY BRANCH: sets codec_id */
             *codec_id = AV_CODEC_ID_H264;
             printf("[stsd] Found avc1 format -> codec_id = H264\n");
 
             /* Now must find and parse avcC sub-box */
             int sub_offset = entry_offset + 8;
             int found_avcC = 0;
             while (sub_offset + 8 <= entry_offset + (int)entry_size) {
                 uint32_t sub_size, sub_tag;
                 int tmp = sub_offset;
                 if (read_atom_header(buf, offset + size, &tmp, &sub_tag, &sub_size) < 0)
                     break;                     /* branch */
                 if (sub_tag == TAG_AVCC) {     /* branch */
                     if (parse_avcC(buf, sub_offset + 8, sub_size - 8) < 0)
                         return -1;
                     found_avcC = 1;
                     break;
                 }
                 sub_offset += sub_size;        /* offset depends on previous data */
             }
             if (!found_avcC)
                 return -1;                     /* branch: avcC required */
             return 0;
         } else if (format == FORMAT_HVC1) {
             *codec_id = AV_CODEC_ID_HEVC;
             printf("[stsd] Found hvc1 format -> codec_id = HEVC\n");
             return 0;
         }
 
         entry_offset += entry_size;            /* offset depends on input data */
     }
     return -1;
 }
 
 /* ============================================================
  * Layers 1-4: Nested atom parsing
  * moov → trak → mdia → minf → stbl → stsd
  * Each layer searches for a specific child atom.
  * ============================================================ */
 static int find_child_atom(const uint8_t *buf, int parent_offset,
                            int parent_size, uint32_t target_tag,
                            int *child_offset, int *child_size) {
     int pos = parent_offset;
     while (pos + 8 <= parent_offset + parent_size) {
         uint32_t size, tag;
         int tmp = pos;
         if (read_atom_header(buf, parent_offset + parent_size, &tmp, &tag, &size) < 0)
             return -1;                    /* branch */
         if (tag == target_tag) {          /* branch: found target? */
             *child_offset = pos + 8;
             *child_size = size - 8;
             return 0;
         }
         pos += size;                      /* branch: next atom (offset data-dependent) */
     }
     return -1;
 }
 
 static int parse_moov(const uint8_t *buf, int offset, int size,
                       int *codec_id) {
     int trak_off, trak_size;
     /* Layer 2: moov → trak */
     if (find_child_atom(buf, offset, size, TAG_TRAK, &trak_off, &trak_size) < 0)
         return -1;
     printf("[moov] Found trak atom at offset %d\n", trak_off);
 
     int mdia_off, mdia_size;
     /* Layer 3: trak → mdia */
     if (find_child_atom(buf, trak_off, trak_size, TAG_MDIA, &mdia_off, &mdia_size) < 0)
         return -1;
     printf("[trak] Found mdia atom at offset %d\n", mdia_off);
 
     int minf_off, minf_size;
     /* Layer 4: mdia → minf */
     if (find_child_atom(buf, mdia_off, mdia_size, TAG_MINF, &minf_off, &minf_size) < 0)
         return -1;
     printf("[mdia] Found minf atom at offset %d\n", minf_off);
 
     int stbl_off, stbl_size;
     /* Layer 5: minf → stbl */
     if (find_child_atom(buf, minf_off, minf_size, TAG_STBL, &stbl_off, &stbl_size) < 0)
         return -1;
     printf("[minf] Found stbl atom at offset %d\n", stbl_off);
 
     int stsd_off, stsd_size;
     /* Layer 6: stbl → stsd */
     if (find_child_atom(buf, stbl_off, stbl_size, TAG_STSD, &stsd_off, &stsd_size) < 0)
         return -1;
     printf("[stbl] Found stsd atom at offset %d\n", stsd_off);
 
     return parse_stsd(buf, stsd_off, stsd_size, codec_id);
 }
 
 /* ============================================================
  * Top-level parser: Find ftyp and moov atoms
  * ============================================================ */
 static int parse_mp4(const uint8_t *buf, int buf_size, int *codec_id) {
     int pos = 0;
     int found_ftyp = 0, found_moov = 0;
 
     while (pos + 8 <= buf_size) {
         uint32_t size, tag;
         int tmp = pos;
         if (read_atom_header(buf, buf_size, &tmp, &tag, &size) < 0)
             break;                           /* branch */
 
         if (tag == TAG_FTYP) {               /* branch: Layer 0 */
             printf("[top] Found ftyp atom at offset %d (size=%u)\n", pos, size);
             found_ftyp = 1;
         } else if (tag == TAG_MOOV) {        /* branch: Layer 1 */
             printf("[top] Found moov atom at offset %d (size=%u)\n", pos, size);
             if (parse_moov(buf, pos + 8, size - 8, codec_id) == 0)
                 found_moov = 1;
         }
         pos += size;                         /* branch: offset is data-dependent */
     }
 
     if (!found_ftyp || !found_moov)
         return -1;
     return 0;
 }
 
 /* ============================================================
  * Target function: ff_rtp_send_h264_hevc (simplified)
  * This is the function PILOT aims to reach.
  * ============================================================ */
 static void ff_rtp_send_h264_hevc(const uint8_t *data, int size) {
     printf("=== TARGET REACHED: ff_rtp_send_h264_hevc() ===\n");
     printf("Processing H.264/HEVC RTP data of size %d\n", size);
 
     /* Simplified vulnerability: negative length calculation */
     if (size > 4) {
         const uint8_t *r = data;
         const uint8_t *end = data + size;
         int nal_length_size = 4;
 
         while (r < end) {
             r += nal_length_size;  /* Can overshoot end */
             int len = (int)(end - r);  /* Can be negative */
             if (len < 0) {
                 printf("!!! VULNERABILITY: negative length = %d !!!\n", len);
                 break;
             }
             r = end;
         }
     }
 }
 
 /* ============================================================
  * Main: rtp_write_packet equivalent
  * ============================================================ */
 int main(int argc, char *argv[]) {
     uint8_t input[INPUT_SIZE];
     int codec_id = AV_CODEC_ID_UNKNOWN;
 
 #ifdef KLEE
     /* --- KLEE mode: symbolic input --- */
     klee_make_symbolic(input, sizeof(input), "input");
 #else
     /* --- Native mode: read from file --- */
     if (argc < 2) {
         fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
         return 1;
     }
     FILE *f = fopen(argv[1], "rb");
     if (!f) {
         perror("fopen");
         return 1;
     }
     memset(input, 0, sizeof(input));
     fread(input, 1, sizeof(input), f);
     fclose(f);
 #endif
 
     printf("--- Parsing MP4 input (%d bytes) ---\n", INPUT_SIZE);
 
     if (parse_mp4(input, INPUT_SIZE, &codec_id) < 0) {
         printf("FAILED: Invalid MP4 structure\n");
         return 1;
     }
 
     /* The branch condition from rtpenc.c */
     if (codec_id == AV_CODEC_ID_H264 ||
         codec_id == AV_CODEC_ID_HEVC) {
         ff_rtp_send_h264_hevc(input + 100, 50);  /* simplified */
     } else {
         printf("FAILED: codec_id (%d) is not H264 or HEVC\n", codec_id);
     }
 
     return 0;
 }
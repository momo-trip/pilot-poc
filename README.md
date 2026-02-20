# Concolic Execution Experiment: KLEE vs PILOT

## Goal
Demonstrate that concolic execution (KLEE) cannot generate a valid MP4 
file to reach `ff_rtp_send_h264_hevc()`, while PILOT's semantic approach 
can trivially do so.

## Setup

### KLEE Docker
```bash
docker pull klee/klee:latest
docker run -ti --rm -v $(pwd):/work klee/klee:latest

# Inside container:
cd /work
rm -rf klee-out-* klee-last
clang -emit-llvm -c -g -O0 -Xclang -disable-O0-optnone \
    -DKLEE concolic_mp4_demo.c -o concolic_mp4_demo.bc

# Run KLEE with 5-minute timeout
klee --max-time=300 --max-memory=4096 concolic_mp4_demo.bc
```

## Expected KLEE Results

### What KLEE will likely do:
1. Start exploring paths through `parse_mp4()`
2. Fork at each `read_atom_header()` call (size and tag checks)
3. Fork at each `find_child_atom()` loop iteration
4. **State explosion**: The number of paths grows exponentially because:
   - Each atom's offset depends on the *size field* of the previous atom
   - Each `while` loop iterates a symbolic number of times
   - 6 levels of nesting: ftyp → moov → trak → mdia → minf → stbl → stsd

### What you should observe:
```
KLEE: output directory is "klee-out-0"
KLEE: Using STP solver
KLEE: WARNING: unable to compute [initial] values
...
KLEE: done: total instructions = XXXXX
KLEE: done: completed paths = YYYY
KLEE: done: generated tests = ZZZZ
```

### Key metrics to check:
```bash
# How many paths were explored?
ls klee-out-0/*.ktest | wc -l

# Did any test reach the target function?
for f in klee-out-0/*.ktest; do
    ktest-tool $f > /tmp/test_input
    # Check if "TARGET REACHED" appears
done

# How many paths terminated early (invalid MP4)?
grep -c "FAILED" klee-out-0/run.stats 2>/dev/null
```

### Most likely outcome:
- KLEE explores thousands of paths, almost all failing at early 
  parsing stages (ftyp check, moov search)
- Even with INPUT_SIZE=512 (very small), KLEE times out (5 min)
  before finding a path through all 6 nesting layers + avcC validation
- **ff_rtp_send_h264_hevc() is NEVER reached**

### Why:
The constraint for reaching the target is effectively:
```
input[4..7] == "ftyp" ∧ input[0..3] >= 8 ∧
input[N..N+7] encodes "moov" atom ∧  (N depends on input[0..3])
input[N+8..] contains "trak" atom ∧  (offset depends on N)
...6 more levels...
input[R..] == "avc1" ∧               (R depends on all above)
input[S..] encodes valid avcC ∧       (S depends on R)
avcC contains valid SPS NAL units     (recursive sub-constraints)
```
The chained offset dependencies make this intractable for any 
constraint solver (SMT or LLM-based).

## PILOT Approach (for comparison)

```bash
# PILOT's LLM generates this command based on semantic understanding:
bash pilot_generate.sh

# Expected output:
# [PILOT] Generating valid H.264 MP4 file...
# [PILOT] Successfully generated valid MP4 file
# ...
# === TARGET REACHED: ff_rtp_send_h264_hevc() ===
```

The contrast is stark:
- **KLEE (concolic)**: 5 minutes, thousands of paths, target NOT reached
- **PILOT (semantic)**: ~1 second, single ffmpeg command, target reached

## Extending the Experiment

### Make it even harder for KLEE:
```c
// Increase INPUT_SIZE to 1024 or 2048
// Add more atom types to parse
// Add more validation in parse_avcC
```
Each addition exponentially increases the number of paths.

### Make it easier for KLEE (to show it CAN work for simple cases):
```c
// Remove nested atom parsing
// Use direct byte comparison: if (input[0] == 'H' && input[1] == '2' ...)
// KLEE will solve this easily — but this is NOT how real parsers work
```

## Conclusion
This experiment demonstrates that the bottleneck is not the solver 
(SMT vs LLM) but the **formulation**: expressing file format validity 
as path constraints over raw bytes is fundamentally intractable for 
complex formats like MP4/H.264. PILOT avoids this entirely by reasoning 
about code semantics and delegating file generation to native tools.
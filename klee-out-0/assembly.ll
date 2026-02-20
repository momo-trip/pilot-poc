; ModuleID = 'concolic_mp4_demo.bc'
source_filename = "concolic_mp4_demo.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [6 x i8] c"input\00", align 1, !dbg !0
@target_reached = internal global i32 0, align 4, !dbg !7
@.str.1 = private unnamed_addr constant [22 x i8] c"0 && \22TARGET_REACHED\22\00", align 1, !dbg !21
@.str.2 = private unnamed_addr constant [20 x i8] c"concolic_mp4_demo.c\00", align 1, !dbg !26
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [23 x i8] c"int main(int, char **)\00", align 1, !dbg !31

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main(i32 noundef %argc, ptr noundef %argv) #0 !dbg !45 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca ptr, align 8
  %input = alloca [512 x i8], align 16
  %codec_id = alloca i32, align 4
  store i32 0, ptr %retval, align 4
  store i32 %argc, ptr %argc.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %argc.addr, metadata !51, metadata !DIExpression()), !dbg !52
  store ptr %argv, ptr %argv.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %argv.addr, metadata !53, metadata !DIExpression()), !dbg !54
  call void @llvm.dbg.declare(metadata ptr %input, metadata !55, metadata !DIExpression()), !dbg !62
  call void @llvm.dbg.declare(metadata ptr %codec_id, metadata !63, metadata !DIExpression()), !dbg !64
  store i32 0, ptr %codec_id, align 4, !dbg !64
  %arraydecay = getelementptr inbounds [512 x i8], ptr %input, i64 0, i64 0, !dbg !65
  call void @klee_make_symbolic(ptr noundef %arraydecay, i64 noundef 512, ptr noundef @.str), !dbg !66
  %arraydecay1 = getelementptr inbounds [512 x i8], ptr %input, i64 0, i64 0, !dbg !67
  %call = call i32 @parse_mp4(ptr noundef %arraydecay1, i32 noundef 512, ptr noundef %codec_id), !dbg !69
  %cmp = icmp slt i32 %call, 0, !dbg !70
  br i1 %cmp, label %if.then, label %if.end, !dbg !71

if.then:                                          ; preds = %entry
  store i32 1, ptr %retval, align 4, !dbg !72
  br label %return, !dbg !72

if.end:                                           ; preds = %entry
  %0 = load i32, ptr %codec_id, align 4, !dbg !74
  %cmp2 = icmp eq i32 %0, 27, !dbg !76
  %1 = load i32, ptr %codec_id, align 4
  %cmp3 = icmp eq i32 %1, 173
  %or.cond = select i1 %cmp2, i1 true, i1 %cmp3, !dbg !77
  br i1 %or.cond, label %if.then4, label %if.else, !dbg !77

if.then4:                                         ; preds = %if.end
  %arraydecay5 = getelementptr inbounds [512 x i8], ptr %input, i64 0, i64 0, !dbg !78
  %add.ptr = getelementptr inbounds i8, ptr %arraydecay5, i64 100, !dbg !80
  call void @ff_rtp_send_h264_hevc(ptr noundef %add.ptr, i32 noundef 50), !dbg !81
  %2 = load i32, ptr @target_reached, align 4, !dbg !82
  %tobool = icmp ne i32 %2, 0, !dbg !82
  br i1 %tobool, label %if.then7, label %if.end8, !dbg !84

if.else:                                          ; preds = %if.end
  store i32 1, ptr %retval, align 4, !dbg !85
  br label %return, !dbg !85

if.then7:                                         ; preds = %if.then4
  call void @__assert_fail(ptr noundef @.str.1, ptr noundef @.str.2, i32 noundef 324, ptr noundef @__PRETTY_FUNCTION__.main) #4, !dbg !87
  unreachable, !dbg !87

if.end8:                                          ; preds = %if.then4
  store i32 0, ptr %retval, align 4, !dbg !91
  br label %return, !dbg !91

return:                                           ; preds = %if.end8, %if.else, %if.then
  %3 = load i32, ptr %retval, align 4, !dbg !92
  ret i32 %3, !dbg !92
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @klee_make_symbolic(ptr noundef, i64 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal i32 @parse_mp4(ptr noundef %buf, i32 noundef %buf_size, ptr noundef %codec_id) #0 !dbg !93 {
entry:
  %retval = alloca i32, align 4
  %buf.addr = alloca ptr, align 8
  %buf_size.addr = alloca i32, align 4
  %codec_id.addr = alloca ptr, align 8
  %pos = alloca i32, align 4
  %found_ftyp = alloca i32, align 4
  %found_moov = alloca i32, align 4
  %size = alloca i32, align 4
  %tag = alloca i32, align 4
  store ptr %buf, ptr %buf.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %buf.addr, metadata !99, metadata !DIExpression()), !dbg !100
  store i32 %buf_size, ptr %buf_size.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %buf_size.addr, metadata !101, metadata !DIExpression()), !dbg !102
  store ptr %codec_id, ptr %codec_id.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %codec_id.addr, metadata !103, metadata !DIExpression()), !dbg !104
  call void @llvm.dbg.declare(metadata ptr %pos, metadata !105, metadata !DIExpression()), !dbg !106
  store i32 0, ptr %pos, align 4, !dbg !106
  call void @llvm.dbg.declare(metadata ptr %found_ftyp, metadata !107, metadata !DIExpression()), !dbg !108
  store i32 0, ptr %found_ftyp, align 4, !dbg !108
  call void @llvm.dbg.declare(metadata ptr %found_moov, metadata !109, metadata !DIExpression()), !dbg !110
  store i32 0, ptr %found_moov, align 4, !dbg !110
  br label %while.cond, !dbg !111

while.cond:                                       ; preds = %if.end12, %entry
  %0 = load i32, ptr %pos, align 4, !dbg !112
  %add = add nsw i32 %0, 8, !dbg !113
  %1 = load i32, ptr %buf_size.addr, align 4, !dbg !114
  %cmp = icmp sle i32 %add, %1, !dbg !115
  br i1 %cmp, label %while.body, label %while.end, !dbg !111

while.body:                                       ; preds = %while.cond
  call void @llvm.dbg.declare(metadata ptr %size, metadata !116, metadata !DIExpression()), !dbg !118
  call void @llvm.dbg.declare(metadata ptr %tag, metadata !119, metadata !DIExpression()), !dbg !120
  %2 = load ptr, ptr %buf.addr, align 8, !dbg !121
  %3 = load i32, ptr %buf_size.addr, align 4, !dbg !123
  %4 = load i32, ptr %pos, align 4, !dbg !124
  %call = call i32 @read_atom_header(ptr noundef %2, i32 noundef %3, i32 noundef %4, ptr noundef %tag, ptr noundef %size), !dbg !125
  %cmp1 = icmp slt i32 %call, 0, !dbg !126
  br i1 %cmp1, label %while.end, label %if.end, !dbg !127

if.end:                                           ; preds = %while.body
  %5 = load i32, ptr %tag, align 4, !dbg !128
  %cmp2 = icmp eq i32 %5, 1887007846, !dbg !130
  br i1 %cmp2, label %if.then3, label %if.else, !dbg !131

if.then3:                                         ; preds = %if.end
  store i32 1, ptr %found_ftyp, align 4, !dbg !132
  br label %if.end12, !dbg !134

if.else:                                          ; preds = %if.end
  %6 = load i32, ptr %tag, align 4, !dbg !135
  %cmp4 = icmp eq i32 %6, 1987014509, !dbg !137
  br i1 %cmp4, label %if.then5, label %if.end12, !dbg !138

if.then5:                                         ; preds = %if.else
  %7 = load ptr, ptr %buf.addr, align 8, !dbg !139
  %8 = load i32, ptr %buf_size.addr, align 4, !dbg !142
  %9 = load i32, ptr %pos, align 4, !dbg !143
  %add6 = add nsw i32 %9, 8, !dbg !144
  %10 = load i32, ptr %size, align 4, !dbg !145
  %sub = sub i32 %10, 8, !dbg !146
  %11 = load ptr, ptr %codec_id.addr, align 8, !dbg !147
  %call7 = call i32 @parse_moov(ptr noundef %7, i32 noundef %8, i32 noundef %add6, i32 noundef %sub, ptr noundef %11), !dbg !148
  %cmp8 = icmp eq i32 %call7, 0, !dbg !149
  br i1 %cmp8, label %if.then9, label %if.end12, !dbg !150

if.then9:                                         ; preds = %if.then5
  store i32 1, ptr %found_moov, align 4, !dbg !151
  br label %if.end12, !dbg !152

if.end12:                                         ; preds = %if.else, %if.then9, %if.then5, %if.then3
  %12 = load i32, ptr %size, align 4, !dbg !153
  %13 = load i32, ptr %pos, align 4, !dbg !154
  %add13 = add i32 %13, %12, !dbg !154
  store i32 %add13, ptr %pos, align 4, !dbg !154
  br label %while.cond, !dbg !111, !llvm.loop !155

while.end:                                        ; preds = %while.body, %while.cond
  %14 = load i32, ptr %found_ftyp, align 4, !dbg !158
  %tobool = icmp ne i32 %14, 0, !dbg !158
  %15 = load i32, ptr %found_moov, align 4
  %tobool14 = icmp ne i32 %15, 0
  %or.cond = select i1 %tobool, i1 %tobool14, i1 false, !dbg !160
  br i1 %or.cond, label %if.end16, label %if.then15, !dbg !160

if.then15:                                        ; preds = %while.end
  store i32 -1, ptr %retval, align 4, !dbg !161
  br label %return, !dbg !161

if.end16:                                         ; preds = %while.end
  store i32 0, ptr %retval, align 4, !dbg !162
  br label %return, !dbg !162

return:                                           ; preds = %if.end16, %if.then15
  %16 = load i32, ptr %retval, align 4, !dbg !163
  ret i32 %16, !dbg !163
}

; Function Attrs: noinline nounwind uwtable
define internal void @ff_rtp_send_h264_hevc(ptr noundef %data, i32 noundef %size) #0 !dbg !164 {
entry:
  %data.addr = alloca ptr, align 8
  %size.addr = alloca i32, align 4
  store ptr %data, ptr %data.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %data.addr, metadata !167, metadata !DIExpression()), !dbg !168
  store i32 %size, ptr %size.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %size.addr, metadata !169, metadata !DIExpression()), !dbg !170
  store i32 1, ptr @target_reached, align 4, !dbg !171
  ret void, !dbg !172
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i32 @read_atom_header(ptr noundef %buf, i32 noundef %buf_size, i32 noundef %pos, ptr noundef %tag, ptr noundef %size) #0 !dbg !173 {
entry:
  %retval = alloca i32, align 4
  %buf.addr = alloca ptr, align 8
  %buf_size.addr = alloca i32, align 4
  %pos.addr = alloca i32, align 4
  %tag.addr = alloca ptr, align 8
  %size.addr = alloca ptr, align 8
  store ptr %buf, ptr %buf.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %buf.addr, metadata !177, metadata !DIExpression()), !dbg !178
  store i32 %buf_size, ptr %buf_size.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %buf_size.addr, metadata !179, metadata !DIExpression()), !dbg !180
  store i32 %pos, ptr %pos.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %pos.addr, metadata !181, metadata !DIExpression()), !dbg !182
  store ptr %tag, ptr %tag.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %tag.addr, metadata !183, metadata !DIExpression()), !dbg !184
  store ptr %size, ptr %size.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %size.addr, metadata !185, metadata !DIExpression()), !dbg !186
  %0 = load i32, ptr %pos.addr, align 4, !dbg !187
  %cmp = icmp slt i32 %0, 0, !dbg !189
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !190

lor.lhs.false:                                    ; preds = %entry
  %1 = load i32, ptr %pos.addr, align 4, !dbg !191
  %add = add nsw i32 %1, 8, !dbg !192
  %2 = load i32, ptr %buf_size.addr, align 4, !dbg !193
  %cmp1 = icmp sgt i32 %add, %2, !dbg !194
  br i1 %cmp1, label %if.then, label %if.end, !dbg !195

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 -1, ptr %retval, align 4, !dbg !196
  br label %return, !dbg !196

if.end:                                           ; preds = %lor.lhs.false
  %3 = load ptr, ptr %buf.addr, align 8, !dbg !197
  %4 = load i32, ptr %pos.addr, align 4, !dbg !198
  %5 = load i32, ptr %buf_size.addr, align 4, !dbg !199
  %call = call i32 @read_be32(ptr noundef %3, i32 noundef %4, i32 noundef %5), !dbg !200
  %6 = load ptr, ptr %size.addr, align 8, !dbg !201
  store i32 %call, ptr %6, align 4, !dbg !202
  %7 = load ptr, ptr %buf.addr, align 8, !dbg !203
  %8 = load i32, ptr %pos.addr, align 4, !dbg !204
  %add2 = add nsw i32 %8, 4, !dbg !205
  %9 = load i32, ptr %buf_size.addr, align 4, !dbg !206
  %call3 = call i32 @read_tag(ptr noundef %7, i32 noundef %add2, i32 noundef %9), !dbg !207
  %10 = load ptr, ptr %tag.addr, align 8, !dbg !208
  store i32 %call3, ptr %10, align 4, !dbg !209
  %11 = load ptr, ptr %size.addr, align 8, !dbg !210
  %12 = load i32, ptr %11, align 4, !dbg !212
  %cmp4 = icmp ult i32 %12, 8, !dbg !213
  br i1 %cmp4, label %if.then8, label %lor.lhs.false5, !dbg !214

lor.lhs.false5:                                   ; preds = %if.end
  %13 = load i32, ptr %pos.addr, align 4, !dbg !215
  %14 = load ptr, ptr %size.addr, align 8, !dbg !216
  %15 = load i32, ptr %14, align 4, !dbg !217
  %add6 = add nsw i32 %13, %15, !dbg !218
  %16 = load i32, ptr %buf_size.addr, align 4, !dbg !219
  %cmp7 = icmp sgt i32 %add6, %16, !dbg !220
  br i1 %cmp7, label %if.then8, label %if.end9, !dbg !221

if.then8:                                         ; preds = %lor.lhs.false5, %if.end
  store i32 -1, ptr %retval, align 4, !dbg !222
  br label %return, !dbg !222

if.end9:                                          ; preds = %lor.lhs.false5
  store i32 0, ptr %retval, align 4, !dbg !223
  br label %return, !dbg !223

return:                                           ; preds = %if.end9, %if.then8, %if.then
  %17 = load i32, ptr %retval, align 4, !dbg !224
  ret i32 %17, !dbg !224
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @parse_moov(ptr noundef %buf, i32 noundef %buf_size, i32 noundef %offset, i32 noundef %size, ptr noundef %codec_id) #0 !dbg !225 {
entry:
  %retval = alloca i32, align 4
  %buf.addr = alloca ptr, align 8
  %buf_size.addr = alloca i32, align 4
  %offset.addr = alloca i32, align 4
  %size.addr = alloca i32, align 4
  %codec_id.addr = alloca ptr, align 8
  %off = alloca i32, align 4
  %sz = alloca i32, align 4
  %mdia_off = alloca i32, align 4
  %mdia_sz = alloca i32, align 4
  %minf_off = alloca i32, align 4
  %minf_sz = alloca i32, align 4
  %stbl_off = alloca i32, align 4
  %stbl_sz = alloca i32, align 4
  %stsd_off = alloca i32, align 4
  %stsd_sz = alloca i32, align 4
  store ptr %buf, ptr %buf.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %buf.addr, metadata !228, metadata !DIExpression()), !dbg !229
  store i32 %buf_size, ptr %buf_size.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %buf_size.addr, metadata !230, metadata !DIExpression()), !dbg !231
  store i32 %offset, ptr %offset.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %offset.addr, metadata !232, metadata !DIExpression()), !dbg !233
  store i32 %size, ptr %size.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %size.addr, metadata !234, metadata !DIExpression()), !dbg !235
  store ptr %codec_id, ptr %codec_id.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %codec_id.addr, metadata !236, metadata !DIExpression()), !dbg !237
  call void @llvm.dbg.declare(metadata ptr %off, metadata !238, metadata !DIExpression()), !dbg !239
  call void @llvm.dbg.declare(metadata ptr %sz, metadata !240, metadata !DIExpression()), !dbg !241
  %0 = load ptr, ptr %buf.addr, align 8, !dbg !242
  %1 = load i32, ptr %buf_size.addr, align 4, !dbg !244
  %2 = load i32, ptr %offset.addr, align 4, !dbg !245
  %3 = load i32, ptr %size.addr, align 4, !dbg !246
  %call = call i32 @find_child_atom(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef 1801548404, ptr noundef %off, ptr noundef %sz), !dbg !247
  %cmp = icmp slt i32 %call, 0, !dbg !248
  br i1 %cmp, label %if.then, label %if.end, !dbg !249

if.then:                                          ; preds = %entry
  store i32 -1, ptr %retval, align 4, !dbg !250
  br label %return, !dbg !250

if.end:                                           ; preds = %entry
  call void @llvm.dbg.declare(metadata ptr %mdia_off, metadata !251, metadata !DIExpression()), !dbg !252
  call void @llvm.dbg.declare(metadata ptr %mdia_sz, metadata !253, metadata !DIExpression()), !dbg !254
  %4 = load ptr, ptr %buf.addr, align 8, !dbg !255
  %5 = load i32, ptr %buf_size.addr, align 4, !dbg !257
  %6 = load i32, ptr %off, align 4, !dbg !258
  %7 = load i32, ptr %sz, align 4, !dbg !259
  %call1 = call i32 @find_child_atom(ptr noundef %4, i32 noundef %5, i32 noundef %6, i32 noundef %7, i32 noundef 1634296941, ptr noundef %mdia_off, ptr noundef %mdia_sz), !dbg !260
  %cmp2 = icmp slt i32 %call1, 0, !dbg !261
  br i1 %cmp2, label %if.then3, label %if.end4, !dbg !262

if.then3:                                         ; preds = %if.end
  store i32 -1, ptr %retval, align 4, !dbg !263
  br label %return, !dbg !263

if.end4:                                          ; preds = %if.end
  call void @llvm.dbg.declare(metadata ptr %minf_off, metadata !264, metadata !DIExpression()), !dbg !265
  call void @llvm.dbg.declare(metadata ptr %minf_sz, metadata !266, metadata !DIExpression()), !dbg !267
  %8 = load ptr, ptr %buf.addr, align 8, !dbg !268
  %9 = load i32, ptr %buf_size.addr, align 4, !dbg !270
  %10 = load i32, ptr %mdia_off, align 4, !dbg !271
  %11 = load i32, ptr %mdia_sz, align 4, !dbg !272
  %call5 = call i32 @find_child_atom(ptr noundef %8, i32 noundef %9, i32 noundef %10, i32 noundef %11, i32 noundef 1718511981, ptr noundef %minf_off, ptr noundef %minf_sz), !dbg !273
  %cmp6 = icmp slt i32 %call5, 0, !dbg !274
  br i1 %cmp6, label %if.then7, label %if.end8, !dbg !275

if.then7:                                         ; preds = %if.end4
  store i32 -1, ptr %retval, align 4, !dbg !276
  br label %return, !dbg !276

if.end8:                                          ; preds = %if.end4
  call void @llvm.dbg.declare(metadata ptr %stbl_off, metadata !277, metadata !DIExpression()), !dbg !278
  call void @llvm.dbg.declare(metadata ptr %stbl_sz, metadata !279, metadata !DIExpression()), !dbg !280
  %12 = load ptr, ptr %buf.addr, align 8, !dbg !281
  %13 = load i32, ptr %buf_size.addr, align 4, !dbg !283
  %14 = load i32, ptr %minf_off, align 4, !dbg !284
  %15 = load i32, ptr %minf_sz, align 4, !dbg !285
  %call9 = call i32 @find_child_atom(ptr noundef %12, i32 noundef %13, i32 noundef %14, i32 noundef %15, i32 noundef 1818391667, ptr noundef %stbl_off, ptr noundef %stbl_sz), !dbg !286
  %cmp10 = icmp slt i32 %call9, 0, !dbg !287
  br i1 %cmp10, label %if.then11, label %if.end12, !dbg !288

if.then11:                                        ; preds = %if.end8
  store i32 -1, ptr %retval, align 4, !dbg !289
  br label %return, !dbg !289

if.end12:                                         ; preds = %if.end8
  call void @llvm.dbg.declare(metadata ptr %stsd_off, metadata !290, metadata !DIExpression()), !dbg !291
  call void @llvm.dbg.declare(metadata ptr %stsd_sz, metadata !292, metadata !DIExpression()), !dbg !293
  %16 = load ptr, ptr %buf.addr, align 8, !dbg !294
  %17 = load i32, ptr %buf_size.addr, align 4, !dbg !296
  %18 = load i32, ptr %stbl_off, align 4, !dbg !297
  %19 = load i32, ptr %stbl_sz, align 4, !dbg !298
  %call13 = call i32 @find_child_atom(ptr noundef %16, i32 noundef %17, i32 noundef %18, i32 noundef %19, i32 noundef 1685288051, ptr noundef %stsd_off, ptr noundef %stsd_sz), !dbg !299
  %cmp14 = icmp slt i32 %call13, 0, !dbg !300
  br i1 %cmp14, label %if.then15, label %if.end16, !dbg !301

if.then15:                                        ; preds = %if.end12
  store i32 -1, ptr %retval, align 4, !dbg !302
  br label %return, !dbg !302

if.end16:                                         ; preds = %if.end12
  %20 = load ptr, ptr %buf.addr, align 8, !dbg !303
  %21 = load i32, ptr %buf_size.addr, align 4, !dbg !304
  %22 = load i32, ptr %stsd_off, align 4, !dbg !305
  %23 = load i32, ptr %stsd_sz, align 4, !dbg !306
  %24 = load ptr, ptr %codec_id.addr, align 8, !dbg !307
  %call17 = call i32 @parse_stsd(ptr noundef %20, i32 noundef %21, i32 noundef %22, i32 noundef %23, ptr noundef %24), !dbg !308
  store i32 %call17, ptr %retval, align 4, !dbg !309
  br label %return, !dbg !309

return:                                           ; preds = %if.end16, %if.then15, %if.then11, %if.then7, %if.then3, %if.then
  %25 = load i32, ptr %retval, align 4, !dbg !310
  ret i32 %25, !dbg !310
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @read_be32(ptr noundef %buf, i32 noundef %offset, i32 noundef %buf_size) #0 !dbg !311 {
entry:
  %retval = alloca i32, align 4
  %buf.addr = alloca ptr, align 8
  %offset.addr = alloca i32, align 4
  %buf_size.addr = alloca i32, align 4
  store ptr %buf, ptr %buf.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %buf.addr, metadata !314, metadata !DIExpression()), !dbg !315
  store i32 %offset, ptr %offset.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %offset.addr, metadata !316, metadata !DIExpression()), !dbg !317
  store i32 %buf_size, ptr %buf_size.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %buf_size.addr, metadata !318, metadata !DIExpression()), !dbg !319
  %0 = load i32, ptr %offset.addr, align 4, !dbg !320
  %cmp = icmp slt i32 %0, 0, !dbg !322
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !323

lor.lhs.false:                                    ; preds = %entry
  %1 = load i32, ptr %offset.addr, align 4, !dbg !324
  %add = add nsw i32 %1, 4, !dbg !325
  %2 = load i32, ptr %buf_size.addr, align 4, !dbg !326
  %cmp1 = icmp sgt i32 %add, %2, !dbg !327
  br i1 %cmp1, label %if.then, label %if.end, !dbg !328

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 0, ptr %retval, align 4, !dbg !329
  br label %return, !dbg !329

if.end:                                           ; preds = %lor.lhs.false
  %3 = load ptr, ptr %buf.addr, align 8, !dbg !330
  %4 = load i32, ptr %offset.addr, align 4, !dbg !331
  %idxprom = sext i32 %4 to i64, !dbg !330
  %arrayidx = getelementptr inbounds i8, ptr %3, i64 %idxprom, !dbg !330
  %5 = load i8, ptr %arrayidx, align 1, !dbg !330
  %conv = zext i8 %5 to i32, !dbg !332
  %shl = shl i32 %conv, 24, !dbg !333
  %6 = load ptr, ptr %buf.addr, align 8, !dbg !334
  %7 = load i32, ptr %offset.addr, align 4, !dbg !335
  %add2 = add nsw i32 %7, 1, !dbg !336
  %idxprom3 = sext i32 %add2 to i64, !dbg !334
  %arrayidx4 = getelementptr inbounds i8, ptr %6, i64 %idxprom3, !dbg !334
  %8 = load i8, ptr %arrayidx4, align 1, !dbg !334
  %conv5 = zext i8 %8 to i32, !dbg !337
  %shl6 = shl i32 %conv5, 16, !dbg !338
  %or = or i32 %shl, %shl6, !dbg !339
  %9 = load ptr, ptr %buf.addr, align 8, !dbg !340
  %10 = load i32, ptr %offset.addr, align 4, !dbg !341
  %add7 = add nsw i32 %10, 2, !dbg !342
  %idxprom8 = sext i32 %add7 to i64, !dbg !340
  %arrayidx9 = getelementptr inbounds i8, ptr %9, i64 %idxprom8, !dbg !340
  %11 = load i8, ptr %arrayidx9, align 1, !dbg !340
  %conv10 = zext i8 %11 to i32, !dbg !343
  %shl11 = shl i32 %conv10, 8, !dbg !344
  %or12 = or i32 %or, %shl11, !dbg !345
  %12 = load ptr, ptr %buf.addr, align 8, !dbg !346
  %13 = load i32, ptr %offset.addr, align 4, !dbg !347
  %add13 = add nsw i32 %13, 3, !dbg !348
  %idxprom14 = sext i32 %add13 to i64, !dbg !346
  %arrayidx15 = getelementptr inbounds i8, ptr %12, i64 %idxprom14, !dbg !346
  %14 = load i8, ptr %arrayidx15, align 1, !dbg !346
  %conv16 = zext i8 %14 to i32, !dbg !349
  %or17 = or i32 %or12, %conv16, !dbg !350
  store i32 %or17, ptr %retval, align 4, !dbg !351
  br label %return, !dbg !351

return:                                           ; preds = %if.end, %if.then
  %15 = load i32, ptr %retval, align 4, !dbg !352
  ret i32 %15, !dbg !352
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @read_tag(ptr noundef %buf, i32 noundef %offset, i32 noundef %buf_size) #0 !dbg !353 {
entry:
  %retval = alloca i32, align 4
  %buf.addr = alloca ptr, align 8
  %offset.addr = alloca i32, align 4
  %buf_size.addr = alloca i32, align 4
  store ptr %buf, ptr %buf.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %buf.addr, metadata !354, metadata !DIExpression()), !dbg !355
  store i32 %offset, ptr %offset.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %offset.addr, metadata !356, metadata !DIExpression()), !dbg !357
  store i32 %buf_size, ptr %buf_size.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %buf_size.addr, metadata !358, metadata !DIExpression()), !dbg !359
  %0 = load i32, ptr %offset.addr, align 4, !dbg !360
  %cmp = icmp slt i32 %0, 0, !dbg !362
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !363

lor.lhs.false:                                    ; preds = %entry
  %1 = load i32, ptr %offset.addr, align 4, !dbg !364
  %add = add nsw i32 %1, 4, !dbg !365
  %2 = load i32, ptr %buf_size.addr, align 4, !dbg !366
  %cmp1 = icmp sgt i32 %add, %2, !dbg !367
  br i1 %cmp1, label %if.then, label %if.end, !dbg !368

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 0, ptr %retval, align 4, !dbg !369
  br label %return, !dbg !369

if.end:                                           ; preds = %lor.lhs.false
  %3 = load ptr, ptr %buf.addr, align 8, !dbg !370
  %4 = load i32, ptr %offset.addr, align 4, !dbg !371
  %idxprom = sext i32 %4 to i64, !dbg !370
  %arrayidx = getelementptr inbounds i8, ptr %3, i64 %idxprom, !dbg !370
  %5 = load i8, ptr %arrayidx, align 1, !dbg !370
  %conv = zext i8 %5 to i32, !dbg !372
  %6 = load ptr, ptr %buf.addr, align 8, !dbg !373
  %7 = load i32, ptr %offset.addr, align 4, !dbg !374
  %add2 = add nsw i32 %7, 1, !dbg !375
  %idxprom3 = sext i32 %add2 to i64, !dbg !373
  %arrayidx4 = getelementptr inbounds i8, ptr %6, i64 %idxprom3, !dbg !373
  %8 = load i8, ptr %arrayidx4, align 1, !dbg !373
  %conv5 = zext i8 %8 to i32, !dbg !376
  %shl = shl i32 %conv5, 8, !dbg !377
  %or = or i32 %conv, %shl, !dbg !378
  %9 = load ptr, ptr %buf.addr, align 8, !dbg !379
  %10 = load i32, ptr %offset.addr, align 4, !dbg !380
  %add6 = add nsw i32 %10, 2, !dbg !381
  %idxprom7 = sext i32 %add6 to i64, !dbg !379
  %arrayidx8 = getelementptr inbounds i8, ptr %9, i64 %idxprom7, !dbg !379
  %11 = load i8, ptr %arrayidx8, align 1, !dbg !379
  %conv9 = zext i8 %11 to i32, !dbg !382
  %shl10 = shl i32 %conv9, 16, !dbg !383
  %or11 = or i32 %or, %shl10, !dbg !384
  %12 = load ptr, ptr %buf.addr, align 8, !dbg !385
  %13 = load i32, ptr %offset.addr, align 4, !dbg !386
  %add12 = add nsw i32 %13, 3, !dbg !387
  %idxprom13 = sext i32 %add12 to i64, !dbg !385
  %arrayidx14 = getelementptr inbounds i8, ptr %12, i64 %idxprom13, !dbg !385
  %14 = load i8, ptr %arrayidx14, align 1, !dbg !385
  %conv15 = zext i8 %14 to i32, !dbg !388
  %shl16 = shl i32 %conv15, 24, !dbg !389
  %or17 = or i32 %or11, %shl16, !dbg !390
  store i32 %or17, ptr %retval, align 4, !dbg !391
  br label %return, !dbg !391

return:                                           ; preds = %if.end, %if.then
  %15 = load i32, ptr %retval, align 4, !dbg !392
  ret i32 %15, !dbg !392
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @find_child_atom(ptr noundef %buf, i32 noundef %buf_size, i32 noundef %parent_offset, i32 noundef %parent_size, i32 noundef %target_tag, ptr noundef %child_offset, ptr noundef %child_size) #0 !dbg !393 {
entry:
  %retval = alloca i32, align 4
  %buf.addr = alloca ptr, align 8
  %buf_size.addr = alloca i32, align 4
  %parent_offset.addr = alloca i32, align 4
  %parent_size.addr = alloca i32, align 4
  %target_tag.addr = alloca i32, align 4
  %child_offset.addr = alloca ptr, align 8
  %child_size.addr = alloca ptr, align 8
  %pos = alloca i32, align 4
  %end = alloca i32, align 4
  %size = alloca i32, align 4
  %tag = alloca i32, align 4
  store ptr %buf, ptr %buf.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %buf.addr, metadata !396, metadata !DIExpression()), !dbg !397
  store i32 %buf_size, ptr %buf_size.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %buf_size.addr, metadata !398, metadata !DIExpression()), !dbg !399
  store i32 %parent_offset, ptr %parent_offset.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %parent_offset.addr, metadata !400, metadata !DIExpression()), !dbg !401
  store i32 %parent_size, ptr %parent_size.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %parent_size.addr, metadata !402, metadata !DIExpression()), !dbg !403
  store i32 %target_tag, ptr %target_tag.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %target_tag.addr, metadata !404, metadata !DIExpression()), !dbg !405
  store ptr %child_offset, ptr %child_offset.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %child_offset.addr, metadata !406, metadata !DIExpression()), !dbg !407
  store ptr %child_size, ptr %child_size.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %child_size.addr, metadata !408, metadata !DIExpression()), !dbg !409
  %0 = load i32, ptr %parent_offset.addr, align 4, !dbg !410
  %cmp = icmp slt i32 %0, 0, !dbg !412
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !413

lor.lhs.false:                                    ; preds = %entry
  %1 = load i32, ptr %parent_offset.addr, align 4, !dbg !414
  %2 = load i32, ptr %parent_size.addr, align 4, !dbg !415
  %add = add nsw i32 %1, %2, !dbg !416
  %3 = load i32, ptr %buf_size.addr, align 4, !dbg !417
  %cmp1 = icmp sgt i32 %add, %3, !dbg !418
  br i1 %cmp1, label %if.then, label %if.end, !dbg !419

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 -1, ptr %retval, align 4, !dbg !420
  br label %return, !dbg !420

if.end:                                           ; preds = %lor.lhs.false
  call void @llvm.dbg.declare(metadata ptr %pos, metadata !421, metadata !DIExpression()), !dbg !422
  %4 = load i32, ptr %parent_offset.addr, align 4, !dbg !423
  store i32 %4, ptr %pos, align 4, !dbg !422
  call void @llvm.dbg.declare(metadata ptr %end, metadata !424, metadata !DIExpression()), !dbg !425
  %5 = load i32, ptr %parent_offset.addr, align 4, !dbg !426
  %6 = load i32, ptr %parent_size.addr, align 4, !dbg !427
  %add2 = add nsw i32 %5, %6, !dbg !428
  store i32 %add2, ptr %end, align 4, !dbg !425
  br label %while.cond, !dbg !429

while.cond:                                       ; preds = %if.end11, %if.end
  %7 = load i32, ptr %pos, align 4, !dbg !430
  %add3 = add nsw i32 %7, 8, !dbg !431
  %8 = load i32, ptr %end, align 4, !dbg !432
  %cmp4 = icmp sle i32 %add3, %8, !dbg !433
  br i1 %cmp4, label %while.body, label %while.end, !dbg !429

while.body:                                       ; preds = %while.cond
  call void @llvm.dbg.declare(metadata ptr %size, metadata !434, metadata !DIExpression()), !dbg !436
  call void @llvm.dbg.declare(metadata ptr %tag, metadata !437, metadata !DIExpression()), !dbg !438
  %9 = load ptr, ptr %buf.addr, align 8, !dbg !439
  %10 = load i32, ptr %buf_size.addr, align 4, !dbg !441
  %11 = load i32, ptr %pos, align 4, !dbg !442
  %call = call i32 @read_atom_header(ptr noundef %9, i32 noundef %10, i32 noundef %11, ptr noundef %tag, ptr noundef %size), !dbg !443
  %cmp5 = icmp slt i32 %call, 0, !dbg !444
  br i1 %cmp5, label %if.then6, label %if.end7, !dbg !445

if.then6:                                         ; preds = %while.body
  store i32 -1, ptr %retval, align 4, !dbg !446
  br label %return, !dbg !446

if.end7:                                          ; preds = %while.body
  %12 = load i32, ptr %tag, align 4, !dbg !447
  %13 = load i32, ptr %target_tag.addr, align 4, !dbg !449
  %cmp8 = icmp eq i32 %12, %13, !dbg !450
  br i1 %cmp8, label %if.then9, label %if.end11, !dbg !451

if.then9:                                         ; preds = %if.end7
  %14 = load i32, ptr %pos, align 4, !dbg !452
  %add10 = add nsw i32 %14, 8, !dbg !454
  %15 = load ptr, ptr %child_offset.addr, align 8, !dbg !455
  store i32 %add10, ptr %15, align 4, !dbg !456
  %16 = load i32, ptr %size, align 4, !dbg !457
  %sub = sub i32 %16, 8, !dbg !458
  %17 = load ptr, ptr %child_size.addr, align 8, !dbg !459
  store i32 %sub, ptr %17, align 4, !dbg !460
  store i32 0, ptr %retval, align 4, !dbg !461
  br label %return, !dbg !461

if.end11:                                         ; preds = %if.end7
  %18 = load i32, ptr %size, align 4, !dbg !462
  %19 = load i32, ptr %pos, align 4, !dbg !463
  %add12 = add i32 %19, %18, !dbg !463
  store i32 %add12, ptr %pos, align 4, !dbg !463
  br label %while.cond, !dbg !429, !llvm.loop !464

while.end:                                        ; preds = %while.cond
  store i32 -1, ptr %retval, align 4, !dbg !466
  br label %return, !dbg !466

return:                                           ; preds = %while.end, %if.then9, %if.then6, %if.then
  %20 = load i32, ptr %retval, align 4, !dbg !467
  ret i32 %20, !dbg !467
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @parse_stsd(ptr noundef %buf, i32 noundef %buf_size, i32 noundef %offset, i32 noundef %size, ptr noundef %codec_id) #0 !dbg !468 {
entry:
  %retval = alloca i32, align 4
  %buf.addr = alloca ptr, align 8
  %buf_size.addr = alloca i32, align 4
  %offset.addr = alloca i32, align 4
  %size.addr = alloca i32, align 4
  %codec_id.addr = alloca ptr, align 8
  %entry_count = alloca i32, align 4
  %entry_offset = alloca i32, align 4
  %i = alloca i32, align 4
  %entry_size = alloca i32, align 4
  %format = alloca i32, align 4
  %sub_offset = alloca i32, align 4
  %sub_size = alloca i32, align 4
  %sub_tag = alloca i32, align 4
  store ptr %buf, ptr %buf.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %buf.addr, metadata !469, metadata !DIExpression()), !dbg !470
  store i32 %buf_size, ptr %buf_size.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %buf_size.addr, metadata !471, metadata !DIExpression()), !dbg !472
  store i32 %offset, ptr %offset.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %offset.addr, metadata !473, metadata !DIExpression()), !dbg !474
  store i32 %size, ptr %size.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %size.addr, metadata !475, metadata !DIExpression()), !dbg !476
  store ptr %codec_id, ptr %codec_id.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %codec_id.addr, metadata !477, metadata !DIExpression()), !dbg !478
  %0 = load i32, ptr %size.addr, align 4, !dbg !479
  %cmp = icmp slt i32 %0, 16, !dbg !481
  %1 = load i32, ptr %offset.addr, align 4
  %cmp1 = icmp slt i32 %1, 0
  %or.cond = select i1 %cmp, i1 true, i1 %cmp1, !dbg !482
  br i1 %or.cond, label %if.then, label %lor.lhs.false2, !dbg !482

lor.lhs.false2:                                   ; preds = %entry
  %2 = load i32, ptr %offset.addr, align 4, !dbg !483
  %3 = load i32, ptr %size.addr, align 4, !dbg !484
  %add = add nsw i32 %2, %3, !dbg !485
  %4 = load i32, ptr %buf_size.addr, align 4, !dbg !486
  %cmp3 = icmp sgt i32 %add, %4, !dbg !487
  br i1 %cmp3, label %if.then, label %if.end, !dbg !488

if.then:                                          ; preds = %lor.lhs.false2, %entry
  store i32 -1, ptr %retval, align 4, !dbg !489
  br label %return, !dbg !489

if.end:                                           ; preds = %lor.lhs.false2
  call void @llvm.dbg.declare(metadata ptr %entry_count, metadata !490, metadata !DIExpression()), !dbg !491
  %5 = load ptr, ptr %buf.addr, align 8, !dbg !492
  %6 = load i32, ptr %offset.addr, align 4, !dbg !493
  %7 = load i32, ptr %buf_size.addr, align 4, !dbg !494
  %call = call i32 @read_be32(ptr noundef %5, i32 noundef %6, i32 noundef %7), !dbg !495
  store i32 %call, ptr %entry_count, align 4, !dbg !491
  %8 = load i32, ptr %entry_count, align 4, !dbg !496
  %cmp4 = icmp ult i32 %8, 1, !dbg !498
  %9 = load i32, ptr %entry_count, align 4
  %cmp6 = icmp ugt i32 %9, 4
  %or.cond1 = select i1 %cmp4, i1 true, i1 %cmp6, !dbg !499
  br i1 %or.cond1, label %if.then7, label %if.end8, !dbg !499

if.then7:                                         ; preds = %if.end
  store i32 -1, ptr %retval, align 4, !dbg !500
  br label %return, !dbg !500

if.end8:                                          ; preds = %if.end
  call void @llvm.dbg.declare(metadata ptr %entry_offset, metadata !501, metadata !DIExpression()), !dbg !502
  %10 = load i32, ptr %offset.addr, align 4, !dbg !503
  %add9 = add nsw i32 %10, 4, !dbg !504
  store i32 %add9, ptr %entry_offset, align 4, !dbg !502
  call void @llvm.dbg.declare(metadata ptr %i, metadata !505, metadata !DIExpression()), !dbg !507
  store i32 0, ptr %i, align 4, !dbg !507
  br label %for.cond, !dbg !508

for.cond:                                         ; preds = %if.end45, %if.end8
  %11 = load i32, ptr %i, align 4, !dbg !509
  %12 = load i32, ptr %entry_count, align 4, !dbg !511
  %cmp10 = icmp ult i32 %11, %12, !dbg !512
  br i1 %cmp10, label %for.body, label %for.end, !dbg !513

for.body:                                         ; preds = %for.cond
  %13 = load i32, ptr %entry_offset, align 4, !dbg !514
  %add11 = add nsw i32 %13, 8, !dbg !517
  %14 = load i32, ptr %offset.addr, align 4, !dbg !518
  %15 = load i32, ptr %size.addr, align 4, !dbg !519
  %add12 = add nsw i32 %14, %15, !dbg !520
  %cmp13 = icmp sgt i32 %add11, %add12, !dbg !521
  br i1 %cmp13, label %if.then14, label %if.end15, !dbg !522

if.then14:                                        ; preds = %for.body
  store i32 -1, ptr %retval, align 4, !dbg !523
  br label %return, !dbg !523

if.end15:                                         ; preds = %for.body
  call void @llvm.dbg.declare(metadata ptr %entry_size, metadata !524, metadata !DIExpression()), !dbg !525
  %16 = load ptr, ptr %buf.addr, align 8, !dbg !526
  %17 = load i32, ptr %entry_offset, align 4, !dbg !527
  %18 = load i32, ptr %buf_size.addr, align 4, !dbg !528
  %call16 = call i32 @read_be32(ptr noundef %16, i32 noundef %17, i32 noundef %18), !dbg !529
  store i32 %call16, ptr %entry_size, align 4, !dbg !525
  call void @llvm.dbg.declare(metadata ptr %format, metadata !530, metadata !DIExpression()), !dbg !531
  %19 = load ptr, ptr %buf.addr, align 8, !dbg !532
  %20 = load i32, ptr %entry_offset, align 4, !dbg !533
  %add17 = add nsw i32 %20, 4, !dbg !534
  %21 = load i32, ptr %buf_size.addr, align 4, !dbg !535
  %call18 = call i32 @read_tag(ptr noundef %19, i32 noundef %add17, i32 noundef %21), !dbg !536
  store i32 %call18, ptr %format, align 4, !dbg !531
  %22 = load i32, ptr %entry_size, align 4, !dbg !537
  %cmp19 = icmp ult i32 %22, 8, !dbg !539
  br i1 %cmp19, label %if.then24, label %lor.lhs.false20, !dbg !540

lor.lhs.false20:                                  ; preds = %if.end15
  %23 = load i32, ptr %entry_offset, align 4, !dbg !541
  %24 = load i32, ptr %entry_size, align 4, !dbg !542
  %add21 = add nsw i32 %23, %24, !dbg !543
  %25 = load i32, ptr %offset.addr, align 4, !dbg !544
  %26 = load i32, ptr %size.addr, align 4, !dbg !545
  %add22 = add nsw i32 %25, %26, !dbg !546
  %cmp23 = icmp sgt i32 %add21, %add22, !dbg !547
  br i1 %cmp23, label %if.then24, label %if.end25, !dbg !548

if.then24:                                        ; preds = %lor.lhs.false20, %if.end15
  store i32 -1, ptr %retval, align 4, !dbg !549
  br label %return, !dbg !549

if.end25:                                         ; preds = %lor.lhs.false20
  %27 = load i32, ptr %format, align 4, !dbg !550
  %cmp26 = icmp eq i32 %27, 828601953, !dbg !552
  br i1 %cmp26, label %if.then27, label %if.end45, !dbg !553

if.then27:                                        ; preds = %if.end25
  %28 = load ptr, ptr %codec_id.addr, align 8, !dbg !554
  store i32 27, ptr %28, align 4, !dbg !556
  call void @llvm.dbg.declare(metadata ptr %sub_offset, metadata !557, metadata !DIExpression()), !dbg !558
  %29 = load i32, ptr %entry_offset, align 4, !dbg !559
  %add28 = add nsw i32 %29, 8, !dbg !560
  store i32 %add28, ptr %sub_offset, align 4, !dbg !558
  br label %while.cond, !dbg !561

while.cond:                                       ; preds = %if.end43, %if.then27
  %30 = load i32, ptr %sub_offset, align 4, !dbg !562
  %add29 = add nsw i32 %30, 8, !dbg !563
  %31 = load i32, ptr %entry_offset, align 4, !dbg !564
  %32 = load i32, ptr %entry_size, align 4, !dbg !565
  %add30 = add nsw i32 %31, %32, !dbg !566
  %cmp31 = icmp sle i32 %add29, %add30, !dbg !567
  br i1 %cmp31, label %while.body, label %while.end, !dbg !561

while.body:                                       ; preds = %while.cond
  call void @llvm.dbg.declare(metadata ptr %sub_size, metadata !568, metadata !DIExpression()), !dbg !570
  call void @llvm.dbg.declare(metadata ptr %sub_tag, metadata !571, metadata !DIExpression()), !dbg !572
  %33 = load ptr, ptr %buf.addr, align 8, !dbg !573
  %34 = load i32, ptr %buf_size.addr, align 4, !dbg !575
  %35 = load i32, ptr %sub_offset, align 4, !dbg !576
  %call32 = call i32 @read_atom_header(ptr noundef %33, i32 noundef %34, i32 noundef %35, ptr noundef %sub_tag, ptr noundef %sub_size), !dbg !577
  %cmp33 = icmp slt i32 %call32, 0, !dbg !578
  br i1 %cmp33, label %while.end, label %if.end35, !dbg !579

if.end35:                                         ; preds = %while.body
  %36 = load i32, ptr %sub_tag, align 4, !dbg !580
  %cmp36 = icmp eq i32 %36, 1130591841, !dbg !582
  br i1 %cmp36, label %if.then37, label %if.end43, !dbg !583

if.then37:                                        ; preds = %if.end35
  %37 = load ptr, ptr %buf.addr, align 8, !dbg !584
  %38 = load i32, ptr %buf_size.addr, align 4, !dbg !587
  %39 = load i32, ptr %sub_offset, align 4, !dbg !588
  %add38 = add nsw i32 %39, 8, !dbg !589
  %40 = load i32, ptr %sub_size, align 4, !dbg !590
  %sub = sub i32 %40, 8, !dbg !591
  %call39 = call i32 @parse_avcC(ptr noundef %37, i32 noundef %38, i32 noundef %add38, i32 noundef %sub), !dbg !592
  %cmp40 = icmp slt i32 %call39, 0, !dbg !593
  br i1 %cmp40, label %if.then41, label %if.end42, !dbg !594

if.then41:                                        ; preds = %if.then37
  store i32 -1, ptr %retval, align 4, !dbg !595
  br label %return, !dbg !595

if.end42:                                         ; preds = %if.then37
  store i32 0, ptr %retval, align 4, !dbg !596
  br label %return, !dbg !596

if.end43:                                         ; preds = %if.end35
  %41 = load i32, ptr %sub_size, align 4, !dbg !597
  %42 = load i32, ptr %sub_offset, align 4, !dbg !598
  %add44 = add i32 %42, %41, !dbg !598
  store i32 %add44, ptr %sub_offset, align 4, !dbg !598
  br label %while.cond, !dbg !561, !llvm.loop !599

while.end:                                        ; preds = %while.body, %while.cond
  store i32 -1, ptr %retval, align 4, !dbg !601
  br label %return, !dbg !601

if.end45:                                         ; preds = %if.end25
  %43 = load i32, ptr %entry_size, align 4, !dbg !602
  %44 = load i32, ptr %entry_offset, align 4, !dbg !603
  %add46 = add i32 %44, %43, !dbg !603
  store i32 %add46, ptr %entry_offset, align 4, !dbg !603
  %45 = load i32, ptr %i, align 4, !dbg !604
  %inc = add i32 %45, 1, !dbg !604
  store i32 %inc, ptr %i, align 4, !dbg !604
  br label %for.cond, !dbg !605, !llvm.loop !606

for.end:                                          ; preds = %for.cond
  store i32 -1, ptr %retval, align 4, !dbg !608
  br label %return, !dbg !608

return:                                           ; preds = %for.end, %while.end, %if.end42, %if.then41, %if.then24, %if.then14, %if.then7, %if.then
  %46 = load i32, ptr %retval, align 4, !dbg !609
  ret i32 %46, !dbg !609
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @parse_avcC(ptr noundef %buf, i32 noundef %buf_size, i32 noundef %offset, i32 noundef %size) #0 !dbg !610 {
entry:
  %retval = alloca i32, align 4
  %buf.addr = alloca ptr, align 8
  %buf_size.addr = alloca i32, align 4
  %offset.addr = alloca i32, align 4
  %size.addr = alloca i32, align 4
  %version = alloca i8, align 1
  %profile = alloca i8, align 1
  %nal_length_size = alloca i8, align 1
  %num_sps = alloca i8, align 1
  %sps_offset = alloca i32, align 4
  %i = alloca i32, align 4
  %sps_size = alloca i16, align 2
  %nal_type = alloca i8, align 1
  store ptr %buf, ptr %buf.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %buf.addr, metadata !613, metadata !DIExpression()), !dbg !614
  store i32 %buf_size, ptr %buf_size.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %buf_size.addr, metadata !615, metadata !DIExpression()), !dbg !616
  store i32 %offset, ptr %offset.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %offset.addr, metadata !617, metadata !DIExpression()), !dbg !618
  store i32 %size, ptr %size.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %size.addr, metadata !619, metadata !DIExpression()), !dbg !620
  %0 = load i32, ptr %size.addr, align 4, !dbg !621
  %cmp = icmp slt i32 %0, 7, !dbg !623
  %1 = load i32, ptr %offset.addr, align 4
  %cmp1 = icmp slt i32 %1, 0
  %or.cond = select i1 %cmp, i1 true, i1 %cmp1, !dbg !624
  br i1 %or.cond, label %if.then, label %lor.lhs.false2, !dbg !624

lor.lhs.false2:                                   ; preds = %entry
  %2 = load i32, ptr %offset.addr, align 4, !dbg !625
  %3 = load i32, ptr %size.addr, align 4, !dbg !626
  %add = add nsw i32 %2, %3, !dbg !627
  %4 = load i32, ptr %buf_size.addr, align 4, !dbg !628
  %cmp3 = icmp sgt i32 %add, %4, !dbg !629
  br i1 %cmp3, label %if.then, label %if.end, !dbg !630

if.then:                                          ; preds = %lor.lhs.false2, %entry
  store i32 -1, ptr %retval, align 4, !dbg !631
  br label %return, !dbg !631

if.end:                                           ; preds = %lor.lhs.false2
  call void @llvm.dbg.declare(metadata ptr %version, metadata !632, metadata !DIExpression()), !dbg !633
  %5 = load ptr, ptr %buf.addr, align 8, !dbg !634
  %6 = load i32, ptr %offset.addr, align 4, !dbg !635
  %idxprom = sext i32 %6 to i64, !dbg !634
  %arrayidx = getelementptr inbounds i8, ptr %5, i64 %idxprom, !dbg !634
  %7 = load i8, ptr %arrayidx, align 1, !dbg !634
  store i8 %7, ptr %version, align 1, !dbg !633
  %8 = load i8, ptr %version, align 1, !dbg !636
  %conv = zext i8 %8 to i32, !dbg !636
  %cmp4 = icmp ne i32 %conv, 1, !dbg !638
  br i1 %cmp4, label %if.then6, label %if.end7, !dbg !639

if.then6:                                         ; preds = %if.end
  store i32 -1, ptr %retval, align 4, !dbg !640
  br label %return, !dbg !640

if.end7:                                          ; preds = %if.end
  call void @llvm.dbg.declare(metadata ptr %profile, metadata !641, metadata !DIExpression()), !dbg !642
  %9 = load ptr, ptr %buf.addr, align 8, !dbg !643
  %10 = load i32, ptr %offset.addr, align 4, !dbg !644
  %add8 = add nsw i32 %10, 1, !dbg !645
  %idxprom9 = sext i32 %add8 to i64, !dbg !643
  %arrayidx10 = getelementptr inbounds i8, ptr %9, i64 %idxprom9, !dbg !643
  %11 = load i8, ptr %arrayidx10, align 1, !dbg !643
  store i8 %11, ptr %profile, align 1, !dbg !642
  %12 = load i8, ptr %profile, align 1, !dbg !646
  %conv11 = zext i8 %12 to i32, !dbg !646
  %cmp12 = icmp ne i32 %conv11, 66, !dbg !648
  br i1 %cmp12, label %land.lhs.true, label %if.end34, !dbg !649

land.lhs.true:                                    ; preds = %if.end7
  %13 = load i8, ptr %profile, align 1, !dbg !650
  %conv14 = zext i8 %13 to i32, !dbg !650
  %cmp15 = icmp ne i32 %conv14, 77, !dbg !651
  br i1 %cmp15, label %land.lhs.true17, label %if.end34, !dbg !652

land.lhs.true17:                                  ; preds = %land.lhs.true
  %14 = load i8, ptr %profile, align 1, !dbg !653
  %conv18 = zext i8 %14 to i32, !dbg !653
  %cmp19 = icmp ne i32 %conv18, 88, !dbg !654
  br i1 %cmp19, label %land.lhs.true21, label %if.end34, !dbg !655

land.lhs.true21:                                  ; preds = %land.lhs.true17
  %15 = load i8, ptr %profile, align 1, !dbg !656
  %conv22 = zext i8 %15 to i32, !dbg !656
  %cmp23 = icmp ne i32 %conv22, 100, !dbg !657
  br i1 %cmp23, label %land.lhs.true25, label %if.end34, !dbg !658

land.lhs.true25:                                  ; preds = %land.lhs.true21
  %16 = load i8, ptr %profile, align 1, !dbg !659
  %conv26 = zext i8 %16 to i32, !dbg !659
  %cmp27 = icmp ne i32 %conv26, 110, !dbg !660
  br i1 %cmp27, label %land.lhs.true29, label %if.end34, !dbg !661

land.lhs.true29:                                  ; preds = %land.lhs.true25
  %17 = load i8, ptr %profile, align 1, !dbg !662
  %conv30 = zext i8 %17 to i32, !dbg !662
  %cmp31 = icmp ne i32 %conv30, 122, !dbg !663
  br i1 %cmp31, label %if.then33, label %if.end34, !dbg !664

if.then33:                                        ; preds = %land.lhs.true29
  store i32 -1, ptr %retval, align 4, !dbg !665
  br label %return, !dbg !665

if.end34:                                         ; preds = %land.lhs.true29, %land.lhs.true25, %land.lhs.true21, %land.lhs.true17, %land.lhs.true, %if.end7
  call void @llvm.dbg.declare(metadata ptr %nal_length_size, metadata !666, metadata !DIExpression()), !dbg !667
  %18 = load ptr, ptr %buf.addr, align 8, !dbg !668
  %19 = load i32, ptr %offset.addr, align 4, !dbg !669
  %add35 = add nsw i32 %19, 4, !dbg !670
  %idxprom36 = sext i32 %add35 to i64, !dbg !668
  %arrayidx37 = getelementptr inbounds i8, ptr %18, i64 %idxprom36, !dbg !668
  %20 = load i8, ptr %arrayidx37, align 1, !dbg !668
  %conv38 = zext i8 %20 to i32, !dbg !668
  %and = and i32 %conv38, 3, !dbg !671
  %add39 = add nsw i32 %and, 1, !dbg !672
  %conv40 = trunc i32 %add39 to i8, !dbg !673
  store i8 %conv40, ptr %nal_length_size, align 1, !dbg !667
  %21 = load i8, ptr %nal_length_size, align 1, !dbg !674
  %conv41 = zext i8 %21 to i32, !dbg !674
  %cmp42 = icmp ne i32 %conv41, 1, !dbg !676
  br i1 %cmp42, label %land.lhs.true44, label %if.end53, !dbg !677

land.lhs.true44:                                  ; preds = %if.end34
  %22 = load i8, ptr %nal_length_size, align 1, !dbg !678
  %conv45 = zext i8 %22 to i32, !dbg !678
  %cmp46 = icmp ne i32 %conv45, 2, !dbg !679
  br i1 %cmp46, label %land.lhs.true48, label %if.end53, !dbg !680

land.lhs.true48:                                  ; preds = %land.lhs.true44
  %23 = load i8, ptr %nal_length_size, align 1, !dbg !681
  %conv49 = zext i8 %23 to i32, !dbg !681
  %cmp50 = icmp ne i32 %conv49, 4, !dbg !682
  br i1 %cmp50, label %if.then52, label %if.end53, !dbg !683

if.then52:                                        ; preds = %land.lhs.true48
  store i32 -1, ptr %retval, align 4, !dbg !684
  br label %return, !dbg !684

if.end53:                                         ; preds = %land.lhs.true48, %land.lhs.true44, %if.end34
  call void @llvm.dbg.declare(metadata ptr %num_sps, metadata !685, metadata !DIExpression()), !dbg !686
  %24 = load ptr, ptr %buf.addr, align 8, !dbg !687
  %25 = load i32, ptr %offset.addr, align 4, !dbg !688
  %add54 = add nsw i32 %25, 5, !dbg !689
  %idxprom55 = sext i32 %add54 to i64, !dbg !687
  %arrayidx56 = getelementptr inbounds i8, ptr %24, i64 %idxprom55, !dbg !687
  %26 = load i8, ptr %arrayidx56, align 1, !dbg !687
  %conv57 = zext i8 %26 to i32, !dbg !687
  %and58 = and i32 %conv57, 31, !dbg !690
  %conv59 = trunc i32 %and58 to i8, !dbg !687
  store i8 %conv59, ptr %num_sps, align 1, !dbg !686
  %27 = load i8, ptr %num_sps, align 1, !dbg !691
  %conv60 = zext i8 %27 to i32, !dbg !691
  %cmp61 = icmp slt i32 %conv60, 1, !dbg !693
  br i1 %cmp61, label %if.then67, label %lor.lhs.false63, !dbg !694

lor.lhs.false63:                                  ; preds = %if.end53
  %28 = load i8, ptr %num_sps, align 1, !dbg !695
  %conv64 = zext i8 %28 to i32, !dbg !695
  %cmp65 = icmp sgt i32 %conv64, 4, !dbg !696
  br i1 %cmp65, label %if.then67, label %if.end68, !dbg !697

if.then67:                                        ; preds = %lor.lhs.false63, %if.end53
  store i32 -1, ptr %retval, align 4, !dbg !698
  br label %return, !dbg !698

if.end68:                                         ; preds = %lor.lhs.false63
  call void @llvm.dbg.declare(metadata ptr %sps_offset, metadata !699, metadata !DIExpression()), !dbg !700
  %29 = load i32, ptr %offset.addr, align 4, !dbg !701
  %add69 = add nsw i32 %29, 6, !dbg !702
  store i32 %add69, ptr %sps_offset, align 4, !dbg !700
  call void @llvm.dbg.declare(metadata ptr %i, metadata !703, metadata !DIExpression()), !dbg !705
  store i32 0, ptr %i, align 4, !dbg !705
  br label %for.cond, !dbg !706

for.cond:                                         ; preds = %if.end119, %if.end68
  %30 = load i32, ptr %i, align 4, !dbg !707
  %31 = load i8, ptr %num_sps, align 1, !dbg !709
  %conv70 = zext i8 %31 to i32, !dbg !709
  %cmp71 = icmp slt i32 %30, %conv70, !dbg !710
  br i1 %cmp71, label %for.body, label %for.end, !dbg !711

for.body:                                         ; preds = %for.cond
  %32 = load i32, ptr %sps_offset, align 4, !dbg !712
  %add73 = add nsw i32 %32, 2, !dbg !715
  %33 = load i32, ptr %offset.addr, align 4, !dbg !716
  %34 = load i32, ptr %size.addr, align 4, !dbg !717
  %add74 = add nsw i32 %33, %34, !dbg !718
  %cmp75 = icmp sgt i32 %add73, %add74, !dbg !719
  br i1 %cmp75, label %if.then77, label %if.end78, !dbg !720

if.then77:                                        ; preds = %for.body
  store i32 -1, ptr %retval, align 4, !dbg !721
  br label %return, !dbg !721

if.end78:                                         ; preds = %for.body
  call void @llvm.dbg.declare(metadata ptr %sps_size, metadata !722, metadata !DIExpression()), !dbg !723
  %35 = load ptr, ptr %buf.addr, align 8, !dbg !724
  %36 = load i32, ptr %sps_offset, align 4, !dbg !725
  %idxprom79 = sext i32 %36 to i64, !dbg !724
  %arrayidx80 = getelementptr inbounds i8, ptr %35, i64 %idxprom79, !dbg !724
  %37 = load i8, ptr %arrayidx80, align 1, !dbg !724
  %conv81 = zext i8 %37 to i16, !dbg !726
  %conv82 = zext i16 %conv81 to i32, !dbg !726
  %shl = shl i32 %conv82, 8, !dbg !727
  %38 = load ptr, ptr %buf.addr, align 8, !dbg !728
  %39 = load i32, ptr %sps_offset, align 4, !dbg !729
  %add83 = add nsw i32 %39, 1, !dbg !730
  %idxprom84 = sext i32 %add83 to i64, !dbg !728
  %arrayidx85 = getelementptr inbounds i8, ptr %38, i64 %idxprom84, !dbg !728
  %40 = load i8, ptr %arrayidx85, align 1, !dbg !728
  %conv86 = zext i8 %40 to i32, !dbg !728
  %or = or i32 %shl, %conv86, !dbg !731
  %conv87 = trunc i32 %or to i16, !dbg !732
  store i16 %conv87, ptr %sps_size, align 2, !dbg !723
  %41 = load i16, ptr %sps_size, align 2, !dbg !733
  %conv88 = zext i16 %41 to i32, !dbg !733
  %cmp89 = icmp eq i32 %conv88, 0, !dbg !735
  br i1 %cmp89, label %if.then102, label %lor.lhs.false91, !dbg !736

lor.lhs.false91:                                  ; preds = %if.end78
  %42 = load i16, ptr %sps_size, align 2, !dbg !737
  %conv92 = zext i16 %42 to i32, !dbg !737
  %cmp93 = icmp sgt i32 %conv92, 128, !dbg !738
  br i1 %cmp93, label %if.then102, label %lor.lhs.false95, !dbg !739

lor.lhs.false95:                                  ; preds = %lor.lhs.false91
  %43 = load i32, ptr %sps_offset, align 4, !dbg !740
  %add96 = add nsw i32 %43, 2, !dbg !741
  %44 = load i16, ptr %sps_size, align 2, !dbg !742
  %conv97 = zext i16 %44 to i32, !dbg !742
  %add98 = add nsw i32 %add96, %conv97, !dbg !743
  %45 = load i32, ptr %offset.addr, align 4, !dbg !744
  %46 = load i32, ptr %size.addr, align 4, !dbg !745
  %add99 = add nsw i32 %45, %46, !dbg !746
  %cmp100 = icmp sgt i32 %add98, %add99, !dbg !747
  br i1 %cmp100, label %if.then102, label %if.end103, !dbg !748

if.then102:                                       ; preds = %lor.lhs.false95, %lor.lhs.false91, %if.end78
  store i32 -1, ptr %retval, align 4, !dbg !749
  br label %return, !dbg !749

if.end103:                                        ; preds = %lor.lhs.false95
  %47 = load i32, ptr %sps_offset, align 4, !dbg !750
  %add104 = add nsw i32 %47, 2, !dbg !752
  %48 = load i32, ptr %buf_size.addr, align 4, !dbg !753
  %cmp105 = icmp sge i32 %add104, %48, !dbg !754
  br i1 %cmp105, label %if.then107, label %if.end108, !dbg !755

if.then107:                                       ; preds = %if.end103
  store i32 -1, ptr %retval, align 4, !dbg !756
  br label %return, !dbg !756

if.end108:                                        ; preds = %if.end103
  call void @llvm.dbg.declare(metadata ptr %nal_type, metadata !757, metadata !DIExpression()), !dbg !758
  %49 = load ptr, ptr %buf.addr, align 8, !dbg !759
  %50 = load i32, ptr %sps_offset, align 4, !dbg !760
  %add109 = add nsw i32 %50, 2, !dbg !761
  %idxprom110 = sext i32 %add109 to i64, !dbg !759
  %arrayidx111 = getelementptr inbounds i8, ptr %49, i64 %idxprom110, !dbg !759
  %51 = load i8, ptr %arrayidx111, align 1, !dbg !759
  %conv112 = zext i8 %51 to i32, !dbg !759
  %and113 = and i32 %conv112, 31, !dbg !762
  %conv114 = trunc i32 %and113 to i8, !dbg !759
  store i8 %conv114, ptr %nal_type, align 1, !dbg !758
  %52 = load i8, ptr %nal_type, align 1, !dbg !763
  %conv115 = zext i8 %52 to i32, !dbg !763
  %cmp116 = icmp ne i32 %conv115, 7, !dbg !765
  br i1 %cmp116, label %if.then118, label %if.end119, !dbg !766

if.then118:                                       ; preds = %if.end108
  store i32 -1, ptr %retval, align 4, !dbg !767
  br label %return, !dbg !767

if.end119:                                        ; preds = %if.end108
  %53 = load i16, ptr %sps_size, align 2, !dbg !768
  %conv120 = zext i16 %53 to i32, !dbg !768
  %add121 = add nsw i32 2, %conv120, !dbg !769
  %54 = load i32, ptr %sps_offset, align 4, !dbg !770
  %add122 = add nsw i32 %54, %add121, !dbg !770
  store i32 %add122, ptr %sps_offset, align 4, !dbg !770
  %55 = load i32, ptr %i, align 4, !dbg !771
  %inc = add nsw i32 %55, 1, !dbg !771
  store i32 %inc, ptr %i, align 4, !dbg !771
  br label %for.cond, !dbg !772, !llvm.loop !773

for.end:                                          ; preds = %for.cond
  store i32 0, ptr %retval, align 4, !dbg !775
  br label %return, !dbg !775

return:                                           ; preds = %for.end, %if.then118, %if.then107, %if.then102, %if.then77, %if.then67, %if.then52, %if.then33, %if.then6, %if.then
  %56 = load i32, ptr %retval, align 4, !dbg !776
  ret i32 %56, !dbg !776
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind }

!llvm.dbg.cu = !{!9}
!llvm.module.flags = !{!37, !38, !39, !40, !41, !42, !43}
!llvm.ident = !{!44}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 290, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "concolic_mp4_demo.c", directory: "/work", checksumkind: CSK_MD5, checksum: "8a326d6206290fb0a4bb94147ea03e38")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 48, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 6)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "target_reached", scope: !9, file: !2, line: 56, type: !16, isLocal: true, isDefinition: true)
!9 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "clang version 16.0.6 (https://github.com/llvm/llvm-project.git 7cbf1a2591520c2491aa35339f227775f4d3adf6)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !10, globals: !20, splitDebugInlining: false, nameTableKind: None)
!10 = !{!11, !16, !17}
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !12, line: 26, baseType: !13)
!12 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !14, line: 42, baseType: !15)
!14 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!15 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!16 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !12, line: 25, baseType: !18)
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !14, line: 40, baseType: !19)
!19 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!20 = !{!0, !21, !26, !31, !7}
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(scope: null, file: !2, line: 324, type: !23, isLocal: true, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 176, elements: !24)
!24 = !{!25}
!25 = !DISubrange(count: 22)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(scope: null, file: !2, line: 324, type: !28, isLocal: true, isDefinition: true)
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 160, elements: !29)
!29 = !{!30}
!30 = !DISubrange(count: 20)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !2, line: 324, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 184, elements: !35)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!35 = !{!36}
!36 = !DISubrange(count: 23)
!37 = !{i32 7, !"Dwarf Version", i32 5}
!38 = !{i32 2, !"Debug Info Version", i32 3}
!39 = !{i32 1, !"wchar_size", i32 4}
!40 = !{i32 8, !"PIC Level", i32 2}
!41 = !{i32 7, !"PIE Level", i32 2}
!42 = !{i32 7, !"uwtable", i32 2}
!43 = !{i32 7, !"frame-pointer", i32 2}
!44 = !{!"clang version 16.0.6 (https://github.com/llvm/llvm-project.git 7cbf1a2591520c2491aa35339f227775f4d3adf6)"}
!45 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 285, type: !46, scopeLine: 285, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !9, retainedNodes: !50)
!46 = !DISubroutineType(types: !47)
!47 = !{!16, !16, !48}
!48 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !49, size: 64)
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!50 = !{}
!51 = !DILocalVariable(name: "argc", arg: 1, scope: !45, file: !2, line: 285, type: !16)
!52 = !DILocation(line: 285, column: 14, scope: !45)
!53 = !DILocalVariable(name: "argv", arg: 2, scope: !45, file: !2, line: 285, type: !48)
!54 = !DILocation(line: 285, column: 26, scope: !45)
!55 = !DILocalVariable(name: "input", scope: !45, file: !2, line: 286, type: !56)
!56 = !DICompositeType(tag: DW_TAG_array_type, baseType: !57, size: 4096, elements: !60)
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !12, line: 24, baseType: !58)
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !14, line: 38, baseType: !59)
!59 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!60 = !{!61}
!61 = !DISubrange(count: 512)
!62 = !DILocation(line: 286, column: 13, scope: !45)
!63 = !DILocalVariable(name: "codec_id", scope: !45, file: !2, line: 287, type: !16)
!64 = !DILocation(line: 287, column: 9, scope: !45)
!65 = !DILocation(line: 290, column: 24, scope: !45)
!66 = !DILocation(line: 290, column: 5, scope: !45)
!67 = !DILocation(line: 305, column: 19, scope: !68)
!68 = distinct !DILexicalBlock(scope: !45, file: !2, line: 305, column: 9)
!69 = !DILocation(line: 305, column: 9, scope: !68)
!70 = !DILocation(line: 305, column: 49, scope: !68)
!71 = !DILocation(line: 305, column: 9, scope: !45)
!72 = !DILocation(line: 307, column: 9, scope: !73)
!73 = distinct !DILexicalBlock(scope: !68, file: !2, line: 305, column: 54)
!74 = !DILocation(line: 311, column: 9, scope: !75)
!75 = distinct !DILexicalBlock(scope: !45, file: !2, line: 311, column: 9)
!76 = !DILocation(line: 311, column: 18, scope: !75)
!77 = !DILocation(line: 311, column: 38, scope: !75)
!78 = !DILocation(line: 313, column: 31, scope: !79)
!79 = distinct !DILexicalBlock(scope: !75, file: !2, line: 312, column: 39)
!80 = !DILocation(line: 313, column: 37, scope: !79)
!81 = !DILocation(line: 313, column: 9, scope: !79)
!82 = !DILocation(line: 323, column: 9, scope: !83)
!83 = distinct !DILexicalBlock(scope: !45, file: !2, line: 323, column: 9)
!84 = !DILocation(line: 323, column: 9, scope: !45)
!85 = !DILocation(line: 316, column: 9, scope: !86)
!86 = distinct !DILexicalBlock(scope: !75, file: !2, line: 314, column: 12)
!87 = !DILocation(line: 324, column: 9, scope: !88)
!88 = distinct !DILexicalBlock(scope: !89, file: !2, line: 324, column: 9)
!89 = distinct !DILexicalBlock(scope: !90, file: !2, line: 324, column: 9)
!90 = distinct !DILexicalBlock(scope: !83, file: !2, line: 323, column: 25)
!91 = !DILocation(line: 328, column: 5, scope: !45)
!92 = !DILocation(line: 329, column: 1, scope: !45)
!93 = distinct !DISubprogram(name: "parse_mp4", scope: !2, file: !2, line: 249, type: !94, scopeLine: 249, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !9, retainedNodes: !50)
!94 = !DISubroutineType(types: !95)
!95 = !{!16, !96, !16, !98}
!96 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64)
!97 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !57)
!98 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!99 = !DILocalVariable(name: "buf", arg: 1, scope: !93, file: !2, line: 249, type: !96)
!100 = !DILocation(line: 249, column: 37, scope: !93)
!101 = !DILocalVariable(name: "buf_size", arg: 2, scope: !93, file: !2, line: 249, type: !16)
!102 = !DILocation(line: 249, column: 46, scope: !93)
!103 = !DILocalVariable(name: "codec_id", arg: 3, scope: !93, file: !2, line: 249, type: !98)
!104 = !DILocation(line: 249, column: 61, scope: !93)
!105 = !DILocalVariable(name: "pos", scope: !93, file: !2, line: 250, type: !16)
!106 = !DILocation(line: 250, column: 9, scope: !93)
!107 = !DILocalVariable(name: "found_ftyp", scope: !93, file: !2, line: 251, type: !16)
!108 = !DILocation(line: 251, column: 9, scope: !93)
!109 = !DILocalVariable(name: "found_moov", scope: !93, file: !2, line: 251, type: !16)
!110 = !DILocation(line: 251, column: 25, scope: !93)
!111 = !DILocation(line: 253, column: 5, scope: !93)
!112 = !DILocation(line: 253, column: 12, scope: !93)
!113 = !DILocation(line: 253, column: 16, scope: !93)
!114 = !DILocation(line: 253, column: 23, scope: !93)
!115 = !DILocation(line: 253, column: 20, scope: !93)
!116 = !DILocalVariable(name: "size", scope: !117, file: !2, line: 254, type: !11)
!117 = distinct !DILexicalBlock(scope: !93, file: !2, line: 253, column: 33)
!118 = !DILocation(line: 254, column: 18, scope: !117)
!119 = !DILocalVariable(name: "tag", scope: !117, file: !2, line: 254, type: !11)
!120 = !DILocation(line: 254, column: 24, scope: !117)
!121 = !DILocation(line: 255, column: 30, scope: !122)
!122 = distinct !DILexicalBlock(scope: !117, file: !2, line: 255, column: 13)
!123 = !DILocation(line: 255, column: 35, scope: !122)
!124 = !DILocation(line: 255, column: 45, scope: !122)
!125 = !DILocation(line: 255, column: 13, scope: !122)
!126 = !DILocation(line: 255, column: 63, scope: !122)
!127 = !DILocation(line: 255, column: 13, scope: !117)
!128 = !DILocation(line: 258, column: 13, scope: !129)
!129 = distinct !DILexicalBlock(scope: !117, file: !2, line: 258, column: 13)
!130 = !DILocation(line: 258, column: 17, scope: !129)
!131 = !DILocation(line: 258, column: 13, scope: !117)
!132 = !DILocation(line: 260, column: 24, scope: !133)
!133 = distinct !DILexicalBlock(scope: !129, file: !2, line: 258, column: 30)
!134 = !DILocation(line: 261, column: 9, scope: !133)
!135 = !DILocation(line: 261, column: 20, scope: !136)
!136 = distinct !DILexicalBlock(scope: !129, file: !2, line: 261, column: 20)
!137 = !DILocation(line: 261, column: 24, scope: !136)
!138 = !DILocation(line: 261, column: 20, scope: !129)
!139 = !DILocation(line: 263, column: 28, scope: !140)
!140 = distinct !DILexicalBlock(scope: !141, file: !2, line: 263, column: 17)
!141 = distinct !DILexicalBlock(scope: !136, file: !2, line: 261, column: 37)
!142 = !DILocation(line: 263, column: 33, scope: !140)
!143 = !DILocation(line: 263, column: 43, scope: !140)
!144 = !DILocation(line: 263, column: 47, scope: !140)
!145 = !DILocation(line: 263, column: 52, scope: !140)
!146 = !DILocation(line: 263, column: 57, scope: !140)
!147 = !DILocation(line: 263, column: 62, scope: !140)
!148 = !DILocation(line: 263, column: 17, scope: !140)
!149 = !DILocation(line: 263, column: 72, scope: !140)
!150 = !DILocation(line: 263, column: 17, scope: !141)
!151 = !DILocation(line: 264, column: 28, scope: !140)
!152 = !DILocation(line: 264, column: 17, scope: !140)
!153 = !DILocation(line: 266, column: 16, scope: !117)
!154 = !DILocation(line: 266, column: 13, scope: !117)
!155 = distinct !{!155, !111, !156, !157}
!156 = !DILocation(line: 267, column: 5, scope: !93)
!157 = !{!"llvm.loop.mustprogress"}
!158 = !DILocation(line: 269, column: 10, scope: !159)
!159 = distinct !DILexicalBlock(scope: !93, file: !2, line: 269, column: 9)
!160 = !DILocation(line: 269, column: 21, scope: !159)
!161 = !DILocation(line: 270, column: 9, scope: !159)
!162 = !DILocation(line: 271, column: 5, scope: !93)
!163 = !DILocation(line: 272, column: 1, scope: !93)
!164 = distinct !DISubprogram(name: "ff_rtp_send_h264_hevc", scope: !2, file: !2, line: 277, type: !165, scopeLine: 277, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !9, retainedNodes: !50)
!165 = !DISubroutineType(types: !166)
!166 = !{null, !96, !16}
!167 = !DILocalVariable(name: "data", arg: 1, scope: !164, file: !2, line: 277, type: !96)
!168 = !DILocation(line: 277, column: 50, scope: !164)
!169 = !DILocalVariable(name: "size", arg: 2, scope: !164, file: !2, line: 277, type: !16)
!170 = !DILocation(line: 277, column: 60, scope: !164)
!171 = !DILocation(line: 278, column: 20, scope: !164)
!172 = !DILocation(line: 280, column: 1, scope: !164)
!173 = distinct !DISubprogram(name: "read_atom_header", scope: !2, file: !2, line: 79, type: !174, scopeLine: 80, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !9, retainedNodes: !50)
!174 = !DISubroutineType(types: !175)
!175 = !{!16, !96, !16, !16, !176, !176}
!176 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!177 = !DILocalVariable(name: "buf", arg: 1, scope: !173, file: !2, line: 79, type: !96)
!178 = !DILocation(line: 79, column: 44, scope: !173)
!179 = !DILocalVariable(name: "buf_size", arg: 2, scope: !173, file: !2, line: 79, type: !16)
!180 = !DILocation(line: 79, column: 53, scope: !173)
!181 = !DILocalVariable(name: "pos", arg: 3, scope: !173, file: !2, line: 80, type: !16)
!182 = !DILocation(line: 80, column: 33, scope: !173)
!183 = !DILocalVariable(name: "tag", arg: 4, scope: !173, file: !2, line: 80, type: !176)
!184 = !DILocation(line: 80, column: 48, scope: !173)
!185 = !DILocalVariable(name: "size", arg: 5, scope: !173, file: !2, line: 80, type: !176)
!186 = !DILocation(line: 80, column: 63, scope: !173)
!187 = !DILocation(line: 81, column: 9, scope: !188)
!188 = distinct !DILexicalBlock(scope: !173, file: !2, line: 81, column: 9)
!189 = !DILocation(line: 81, column: 13, scope: !188)
!190 = !DILocation(line: 81, column: 17, scope: !188)
!191 = !DILocation(line: 81, column: 20, scope: !188)
!192 = !DILocation(line: 81, column: 24, scope: !188)
!193 = !DILocation(line: 81, column: 30, scope: !188)
!194 = !DILocation(line: 81, column: 28, scope: !188)
!195 = !DILocation(line: 81, column: 9, scope: !173)
!196 = !DILocation(line: 82, column: 9, scope: !188)
!197 = !DILocation(line: 83, column: 23, scope: !173)
!198 = !DILocation(line: 83, column: 28, scope: !173)
!199 = !DILocation(line: 83, column: 33, scope: !173)
!200 = !DILocation(line: 83, column: 13, scope: !173)
!201 = !DILocation(line: 83, column: 6, scope: !173)
!202 = !DILocation(line: 83, column: 11, scope: !173)
!203 = !DILocation(line: 84, column: 22, scope: !173)
!204 = !DILocation(line: 84, column: 27, scope: !173)
!205 = !DILocation(line: 84, column: 31, scope: !173)
!206 = !DILocation(line: 84, column: 36, scope: !173)
!207 = !DILocation(line: 84, column: 13, scope: !173)
!208 = !DILocation(line: 84, column: 6, scope: !173)
!209 = !DILocation(line: 84, column: 11, scope: !173)
!210 = !DILocation(line: 85, column: 10, scope: !211)
!211 = distinct !DILexicalBlock(scope: !173, file: !2, line: 85, column: 9)
!212 = !DILocation(line: 85, column: 9, scope: !211)
!213 = !DILocation(line: 85, column: 15, scope: !211)
!214 = !DILocation(line: 85, column: 19, scope: !211)
!215 = !DILocation(line: 85, column: 22, scope: !211)
!216 = !DILocation(line: 85, column: 34, scope: !211)
!217 = !DILocation(line: 85, column: 33, scope: !211)
!218 = !DILocation(line: 85, column: 26, scope: !211)
!219 = !DILocation(line: 85, column: 41, scope: !211)
!220 = !DILocation(line: 85, column: 39, scope: !211)
!221 = !DILocation(line: 85, column: 9, scope: !173)
!222 = !DILocation(line: 86, column: 9, scope: !211)
!223 = !DILocation(line: 87, column: 5, scope: !173)
!224 = !DILocation(line: 88, column: 1, scope: !173)
!225 = distinct !DISubprogram(name: "parse_moov", scope: !2, file: !2, line: 215, type: !226, scopeLine: 216, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !9, retainedNodes: !50)
!226 = !DISubroutineType(types: !227)
!227 = !{!16, !96, !16, !16, !16, !98}
!228 = !DILocalVariable(name: "buf", arg: 1, scope: !225, file: !2, line: 215, type: !96)
!229 = !DILocation(line: 215, column: 38, scope: !225)
!230 = !DILocalVariable(name: "buf_size", arg: 2, scope: !225, file: !2, line: 215, type: !16)
!231 = !DILocation(line: 215, column: 47, scope: !225)
!232 = !DILocalVariable(name: "offset", arg: 3, scope: !225, file: !2, line: 216, type: !16)
!233 = !DILocation(line: 216, column: 27, scope: !225)
!234 = !DILocalVariable(name: "size", arg: 4, scope: !225, file: !2, line: 216, type: !16)
!235 = !DILocation(line: 216, column: 39, scope: !225)
!236 = !DILocalVariable(name: "codec_id", arg: 5, scope: !225, file: !2, line: 216, type: !98)
!237 = !DILocation(line: 216, column: 50, scope: !225)
!238 = !DILocalVariable(name: "off", scope: !225, file: !2, line: 217, type: !16)
!239 = !DILocation(line: 217, column: 9, scope: !225)
!240 = !DILocalVariable(name: "sz", scope: !225, file: !2, line: 217, type: !16)
!241 = !DILocation(line: 217, column: 14, scope: !225)
!242 = !DILocation(line: 219, column: 25, scope: !243)
!243 = distinct !DILexicalBlock(scope: !225, file: !2, line: 219, column: 9)
!244 = !DILocation(line: 219, column: 30, scope: !243)
!245 = !DILocation(line: 219, column: 40, scope: !243)
!246 = !DILocation(line: 219, column: 48, scope: !243)
!247 = !DILocation(line: 219, column: 9, scope: !243)
!248 = !DILocation(line: 219, column: 75, scope: !243)
!249 = !DILocation(line: 219, column: 9, scope: !225)
!250 = !DILocation(line: 220, column: 9, scope: !243)
!251 = !DILocalVariable(name: "mdia_off", scope: !225, file: !2, line: 223, type: !16)
!252 = !DILocation(line: 223, column: 9, scope: !225)
!253 = !DILocalVariable(name: "mdia_sz", scope: !225, file: !2, line: 223, type: !16)
!254 = !DILocation(line: 223, column: 19, scope: !225)
!255 = !DILocation(line: 224, column: 25, scope: !256)
!256 = distinct !DILexicalBlock(scope: !225, file: !2, line: 224, column: 9)
!257 = !DILocation(line: 224, column: 30, scope: !256)
!258 = !DILocation(line: 224, column: 40, scope: !256)
!259 = !DILocation(line: 224, column: 45, scope: !256)
!260 = !DILocation(line: 224, column: 9, scope: !256)
!261 = !DILocation(line: 224, column: 80, scope: !256)
!262 = !DILocation(line: 224, column: 9, scope: !225)
!263 = !DILocation(line: 225, column: 9, scope: !256)
!264 = !DILocalVariable(name: "minf_off", scope: !225, file: !2, line: 228, type: !16)
!265 = !DILocation(line: 228, column: 9, scope: !225)
!266 = !DILocalVariable(name: "minf_sz", scope: !225, file: !2, line: 228, type: !16)
!267 = !DILocation(line: 228, column: 19, scope: !225)
!268 = !DILocation(line: 229, column: 25, scope: !269)
!269 = distinct !DILexicalBlock(scope: !225, file: !2, line: 229, column: 9)
!270 = !DILocation(line: 229, column: 30, scope: !269)
!271 = !DILocation(line: 229, column: 40, scope: !269)
!272 = !DILocation(line: 229, column: 50, scope: !269)
!273 = !DILocation(line: 229, column: 9, scope: !269)
!274 = !DILocation(line: 229, column: 90, scope: !269)
!275 = !DILocation(line: 229, column: 9, scope: !225)
!276 = !DILocation(line: 230, column: 9, scope: !269)
!277 = !DILocalVariable(name: "stbl_off", scope: !225, file: !2, line: 233, type: !16)
!278 = !DILocation(line: 233, column: 9, scope: !225)
!279 = !DILocalVariable(name: "stbl_sz", scope: !225, file: !2, line: 233, type: !16)
!280 = !DILocation(line: 233, column: 19, scope: !225)
!281 = !DILocation(line: 234, column: 25, scope: !282)
!282 = distinct !DILexicalBlock(scope: !225, file: !2, line: 234, column: 9)
!283 = !DILocation(line: 234, column: 30, scope: !282)
!284 = !DILocation(line: 234, column: 40, scope: !282)
!285 = !DILocation(line: 234, column: 50, scope: !282)
!286 = !DILocation(line: 234, column: 9, scope: !282)
!287 = !DILocation(line: 234, column: 90, scope: !282)
!288 = !DILocation(line: 234, column: 9, scope: !225)
!289 = !DILocation(line: 235, column: 9, scope: !282)
!290 = !DILocalVariable(name: "stsd_off", scope: !225, file: !2, line: 238, type: !16)
!291 = !DILocation(line: 238, column: 9, scope: !225)
!292 = !DILocalVariable(name: "stsd_sz", scope: !225, file: !2, line: 238, type: !16)
!293 = !DILocation(line: 238, column: 19, scope: !225)
!294 = !DILocation(line: 239, column: 25, scope: !295)
!295 = distinct !DILexicalBlock(scope: !225, file: !2, line: 239, column: 9)
!296 = !DILocation(line: 239, column: 30, scope: !295)
!297 = !DILocation(line: 239, column: 40, scope: !295)
!298 = !DILocation(line: 239, column: 50, scope: !295)
!299 = !DILocation(line: 239, column: 9, scope: !295)
!300 = !DILocation(line: 239, column: 90, scope: !295)
!301 = !DILocation(line: 239, column: 9, scope: !225)
!302 = !DILocation(line: 240, column: 9, scope: !295)
!303 = !DILocation(line: 243, column: 23, scope: !225)
!304 = !DILocation(line: 243, column: 28, scope: !225)
!305 = !DILocation(line: 243, column: 38, scope: !225)
!306 = !DILocation(line: 243, column: 48, scope: !225)
!307 = !DILocation(line: 243, column: 57, scope: !225)
!308 = !DILocation(line: 243, column: 12, scope: !225)
!309 = !DILocation(line: 243, column: 5, scope: !225)
!310 = !DILocation(line: 244, column: 1, scope: !225)
!311 = distinct !DISubprogram(name: "read_be32", scope: !2, file: !2, line: 61, type: !312, scopeLine: 61, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !9, retainedNodes: !50)
!312 = !DISubroutineType(types: !313)
!313 = !{!11, !96, !16, !16}
!314 = !DILocalVariable(name: "buf", arg: 1, scope: !311, file: !2, line: 61, type: !96)
!315 = !DILocation(line: 61, column: 42, scope: !311)
!316 = !DILocalVariable(name: "offset", arg: 2, scope: !311, file: !2, line: 61, type: !16)
!317 = !DILocation(line: 61, column: 51, scope: !311)
!318 = !DILocalVariable(name: "buf_size", arg: 3, scope: !311, file: !2, line: 61, type: !16)
!319 = !DILocation(line: 61, column: 63, scope: !311)
!320 = !DILocation(line: 62, column: 9, scope: !321)
!321 = distinct !DILexicalBlock(scope: !311, file: !2, line: 62, column: 9)
!322 = !DILocation(line: 62, column: 16, scope: !321)
!323 = !DILocation(line: 62, column: 20, scope: !321)
!324 = !DILocation(line: 62, column: 23, scope: !321)
!325 = !DILocation(line: 62, column: 30, scope: !321)
!326 = !DILocation(line: 62, column: 36, scope: !321)
!327 = !DILocation(line: 62, column: 34, scope: !321)
!328 = !DILocation(line: 62, column: 9, scope: !311)
!329 = !DILocation(line: 62, column: 46, scope: !321)
!330 = !DILocation(line: 63, column: 23, scope: !311)
!331 = !DILocation(line: 63, column: 27, scope: !311)
!332 = !DILocation(line: 63, column: 13, scope: !311)
!333 = !DILocation(line: 63, column: 35, scope: !311)
!334 = !DILocation(line: 63, column: 55, scope: !311)
!335 = !DILocation(line: 63, column: 59, scope: !311)
!336 = !DILocation(line: 63, column: 65, scope: !311)
!337 = !DILocation(line: 63, column: 45, scope: !311)
!338 = !DILocation(line: 63, column: 69, scope: !311)
!339 = !DILocation(line: 63, column: 42, scope: !311)
!340 = !DILocation(line: 64, column: 23, scope: !311)
!341 = !DILocation(line: 64, column: 27, scope: !311)
!342 = !DILocation(line: 64, column: 33, scope: !311)
!343 = !DILocation(line: 64, column: 13, scope: !311)
!344 = !DILocation(line: 64, column: 37, scope: !311)
!345 = !DILocation(line: 63, column: 76, scope: !311)
!346 = !DILocation(line: 64, column: 55, scope: !311)
!347 = !DILocation(line: 64, column: 59, scope: !311)
!348 = !DILocation(line: 64, column: 65, scope: !311)
!349 = !DILocation(line: 64, column: 45, scope: !311)
!350 = !DILocation(line: 64, column: 43, scope: !311)
!351 = !DILocation(line: 63, column: 5, scope: !311)
!352 = !DILocation(line: 65, column: 1, scope: !311)
!353 = distinct !DISubprogram(name: "read_tag", scope: !2, file: !2, line: 70, type: !312, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !9, retainedNodes: !50)
!354 = !DILocalVariable(name: "buf", arg: 1, scope: !353, file: !2, line: 70, type: !96)
!355 = !DILocation(line: 70, column: 41, scope: !353)
!356 = !DILocalVariable(name: "offset", arg: 2, scope: !353, file: !2, line: 70, type: !16)
!357 = !DILocation(line: 70, column: 50, scope: !353)
!358 = !DILocalVariable(name: "buf_size", arg: 3, scope: !353, file: !2, line: 70, type: !16)
!359 = !DILocation(line: 70, column: 62, scope: !353)
!360 = !DILocation(line: 71, column: 9, scope: !361)
!361 = distinct !DILexicalBlock(scope: !353, file: !2, line: 71, column: 9)
!362 = !DILocation(line: 71, column: 16, scope: !361)
!363 = !DILocation(line: 71, column: 20, scope: !361)
!364 = !DILocation(line: 71, column: 23, scope: !361)
!365 = !DILocation(line: 71, column: 30, scope: !361)
!366 = !DILocation(line: 71, column: 36, scope: !361)
!367 = !DILocation(line: 71, column: 34, scope: !361)
!368 = !DILocation(line: 71, column: 9, scope: !353)
!369 = !DILocation(line: 71, column: 46, scope: !361)
!370 = !DILocation(line: 72, column: 23, scope: !353)
!371 = !DILocation(line: 72, column: 27, scope: !353)
!372 = !DILocation(line: 72, column: 13, scope: !353)
!373 = !DILocation(line: 72, column: 49, scope: !353)
!374 = !DILocation(line: 72, column: 53, scope: !353)
!375 = !DILocation(line: 72, column: 59, scope: !353)
!376 = !DILocation(line: 72, column: 39, scope: !353)
!377 = !DILocation(line: 72, column: 63, scope: !353)
!378 = !DILocation(line: 72, column: 36, scope: !353)
!379 = !DILocation(line: 73, column: 23, scope: !353)
!380 = !DILocation(line: 73, column: 27, scope: !353)
!381 = !DILocation(line: 73, column: 33, scope: !353)
!382 = !DILocation(line: 73, column: 13, scope: !353)
!383 = !DILocation(line: 73, column: 37, scope: !353)
!384 = !DILocation(line: 72, column: 69, scope: !353)
!385 = !DILocation(line: 73, column: 57, scope: !353)
!386 = !DILocation(line: 73, column: 61, scope: !353)
!387 = !DILocation(line: 73, column: 67, scope: !353)
!388 = !DILocation(line: 73, column: 47, scope: !353)
!389 = !DILocation(line: 73, column: 71, scope: !353)
!390 = !DILocation(line: 73, column: 44, scope: !353)
!391 = !DILocation(line: 72, column: 5, scope: !353)
!392 = !DILocation(line: 74, column: 1, scope: !353)
!393 = distinct !DISubprogram(name: "find_child_atom", scope: !2, file: !2, line: 188, type: !394, scopeLine: 191, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !9, retainedNodes: !50)
!394 = !DISubroutineType(types: !395)
!395 = !{!16, !96, !16, !16, !16, !11, !98, !98}
!396 = !DILocalVariable(name: "buf", arg: 1, scope: !393, file: !2, line: 188, type: !96)
!397 = !DILocation(line: 188, column: 43, scope: !393)
!398 = !DILocalVariable(name: "buf_size", arg: 2, scope: !393, file: !2, line: 188, type: !16)
!399 = !DILocation(line: 188, column: 52, scope: !393)
!400 = !DILocalVariable(name: "parent_offset", arg: 3, scope: !393, file: !2, line: 189, type: !16)
!401 = !DILocation(line: 189, column: 32, scope: !393)
!402 = !DILocalVariable(name: "parent_size", arg: 4, scope: !393, file: !2, line: 189, type: !16)
!403 = !DILocation(line: 189, column: 51, scope: !393)
!404 = !DILocalVariable(name: "target_tag", arg: 5, scope: !393, file: !2, line: 190, type: !11)
!405 = !DILocation(line: 190, column: 37, scope: !393)
!406 = !DILocalVariable(name: "child_offset", arg: 6, scope: !393, file: !2, line: 191, type: !98)
!407 = !DILocation(line: 191, column: 33, scope: !393)
!408 = !DILocalVariable(name: "child_size", arg: 7, scope: !393, file: !2, line: 191, type: !98)
!409 = !DILocation(line: 191, column: 52, scope: !393)
!410 = !DILocation(line: 192, column: 9, scope: !411)
!411 = distinct !DILexicalBlock(scope: !393, file: !2, line: 192, column: 9)
!412 = !DILocation(line: 192, column: 23, scope: !411)
!413 = !DILocation(line: 192, column: 27, scope: !411)
!414 = !DILocation(line: 192, column: 30, scope: !411)
!415 = !DILocation(line: 192, column: 46, scope: !411)
!416 = !DILocation(line: 192, column: 44, scope: !411)
!417 = !DILocation(line: 192, column: 60, scope: !411)
!418 = !DILocation(line: 192, column: 58, scope: !411)
!419 = !DILocation(line: 192, column: 9, scope: !393)
!420 = !DILocation(line: 193, column: 9, scope: !411)
!421 = !DILocalVariable(name: "pos", scope: !393, file: !2, line: 195, type: !16)
!422 = !DILocation(line: 195, column: 9, scope: !393)
!423 = !DILocation(line: 195, column: 15, scope: !393)
!424 = !DILocalVariable(name: "end", scope: !393, file: !2, line: 196, type: !16)
!425 = !DILocation(line: 196, column: 9, scope: !393)
!426 = !DILocation(line: 196, column: 15, scope: !393)
!427 = !DILocation(line: 196, column: 31, scope: !393)
!428 = !DILocation(line: 196, column: 29, scope: !393)
!429 = !DILocation(line: 197, column: 5, scope: !393)
!430 = !DILocation(line: 197, column: 12, scope: !393)
!431 = !DILocation(line: 197, column: 16, scope: !393)
!432 = !DILocation(line: 197, column: 23, scope: !393)
!433 = !DILocation(line: 197, column: 20, scope: !393)
!434 = !DILocalVariable(name: "size", scope: !435, file: !2, line: 198, type: !11)
!435 = distinct !DILexicalBlock(scope: !393, file: !2, line: 197, column: 28)
!436 = !DILocation(line: 198, column: 18, scope: !435)
!437 = !DILocalVariable(name: "tag", scope: !435, file: !2, line: 198, type: !11)
!438 = !DILocation(line: 198, column: 24, scope: !435)
!439 = !DILocation(line: 199, column: 30, scope: !440)
!440 = distinct !DILexicalBlock(scope: !435, file: !2, line: 199, column: 13)
!441 = !DILocation(line: 199, column: 35, scope: !440)
!442 = !DILocation(line: 199, column: 45, scope: !440)
!443 = !DILocation(line: 199, column: 13, scope: !440)
!444 = !DILocation(line: 199, column: 63, scope: !440)
!445 = !DILocation(line: 199, column: 13, scope: !435)
!446 = !DILocation(line: 200, column: 13, scope: !440)
!447 = !DILocation(line: 201, column: 13, scope: !448)
!448 = distinct !DILexicalBlock(scope: !435, file: !2, line: 201, column: 13)
!449 = !DILocation(line: 201, column: 20, scope: !448)
!450 = !DILocation(line: 201, column: 17, scope: !448)
!451 = !DILocation(line: 201, column: 13, scope: !435)
!452 = !DILocation(line: 202, column: 29, scope: !453)
!453 = distinct !DILexicalBlock(scope: !448, file: !2, line: 201, column: 32)
!454 = !DILocation(line: 202, column: 33, scope: !453)
!455 = !DILocation(line: 202, column: 14, scope: !453)
!456 = !DILocation(line: 202, column: 27, scope: !453)
!457 = !DILocation(line: 203, column: 27, scope: !453)
!458 = !DILocation(line: 203, column: 32, scope: !453)
!459 = !DILocation(line: 203, column: 14, scope: !453)
!460 = !DILocation(line: 203, column: 25, scope: !453)
!461 = !DILocation(line: 204, column: 13, scope: !453)
!462 = !DILocation(line: 206, column: 16, scope: !435)
!463 = !DILocation(line: 206, column: 13, scope: !435)
!464 = distinct !{!464, !429, !465, !157}
!465 = !DILocation(line: 207, column: 5, scope: !393)
!466 = !DILocation(line: 208, column: 5, scope: !393)
!467 = !DILocation(line: 209, column: 1, scope: !393)
!468 = distinct !DISubprogram(name: "parse_stsd", scope: !2, file: !2, line: 140, type: !226, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !9, retainedNodes: !50)
!469 = !DILocalVariable(name: "buf", arg: 1, scope: !468, file: !2, line: 140, type: !96)
!470 = !DILocation(line: 140, column: 38, scope: !468)
!471 = !DILocalVariable(name: "buf_size", arg: 2, scope: !468, file: !2, line: 140, type: !16)
!472 = !DILocation(line: 140, column: 47, scope: !468)
!473 = !DILocalVariable(name: "offset", arg: 3, scope: !468, file: !2, line: 141, type: !16)
!474 = !DILocation(line: 141, column: 27, scope: !468)
!475 = !DILocalVariable(name: "size", arg: 4, scope: !468, file: !2, line: 141, type: !16)
!476 = !DILocation(line: 141, column: 39, scope: !468)
!477 = !DILocalVariable(name: "codec_id", arg: 5, scope: !468, file: !2, line: 141, type: !98)
!478 = !DILocation(line: 141, column: 50, scope: !468)
!479 = !DILocation(line: 142, column: 9, scope: !480)
!480 = distinct !DILexicalBlock(scope: !468, file: !2, line: 142, column: 9)
!481 = !DILocation(line: 142, column: 14, scope: !480)
!482 = !DILocation(line: 142, column: 19, scope: !480)
!483 = !DILocation(line: 142, column: 36, scope: !480)
!484 = !DILocation(line: 142, column: 45, scope: !480)
!485 = !DILocation(line: 142, column: 43, scope: !480)
!486 = !DILocation(line: 142, column: 52, scope: !480)
!487 = !DILocation(line: 142, column: 50, scope: !480)
!488 = !DILocation(line: 142, column: 9, scope: !468)
!489 = !DILocation(line: 143, column: 9, scope: !480)
!490 = !DILocalVariable(name: "entry_count", scope: !468, file: !2, line: 145, type: !11)
!491 = !DILocation(line: 145, column: 14, scope: !468)
!492 = !DILocation(line: 145, column: 38, scope: !468)
!493 = !DILocation(line: 145, column: 43, scope: !468)
!494 = !DILocation(line: 145, column: 51, scope: !468)
!495 = !DILocation(line: 145, column: 28, scope: !468)
!496 = !DILocation(line: 146, column: 9, scope: !497)
!497 = distinct !DILexicalBlock(scope: !468, file: !2, line: 146, column: 9)
!498 = !DILocation(line: 146, column: 21, scope: !497)
!499 = !DILocation(line: 146, column: 25, scope: !497)
!500 = !DILocation(line: 147, column: 9, scope: !497)
!501 = !DILocalVariable(name: "entry_offset", scope: !468, file: !2, line: 149, type: !16)
!502 = !DILocation(line: 149, column: 9, scope: !468)
!503 = !DILocation(line: 149, column: 24, scope: !468)
!504 = !DILocation(line: 149, column: 31, scope: !468)
!505 = !DILocalVariable(name: "i", scope: !506, file: !2, line: 150, type: !11)
!506 = distinct !DILexicalBlock(scope: !468, file: !2, line: 150, column: 5)
!507 = !DILocation(line: 150, column: 19, scope: !506)
!508 = !DILocation(line: 150, column: 10, scope: !506)
!509 = !DILocation(line: 150, column: 26, scope: !510)
!510 = distinct !DILexicalBlock(scope: !506, file: !2, line: 150, column: 5)
!511 = !DILocation(line: 150, column: 30, scope: !510)
!512 = !DILocation(line: 150, column: 28, scope: !510)
!513 = !DILocation(line: 150, column: 5, scope: !506)
!514 = !DILocation(line: 151, column: 13, scope: !515)
!515 = distinct !DILexicalBlock(scope: !516, file: !2, line: 151, column: 13)
!516 = distinct !DILexicalBlock(scope: !510, file: !2, line: 150, column: 48)
!517 = !DILocation(line: 151, column: 26, scope: !515)
!518 = !DILocation(line: 151, column: 32, scope: !515)
!519 = !DILocation(line: 151, column: 41, scope: !515)
!520 = !DILocation(line: 151, column: 39, scope: !515)
!521 = !DILocation(line: 151, column: 30, scope: !515)
!522 = !DILocation(line: 151, column: 13, scope: !516)
!523 = !DILocation(line: 152, column: 13, scope: !515)
!524 = !DILocalVariable(name: "entry_size", scope: !516, file: !2, line: 154, type: !11)
!525 = !DILocation(line: 154, column: 18, scope: !516)
!526 = !DILocation(line: 154, column: 41, scope: !516)
!527 = !DILocation(line: 154, column: 46, scope: !516)
!528 = !DILocation(line: 154, column: 60, scope: !516)
!529 = !DILocation(line: 154, column: 31, scope: !516)
!530 = !DILocalVariable(name: "format", scope: !516, file: !2, line: 155, type: !11)
!531 = !DILocation(line: 155, column: 18, scope: !516)
!532 = !DILocation(line: 155, column: 40, scope: !516)
!533 = !DILocation(line: 155, column: 45, scope: !516)
!534 = !DILocation(line: 155, column: 58, scope: !516)
!535 = !DILocation(line: 155, column: 63, scope: !516)
!536 = !DILocation(line: 155, column: 31, scope: !516)
!537 = !DILocation(line: 157, column: 13, scope: !538)
!538 = distinct !DILexicalBlock(scope: !516, file: !2, line: 157, column: 13)
!539 = !DILocation(line: 157, column: 24, scope: !538)
!540 = !DILocation(line: 157, column: 28, scope: !538)
!541 = !DILocation(line: 157, column: 31, scope: !538)
!542 = !DILocation(line: 157, column: 51, scope: !538)
!543 = !DILocation(line: 157, column: 44, scope: !538)
!544 = !DILocation(line: 157, column: 64, scope: !538)
!545 = !DILocation(line: 157, column: 73, scope: !538)
!546 = !DILocation(line: 157, column: 71, scope: !538)
!547 = !DILocation(line: 157, column: 62, scope: !538)
!548 = !DILocation(line: 157, column: 13, scope: !516)
!549 = !DILocation(line: 158, column: 13, scope: !538)
!550 = !DILocation(line: 160, column: 13, scope: !551)
!551 = distinct !DILexicalBlock(scope: !516, file: !2, line: 160, column: 13)
!552 = !DILocation(line: 160, column: 20, scope: !551)
!553 = !DILocation(line: 160, column: 13, scope: !516)
!554 = !DILocation(line: 161, column: 14, scope: !555)
!555 = distinct !DILexicalBlock(scope: !551, file: !2, line: 160, column: 36)
!556 = !DILocation(line: 161, column: 23, scope: !555)
!557 = !DILocalVariable(name: "sub_offset", scope: !555, file: !2, line: 165, type: !16)
!558 = !DILocation(line: 165, column: 17, scope: !555)
!559 = !DILocation(line: 165, column: 30, scope: !555)
!560 = !DILocation(line: 165, column: 43, scope: !555)
!561 = !DILocation(line: 166, column: 13, scope: !555)
!562 = !DILocation(line: 166, column: 20, scope: !555)
!563 = !DILocation(line: 166, column: 31, scope: !555)
!564 = !DILocation(line: 166, column: 38, scope: !555)
!565 = !DILocation(line: 166, column: 58, scope: !555)
!566 = !DILocation(line: 166, column: 51, scope: !555)
!567 = !DILocation(line: 166, column: 35, scope: !555)
!568 = !DILocalVariable(name: "sub_size", scope: !569, file: !2, line: 167, type: !11)
!569 = distinct !DILexicalBlock(scope: !555, file: !2, line: 166, column: 70)
!570 = !DILocation(line: 167, column: 26, scope: !569)
!571 = !DILocalVariable(name: "sub_tag", scope: !569, file: !2, line: 167, type: !11)
!572 = !DILocation(line: 167, column: 36, scope: !569)
!573 = !DILocation(line: 168, column: 38, scope: !574)
!574 = distinct !DILexicalBlock(scope: !569, file: !2, line: 168, column: 21)
!575 = !DILocation(line: 168, column: 43, scope: !574)
!576 = !DILocation(line: 168, column: 53, scope: !574)
!577 = !DILocation(line: 168, column: 21, scope: !574)
!578 = !DILocation(line: 168, column: 86, scope: !574)
!579 = !DILocation(line: 168, column: 21, scope: !569)
!580 = !DILocation(line: 170, column: 21, scope: !581)
!581 = distinct !DILexicalBlock(scope: !569, file: !2, line: 170, column: 21)
!582 = !DILocation(line: 170, column: 29, scope: !581)
!583 = !DILocation(line: 170, column: 21, scope: !569)
!584 = !DILocation(line: 171, column: 36, scope: !585)
!585 = distinct !DILexicalBlock(scope: !586, file: !2, line: 171, column: 25)
!586 = distinct !DILexicalBlock(scope: !581, file: !2, line: 170, column: 42)
!587 = !DILocation(line: 171, column: 41, scope: !585)
!588 = !DILocation(line: 171, column: 51, scope: !585)
!589 = !DILocation(line: 171, column: 62, scope: !585)
!590 = !DILocation(line: 171, column: 67, scope: !585)
!591 = !DILocation(line: 171, column: 76, scope: !585)
!592 = !DILocation(line: 171, column: 25, scope: !585)
!593 = !DILocation(line: 171, column: 81, scope: !585)
!594 = !DILocation(line: 171, column: 25, scope: !586)
!595 = !DILocation(line: 172, column: 25, scope: !585)
!596 = !DILocation(line: 173, column: 21, scope: !586)
!597 = !DILocation(line: 175, column: 31, scope: !569)
!598 = !DILocation(line: 175, column: 28, scope: !569)
!599 = distinct !{!599, !561, !600, !157}
!600 = !DILocation(line: 176, column: 13, scope: !555)
!601 = !DILocation(line: 177, column: 13, scope: !555)
!602 = !DILocation(line: 180, column: 25, scope: !516)
!603 = !DILocation(line: 180, column: 22, scope: !516)
!604 = !DILocation(line: 150, column: 44, scope: !510)
!605 = !DILocation(line: 150, column: 5, scope: !510)
!606 = distinct !{!606, !513, !607, !157}
!607 = !DILocation(line: 181, column: 5, scope: !506)
!608 = !DILocation(line: 182, column: 5, scope: !468)
!609 = !DILocation(line: 183, column: 1, scope: !468)
!610 = distinct !DISubprogram(name: "parse_avcC", scope: !2, file: !2, line: 93, type: !611, scopeLine: 94, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !9, retainedNodes: !50)
!611 = !DISubroutineType(types: !612)
!612 = !{!16, !96, !16, !16, !16}
!613 = !DILocalVariable(name: "buf", arg: 1, scope: !610, file: !2, line: 93, type: !96)
!614 = !DILocation(line: 93, column: 38, scope: !610)
!615 = !DILocalVariable(name: "buf_size", arg: 2, scope: !610, file: !2, line: 93, type: !16)
!616 = !DILocation(line: 93, column: 47, scope: !610)
!617 = !DILocalVariable(name: "offset", arg: 3, scope: !610, file: !2, line: 94, type: !16)
!618 = !DILocation(line: 94, column: 27, scope: !610)
!619 = !DILocalVariable(name: "size", arg: 4, scope: !610, file: !2, line: 94, type: !16)
!620 = !DILocation(line: 94, column: 39, scope: !610)
!621 = !DILocation(line: 95, column: 9, scope: !622)
!622 = distinct !DILexicalBlock(scope: !610, file: !2, line: 95, column: 9)
!623 = !DILocation(line: 95, column: 14, scope: !622)
!624 = !DILocation(line: 95, column: 18, scope: !622)
!625 = !DILocation(line: 95, column: 35, scope: !622)
!626 = !DILocation(line: 95, column: 44, scope: !622)
!627 = !DILocation(line: 95, column: 42, scope: !622)
!628 = !DILocation(line: 95, column: 51, scope: !622)
!629 = !DILocation(line: 95, column: 49, scope: !622)
!630 = !DILocation(line: 95, column: 9, scope: !610)
!631 = !DILocation(line: 96, column: 9, scope: !622)
!632 = !DILocalVariable(name: "version", scope: !610, file: !2, line: 98, type: !57)
!633 = !DILocation(line: 98, column: 13, scope: !610)
!634 = !DILocation(line: 98, column: 23, scope: !610)
!635 = !DILocation(line: 98, column: 27, scope: !610)
!636 = !DILocation(line: 99, column: 9, scope: !637)
!637 = distinct !DILexicalBlock(scope: !610, file: !2, line: 99, column: 9)
!638 = !DILocation(line: 99, column: 17, scope: !637)
!639 = !DILocation(line: 99, column: 9, scope: !610)
!640 = !DILocation(line: 100, column: 9, scope: !637)
!641 = !DILocalVariable(name: "profile", scope: !610, file: !2, line: 102, type: !57)
!642 = !DILocation(line: 102, column: 13, scope: !610)
!643 = !DILocation(line: 102, column: 23, scope: !610)
!644 = !DILocation(line: 102, column: 27, scope: !610)
!645 = !DILocation(line: 102, column: 34, scope: !610)
!646 = !DILocation(line: 103, column: 9, scope: !647)
!647 = distinct !DILexicalBlock(scope: !610, file: !2, line: 103, column: 9)
!648 = !DILocation(line: 103, column: 17, scope: !647)
!649 = !DILocation(line: 103, column: 23, scope: !647)
!650 = !DILocation(line: 103, column: 26, scope: !647)
!651 = !DILocation(line: 103, column: 34, scope: !647)
!652 = !DILocation(line: 103, column: 40, scope: !647)
!653 = !DILocation(line: 103, column: 43, scope: !647)
!654 = !DILocation(line: 103, column: 51, scope: !647)
!655 = !DILocation(line: 103, column: 57, scope: !647)
!656 = !DILocation(line: 104, column: 9, scope: !647)
!657 = !DILocation(line: 104, column: 17, scope: !647)
!658 = !DILocation(line: 104, column: 24, scope: !647)
!659 = !DILocation(line: 104, column: 27, scope: !647)
!660 = !DILocation(line: 104, column: 35, scope: !647)
!661 = !DILocation(line: 104, column: 42, scope: !647)
!662 = !DILocation(line: 104, column: 45, scope: !647)
!663 = !DILocation(line: 104, column: 53, scope: !647)
!664 = !DILocation(line: 103, column: 9, scope: !610)
!665 = !DILocation(line: 105, column: 9, scope: !647)
!666 = !DILocalVariable(name: "nal_length_size", scope: !610, file: !2, line: 107, type: !57)
!667 = !DILocation(line: 107, column: 13, scope: !610)
!668 = !DILocation(line: 107, column: 32, scope: !610)
!669 = !DILocation(line: 107, column: 36, scope: !610)
!670 = !DILocation(line: 107, column: 43, scope: !610)
!671 = !DILocation(line: 107, column: 48, scope: !610)
!672 = !DILocation(line: 107, column: 56, scope: !610)
!673 = !DILocation(line: 107, column: 31, scope: !610)
!674 = !DILocation(line: 108, column: 9, scope: !675)
!675 = distinct !DILexicalBlock(scope: !610, file: !2, line: 108, column: 9)
!676 = !DILocation(line: 108, column: 25, scope: !675)
!677 = !DILocation(line: 108, column: 30, scope: !675)
!678 = !DILocation(line: 108, column: 33, scope: !675)
!679 = !DILocation(line: 108, column: 49, scope: !675)
!680 = !DILocation(line: 108, column: 54, scope: !675)
!681 = !DILocation(line: 108, column: 57, scope: !675)
!682 = !DILocation(line: 108, column: 73, scope: !675)
!683 = !DILocation(line: 108, column: 9, scope: !610)
!684 = !DILocation(line: 109, column: 9, scope: !675)
!685 = !DILocalVariable(name: "num_sps", scope: !610, file: !2, line: 111, type: !57)
!686 = !DILocation(line: 111, column: 13, scope: !610)
!687 = !DILocation(line: 111, column: 23, scope: !610)
!688 = !DILocation(line: 111, column: 27, scope: !610)
!689 = !DILocation(line: 111, column: 34, scope: !610)
!690 = !DILocation(line: 111, column: 39, scope: !610)
!691 = !DILocation(line: 112, column: 9, scope: !692)
!692 = distinct !DILexicalBlock(scope: !610, file: !2, line: 112, column: 9)
!693 = !DILocation(line: 112, column: 17, scope: !692)
!694 = !DILocation(line: 112, column: 21, scope: !692)
!695 = !DILocation(line: 112, column: 24, scope: !692)
!696 = !DILocation(line: 112, column: 32, scope: !692)
!697 = !DILocation(line: 112, column: 9, scope: !610)
!698 = !DILocation(line: 113, column: 9, scope: !692)
!699 = !DILocalVariable(name: "sps_offset", scope: !610, file: !2, line: 115, type: !16)
!700 = !DILocation(line: 115, column: 9, scope: !610)
!701 = !DILocation(line: 115, column: 22, scope: !610)
!702 = !DILocation(line: 115, column: 29, scope: !610)
!703 = !DILocalVariable(name: "i", scope: !704, file: !2, line: 116, type: !16)
!704 = distinct !DILexicalBlock(scope: !610, file: !2, line: 116, column: 5)
!705 = !DILocation(line: 116, column: 14, scope: !704)
!706 = !DILocation(line: 116, column: 10, scope: !704)
!707 = !DILocation(line: 116, column: 21, scope: !708)
!708 = distinct !DILexicalBlock(scope: !704, file: !2, line: 116, column: 5)
!709 = !DILocation(line: 116, column: 25, scope: !708)
!710 = !DILocation(line: 116, column: 23, scope: !708)
!711 = !DILocation(line: 116, column: 5, scope: !704)
!712 = !DILocation(line: 117, column: 13, scope: !713)
!713 = distinct !DILexicalBlock(scope: !714, file: !2, line: 117, column: 13)
!714 = distinct !DILexicalBlock(scope: !708, file: !2, line: 116, column: 39)
!715 = !DILocation(line: 117, column: 24, scope: !713)
!716 = !DILocation(line: 117, column: 30, scope: !713)
!717 = !DILocation(line: 117, column: 39, scope: !713)
!718 = !DILocation(line: 117, column: 37, scope: !713)
!719 = !DILocation(line: 117, column: 28, scope: !713)
!720 = !DILocation(line: 117, column: 13, scope: !714)
!721 = !DILocation(line: 118, column: 13, scope: !713)
!722 = !DILocalVariable(name: "sps_size", scope: !714, file: !2, line: 119, type: !17)
!723 = !DILocation(line: 119, column: 18, scope: !714)
!724 = !DILocation(line: 119, column: 40, scope: !714)
!725 = !DILocation(line: 119, column: 44, scope: !714)
!726 = !DILocation(line: 119, column: 30, scope: !714)
!727 = !DILocation(line: 119, column: 56, scope: !714)
!728 = !DILocation(line: 119, column: 64, scope: !714)
!729 = !DILocation(line: 119, column: 68, scope: !714)
!730 = !DILocation(line: 119, column: 79, scope: !714)
!731 = !DILocation(line: 119, column: 62, scope: !714)
!732 = !DILocation(line: 119, column: 29, scope: !714)
!733 = !DILocation(line: 120, column: 13, scope: !734)
!734 = distinct !DILexicalBlock(scope: !714, file: !2, line: 120, column: 13)
!735 = !DILocation(line: 120, column: 22, scope: !734)
!736 = !DILocation(line: 120, column: 27, scope: !734)
!737 = !DILocation(line: 120, column: 30, scope: !734)
!738 = !DILocation(line: 120, column: 39, scope: !734)
!739 = !DILocation(line: 120, column: 45, scope: !734)
!740 = !DILocation(line: 120, column: 48, scope: !734)
!741 = !DILocation(line: 120, column: 59, scope: !734)
!742 = !DILocation(line: 120, column: 65, scope: !734)
!743 = !DILocation(line: 120, column: 63, scope: !734)
!744 = !DILocation(line: 120, column: 76, scope: !734)
!745 = !DILocation(line: 120, column: 85, scope: !734)
!746 = !DILocation(line: 120, column: 83, scope: !734)
!747 = !DILocation(line: 120, column: 74, scope: !734)
!748 = !DILocation(line: 120, column: 13, scope: !714)
!749 = !DILocation(line: 121, column: 13, scope: !734)
!750 = !DILocation(line: 124, column: 13, scope: !751)
!751 = distinct !DILexicalBlock(scope: !714, file: !2, line: 124, column: 13)
!752 = !DILocation(line: 124, column: 24, scope: !751)
!753 = !DILocation(line: 124, column: 31, scope: !751)
!754 = !DILocation(line: 124, column: 28, scope: !751)
!755 = !DILocation(line: 124, column: 13, scope: !714)
!756 = !DILocation(line: 125, column: 13, scope: !751)
!757 = !DILocalVariable(name: "nal_type", scope: !714, file: !2, line: 126, type: !57)
!758 = !DILocation(line: 126, column: 17, scope: !714)
!759 = !DILocation(line: 126, column: 28, scope: !714)
!760 = !DILocation(line: 126, column: 32, scope: !714)
!761 = !DILocation(line: 126, column: 43, scope: !714)
!762 = !DILocation(line: 126, column: 48, scope: !714)
!763 = !DILocation(line: 127, column: 13, scope: !764)
!764 = distinct !DILexicalBlock(scope: !714, file: !2, line: 127, column: 13)
!765 = !DILocation(line: 127, column: 22, scope: !764)
!766 = !DILocation(line: 127, column: 13, scope: !714)
!767 = !DILocation(line: 128, column: 13, scope: !764)
!768 = !DILocation(line: 130, column: 27, scope: !714)
!769 = !DILocation(line: 130, column: 25, scope: !714)
!770 = !DILocation(line: 130, column: 20, scope: !714)
!771 = !DILocation(line: 116, column: 35, scope: !708)
!772 = !DILocation(line: 116, column: 5, scope: !708)
!773 = distinct !{!773, !711, !774, !157}
!774 = !DILocation(line: 131, column: 5, scope: !704)
!775 = !DILocation(line: 134, column: 5, scope: !610)
!776 = !DILocation(line: 135, column: 1, scope: !610)

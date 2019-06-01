@.QuickSort_vtable = global [0 x i8*] []
@.QS_vtable = global [4 x i8*] [i8* bitcast (i32 (i8*, i32)* @QS.Start to i8*), i8* bitcast (i32 (i8*, i32, i32)* @QS.Sort to i8*), i8* bitcast (i32 (i8*)* @QS.Print to i8*), i8* bitcast (i32 (i8*, i32)* @QS.Init to i8*)]


declare i8* @calloc(i32, i32)
declare i32 @printf(i8*, ...)
declare void @exit(i32)

@_cint = constant [4 x i8] c"%d\0a\00"
@_cOOB = constant [15 x i8] c"Out of bounds\0a\00"
define void @print_int(i32 %i) {
	%_str = bitcast [4 x i8]* @_cint to i8*
	call i32 (i8*, ...) @printf(i8* %_str, i32 %i)
	ret void
}

define void @throw_oob() {
	%_str = bitcast [15 x i8]* @_cOOB to i8*
	call i32 (i8*, ...) @printf(i8* %_str)
	call void @exit(i32 1)
	ret void
}

define i32 @main() {
	%_0 = call i8* @calloc(i32 1, i32 20)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [4 x i8*], [4 x i8*]* @.QS_vtable, i32 0, i32 0
	store i8** %_2, i8*** %_1
	%_3 = bitcast i8* %_0 to i8***
	%_4 = load i8**, i8*** %_3
	%_5 = getelementptr i8*, i8** %_4, i32 0
	%_6 = load i8*, i8** %_5
	%_7 = bitcast i8* %_6 to i32 (i8*, i32)*
	%_8 = call i32 %_7(i8* %_0, i32 10)
	call void (i32) @print_int(i32 %_8)
	ret i32 0
}

define i32 @QS.Start(i8* %this, i32 %.sz) {
	%sz = alloca i32
	store i32 %.sz, i32* %sz
	%aux01 = alloca i32
	%_9 = load i32, i32* %sz
	%_10 = bitcast i8* %this to i8***
	%_11 = load i8**, i8*** %_10
	%_12 = getelementptr i8*, i8** %_11, i32 3
	%_13 = load i8*, i8** %_12
	%_14 = bitcast i8* %_13 to i32 (i8*, i32)*
	%_15 = call i32 %_14(i8* %this, i32 %_9)
	store i32 %_15, i32* %aux01
	%_16 = bitcast i8* %this to i8***
	%_17 = load i8**, i8*** %_16
	%_18 = getelementptr i8*, i8** %_17, i32 2
	%_19 = load i8*, i8** %_18
	%_20 = bitcast i8* %_19 to i32 (i8*)*
	%_21 = call i32 %_20(i8* %this)
	store i32 %_21, i32* %aux01
	call void (i32) @print_int(i32 9999)
	%_23 = getelementptr i8, i8* %this, i32 16
	%_24 = bitcast i8* %_23 to i32*
	%_22 = load i32, i32* %_24
	%_25 = sub i32 %_22, 1
	store i32 %_25, i32* %aux01
	%_26 = load i32, i32* %aux01
	%_27 = bitcast i8* %this to i8***
	%_28 = load i8**, i8*** %_27
	%_29 = getelementptr i8*, i8** %_28, i32 1
	%_30 = load i8*, i8** %_29
	%_31 = bitcast i8* %_30 to i32 (i8*, i32, i32)*
	%_32 = call i32 %_31(i8* %this, i32 0, i32 %_26)
	store i32 %_32, i32* %aux01
	%_33 = bitcast i8* %this to i8***
	%_34 = load i8**, i8*** %_33
	%_35 = getelementptr i8*, i8** %_34, i32 2
	%_36 = load i8*, i8** %_35
	%_37 = bitcast i8* %_36 to i32 (i8*)*
	%_38 = call i32 %_37(i8* %this)
	store i32 %_38, i32* %aux01
	ret i32 0
}

define i32 @QS.Sort(i8* %this, i32 %.left, i32 %.right) {
	%left = alloca i32
	store i32 %.left, i32* %left
	%right = alloca i32
	store i32 %.right, i32* %right
	%v = alloca i32
	%i = alloca i32
	%j = alloca i32
	%nt = alloca i32
	%t = alloca i32
	%cont01 = alloca i1
	%cont02 = alloca i1
	%aux03 = alloca i32
	store i32 0, i32* %t
	%_39 = load i32, i32* %left
	%_40 = load i32, i32* %right
	%_41 = icmp slt i32 %_39, %_40
	br i1 %_41, label %if0, label %if1
if0:
	%_43 = getelementptr i8, i8* %this, i32 8
	%_44 = bitcast i8* %_43 to i32**
	%_42 = load i32*, i32** %_44
	%_45 = load i32, i32* %right
	%_46 = load i32, i32* %_42
	%_47 = icmp ule i32 %_46, %_45
	br i1 %_47, label %oob0, label %oob1
oob0:
	call void @throw_oob()
	br label %oob1
oob1:
	%_48 = add i32 %_45, 1
	%_49 = getelementptr i32, i32* %_42, i32 %_48
	%_50 = load i32, i32* %_49
	store i32 %_50, i32* %v
	%_51 = load i32, i32* %left
	%_52 = sub i32 %_51, 1
	store i32 %_52, i32* %i
	%_53 = load i32, i32* %right
	store i32 %_53, i32* %j
	store i1 1, i1* %cont01
	br label %loop0
loop0:
	%_54 = load i1, i1* %cont01
	br i1 %_54, label %loop1, label %loop2
loop1:
	store i1 1, i1* %cont02
	br label %loop3
loop3:
	%_55 = load i1, i1* %cont02
	br i1 %_55, label %loop4, label %loop5
loop4:
	%_56 = load i32, i32* %i
	%_57 = add i32 %_56, 1
	store i32 %_57, i32* %i
	%_59 = getelementptr i8, i8* %this, i32 8
	%_60 = bitcast i8* %_59 to i32**
	%_58 = load i32*, i32** %_60
	%_61 = load i32, i32* %i
	%_62 = load i32, i32* %_58
	%_63 = icmp ule i32 %_62, %_61
	br i1 %_63, label %oob2, label %oob3
oob2:
	call void @throw_oob()
	br label %oob3
oob3:
	%_64 = add i32 %_61, 1
	%_65 = getelementptr i32, i32* %_58, i32 %_64
	%_66 = load i32, i32* %_65
	store i32 %_66, i32* %aux03
	%_67 = load i32, i32* %aux03
	%_68 = load i32, i32* %v
	%_69 = icmp slt i32 %_67, %_68
	%_70 = xor i1 1, %_69
	br i1 %_70, label %if3, label %if4
if3:
	store i1 0, i1* %cont02
	br label %if5
if4:
	store i1 1, i1* %cont02
	br label %if5
if5:
	br label %loop3
loop5:
	store i1 1, i1* %cont02
	br label %loop6
loop6:
	%_71 = load i1, i1* %cont02
	br i1 %_71, label %loop7, label %loop8
loop7:
	%_72 = load i32, i32* %j
	%_73 = sub i32 %_72, 1
	store i32 %_73, i32* %j
	%_75 = getelementptr i8, i8* %this, i32 8
	%_76 = bitcast i8* %_75 to i32**
	%_74 = load i32*, i32** %_76
	%_77 = load i32, i32* %j
	%_78 = load i32, i32* %_74
	%_79 = icmp ule i32 %_78, %_77
	br i1 %_79, label %oob4, label %oob5
oob4:
	call void @throw_oob()
	br label %oob5
oob5:
	%_80 = add i32 %_77, 1
	%_81 = getelementptr i32, i32* %_74, i32 %_80
	%_82 = load i32, i32* %_81
	store i32 %_82, i32* %aux03
	%_83 = load i32, i32* %v
	%_84 = load i32, i32* %aux03
	%_85 = icmp slt i32 %_83, %_84
	%_86 = xor i1 1, %_85
	br i1 %_86, label %if6, label %if7
if6:
	store i1 0, i1* %cont02
	br label %if8
if7:
	store i1 1, i1* %cont02
	br label %if8
if8:
	br label %loop6
loop8:
	%_88 = getelementptr i8, i8* %this, i32 8
	%_89 = bitcast i8* %_88 to i32**
	%_87 = load i32*, i32** %_89
	%_90 = load i32, i32* %i
	%_91 = load i32, i32* %_87
	%_92 = icmp ule i32 %_91, %_90
	br i1 %_92, label %oob6, label %oob7
oob6:
	call void @throw_oob()
	br label %oob7
oob7:
	%_93 = add i32 %_90, 1
	%_94 = getelementptr i32, i32* %_87, i32 %_93
	%_95 = load i32, i32* %_94
	store i32 %_95, i32* %t
	%_96 = load i32, i32* %i
	%_98 = getelementptr i8, i8* %this, i32 8
	%_99 = bitcast i8* %_98 to i32**
	%_97 = load i32*, i32** %_99
	%_100 = load i32, i32* %j
	%_101 = load i32, i32* %_97
	%_102 = icmp ule i32 %_101, %_100
	br i1 %_102, label %oob8, label %oob9
oob8:
	call void @throw_oob()
	br label %oob9
oob9:
	%_103 = add i32 %_100, 1
	%_104 = getelementptr i32, i32* %_97, i32 %_103
	%_105 = load i32, i32* %_104
	%_107 = getelementptr i8, i8* %this, i32 8
	%_108 = bitcast i8* %_107 to i32**
	%_106 = load i32*, i32** %_108
	%_109 = load i32, i32* %_106
	%_110 = icmp ule i32 %_109, %_96
	br i1 %_110, label %oob10, label %oob11
oob10:
	call void @throw_oob()
	br label %oob11
oob11:
	%_111 = add i32 %_96, 1
	%_112 = getelementptr i32, i32* %_106, i32 %_111
	store i32 %_105, i32* %_112
	%_113 = load i32, i32* %j
	%_114 = load i32, i32* %t
	%_116 = getelementptr i8, i8* %this, i32 8
	%_117 = bitcast i8* %_116 to i32**
	%_115 = load i32*, i32** %_117
	%_118 = load i32, i32* %_115
	%_119 = icmp ule i32 %_118, %_113
	br i1 %_119, label %oob12, label %oob13
oob12:
	call void @throw_oob()
	br label %oob13
oob13:
	%_120 = add i32 %_113, 1
	%_121 = getelementptr i32, i32* %_115, i32 %_120
	store i32 %_114, i32* %_121
	%_122 = load i32, i32* %j
	%_123 = load i32, i32* %i
	%_124 = add i32 %_123, 1
	%_125 = icmp slt i32 %_122, %_124
	br i1 %_125, label %if9, label %if10
if9:
	store i1 0, i1* %cont01
	br label %if11
if10:
	store i1 1, i1* %cont01
	br label %if11
if11:
	br label %loop0
loop2:
	%_126 = load i32, i32* %j
	%_128 = getelementptr i8, i8* %this, i32 8
	%_129 = bitcast i8* %_128 to i32**
	%_127 = load i32*, i32** %_129
	%_130 = load i32, i32* %i
	%_131 = load i32, i32* %_127
	%_132 = icmp ule i32 %_131, %_130
	br i1 %_132, label %oob14, label %oob15
oob14:
	call void @throw_oob()
	br label %oob15
oob15:
	%_133 = add i32 %_130, 1
	%_134 = getelementptr i32, i32* %_127, i32 %_133
	%_135 = load i32, i32* %_134
	%_137 = getelementptr i8, i8* %this, i32 8
	%_138 = bitcast i8* %_137 to i32**
	%_136 = load i32*, i32** %_138
	%_139 = load i32, i32* %_136
	%_140 = icmp ule i32 %_139, %_126
	br i1 %_140, label %oob16, label %oob17
oob16:
	call void @throw_oob()
	br label %oob17
oob17:
	%_141 = add i32 %_126, 1
	%_142 = getelementptr i32, i32* %_136, i32 %_141
	store i32 %_135, i32* %_142
	%_143 = load i32, i32* %i
	%_145 = getelementptr i8, i8* %this, i32 8
	%_146 = bitcast i8* %_145 to i32**
	%_144 = load i32*, i32** %_146
	%_147 = load i32, i32* %right
	%_148 = load i32, i32* %_144
	%_149 = icmp ule i32 %_148, %_147
	br i1 %_149, label %oob18, label %oob19
oob18:
	call void @throw_oob()
	br label %oob19
oob19:
	%_150 = add i32 %_147, 1
	%_151 = getelementptr i32, i32* %_144, i32 %_150
	%_152 = load i32, i32* %_151
	%_154 = getelementptr i8, i8* %this, i32 8
	%_155 = bitcast i8* %_154 to i32**
	%_153 = load i32*, i32** %_155
	%_156 = load i32, i32* %_153
	%_157 = icmp ule i32 %_156, %_143
	br i1 %_157, label %oob20, label %oob21
oob20:
	call void @throw_oob()
	br label %oob21
oob21:
	%_158 = add i32 %_143, 1
	%_159 = getelementptr i32, i32* %_153, i32 %_158
	store i32 %_152, i32* %_159
	%_160 = load i32, i32* %right
	%_161 = load i32, i32* %t
	%_163 = getelementptr i8, i8* %this, i32 8
	%_164 = bitcast i8* %_163 to i32**
	%_162 = load i32*, i32** %_164
	%_165 = load i32, i32* %_162
	%_166 = icmp ule i32 %_165, %_160
	br i1 %_166, label %oob22, label %oob23
oob22:
	call void @throw_oob()
	br label %oob23
oob23:
	%_167 = add i32 %_160, 1
	%_168 = getelementptr i32, i32* %_162, i32 %_167
	store i32 %_161, i32* %_168
	%_169 = load i32, i32* %left
	%_170 = load i32, i32* %i
	%_171 = sub i32 %_170, 1
	%_172 = bitcast i8* %this to i8***
	%_173 = load i8**, i8*** %_172
	%_174 = getelementptr i8*, i8** %_173, i32 1
	%_175 = load i8*, i8** %_174
	%_176 = bitcast i8* %_175 to i32 (i8*, i32, i32)*
	%_177 = call i32 %_176(i8* %this, i32 %_169, i32 %_171)
	store i32 %_177, i32* %nt
	%_178 = load i32, i32* %i
	%_179 = add i32 %_178, 1
	%_180 = load i32, i32* %right
	%_181 = bitcast i8* %this to i8***
	%_182 = load i8**, i8*** %_181
	%_183 = getelementptr i8*, i8** %_182, i32 1
	%_184 = load i8*, i8** %_183
	%_185 = bitcast i8* %_184 to i32 (i8*, i32, i32)*
	%_186 = call i32 %_185(i8* %this, i32 %_179, i32 %_180)
	store i32 %_186, i32* %nt
	br label %if2
if1:
	store i32 0, i32* %nt
	br label %if2
if2:
	ret i32 0
}

define i32 @QS.Print(i8* %this) {
	%j = alloca i32
	store i32 0, i32* %j
	br label %loop9
loop9:
	%_187 = load i32, i32* %j
	%_189 = getelementptr i8, i8* %this, i32 16
	%_190 = bitcast i8* %_189 to i32*
	%_188 = load i32, i32* %_190
	%_191 = icmp slt i32 %_187, %_188
	br i1 %_191, label %loop10, label %loop11
loop10:
	%_193 = getelementptr i8, i8* %this, i32 8
	%_194 = bitcast i8* %_193 to i32**
	%_192 = load i32*, i32** %_194
	%_195 = load i32, i32* %j
	%_196 = load i32, i32* %_192
	%_197 = icmp ule i32 %_196, %_195
	br i1 %_197, label %oob24, label %oob25
oob24:
	call void @throw_oob()
	br label %oob25
oob25:
	%_198 = add i32 %_195, 1
	%_199 = getelementptr i32, i32* %_192, i32 %_198
	%_200 = load i32, i32* %_199
	call void (i32) @print_int(i32 %_200)
	%_201 = load i32, i32* %j
	%_202 = add i32 %_201, 1
	store i32 %_202, i32* %j
	br label %loop9
loop11:
	ret i32 0
}

define i32 @QS.Init(i8* %this, i32 %.sz) {
	%sz = alloca i32
	store i32 %.sz, i32* %sz
	%_203 = load i32, i32* %sz
	%_204 = getelementptr i8, i8* %this, i32 16
	%_205 = bitcast i8* %_204 to i32*
	store i32 %_203, i32* %_205
	%_206 = load i32, i32* %sz
	%_207 = icmp slt i32 %_206, 0
	br i1 %_207, label %arr_alloc0, label %arr_alloc1
arr_alloc0:
	call void @throw_oob()
	br label %arr_alloc1
arr_alloc1:
	%_208 = add i32 %_206, 1
	%_209 = call i8* @calloc(i32 4, i32 %_208)
	%_210 = bitcast i8* %_209 to i32*
	store i32 %_206, i32* %_210
	%_211 = getelementptr i8, i8* %this, i32 8
	%_212 = bitcast i8* %_211 to i32**
	store i32* %_210, i32** %_212
	%_214 = getelementptr i8, i8* %this, i32 8
	%_215 = bitcast i8* %_214 to i32**
	%_213 = load i32*, i32** %_215
	%_216 = load i32, i32* %_213
	%_217 = icmp ule i32 %_216, 0
	br i1 %_217, label %oob26, label %oob27
oob26:
	call void @throw_oob()
	br label %oob27
oob27:
	%_218 = add i32 0, 1
	%_219 = getelementptr i32, i32* %_213, i32 %_218
	store i32 20, i32* %_219
	%_221 = getelementptr i8, i8* %this, i32 8
	%_222 = bitcast i8* %_221 to i32**
	%_220 = load i32*, i32** %_222
	%_223 = load i32, i32* %_220
	%_224 = icmp ule i32 %_223, 1
	br i1 %_224, label %oob28, label %oob29
oob28:
	call void @throw_oob()
	br label %oob29
oob29:
	%_225 = add i32 1, 1
	%_226 = getelementptr i32, i32* %_220, i32 %_225
	store i32 7, i32* %_226
	%_228 = getelementptr i8, i8* %this, i32 8
	%_229 = bitcast i8* %_228 to i32**
	%_227 = load i32*, i32** %_229
	%_230 = load i32, i32* %_227
	%_231 = icmp ule i32 %_230, 2
	br i1 %_231, label %oob30, label %oob31
oob30:
	call void @throw_oob()
	br label %oob31
oob31:
	%_232 = add i32 2, 1
	%_233 = getelementptr i32, i32* %_227, i32 %_232
	store i32 12, i32* %_233
	%_235 = getelementptr i8, i8* %this, i32 8
	%_236 = bitcast i8* %_235 to i32**
	%_234 = load i32*, i32** %_236
	%_237 = load i32, i32* %_234
	%_238 = icmp ule i32 %_237, 3
	br i1 %_238, label %oob32, label %oob33
oob32:
	call void @throw_oob()
	br label %oob33
oob33:
	%_239 = add i32 3, 1
	%_240 = getelementptr i32, i32* %_234, i32 %_239
	store i32 18, i32* %_240
	%_242 = getelementptr i8, i8* %this, i32 8
	%_243 = bitcast i8* %_242 to i32**
	%_241 = load i32*, i32** %_243
	%_244 = load i32, i32* %_241
	%_245 = icmp ule i32 %_244, 4
	br i1 %_245, label %oob34, label %oob35
oob34:
	call void @throw_oob()
	br label %oob35
oob35:
	%_246 = add i32 4, 1
	%_247 = getelementptr i32, i32* %_241, i32 %_246
	store i32 2, i32* %_247
	%_249 = getelementptr i8, i8* %this, i32 8
	%_250 = bitcast i8* %_249 to i32**
	%_248 = load i32*, i32** %_250
	%_251 = load i32, i32* %_248
	%_252 = icmp ule i32 %_251, 5
	br i1 %_252, label %oob36, label %oob37
oob36:
	call void @throw_oob()
	br label %oob37
oob37:
	%_253 = add i32 5, 1
	%_254 = getelementptr i32, i32* %_248, i32 %_253
	store i32 11, i32* %_254
	%_256 = getelementptr i8, i8* %this, i32 8
	%_257 = bitcast i8* %_256 to i32**
	%_255 = load i32*, i32** %_257
	%_258 = load i32, i32* %_255
	%_259 = icmp ule i32 %_258, 6
	br i1 %_259, label %oob38, label %oob39
oob38:
	call void @throw_oob()
	br label %oob39
oob39:
	%_260 = add i32 6, 1
	%_261 = getelementptr i32, i32* %_255, i32 %_260
	store i32 6, i32* %_261
	%_263 = getelementptr i8, i8* %this, i32 8
	%_264 = bitcast i8* %_263 to i32**
	%_262 = load i32*, i32** %_264
	%_265 = load i32, i32* %_262
	%_266 = icmp ule i32 %_265, 7
	br i1 %_266, label %oob40, label %oob41
oob40:
	call void @throw_oob()
	br label %oob41
oob41:
	%_267 = add i32 7, 1
	%_268 = getelementptr i32, i32* %_262, i32 %_267
	store i32 9, i32* %_268
	%_270 = getelementptr i8, i8* %this, i32 8
	%_271 = bitcast i8* %_270 to i32**
	%_269 = load i32*, i32** %_271
	%_272 = load i32, i32* %_269
	%_273 = icmp ule i32 %_272, 8
	br i1 %_273, label %oob42, label %oob43
oob42:
	call void @throw_oob()
	br label %oob43
oob43:
	%_274 = add i32 8, 1
	%_275 = getelementptr i32, i32* %_269, i32 %_274
	store i32 19, i32* %_275
	%_277 = getelementptr i8, i8* %this, i32 8
	%_278 = bitcast i8* %_277 to i32**
	%_276 = load i32*, i32** %_278
	%_279 = load i32, i32* %_276
	%_280 = icmp ule i32 %_279, 9
	br i1 %_280, label %oob44, label %oob45
oob44:
	call void @throw_oob()
	br label %oob45
oob45:
	%_281 = add i32 9, 1
	%_282 = getelementptr i32, i32* %_276, i32 %_281
	store i32 5, i32* %_282
	ret i32 0
}


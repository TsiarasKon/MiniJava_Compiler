@.TreeVisitor_vtable = global [0 x i8*] []
@.TV_vtable = global [1 x i8*] [i8* bitcast (i32 (i8*)* @TV.Start to i8*)]
@.Tree_vtable = global [21 x i8*] [i8* bitcast (i1 (i8*, i32)* @Tree.Init to i8*), i8* bitcast (i1 (i8*, i8*)* @Tree.SetRight to i8*), i8* bitcast (i1 (i8*, i8*)* @Tree.SetLeft to i8*), i8* bitcast (i8* (i8*)* @Tree.GetRight to i8*), i8* bitcast (i8* (i8*)* @Tree.GetLeft to i8*), i8* bitcast (i32 (i8*)* @Tree.GetKey to i8*), i8* bitcast (i1 (i8*, i32)* @Tree.SetKey to i8*), i8* bitcast (i1 (i8*)* @Tree.GetHas_Right to i8*), i8* bitcast (i1 (i8*)* @Tree.GetHas_Left to i8*), i8* bitcast (i1 (i8*, i1)* @Tree.SetHas_Left to i8*), i8* bitcast (i1 (i8*, i1)* @Tree.SetHas_Right to i8*), i8* bitcast (i1 (i8*, i32, i32)* @Tree.Compare to i8*), i8* bitcast (i1 (i8*, i32)* @Tree.Insert to i8*), i8* bitcast (i1 (i8*, i32)* @Tree.Delete to i8*), i8* bitcast (i1 (i8*, i8*, i8*)* @Tree.Remove to i8*), i8* bitcast (i1 (i8*, i8*, i8*)* @Tree.RemoveRight to i8*), i8* bitcast (i1 (i8*, i8*, i8*)* @Tree.RemoveLeft to i8*), i8* bitcast (i32 (i8*, i32)* @Tree.Search to i8*), i8* bitcast (i1 (i8*)* @Tree.Print to i8*), i8* bitcast (i1 (i8*, i8*)* @Tree.RecPrint to i8*), i8* bitcast (i32 (i8*, i8*)* @Tree.accept to i8*)]
@.Visitor_vtable = global [1 x i8*] [i8* bitcast (i32 (i8*, i8*)* @Visitor.visit to i8*)]
@.MyVisitor_vtable = global [1 x i8*] [i8* bitcast (i32 (i8*, i8*)* @MyVisitor.visit to i8*)]


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
	%_0 = call i8* @calloc(i32 1, i32 8)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [1 x i8*], [1 x i8*]* @.TV_vtable, i32 0, i32 0
	store i8** %_2, i8*** %_1
	%_3 = bitcast i8* %_0 to i8***
	%_4 = load i8**, i8*** %_3
	%_5 = getelementptr i8*, i8** %_4, i32 0
	%_6 = load i8*, i8** %_5
	%_7 = bitcast i8* %_6 to i32 (i8*)*
	%_8 = call i32 %_7(i8* %_0)
	call void (i32) @print_int(i32 %_8)
	ret i32 0
}

define i32 @TV.Start(i8* %this) {
	%root = alloca i8*
	%ntb = alloca i1
	%nti = alloca i32
	%v = alloca i8*
	%_9 = call i8* @calloc(i32 1, i32 38)
	%_10 = bitcast i8* %_9 to i8***
	%_11 = getelementptr [21 x i8*], [21 x i8*]* @.Tree_vtable, i32 0, i32 0
	store i8** %_11, i8*** %_10
	store i8* %_9, i8** %root
	%_12 = load i8*, i8** %root
	%_13 = bitcast i8* %_12 to i8***
	%_14 = load i8**, i8*** %_13
	%_15 = getelementptr i8*, i8** %_14, i32 0
	%_16 = load i8*, i8** %_15
	%_17 = bitcast i8* %_16 to i1 (i8*, i32)*
	%_18 = call i1 %_17(i8* %_12, i32 16)
	store i1 %_18, i1* %ntb
	%_19 = load i8*, i8** %root
	%_20 = bitcast i8* %_19 to i8***
	%_21 = load i8**, i8*** %_20
	%_22 = getelementptr i8*, i8** %_21, i32 18
	%_23 = load i8*, i8** %_22
	%_24 = bitcast i8* %_23 to i1 (i8*)*
	%_25 = call i1 %_24(i8* %_19)
	store i1 %_25, i1* %ntb
	call void (i32) @print_int(i32 100000000)
	%_26 = load i8*, i8** %root
	%_27 = bitcast i8* %_26 to i8***
	%_28 = load i8**, i8*** %_27
	%_29 = getelementptr i8*, i8** %_28, i32 12
	%_30 = load i8*, i8** %_29
	%_31 = bitcast i8* %_30 to i1 (i8*, i32)*
	%_32 = call i1 %_31(i8* %_26, i32 8)
	store i1 %_32, i1* %ntb
	%_33 = load i8*, i8** %root
	%_34 = bitcast i8* %_33 to i8***
	%_35 = load i8**, i8*** %_34
	%_36 = getelementptr i8*, i8** %_35, i32 12
	%_37 = load i8*, i8** %_36
	%_38 = bitcast i8* %_37 to i1 (i8*, i32)*
	%_39 = call i1 %_38(i8* %_33, i32 24)
	store i1 %_39, i1* %ntb
	%_40 = load i8*, i8** %root
	%_41 = bitcast i8* %_40 to i8***
	%_42 = load i8**, i8*** %_41
	%_43 = getelementptr i8*, i8** %_42, i32 12
	%_44 = load i8*, i8** %_43
	%_45 = bitcast i8* %_44 to i1 (i8*, i32)*
	%_46 = call i1 %_45(i8* %_40, i32 4)
	store i1 %_46, i1* %ntb
	%_47 = load i8*, i8** %root
	%_48 = bitcast i8* %_47 to i8***
	%_49 = load i8**, i8*** %_48
	%_50 = getelementptr i8*, i8** %_49, i32 12
	%_51 = load i8*, i8** %_50
	%_52 = bitcast i8* %_51 to i1 (i8*, i32)*
	%_53 = call i1 %_52(i8* %_47, i32 12)
	store i1 %_53, i1* %ntb
	%_54 = load i8*, i8** %root
	%_55 = bitcast i8* %_54 to i8***
	%_56 = load i8**, i8*** %_55
	%_57 = getelementptr i8*, i8** %_56, i32 12
	%_58 = load i8*, i8** %_57
	%_59 = bitcast i8* %_58 to i1 (i8*, i32)*
	%_60 = call i1 %_59(i8* %_54, i32 20)
	store i1 %_60, i1* %ntb
	%_61 = load i8*, i8** %root
	%_62 = bitcast i8* %_61 to i8***
	%_63 = load i8**, i8*** %_62
	%_64 = getelementptr i8*, i8** %_63, i32 12
	%_65 = load i8*, i8** %_64
	%_66 = bitcast i8* %_65 to i1 (i8*, i32)*
	%_67 = call i1 %_66(i8* %_61, i32 28)
	store i1 %_67, i1* %ntb
	%_68 = load i8*, i8** %root
	%_69 = bitcast i8* %_68 to i8***
	%_70 = load i8**, i8*** %_69
	%_71 = getelementptr i8*, i8** %_70, i32 12
	%_72 = load i8*, i8** %_71
	%_73 = bitcast i8* %_72 to i1 (i8*, i32)*
	%_74 = call i1 %_73(i8* %_68, i32 14)
	store i1 %_74, i1* %ntb
	%_75 = load i8*, i8** %root
	%_76 = bitcast i8* %_75 to i8***
	%_77 = load i8**, i8*** %_76
	%_78 = getelementptr i8*, i8** %_77, i32 18
	%_79 = load i8*, i8** %_78
	%_80 = bitcast i8* %_79 to i1 (i8*)*
	%_81 = call i1 %_80(i8* %_75)
	store i1 %_81, i1* %ntb
	call void (i32) @print_int(i32 100000000)
	%_82 = call i8* @calloc(i32 1, i32 24)
	%_83 = bitcast i8* %_82 to i8***
	%_84 = getelementptr [1 x i8*], [1 x i8*]* @.MyVisitor_vtable, i32 0, i32 0
	store i8** %_84, i8*** %_83
	store i8* %_82, i8** %v
	call void (i32) @print_int(i32 50000000)
	%_85 = load i8*, i8** %root
	%_86 = load i8*, i8** %v
	%_87 = bitcast i8* %_85 to i8***
	%_88 = load i8**, i8*** %_87
	%_89 = getelementptr i8*, i8** %_88, i32 20
	%_90 = load i8*, i8** %_89
	%_91 = bitcast i8* %_90 to i32 (i8*, i8*)*
	%_92 = call i32 %_91(i8* %_85, i8* %_86)
	store i32 %_92, i32* %nti
	call void (i32) @print_int(i32 100000000)
	%_93 = load i8*, i8** %root
	%_94 = bitcast i8* %_93 to i8***
	%_95 = load i8**, i8*** %_94
	%_96 = getelementptr i8*, i8** %_95, i32 17
	%_97 = load i8*, i8** %_96
	%_98 = bitcast i8* %_97 to i32 (i8*, i32)*
	%_99 = call i32 %_98(i8* %_93, i32 24)
	call void (i32) @print_int(i32 %_99)
	%_100 = load i8*, i8** %root
	%_101 = bitcast i8* %_100 to i8***
	%_102 = load i8**, i8*** %_101
	%_103 = getelementptr i8*, i8** %_102, i32 17
	%_104 = load i8*, i8** %_103
	%_105 = bitcast i8* %_104 to i32 (i8*, i32)*
	%_106 = call i32 %_105(i8* %_100, i32 12)
	call void (i32) @print_int(i32 %_106)
	%_107 = load i8*, i8** %root
	%_108 = bitcast i8* %_107 to i8***
	%_109 = load i8**, i8*** %_108
	%_110 = getelementptr i8*, i8** %_109, i32 17
	%_111 = load i8*, i8** %_110
	%_112 = bitcast i8* %_111 to i32 (i8*, i32)*
	%_113 = call i32 %_112(i8* %_107, i32 16)
	call void (i32) @print_int(i32 %_113)
	%_114 = load i8*, i8** %root
	%_115 = bitcast i8* %_114 to i8***
	%_116 = load i8**, i8*** %_115
	%_117 = getelementptr i8*, i8** %_116, i32 17
	%_118 = load i8*, i8** %_117
	%_119 = bitcast i8* %_118 to i32 (i8*, i32)*
	%_120 = call i32 %_119(i8* %_114, i32 50)
	call void (i32) @print_int(i32 %_120)
	%_121 = load i8*, i8** %root
	%_122 = bitcast i8* %_121 to i8***
	%_123 = load i8**, i8*** %_122
	%_124 = getelementptr i8*, i8** %_123, i32 17
	%_125 = load i8*, i8** %_124
	%_126 = bitcast i8* %_125 to i32 (i8*, i32)*
	%_127 = call i32 %_126(i8* %_121, i32 12)
	call void (i32) @print_int(i32 %_127)
	%_128 = load i8*, i8** %root
	%_129 = bitcast i8* %_128 to i8***
	%_130 = load i8**, i8*** %_129
	%_131 = getelementptr i8*, i8** %_130, i32 13
	%_132 = load i8*, i8** %_131
	%_133 = bitcast i8* %_132 to i1 (i8*, i32)*
	%_134 = call i1 %_133(i8* %_128, i32 12)
	store i1 %_134, i1* %ntb
	%_135 = load i8*, i8** %root
	%_136 = bitcast i8* %_135 to i8***
	%_137 = load i8**, i8*** %_136
	%_138 = getelementptr i8*, i8** %_137, i32 18
	%_139 = load i8*, i8** %_138
	%_140 = bitcast i8* %_139 to i1 (i8*)*
	%_141 = call i1 %_140(i8* %_135)
	store i1 %_141, i1* %ntb
	%_142 = load i8*, i8** %root
	%_143 = bitcast i8* %_142 to i8***
	%_144 = load i8**, i8*** %_143
	%_145 = getelementptr i8*, i8** %_144, i32 17
	%_146 = load i8*, i8** %_145
	%_147 = bitcast i8* %_146 to i32 (i8*, i32)*
	%_148 = call i32 %_147(i8* %_142, i32 12)
	call void (i32) @print_int(i32 %_148)
	ret i32 0
}

define i1 @Tree.Init(i8* %this, i32 %.v_key) {
	%v_key = alloca i32
	store i32 %.v_key, i32* %v_key
	%_149 = load i32, i32* %v_key
	%_150 = getelementptr i8, i8* %this, i32 24
	%_151 = bitcast i8* %_150 to i32*
	store i32 %_149, i32* %_151
	%_152 = getelementptr i8, i8* %this, i32 28
	%_153 = bitcast i8* %_152 to i1*
	store i1 0, i1* %_153
	%_154 = getelementptr i8, i8* %this, i32 29
	%_155 = bitcast i8* %_154 to i1*
	store i1 0, i1* %_155
	ret i1 1
}

define i1 @Tree.SetRight(i8* %this, i8* %.rn) {
	%rn = alloca i8*
	store i8* %.rn, i8** %rn
	%_156 = load i8*, i8** %rn
	%_157 = getelementptr i8, i8* %this, i32 16
	%_158 = bitcast i8* %_157 to i8**
	store i8* %_156, i8** %_158
	ret i1 1
}

define i1 @Tree.SetLeft(i8* %this, i8* %.ln) {
	%ln = alloca i8*
	store i8* %.ln, i8** %ln
	%_159 = load i8*, i8** %ln
	%_160 = getelementptr i8, i8* %this, i32 8
	%_161 = bitcast i8* %_160 to i8**
	store i8* %_159, i8** %_161
	ret i1 1
}

define i8* @Tree.GetRight(i8* %this) {
	%_163 = getelementptr i8, i8* %this, i32 16
	%_164 = bitcast i8* %_163 to i8**
	%_162 = load i8*, i8** %_164
	ret i8* %_162
}

define i8* @Tree.GetLeft(i8* %this) {
	%_166 = getelementptr i8, i8* %this, i32 8
	%_167 = bitcast i8* %_166 to i8**
	%_165 = load i8*, i8** %_167
	ret i8* %_165
}

define i32 @Tree.GetKey(i8* %this) {
	%_169 = getelementptr i8, i8* %this, i32 24
	%_170 = bitcast i8* %_169 to i32*
	%_168 = load i32, i32* %_170
	ret i32 %_168
}

define i1 @Tree.SetKey(i8* %this, i32 %.v_key) {
	%v_key = alloca i32
	store i32 %.v_key, i32* %v_key
	%_171 = load i32, i32* %v_key
	%_172 = getelementptr i8, i8* %this, i32 24
	%_173 = bitcast i8* %_172 to i32*
	store i32 %_171, i32* %_173
	ret i1 1
}

define i1 @Tree.GetHas_Right(i8* %this) {
	%_175 = getelementptr i8, i8* %this, i32 29
	%_176 = bitcast i8* %_175 to i1*
	%_174 = load i1, i1* %_176
	ret i1 %_174
}

define i1 @Tree.GetHas_Left(i8* %this) {
	%_178 = getelementptr i8, i8* %this, i32 28
	%_179 = bitcast i8* %_178 to i1*
	%_177 = load i1, i1* %_179
	ret i1 %_177
}

define i1 @Tree.SetHas_Left(i8* %this, i1 %.val) {
	%val = alloca i1
	store i1 %.val, i1* %val
	%_180 = load i1, i1* %val
	%_181 = getelementptr i8, i8* %this, i32 28
	%_182 = bitcast i8* %_181 to i1*
	store i1 %_180, i1* %_182
	ret i1 1
}

define i1 @Tree.SetHas_Right(i8* %this, i1 %.val) {
	%val = alloca i1
	store i1 %.val, i1* %val
	%_183 = load i1, i1* %val
	%_184 = getelementptr i8, i8* %this, i32 29
	%_185 = bitcast i8* %_184 to i1*
	store i1 %_183, i1* %_185
	ret i1 1
}

define i1 @Tree.Compare(i8* %this, i32 %.num1, i32 %.num2) {
	%num1 = alloca i32
	store i32 %.num1, i32* %num1
	%num2 = alloca i32
	store i32 %.num2, i32* %num2
	%ntb = alloca i1
	%nti = alloca i32
	store i1 0, i1* %ntb
	%_186 = load i32, i32* %num2
	%_187 = add i32 %_186, 1
	store i32 %_187, i32* %nti
	%_188 = load i32, i32* %num1
	%_189 = load i32, i32* %num2
	%_190 = icmp slt i32 %_188, %_189
	br i1 %_190, label %if0, label %if1
if0:
	store i1 0, i1* %ntb
	br label %if2
if1:
	%_191 = load i32, i32* %num1
	%_192 = load i32, i32* %nti
	%_193 = icmp slt i32 %_191, %_192
	%_194 = xor i1 1, %_193
	br i1 %_194, label %if3, label %if4
if3:
	store i1 0, i1* %ntb
	br label %if5
if4:
	store i1 1, i1* %ntb
	br label %if5
if5:
	br label %if2
if2:
	%_195 = load i1, i1* %ntb
	ret i1 %_195
}

define i1 @Tree.Insert(i8* %this, i32 %.v_key) {
	%v_key = alloca i32
	store i32 %.v_key, i32* %v_key
	%new_node = alloca i8*
	%ntb = alloca i1
	%current_node = alloca i8*
	%cont = alloca i1
	%key_aux = alloca i32
	%_196 = call i8* @calloc(i32 1, i32 38)
	%_197 = bitcast i8* %_196 to i8***
	%_198 = getelementptr [21 x i8*], [21 x i8*]* @.Tree_vtable, i32 0, i32 0
	store i8** %_198, i8*** %_197
	store i8* %_196, i8** %new_node
	%_199 = load i8*, i8** %new_node
	%_200 = load i32, i32* %v_key
	%_201 = bitcast i8* %_199 to i8***
	%_202 = load i8**, i8*** %_201
	%_203 = getelementptr i8*, i8** %_202, i32 0
	%_204 = load i8*, i8** %_203
	%_205 = bitcast i8* %_204 to i1 (i8*, i32)*
	%_206 = call i1 %_205(i8* %_199, i32 %_200)
	store i1 %_206, i1* %ntb
	store i8* %this, i8** %current_node
	store i1 1, i1* %cont
	br label %loop0
loop0:
	%_207 = load i1, i1* %cont
	br i1 %_207, label %loop1, label %loop2
loop1:
	%_208 = load i8*, i8** %current_node
	%_209 = bitcast i8* %_208 to i8***
	%_210 = load i8**, i8*** %_209
	%_211 = getelementptr i8*, i8** %_210, i32 5
	%_212 = load i8*, i8** %_211
	%_213 = bitcast i8* %_212 to i32 (i8*)*
	%_214 = call i32 %_213(i8* %_208)
	store i32 %_214, i32* %key_aux
	%_215 = load i32, i32* %v_key
	%_216 = load i32, i32* %key_aux
	%_217 = icmp slt i32 %_215, %_216
	br i1 %_217, label %if6, label %if7
if6:
	%_218 = load i8*, i8** %current_node
	%_219 = bitcast i8* %_218 to i8***
	%_220 = load i8**, i8*** %_219
	%_221 = getelementptr i8*, i8** %_220, i32 8
	%_222 = load i8*, i8** %_221
	%_223 = bitcast i8* %_222 to i1 (i8*)*
	%_224 = call i1 %_223(i8* %_218)
	br i1 %_224, label %if9, label %if10
if9:
	%_225 = load i8*, i8** %current_node
	%_226 = bitcast i8* %_225 to i8***
	%_227 = load i8**, i8*** %_226
	%_228 = getelementptr i8*, i8** %_227, i32 4
	%_229 = load i8*, i8** %_228
	%_230 = bitcast i8* %_229 to i8* (i8*)*
	%_231 = call i8* %_230(i8* %_225)
	store i8* %_231, i8** %current_node
	br label %if11
if10:
	store i1 0, i1* %cont
	%_232 = load i8*, i8** %current_node
	%_233 = bitcast i8* %_232 to i8***
	%_234 = load i8**, i8*** %_233
	%_235 = getelementptr i8*, i8** %_234, i32 9
	%_236 = load i8*, i8** %_235
	%_237 = bitcast i8* %_236 to i1 (i8*, i1)*
	%_238 = call i1 %_237(i8* %_232, i1 1)
	store i1 %_238, i1* %ntb
	%_239 = load i8*, i8** %current_node
	%_240 = load i8*, i8** %new_node
	%_241 = bitcast i8* %_239 to i8***
	%_242 = load i8**, i8*** %_241
	%_243 = getelementptr i8*, i8** %_242, i32 2
	%_244 = load i8*, i8** %_243
	%_245 = bitcast i8* %_244 to i1 (i8*, i8*)*
	%_246 = call i1 %_245(i8* %_239, i8* %_240)
	store i1 %_246, i1* %ntb
	br label %if11
if11:
	br label %if8
if7:
	%_247 = load i8*, i8** %current_node
	%_248 = bitcast i8* %_247 to i8***
	%_249 = load i8**, i8*** %_248
	%_250 = getelementptr i8*, i8** %_249, i32 7
	%_251 = load i8*, i8** %_250
	%_252 = bitcast i8* %_251 to i1 (i8*)*
	%_253 = call i1 %_252(i8* %_247)
	br i1 %_253, label %if12, label %if13
if12:
	%_254 = load i8*, i8** %current_node
	%_255 = bitcast i8* %_254 to i8***
	%_256 = load i8**, i8*** %_255
	%_257 = getelementptr i8*, i8** %_256, i32 3
	%_258 = load i8*, i8** %_257
	%_259 = bitcast i8* %_258 to i8* (i8*)*
	%_260 = call i8* %_259(i8* %_254)
	store i8* %_260, i8** %current_node
	br label %if14
if13:
	store i1 0, i1* %cont
	%_261 = load i8*, i8** %current_node
	%_262 = bitcast i8* %_261 to i8***
	%_263 = load i8**, i8*** %_262
	%_264 = getelementptr i8*, i8** %_263, i32 10
	%_265 = load i8*, i8** %_264
	%_266 = bitcast i8* %_265 to i1 (i8*, i1)*
	%_267 = call i1 %_266(i8* %_261, i1 1)
	store i1 %_267, i1* %ntb
	%_268 = load i8*, i8** %current_node
	%_269 = load i8*, i8** %new_node
	%_270 = bitcast i8* %_268 to i8***
	%_271 = load i8**, i8*** %_270
	%_272 = getelementptr i8*, i8** %_271, i32 1
	%_273 = load i8*, i8** %_272
	%_274 = bitcast i8* %_273 to i1 (i8*, i8*)*
	%_275 = call i1 %_274(i8* %_268, i8* %_269)
	store i1 %_275, i1* %ntb
	br label %if14
if14:
	br label %if8
if8:
	br label %loop0
loop2:
	ret i1 1
}

define i1 @Tree.Delete(i8* %this, i32 %.v_key) {
	%v_key = alloca i32
	store i32 %.v_key, i32* %v_key
	%current_node = alloca i8*
	%parent_node = alloca i8*
	%cont = alloca i1
	%found = alloca i1
	%ntb = alloca i1
	%is_root = alloca i1
	%key_aux = alloca i32
	store i8* %this, i8** %current_node
	store i8* %this, i8** %parent_node
	store i1 1, i1* %cont
	store i1 0, i1* %found
	store i1 1, i1* %is_root
	br label %loop3
loop3:
	%_276 = load i1, i1* %cont
	br i1 %_276, label %loop4, label %loop5
loop4:
	%_277 = load i8*, i8** %current_node
	%_278 = bitcast i8* %_277 to i8***
	%_279 = load i8**, i8*** %_278
	%_280 = getelementptr i8*, i8** %_279, i32 5
	%_281 = load i8*, i8** %_280
	%_282 = bitcast i8* %_281 to i32 (i8*)*
	%_283 = call i32 %_282(i8* %_277)
	store i32 %_283, i32* %key_aux
	%_284 = load i32, i32* %v_key
	%_285 = load i32, i32* %key_aux
	%_286 = icmp slt i32 %_284, %_285
	br i1 %_286, label %if15, label %if16
if15:
	%_287 = load i8*, i8** %current_node
	%_288 = bitcast i8* %_287 to i8***
	%_289 = load i8**, i8*** %_288
	%_290 = getelementptr i8*, i8** %_289, i32 8
	%_291 = load i8*, i8** %_290
	%_292 = bitcast i8* %_291 to i1 (i8*)*
	%_293 = call i1 %_292(i8* %_287)
	br i1 %_293, label %if18, label %if19
if18:
	%_294 = load i8*, i8** %current_node
	store i8* %_294, i8** %parent_node
	%_295 = load i8*, i8** %current_node
	%_296 = bitcast i8* %_295 to i8***
	%_297 = load i8**, i8*** %_296
	%_298 = getelementptr i8*, i8** %_297, i32 4
	%_299 = load i8*, i8** %_298
	%_300 = bitcast i8* %_299 to i8* (i8*)*
	%_301 = call i8* %_300(i8* %_295)
	store i8* %_301, i8** %current_node
	br label %if20
if19:
	store i1 0, i1* %cont
	br label %if20
if20:
	br label %if17
if16:
	%_302 = load i32, i32* %key_aux
	%_303 = load i32, i32* %v_key
	%_304 = icmp slt i32 %_302, %_303
	br i1 %_304, label %if21, label %if22
if21:
	%_305 = load i8*, i8** %current_node
	%_306 = bitcast i8* %_305 to i8***
	%_307 = load i8**, i8*** %_306
	%_308 = getelementptr i8*, i8** %_307, i32 7
	%_309 = load i8*, i8** %_308
	%_310 = bitcast i8* %_309 to i1 (i8*)*
	%_311 = call i1 %_310(i8* %_305)
	br i1 %_311, label %if24, label %if25
if24:
	%_312 = load i8*, i8** %current_node
	store i8* %_312, i8** %parent_node
	%_313 = load i8*, i8** %current_node
	%_314 = bitcast i8* %_313 to i8***
	%_315 = load i8**, i8*** %_314
	%_316 = getelementptr i8*, i8** %_315, i32 3
	%_317 = load i8*, i8** %_316
	%_318 = bitcast i8* %_317 to i8* (i8*)*
	%_319 = call i8* %_318(i8* %_313)
	store i8* %_319, i8** %current_node
	br label %if26
if25:
	store i1 0, i1* %cont
	br label %if26
if26:
	br label %if23
if22:
	%_320 = load i1, i1* %is_root
	br i1 %_320, label %if27, label %if28
if27:
	%_321 = load i8*, i8** %current_node
	%_322 = bitcast i8* %_321 to i8***
	%_323 = load i8**, i8*** %_322
	%_324 = getelementptr i8*, i8** %_323, i32 7
	%_325 = load i8*, i8** %_324
	%_326 = bitcast i8* %_325 to i1 (i8*)*
	%_327 = call i1 %_326(i8* %_321)
	%_328 = xor i1 1, %_327
	%_329 = load i8*, i8** %current_node
	%_330 = bitcast i8* %_329 to i8***
	%_331 = load i8**, i8*** %_330
	%_332 = getelementptr i8*, i8** %_331, i32 8
	%_333 = load i8*, i8** %_332
	%_334 = bitcast i8* %_333 to i1 (i8*)*
	%_335 = call i1 %_334(i8* %_329)
	%_336 = xor i1 1, %_335
	br label %andclause0
andclause0:
	br i1 %_328, label %andclause1, label %andclause2
andclause1:
	br label %andclause2
andclause2:
	%_337 = phi i1 [0, %andclause0], [%_336, %andclause1]
	br i1 %_337, label %if30, label %if31
if30:
	store i1 1, i1* %ntb
	br label %if32
if31:
	%_338 = load i8*, i8** %parent_node
	%_339 = load i8*, i8** %current_node
	%_340 = bitcast i8* %this to i8***
	%_341 = load i8**, i8*** %_340
	%_342 = getelementptr i8*, i8** %_341, i32 14
	%_343 = load i8*, i8** %_342
	%_344 = bitcast i8* %_343 to i1 (i8*, i8*, i8*)*
	%_345 = call i1 %_344(i8* %this, i8* %_338, i8* %_339)
	store i1 %_345, i1* %ntb
	br label %if32
if32:
	br label %if29
if28:
	%_346 = load i8*, i8** %parent_node
	%_347 = load i8*, i8** %current_node
	%_348 = bitcast i8* %this to i8***
	%_349 = load i8**, i8*** %_348
	%_350 = getelementptr i8*, i8** %_349, i32 14
	%_351 = load i8*, i8** %_350
	%_352 = bitcast i8* %_351 to i1 (i8*, i8*, i8*)*
	%_353 = call i1 %_352(i8* %this, i8* %_346, i8* %_347)
	store i1 %_353, i1* %ntb
	br label %if29
if29:
	store i1 1, i1* %found
	store i1 0, i1* %cont
	br label %if23
if23:
	br label %if17
if17:
	store i1 0, i1* %is_root
	br label %loop3
loop5:
	%_354 = load i1, i1* %found
	ret i1 %_354
}

define i1 @Tree.Remove(i8* %this, i8* %.p_node, i8* %.c_node) {
	%p_node = alloca i8*
	store i8* %.p_node, i8** %p_node
	%c_node = alloca i8*
	store i8* %.c_node, i8** %c_node
	%ntb = alloca i1
	%auxkey1 = alloca i32
	%auxkey2 = alloca i32
	%_355 = load i8*, i8** %c_node
	%_356 = bitcast i8* %_355 to i8***
	%_357 = load i8**, i8*** %_356
	%_358 = getelementptr i8*, i8** %_357, i32 8
	%_359 = load i8*, i8** %_358
	%_360 = bitcast i8* %_359 to i1 (i8*)*
	%_361 = call i1 %_360(i8* %_355)
	br i1 %_361, label %if33, label %if34
if33:
	%_362 = load i8*, i8** %p_node
	%_363 = load i8*, i8** %c_node
	%_364 = bitcast i8* %this to i8***
	%_365 = load i8**, i8*** %_364
	%_366 = getelementptr i8*, i8** %_365, i32 16
	%_367 = load i8*, i8** %_366
	%_368 = bitcast i8* %_367 to i1 (i8*, i8*, i8*)*
	%_369 = call i1 %_368(i8* %this, i8* %_362, i8* %_363)
	store i1 %_369, i1* %ntb
	br label %if35
if34:
	%_370 = load i8*, i8** %c_node
	%_371 = bitcast i8* %_370 to i8***
	%_372 = load i8**, i8*** %_371
	%_373 = getelementptr i8*, i8** %_372, i32 7
	%_374 = load i8*, i8** %_373
	%_375 = bitcast i8* %_374 to i1 (i8*)*
	%_376 = call i1 %_375(i8* %_370)
	br i1 %_376, label %if36, label %if37
if36:
	%_377 = load i8*, i8** %p_node
	%_378 = load i8*, i8** %c_node
	%_379 = bitcast i8* %this to i8***
	%_380 = load i8**, i8*** %_379
	%_381 = getelementptr i8*, i8** %_380, i32 15
	%_382 = load i8*, i8** %_381
	%_383 = bitcast i8* %_382 to i1 (i8*, i8*, i8*)*
	%_384 = call i1 %_383(i8* %this, i8* %_377, i8* %_378)
	store i1 %_384, i1* %ntb
	br label %if38
if37:
	%_385 = load i8*, i8** %c_node
	%_386 = bitcast i8* %_385 to i8***
	%_387 = load i8**, i8*** %_386
	%_388 = getelementptr i8*, i8** %_387, i32 5
	%_389 = load i8*, i8** %_388
	%_390 = bitcast i8* %_389 to i32 (i8*)*
	%_391 = call i32 %_390(i8* %_385)
	store i32 %_391, i32* %auxkey1
	%_392 = load i8*, i8** %p_node
	%_393 = bitcast i8* %_392 to i8***
	%_394 = load i8**, i8*** %_393
	%_395 = getelementptr i8*, i8** %_394, i32 4
	%_396 = load i8*, i8** %_395
	%_397 = bitcast i8* %_396 to i8* (i8*)*
	%_398 = call i8* %_397(i8* %_392)
	%_399 = bitcast i8* %_398 to i8***
	%_400 = load i8**, i8*** %_399
	%_401 = getelementptr i8*, i8** %_400, i32 5
	%_402 = load i8*, i8** %_401
	%_403 = bitcast i8* %_402 to i32 (i8*)*
	%_404 = call i32 %_403(i8* %_398)
	store i32 %_404, i32* %auxkey2
	%_405 = load i32, i32* %auxkey1
	%_406 = load i32, i32* %auxkey2
	%_407 = bitcast i8* %this to i8***
	%_408 = load i8**, i8*** %_407
	%_409 = getelementptr i8*, i8** %_408, i32 11
	%_410 = load i8*, i8** %_409
	%_411 = bitcast i8* %_410 to i1 (i8*, i32, i32)*
	%_412 = call i1 %_411(i8* %this, i32 %_405, i32 %_406)
	br i1 %_412, label %if39, label %if40
if39:
	%_413 = load i8*, i8** %p_node
	%_415 = getelementptr i8, i8* %this, i32 30
	%_416 = bitcast i8* %_415 to i8**
	%_414 = load i8*, i8** %_416
	%_417 = bitcast i8* %_413 to i8***
	%_418 = load i8**, i8*** %_417
	%_419 = getelementptr i8*, i8** %_418, i32 2
	%_420 = load i8*, i8** %_419
	%_421 = bitcast i8* %_420 to i1 (i8*, i8*)*
	%_422 = call i1 %_421(i8* %_413, i8* %_414)
	store i1 %_422, i1* %ntb
	%_423 = load i8*, i8** %p_node
	%_424 = bitcast i8* %_423 to i8***
	%_425 = load i8**, i8*** %_424
	%_426 = getelementptr i8*, i8** %_425, i32 9
	%_427 = load i8*, i8** %_426
	%_428 = bitcast i8* %_427 to i1 (i8*, i1)*
	%_429 = call i1 %_428(i8* %_423, i1 0)
	store i1 %_429, i1* %ntb
	br label %if41
if40:
	%_430 = load i8*, i8** %p_node
	%_432 = getelementptr i8, i8* %this, i32 30
	%_433 = bitcast i8* %_432 to i8**
	%_431 = load i8*, i8** %_433
	%_434 = bitcast i8* %_430 to i8***
	%_435 = load i8**, i8*** %_434
	%_436 = getelementptr i8*, i8** %_435, i32 1
	%_437 = load i8*, i8** %_436
	%_438 = bitcast i8* %_437 to i1 (i8*, i8*)*
	%_439 = call i1 %_438(i8* %_430, i8* %_431)
	store i1 %_439, i1* %ntb
	%_440 = load i8*, i8** %p_node
	%_441 = bitcast i8* %_440 to i8***
	%_442 = load i8**, i8*** %_441
	%_443 = getelementptr i8*, i8** %_442, i32 10
	%_444 = load i8*, i8** %_443
	%_445 = bitcast i8* %_444 to i1 (i8*, i1)*
	%_446 = call i1 %_445(i8* %_440, i1 0)
	store i1 %_446, i1* %ntb
	br label %if41
if41:
	br label %if38
if38:
	br label %if35
if35:
	ret i1 1
}

define i1 @Tree.RemoveRight(i8* %this, i8* %.p_node, i8* %.c_node) {
	%p_node = alloca i8*
	store i8* %.p_node, i8** %p_node
	%c_node = alloca i8*
	store i8* %.c_node, i8** %c_node
	%ntb = alloca i1
	br label %loop6
loop6:
	%_447 = load i8*, i8** %c_node
	%_448 = bitcast i8* %_447 to i8***
	%_449 = load i8**, i8*** %_448
	%_450 = getelementptr i8*, i8** %_449, i32 7
	%_451 = load i8*, i8** %_450
	%_452 = bitcast i8* %_451 to i1 (i8*)*
	%_453 = call i1 %_452(i8* %_447)
	br i1 %_453, label %loop7, label %loop8
loop7:
	%_454 = load i8*, i8** %c_node
	%_455 = load i8*, i8** %c_node
	%_456 = bitcast i8* %_455 to i8***
	%_457 = load i8**, i8*** %_456
	%_458 = getelementptr i8*, i8** %_457, i32 3
	%_459 = load i8*, i8** %_458
	%_460 = bitcast i8* %_459 to i8* (i8*)*
	%_461 = call i8* %_460(i8* %_455)
	%_462 = bitcast i8* %_461 to i8***
	%_463 = load i8**, i8*** %_462
	%_464 = getelementptr i8*, i8** %_463, i32 5
	%_465 = load i8*, i8** %_464
	%_466 = bitcast i8* %_465 to i32 (i8*)*
	%_467 = call i32 %_466(i8* %_461)
	%_468 = bitcast i8* %_454 to i8***
	%_469 = load i8**, i8*** %_468
	%_470 = getelementptr i8*, i8** %_469, i32 6
	%_471 = load i8*, i8** %_470
	%_472 = bitcast i8* %_471 to i1 (i8*, i32)*
	%_473 = call i1 %_472(i8* %_454, i32 %_467)
	store i1 %_473, i1* %ntb
	%_474 = load i8*, i8** %c_node
	store i8* %_474, i8** %p_node
	%_475 = load i8*, i8** %c_node
	%_476 = bitcast i8* %_475 to i8***
	%_477 = load i8**, i8*** %_476
	%_478 = getelementptr i8*, i8** %_477, i32 3
	%_479 = load i8*, i8** %_478
	%_480 = bitcast i8* %_479 to i8* (i8*)*
	%_481 = call i8* %_480(i8* %_475)
	store i8* %_481, i8** %c_node
	br label %loop6
loop8:
	%_482 = load i8*, i8** %p_node
	%_484 = getelementptr i8, i8* %this, i32 30
	%_485 = bitcast i8* %_484 to i8**
	%_483 = load i8*, i8** %_485
	%_486 = bitcast i8* %_482 to i8***
	%_487 = load i8**, i8*** %_486
	%_488 = getelementptr i8*, i8** %_487, i32 1
	%_489 = load i8*, i8** %_488
	%_490 = bitcast i8* %_489 to i1 (i8*, i8*)*
	%_491 = call i1 %_490(i8* %_482, i8* %_483)
	store i1 %_491, i1* %ntb
	%_492 = load i8*, i8** %p_node
	%_493 = bitcast i8* %_492 to i8***
	%_494 = load i8**, i8*** %_493
	%_495 = getelementptr i8*, i8** %_494, i32 10
	%_496 = load i8*, i8** %_495
	%_497 = bitcast i8* %_496 to i1 (i8*, i1)*
	%_498 = call i1 %_497(i8* %_492, i1 0)
	store i1 %_498, i1* %ntb
	ret i1 1
}

define i1 @Tree.RemoveLeft(i8* %this, i8* %.p_node, i8* %.c_node) {
	%p_node = alloca i8*
	store i8* %.p_node, i8** %p_node
	%c_node = alloca i8*
	store i8* %.c_node, i8** %c_node
	%ntb = alloca i1
	br label %loop9
loop9:
	%_499 = load i8*, i8** %c_node
	%_500 = bitcast i8* %_499 to i8***
	%_501 = load i8**, i8*** %_500
	%_502 = getelementptr i8*, i8** %_501, i32 8
	%_503 = load i8*, i8** %_502
	%_504 = bitcast i8* %_503 to i1 (i8*)*
	%_505 = call i1 %_504(i8* %_499)
	br i1 %_505, label %loop10, label %loop11
loop10:
	%_506 = load i8*, i8** %c_node
	%_507 = load i8*, i8** %c_node
	%_508 = bitcast i8* %_507 to i8***
	%_509 = load i8**, i8*** %_508
	%_510 = getelementptr i8*, i8** %_509, i32 4
	%_511 = load i8*, i8** %_510
	%_512 = bitcast i8* %_511 to i8* (i8*)*
	%_513 = call i8* %_512(i8* %_507)
	%_514 = bitcast i8* %_513 to i8***
	%_515 = load i8**, i8*** %_514
	%_516 = getelementptr i8*, i8** %_515, i32 5
	%_517 = load i8*, i8** %_516
	%_518 = bitcast i8* %_517 to i32 (i8*)*
	%_519 = call i32 %_518(i8* %_513)
	%_520 = bitcast i8* %_506 to i8***
	%_521 = load i8**, i8*** %_520
	%_522 = getelementptr i8*, i8** %_521, i32 6
	%_523 = load i8*, i8** %_522
	%_524 = bitcast i8* %_523 to i1 (i8*, i32)*
	%_525 = call i1 %_524(i8* %_506, i32 %_519)
	store i1 %_525, i1* %ntb
	%_526 = load i8*, i8** %c_node
	store i8* %_526, i8** %p_node
	%_527 = load i8*, i8** %c_node
	%_528 = bitcast i8* %_527 to i8***
	%_529 = load i8**, i8*** %_528
	%_530 = getelementptr i8*, i8** %_529, i32 4
	%_531 = load i8*, i8** %_530
	%_532 = bitcast i8* %_531 to i8* (i8*)*
	%_533 = call i8* %_532(i8* %_527)
	store i8* %_533, i8** %c_node
	br label %loop9
loop11:
	%_534 = load i8*, i8** %p_node
	%_536 = getelementptr i8, i8* %this, i32 30
	%_537 = bitcast i8* %_536 to i8**
	%_535 = load i8*, i8** %_537
	%_538 = bitcast i8* %_534 to i8***
	%_539 = load i8**, i8*** %_538
	%_540 = getelementptr i8*, i8** %_539, i32 2
	%_541 = load i8*, i8** %_540
	%_542 = bitcast i8* %_541 to i1 (i8*, i8*)*
	%_543 = call i1 %_542(i8* %_534, i8* %_535)
	store i1 %_543, i1* %ntb
	%_544 = load i8*, i8** %p_node
	%_545 = bitcast i8* %_544 to i8***
	%_546 = load i8**, i8*** %_545
	%_547 = getelementptr i8*, i8** %_546, i32 9
	%_548 = load i8*, i8** %_547
	%_549 = bitcast i8* %_548 to i1 (i8*, i1)*
	%_550 = call i1 %_549(i8* %_544, i1 0)
	store i1 %_550, i1* %ntb
	ret i1 1
}

define i32 @Tree.Search(i8* %this, i32 %.v_key) {
	%v_key = alloca i32
	store i32 %.v_key, i32* %v_key
	%current_node = alloca i8*
	%ifound = alloca i32
	%cont = alloca i1
	%key_aux = alloca i32
	store i8* %this, i8** %current_node
	store i1 1, i1* %cont
	store i32 0, i32* %ifound
	br label %loop12
loop12:
	%_551 = load i1, i1* %cont
	br i1 %_551, label %loop13, label %loop14
loop13:
	%_552 = load i8*, i8** %current_node
	%_553 = bitcast i8* %_552 to i8***
	%_554 = load i8**, i8*** %_553
	%_555 = getelementptr i8*, i8** %_554, i32 5
	%_556 = load i8*, i8** %_555
	%_557 = bitcast i8* %_556 to i32 (i8*)*
	%_558 = call i32 %_557(i8* %_552)
	store i32 %_558, i32* %key_aux
	%_559 = load i32, i32* %v_key
	%_560 = load i32, i32* %key_aux
	%_561 = icmp slt i32 %_559, %_560
	br i1 %_561, label %if42, label %if43
if42:
	%_562 = load i8*, i8** %current_node
	%_563 = bitcast i8* %_562 to i8***
	%_564 = load i8**, i8*** %_563
	%_565 = getelementptr i8*, i8** %_564, i32 8
	%_566 = load i8*, i8** %_565
	%_567 = bitcast i8* %_566 to i1 (i8*)*
	%_568 = call i1 %_567(i8* %_562)
	br i1 %_568, label %if45, label %if46
if45:
	%_569 = load i8*, i8** %current_node
	%_570 = bitcast i8* %_569 to i8***
	%_571 = load i8**, i8*** %_570
	%_572 = getelementptr i8*, i8** %_571, i32 4
	%_573 = load i8*, i8** %_572
	%_574 = bitcast i8* %_573 to i8* (i8*)*
	%_575 = call i8* %_574(i8* %_569)
	store i8* %_575, i8** %current_node
	br label %if47
if46:
	store i1 0, i1* %cont
	br label %if47
if47:
	br label %if44
if43:
	%_576 = load i32, i32* %key_aux
	%_577 = load i32, i32* %v_key
	%_578 = icmp slt i32 %_576, %_577
	br i1 %_578, label %if48, label %if49
if48:
	%_579 = load i8*, i8** %current_node
	%_580 = bitcast i8* %_579 to i8***
	%_581 = load i8**, i8*** %_580
	%_582 = getelementptr i8*, i8** %_581, i32 7
	%_583 = load i8*, i8** %_582
	%_584 = bitcast i8* %_583 to i1 (i8*)*
	%_585 = call i1 %_584(i8* %_579)
	br i1 %_585, label %if51, label %if52
if51:
	%_586 = load i8*, i8** %current_node
	%_587 = bitcast i8* %_586 to i8***
	%_588 = load i8**, i8*** %_587
	%_589 = getelementptr i8*, i8** %_588, i32 3
	%_590 = load i8*, i8** %_589
	%_591 = bitcast i8* %_590 to i8* (i8*)*
	%_592 = call i8* %_591(i8* %_586)
	store i8* %_592, i8** %current_node
	br label %if53
if52:
	store i1 0, i1* %cont
	br label %if53
if53:
	br label %if50
if49:
	store i32 1, i32* %ifound
	store i1 0, i1* %cont
	br label %if50
if50:
	br label %if44
if44:
	br label %loop12
loop14:
	%_593 = load i32, i32* %ifound
	ret i32 %_593
}

define i1 @Tree.Print(i8* %this) {
	%ntb = alloca i1
	%current_node = alloca i8*
	store i8* %this, i8** %current_node
	%_594 = load i8*, i8** %current_node
	%_595 = bitcast i8* %this to i8***
	%_596 = load i8**, i8*** %_595
	%_597 = getelementptr i8*, i8** %_596, i32 19
	%_598 = load i8*, i8** %_597
	%_599 = bitcast i8* %_598 to i1 (i8*, i8*)*
	%_600 = call i1 %_599(i8* %this, i8* %_594)
	store i1 %_600, i1* %ntb
	ret i1 1
}

define i1 @Tree.RecPrint(i8* %this, i8* %.node) {
	%node = alloca i8*
	store i8* %.node, i8** %node
	%ntb = alloca i1
	%_601 = load i8*, i8** %node
	%_602 = bitcast i8* %_601 to i8***
	%_603 = load i8**, i8*** %_602
	%_604 = getelementptr i8*, i8** %_603, i32 8
	%_605 = load i8*, i8** %_604
	%_606 = bitcast i8* %_605 to i1 (i8*)*
	%_607 = call i1 %_606(i8* %_601)
	br i1 %_607, label %if54, label %if55
if54:
	%_608 = load i8*, i8** %node
	%_609 = bitcast i8* %_608 to i8***
	%_610 = load i8**, i8*** %_609
	%_611 = getelementptr i8*, i8** %_610, i32 4
	%_612 = load i8*, i8** %_611
	%_613 = bitcast i8* %_612 to i8* (i8*)*
	%_614 = call i8* %_613(i8* %_608)
	%_615 = bitcast i8* %this to i8***
	%_616 = load i8**, i8*** %_615
	%_617 = getelementptr i8*, i8** %_616, i32 19
	%_618 = load i8*, i8** %_617
	%_619 = bitcast i8* %_618 to i1 (i8*, i8*)*
	%_620 = call i1 %_619(i8* %this, i8* %_614)
	store i1 %_620, i1* %ntb
	br label %if56
if55:
	store i1 1, i1* %ntb
	br label %if56
if56:
	%_621 = load i8*, i8** %node
	%_622 = bitcast i8* %_621 to i8***
	%_623 = load i8**, i8*** %_622
	%_624 = getelementptr i8*, i8** %_623, i32 5
	%_625 = load i8*, i8** %_624
	%_626 = bitcast i8* %_625 to i32 (i8*)*
	%_627 = call i32 %_626(i8* %_621)
	call void (i32) @print_int(i32 %_627)
	%_628 = load i8*, i8** %node
	%_629 = bitcast i8* %_628 to i8***
	%_630 = load i8**, i8*** %_629
	%_631 = getelementptr i8*, i8** %_630, i32 7
	%_632 = load i8*, i8** %_631
	%_633 = bitcast i8* %_632 to i1 (i8*)*
	%_634 = call i1 %_633(i8* %_628)
	br i1 %_634, label %if57, label %if58
if57:
	%_635 = load i8*, i8** %node
	%_636 = bitcast i8* %_635 to i8***
	%_637 = load i8**, i8*** %_636
	%_638 = getelementptr i8*, i8** %_637, i32 3
	%_639 = load i8*, i8** %_638
	%_640 = bitcast i8* %_639 to i8* (i8*)*
	%_641 = call i8* %_640(i8* %_635)
	%_642 = bitcast i8* %this to i8***
	%_643 = load i8**, i8*** %_642
	%_644 = getelementptr i8*, i8** %_643, i32 19
	%_645 = load i8*, i8** %_644
	%_646 = bitcast i8* %_645 to i1 (i8*, i8*)*
	%_647 = call i1 %_646(i8* %this, i8* %_641)
	store i1 %_647, i1* %ntb
	br label %if59
if58:
	store i1 1, i1* %ntb
	br label %if59
if59:
	ret i1 1
}

define i32 @Tree.accept(i8* %this, i8* %.v) {
	%v = alloca i8*
	store i8* %.v, i8** %v
	%nti = alloca i32
	call void (i32) @print_int(i32 333)
	%_648 = load i8*, i8** %v
	%_649 = bitcast i8* %_648 to i8***
	%_650 = load i8**, i8*** %_649
	%_651 = getelementptr i8*, i8** %_650, i32 0
	%_652 = load i8*, i8** %_651
	%_653 = bitcast i8* %_652 to i32 (i8*, i8*)*
	%_654 = call i32 %_653(i8* %_648, i8* %this)
	store i32 %_654, i32* %nti
	ret i32 0
}

define i32 @Visitor.visit(i8* %this, i8* %.n) {
	%n = alloca i8*
	store i8* %.n, i8** %n
	%nti = alloca i32
	%_655 = load i8*, i8** %n
	%_656 = bitcast i8* %_655 to i8***
	%_657 = load i8**, i8*** %_656
	%_658 = getelementptr i8*, i8** %_657, i32 7
	%_659 = load i8*, i8** %_658
	%_660 = bitcast i8* %_659 to i1 (i8*)*
	%_661 = call i1 %_660(i8* %_655)
	br i1 %_661, label %if60, label %if61
if60:
	%_662 = load i8*, i8** %n
	%_663 = bitcast i8* %_662 to i8***
	%_664 = load i8**, i8*** %_663
	%_665 = getelementptr i8*, i8** %_664, i32 3
	%_666 = load i8*, i8** %_665
	%_667 = bitcast i8* %_666 to i8* (i8*)*
	%_668 = call i8* %_667(i8* %_662)
	%_669 = getelementptr i8, i8* %this, i32 16
	%_670 = bitcast i8* %_669 to i8**
	store i8* %_668, i8** %_670
	%_672 = getelementptr i8, i8* %this, i32 16
	%_673 = bitcast i8* %_672 to i8**
	%_671 = load i8*, i8** %_673
	%_674 = bitcast i8* %_671 to i8***
	%_675 = load i8**, i8*** %_674
	%_676 = getelementptr i8*, i8** %_675, i32 20
	%_677 = load i8*, i8** %_676
	%_678 = bitcast i8* %_677 to i32 (i8*, i8*)*
	%_679 = call i32 %_678(i8* %_671, i8* %this)
	store i32 %_679, i32* %nti
	br label %if62
if61:
	store i32 0, i32* %nti
	br label %if62
if62:
	%_680 = load i8*, i8** %n
	%_681 = bitcast i8* %_680 to i8***
	%_682 = load i8**, i8*** %_681
	%_683 = getelementptr i8*, i8** %_682, i32 8
	%_684 = load i8*, i8** %_683
	%_685 = bitcast i8* %_684 to i1 (i8*)*
	%_686 = call i1 %_685(i8* %_680)
	br i1 %_686, label %if63, label %if64
if63:
	%_687 = load i8*, i8** %n
	%_688 = bitcast i8* %_687 to i8***
	%_689 = load i8**, i8*** %_688
	%_690 = getelementptr i8*, i8** %_689, i32 4
	%_691 = load i8*, i8** %_690
	%_692 = bitcast i8* %_691 to i8* (i8*)*
	%_693 = call i8* %_692(i8* %_687)
	%_694 = getelementptr i8, i8* %this, i32 8
	%_695 = bitcast i8* %_694 to i8**
	store i8* %_693, i8** %_695
	%_697 = getelementptr i8, i8* %this, i32 8
	%_698 = bitcast i8* %_697 to i8**
	%_696 = load i8*, i8** %_698
	%_699 = bitcast i8* %_696 to i8***
	%_700 = load i8**, i8*** %_699
	%_701 = getelementptr i8*, i8** %_700, i32 20
	%_702 = load i8*, i8** %_701
	%_703 = bitcast i8* %_702 to i32 (i8*, i8*)*
	%_704 = call i32 %_703(i8* %_696, i8* %this)
	store i32 %_704, i32* %nti
	br label %if65
if64:
	store i32 0, i32* %nti
	br label %if65
if65:
	ret i32 0
}

define i32 @MyVisitor.visit(i8* %this, i8* %.n) {
	%n = alloca i8*
	store i8* %.n, i8** %n
	%nti = alloca i32
	%_705 = load i8*, i8** %n
	%_706 = bitcast i8* %_705 to i8***
	%_707 = load i8**, i8*** %_706
	%_708 = getelementptr i8*, i8** %_707, i32 7
	%_709 = load i8*, i8** %_708
	%_710 = bitcast i8* %_709 to i1 (i8*)*
	%_711 = call i1 %_710(i8* %_705)
	br i1 %_711, label %if66, label %if67
if66:
	%_712 = load i8*, i8** %n
	%_713 = bitcast i8* %_712 to i8***
	%_714 = load i8**, i8*** %_713
	%_715 = getelementptr i8*, i8** %_714, i32 3
	%_716 = load i8*, i8** %_715
	%_717 = bitcast i8* %_716 to i8* (i8*)*
	%_718 = call i8* %_717(i8* %_712)
	%_719 = getelementptr i8, i8* %this, i32 16
	%_720 = bitcast i8* %_719 to i8**
	store i8* %_718, i8** %_720
	%_722 = getelementptr i8, i8* %this, i32 16
	%_723 = bitcast i8* %_722 to i8**
	%_721 = load i8*, i8** %_723
	%_724 = bitcast i8* %_721 to i8***
	%_725 = load i8**, i8*** %_724
	%_726 = getelementptr i8*, i8** %_725, i32 20
	%_727 = load i8*, i8** %_726
	%_728 = bitcast i8* %_727 to i32 (i8*, i8*)*
	%_729 = call i32 %_728(i8* %_721, i8* %this)
	store i32 %_729, i32* %nti
	br label %if68
if67:
	store i32 0, i32* %nti
	br label %if68
if68:
	%_730 = load i8*, i8** %n
	%_731 = bitcast i8* %_730 to i8***
	%_732 = load i8**, i8*** %_731
	%_733 = getelementptr i8*, i8** %_732, i32 5
	%_734 = load i8*, i8** %_733
	%_735 = bitcast i8* %_734 to i32 (i8*)*
	%_736 = call i32 %_735(i8* %_730)
	call void (i32) @print_int(i32 %_736)
	%_737 = load i8*, i8** %n
	%_738 = bitcast i8* %_737 to i8***
	%_739 = load i8**, i8*** %_738
	%_740 = getelementptr i8*, i8** %_739, i32 8
	%_741 = load i8*, i8** %_740
	%_742 = bitcast i8* %_741 to i1 (i8*)*
	%_743 = call i1 %_742(i8* %_737)
	br i1 %_743, label %if69, label %if70
if69:
	%_744 = load i8*, i8** %n
	%_745 = bitcast i8* %_744 to i8***
	%_746 = load i8**, i8*** %_745
	%_747 = getelementptr i8*, i8** %_746, i32 4
	%_748 = load i8*, i8** %_747
	%_749 = bitcast i8* %_748 to i8* (i8*)*
	%_750 = call i8* %_749(i8* %_744)
	%_751 = getelementptr i8, i8* %this, i32 8
	%_752 = bitcast i8* %_751 to i8**
	store i8* %_750, i8** %_752
	%_754 = getelementptr i8, i8* %this, i32 8
	%_755 = bitcast i8* %_754 to i8**
	%_753 = load i8*, i8** %_755
	%_756 = bitcast i8* %_753 to i8***
	%_757 = load i8**, i8*** %_756
	%_758 = getelementptr i8*, i8** %_757, i32 20
	%_759 = load i8*, i8** %_758
	%_760 = bitcast i8* %_759 to i32 (i8*, i8*)*
	%_761 = call i32 %_760(i8* %_753, i8* %this)
	store i32 %_761, i32* %nti
	br label %if71
if70:
	store i32 0, i32* %nti
	br label %if71
if71:
	ret i32 0
}


@.BubbleSort_vtable = global [0 x i8*] []
@.BBS_vtable = global [4 x i8*] [i8* bitcast (i32 (i8*, i32)* @BBS.Start to i8*), i8* bitcast (i32 (i8*)* @BBS.Sort to i8*), i8* bitcast (i32 (i8*)* @BBS.Print to i8*), i8* bitcast (i32 (i8*, i32)* @BBS.Init to i8*)]


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
	%_2 = getelementptr [4 x i8*], [4 x i8*]* @.BBS_vtable, i32 0, i32 0
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

define i32 @BBS.Start(i8* %this, i32 %.sz) {
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
	call void (i32) @print_int(i32 99999)
	%_22 = bitcast i8* %this to i8***
	%_23 = load i8**, i8*** %_22
	%_24 = getelementptr i8*, i8** %_23, i32 1
	%_25 = load i8*, i8** %_24
	%_26 = bitcast i8* %_25 to i32 (i8*)*
	%_27 = call i32 %_26(i8* %this)
	store i32 %_27, i32* %aux01
	%_28 = bitcast i8* %this to i8***
	%_29 = load i8**, i8*** %_28
	%_30 = getelementptr i8*, i8** %_29, i32 2
	%_31 = load i8*, i8** %_30
	%_32 = bitcast i8* %_31 to i32 (i8*)*
	%_33 = call i32 %_32(i8* %this)
	store i32 %_33, i32* %aux01
	ret i32 0
}

define i32 @BBS.Sort(i8* %this) {
	%nt = alloca i32
	%i = alloca i32
	%aux02 = alloca i32
	%aux04 = alloca i32
	%aux05 = alloca i32
	%aux06 = alloca i32
	%aux07 = alloca i32
	%j = alloca i32
	%t = alloca i32
	%_35 = getelementptr i8, i8* %this, i32 16
	%_36 = bitcast i8* %_35 to i32*
	%_34 = load i32, i32* %_36
	%_37 = sub i32 %_34, 1
	store i32 %_37, i32* %i
	%_38 = sub i32 0, 1
	store i32 %_38, i32* %aux02
	br label %loop0
loop0:
	%_39 = load i32, i32* %aux02
	%_40 = load i32, i32* %i
	%_41 = icmp slt i32 %_39, %_40
	br i1 %_41, label %loop1, label %loop2
loop1:
	store i32 1, i32* %j
	br label %loop3
loop3:
	%_42 = load i32, i32* %j
	%_43 = load i32, i32* %i
	%_44 = add i32 %_43, 1
	%_45 = icmp slt i32 %_42, %_44
	br i1 %_45, label %loop4, label %loop5
loop4:
	%_46 = load i32, i32* %j
	%_47 = sub i32 %_46, 1
	store i32 %_47, i32* %aux07
	%_49 = getelementptr i8, i8* %this, i32 8
	%_50 = bitcast i8* %_49 to i32**
	%_48 = load i32*, i32** %_50
	%_51 = load i32, i32* %aux07
	%_52 = load i32, i32* %_48
	%_53 = icmp ule i32 %_52, %_51
	br i1 %_53, label %oob0, label %oob1
oob0:
	call void @throw_oob()
	br label %oob1
oob1:
	%_54 = add i32 %_51, 1
	%_55 = getelementptr i32, i32* %_48, i32 %_54
	%_56 = load i32, i32* %_55
	store i32 %_56, i32* %aux04
	%_58 = getelementptr i8, i8* %this, i32 8
	%_59 = bitcast i8* %_58 to i32**
	%_57 = load i32*, i32** %_59
	%_60 = load i32, i32* %j
	%_61 = load i32, i32* %_57
	%_62 = icmp ule i32 %_61, %_60
	br i1 %_62, label %oob2, label %oob3
oob2:
	call void @throw_oob()
	br label %oob3
oob3:
	%_63 = add i32 %_60, 1
	%_64 = getelementptr i32, i32* %_57, i32 %_63
	%_65 = load i32, i32* %_64
	store i32 %_65, i32* %aux05
	%_66 = load i32, i32* %aux05
	%_67 = load i32, i32* %aux04
	%_68 = icmp slt i32 %_66, %_67
	br i1 %_68, label %if0, label %if1
if0:
	%_69 = load i32, i32* %j
	%_70 = sub i32 %_69, 1
	store i32 %_70, i32* %aux06
	%_72 = getelementptr i8, i8* %this, i32 8
	%_73 = bitcast i8* %_72 to i32**
	%_71 = load i32*, i32** %_73
	%_74 = load i32, i32* %aux06
	%_75 = load i32, i32* %_71
	%_76 = icmp ule i32 %_75, %_74
	br i1 %_76, label %oob4, label %oob5
oob4:
	call void @throw_oob()
	br label %oob5
oob5:
	%_77 = add i32 %_74, 1
	%_78 = getelementptr i32, i32* %_71, i32 %_77
	%_79 = load i32, i32* %_78
	store i32 %_79, i32* %t
	%_80 = load i32, i32* %aux06
	%_82 = getelementptr i8, i8* %this, i32 8
	%_83 = bitcast i8* %_82 to i32**
	%_81 = load i32*, i32** %_83
	%_84 = load i32, i32* %j
	%_85 = load i32, i32* %_81
	%_86 = icmp ule i32 %_85, %_84
	br i1 %_86, label %oob6, label %oob7
oob6:
	call void @throw_oob()
	br label %oob7
oob7:
	%_87 = add i32 %_84, 1
	%_88 = getelementptr i32, i32* %_81, i32 %_87
	%_89 = load i32, i32* %_88
	%_91 = getelementptr i8, i8* %this, i32 8
	%_92 = bitcast i8* %_91 to i32**
	%_90 = load i32*, i32** %_92
	%_93 = load i32, i32* %_90
	%_94 = icmp ule i32 %_93, %_80
	br i1 %_94, label %oob8, label %oob9
oob8:
	call void @throw_oob()
	br label %oob9
oob9:
	%_95 = add i32 %_80, 1
	%_96 = getelementptr i32, i32* %_90, i32 %_95
	store i32 %_89, i32* %_96
	%_97 = load i32, i32* %j
	%_98 = load i32, i32* %t
	%_100 = getelementptr i8, i8* %this, i32 8
	%_101 = bitcast i8* %_100 to i32**
	%_99 = load i32*, i32** %_101
	%_102 = load i32, i32* %_99
	%_103 = icmp ule i32 %_102, %_97
	br i1 %_103, label %oob10, label %oob11
oob10:
	call void @throw_oob()
	br label %oob11
oob11:
	%_104 = add i32 %_97, 1
	%_105 = getelementptr i32, i32* %_99, i32 %_104
	store i32 %_98, i32* %_105
	br label %if2
if1:
	store i32 0, i32* %nt
	br label %if2
if2:
	%_106 = load i32, i32* %j
	%_107 = add i32 %_106, 1
	store i32 %_107, i32* %j
	br label %loop3
loop5:
	%_108 = load i32, i32* %i
	%_109 = sub i32 %_108, 1
	store i32 %_109, i32* %i
	br label %loop0
loop2:
	ret i32 0
}

define i32 @BBS.Print(i8* %this) {
	%j = alloca i32
	store i32 0, i32* %j
	br label %loop6
loop6:
	%_110 = load i32, i32* %j
	%_112 = getelementptr i8, i8* %this, i32 16
	%_113 = bitcast i8* %_112 to i32*
	%_111 = load i32, i32* %_113
	%_114 = icmp slt i32 %_110, %_111
	br i1 %_114, label %loop7, label %loop8
loop7:
	%_116 = getelementptr i8, i8* %this, i32 8
	%_117 = bitcast i8* %_116 to i32**
	%_115 = load i32*, i32** %_117
	%_118 = load i32, i32* %j
	%_119 = load i32, i32* %_115
	%_120 = icmp ule i32 %_119, %_118
	br i1 %_120, label %oob12, label %oob13
oob12:
	call void @throw_oob()
	br label %oob13
oob13:
	%_121 = add i32 %_118, 1
	%_122 = getelementptr i32, i32* %_115, i32 %_121
	%_123 = load i32, i32* %_122
	call void (i32) @print_int(i32 %_123)
	%_124 = load i32, i32* %j
	%_125 = add i32 %_124, 1
	store i32 %_125, i32* %j
	br label %loop6
loop8:
	ret i32 0
}

define i32 @BBS.Init(i8* %this, i32 %.sz) {
	%sz = alloca i32
	store i32 %.sz, i32* %sz
	%_126 = load i32, i32* %sz
	%_127 = getelementptr i8, i8* %this, i32 16
	%_128 = bitcast i8* %_127 to i32*
	store i32 %_126, i32* %_128
	%_129 = load i32, i32* %sz
	%_130 = icmp slt i32 %_129, 0
	br i1 %_130, label %arr_alloc0, label %arr_alloc1
arr_alloc0:
	call void @throw_oob()
	br label %arr_alloc1
arr_alloc1:
	%_131 = add i32 %_129, 1
	%_132 = call i8* @calloc(i32 4, i32 %_131)
	%_133 = bitcast i8* %_132 to i32*
	store i32 %_129, i32* %_133
	%_134 = getelementptr i8, i8* %this, i32 8
	%_135 = bitcast i8* %_134 to i32**
	store i32* %_133, i32** %_135
	%_137 = getelementptr i8, i8* %this, i32 8
	%_138 = bitcast i8* %_137 to i32**
	%_136 = load i32*, i32** %_138
	%_139 = load i32, i32* %_136
	%_140 = icmp ule i32 %_139, 0
	br i1 %_140, label %oob14, label %oob15
oob14:
	call void @throw_oob()
	br label %oob15
oob15:
	%_141 = add i32 0, 1
	%_142 = getelementptr i32, i32* %_136, i32 %_141
	store i32 20, i32* %_142
	%_144 = getelementptr i8, i8* %this, i32 8
	%_145 = bitcast i8* %_144 to i32**
	%_143 = load i32*, i32** %_145
	%_146 = load i32, i32* %_143
	%_147 = icmp ule i32 %_146, 1
	br i1 %_147, label %oob16, label %oob17
oob16:
	call void @throw_oob()
	br label %oob17
oob17:
	%_148 = add i32 1, 1
	%_149 = getelementptr i32, i32* %_143, i32 %_148
	store i32 7, i32* %_149
	%_151 = getelementptr i8, i8* %this, i32 8
	%_152 = bitcast i8* %_151 to i32**
	%_150 = load i32*, i32** %_152
	%_153 = load i32, i32* %_150
	%_154 = icmp ule i32 %_153, 2
	br i1 %_154, label %oob18, label %oob19
oob18:
	call void @throw_oob()
	br label %oob19
oob19:
	%_155 = add i32 2, 1
	%_156 = getelementptr i32, i32* %_150, i32 %_155
	store i32 12, i32* %_156
	%_158 = getelementptr i8, i8* %this, i32 8
	%_159 = bitcast i8* %_158 to i32**
	%_157 = load i32*, i32** %_159
	%_160 = load i32, i32* %_157
	%_161 = icmp ule i32 %_160, 3
	br i1 %_161, label %oob20, label %oob21
oob20:
	call void @throw_oob()
	br label %oob21
oob21:
	%_162 = add i32 3, 1
	%_163 = getelementptr i32, i32* %_157, i32 %_162
	store i32 18, i32* %_163
	%_165 = getelementptr i8, i8* %this, i32 8
	%_166 = bitcast i8* %_165 to i32**
	%_164 = load i32*, i32** %_166
	%_167 = load i32, i32* %_164
	%_168 = icmp ule i32 %_167, 4
	br i1 %_168, label %oob22, label %oob23
oob22:
	call void @throw_oob()
	br label %oob23
oob23:
	%_169 = add i32 4, 1
	%_170 = getelementptr i32, i32* %_164, i32 %_169
	store i32 2, i32* %_170
	%_172 = getelementptr i8, i8* %this, i32 8
	%_173 = bitcast i8* %_172 to i32**
	%_171 = load i32*, i32** %_173
	%_174 = load i32, i32* %_171
	%_175 = icmp ule i32 %_174, 5
	br i1 %_175, label %oob24, label %oob25
oob24:
	call void @throw_oob()
	br label %oob25
oob25:
	%_176 = add i32 5, 1
	%_177 = getelementptr i32, i32* %_171, i32 %_176
	store i32 11, i32* %_177
	%_179 = getelementptr i8, i8* %this, i32 8
	%_180 = bitcast i8* %_179 to i32**
	%_178 = load i32*, i32** %_180
	%_181 = load i32, i32* %_178
	%_182 = icmp ule i32 %_181, 6
	br i1 %_182, label %oob26, label %oob27
oob26:
	call void @throw_oob()
	br label %oob27
oob27:
	%_183 = add i32 6, 1
	%_184 = getelementptr i32, i32* %_178, i32 %_183
	store i32 6, i32* %_184
	%_186 = getelementptr i8, i8* %this, i32 8
	%_187 = bitcast i8* %_186 to i32**
	%_185 = load i32*, i32** %_187
	%_188 = load i32, i32* %_185
	%_189 = icmp ule i32 %_188, 7
	br i1 %_189, label %oob28, label %oob29
oob28:
	call void @throw_oob()
	br label %oob29
oob29:
	%_190 = add i32 7, 1
	%_191 = getelementptr i32, i32* %_185, i32 %_190
	store i32 9, i32* %_191
	%_193 = getelementptr i8, i8* %this, i32 8
	%_194 = bitcast i8* %_193 to i32**
	%_192 = load i32*, i32** %_194
	%_195 = load i32, i32* %_192
	%_196 = icmp ule i32 %_195, 8
	br i1 %_196, label %oob30, label %oob31
oob30:
	call void @throw_oob()
	br label %oob31
oob31:
	%_197 = add i32 8, 1
	%_198 = getelementptr i32, i32* %_192, i32 %_197
	store i32 19, i32* %_198
	%_200 = getelementptr i8, i8* %this, i32 8
	%_201 = bitcast i8* %_200 to i32**
	%_199 = load i32*, i32** %_201
	%_202 = load i32, i32* %_199
	%_203 = icmp ule i32 %_202, 9
	br i1 %_203, label %oob32, label %oob33
oob32:
	call void @throw_oob()
	br label %oob33
oob33:
	%_204 = add i32 9, 1
	%_205 = getelementptr i32, i32* %_199, i32 %_204
	store i32 5, i32* %_205
	ret i32 0
}


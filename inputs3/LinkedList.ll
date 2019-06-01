@.LinkedList_vtable = global [0 x i8*] []
@.Element_vtable = global [6 x i8*] [i8* bitcast (i1 (i8*, i32, i32, i1)* @Element.Init to i8*), i8* bitcast (i32 (i8*)* @Element.GetAge to i8*), i8* bitcast (i32 (i8*)* @Element.GetSalary to i8*), i8* bitcast (i1 (i8*)* @Element.GetMarried to i8*), i8* bitcast (i1 (i8*, i8*)* @Element.Equal to i8*), i8* bitcast (i1 (i8*, i32, i32)* @Element.Compare to i8*)]
@.List_vtable = global [10 x i8*] [i8* bitcast (i1 (i8*)* @List.Init to i8*), i8* bitcast (i1 (i8*, i8*, i8*, i1)* @List.InitNew to i8*), i8* bitcast (i8* (i8*, i8*)* @List.Insert to i8*), i8* bitcast (i1 (i8*, i8*)* @List.SetNext to i8*), i8* bitcast (i8* (i8*, i8*)* @List.Delete to i8*), i8* bitcast (i32 (i8*, i8*)* @List.Search to i8*), i8* bitcast (i1 (i8*)* @List.GetEnd to i8*), i8* bitcast (i8* (i8*)* @List.GetElem to i8*), i8* bitcast (i8* (i8*)* @List.GetNext to i8*), i8* bitcast (i1 (i8*)* @List.Print to i8*)]
@.LL_vtable = global [1 x i8*] [i8* bitcast (i32 (i8*)* @LL.Start to i8*)]


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
	%_2 = getelementptr [1 x i8*], [1 x i8*]* @.LL_vtable, i32 0, i32 0
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

define i1 @Element.Init(i8* %this, i32 %.v_Age, i32 %.v_Salary, i1 %.v_Married) {
	%v_Age = alloca i32
	store i32 %.v_Age, i32* %v_Age
	%v_Salary = alloca i32
	store i32 %.v_Salary, i32* %v_Salary
	%v_Married = alloca i1
	store i1 %.v_Married, i1* %v_Married
	%_9 = load i32, i32* %v_Age
	%_10 = getelementptr i8, i8* %this, i32 8
	%_11 = bitcast i8* %_10 to i32*
	store i32 %_9, i32* %_11
	%_12 = load i32, i32* %v_Salary
	%_13 = getelementptr i8, i8* %this, i32 12
	%_14 = bitcast i8* %_13 to i32*
	store i32 %_12, i32* %_14
	%_15 = load i1, i1* %v_Married
	%_16 = getelementptr i8, i8* %this, i32 16
	%_17 = bitcast i8* %_16 to i1*
	store i1 %_15, i1* %_17
	ret i1 1
}

define i32 @Element.GetAge(i8* %this) {
	%_19 = getelementptr i8, i8* %this, i32 8
	%_20 = bitcast i8* %_19 to i32*
	%_18 = load i32, i32* %_20
	ret i32 %_18
}

define i32 @Element.GetSalary(i8* %this) {
	%_22 = getelementptr i8, i8* %this, i32 12
	%_23 = bitcast i8* %_22 to i32*
	%_21 = load i32, i32* %_23
	ret i32 %_21
}

define i1 @Element.GetMarried(i8* %this) {
	%_25 = getelementptr i8, i8* %this, i32 16
	%_26 = bitcast i8* %_25 to i1*
	%_24 = load i1, i1* %_26
	ret i1 %_24
}

define i1 @Element.Equal(i8* %this, i8* %.other) {
	%other = alloca i8*
	store i8* %.other, i8** %other
	%ret_val = alloca i1
	%aux01 = alloca i32
	%aux02 = alloca i32
	%nt = alloca i32
	store i1 1, i1* %ret_val
	%_27 = load i8*, i8** %other
	%_28 = bitcast i8* %_27 to i8***
	%_29 = load i8**, i8*** %_28
	%_30 = getelementptr i8*, i8** %_29, i32 1
	%_31 = load i8*, i8** %_30
	%_32 = bitcast i8* %_31 to i32 (i8*)*
	%_33 = call i32 %_32(i8* %_27)
	store i32 %_33, i32* %aux01
	%_34 = load i32, i32* %aux01
	%_36 = getelementptr i8, i8* %this, i32 8
	%_37 = bitcast i8* %_36 to i32*
	%_35 = load i32, i32* %_37
	%_38 = bitcast i8* %this to i8***
	%_39 = load i8**, i8*** %_38
	%_40 = getelementptr i8*, i8** %_39, i32 5
	%_41 = load i8*, i8** %_40
	%_42 = bitcast i8* %_41 to i1 (i8*, i32, i32)*
	%_43 = call i1 %_42(i8* %this, i32 %_34, i32 %_35)
	%_44 = xor i1 1, %_43
	br i1 %_44, label %if0, label %if1
if0:
	store i1 0, i1* %ret_val
	br label %if2
if1:
	%_45 = load i8*, i8** %other
	%_46 = bitcast i8* %_45 to i8***
	%_47 = load i8**, i8*** %_46
	%_48 = getelementptr i8*, i8** %_47, i32 2
	%_49 = load i8*, i8** %_48
	%_50 = bitcast i8* %_49 to i32 (i8*)*
	%_51 = call i32 %_50(i8* %_45)
	store i32 %_51, i32* %aux02
	%_52 = load i32, i32* %aux02
	%_54 = getelementptr i8, i8* %this, i32 12
	%_55 = bitcast i8* %_54 to i32*
	%_53 = load i32, i32* %_55
	%_56 = bitcast i8* %this to i8***
	%_57 = load i8**, i8*** %_56
	%_58 = getelementptr i8*, i8** %_57, i32 5
	%_59 = load i8*, i8** %_58
	%_60 = bitcast i8* %_59 to i1 (i8*, i32, i32)*
	%_61 = call i1 %_60(i8* %this, i32 %_52, i32 %_53)
	%_62 = xor i1 1, %_61
	br i1 %_62, label %if3, label %if4
if3:
	store i1 0, i1* %ret_val
	br label %if5
if4:
	%_64 = getelementptr i8, i8* %this, i32 16
	%_65 = bitcast i8* %_64 to i1*
	%_63 = load i1, i1* %_65
	br i1 %_63, label %if6, label %if7
if6:
	%_66 = load i8*, i8** %other
	%_67 = bitcast i8* %_66 to i8***
	%_68 = load i8**, i8*** %_67
	%_69 = getelementptr i8*, i8** %_68, i32 3
	%_70 = load i8*, i8** %_69
	%_71 = bitcast i8* %_70 to i1 (i8*)*
	%_72 = call i1 %_71(i8* %_66)
	%_73 = xor i1 1, %_72
	br i1 %_73, label %if9, label %if10
if9:
	store i1 0, i1* %ret_val
	br label %if11
if10:
	store i32 0, i32* %nt
	br label %if11
if11:
	br label %if8
if7:
	%_74 = load i8*, i8** %other
	%_75 = bitcast i8* %_74 to i8***
	%_76 = load i8**, i8*** %_75
	%_77 = getelementptr i8*, i8** %_76, i32 3
	%_78 = load i8*, i8** %_77
	%_79 = bitcast i8* %_78 to i1 (i8*)*
	%_80 = call i1 %_79(i8* %_74)
	br i1 %_80, label %if12, label %if13
if12:
	store i1 0, i1* %ret_val
	br label %if14
if13:
	store i32 0, i32* %nt
	br label %if14
if14:
	br label %if8
if8:
	br label %if5
if5:
	br label %if2
if2:
	%_81 = load i1, i1* %ret_val
	ret i1 %_81
}

define i1 @Element.Compare(i8* %this, i32 %.num1, i32 %.num2) {
	%num1 = alloca i32
	store i32 %.num1, i32* %num1
	%num2 = alloca i32
	store i32 %.num2, i32* %num2
	%retval = alloca i1
	%aux02 = alloca i32
	store i1 0, i1* %retval
	%_82 = load i32, i32* %num2
	%_83 = add i32 %_82, 1
	store i32 %_83, i32* %aux02
	%_84 = load i32, i32* %num1
	%_85 = load i32, i32* %num2
	%_86 = icmp slt i32 %_84, %_85
	br i1 %_86, label %if15, label %if16
if15:
	store i1 0, i1* %retval
	br label %if17
if16:
	%_87 = load i32, i32* %num1
	%_88 = load i32, i32* %aux02
	%_89 = icmp slt i32 %_87, %_88
	%_90 = xor i1 1, %_89
	br i1 %_90, label %if18, label %if19
if18:
	store i1 0, i1* %retval
	br label %if20
if19:
	store i1 1, i1* %retval
	br label %if20
if20:
	br label %if17
if17:
	%_91 = load i1, i1* %retval
	ret i1 %_91
}

define i1 @List.Init(i8* %this) {
	%_92 = getelementptr i8, i8* %this, i32 24
	%_93 = bitcast i8* %_92 to i1*
	store i1 1, i1* %_93
	ret i1 1
}

define i1 @List.InitNew(i8* %this, i8* %.v_elem, i8* %.v_next, i1 %.v_end) {
	%v_elem = alloca i8*
	store i8* %.v_elem, i8** %v_elem
	%v_next = alloca i8*
	store i8* %.v_next, i8** %v_next
	%v_end = alloca i1
	store i1 %.v_end, i1* %v_end
	%_94 = load i1, i1* %v_end
	%_95 = getelementptr i8, i8* %this, i32 24
	%_96 = bitcast i8* %_95 to i1*
	store i1 %_94, i1* %_96
	%_97 = load i8*, i8** %v_elem
	%_98 = getelementptr i8, i8* %this, i32 8
	%_99 = bitcast i8* %_98 to i8**
	store i8* %_97, i8** %_99
	%_100 = load i8*, i8** %v_next
	%_101 = getelementptr i8, i8* %this, i32 16
	%_102 = bitcast i8* %_101 to i8**
	store i8* %_100, i8** %_102
	ret i1 1
}

define i8* @List.Insert(i8* %this, i8* %.new_elem) {
	%new_elem = alloca i8*
	store i8* %.new_elem, i8** %new_elem
	%ret_val = alloca i1
	%aux03 = alloca i8*
	%aux02 = alloca i8*
	store i8* %this, i8** %aux03
	%_103 = call i8* @calloc(i32 1, i32 25)
	%_104 = bitcast i8* %_103 to i8***
	%_105 = getelementptr [10 x i8*], [10 x i8*]* @.List_vtable, i32 0, i32 0
	store i8** %_105, i8*** %_104
	store i8* %_103, i8** %aux02
	%_106 = load i8*, i8** %aux02
	%_107 = load i8*, i8** %new_elem
	%_108 = load i8*, i8** %aux03
	%_109 = bitcast i8* %_106 to i8***
	%_110 = load i8**, i8*** %_109
	%_111 = getelementptr i8*, i8** %_110, i32 1
	%_112 = load i8*, i8** %_111
	%_113 = bitcast i8* %_112 to i1 (i8*, i8*, i8*, i1)*
	%_114 = call i1 %_113(i8* %_106, i8* %_107, i8* %_108, i1 0)
	store i1 %_114, i1* %ret_val
	%_115 = load i8*, i8** %aux02
	ret i8* %_115
}

define i1 @List.SetNext(i8* %this, i8* %.v_next) {
	%v_next = alloca i8*
	store i8* %.v_next, i8** %v_next
	%_116 = load i8*, i8** %v_next
	%_117 = getelementptr i8, i8* %this, i32 16
	%_118 = bitcast i8* %_117 to i8**
	store i8* %_116, i8** %_118
	ret i1 1
}

define i8* @List.Delete(i8* %this, i8* %.e) {
	%e = alloca i8*
	store i8* %.e, i8** %e
	%my_head = alloca i8*
	%ret_val = alloca i1
	%aux05 = alloca i1
	%aux01 = alloca i8*
	%prev = alloca i8*
	%var_end = alloca i1
	%var_elem = alloca i8*
	%aux04 = alloca i32
	%nt = alloca i32
	store i8* %this, i8** %my_head
	store i1 0, i1* %ret_val
	%_119 = sub i32 0, 1
	store i32 %_119, i32* %aux04
	store i8* %this, i8** %aux01
	store i8* %this, i8** %prev
	%_121 = getelementptr i8, i8* %this, i32 24
	%_122 = bitcast i8* %_121 to i1*
	%_120 = load i1, i1* %_122
	store i1 %_120, i1* %var_end
	%_124 = getelementptr i8, i8* %this, i32 8
	%_125 = bitcast i8* %_124 to i8**
	%_123 = load i8*, i8** %_125
	store i8* %_123, i8** %var_elem
	br label %loop0
loop0:
	br label %andclause0
andclause0:
	%_126 = load i1, i1* %var_end
	%_127 = xor i1 1, %_126
	br i1 %_127, label %andclause1, label %andclause2
andclause1:
	%_128 = load i1, i1* %ret_val
	%_129 = xor i1 1, %_128
	br label %andclause2
andclause2:
	%_130 = phi i1 [0, %andclause0], [%_129, %andclause1]
	br i1 %_130, label %loop1, label %loop2
loop1:
	%_131 = load i8*, i8** %e
	%_132 = load i8*, i8** %var_elem
	%_133 = bitcast i8* %_131 to i8***
	%_134 = load i8**, i8*** %_133
	%_135 = getelementptr i8*, i8** %_134, i32 4
	%_136 = load i8*, i8** %_135
	%_137 = bitcast i8* %_136 to i1 (i8*, i8*)*
	%_138 = call i1 %_137(i8* %_131, i8* %_132)
	br i1 %_138, label %if21, label %if22
if21:
	store i1 1, i1* %ret_val
	%_139 = load i32, i32* %aux04
	%_140 = icmp slt i32 %_139, 0
	br i1 %_140, label %if24, label %if25
if24:
	%_141 = load i8*, i8** %aux01
	%_142 = bitcast i8* %_141 to i8***
	%_143 = load i8**, i8*** %_142
	%_144 = getelementptr i8*, i8** %_143, i32 8
	%_145 = load i8*, i8** %_144
	%_146 = bitcast i8* %_145 to i8* (i8*)*
	%_147 = call i8* %_146(i8* %_141)
	store i8* %_147, i8** %my_head
	br label %if26
if25:
	%_148 = sub i32 0, 555
	call void (i32) @print_int(i32 %_148)
	%_149 = load i8*, i8** %prev
	%_150 = load i8*, i8** %aux01
	%_151 = bitcast i8* %_150 to i8***
	%_152 = load i8**, i8*** %_151
	%_153 = getelementptr i8*, i8** %_152, i32 8
	%_154 = load i8*, i8** %_153
	%_155 = bitcast i8* %_154 to i8* (i8*)*
	%_156 = call i8* %_155(i8* %_150)
	%_157 = bitcast i8* %_149 to i8***
	%_158 = load i8**, i8*** %_157
	%_159 = getelementptr i8*, i8** %_158, i32 3
	%_160 = load i8*, i8** %_159
	%_161 = bitcast i8* %_160 to i1 (i8*, i8*)*
	%_162 = call i1 %_161(i8* %_149, i8* %_156)
	store i1 %_162, i1* %aux05
	%_163 = sub i32 0, 555
	call void (i32) @print_int(i32 %_163)
	br label %if26
if26:
	br label %if23
if22:
	store i32 0, i32* %nt
	br label %if23
if23:
	%_164 = load i1, i1* %ret_val
	%_165 = xor i1 1, %_164
	br i1 %_165, label %if27, label %if28
if27:
	%_166 = load i8*, i8** %aux01
	store i8* %_166, i8** %prev
	%_167 = load i8*, i8** %aux01
	%_168 = bitcast i8* %_167 to i8***
	%_169 = load i8**, i8*** %_168
	%_170 = getelementptr i8*, i8** %_169, i32 8
	%_171 = load i8*, i8** %_170
	%_172 = bitcast i8* %_171 to i8* (i8*)*
	%_173 = call i8* %_172(i8* %_167)
	store i8* %_173, i8** %aux01
	%_174 = load i8*, i8** %aux01
	%_175 = bitcast i8* %_174 to i8***
	%_176 = load i8**, i8*** %_175
	%_177 = getelementptr i8*, i8** %_176, i32 6
	%_178 = load i8*, i8** %_177
	%_179 = bitcast i8* %_178 to i1 (i8*)*
	%_180 = call i1 %_179(i8* %_174)
	store i1 %_180, i1* %var_end
	%_181 = load i8*, i8** %aux01
	%_182 = bitcast i8* %_181 to i8***
	%_183 = load i8**, i8*** %_182
	%_184 = getelementptr i8*, i8** %_183, i32 7
	%_185 = load i8*, i8** %_184
	%_186 = bitcast i8* %_185 to i8* (i8*)*
	%_187 = call i8* %_186(i8* %_181)
	store i8* %_187, i8** %var_elem
	store i32 1, i32* %aux04
	br label %if29
if28:
	store i32 0, i32* %nt
	br label %if29
if29:
	br label %loop0
loop2:
	%_188 = load i8*, i8** %my_head
	ret i8* %_188
}

define i32 @List.Search(i8* %this, i8* %.e) {
	%e = alloca i8*
	store i8* %.e, i8** %e
	%int_ret_val = alloca i32
	%aux01 = alloca i8*
	%var_elem = alloca i8*
	%var_end = alloca i1
	%nt = alloca i32
	store i32 0, i32* %int_ret_val
	store i8* %this, i8** %aux01
	%_190 = getelementptr i8, i8* %this, i32 24
	%_191 = bitcast i8* %_190 to i1*
	%_189 = load i1, i1* %_191
	store i1 %_189, i1* %var_end
	%_193 = getelementptr i8, i8* %this, i32 8
	%_194 = bitcast i8* %_193 to i8**
	%_192 = load i8*, i8** %_194
	store i8* %_192, i8** %var_elem
	br label %loop3
loop3:
	%_195 = load i1, i1* %var_end
	%_196 = xor i1 1, %_195
	br i1 %_196, label %loop4, label %loop5
loop4:
	%_197 = load i8*, i8** %e
	%_198 = load i8*, i8** %var_elem
	%_199 = bitcast i8* %_197 to i8***
	%_200 = load i8**, i8*** %_199
	%_201 = getelementptr i8*, i8** %_200, i32 4
	%_202 = load i8*, i8** %_201
	%_203 = bitcast i8* %_202 to i1 (i8*, i8*)*
	%_204 = call i1 %_203(i8* %_197, i8* %_198)
	br i1 %_204, label %if30, label %if31
if30:
	store i32 1, i32* %int_ret_val
	br label %if32
if31:
	store i32 0, i32* %nt
	br label %if32
if32:
	%_205 = load i8*, i8** %aux01
	%_206 = bitcast i8* %_205 to i8***
	%_207 = load i8**, i8*** %_206
	%_208 = getelementptr i8*, i8** %_207, i32 8
	%_209 = load i8*, i8** %_208
	%_210 = bitcast i8* %_209 to i8* (i8*)*
	%_211 = call i8* %_210(i8* %_205)
	store i8* %_211, i8** %aux01
	%_212 = load i8*, i8** %aux01
	%_213 = bitcast i8* %_212 to i8***
	%_214 = load i8**, i8*** %_213
	%_215 = getelementptr i8*, i8** %_214, i32 6
	%_216 = load i8*, i8** %_215
	%_217 = bitcast i8* %_216 to i1 (i8*)*
	%_218 = call i1 %_217(i8* %_212)
	store i1 %_218, i1* %var_end
	%_219 = load i8*, i8** %aux01
	%_220 = bitcast i8* %_219 to i8***
	%_221 = load i8**, i8*** %_220
	%_222 = getelementptr i8*, i8** %_221, i32 7
	%_223 = load i8*, i8** %_222
	%_224 = bitcast i8* %_223 to i8* (i8*)*
	%_225 = call i8* %_224(i8* %_219)
	store i8* %_225, i8** %var_elem
	br label %loop3
loop5:
	%_226 = load i32, i32* %int_ret_val
	ret i32 %_226
}

define i1 @List.GetEnd(i8* %this) {
	%_228 = getelementptr i8, i8* %this, i32 24
	%_229 = bitcast i8* %_228 to i1*
	%_227 = load i1, i1* %_229
	ret i1 %_227
}

define i8* @List.GetElem(i8* %this) {
	%_231 = getelementptr i8, i8* %this, i32 8
	%_232 = bitcast i8* %_231 to i8**
	%_230 = load i8*, i8** %_232
	ret i8* %_230
}

define i8* @List.GetNext(i8* %this) {
	%_234 = getelementptr i8, i8* %this, i32 16
	%_235 = bitcast i8* %_234 to i8**
	%_233 = load i8*, i8** %_235
	ret i8* %_233
}

define i1 @List.Print(i8* %this) {
	%aux01 = alloca i8*
	%var_end = alloca i1
	%var_elem = alloca i8*
	store i8* %this, i8** %aux01
	%_237 = getelementptr i8, i8* %this, i32 24
	%_238 = bitcast i8* %_237 to i1*
	%_236 = load i1, i1* %_238
	store i1 %_236, i1* %var_end
	%_240 = getelementptr i8, i8* %this, i32 8
	%_241 = bitcast i8* %_240 to i8**
	%_239 = load i8*, i8** %_241
	store i8* %_239, i8** %var_elem
	br label %loop6
loop6:
	%_242 = load i1, i1* %var_end
	%_243 = xor i1 1, %_242
	br i1 %_243, label %loop7, label %loop8
loop7:
	%_244 = load i8*, i8** %var_elem
	%_245 = bitcast i8* %_244 to i8***
	%_246 = load i8**, i8*** %_245
	%_247 = getelementptr i8*, i8** %_246, i32 1
	%_248 = load i8*, i8** %_247
	%_249 = bitcast i8* %_248 to i32 (i8*)*
	%_250 = call i32 %_249(i8* %_244)
	call void (i32) @print_int(i32 %_250)
	%_251 = load i8*, i8** %aux01
	%_252 = bitcast i8* %_251 to i8***
	%_253 = load i8**, i8*** %_252
	%_254 = getelementptr i8*, i8** %_253, i32 8
	%_255 = load i8*, i8** %_254
	%_256 = bitcast i8* %_255 to i8* (i8*)*
	%_257 = call i8* %_256(i8* %_251)
	store i8* %_257, i8** %aux01
	%_258 = load i8*, i8** %aux01
	%_259 = bitcast i8* %_258 to i8***
	%_260 = load i8**, i8*** %_259
	%_261 = getelementptr i8*, i8** %_260, i32 6
	%_262 = load i8*, i8** %_261
	%_263 = bitcast i8* %_262 to i1 (i8*)*
	%_264 = call i1 %_263(i8* %_258)
	store i1 %_264, i1* %var_end
	%_265 = load i8*, i8** %aux01
	%_266 = bitcast i8* %_265 to i8***
	%_267 = load i8**, i8*** %_266
	%_268 = getelementptr i8*, i8** %_267, i32 7
	%_269 = load i8*, i8** %_268
	%_270 = bitcast i8* %_269 to i8* (i8*)*
	%_271 = call i8* %_270(i8* %_265)
	store i8* %_271, i8** %var_elem
	br label %loop6
loop8:
	ret i1 1
}

define i32 @LL.Start(i8* %this) {
	%head = alloca i8*
	%last_elem = alloca i8*
	%aux01 = alloca i1
	%el01 = alloca i8*
	%el02 = alloca i8*
	%el03 = alloca i8*
	%_272 = call i8* @calloc(i32 1, i32 25)
	%_273 = bitcast i8* %_272 to i8***
	%_274 = getelementptr [10 x i8*], [10 x i8*]* @.List_vtable, i32 0, i32 0
	store i8** %_274, i8*** %_273
	store i8* %_272, i8** %last_elem
	%_275 = load i8*, i8** %last_elem
	%_276 = bitcast i8* %_275 to i8***
	%_277 = load i8**, i8*** %_276
	%_278 = getelementptr i8*, i8** %_277, i32 0
	%_279 = load i8*, i8** %_278
	%_280 = bitcast i8* %_279 to i1 (i8*)*
	%_281 = call i1 %_280(i8* %_275)
	store i1 %_281, i1* %aux01
	%_282 = load i8*, i8** %last_elem
	store i8* %_282, i8** %head
	%_283 = load i8*, i8** %head
	%_284 = bitcast i8* %_283 to i8***
	%_285 = load i8**, i8*** %_284
	%_286 = getelementptr i8*, i8** %_285, i32 0
	%_287 = load i8*, i8** %_286
	%_288 = bitcast i8* %_287 to i1 (i8*)*
	%_289 = call i1 %_288(i8* %_283)
	store i1 %_289, i1* %aux01
	%_290 = load i8*, i8** %head
	%_291 = bitcast i8* %_290 to i8***
	%_292 = load i8**, i8*** %_291
	%_293 = getelementptr i8*, i8** %_292, i32 9
	%_294 = load i8*, i8** %_293
	%_295 = bitcast i8* %_294 to i1 (i8*)*
	%_296 = call i1 %_295(i8* %_290)
	store i1 %_296, i1* %aux01
	%_297 = call i8* @calloc(i32 1, i32 17)
	%_298 = bitcast i8* %_297 to i8***
	%_299 = getelementptr [6 x i8*], [6 x i8*]* @.Element_vtable, i32 0, i32 0
	store i8** %_299, i8*** %_298
	store i8* %_297, i8** %el01
	%_300 = load i8*, i8** %el01
	%_301 = bitcast i8* %_300 to i8***
	%_302 = load i8**, i8*** %_301
	%_303 = getelementptr i8*, i8** %_302, i32 0
	%_304 = load i8*, i8** %_303
	%_305 = bitcast i8* %_304 to i1 (i8*, i32, i32, i1)*
	%_306 = call i1 %_305(i8* %_300, i32 25, i32 37000, i1 0)
	store i1 %_306, i1* %aux01
	%_307 = load i8*, i8** %head
	%_308 = load i8*, i8** %el01
	%_309 = bitcast i8* %_307 to i8***
	%_310 = load i8**, i8*** %_309
	%_311 = getelementptr i8*, i8** %_310, i32 2
	%_312 = load i8*, i8** %_311
	%_313 = bitcast i8* %_312 to i8* (i8*, i8*)*
	%_314 = call i8* %_313(i8* %_307, i8* %_308)
	store i8* %_314, i8** %head
	%_315 = load i8*, i8** %head
	%_316 = bitcast i8* %_315 to i8***
	%_317 = load i8**, i8*** %_316
	%_318 = getelementptr i8*, i8** %_317, i32 9
	%_319 = load i8*, i8** %_318
	%_320 = bitcast i8* %_319 to i1 (i8*)*
	%_321 = call i1 %_320(i8* %_315)
	store i1 %_321, i1* %aux01
	call void (i32) @print_int(i32 10000000)
	%_322 = call i8* @calloc(i32 1, i32 17)
	%_323 = bitcast i8* %_322 to i8***
	%_324 = getelementptr [6 x i8*], [6 x i8*]* @.Element_vtable, i32 0, i32 0
	store i8** %_324, i8*** %_323
	store i8* %_322, i8** %el01
	%_325 = load i8*, i8** %el01
	%_326 = bitcast i8* %_325 to i8***
	%_327 = load i8**, i8*** %_326
	%_328 = getelementptr i8*, i8** %_327, i32 0
	%_329 = load i8*, i8** %_328
	%_330 = bitcast i8* %_329 to i1 (i8*, i32, i32, i1)*
	%_331 = call i1 %_330(i8* %_325, i32 39, i32 42000, i1 1)
	store i1 %_331, i1* %aux01
	%_332 = load i8*, i8** %el01
	store i8* %_332, i8** %el02
	%_333 = load i8*, i8** %head
	%_334 = load i8*, i8** %el01
	%_335 = bitcast i8* %_333 to i8***
	%_336 = load i8**, i8*** %_335
	%_337 = getelementptr i8*, i8** %_336, i32 2
	%_338 = load i8*, i8** %_337
	%_339 = bitcast i8* %_338 to i8* (i8*, i8*)*
	%_340 = call i8* %_339(i8* %_333, i8* %_334)
	store i8* %_340, i8** %head
	%_341 = load i8*, i8** %head
	%_342 = bitcast i8* %_341 to i8***
	%_343 = load i8**, i8*** %_342
	%_344 = getelementptr i8*, i8** %_343, i32 9
	%_345 = load i8*, i8** %_344
	%_346 = bitcast i8* %_345 to i1 (i8*)*
	%_347 = call i1 %_346(i8* %_341)
	store i1 %_347, i1* %aux01
	call void (i32) @print_int(i32 10000000)
	%_348 = call i8* @calloc(i32 1, i32 17)
	%_349 = bitcast i8* %_348 to i8***
	%_350 = getelementptr [6 x i8*], [6 x i8*]* @.Element_vtable, i32 0, i32 0
	store i8** %_350, i8*** %_349
	store i8* %_348, i8** %el01
	%_351 = load i8*, i8** %el01
	%_352 = bitcast i8* %_351 to i8***
	%_353 = load i8**, i8*** %_352
	%_354 = getelementptr i8*, i8** %_353, i32 0
	%_355 = load i8*, i8** %_354
	%_356 = bitcast i8* %_355 to i1 (i8*, i32, i32, i1)*
	%_357 = call i1 %_356(i8* %_351, i32 22, i32 34000, i1 0)
	store i1 %_357, i1* %aux01
	%_358 = load i8*, i8** %head
	%_359 = load i8*, i8** %el01
	%_360 = bitcast i8* %_358 to i8***
	%_361 = load i8**, i8*** %_360
	%_362 = getelementptr i8*, i8** %_361, i32 2
	%_363 = load i8*, i8** %_362
	%_364 = bitcast i8* %_363 to i8* (i8*, i8*)*
	%_365 = call i8* %_364(i8* %_358, i8* %_359)
	store i8* %_365, i8** %head
	%_366 = load i8*, i8** %head
	%_367 = bitcast i8* %_366 to i8***
	%_368 = load i8**, i8*** %_367
	%_369 = getelementptr i8*, i8** %_368, i32 9
	%_370 = load i8*, i8** %_369
	%_371 = bitcast i8* %_370 to i1 (i8*)*
	%_372 = call i1 %_371(i8* %_366)
	store i1 %_372, i1* %aux01
	%_373 = call i8* @calloc(i32 1, i32 17)
	%_374 = bitcast i8* %_373 to i8***
	%_375 = getelementptr [6 x i8*], [6 x i8*]* @.Element_vtable, i32 0, i32 0
	store i8** %_375, i8*** %_374
	store i8* %_373, i8** %el03
	%_376 = load i8*, i8** %el03
	%_377 = bitcast i8* %_376 to i8***
	%_378 = load i8**, i8*** %_377
	%_379 = getelementptr i8*, i8** %_378, i32 0
	%_380 = load i8*, i8** %_379
	%_381 = bitcast i8* %_380 to i1 (i8*, i32, i32, i1)*
	%_382 = call i1 %_381(i8* %_376, i32 27, i32 34000, i1 0)
	store i1 %_382, i1* %aux01
	%_383 = load i8*, i8** %head
	%_384 = load i8*, i8** %el02
	%_385 = bitcast i8* %_383 to i8***
	%_386 = load i8**, i8*** %_385
	%_387 = getelementptr i8*, i8** %_386, i32 5
	%_388 = load i8*, i8** %_387
	%_389 = bitcast i8* %_388 to i32 (i8*, i8*)*
	%_390 = call i32 %_389(i8* %_383, i8* %_384)
	call void (i32) @print_int(i32 %_390)
	%_391 = load i8*, i8** %head
	%_392 = load i8*, i8** %el03
	%_393 = bitcast i8* %_391 to i8***
	%_394 = load i8**, i8*** %_393
	%_395 = getelementptr i8*, i8** %_394, i32 5
	%_396 = load i8*, i8** %_395
	%_397 = bitcast i8* %_396 to i32 (i8*, i8*)*
	%_398 = call i32 %_397(i8* %_391, i8* %_392)
	call void (i32) @print_int(i32 %_398)
	call void (i32) @print_int(i32 10000000)
	%_399 = call i8* @calloc(i32 1, i32 17)
	%_400 = bitcast i8* %_399 to i8***
	%_401 = getelementptr [6 x i8*], [6 x i8*]* @.Element_vtable, i32 0, i32 0
	store i8** %_401, i8*** %_400
	store i8* %_399, i8** %el01
	%_402 = load i8*, i8** %el01
	%_403 = bitcast i8* %_402 to i8***
	%_404 = load i8**, i8*** %_403
	%_405 = getelementptr i8*, i8** %_404, i32 0
	%_406 = load i8*, i8** %_405
	%_407 = bitcast i8* %_406 to i1 (i8*, i32, i32, i1)*
	%_408 = call i1 %_407(i8* %_402, i32 28, i32 35000, i1 0)
	store i1 %_408, i1* %aux01
	%_409 = load i8*, i8** %head
	%_410 = load i8*, i8** %el01
	%_411 = bitcast i8* %_409 to i8***
	%_412 = load i8**, i8*** %_411
	%_413 = getelementptr i8*, i8** %_412, i32 2
	%_414 = load i8*, i8** %_413
	%_415 = bitcast i8* %_414 to i8* (i8*, i8*)*
	%_416 = call i8* %_415(i8* %_409, i8* %_410)
	store i8* %_416, i8** %head
	%_417 = load i8*, i8** %head
	%_418 = bitcast i8* %_417 to i8***
	%_419 = load i8**, i8*** %_418
	%_420 = getelementptr i8*, i8** %_419, i32 9
	%_421 = load i8*, i8** %_420
	%_422 = bitcast i8* %_421 to i1 (i8*)*
	%_423 = call i1 %_422(i8* %_417)
	store i1 %_423, i1* %aux01
	call void (i32) @print_int(i32 2220000)
	%_424 = load i8*, i8** %head
	%_425 = load i8*, i8** %el02
	%_426 = bitcast i8* %_424 to i8***
	%_427 = load i8**, i8*** %_426
	%_428 = getelementptr i8*, i8** %_427, i32 4
	%_429 = load i8*, i8** %_428
	%_430 = bitcast i8* %_429 to i8* (i8*, i8*)*
	%_431 = call i8* %_430(i8* %_424, i8* %_425)
	store i8* %_431, i8** %head
	%_432 = load i8*, i8** %head
	%_433 = bitcast i8* %_432 to i8***
	%_434 = load i8**, i8*** %_433
	%_435 = getelementptr i8*, i8** %_434, i32 9
	%_436 = load i8*, i8** %_435
	%_437 = bitcast i8* %_436 to i1 (i8*)*
	%_438 = call i1 %_437(i8* %_432)
	store i1 %_438, i1* %aux01
	call void (i32) @print_int(i32 33300000)
	%_439 = load i8*, i8** %head
	%_440 = load i8*, i8** %el01
	%_441 = bitcast i8* %_439 to i8***
	%_442 = load i8**, i8*** %_441
	%_443 = getelementptr i8*, i8** %_442, i32 4
	%_444 = load i8*, i8** %_443
	%_445 = bitcast i8* %_444 to i8* (i8*, i8*)*
	%_446 = call i8* %_445(i8* %_439, i8* %_440)
	store i8* %_446, i8** %head
	%_447 = load i8*, i8** %head
	%_448 = bitcast i8* %_447 to i8***
	%_449 = load i8**, i8*** %_448
	%_450 = getelementptr i8*, i8** %_449, i32 9
	%_451 = load i8*, i8** %_450
	%_452 = bitcast i8* %_451 to i1 (i8*)*
	%_453 = call i1 %_452(i8* %_447)
	store i1 %_453, i1* %aux01
	call void (i32) @print_int(i32 44440000)
	ret i32 0
}


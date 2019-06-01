@.LinearSearch_vtable = global [0 x i8*] []
@.LS_vtable = global [4 x i8*] [i8* bitcast (i32 (i8*, i32)* @LS.Start to i8*), i8* bitcast (i32 (i8*)* @LS.Print to i8*), i8* bitcast (i32 (i8*, i32)* @LS.Search to i8*), i8* bitcast (i32 (i8*, i32)* @LS.Init to i8*)]


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
	%_2 = getelementptr [4 x i8*], [4 x i8*]* @.LS_vtable, i32 0, i32 0
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

define i32 @LS.Start(i8* %this, i32 %.sz) {
	%sz = alloca i32
	store i32 %.sz, i32* %sz
	%aux01 = alloca i32
	%aux02 = alloca i32
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
	%_18 = getelementptr i8*, i8** %_17, i32 1
	%_19 = load i8*, i8** %_18
	%_20 = bitcast i8* %_19 to i32 (i8*)*
	%_21 = call i32 %_20(i8* %this)
	store i32 %_21, i32* %aux02
	call void (i32) @print_int(i32 9999)
	%_22 = bitcast i8* %this to i8***
	%_23 = load i8**, i8*** %_22
	%_24 = getelementptr i8*, i8** %_23, i32 2
	%_25 = load i8*, i8** %_24
	%_26 = bitcast i8* %_25 to i32 (i8*, i32)*
	%_27 = call i32 %_26(i8* %this, i32 8)
	call void (i32) @print_int(i32 %_27)
	%_28 = bitcast i8* %this to i8***
	%_29 = load i8**, i8*** %_28
	%_30 = getelementptr i8*, i8** %_29, i32 2
	%_31 = load i8*, i8** %_30
	%_32 = bitcast i8* %_31 to i32 (i8*, i32)*
	%_33 = call i32 %_32(i8* %this, i32 12)
	call void (i32) @print_int(i32 %_33)
	%_34 = bitcast i8* %this to i8***
	%_35 = load i8**, i8*** %_34
	%_36 = getelementptr i8*, i8** %_35, i32 2
	%_37 = load i8*, i8** %_36
	%_38 = bitcast i8* %_37 to i32 (i8*, i32)*
	%_39 = call i32 %_38(i8* %this, i32 17)
	call void (i32) @print_int(i32 %_39)
	%_40 = bitcast i8* %this to i8***
	%_41 = load i8**, i8*** %_40
	%_42 = getelementptr i8*, i8** %_41, i32 2
	%_43 = load i8*, i8** %_42
	%_44 = bitcast i8* %_43 to i32 (i8*, i32)*
	%_45 = call i32 %_44(i8* %this, i32 50)
	call void (i32) @print_int(i32 %_45)
	ret i32 55
}

define i32 @LS.Print(i8* %this) {
	%j = alloca i32
	store i32 1, i32* %j
	br label %loop0
loop0:
	%_46 = load i32, i32* %j
	%_48 = getelementptr i8, i8* %this, i32 16
	%_49 = bitcast i8* %_48 to i32*
	%_47 = load i32, i32* %_49
	%_50 = icmp slt i32 %_46, %_47
	br i1 %_50, label %loop1, label %loop2
loop1:
	%_52 = getelementptr i8, i8* %this, i32 8
	%_53 = bitcast i8* %_52 to i32**
	%_51 = load i32*, i32** %_53
	%_54 = load i32, i32* %j
	%_55 = load i32, i32* %_51
	%_56 = icmp ule i32 %_55, %_54
	br i1 %_56, label %oob0, label %oob1
oob0:
	call void @throw_oob()
	br label %oob1
oob1:
	%_57 = add i32 %_54, 1
	%_58 = getelementptr i32, i32* %_51, i32 %_57
	%_59 = load i32, i32* %_58
	call void (i32) @print_int(i32 %_59)
	%_60 = load i32, i32* %j
	%_61 = add i32 %_60, 1
	store i32 %_61, i32* %j
	br label %loop0
loop2:
	ret i32 0
}

define i32 @LS.Search(i8* %this, i32 %.num) {
	%num = alloca i32
	store i32 %.num, i32* %num
	%j = alloca i32
	%ls01 = alloca i1
	%ifound = alloca i32
	%aux01 = alloca i32
	%aux02 = alloca i32
	%nt = alloca i32
	store i32 1, i32* %j
	store i1 0, i1* %ls01
	store i32 0, i32* %ifound
	br label %loop3
loop3:
	%_62 = load i32, i32* %j
	%_64 = getelementptr i8, i8* %this, i32 16
	%_65 = bitcast i8* %_64 to i32*
	%_63 = load i32, i32* %_65
	%_66 = icmp slt i32 %_62, %_63
	br i1 %_66, label %loop4, label %loop5
loop4:
	%_68 = getelementptr i8, i8* %this, i32 8
	%_69 = bitcast i8* %_68 to i32**
	%_67 = load i32*, i32** %_69
	%_70 = load i32, i32* %j
	%_71 = load i32, i32* %_67
	%_72 = icmp ule i32 %_71, %_70
	br i1 %_72, label %oob2, label %oob3
oob2:
	call void @throw_oob()
	br label %oob3
oob3:
	%_73 = add i32 %_70, 1
	%_74 = getelementptr i32, i32* %_67, i32 %_73
	%_75 = load i32, i32* %_74
	store i32 %_75, i32* %aux01
	%_76 = load i32, i32* %num
	%_77 = add i32 %_76, 1
	store i32 %_77, i32* %aux02
	%_78 = load i32, i32* %aux01
	%_79 = load i32, i32* %num
	%_80 = icmp slt i32 %_78, %_79
	br i1 %_80, label %if0, label %if1
if0:
	store i32 0, i32* %nt
	br label %if2
if1:
	%_81 = load i32, i32* %aux01
	%_82 = load i32, i32* %aux02
	%_83 = icmp slt i32 %_81, %_82
	%_84 = xor i1 1, %_83
	br i1 %_84, label %if3, label %if4
if3:
	store i32 0, i32* %nt
	br label %if5
if4:
	store i1 1, i1* %ls01
	store i32 1, i32* %ifound
	%_86 = getelementptr i8, i8* %this, i32 16
	%_87 = bitcast i8* %_86 to i32*
	%_85 = load i32, i32* %_87
	store i32 %_85, i32* %j
	br label %if5
if5:
	br label %if2
if2:
	%_88 = load i32, i32* %j
	%_89 = add i32 %_88, 1
	store i32 %_89, i32* %j
	br label %loop3
loop5:
	%_90 = load i32, i32* %ifound
	ret i32 %_90
}

define i32 @LS.Init(i8* %this, i32 %.sz) {
	%sz = alloca i32
	store i32 %.sz, i32* %sz
	%j = alloca i32
	%k = alloca i32
	%aux01 = alloca i32
	%aux02 = alloca i32
	%_91 = load i32, i32* %sz
	%_92 = getelementptr i8, i8* %this, i32 16
	%_93 = bitcast i8* %_92 to i32*
	store i32 %_91, i32* %_93
	%_94 = load i32, i32* %sz
	%_95 = icmp slt i32 %_94, 0
	br i1 %_95, label %arr_alloc0, label %arr_alloc1
arr_alloc0:
	call void @throw_oob()
	br label %arr_alloc1
arr_alloc1:
	%_96 = add i32 %_94, 1
	%_97 = call i8* @calloc(i32 4, i32 %_96)
	%_98 = bitcast i8* %_97 to i32*
	store i32 %_94, i32* %_98
	%_99 = getelementptr i8, i8* %this, i32 8
	%_100 = bitcast i8* %_99 to i32**
	store i32* %_98, i32** %_100
	store i32 1, i32* %j
	%_102 = getelementptr i8, i8* %this, i32 16
	%_103 = bitcast i8* %_102 to i32*
	%_101 = load i32, i32* %_103
	%_104 = add i32 %_101, 1
	store i32 %_104, i32* %k
	br label %loop6
loop6:
	%_105 = load i32, i32* %j
	%_107 = getelementptr i8, i8* %this, i32 16
	%_108 = bitcast i8* %_107 to i32*
	%_106 = load i32, i32* %_108
	%_109 = icmp slt i32 %_105, %_106
	br i1 %_109, label %loop7, label %loop8
loop7:
	%_110 = load i32, i32* %j
	%_111 = mul i32 2, %_110
	store i32 %_111, i32* %aux01
	%_112 = load i32, i32* %k
	%_113 = sub i32 %_112, 3
	store i32 %_113, i32* %aux02
	%_114 = load i32, i32* %j
	%_115 = load i32, i32* %aux01
	%_116 = load i32, i32* %aux02
	%_117 = add i32 %_115, %_116
	%_119 = getelementptr i8, i8* %this, i32 8
	%_120 = bitcast i8* %_119 to i32**
	%_118 = load i32*, i32** %_120
	%_121 = load i32, i32* %_118
	%_122 = icmp ule i32 %_121, %_114
	br i1 %_122, label %oob4, label %oob5
oob4:
	call void @throw_oob()
	br label %oob5
oob5:
	%_123 = add i32 %_114, 1
	%_124 = getelementptr i32, i32* %_118, i32 %_123
	store i32 %_117, i32* %_124
	%_125 = load i32, i32* %j
	%_126 = add i32 %_125, 1
	store i32 %_126, i32* %j
	%_127 = load i32, i32* %k
	%_128 = sub i32 %_127, 1
	store i32 %_128, i32* %k
	br label %loop6
loop8:
	ret i32 0
}


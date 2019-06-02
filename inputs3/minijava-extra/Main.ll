@.Main_vtable = global [0 x i8*] []
@.ArrayTest_vtable = global [1 x i8*] [i8* bitcast (i32 (i8*, i32)* @ArrayTest.test to i8*)]
@.B_vtable = global [1 x i8*] [i8* bitcast (i32 (i8*, i32)* @B.test to i8*)]


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
	%ab = alloca i8*
	%_0 = call i8* @calloc(i32 1, i32 20)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [1 x i8*], [1 x i8*]* @.ArrayTest_vtable, i32 0, i32 0
	store i8** %_2, i8*** %_1
	store i8* %_0, i8** %ab
	%_3 = load i8*, i8** %ab
	%_4 = bitcast i8* %_3 to i8***
	%_5 = load i8**, i8*** %_4
	%_6 = getelementptr i8*, i8** %_5, i32 0
	%_7 = load i8*, i8** %_6
	%_8 = bitcast i8* %_7 to i32 (i8*, i32)*
	%_9 = call i32 %_8(i8* %_3, i32 3)
	call void (i32) @print_int(i32 %_9)
	ret i32 0
}

define i32 @ArrayTest.test(i8* %this, i32 %.num) {
	%num = alloca i32
	store i32 %.num, i32* %num
	%i = alloca i32
	%intArray = alloca i32*
	%_10 = load i32, i32* %num
	%_11 = icmp slt i32 %_10, 0
	br i1 %_11, label %arr_alloc0, label %arr_alloc1
arr_alloc0:
	call void @throw_oob()
	br label %arr_alloc1
arr_alloc1:
	%_12 = add i32 %_10, 1
	%_13 = call i8* @calloc(i32 4, i32 %_12)
	%_14 = bitcast i8* %_13 to i32*
	store i32 %_10, i32* %_14
	store i32* %_14, i32** %intArray
	%_15 = getelementptr i8, i8* %this, i32 16
	%_16 = bitcast i8* %_15 to i32*
	store i32 0, i32* %_16
	%_18 = getelementptr i8, i8* %this, i32 16
	%_19 = bitcast i8* %_18 to i32*
	%_17 = load i32, i32* %_19
	call void (i32) @print_int(i32 %_17)
	%_20 = load i32*, i32** %intArray
	%_21 = load i32, i32* %_20
	call void (i32) @print_int(i32 %_21)
	store i32 0, i32* %i
	call void (i32) @print_int(i32 111)
	br label %loop0
loop0:
	%_22 = load i32, i32* %i
	%_23 = load i32*, i32** %intArray
	%_24 = load i32, i32* %_23
	%_25 = icmp slt i32 %_22, %_24
	br i1 %_25, label %loop1, label %loop2
loop1:
	%_26 = load i32, i32* %i
	%_27 = add i32 %_26, 1
	call void (i32) @print_int(i32 %_27)
	%_28 = load i32, i32* %i
	%_29 = load i32, i32* %i
	%_30 = add i32 %_29, 1
	%_31 = load i32*, i32** %intArray
	%_32 = load i32, i32* %_31
	%_33 = icmp ule i32 %_32, %_28
	br i1 %_33, label %oob0, label %oob1
oob0:
	call void @throw_oob()
	br label %oob1
oob1:
	%_34 = add i32 %_28, 1
	%_35 = getelementptr i32, i32* %_31, i32 %_34
	store i32 %_30, i32* %_35
	%_36 = load i32, i32* %i
	%_37 = add i32 %_36, 1
	store i32 %_37, i32* %i
	br label %loop0
loop2:
	call void (i32) @print_int(i32 222)
	store i32 0, i32* %i
	br label %loop3
loop3:
	%_38 = load i32, i32* %i
	%_39 = load i32*, i32** %intArray
	%_40 = load i32, i32* %_39
	%_41 = icmp slt i32 %_38, %_40
	br i1 %_41, label %loop4, label %loop5
loop4:
	%_42 = load i32*, i32** %intArray
	%_43 = load i32, i32* %i
	%_44 = load i32, i32* %_42
	%_45 = icmp ule i32 %_44, %_43
	br i1 %_45, label %oob2, label %oob3
oob2:
	call void @throw_oob()
	br label %oob3
oob3:
	%_46 = add i32 %_43, 1
	%_47 = getelementptr i32, i32* %_42, i32 %_46
	%_48 = load i32, i32* %_47
	call void (i32) @print_int(i32 %_48)
	%_49 = load i32, i32* %i
	%_50 = add i32 %_49, 1
	store i32 %_50, i32* %i
	br label %loop3
loop5:
	call void (i32) @print_int(i32 333)
	%_51 = load i32*, i32** %intArray
	%_52 = load i32, i32* %_51
	ret i32 %_52
}

define i32 @B.test(i8* %this, i32 %.num) {
	%num = alloca i32
	store i32 %.num, i32* %num
	%i = alloca i32
	%intArray = alloca i32*
	%_53 = load i32, i32* %num
	%_54 = icmp slt i32 %_53, 0
	br i1 %_54, label %arr_alloc2, label %arr_alloc3
arr_alloc2:
	call void @throw_oob()
	br label %arr_alloc3
arr_alloc3:
	%_55 = add i32 %_53, 1
	%_56 = call i8* @calloc(i32 4, i32 %_55)
	%_57 = bitcast i8* %_56 to i32*
	store i32 %_53, i32* %_57
	store i32* %_57, i32** %intArray
	%_58 = getelementptr i8, i8* %this, i32 20
	%_59 = bitcast i8* %_58 to i32*
	store i32 12, i32* %_59
	%_61 = getelementptr i8, i8* %this, i32 20
	%_62 = bitcast i8* %_61 to i32*
	%_60 = load i32, i32* %_62
	call void (i32) @print_int(i32 %_60)
	%_63 = load i32*, i32** %intArray
	%_64 = load i32, i32* %_63
	call void (i32) @print_int(i32 %_64)
	store i32 0, i32* %i
	call void (i32) @print_int(i32 111)
	br label %loop6
loop6:
	%_65 = load i32, i32* %i
	%_66 = load i32*, i32** %intArray
	%_67 = load i32, i32* %_66
	%_68 = icmp slt i32 %_65, %_67
	br i1 %_68, label %loop7, label %loop8
loop7:
	%_69 = load i32, i32* %i
	%_70 = add i32 %_69, 1
	call void (i32) @print_int(i32 %_70)
	%_71 = load i32, i32* %i
	%_72 = load i32, i32* %i
	%_73 = add i32 %_72, 1
	%_74 = load i32*, i32** %intArray
	%_75 = load i32, i32* %_74
	%_76 = icmp ule i32 %_75, %_71
	br i1 %_76, label %oob4, label %oob5
oob4:
	call void @throw_oob()
	br label %oob5
oob5:
	%_77 = add i32 %_71, 1
	%_78 = getelementptr i32, i32* %_74, i32 %_77
	store i32 %_73, i32* %_78
	%_79 = load i32, i32* %i
	%_80 = add i32 %_79, 1
	store i32 %_80, i32* %i
	br label %loop6
loop8:
	call void (i32) @print_int(i32 222)
	store i32 0, i32* %i
	br label %loop9
loop9:
	%_81 = load i32, i32* %i
	%_82 = load i32*, i32** %intArray
	%_83 = load i32, i32* %_82
	%_84 = icmp slt i32 %_81, %_83
	br i1 %_84, label %loop10, label %loop11
loop10:
	%_85 = load i32*, i32** %intArray
	%_86 = load i32, i32* %i
	%_87 = load i32, i32* %_85
	%_88 = icmp ule i32 %_87, %_86
	br i1 %_88, label %oob6, label %oob7
oob6:
	call void @throw_oob()
	br label %oob7
oob7:
	%_89 = add i32 %_86, 1
	%_90 = getelementptr i32, i32* %_85, i32 %_89
	%_91 = load i32, i32* %_90
	call void (i32) @print_int(i32 %_91)
	%_92 = load i32, i32* %i
	%_93 = add i32 %_92, 1
	store i32 %_93, i32* %i
	br label %loop9
loop11:
	call void (i32) @print_int(i32 333)
	%_94 = load i32*, i32** %intArray
	%_95 = load i32, i32* %_94
	ret i32 %_95
}


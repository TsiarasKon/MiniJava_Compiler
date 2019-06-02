@.test20_vtable = global [0 x i8*] []
@.A23_vtable = global [3 x i8*] [i8* bitcast (i32 (i8*, i8*)* @A23.init to i8*), i8* bitcast (i32 (i8*)* @A23.getI1 to i8*), i8* bitcast (i32 (i8*, i32)* @A23.setI1 to i8*)]
@.B23_vtable = global [3 x i8*] [i8* bitcast (i32 (i8*, i8*)* @B23.init to i8*), i8* bitcast (i32 (i8*)* @B23.getI1 to i8*), i8* bitcast (i32 (i8*, i32)* @B23.setI1 to i8*)]
@.C23_vtable = global [3 x i8*] [i8* bitcast (i32 (i8*, i8*)* @C23.init to i8*), i8* bitcast (i32 (i8*)* @C23.getI1 to i8*), i8* bitcast (i32 (i8*, i32)* @C23.setI1 to i8*)]


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
	%_0 = call i8* @calloc(i32 1, i32 36)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [3 x i8*], [3 x i8*]* @.C23_vtable, i32 0, i32 0
	store i8** %_2, i8*** %_1
	%_3 = call i8* @calloc(i32 1, i32 28)
	%_4 = bitcast i8* %_3 to i8***
	%_5 = getelementptr [3 x i8*], [3 x i8*]* @.B23_vtable, i32 0, i32 0
	store i8** %_5, i8*** %_4
	%_6 = bitcast i8* %_0 to i8***
	%_7 = load i8**, i8*** %_6
	%_8 = getelementptr i8*, i8** %_7, i32 0
	%_9 = load i8*, i8** %_8
	%_10 = bitcast i8* %_9 to i32 (i8*, i8*)*
	%_11 = call i32 %_10(i8* %_0, i8* %_3)
	call void (i32) @print_int(i32 %_11)
	ret i32 0
}

define i32 @A23.init(i8* %this, i8* %.a) {
	%a = alloca i8*
	store i8* %.a, i8** %a
	%_12 = load i8*, i8** %a
	%_13 = bitcast i8* %_12 to i8***
	%_14 = load i8**, i8*** %_13
	%_15 = getelementptr i8*, i8** %_14, i32 1
	%_16 = load i8*, i8** %_15
	%_17 = bitcast i8* %_16 to i32 (i8*)*
	%_18 = call i32 %_17(i8* %_12)
	%_19 = getelementptr i8, i8* %this, i32 12
	%_20 = bitcast i8* %_19 to i32*
	store i32 %_18, i32* %_20
	%_21 = getelementptr i8, i8* %this, i32 16
	%_22 = bitcast i8* %_21 to i32*
	store i32 222, i32* %_22
	%_24 = getelementptr i8, i8* %this, i32 12
	%_25 = bitcast i8* %_24 to i32*
	%_23 = load i32, i32* %_25
	%_27 = getelementptr i8, i8* %this, i32 16
	%_28 = bitcast i8* %_27 to i32*
	%_26 = load i32, i32* %_28
	%_29 = add i32 %_23, %_26
	%_30 = bitcast i8* %this to i8***
	%_31 = load i8**, i8*** %_30
	%_32 = getelementptr i8*, i8** %_31, i32 2
	%_33 = load i8*, i8** %_32
	%_34 = bitcast i8* %_33 to i32 (i8*, i32)*
	%_35 = call i32 %_34(i8* %this, i32 %_29)
	%_36 = getelementptr i8, i8* %this, i32 8
	%_37 = bitcast i8* %_36 to i32*
	store i32 %_35, i32* %_37
	%_39 = getelementptr i8, i8* %this, i32 8
	%_40 = bitcast i8* %_39 to i32*
	%_38 = load i32, i32* %_40
	ret i32 %_38
}

define i32 @A23.getI1(i8* %this) {
	%_42 = getelementptr i8, i8* %this, i32 8
	%_43 = bitcast i8* %_42 to i32*
	%_41 = load i32, i32* %_43
	ret i32 %_41
}

define i32 @A23.setI1(i8* %this, i32 %.i) {
	%i = alloca i32
	store i32 %.i, i32* %i
	%_44 = load i32, i32* %i
	ret i32 %_44
}

define i32 @B23.init(i8* %this, i8* %.a) {
	%a = alloca i8*
	store i8* %.a, i8** %a
	%a_local = alloca i8*
	%_45 = call i8* @calloc(i32 1, i32 20)
	%_46 = bitcast i8* %_45 to i8***
	%_47 = getelementptr [3 x i8*], [3 x i8*]* @.A23_vtable, i32 0, i32 0
	store i8** %_47, i8*** %_46
	store i8* %_45, i8** %a_local
	%_48 = load i8*, i8** %a
	%_49 = bitcast i8* %_48 to i8***
	%_50 = load i8**, i8*** %_49
	%_51 = getelementptr i8*, i8** %_50, i32 1
	%_52 = load i8*, i8** %_51
	%_53 = bitcast i8* %_52 to i32 (i8*)*
	%_54 = call i32 %_53(i8* %_48)
	%_55 = getelementptr i8, i8* %this, i32 24
	%_56 = bitcast i8* %_55 to i32*
	store i32 %_54, i32* %_56
	%_58 = getelementptr i8, i8* %this, i32 24
	%_59 = bitcast i8* %_58 to i32*
	%_57 = load i32, i32* %_59
	%_60 = bitcast i8* %this to i8***
	%_61 = load i8**, i8*** %_60
	%_62 = getelementptr i8*, i8** %_61, i32 2
	%_63 = load i8*, i8** %_62
	%_64 = bitcast i8* %_63 to i32 (i8*, i32)*
	%_65 = call i32 %_64(i8* %this, i32 %_57)
	%_66 = getelementptr i8, i8* %this, i32 20
	%_67 = bitcast i8* %_66 to i32*
	store i32 %_65, i32* %_67
	%_68 = load i8*, i8** %a_local
	%_69 = bitcast i8* %_68 to i8***
	%_70 = load i8**, i8*** %_69
	%_71 = getelementptr i8*, i8** %_70, i32 0
	%_72 = load i8*, i8** %_71
	%_73 = bitcast i8* %_72 to i32 (i8*, i8*)*
	%_74 = call i32 %_73(i8* %_68, i8* %this)
	ret i32 %_74
}

define i32 @B23.getI1(i8* %this) {
	%_76 = getelementptr i8, i8* %this, i32 20
	%_77 = bitcast i8* %_76 to i32*
	%_75 = load i32, i32* %_77
	ret i32 %_75
}

define i32 @B23.setI1(i8* %this, i32 %.i) {
	%i = alloca i32
	store i32 %.i, i32* %i
	%_78 = load i32, i32* %i
	%_79 = add i32 %_78, 111
	ret i32 %_79
}

define i32 @C23.init(i8* %this, i8* %.a) {
	%a = alloca i8*
	store i8* %.a, i8** %a
	%_80 = getelementptr i8, i8* %this, i32 32
	%_81 = bitcast i8* %_80 to i32*
	store i32 333, i32* %_81
	%_83 = getelementptr i8, i8* %this, i32 32
	%_84 = bitcast i8* %_83 to i32*
	%_82 = load i32, i32* %_84
	%_85 = bitcast i8* %this to i8***
	%_86 = load i8**, i8*** %_85
	%_87 = getelementptr i8*, i8** %_86, i32 2
	%_88 = load i8*, i8** %_87
	%_89 = bitcast i8* %_88 to i32 (i8*, i32)*
	%_90 = call i32 %_89(i8* %this, i32 %_82)
	%_91 = getelementptr i8, i8* %this, i32 28
	%_92 = bitcast i8* %_91 to i32*
	store i32 %_90, i32* %_92
	%_93 = load i8*, i8** %a
	%_94 = bitcast i8* %_93 to i8***
	%_95 = load i8**, i8*** %_94
	%_96 = getelementptr i8*, i8** %_95, i32 0
	%_97 = load i8*, i8** %_96
	%_98 = bitcast i8* %_97 to i32 (i8*, i8*)*
	%_99 = call i32 %_98(i8* %_93, i8* %this)
	ret i32 %_99
}

define i32 @C23.getI1(i8* %this) {
	%_101 = getelementptr i8, i8* %this, i32 28
	%_102 = bitcast i8* %_101 to i32*
	%_100 = load i32, i32* %_102
	ret i32 %_100
}

define i32 @C23.setI1(i8* %this, i32 %.i) {
	%i = alloca i32
	store i32 %.i, i32* %i
	%_103 = load i32, i32* %i
	%_104 = mul i32 %_103, 2
	ret i32 %_104
}


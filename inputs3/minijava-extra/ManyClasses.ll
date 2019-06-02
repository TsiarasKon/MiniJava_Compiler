@.ManyClasses_vtable = global [0 x i8*] []
@.A_vtable = global [1 x i8*] [i8* bitcast (i32 (i8*)* @A.get to i8*)]
@.B_vtable = global [2 x i8*] [i8* bitcast (i32 (i8*)* @A.get to i8*), i8* bitcast (i1 (i8*)* @B.set to i8*)]
@.C_vtable = global [3 x i8*] [i8* bitcast (i32 (i8*)* @C.get to i8*), i8* bitcast (i1 (i8*)* @B.set to i8*), i8* bitcast (i1 (i8*)* @C.reset to i8*)]


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
	%rv = alloca i1
	%a = alloca i8*
	%b = alloca i8*
	%c = alloca i8*
	%_0 = call i8* @calloc(i32 1, i32 9)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [2 x i8*], [2 x i8*]* @.B_vtable, i32 0, i32 0
	store i8** %_2, i8*** %_1
	store i8* %_0, i8** %b
	%_3 = call i8* @calloc(i32 1, i32 9)
	%_4 = bitcast i8* %_3 to i8***
	%_5 = getelementptr [3 x i8*], [3 x i8*]* @.C_vtable, i32 0, i32 0
	store i8** %_5, i8*** %_4
	store i8* %_3, i8** %c
	%_6 = load i8*, i8** %b
	%_7 = bitcast i8* %_6 to i8***
	%_8 = load i8**, i8*** %_7
	%_9 = getelementptr i8*, i8** %_8, i32 1
	%_10 = load i8*, i8** %_9
	%_11 = bitcast i8* %_10 to i1 (i8*)*
	%_12 = call i1 %_11(i8* %_6)
	store i1 %_12, i1* %rv
	%_13 = load i8*, i8** %c
	%_14 = bitcast i8* %_13 to i8***
	%_15 = load i8**, i8*** %_14
	%_16 = getelementptr i8*, i8** %_15, i32 2
	%_17 = load i8*, i8** %_16
	%_18 = bitcast i8* %_17 to i1 (i8*)*
	%_19 = call i1 %_18(i8* %_13)
	store i1 %_19, i1* %rv
	%_20 = load i8*, i8** %b
	%_21 = bitcast i8* %_20 to i8***
	%_22 = load i8**, i8*** %_21
	%_23 = getelementptr i8*, i8** %_22, i32 0
	%_24 = load i8*, i8** %_23
	%_25 = bitcast i8* %_24 to i32 (i8*)*
	%_26 = call i32 %_25(i8* %_20)
	call void (i32) @print_int(i32 %_26)
	%_27 = load i8*, i8** %c
	%_28 = bitcast i8* %_27 to i8***
	%_29 = load i8**, i8*** %_28
	%_30 = getelementptr i8*, i8** %_29, i32 0
	%_31 = load i8*, i8** %_30
	%_32 = bitcast i8* %_31 to i32 (i8*)*
	%_33 = call i32 %_32(i8* %_27)
	call void (i32) @print_int(i32 %_33)
	ret i32 0
}

define i32 @A.get(i8* %this) {
	%rv = alloca i32
	%_35 = getelementptr i8, i8* %this, i32 8
	%_36 = bitcast i8* %_35 to i1*
	%_34 = load i1, i1* %_36
	br i1 %_34, label %if0, label %if1
if0:
	store i32 1, i32* %rv
	br label %if2
if1:
	store i32 0, i32* %rv
	br label %if2
if2:
	%_37 = load i32, i32* %rv
	ret i32 %_37
}

define i1 @B.set(i8* %this) {
	%old = alloca i1
	%_39 = getelementptr i8, i8* %this, i32 8
	%_40 = bitcast i8* %_39 to i1*
	%_38 = load i1, i1* %_40
	store i1 %_38, i1* %old
	%_41 = getelementptr i8, i8* %this, i32 8
	%_42 = bitcast i8* %_41 to i1*
	store i1 1, i1* %_42
	%_44 = getelementptr i8, i8* %this, i32 8
	%_45 = bitcast i8* %_44 to i1*
	%_43 = load i1, i1* %_45
	ret i1 %_43
}

define i1 @C.reset(i8* %this) {
	%old = alloca i1
	%_47 = getelementptr i8, i8* %this, i32 8
	%_48 = bitcast i8* %_47 to i1*
	%_46 = load i1, i1* %_48
	store i1 %_46, i1* %old
	%_49 = getelementptr i8, i8* %this, i32 8
	%_50 = bitcast i8* %_49 to i1*
	store i1 0, i1* %_50
	%_52 = getelementptr i8, i8* %this, i32 8
	%_53 = bitcast i8* %_52 to i1*
	%_51 = load i1, i1* %_53
	ret i1 %_51
}

define i32 @C.get(i8* %this) {
	ret i32 42
}


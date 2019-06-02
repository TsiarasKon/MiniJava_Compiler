@.ShadowField_vtable = global [0 x i8*] []
@.A_vtable = global [2 x i8*] [i8* bitcast (i8* (i8*)* @A.foo to i8*), i8* bitcast (i32 (i8*)* @A.get to i8*)]


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
	%a = alloca i8*
	%_0 = call i8* @calloc(i32 1, i32 12)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [2 x i8*], [2 x i8*]* @.A_vtable, i32 0, i32 0
	store i8** %_2, i8*** %_1
	store i8* %_0, i8** %a
	%_3 = load i8*, i8** %a
	%_4 = bitcast i8* %_3 to i8***
	%_5 = load i8**, i8*** %_4
	%_6 = getelementptr i8*, i8** %_5, i32 0
	%_7 = load i8*, i8** %_6
	%_8 = bitcast i8* %_7 to i8* (i8*)*
	%_9 = call i8* %_8(i8* %_3)
	store i8* %_9, i8** %a
	%_10 = load i8*, i8** %a
	%_11 = bitcast i8* %_10 to i8***
	%_12 = load i8**, i8*** %_11
	%_13 = getelementptr i8*, i8** %_12, i32 1
	%_14 = load i8*, i8** %_13
	%_15 = bitcast i8* %_14 to i32 (i8*)*
	%_16 = call i32 %_15(i8* %_10)
	call void (i32) @print_int(i32 %_16)
	ret i32 0
}

define i8* @A.foo(i8* %this) {
	%x = alloca i8*
	%_17 = call i8* @calloc(i32 1, i32 12)
	%_18 = bitcast i8* %_17 to i8***
	%_19 = getelementptr [2 x i8*], [2 x i8*]* @.A_vtable, i32 0, i32 0
	store i8** %_19, i8*** %_18
	%_20 = getelementptr i8, i8* %this, i32 8
	%_21 = bitcast i8* %_20 to i8**
	store i8* %_17, i8** %_21
	%_23 = getelementptr i8, i8* %this, i32 8
	%_24 = bitcast i8* %_23 to i8**
	%_22 = load i8*, i8** %_24
	ret i8* %_22
}

define i32 @A.get(i8* %this) {
	%_26 = getelementptr i8, i8* %this, i32 8
	%_27 = bitcast i8* %_26 to i32*
	%_25 = load i32, i32* %_27
	ret i32 %_25
}


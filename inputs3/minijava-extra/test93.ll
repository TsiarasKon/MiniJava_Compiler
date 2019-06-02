@.test93_vtable = global [0 x i8*] []
@.Test_vtable = global [2 x i8*] [i8* bitcast (i32 (i8*)* @Test.start to i8*), i8* bitcast (i8* (i8*)* @Test.next to i8*)]


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
	%_0 = call i8* @calloc(i32 1, i32 24)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [2 x i8*], [2 x i8*]* @.Test_vtable, i32 0, i32 0
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

define i32 @Test.start(i8* %this) {
	%_9 = icmp slt i32 10, 0
	br i1 %_9, label %arr_alloc0, label %arr_alloc1
arr_alloc0:
	call void @throw_oob()
	br label %arr_alloc1
arr_alloc1:
	%_10 = add i32 10, 1
	%_11 = call i8* @calloc(i32 4, i32 %_10)
	%_12 = bitcast i8* %_11 to i32*
	store i32 10, i32* %_12
	%_13 = getelementptr i8, i8* %this, i32 16
	%_14 = bitcast i8* %_13 to i32**
	store i32* %_12, i32** %_14
	%_15 = call i8* @calloc(i32 1, i32 24)
	%_16 = bitcast i8* %_15 to i8***
	%_17 = getelementptr [2 x i8*], [2 x i8*]* @.Test_vtable, i32 0, i32 0
	store i8** %_17, i8*** %_16
	%_18 = getelementptr i8, i8* %this, i32 8
	%_19 = bitcast i8* %_18 to i8**
	store i8* %_15, i8** %_19
	%_21 = getelementptr i8, i8* %this, i32 8
	%_22 = bitcast i8* %_21 to i8**
	%_20 = load i8*, i8** %_22
	%_23 = bitcast i8* %_20 to i8***
	%_24 = load i8**, i8*** %_23
	%_25 = getelementptr i8*, i8** %_24, i32 1
	%_26 = load i8*, i8** %_25
	%_27 = bitcast i8* %_26 to i8* (i8*)*
	%_28 = call i8* %_27(i8* %_20)
	%_29 = bitcast i8* %_28 to i8***
	%_30 = load i8**, i8*** %_29
	%_31 = getelementptr i8*, i8** %_30, i32 1
	%_32 = load i8*, i8** %_31
	%_33 = bitcast i8* %_32 to i8* (i8*)*
	%_34 = call i8* %_33(i8* %_28)
	%_35 = getelementptr i8, i8* %this, i32 8
	%_36 = bitcast i8* %_35 to i8**
	store i8* %_34, i8** %_36
	ret i32 0
}

define i8* @Test.next(i8* %this) {
	%_37 = call i8* @calloc(i32 1, i32 24)
	%_38 = bitcast i8* %_37 to i8***
	%_39 = getelementptr [2 x i8*], [2 x i8*]* @.Test_vtable, i32 0, i32 0
	store i8** %_39, i8*** %_38
	%_40 = getelementptr i8, i8* %this, i32 8
	%_41 = bitcast i8* %_40 to i8**
	store i8* %_37, i8** %_41
	%_43 = getelementptr i8, i8* %this, i32 8
	%_44 = bitcast i8* %_43 to i8**
	%_42 = load i8*, i8** %_44
	ret i8* %_42
}


@.Example1_vtable = global [0 x i8*] []
@.Test1_vtable = global [1 x i8*] [i8* bitcast (i32 (i8*, i32, i1)* @Test1.Start to i8*)]


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
	%_0 = call i8* @calloc(i32 1, i32 12)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [1 x i8*], [1 x i8*]* @.Test1_vtable, i32 0, i32 0
	store i8** %_2, i8*** %_1
	%_3 = bitcast i8* %_0 to i8***
	%_4 = load i8**, i8*** %_3
	%_5 = getelementptr i8*, i8** %_4, i32 0
	%_6 = load i8*, i8** %_5
	%_7 = bitcast i8* %_6 to i32 (i8*, i32, i1)*
	%_8 = call i32 %_7(i8* %_0, i32 5, i1 1)
	call void (i32) @print_int(i32 %_8)
	ret i32 0
}

define i32 @Test1.Start(i8* %this, i32 %.b, i1 %.c) {
	%b = alloca i32
	store i32 %.b, i32* %b
	%c = alloca i1
	store i1 %.c, i1* %c
	%ntb = alloca i1
	%nti = alloca i32*
	%ourint = alloca i32
	%_9 = load i32, i32* %b
	%_10 = icmp slt i32 %_9, 0
	br i1 %_10, label %arr_alloc0, label %arr_alloc1
arr_alloc0:
	call void @throw_oob()
	br label %arr_alloc1
arr_alloc1:
	%_11 = add i32 %_9, 1
	%_12 = call i8* @calloc(i32 4, i32 %_11)
	%_13 = bitcast i8* %_12 to i32*
	store i32 %_9, i32* %_13
	store i32* %_13, i32** %nti
	%_14 = load i32*, i32** %nti
	%_15 = load i32, i32* %_14
	%_16 = icmp ule i32 %_15, 0
	br i1 %_16, label %oob0, label %oob1
oob0:
	call void @throw_oob()
	br label %oob1
oob1:
	%_17 = add i32 0, 1
	%_18 = getelementptr i32, i32* %_14, i32 %_17
	%_19 = load i32, i32* %_18
	store i32 %_19, i32* %ourint
	%_20 = load i32, i32* %ourint
	call void (i32) @print_int(i32 %_20)
	%_21 = load i32*, i32** %nti
	%_22 = load i32, i32* %_21
	%_23 = icmp ule i32 %_22, 0
	br i1 %_23, label %oob2, label %oob3
oob2:
	call void @throw_oob()
	br label %oob3
oob3:
	%_24 = add i32 0, 1
	%_25 = getelementptr i32, i32* %_21, i32 %_24
	%_26 = load i32, i32* %_25
	ret i32 %_26
}


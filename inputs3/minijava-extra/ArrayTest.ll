@.ArrayTest_vtable = global [0 x i8*] []
@.Test_vtable = global [1 x i8*] [i8* bitcast (i1 (i8*, i32)* @Test.start to i8*)]


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
	%n = alloca i1
	%_0 = call i8* @calloc(i32 1, i32 8)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [1 x i8*], [1 x i8*]* @.Test_vtable, i32 0, i32 0
	store i8** %_2, i8*** %_1
	%_3 = bitcast i8* %_0 to i8***
	%_4 = load i8**, i8*** %_3
	%_5 = getelementptr i8*, i8** %_4, i32 0
	%_6 = load i8*, i8** %_5
	%_7 = bitcast i8* %_6 to i1 (i8*, i32)*
	%_8 = call i1 %_7(i8* %_0, i32 10)
	store i1 %_8, i1* %n
	ret i32 0
}

define i1 @Test.start(i8* %this, i32 %.sz) {
	%sz = alloca i32
	store i32 %.sz, i32* %sz
	%b = alloca i32*
	%l = alloca i32
	%i = alloca i32
	%_9 = load i32, i32* %sz
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
	store i32* %_13, i32** %b
	%_14 = load i32*, i32** %b
	%_15 = load i32, i32* %_14
	store i32 %_15, i32* %l
	store i32 0, i32* %i
	br label %loop0
loop0:
	%_16 = load i32, i32* %i
	%_17 = load i32, i32* %l
	%_18 = icmp slt i32 %_16, %_17
	br i1 %_18, label %loop1, label %loop2
loop1:
	%_19 = load i32, i32* %i
	%_20 = load i32, i32* %i
	%_21 = load i32*, i32** %b
	%_22 = load i32, i32* %_21
	%_23 = icmp ule i32 %_22, %_19
	br i1 %_23, label %oob0, label %oob1
oob0:
	call void @throw_oob()
	br label %oob1
oob1:
	%_24 = add i32 %_19, 1
	%_25 = getelementptr i32, i32* %_21, i32 %_24
	store i32 %_20, i32* %_25
	%_26 = load i32*, i32** %b
	%_27 = load i32, i32* %i
	%_28 = load i32, i32* %_26
	%_29 = icmp ule i32 %_28, %_27
	br i1 %_29, label %oob2, label %oob3
oob2:
	call void @throw_oob()
	br label %oob3
oob3:
	%_30 = add i32 %_27, 1
	%_31 = getelementptr i32, i32* %_26, i32 %_30
	%_32 = load i32, i32* %_31
	call void (i32) @print_int(i32 %_32)
	%_33 = load i32, i32* %i
	%_34 = add i32 %_33, 1
	store i32 %_34, i32* %i
	br label %loop0
loop2:
	ret i1 1
}


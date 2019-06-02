@.OutOfBounds1_vtable = global [0 x i8*] []
@.A_vtable = global [1 x i8*] [i8* bitcast (i32 (i8*)* @A.run to i8*)]


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
	%_2 = getelementptr [1 x i8*], [1 x i8*]* @.A_vtable, i32 0, i32 0
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

define i32 @A.run(i8* %this) {
	%a = alloca i32*
	%x = alloca i32
	%y = alloca i32
	%_9 = icmp slt i32 20, 0
	br i1 %_9, label %arr_alloc0, label %arr_alloc1
arr_alloc0:
	call void @throw_oob()
	br label %arr_alloc1
arr_alloc1:
	%_10 = add i32 20, 1
	%_11 = call i8* @calloc(i32 4, i32 %_10)
	%_12 = bitcast i8* %_11 to i32*
	store i32 20, i32* %_12
	store i32* %_12, i32** %a
	%_13 = sub i32 1, 3
	store i32 %_13, i32* %y
	%_14 = load i32*, i32** %a
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
	call void (i32) @print_int(i32 %_19)
	%_20 = load i32*, i32** %a
	%_21 = load i32, i32* %_20
	%_22 = icmp ule i32 %_21, 19
	br i1 %_22, label %oob2, label %oob3
oob2:
	call void @throw_oob()
	br label %oob3
oob3:
	%_23 = add i32 19, 1
	%_24 = getelementptr i32, i32* %_20, i32 %_23
	%_25 = load i32, i32* %_24
	call void (i32) @print_int(i32 %_25)
	store i32 12345, i32* %x
	%_26 = load i32*, i32** %a
	%_27 = load i32, i32* %x
	%_28 = load i32, i32* %_26
	%_29 = icmp ule i32 %_28, %_27
	br i1 %_29, label %oob4, label %oob5
oob4:
	call void @throw_oob()
	br label %oob5
oob5:
	%_30 = add i32 %_27, 1
	%_31 = getelementptr i32, i32* %_26, i32 %_30
	%_32 = load i32, i32* %_31
	ret i32 %_32
}


@.test82_vtable = global [0 x i8*] []
@.Test_vtable = global [2 x i8*] [i8* bitcast (i32 (i8*)* @Test.start to i8*), i8* bitcast (i1 (i8*)* @Test.next to i8*)]


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
	%_0 = call i8* @calloc(i32 1, i32 17)
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
	%_9 = call i8* @calloc(i32 1, i32 17)
	%_10 = bitcast i8* %_9 to i8***
	%_11 = getelementptr [2 x i8*], [2 x i8*]* @.Test_vtable, i32 0, i32 0
	store i8** %_11, i8*** %_10
	%_12 = getelementptr i8, i8* %this, i32 8
	%_13 = bitcast i8* %_12 to i8**
	store i8* %_9, i8** %_13
	%_15 = getelementptr i8, i8* %this, i32 8
	%_16 = bitcast i8* %_15 to i8**
	%_14 = load i8*, i8** %_16
	%_17 = bitcast i8* %_14 to i8***
	%_18 = load i8**, i8*** %_17
	%_19 = getelementptr i8*, i8** %_18, i32 1
	%_20 = load i8*, i8** %_19
	%_21 = bitcast i8* %_20 to i1 (i8*)*
	%_22 = call i1 %_21(i8* %_14)
	%_23 = getelementptr i8, i8* %this, i32 16
	%_24 = bitcast i8* %_23 to i1*
	store i1 %_22, i1* %_24
	ret i32 0
}

define i1 @Test.next(i8* %this) {
	%b2 = alloca i1
	%_25 = icmp slt i32 7, 8
	br label %andclause0
andclause0:
	br i1 1, label %andclause1, label %andclause2
andclause1:
	br label %andclause2
andclause2:
	%_26 = phi i1 [0, %andclause0], [%_25, %andclause1]
	%_28 = getelementptr i8, i8* %this, i32 16
	%_29 = bitcast i8* %_28 to i1*
	%_27 = load i1, i1* %_29
	%_30 = xor i1 1, %_27
	br label %andclause3
andclause3:
	br i1 %_26, label %andclause4, label %andclause5
andclause4:
	br label %andclause5
andclause5:
	%_31 = phi i1 [0, %andclause3], [%_30, %andclause4]
	store i1 %_31, i1* %b2
	%_32 = load i1, i1* %b2
	ret i1 %_32
}


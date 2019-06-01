@.Test_vtable = global [0 x i8*] []
@.Mine_vtable = global [2 x i8*] [i8* bitcast (i32 (i8*)* @Mine.myPrintInt to i8*), i8* bitcast (i1 (i8*)* @Mine.myPrintBool to i8*)]


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
	%_2 = getelementptr [2 x i8*], [2 x i8*]* @.Mine_vtable, i32 0, i32 0
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

define i32 @Mine.myPrintInt(i8* %this) {
	%x = alloca i32
	store i32 42, i32* %x
	%_9 = load i32, i32* %x
	ret i32 %_9
}

define i1 @Mine.myPrintBool(i8* %this) {
	%b = alloca i1
	store i1 1, i1* %b
	br label %andclause0
andclause0:
	%_10 = load i1, i1* %b
	br i1 %_10, label %andclause1, label %andclause2
andclause1:
	br label %andclause2
andclause2:
	%_11 = phi i1 [0, %andclause0], [0, %andclause1]
	ret i1 %_11
}


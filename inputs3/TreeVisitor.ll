@.TreeVisitor_vtable = global [0 x i8*] []
@.TV_vtable = global [1 x i8*] [i8* bitcast (i32 (i8*)* @TV.Start to i8*)]
@.Tree_vtable = global [21 x i8*] [i8* bitcast (i1 (i8*, i32)* @Tree.Init to i8*), i8* bitcast (i1 (i8*, i8*)* @Tree.SetRight to i8*), i8* bitcast (i1 (i8*, i8*)* @Tree.SetLeft to i8*), i8* bitcast (i8* (i8*)* @Tree.GetRight to i8*), i8* bitcast (i8* (i8*)* @Tree.GetLeft to i8*), i8* bitcast (i32 (i8*)* @Tree.GetKey to i8*), i8* bitcast (i1 (i8*, i32)* @Tree.SetKey to i8*), i8* bitcast (i1 (i8*)* @Tree.GetHas_Right to i8*), i8* bitcast (i1 (i8*)* @Tree.GetHas_Left to i8*), i8* bitcast (i1 (i8*, i1)* @Tree.SetHas_Left to i8*), i8* bitcast (i1 (i8*, i1)* @Tree.SetHas_Right to i8*), i8* bitcast (i1 (i8*, i32, i32)* @Tree.Compare to i8*), i8* bitcast (i1 (i8*, i32)* @Tree.Insert to i8*), i8* bitcast (i1 (i8*, i32)* @Tree.Delete to i8*), i8* bitcast (i1 (i8*, i8*, i8*)* @Tree.Remove to i8*), i8* bitcast (i1 (i8*, i8*, i8*)* @Tree.RemoveRight to i8*), i8* bitcast (i1 (i8*, i8*, i8*)* @Tree.RemoveLeft to i8*), i8* bitcast (i32 (i8*, i32)* @Tree.Search to i8*), i8* bitcast (i1 (i8*)* @Tree.Print to i8*), i8* bitcast (i1 (i8*, i8*)* @Tree.RecPrint to i8*), i8* bitcast (i32 (i8*, i8*)* @Tree.accept to i8*)]
@.Visitor_vtable = global [1 x i8*] [i8* bitcast (i32 (i8*, i8*)* @Visitor.visit to i8*)]
@.MyVisitor_vtable = global [1 x i8*] [i8* bitcast (i32 (i8*, i8*)* @MyVisitor.visit to i8*)]


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

	ret i32 0
}
define i32 @TV.Start(i8* %this) {
	ret i32nulldefine i1 @Tree.Init(i8* %this, i32 %.v_key) {
	ret i1nulldefine i1 @Tree.SetRight(i8* %this, i8* %.rn) {
	ret i1nulldefine i1 @Tree.SetLeft(i8* %this, i8* %.ln) {
	ret i1nulldefine i8* @Tree.GetRight(i8* %this) {
	ret i8*nulldefine i8* @Tree.GetLeft(i8* %this) {
	ret i8*nulldefine i32 @Tree.GetKey(i8* %this) {
	ret i32nulldefine i1 @Tree.SetKey(i8* %this, i32 %.v_key) {
	ret i1nulldefine i1 @Tree.GetHas_Right(i8* %this) {
	ret i1nulldefine i1 @Tree.GetHas_Left(i8* %this) {
	ret i1nulldefine i1 @Tree.SetHas_Left(i8* %this, i1 %.val) {
	ret i1nulldefine i1 @Tree.SetHas_Right(i8* %this, i1 %.val) {
	ret i1nulldefine i1 @Tree.Compare(i8* %this, i32 %.num1, i32 %.num2) {
	ret i1nulldefine i1 @Tree.Insert(i8* %this, i32 %.v_key) {
	ret i1nulldefine i1 @Tree.Delete(i8* %this, i32 %.v_key) {
	ret i1nulldefine i1 @Tree.Remove(i8* %this, i8* %.p_node, i8* %.c_node) {
	ret i1nulldefine i1 @Tree.RemoveRight(i8* %this, i8* %.p_node, i8* %.c_node) {
	ret i1nulldefine i1 @Tree.RemoveLeft(i8* %this, i8* %.p_node, i8* %.c_node) {
	ret i1nulldefine i32 @Tree.Search(i8* %this, i32 %.v_key) {
	ret i32nulldefine i1 @Tree.Print(i8* %this) {
	ret i1nulldefine i1 @Tree.RecPrint(i8* %this, i8* %.node) {
	ret i1nulldefine i32 @Tree.accept(i8* %this, i8* %.v) {
	ret i32nulldefine i32 @Visitor.visit(i8* %this, i8* %.n) {
	ret i32nulldefine i32 @MyVisitor.visit(i8* %this, i8* %.n) {
	ret i32null
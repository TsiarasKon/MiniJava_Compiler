import syntaxtree.*;
import visitor.GJDepthFirst;

import java.io.*;
import java.util.LinkedHashMap;
import java.util.Map;

public class LLVMGeneratorVisitor extends GJDepthFirst<String, SymbolTable>{

    private File llFileptr;
    private SymbolTable symbolTable;
    private VTables vTables;

    private int currLabelNum;
    private int currTempRegisterNum;

    private String currentClassName;
    private String currentMethodName;

    LLVMGeneratorVisitor(String llFileName, SymbolTable _symbolTable, VTables _vTables) {
        llFileptr = new File(llFileName);
        try {
            if (!llFileptr.createNewFile()) {
                Writer llFileWriter = new FileWriter(llFileName, false);
                llFileWriter.close();
            }
        } catch (IOException ex) {
            System.err.println(ex.getMessage());
        }
        symbolTable = _symbolTable;
        vTables = _vTables;
        currLabelNum = currTempRegisterNum = 0;
    }

    String getLLVMType(String actualType) {
        switch (actualType) {
            case "int":
                return "i32";
            case "boolean":
                return "i1";
            case "int[]":
                return "i32*";
            default:
                return "i8*";
        }
    }

    void emit(String buffer) {
        try {
            FileWriter fw = new FileWriter(llFileptr, true);
            BufferedWriter bw = new BufferedWriter(fw);
            PrintWriter pw = new PrintWriter(bw);
            pw.print(buffer);
            pw.close();
        } catch (IOException ex) {
            System.err.println(ex.getMessage());
        }
    }

    void emitLLVMHelperMethods() {
        String buffer = "\n" +
            "declare i8* @calloc(i32, i32)\n" +
            "declare i32 @printf(i8*, ...)\n" +
            "declare void @exit(i32)\n" +
            "\n" +
            "@_cint = constant [4 x i8] c\"%d\\0a\\00\"\n" +
            "@_cOOB = constant [15 x i8] c\"Out of bounds\\0a\\00\"\n" +
            "define void @print_int(i32 %i) {\n" +
            "\t%_str = bitcast [4 x i8]* @_cint to i8*\n" +
            "\tcall i32 (i8*, ...) @printf(i8* %_str, i32 %i)\n" +
            "\tret void\n" +
            "}\n" +
            "\n" +
            "define void @throw_oob() {\n" +
            "\t%_str = bitcast [15 x i8]* @_cOOB to i8*\n" +
            "\tcall i32 (i8*, ...) @printf(i8* %_str)\n" +
            "\tcall void @exit(i32 1)\n" +
            "\tret void\n" +
            "}\n";
        emit(buffer);
    }

    void emitLLVMVTables() {
        for (Map.Entry<String, VTables.ClassVTable> classEntry : vTables.classesVTables.entrySet()) {
            String className = classEntry.getKey();
            VTables.ClassVTable classVTable = classEntry.getValue();
            if (classVTable.isMainClass) {
                emit("@." + className + "_vtable = global [0 x i8*] []\n");
                continue;
            }
            emit("@." + className + "_vtable = global [");
            int functionsNum = 0;
            StringBuilder currBuilder = new StringBuilder();
            for (Map.Entry<String, Integer> methodEntry : classVTable.methodsTable.entrySet()) {
                String methodName = methodEntry.getKey();
                if (functionsNum > 0) {
                    currBuilder.append(", ");
                }
                functionsNum++;
                String methodReturnType = symbolTable.getClassMethodReturnType(className, methodName);
                currBuilder.append("i8* bitcast (");
                currBuilder.append(getLLVMType(methodReturnType));
                currBuilder.append(" (i8*");
                LinkedHashMap<String, String> methodParameters = symbolTable.getClassMethodParameters(className, methodName);
                for (Map.Entry<String, String> parameterEntry : methodParameters.entrySet()) {
                    currBuilder.append(", ");
                    currBuilder.append(getLLVMType(parameterEntry.getValue()));
                }
                currBuilder.append(")* @");
                currBuilder.append(className);
                currBuilder.append(".");
                currBuilder.append(methodName);
                currBuilder.append(" to i8*)");
            }
            emit(functionsNum + " x i8*] [" + currBuilder + "]\n");
        }
        emit("\n");
    }

    String getLabel() {
        return "label" + currLabelNum++;
    }

    String getTempReg() {
        return "%_" + currTempRegisterNum++;
    }


    /**
     * f0 -> MainClass()
     * f1 -> ( TypeDeclaration() )*
     * f2 -> <EOF>
     */
    public String visit(Goal n, SymbolTable symbolTable) throws Exception {
        emitLLVMVTables();
        emitLLVMHelperMethods();
        n.f0.accept(this, symbolTable);
        n.f1.accept(this, symbolTable);
        return null;
    }

    /**
     * f0 -> "class"
     * f1 -> Identifier()
     * f2 -> "{"
     * f3 -> "public"
     * f4 -> "static"
     * f5 -> "void"
     * f6 -> "main"
     * f7 -> "("
     * f8 -> "String"
     * f9 -> "["
     * f10 -> "]"
     * f11 -> Identifier()
     * f12 -> ")"
     * f13 -> "{"
     * f14 -> ( VarDeclaration() )*
     * f15 -> ( Statement() )*
     * f16 -> "}"
     * f17 -> "}"
     */
    public String visit(MainClass n, SymbolTable symbolTable) throws Exception {
        emit("\ndefine i32 @main() {\n");
        currentClassName = n.f1.accept(this, symbolTable);
        currentMethodName = "main";
        n.f14.accept(this, symbolTable);
        n.f15.accept(this, symbolTable);
        emit("\tret i32 0\n}\n");
        return null;
    }
//
//    /**
//     * f0 -> ClassDeclaration()
//     *       | ClassExtendsDeclaration()
//     */
//    public String visit(TypeDeclaration n, SymbolTable symbolTable) throws Exception {
//        return n.f0.accept(this, argu);
//    }

    /**
     * f0 -> "class"
     * f1 -> Identifier()
     * f2 -> "{"
     * f3 -> ( VarDeclaration() )*
     * f4 -> ( MethodDeclaration() )*
     * f5 -> "}"
     */
    public String visit(ClassDeclaration n, SymbolTable symbolTable) throws Exception {
        currentClassName = n.f1.accept(this, symbolTable);
        n.f4.accept(this, symbolTable);
        return null;
    }

    /**
     * f0 -> "class"
     * f1 -> Identifier()
     * f2 -> "extends"
     * f3 -> Identifier()
     * f4 -> "{"
     * f5 -> ( VarDeclaration() )*
     * f6 -> ( MethodDeclaration() )*
     * f7 -> "}"
     */
    public String visit(ClassExtendsDeclaration n, SymbolTable symbolTable) throws Exception {
        currentClassName = n.f1.accept(this, symbolTable);
        n.f6.accept(this, symbolTable);
        return null;
    }

//    /**
//     * f0 -> Type()
//     * f1 -> Identifier()
//     * f2 -> ";"
//     */
//    public String visit(VarDeclaration n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        n.f2.accept(this, argu);
//        return _ret;
//    }

    /**
     * f0 -> "public"
     * f1 -> Type()
     * f2 -> Identifier()
     * f3 -> "("
     * f4 -> ( FormalParameterList() )?
     * f5 -> ")"
     * f6 -> "{"
     * f7 -> ( VarDeclaration() )*
     * f8 -> ( Statement() )*
     * f9 -> "return"
     * f10 -> Expression()
     * f11 -> ";"
     * f12 -> "}"
     */
    public String visit(MethodDeclaration n, SymbolTable symbolTable) throws Exception {
        currentMethodName = n.f2.accept(this, symbolTable);
        String currBuffer = "define " + getLLVMType(n.f1.accept(this, symbolTable)) +
                " @" + currentClassName + "." + currentMethodName + "(i8* %this";
        LinkedHashMap<String, String> methodParameters = symbolTable.getClassMethodParameters(currentClassName, currentMethodName);
        for (Map.Entry<String, String> parameterEntry : methodParameters.entrySet()) {
            currBuffer += ", " + getLLVMType(parameterEntry.getValue()) + " %." + parameterEntry.getKey();
        }
        emit(currBuffer + ") {\n");
        n.f7.accept(this, symbolTable);
        String retRegister = n.f8.accept(this, symbolTable);
        emit("\tret " + getLLVMType(symbolTable.getClassMethodReturnType(currentClassName, currentMethodName)) + ' ' + retRegister + "\n}\n");
        return null;
    }

//    /**
//     * f0 -> FormalParameter()
//     * f1 -> FormalParameterTail()
//     */
//    public String visit(FormalParameterList n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> Type()
//     * f1 -> Identifier()
//     */
//    public String visit(FormalParameter n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> ( FormalParameterTerm() )*
//     */
//    public String visit(FormalParameterTail n, SymbolTable symbolTable) throws Exception {
//        return n.f0.accept(this, argu);
//    }
//
//    /**
//     * f0 -> ","
//     * f1 -> FormalParameter()
//     */
//    public String visit(FormalParameterTerm n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> ArrayType()
//     *       | BooleanType()
//     *       | IntegerType()
//     *       | Identifier()
//     */
//    public String visit(Type n, SymbolTable symbolTable) throws Exception {
//        return n.f0.accept(this, argu);
//    }

    /**
     * f0 -> "int"
     * f1 -> "["
     * f2 -> "]"
     */
    public String visit(ArrayType n, SymbolTable symbolTable) throws Exception {
        return "int[]";
    }

    /**
     * f0 -> "boolean"
     */
    public String visit(BooleanType n, SymbolTable symbolTable) throws Exception {
        return "boolean";
    }

    /**
     * f0 -> "int"
     */
    public String visit(IntegerType n, SymbolTable symbolTable) throws Exception {
        return "int";
    }

//    /**
//     * f0 -> Block()
//     *       | AssignmentStatement()
//     *       | ArrayAssignmentStatement()
//     *       | IfStatement()
//     *       | WhileStatement()
//     *       | PrintStatement()
//     */
//    public String visit(Statement n, SymbolTable symbolTable) throws Exception {
//        return n.f0.accept(this, argu);
//    }
//
//    /**
//     * f0 -> "{"
//     * f1 -> ( Statement() )*
//     * f2 -> "}"
//     */
//    public String visit(Block n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        n.f2.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> Identifier()
//     * f1 -> "="
//     * f2 -> Expression()
//     * f3 -> ";"
//     */
//    public String visit(AssignmentStatement n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        n.f2.accept(this, argu);
//        n.f3.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> Identifier()
//     * f1 -> "["
//     * f2 -> Expression()
//     * f3 -> "]"
//     * f4 -> "="
//     * f5 -> Expression()
//     * f6 -> ";"
//     */
//    public String visit(ArrayAssignmentStatement n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        n.f2.accept(this, argu);
//        n.f3.accept(this, argu);
//        n.f4.accept(this, argu);
//        n.f5.accept(this, argu);
//        n.f6.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> "if"
//     * f1 -> "("
//     * f2 -> Expression()
//     * f3 -> ")"
//     * f4 -> Statement()
//     * f5 -> "else"
//     * f6 -> Statement()
//     */
//    public String visit(IfStatement n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        n.f2.accept(this, argu);
//        n.f3.accept(this, argu);
//        n.f4.accept(this, argu);
//        n.f5.accept(this, argu);
//        n.f6.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> "while"
//     * f1 -> "("
//     * f2 -> Expression()
//     * f3 -> ")"
//     * f4 -> Statement()
//     */
//    public String visit(WhileStatement n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        n.f2.accept(this, argu);
//        n.f3.accept(this, argu);
//        n.f4.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> "System.out.println"
//     * f1 -> "("
//     * f2 -> Expression()
//     * f3 -> ")"
//     * f4 -> ";"
//     */
//    public String visit(PrintStatement n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        n.f2.accept(this, argu);
//        n.f3.accept(this, argu);
//        n.f4.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> AndExpression()
//     *       | CompareExpression()
//     *       | PlusExpression()
//     *       | MinusExpression()
//     *       | TimesExpression()
//     *       | ArrayLookup()
//     *       | ArrayLength()
//     *       | MessageSend()
//     *       | Clause()
//     */
//    public String visit(Expression n, SymbolTable symbolTable) throws Exception {
//        return n.f0.accept(this, argu);
//    }
//
//    /**
//     * f0 -> Clause()
//     * f1 -> "&&"
//     * f2 -> Clause()
//     */
//    public String visit(AndExpression n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        n.f2.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> PrimaryExpression()
//     * f1 -> "<"
//     * f2 -> PrimaryExpression()
//     */
//    public String visit(CompareExpression n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        n.f2.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> PrimaryExpression()
//     * f1 -> "+"
//     * f2 -> PrimaryExpression()
//     */
//    public String visit(PlusExpression n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        n.f2.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> PrimaryExpression()
//     * f1 -> "-"
//     * f2 -> PrimaryExpression()
//     */
//    public String visit(MinusExpression n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        n.f2.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> PrimaryExpression()
//     * f1 -> "*"
//     * f2 -> PrimaryExpression()
//     */
//    public String visit(TimesExpression n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        n.f2.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> PrimaryExpression()
//     * f1 -> "["
//     * f2 -> PrimaryExpression()
//     * f3 -> "]"
//     */
//    public String visit(ArrayLookup n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        n.f2.accept(this, argu);
//        n.f3.accept(this, argu);
//        return _ret;
//    }

//    /**
//     * f0 -> PrimaryExpression()
//     * f1 -> "."
//     * f2 -> "length"
//     */
//    public String visit(ArrayLength n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        n.f2.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> PrimaryExpression()
//     * f1 -> "."
//     * f2 -> Identifier()
//     * f3 -> "("
//     * f4 -> ( ExpressionList() )?
//     * f5 -> ")"
//     */
//    public String visit(MessageSend n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        n.f2.accept(this, argu);
//        n.f3.accept(this, argu);
//        n.f4.accept(this, argu);
//        n.f5.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> Expression()
//     * f1 -> ExpressionTail()
//     */
//    public String visit(ExpressionList n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> ( ExpressionTerm() )*
//     */
//    public String visit(ExpressionTail n, SymbolTable symbolTable) throws Exception {
//        return n.f0.accept(this, argu);
//    }
//
//    /**
//     * f0 -> ","
//     * f1 -> Expression()
//     */
//    public String visit(ExpressionTerm n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> NotExpression()
//     *       | PrimaryExpression()
//     */
//    public String visit(Clause n, SymbolTable symbolTable) throws Exception {
//        return n.f0.accept(this, argu);
//    }
//
//    /**
//     * f0 -> IntegerLiteral()
//     *       | TrueLiteral()
//     *       | FalseLiteral()
//     *       | Identifier()
//     *       | ThisExpression()
//     *       | ArrayAllocationExpression()
//     *       | AllocationExpression()
//     *       | BracketExpression()
//     */
//    public String visit(PrimaryExpression n, SymbolTable symbolTable) throws Exception {
//        return n.f0.accept(this, argu);
//    }

    /**
     * f0 -> <INTEGER_LITERAL>
     */
    public String visit(IntegerLiteral n, SymbolTable symbolTable) throws Exception {
        return n.f0.toString();
    }

    /**
     * f0 -> "true"
     */
    public String visit(TrueLiteral n, SymbolTable symbolTable) throws Exception {
        return "true";
    }

    /**
     * f0 -> "false"
     */
    public String visit(FalseLiteral n, SymbolTable symbolTable) throws Exception {
        return "false";
    }

    /**
     * f0 -> <IDENTIFIER>
     */
    public String visit(Identifier n, SymbolTable symbolTable) throws Exception {
        return n.f0.toString();
    }

    /**
     * f0 -> "this"
     */
    public String visit(ThisExpression n, SymbolTable symbolTable) throws Exception {
        return "%this";
    }

//    /**
//     * f0 -> "new"
//     * f1 -> "int"
//     * f2 -> "["
//     * f3 -> Expression()
//     * f4 -> "]"
//     */
//    public String visit(ArrayAllocationExpression n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        n.f2.accept(this, argu);
//        n.f3.accept(this, argu);
//        n.f4.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> "new"
//     * f1 -> Identifier()
//     * f2 -> "("
//     * f3 -> ")"
//     */
//    public String visit(AllocationExpression n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        n.f2.accept(this, argu);
//        n.f3.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> "!"
//     * f1 -> Clause()
//     */
//    public String visit(NotExpression n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        return _ret;
//    }
//
//    /**
//     * f0 -> "("
//     * f1 -> Expression()
//     * f2 -> ")"
//     */
//    public String visit(BracketExpression n, SymbolTable symbolTable) throws Exception {
//        String _ret=null;
//        n.f0.accept(this, argu);
//        n.f1.accept(this, argu);
//        n.f2.accept(this, argu);
//        return _ret;
//    }

}

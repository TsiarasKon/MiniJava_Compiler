import syntaxtree.*;
import visitor.GJNoArguDepthFirst;

import java.io.*;
import java.util.*;

public class LLVMGeneratorVisitor extends GJNoArguDepthFirst<String> {

    private File llFileptr;
    private SymbolTable symbolTable;
    private VTables vTables;

    private int currLabelNum_if;
    private int currLabelNum_loop;
    private int currLabelNum_and;
    private int currLabelNum_arr;
    private int currLabelNum_oob;
    private int currTempRegisterNum;

    private String currExprType;
    private List<String> currMethodParameterRegs;
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
        currLabelNum_if = currLabelNum_loop = currLabelNum_and = currLabelNum_arr = currLabelNum_oob = currTempRegisterNum = 0;
        currExprType = null;
    }

    String getLLVMType(String actualType) {
        if (actualType == null) {       // Should never get here
            System.err.println("Tried to get LLVM type of 'null'. Exiting ...");
            System.exit(1);
        }
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

    private int getClassSize(String className) {
        return symbolTable.getClassFieldOffset(className) + 8;
    }

    private int getClassMethodsNum(String className) {
        return symbolTable.getClassMethodOffset(className) / 8;
    }

    private List<String> getClassMethodParameterLLVMTypes(String className, String methodName) {
        List<String> methodParameterLLVMTypes = new ArrayList<>();
        LinkedHashMap<String, String> methodParameters = symbolTable.getClassMethodParameters(className, methodName);
        for (Map.Entry<String, String> parameterEntry : methodParameters.entrySet()) {
            methodParameterLLVMTypes.add(getLLVMType(parameterEntry.getValue()));
        }
        return methodParameterLLVMTypes;
    }

    private void emit(String buffer) {
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

    private void emitLLVMHelperMethods() {
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

    private void emitLLVMVTables() {
        for (Map.Entry<String, VTables.ClassVTable> classEntry : vTables.classesVTables.entrySet()) {
            String className = classEntry.getKey();
            VTables.ClassVTable classVTable = classEntry.getValue();
            if (classVTable.isMainClass) {
                emit("@." + className + "_vtable = global [0 x i8*] []\n");
                continue;
            }
            emit("@." + className + "_vtable = global [");
            int functionsNum = 0;
            Iterator currIt = classVTable.methodsFromTable.entrySet().iterator();
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
                currBuilder.append(((Map.Entry) currIt.next()).getValue());
                currBuilder.append(".");
                currBuilder.append(methodName);
                currBuilder.append(" to i8*)");
            }
            emit(functionsNum + " x i8*] [" + currBuilder + "]\n");
        }
        emit("\n");
    }

    private String getLabel(String labelType) {
        switch (labelType) {
            case "if":
                return "if" + currLabelNum_if++;
            case "loop":
                return "loop" + currLabelNum_loop++;
            case "and":
                return "andclause" + currLabelNum_and++;
            case "arr":
                return "arr_alloc" + currLabelNum_arr++;
            default:
                return "oob" + currLabelNum_oob++;
        }
    }

    private String getTempReg() {
        return "%_" + currTempRegisterNum++;
    }

    private boolean isExprLiteral(String expr) {
        try {
            Integer.parseInt(expr);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    private String loadNonLiteral(String expr) {
        if (isExprLiteral(expr) || expr == null) {
            return expr;
        }
        String exprType = symbolTable.getClassMethodVarType(currentClassName, currentMethodName, expr.substring(1));
        if (exprType == null) {
            return expr;
        }
        String exprLLVMType = getLLVMType(exprType);
        String exprReg = getTempReg();
        if (symbolTable.getClassFieldType(currentClassName, expr.substring(1)) != null) {     // loading a class field
            String elemPtrReg = getTempReg();
            String bitcastReg = getTempReg();
            emit('\t' + elemPtrReg + " = getelementptr i8, i8* %this, i32 " + vTables.getClassFieldOffset(currentClassName, expr.substring(1)) + '\n' +
                    '\t' + bitcastReg + " = bitcast i8* " + elemPtrReg + " to " + exprLLVMType + "*\n" +
                    '\t' + exprReg + " = load " + exprLLVMType + ", " + exprLLVMType + "* " + bitcastReg + '\n');
        } else {
            emit('\t' + exprReg + " = load " + exprLLVMType + ", " + exprLLVMType + "* " + expr + '\n');
        }
        return exprReg;
    }


    /**
     * f0 -> MainClass()
     * f1 -> ( TypeDeclaration() )*
     * f2 -> <EOF>
     */
    public String visit(Goal n) throws Exception {
        emitLLVMVTables();
        emitLLVMHelperMethods();
        n.f0.accept(this);
        n.f1.accept(this);
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
    public String visit(MainClass n) throws Exception {
        emit("\ndefine i32 @main() {\n");
        currentClassName = n.f1.accept(this);
        currentMethodName = "main";
        n.f14.accept(this);
        n.f15.accept(this);
        emit("\tret i32 0\n}\n\n");
        return null;
    }

    /**
     * f0 -> "class"
     * f1 -> Identifier()
     * f2 -> "{"
     * f3 -> ( VarDeclaration() )*
     * f4 -> ( MethodDeclaration() )*
     * f5 -> "}"
     */
    public String visit(ClassDeclaration n) throws Exception {
        currentClassName = n.f1.accept(this);
        n.f4.accept(this);
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
    public String visit(ClassExtendsDeclaration n) throws Exception {
        currentClassName = n.f1.accept(this);
        n.f6.accept(this);
        return null;
    }

    /**
     * f0 -> Type()
     * f1 -> Identifier()
     * f2 -> ";"
     */
    public String visit(VarDeclaration n) throws Exception {
        emit("\t%" + n.f1.accept(this) + " = alloca " + getLLVMType(n.f0.accept(this)) + '\n');
        return null;
    }

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
    public String visit(MethodDeclaration n) throws Exception {
        currentMethodName = n.f2.accept(this);
        String currBuffer = "define " + getLLVMType(n.f1.accept(this)) +
                " @" + currentClassName + "." + currentMethodName + "(i8* %this";
        LinkedHashMap<String, String> methodParameters = symbolTable.getClassMethodParameters(currentClassName, currentMethodName);
        String paramAllocaBuffer = "";
        for (Map.Entry<String, String> parameterEntry : methodParameters.entrySet()) {
            String llvmParamType = getLLVMType(parameterEntry.getValue());
            String currParamName = parameterEntry.getKey();
            currBuffer += ", " + llvmParamType + " %." + currParamName;
            paramAllocaBuffer += "\t%" + currParamName + " = alloca " + llvmParamType + '\n' +
                    "\tstore " + llvmParamType + " %." + currParamName + ", " + llvmParamType + "* %" + currParamName + '\n';
        }
        emit(currBuffer + ") {\n");
        emit(paramAllocaBuffer);
        n.f7.accept(this);
        n.f8.accept(this);
        String retRegister = loadNonLiteral(n.f10.accept(this));
        emit("\tret " + getLLVMType(symbolTable.getClassMethodReturnType(currentClassName, currentMethodName)) + ' ' + retRegister + "\n}\n\n");
        return null;
    }

    /**
     * f0 -> "int"
     * f1 -> "["
     * f2 -> "]"
     */
    public String visit(ArrayType n) throws Exception {
        return "int[]";
    }

    /**
     * f0 -> "boolean"
     */
    public String visit(BooleanType n) throws Exception {
        return "boolean";
    }

    /**
     * f0 -> "int"
     */
    public String visit(IntegerType n) throws Exception {
        return "int";
    }

    /**
     * f0 -> Identifier()
     * f1 -> "="
     * f2 -> Expression()
     * f3 -> ";"
     */
    public String visit(AssignmentStatement n) throws Exception {
        String idName = n.f0.accept(this);
        String idLLVMType = getLLVMType(currExprType);
        String expr = loadNonLiteral(n.f2.accept(this));
        String exprLLVMType = getLLVMType(currExprType);
        if (symbolTable.getClassFieldType(currentClassName, idName) != null) {     // assigning to a class field
            String elemPtrReg = getTempReg();
            String bitcastReg = getTempReg();
            emit('\t' + elemPtrReg + " = getelementptr i8, i8* %this, i32 " + vTables.getClassFieldOffset(currentClassName, idName) + '\n' +
                    '\t' + bitcastReg + " = bitcast i8* " + elemPtrReg + " to " + idLLVMType + "*\n" +
                    "\tstore " + exprLLVMType + ' ' + expr + ", " + exprLLVMType + "* " + bitcastReg + '\n');
        } else {
            emit("\tstore " + idLLVMType + ' ' + expr + ", " + exprLLVMType + "* %" + idName + '\n');
        }
        return expr;
    }

    /**
     * f0 -> Identifier()
     * f1 -> "["
     * f2 -> Expression()
     * f3 -> "]"
     * f4 -> "="
     * f5 -> Expression()
     * f6 -> ";"
     */
    public String visit(ArrayAssignmentStatement n) throws Exception {
        String idName = n.f0.accept(this);
        String arrIndex = loadNonLiteral(n.f2.accept(this));
        String rvalExpr = loadNonLiteral(n.f5.accept(this));
        String arrReg = getTempReg();
        if (symbolTable.getClassFieldType(currentClassName, idName) != null) {     // assigning to a class field
            String elemPtrReg = getTempReg();
            String bitcastReg = getTempReg();
            emit('\t' + elemPtrReg + " = getelementptr i8, i8* %this, i32 " + vTables.getClassFieldOffset(currentClassName, idName) + '\n' +
                    '\t' + bitcastReg + " = bitcast i8* " + elemPtrReg + " to i32**\n" +
                    '\t' + arrReg + " = load i32*, i32** " + bitcastReg + '\n');
        } else {
            emit('\t' + arrReg + " = load i32*, i32** %" + idName + '\n');
        }
        String arrSizeReg = getTempReg();
        // emit check for arrIndex > arrSize (unsigned comparison also catches arrIndex < 0)
        String arrIndexCmpReg = getTempReg();
        String arrInvalidLabel = getLabel("oob");
        String arrValidLabel = getLabel("oob");
        String arrIncreasedIndexReg = getTempReg();
        String arrValueRegPtr = getTempReg();
        emit('\t' + arrSizeReg + " = load i32, i32* " + arrReg + '\n' +
                '\t' + arrIndexCmpReg + " = icmp ule i32 " + arrSizeReg + ", " + arrIndex + '\n' +
                "\tbr i1 " + arrIndexCmpReg + ", label %" + arrInvalidLabel + ", label %" + arrValidLabel + '\n' +
                arrInvalidLabel + ":\n" +
                "\tcall void @throw_oob()\n" +
                "\tbr label %" + arrValidLabel + '\n' +
                arrValidLabel + ":\n" +
                '\t' + arrIncreasedIndexReg + " = add i32 " + arrIndex + ", 1\n" +
                '\t' + arrValueRegPtr + " = getelementptr i32, i32* " + arrReg + ", i32 " + arrIncreasedIndexReg + '\n' +
                "\tstore i32 " + rvalExpr + ", i32* " + arrValueRegPtr + '\n');
        currExprType = "int";
        return rvalExpr;
    }

    /**
     * f0 -> "if"
     * f1 -> "("
     * f2 -> Expression()
     * f3 -> ")"
     * f4 -> Statement()
     * f5 -> "else"
     * f6 -> Statement()
     */
    public String visit(IfStatement n) throws Exception {
        String exprReg = loadNonLiteral(n.f2.accept(this));
        String ifLabel = getLabel("if");
        String elseLabel = getLabel("if");
        String endIfLabel = getLabel("if");
        emit("\tbr i1 " + exprReg + ", label %" + ifLabel + ", label %" + elseLabel + '\n' +
                ifLabel + ":\n");
        n.f4.accept(this);
        emit("\tbr label %" + endIfLabel + '\n' +
                elseLabel + ":\n");
        n.f6.accept(this);
        emit("\tbr label %" + endIfLabel + '\n' +
                endIfLabel + ":\n");
        return null;
    }

    /**
     * f0 -> "while"
     * f1 -> "("
     * f2 -> Expression()
     * f3 -> ")"
     * f4 -> Statement()
     */
    public String visit(WhileStatement n) throws Exception {
        String startLabel = getLabel("loop");
        String contLabel = getLabel("loop");
        String endLabel = getLabel("loop");
        emit("\tbr label %" + startLabel + '\n' +
                startLabel + ":\n");
        String exprReg = loadNonLiteral(n.f2.accept(this));
        emit("\tbr i1 " + exprReg + ", label %" + contLabel + ", label %" + endLabel + '\n' +
                contLabel + ":\n");
        n.f4.accept(this);
        emit("\tbr label %" + startLabel + '\n' +
                endLabel + ":\n");
        return null;
    }

    /**
     * f0 -> "System.out.println"
     * f1 -> "("
     * f2 -> Expression()
     * f3 -> ")"
     * f4 -> ";"
     */
    public String visit(PrintStatement n) throws Exception {
        String expr = loadNonLiteral(n.f2.accept(this));
        if ("boolean".equals(currExprType)) {
            String zextReg = getTempReg();
            emit('\t' + zextReg + " = zext i1 " + expr + " to i32\n" +
                    "\tcall void (i32) @print_int(i32 " + zextReg + ")\n");
        } else {
            emit("\tcall void (i32) @print_int(i32 " + expr + ")\n");
        }
        return null;
    }

    /**
     * f0 -> Clause()
     * f1 -> "&&"
     * f2 -> Clause()
     */
    public String visit(AndExpression n) throws Exception {
        String expr1 = loadNonLiteral(n.f0.accept(this));
        String expr2 = loadNonLiteral(n.f2.accept(this));
        String expr1Label = getLabel("and");
        String expr2Label = getLabel("and");
        String contLabel = getLabel("and");
        emit("\tbr label %" + expr1Label + '\n' +
                expr1Label + ":\n");
        emit("\tbr i1 " + expr1 + ", label %" + expr2Label + ", label %" + contLabel + '\n' +
                expr2Label + ":\n");
        emit("\tbr label %" + contLabel + '\n' +
                contLabel + ":\n");
        String tempReg = getTempReg();
        emit('\t' + tempReg + " = phi i1 [0, %" + expr1Label + "], [" + expr2 + ", %" + expr2Label + "]\n");
        currExprType = "boolean";
        return tempReg;
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "<"
     * f2 -> PrimaryExpression()
     */
    public String visit(CompareExpression n) throws Exception {
        String expr1 = loadNonLiteral(n.f0.accept(this));
        String expr2 = loadNonLiteral(n.f2.accept(this));
        String tempReg = getTempReg();
        emit('\t' + tempReg + " = icmp slt i32 " + expr1 + ", " + expr2 + '\n');
        currExprType = "boolean";
        return tempReg;
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "+"
     * f2 -> PrimaryExpression()
     */
    public String visit(PlusExpression n) throws Exception {
        String expr1 = loadNonLiteral(n.f0.accept(this));
        String expr2 = loadNonLiteral(n.f2.accept(this));
        String tempReg = getTempReg();
        emit('\t' + tempReg + " = add i32 " + expr1 + ", " + expr2 + '\n');
        currExprType = "int";
        return tempReg;
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "-"
     * f2 -> PrimaryExpression()
     */
    public String visit(MinusExpression n) throws Exception {
        String expr1 = loadNonLiteral(n.f0.accept(this));
        String expr2 = loadNonLiteral(n.f2.accept(this));
        String tempReg = getTempReg();
        emit('\t' + tempReg + " = sub i32 " + expr1 + ", " + expr2 + '\n');
        currExprType = "int";
        return tempReg;
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "*"
     * f2 -> PrimaryExpression()
     */
    public String visit(TimesExpression n) throws Exception {
        String expr1 = loadNonLiteral(n.f0.accept(this));
        String expr2 = loadNonLiteral(n.f2.accept(this));
        String tempReg = getTempReg();
        emit('\t' + tempReg + " = mul i32 " + expr1 + ", " + expr2 + '\n');
        currExprType = "int";
        return tempReg;
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "["
     * f2 -> PrimaryExpression()
     * f3 -> "]"
     */
    public String visit(ArrayLookup n) throws Exception {
        String arr = loadNonLiteral(n.f0.accept(this));
        String arrIndex = loadNonLiteral(n.f2.accept(this));
        String arrSizeReg = getTempReg();
        // emit check for arrIndex > arrSize (unsigned comparison also catches arrIndex < 0)
        String arrIndexCmpReg = getTempReg();
        String arrInvalidLabel = getLabel("oob");
        String arrValidLabel = getLabel("oob");
        String arrIncreasedIndexReg = getTempReg();
        String arrValueRegPtr = getTempReg();
        String arrValueReg = getTempReg();
        emit('\t' + arrSizeReg + " = load i32, i32* " + arr + '\n' +
                '\t' + arrIndexCmpReg + " = icmp ule i32 " + arrSizeReg + ", " + arrIndex + '\n' +
                "\tbr i1 " + arrIndexCmpReg + ", label %" + arrInvalidLabel + ", label %" + arrValidLabel + '\n' +
                arrInvalidLabel + ":\n" +
                "\tcall void @throw_oob()\n" +
                "\tbr label %" + arrValidLabel + '\n' +
                arrValidLabel + ":\n" +
                '\t' + arrIncreasedIndexReg + " = add i32 " + arrIndex + ", 1\n" +
                '\t' + arrValueRegPtr + " = getelementptr i32, i32* " + arr + ", i32 " + arrIncreasedIndexReg + '\n' +
                '\t' + arrValueReg + " = load i32, i32* " + arrValueRegPtr + '\n');
        currExprType = "int";
        return arrValueReg;
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "."
     * f2 -> "length"
     */
    public String visit(ArrayLength n) throws Exception {
        String arr = loadNonLiteral(n.f0.accept(this));
        String arrSizeReg = getTempReg();
        emit('\t' + arrSizeReg + " = load i32, i32* " + arr + '\n');
        currExprType = "int";
        return arrSizeReg;
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "."
     * f2 -> Identifier()
     * f3 -> "("
     * f4 -> ( ExpressionList() )?
     * f5 -> ")"
     */
    public String visit(MessageSend n) throws Exception {
        String classReg = loadNonLiteral(n.f0.accept(this));
        String classType = currExprType;
        String methodName = n.f2.accept(this);
        List<String> previousMethodParameterRegs = currMethodParameterRegs;
        currMethodParameterRegs = new ArrayList<>();
        n.f4.accept(this);
        int methodIndex = vTables.getClassMethodIndex(classType, methodName);
        String methodReturnType = symbolTable.getClassMethodReturnType(classType, methodName);
        String methodLLVMReturnType = getLLVMType(methodReturnType);
        String bitcast1Reg = getTempReg();
        String load1Reg = getTempReg();
        String elemPtrReg = getTempReg();
        String load2Reg = getTempReg();
        String bitcast2Reg = getTempReg();
        String callReg = getTempReg();
        String currBuffer = '\t' + bitcast1Reg + " = bitcast i8* " + classReg + " to i8***\n" +
                '\t' + load1Reg + " = load i8**, i8*** " + bitcast1Reg + '\n' +
                '\t' + elemPtrReg + " = getelementptr i8*, i8** " + load1Reg + ", i32 " + methodIndex + '\n' +
                '\t' + load2Reg + " = load i8*, i8** " + elemPtrReg + '\n' +
                '\t' + bitcast2Reg + " = bitcast i8* " + load2Reg + " to " + methodLLVMReturnType + " (i8*";
        List<String> methodParameterLLVMTypes = getClassMethodParameterLLVMTypes(classType, methodName);
        for (String parameterLLVMType : methodParameterLLVMTypes) {
            currBuffer += ", " + parameterLLVMType;
        }
        currBuffer += ")*\n" +
                '\t' + callReg + " = call " + methodLLVMReturnType + ' ' + bitcast2Reg + "(i8* " + classReg;
        Iterator it = currMethodParameterRegs.iterator();
        for (String parameterLLVMType : methodParameterLLVMTypes) {
            currBuffer += ", " + parameterLLVMType + ' ' + it.next();
        }
        emit(currBuffer + ")\n");
        currMethodParameterRegs = previousMethodParameterRegs;
        currExprType = methodReturnType;
        return callReg;
    }

    /**
     * f0 -> Expression()
     * f1 -> ExpressionTail()
     */
    public String visit(ExpressionList n) throws Exception {
        currMethodParameterRegs.add(loadNonLiteral(n.f0.accept(this)));
        n.f1.accept(this);
        return null;
    }

    /**
     * f0 -> ","
     * f1 -> Expression()
     */
    public String visit(ExpressionTerm n) throws Exception {
        currMethodParameterRegs.add(loadNonLiteral(n.f1.accept(this)));
        return null;
    }

    /**
     * f0 -> IntegerLiteral()
     *       | TrueLiteral()
     *       | FalseLiteral()
     *       | Identifier()
     *       | ThisExpression()
     *       | ArrayAllocationExpression()
     *       | AllocationExpression()
     *       | BracketExpression()
     */
    public String visit(PrimaryExpression n) throws Exception {
        String expr = n.f0.accept(this);
        if (expr == null) return null;
        if (symbolTable.getClassFieldType(currentClassName, expr) != null || symbolTable.getClassMethodVarType(currentClassName, currentMethodName, expr) != null) {
            return '%' + expr;
        }
        switch (expr) {
            case "true":
                return "1";
            case "false":
                return "0";
            default:
                return expr;
        }
    }

    /**
     * f0 -> <INTEGER_LITERAL>
     */
    public String visit(IntegerLiteral n) throws Exception {
        currExprType = "int";
        return n.f0.toString();
    }

    /**
     * f0 -> "true"
     */
    public String visit(TrueLiteral n) throws Exception {
        currExprType = "boolean";
        return "true";
    }

    /**
     * f0 -> "false"
     */
    public String visit(FalseLiteral n) throws Exception {
        currExprType = "boolean";
        return "false";
    }

    /**
     * f0 -> <IDENTIFIER>
     */
    public String visit(Identifier n) throws Exception {
        String idStr = n.f0.toString();
        if (currentClassName != null && currentMethodName != null) {
            currExprType = symbolTable.getClassMethodVarType(currentClassName, currentMethodName, idStr);   // could be null, then it won't be needed
        }
        return idStr;
    }

    /**
     * f0 -> "this"
     */
    public String visit(ThisExpression n) throws Exception {
        currExprType = currentClassName;
        return "%this";
    }

    /**
     * f0 -> "new"
     * f1 -> "int"
     * f2 -> "["
     * f3 -> Expression()
     * f4 -> "]"
     */
    public String visit(ArrayAllocationExpression n) throws Exception {
        String arrSize = loadNonLiteral(n.f3.accept(this));
        // emit check for arrSize < 0
        String arrSizeCmpReg = getTempReg();
        String arrInvalidLabel = getLabel("arr");
        String arrValidLabel = getLabel("arr");
        emit('\t' + arrSizeCmpReg + " = icmp slt i32 " + arrSize + ", 0\n" +
                "\tbr i1 " + arrSizeCmpReg + ", label %" + arrInvalidLabel + ", label %" + arrValidLabel + '\n' +
                arrInvalidLabel + ":\n" +
                "\tcall void @throw_oob()\n" +
                "\tbr label %" + arrValidLabel + '\n' +
                arrValidLabel + ":\n");
        String increasedArrSizeReg = getTempReg();
        String callocReg = getTempReg();
        String bitcastReg = getTempReg();
        // store arrSize as first element of array
        emit('\t' + increasedArrSizeReg + " = add i32 " + arrSize + ", 1\n" +
                '\t' + callocReg + " = call i8* @calloc(i32 4, i32 " + increasedArrSizeReg + ")\n" +
                '\t' + bitcastReg + " = bitcast i8* " + callocReg + " to i32*\n" +
                "\tstore i32 " + arrSize + ", i32* " + bitcastReg + "\n");
        currExprType = "int[]";
        return bitcastReg;
    }

    /**
     * f0 -> "new"
     * f1 -> Identifier()
     * f2 -> "("
     * f3 -> ")"
     */
    public String visit(AllocationExpression n) throws Exception {
        String className = n.f1.accept(this);
        int classSize = getClassSize(className);
        int vTableLength = getClassMethodsNum(className);
        String callocReg = getTempReg();
        String bitcastReg = getTempReg();
        String elemPtrReg = getTempReg();
        emit('\t' + callocReg + " = call i8* @calloc(i32 1, i32 " + classSize + ")\n" +
                '\t' + bitcastReg + " = bitcast i8* " + callocReg + " to i8***\n" +
                '\t' + elemPtrReg + " = getelementptr [" + vTableLength + " x i8*], [" + vTableLength + " x i8*]* @." + className + "_vtable, i32 0, i32 0\n" +
                "\tstore i8** " + elemPtrReg + ", i8*** " + bitcastReg + '\n');
        currExprType = className;
        return callocReg;
    }

    /**
     * f0 -> "!"
     * f1 -> Clause()
     */
    public String visit(NotExpression n) throws Exception {
        String expr = loadNonLiteral(n.f1.accept(this));
        String tempReg = getTempReg();
        emit('\t' + tempReg + " = xor i1 1, " + expr + '\n');
        return tempReg;
    }

    /**
     * f0 -> "("
     * f1 -> Expression()
     * f2 -> ")"
     */
    public String visit(BracketExpression n) throws Exception {
        return loadNonLiteral(n.f1.accept(this));
    }

}

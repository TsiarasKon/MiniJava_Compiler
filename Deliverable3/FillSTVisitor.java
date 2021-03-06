import syntaxtree.*;
import visitor.GJDepthFirst;

public class FillSTVisitor extends GJDepthFirst<String, SymbolTable>{

	private String currentClassName;
	private String currentMethodName;

	private int lineNumber;
	private int columnNumber;

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
		String mainClassName = n.f1.accept(this, symbolTable);
        symbolTable.addClass(mainClassName, lineNumber, columnNumber);
        currentClassName = mainClassName;
        symbolTable.addClassMethod(mainClassName, "void", "main");
        currentMethodName = "main";
		String mainParamName = n.f11.accept(this, symbolTable);
		symbolTable.addClassMethodParam(mainClassName, "main", "undefined", mainParamName);
		n.f14.accept(this, symbolTable);
        currentMethodName = null;
        currentClassName = null;
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
	public String visit(ClassDeclaration n, SymbolTable symbolTable) throws Exception {
		String className = n.f1.accept(this, symbolTable);
		symbolTable.addClass(className, lineNumber, columnNumber);
		currentClassName = className;
		n.f3.accept(this, symbolTable);
		n.f4.accept(this, symbolTable);
		currentClassName = null;
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
		String className = n.f1.accept(this, symbolTable);
		String parentClassName = n.f3.accept(this, symbolTable);
		symbolTable.addClass(className, parentClassName, lineNumber, columnNumber);
		currentClassName = className;
		n.f5.accept(this, symbolTable);
		n.f6.accept(this, symbolTable);
		currentClassName = null;
		return null;
	}

	/**
	 * f0 -> Type()
	 * f1 -> Identifier()
	 * f2 -> ";"
	 */
	public String visit(VarDeclaration n, SymbolTable symbolTable) throws Exception {
		String varType = n.f0.accept(this, symbolTable);
		String varName = n.f1.accept(this, symbolTable);
		if (currentMethodName == null) {        // adding class fields
			if (!symbolTable.addClassField(currentClassName, varType, varName)) {
				throw new SemanticException("duplicate field named '" + varName + "' in class '" + currentClassName + "'", lineNumber, columnNumber);
			}
        } else {        // adding method variable
		    if (!symbolTable.addMethodVar(currentClassName, currentMethodName, varType, varName)) {
				throw new SemanticException("duplicate variable named '" + varName + "' in '" + currentClassName + "." + currentMethodName + "()'", lineNumber, columnNumber);
            }
        }
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
	public String visit(MethodDeclaration n, SymbolTable symbolTable) throws Exception {
		String methodType = n.f1.accept(this, symbolTable);
		String methodName = n.f2.accept(this, symbolTable);
		if (!symbolTable.addClassMethod(currentClassName, methodType, methodName)) {
			throw new SemanticException("method '" + methodName + "()' is already defined in class '" + currentClassName + "'", lineNumber, columnNumber);
		}
		currentMethodName = methodName;
		n.f4.accept(this, symbolTable);
		n.f7.accept(this, symbolTable);
		currentMethodName = null;
		return null;
	}

	/**
	 * f0 -> Type()
	 * f1 -> Identifier()
	 */
	public String visit(FormalParameter n, SymbolTable symbolTable) throws Exception {
		String varType = n.f0.accept(this, symbolTable);
		String varName = n.f1.accept(this, symbolTable);
		if (!symbolTable.addClassMethodParam(currentClassName, currentMethodName, varType, varName)) {
			throw new SemanticException("duplicate parameter named '" + varName + "' in '" + currentClassName + "." + currentMethodName + "()'", lineNumber, columnNumber);
		}
		return null;
	}

	public String visit(ArrayType n, SymbolTable symbolTable) {
		lineNumber = n.f0.beginLine;
		columnNumber = n.f0.beginColumn;
		return "int[]";
	}

	public String visit(BooleanType n, SymbolTable symbolTable) {
		lineNumber = n.f0.beginLine;
		columnNumber = n.f0.beginColumn;
		return "boolean";
	}

	public String visit(IntegerType n, SymbolTable symbolTable) {
		lineNumber = n.f0.beginLine;
		columnNumber = n.f0.beginColumn;
        return "int";
	}

	/**
	 * f0 -> <IDENTIFIER>
	 */
	public String visit(Identifier n, SymbolTable symbolTable) {
		lineNumber = n.f0.beginLine;
		columnNumber = n.f0.beginColumn;
		return n.f0.toString();
	}

}

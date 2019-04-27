import syntaxtree.*;
import visitor.GJDepthFirst;

public class FillSTVisitor extends GJDepthFirst<String, SymbolTable>{

	private String currentClassName;
	private String currentMethodName;

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
        symbolTable.addClass(mainClassName);
        currentClassName = mainClassName;
        symbolTable.addClassMethod(mainClassName, "main", "void");
        currentMethodName = "main";
		String mainParamName = n.f11.accept(this, symbolTable);
		try {
            symbolTable.addClassMethodParam(mainClassName, "main", "undefined", mainParamName);
        } catch (SemanticException se) {    // should never get here
		    System.out.println(se.getMessage() + "invalid main parameter name?");
        }
		n.f14.accept(this, symbolTable);
        currentMethodName = null;
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
		if (currentMethodName == null) {        // adding class field
            symbolTable.addClassField(currentClassName, varType, varName);
        } else {        // adding method variable
		    try {
                symbolTable.addMethodVar(currentClassName, currentMethodName, varType, varName);
            } catch (SemanticException se) {
                System.out.println(se.getMessage() + "duplicate variable name in \"" + currentClassName + "." + currentMethodName + "()\"");
                throw se;
            }
        }
		return varType + " " + varName;
	}

	public String visit(ArrayType n, SymbolTable symbolTable) {
		return "int[]";
	}

	public String visit(BooleanType n, SymbolTable symbolTable) {
		return "boolean";
	}

	public String visit(IntegerType n, SymbolTable symbolTable) {
        return "int";
	}

	/**
	 * f0 -> <IDENTIFIER>
	 */
	public String visit(Identifier n, SymbolTable symbolTable) {
		return n.f0.toString();
	}

}

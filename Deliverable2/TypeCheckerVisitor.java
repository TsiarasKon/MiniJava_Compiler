import syntaxtree.*;
import visitor.GJDepthFirst;

import java.util.ArrayList;

public class TypeCheckerVisitor extends GJDepthFirst<String, SymbolTable>{

	private String currentClassName;
	private String currentMethodName;
	private String newlyCreatedClass;
	private ArrayList<String> methodParameters;

	private int lineNumber;
	private int columnNumber;

	public TypeCheckerVisitor() {
		lineNumber = columnNumber = 1;
	}

	private void validateType(String type, SymbolTable symbolTable, String validType, String exceptionMsg) throws SemanticException {
		if (!type.equals(validType)) {
			if (currentMethodName == null && !validType.equals(symbolTable.getClassFieldType(currentClassName, type))) {
				throw new SemanticException(exceptionMsg, lineNumber, columnNumber);
			}
			String actualType = symbolTable.getClassMethodVarType(currentClassName, currentMethodName, type);
			if (actualType == null && !type.equals("int") && !type.equals("boolean") && !type.equals("int[]")) {
				throw new SemanticException("unknown identifier '" + type + "'", lineNumber, columnNumber);
			}
			if (!validType.equals(actualType)) {
				throw new SemanticException(exceptionMsg, lineNumber, columnNumber);
			}
		}
	}

	private void validateType2(String type, SymbolTable symbolTable, String validType1, String validType2, String exceptionMsg) throws SemanticException {
		if (!type.equals(validType1) && !type.equals(validType2)) {
			if (currentMethodName == null && !validType1.equals(symbolTable.getClassFieldType(currentClassName, type)) &&
					!validType2.equals(symbolTable.getClassFieldType(currentClassName, type))) {
				throw new SemanticException(exceptionMsg, lineNumber, columnNumber);
			}
			String actualType = symbolTable.getClassMethodVarType(currentClassName, currentMethodName, type);
			if (actualType == null && !type.equals("int") && !type.equals("boolean") && !type.equals("int[]")) {
				throw new SemanticException("unknown identifier '" + type + "'", lineNumber, columnNumber);
			}
			if (!validType1.equals(actualType) && !validType2.equals(actualType)) {
				throw new SemanticException(exceptionMsg, lineNumber, columnNumber);
			}
		}
	}

	private void validateClassName(String className, SymbolTable symbolTable, String exceptionMsg) throws SemanticException {
	    if (newlyCreatedClass != null) {
	        if (!symbolTable.classExists(newlyCreatedClass)) {
                throw new SemanticException(exceptionMsg, lineNumber, columnNumber);
	        }
        } else {
			if (!symbolTable.classExists(className)) {
				String classType = symbolTable.getClassMethodVarType(currentClassName, currentMethodName, className);
				if (classType == null || classType.equals("int") || classType.equals("boolean") || classType.equals("int[]")) {
					throw new SemanticException(exceptionMsg, lineNumber, columnNumber);
				}
			}
        }
	}

	private void parameterListTypeAdd(String type, SymbolTable symbolTable) throws SemanticException {
		if (type.equals("int") || type.equals("boolean") || type.equals("int[]") || symbolTable.classExists(type)) {
            methodParameters.add(type);
        } else {
			String actualType = symbolTable.getClassMethodVarType(currentClassName, currentMethodName, type);
			if (actualType == null) {
				throw new SemanticException("variable '" + type + "' has not been defined", lineNumber, columnNumber);
			}
			methodParameters.add(actualType);
		}
	}

	private void validateAssignment(SymbolTable symbolTable, String leftType, String rightType) throws SemanticException {
		String possibleRightClassType = symbolTable.getClassMethodVarType(currentClassName, currentMethodName, rightType);
	    if (leftType.equals(rightType) || leftType.equals(possibleRightClassType) || symbolTable.isClassOrSubclass(rightType, leftType)) {
	    	return;
        }
	    if (possibleRightClassType == null) {
			throw new SemanticException("unknown identifier '" + rightType + "'", lineNumber, columnNumber);
		}
	    if (!symbolTable.isClassOrSubclass(possibleRightClassType, leftType)) {
            throw new SemanticException("cannot assign an expression of type '" + possibleRightClassType + "' to a variable of type '" + leftType + "'", lineNumber, columnNumber);
        }
    }

    private void validateMethodReturnType(SymbolTable symbolTable, String returnExprType) throws SemanticException {
		String methodReturnType = symbolTable.getClassMethodReturnType(currentClassName, currentMethodName);
		try {
			validateAssignment(symbolTable, methodReturnType, returnExprType);
		} catch (SemanticException se) {
			throw new SemanticException("returning type '" + returnExprType + "' from '" + currentClassName + "." +
					currentMethodName + "()' which has return type '" + methodReturnType + "'", lineNumber, columnNumber);
		}
	}

	/* Overridden visit() methods: */

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
        currentClassName = n.f1.accept(this, symbolTable);
        currentMethodName = "main";
        n.f15.accept(this, symbolTable);
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
        currentClassName = n.f1.accept(this, symbolTable);
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
        currentClassName = n.f1.accept(this, symbolTable);
        n.f6.accept(this, symbolTable);
        currentClassName = null;
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
        currentMethodName = n.f2.accept(this, symbolTable);
        n.f8.accept(this, symbolTable);
        String returnExprType = n.f10.accept(this, symbolTable);
        validateMethodReturnType(symbolTable, returnExprType);
        currentMethodName = null;
        return null;
    }

    /**
     * f0 -> Identifier()
     * f1 -> "="
     * f2 -> Expression()
     * f3 -> ";"
     */
    public String visit(AssignmentStatement n, SymbolTable symbolTable) throws Exception {
    	String f0str = n.f0.accept(this, symbolTable);
        String f0Type = symbolTable.getClassMethodVarType(currentClassName, currentMethodName, f0str);
        if (f0Type == null) {
        	throw new SemanticException("trying to assign to a variable named '" + f0str + "' which has not previously been defined", lineNumber, columnNumber);
		}
        String f2str = n.f2.accept(this, symbolTable);
        validateAssignment(symbolTable, f0Type, f2str);
        return f0Type;
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
    public String visit(ArrayAssignmentStatement n, SymbolTable symbolTable) throws Exception {
        validateType(n.f0.accept(this, symbolTable), symbolTable, "int[]", "trying to get an element of a non-array type");
        validateType(n.f2.accept(this, symbolTable), symbolTable, "int", "array index is not an integer");
        validateType(n.f5.accept(this, symbolTable), symbolTable, "int", "trying to assign a non-integer to an integer array element");
        return null;
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
    public String visit(IfStatement n, SymbolTable symbolTable) throws Exception {
        validateType(n.f2.accept(this, symbolTable), symbolTable, "boolean", "using a non-boolean value for an 'if' condition");
        n.f4.accept(this, symbolTable);
        n.f6.accept(this, symbolTable);
        return null;
    }

    /**
     * f0 -> "while"
     * f1 -> "("
     * f2 -> Expression()
     * f3 -> ")"
     * f4 -> Statement()
     */
    public String visit(WhileStatement n, SymbolTable symbolTable) throws Exception {
        validateType(n.f2.accept(this, symbolTable), symbolTable, "boolean", "using a non-boolean value for a 'while' condition");
        n.f4.accept(this, symbolTable);
        return null;
    }

    /**
     * f0 -> "System.out.println"
     * f1 -> "("
     * f2 -> Expression()
     * f3 -> ")"
     * f4 -> ";"
     */
    public String visit(PrintStatement n, SymbolTable symbolTable) throws Exception {
    	String f2str = n.f2.accept(this, symbolTable);
		String f2Type = (f2str.equals("int") || f2str.equals("boolean") || f2str.equals("int[]")) ? f2str : symbolTable.getClassMethodVarType(currentClassName, currentMethodName, f2str);
        validateType2(f2str, symbolTable, "int", "boolean", "attempted to print non-printable type '" + f2Type + "'");
        return null;
    }

	/**
	 * f0 -> Clause()
	 * f1 -> "&&"
	 * f2 -> Clause()
	 */
	public String visit(AndExpression n, SymbolTable symbolTable) throws Exception {
		validateType(n.f0.accept(this, symbolTable), symbolTable, "boolean", "left clause of '&&' operator is not a boolean");
		validateType(n.f2.accept(this, symbolTable), symbolTable, "boolean", "right clause of '&&' operator is not a boolean");
		return "boolean";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "<"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(CompareExpression n, SymbolTable symbolTable) throws Exception {
		validateType(n.f0.accept(this, symbolTable), symbolTable, "int", "left expression of '<' operator is not an integer");
		validateType(n.f2.accept(this, symbolTable), symbolTable, "int", "right expression of '<' operator is not an integer");
		return "boolean";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "+"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(PlusExpression n, SymbolTable symbolTable) throws Exception {
		validateType(n.f0.accept(this, symbolTable), symbolTable, "int", "left expression of '+' operator is not a boolean");
		validateType(n.f2.accept(this, symbolTable), symbolTable, "int", "right expression of '+' operator is not an integer");
		return "int";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "-"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(MinusExpression n, SymbolTable symbolTable) throws Exception {
		validateType(n.f0.accept(this, symbolTable), symbolTable, "int", "left expression of '-' operator is not a boolean");
		validateType(n.f2.accept(this, symbolTable), symbolTable, "int",  "right expression of '-' operator is not an integer");
		return "int";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "*"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(TimesExpression n, SymbolTable symbolTable) throws Exception {
		validateType(n.f0.accept(this, symbolTable), symbolTable, "int", "left expression of '*' operator is not a boolean");
		validateType(n.f2.accept(this, symbolTable), symbolTable, "int", "right expression of '*' operator is not an integer");
		return "int";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "["
	 * f2 -> PrimaryExpression()
	 * f3 -> "]"
	 */
	public String visit(ArrayLookup n, SymbolTable symbolTable) throws Exception {
		validateType(n.f0.accept(this, symbolTable), symbolTable, "int[]", "trying to get an element of a non-array type");
		validateType(n.f2.accept(this, symbolTable), symbolTable, "int", "array index is not an integer");
		return "int";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "."
	 * f2 -> "length"
	 */
	public String visit(ArrayLength n, SymbolTable symbolTable) throws Exception {
		validateType(n.f0.accept(this, symbolTable), symbolTable, "int[]", "trying to get length of a non-array type");
		return "int";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "."
	 * f2 -> Identifier()
	 * f3 -> "("
	 * f4 -> ( ExpressionList() )?
	 * f5 -> ")"
	 */
	public String visit(MessageSend n, SymbolTable symbolTable) throws Exception {
	    newlyCreatedClass = null;
		String f0str = n.f0.accept(this, symbolTable);
		String f0Type = (symbolTable.classExists(f0str)) ? f0str : (newlyCreatedClass == null) ? symbolTable.getClassMethodVarType(currentClassName, currentMethodName, f0str) : newlyCreatedClass;
		validateClassName(f0str, symbolTable, "tried to call a method of class '" + f0Type + "' but a class with that name has not been defined");
		String f2str = n.f2.accept(this, symbolTable);
		String methodReturnType = symbolTable.getClassMethodReturnType(f0Type, f2str);
		if (methodReturnType == null) {
			throw new SemanticException("tried to call '" + f0Type + "." + f2str + "()' but class '" + f0Type + "' has no method named '" + f2str + "'", lineNumber, columnNumber);
		}
		ArrayList<String> previousMethodParameters = null;		// needed for nested method calls
		if (methodParameters != null) {
			previousMethodParameters = new ArrayList<>(methodParameters);
		}
		methodParameters = new ArrayList<>();
        n.f4.accept(this, symbolTable);
		symbolTable.validateClassMethodParameters(f0Type, f2str, methodParameters, lineNumber, columnNumber);
		if (previousMethodParameters != null) {
			methodParameters = previousMethodParameters;
		}
		return methodReturnType;
	}

	/**
	 * f0 -> Expression()
	 * f1 -> ExpressionTail()
	 */
	public String visit(ExpressionList n, SymbolTable symbolTable) throws Exception {
		parameterListTypeAdd(n.f0.accept(this, symbolTable), symbolTable);
		n.f1.accept(this, symbolTable);
		return null;
	}

	/**
	 * f0 -> ","
	 * f1 -> Expression()
	 */
	public String visit(ExpressionTerm n, SymbolTable symbolTable) throws Exception {
		parameterListTypeAdd(n.f1.accept(this, symbolTable), symbolTable);
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
	public String visit(PrimaryExpression n, SymbolTable symbolTable) throws Exception {
		String exprStr = n.f0.accept(this, symbolTable);
		switch (exprStr) {
			case "INTEGER_LITERAL":
				return "int";
			case "BOOLEAN_LITERAL":
				return "boolean";
			case "this":
				return currentClassName;
			default:
				return exprStr;
		}
	}

	/**
	 * f0 -> <INTEGER_LITERAL>
	 */
	public String visit(IntegerLiteral n, SymbolTable symbolTable) {
		lineNumber = n.f0.beginLine;
		columnNumber = n.f0.beginColumn;
		return "INTEGER_LITERAL";
	}

	/**
	 * f0 -> "true"
	 */
	public String visit(TrueLiteral n, SymbolTable symbolTable) {
		lineNumber = n.f0.beginLine;
		columnNumber = n.f0.beginColumn;
		return "BOOLEAN_LITERAL";
	}

	/**
	 * f0 -> "false"
	 */
	public String visit(FalseLiteral n, SymbolTable symbolTable) {
		lineNumber = n.f0.beginLine;
		columnNumber = n.f0.beginColumn;
		return "BOOLEAN_LITERAL";
	}

	/**
	 * f0 -> <IDENTIFIER>
	 */
	public String visit(Identifier n, SymbolTable symbolTable) {
		lineNumber = n.f0.beginLine;
		columnNumber = n.f0.beginColumn;
		return n.f0.toString();
	}

	/**
	 * f0 -> "this"
	 */
	public String visit(ThisExpression n, SymbolTable symbolTable) {
		lineNumber = n.f0.beginLine;
		columnNumber = n.f0.beginColumn;
		return "this";
	}

	/**
	 * f0 -> "new"
	 * f1 -> "int"
	 * f2 -> "["
	 * f3 -> Expression()
	 * f4 -> "]"
	 */
	public String visit(ArrayAllocationExpression n, SymbolTable symbolTable) throws Exception {
		validateType(n.f3.accept(this, symbolTable), symbolTable, "int", "trying to allocate array of not integer size");
		return "int[]";
	}

	/**
	 * f0 -> "new"
	 * f1 -> Identifier()
	 * f2 -> "("
	 * f3 -> ")"
	 */
	public String visit(AllocationExpression n, SymbolTable symbolTable) throws Exception {
		String newClassName = n.f1.accept(this, symbolTable);
		if (!symbolTable.classExists(newClassName)) {
			throw new SemanticException("trying to create a new instance of class '" + newClassName + "' but that class has not been defined", lineNumber, columnNumber);
		}
		newlyCreatedClass = newClassName;
		return newClassName;
	}

	/**
	 * f0 -> "!"
	 * f1 -> Clause()
	 */
	public String visit(NotExpression n, SymbolTable symbolTable) throws Exception {
		validateType(n.f1.accept(this, symbolTable), symbolTable, "boolean", "tried to use operator '!' on non-boolean clause");
		return "boolean";
	}

    /**
     * f0 -> "("
     * f1 -> Expression()
     * f2 -> ")"
     */
    public String visit(BracketExpression n, SymbolTable symbolTable) throws Exception {
        return n.f1.accept(this, symbolTable);
    }

}

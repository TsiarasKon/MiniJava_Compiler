import syntaxtree.*;
import visitor.GJDepthFirst;

import java.util.ArrayList;

public class AnalyzerVisitor extends GJDepthFirst<String, SymbolTable>{

	private String currentClassName;
	private String currentMethodName;
	private String newlyCreatedClass;
	private ArrayList<String> methodParameters;

	private void validateType(String type, SymbolTable symbolTable, String validType, String exceptionMsg) throws SemanticException {
		if (!type.equals(validType)) {
			if (currentMethodName == null && !validType.equals(symbolTable.getClassFieldType(currentClassName, type))) {
				throw new SemanticException(exceptionMsg);
			}
			if (!validType.equals(symbolTable.getClassMethodVarType(currentClassName, currentMethodName, type))) {
				throw new SemanticException(exceptionMsg);
			}
		}
	}

	private void validateType2(String type, SymbolTable symbolTable, String validType1, String validType2, String exceptionMsg) throws SemanticException {
		if (!type.equals(validType1) && !type.equals(validType2)) {
			if (currentMethodName == null && !validType1.equals(symbolTable.getClassFieldType(currentClassName, type)) &&
					!validType2.equals(symbolTable.getClassFieldType(currentClassName, type))) {
				throw new SemanticException(exceptionMsg);
			}
			if (!validType1.equals(symbolTable.getClassMethodVarType(currentClassName, currentMethodName, type)) &&
					!validType2.equals(symbolTable.getClassMethodVarType(currentClassName, currentMethodName, type))) {
				throw new SemanticException(exceptionMsg);
			}
		}
	}

    private void validateType4(String type, SymbolTable symbolTable, String validType1, String validType2, String validType3, String validType4, String exceptionMsg) throws SemanticException {
        if (!type.equals(validType1) && !type.equals(validType2) && !type.equals(validType3) && !type.equals(validType4)) {
            if (!validType1.equals(symbolTable.getClassMethodVarType(currentClassName, currentMethodName, type)) &&
                    !validType2.equals(symbolTable.getClassMethodVarType(currentClassName, currentMethodName, type)) &&
                    !validType3.equals(symbolTable.getClassMethodVarType(currentClassName, currentMethodName, type)) &&
                    !validType4.equals(symbolTable.getClassMethodVarType(currentClassName, currentMethodName, type))) {
                throw new SemanticException(exceptionMsg);
            }
        }
    }

	private void validateClassName(String className, SymbolTable symbolTable, String exceptionMsg) throws SemanticException {
	    if (newlyCreatedClass != null) {
	        if (!symbolTable.classExists(newlyCreatedClass)) {
                throw new SemanticException(exceptionMsg);      // TODO other msg
            }
        } else {
            String classType = symbolTable.getClassMethodVarType(currentClassName, currentMethodName, className);
            if (classType == null || classType.equals("int") || classType.equals("boolean") || classType.equals("int[]")) {        // TODO: second exception message
                throw new SemanticException(exceptionMsg);
            }
        }
	}

	private void parameterListTypeAdd(String type, SymbolTable symbolTable) throws SemanticException {
		if (type.equals("INTEGER_LITERAL")) {
			methodParameters.add("int");
		} else if (type.equals("BOOLEAN_LITERAL")) {
			methodParameters.add("boolean");
		} else {
			String actualType = symbolTable.getClassMethodVarType(currentClassName, currentMethodName, type);
			if (actualType == null) {
				throw new SemanticException("variable '" + type + "' has not been defined");
			}
			methodParameters.add(actualType);
		}
	}

	private void validateAssignment(SymbolTable symbolTable, String leftType, String rightType) throws SemanticException {
	    if (leftType.equals(rightType) || rightType.equals("int") && !leftType.equals("INTEGER_LITERAL") || (rightType.equals("boolean") && !leftType.equals("BOOLEAN_LITERAL"))) {
	        return;
        }
        if (!symbolTable.isClassOrSubclass(leftType, rightType)) {
            throw new SemanticException("cannot assign a class of type '" + rightType + "' to a variable of type '" + leftType +
                    "' because the former is not identical to or a subclass of the latter");
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
        n.f10.accept(this, symbolTable);
        currentMethodName = null;
        return null;
    }

//    /**
//     * f0 -> Identifier()
//     * f1 -> "="
//     * f2 -> Expression()
//     * f3 -> ";"
//     */
//    public String visit(AssignmentStatement n, SymbolTable symbolTable) throws Exception {
//        String idType = symbolTable.getClassMethodVarType(currentClassName, currentMethodName, n.f0.accept(this, symbolTable));
//        String f2str = n.f2.accept(this, symbolTable);
//        validateAssignment(symbolTable, idType, f2str);
//        return f2str;
//    }

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
        // TODO: messages
        validateType(n.f0.accept(this, symbolTable), symbolTable, "int[]", "type");
        validateType2(n.f2.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
        validateType2(n.f5.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
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
        validateType2(n.f2.accept(this, symbolTable), symbolTable, "boolean", "BOOLEAN_LITERAL", "type");
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
        validateType2(n.f2.accept(this, symbolTable), symbolTable, "boolean", "BOOLEAN_LITERAL", "type");
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
        validateType4(n.f2.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL",
                "boolean", "BOOLEAN_LITERAL", "attempted to print non-printable type");
        return null;
    }
    
	/**
	 * f0 -> Clause()
	 * f1 -> "&&"
	 * f2 -> Clause()
	 */
	public String visit(AndExpression n, SymbolTable symbolTable) throws Exception {
		// expected f0 type: int or INTEGER_LITERAL
		validateType2(n.f0.accept(this, symbolTable), symbolTable, "boolean", "BOOLEAN_LITERAL", "type");
		// expected f2 type: int or INTEGER_LITERAL
		validateType2(n.f2.accept(this, symbolTable), symbolTable, "boolean", "BOOLEAN_LITERAL", "type");
		return "boolean";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "<"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(CompareExpression n, SymbolTable symbolTable) throws Exception {
		// expected f0 type: int or INTEGER_LITERAL
		validateType2(n.f0.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
		// expected f2 type: int or INTEGER_LITERAL
		validateType2(n.f2.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
		return "boolean";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "+"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(PlusExpression n, SymbolTable symbolTable) throws Exception {
		// expected f0 type: int or INTEGER_LITERAL
		validateType2(n.f0.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
		// expected f2 type: int or INTEGER_LITERAL
		validateType2(n.f2.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
		return "int";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "-"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(MinusExpression n, SymbolTable symbolTable) throws Exception {
		// expected f0 type: int or INTEGER_LITERAL
		validateType2(n.f0.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
		// expected f2 type: int or INTEGER_LITERAL
		validateType2(n.f2.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
		return "int";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "*"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(TimesExpression n, SymbolTable symbolTable) throws Exception {
		// expected f0 type: int or INTEGER_LITERAL
		validateType2(n.f0.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
		// expected f2 type: int or INTEGER_LITERAL
		validateType2(n.f2.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
		return "int";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "["
	 * f2 -> PrimaryExpression()
	 * f3 -> "]"
	 */
	public String visit(ArrayLookup n, SymbolTable symbolTable) throws Exception {
		// expected f0 type: int[]
		validateType(n.f0.accept(this, symbolTable), symbolTable, "int[]", "type");
		// expected f2 type: int or INTEGER_LITERAL
		validateType2(n.f2.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
		return "int";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "."
	 * f2 -> "length"
	 */
	public String visit(ArrayLength n, SymbolTable symbolTable) throws Exception {
		// expected f0 type: int[]
		validateType(n.f0.accept(this, symbolTable), symbolTable, "int[]", "type");
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
		// expected f0 type: class
		String f0str = n.f0.accept(this, symbolTable);
		if (f0str.equals("this")) {
			f0str = currentClassName;
		} else {
			validateClassName(f0str, symbolTable, "tried to call a method of class '" + f0str + "' but a class with that name has not been defined");
		}
//		String f0Type =
		String f2str = n.f2.accept(this, symbolTable);
		String methodReturnType = symbolTable.getClassMethodReturnType(f0str, f2str);
		if (methodReturnType == null) {
			throw new SemanticException("tried to call '" + f0str + "." + f2str + "()' but class '" + f0str + "' has no method named '" + f2str + "'");
		}
		methodParameters = new ArrayList<>();
        n.f4.accept(this, symbolTable);
		symbolTable.validateClassMethodParameters(f0str, f2str, methodParameters);
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
	 * f0 -> <INTEGER_LITERAL>
	 */
	public String visit(IntegerLiteral n, SymbolTable symbolTable) {
		return "INTEGER_LITERAL";
	}

	/**
	 * f0 -> "true"
	 */
	public String visit(TrueLiteral n, SymbolTable symbolTable) {
		return "BOOLEAN_LITERAL";
	}

	/**
	 * f0 -> "false"
	 */
	public String visit(FalseLiteral n, SymbolTable symbolTable) {
		return "BOOLEAN_LITERAL";
	}

	/**
	 * f0 -> <IDENTIFIER>
	 */
	public String visit(Identifier n, SymbolTable symbolTable) {
		return n.f0.toString();
	}

	/**
	 * f0 -> "this"
	 */
	public String visit(ThisExpression n, SymbolTable symbolTable) {
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
		// expected f3 type: int or INTEGER_LITERAL
		validateType2(n.f3.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
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
			throw new SemanticException("trying to create a new instance of class '" + newClassName + "' but that class has not been defined");
		}
		newlyCreatedClass = newClassName;
		return newClassName;
	}

	/**
	 * f0 -> "!"
	 * f1 -> Clause()
	 */
	public String visit(NotExpression n, SymbolTable symbolTable) throws Exception {
		// expected f1 type: boolean or BOOLEAN_LITERAL
		validateType2(n.f1.accept(this, symbolTable), symbolTable, "boolean", "BOOLEAN_LITERAL", "type");
		return "boolean";
	}

}

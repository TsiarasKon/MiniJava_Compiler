import syntaxtree.*;
import visitor.GJDepthFirst;

import java.util.ArrayList;
import java.util.LinkedHashMap;

public class AnalyzerVisitor extends GJDepthFirst<String, SymbolTable>{

	private String currentClassName;
	private String currentMethodName;
	private String expressionType;
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

	private void validateType(String type, SymbolTable symbolTable, String validType1, String validType2, String exceptionMsg) throws SemanticException {
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

	private void validateClassName(String className, SymbolTable symbolTable, String exceptionMsg) throws SemanticException {
		String classType = symbolTable.getClassMethodVarType(currentClassName, currentMethodName, className);
		if (classType == null || classType.equals("int") || classType.equals("boolean") || classType.equals("int[]")) {		// TODO: second exception message
			throw new SemanticException(exceptionMsg);
		}
	}

	/* Overridden visit() methods: */

	/**
	 * f0 -> Clause()
	 * f1 -> "&&"
	 * f2 -> Clause()
	 */
	public String visit(AndExpression n, SymbolTable symbolTable) throws Exception {
		// expected f0 type: int or INTEGER_LITERAL
		validateType(n.f0.accept(this, symbolTable), symbolTable, "boolean", "BOOLEAN_LITERAL", "type");
		// expected f2 type: int or INTEGER_LITERAL
		validateType(n.f2.accept(this, symbolTable), symbolTable, "boolean", "BOOLEAN_LITERAL", "type");
		return "boolean";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "<"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(CompareExpression n, SymbolTable symbolTable) throws Exception {
		// expected f0 type: int or INTEGER_LITERAL
		validateType(n.f0.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
		// expected f2 type: int or INTEGER_LITERAL
		validateType(n.f2.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
		return "boolean";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "+"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(PlusExpression n, SymbolTable symbolTable) throws Exception {
		// expected f0 type: int or INTEGER_LITERAL
		validateType(n.f0.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
		// expected f2 type: int or INTEGER_LITERAL
		validateType(n.f2.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
		return "int";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "-"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(MinusExpression n, SymbolTable symbolTable) throws Exception {
		// expected f0 type: int or INTEGER_LITERAL
		validateType(n.f0.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
		// expected f2 type: int or INTEGER_LITERAL
		validateType(n.f2.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
		return "int";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "*"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(TimesExpression n, SymbolTable symbolTable) throws Exception {
		// expected f0 type: int or INTEGER_LITERAL
		validateType(n.f0.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
		// expected f2 type: int or INTEGER_LITERAL
		validateType(n.f2.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
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
		validateType(n.f2.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
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
		// expected f0 type: class
		String f0str = n.f0.accept(this, symbolTable);
		if (f0str.equals("this")) {
			f0str = currentClassName;
		} else {
			validateClassName(f0str, symbolTable, "tried to call a method of class '" + f0str + "' but a class with that name has not been defined");
		}
		String f2str = n.f0.accept(this, symbolTable);
		String methodReturnType = symbolTable.getClassMethodReturnType(f0str, f2str);
		if (methodReturnType == null) {
			throw new SemanticException("tried to call '" + f0str + "." + f2str + "()' but class '" + f0str + "' has no method named '" + f2str + "'");
		}
		return methodReturnType;
	}

	/**
	 * f0 -> Expression()
	 * f1 -> ExpressionTail()
	 */
	public String visit(ExpressionList n, SymbolTable symbolTable) throws Exception {
		methodParameters = new ArrayList<>();
		methodParameters.add(n.f0.accept(this, symbolTable));
		n.f1.accept(this, symbolTable);
		return null;
	}

	/**
	 * f0 -> ","
	 * f1 -> Expression()
	 */
	public String visit(ExpressionTerm n, SymbolTable symbolTable) throws Exception {
		methodParameters.add(n.f1.accept(this, symbolTable));
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
		validateType(n.f3.accept(this, symbolTable), symbolTable, "int", "INTEGER_LITERAL", "type");
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
		return newClassName;
	}

	/**
	 * f0 -> "!"
	 * f1 -> Clause()
	 */
	public String visit(NotExpression n, SymbolTable symbolTable) throws Exception {
		// expected f1 type: boolean or BOOLEAN_LITERAL
		validateType(n.f1.accept(this, symbolTable), symbolTable, "boolean", "BOOLEAN_LITERAL", "type");
		return "boolean";
	}

}

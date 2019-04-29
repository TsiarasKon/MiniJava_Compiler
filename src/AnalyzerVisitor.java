import syntaxtree.*;
import visitor.GJDepthFirst;

import java.util.LinkedHashMap;

public class AnalyzerVisitor extends GJDepthFirst<String, SymbolTable>{

	private String currentClassName;
	private String currentMethodName;
	private String expressionType;

	private void validateType(String type, String validType, String exceptionMsg) throws SemanticException {
		if (!type.equals(validType)) {
			throw new SemanticException(exceptionMsg);
		}
	}

	private void validateType(String type, String validType1, String validType2, String exceptionMsg) throws SemanticException {
		if (!type.equals(validType1) && !type.equals(validType2)) {
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
		validateType(n.f0.accept(this, symbolTable), "boolean", "BOOLEAN_LITERAL", "type");
		// expected f2 type: int or INTEGER_LITERAL
		validateType(n.f2.accept(this, symbolTable), "boolean", "BOOLEAN_LITERAL", "type");
		return "boolean";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "<"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(CompareExpression n, SymbolTable symbolTable) throws Exception {
		// expected f0 type: int or INTEGER_LITERAL
		validateType(n.f0.accept(this, symbolTable), "int", "INTEGER_LITERAL", "type");
		// expected f2 type: int or INTEGER_LITERAL
		validateType(n.f2.accept(this, symbolTable), "int", "INTEGER_LITERAL", "type");
		return "boolean";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "+"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(PlusExpression n, SymbolTable symbolTable) throws Exception {
		// expected f0 type: int or INTEGER_LITERAL
		validateType(n.f0.accept(this, symbolTable), "int", "INTEGER_LITERAL", "type");
		// expected f2 type: int or INTEGER_LITERAL
		validateType(n.f2.accept(this, symbolTable), "int", "INTEGER_LITERAL", "type");
		return "int";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "-"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(MinusExpression n, SymbolTable symbolTable) throws Exception {
		// expected f0 type: int or INTEGER_LITERAL
		validateType(n.f0.accept(this, symbolTable), "int", "INTEGER_LITERAL", "type");
		// expected f2 type: int or INTEGER_LITERAL
		validateType(n.f2.accept(this, symbolTable), "int", "INTEGER_LITERAL", "type");
		return "int";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "*"
	 * f2 -> PrimaryExpression()
	 */
	public String visit(TimesExpression n, SymbolTable symbolTable) throws Exception {
		// expected f0 type: int or INTEGER_LITERAL
		validateType(n.f0.accept(this, symbolTable), "int", "INTEGER_LITERAL", "type");
		// expected f2 type: int or INTEGER_LITERAL
		validateType(n.f2.accept(this, symbolTable), "int", "INTEGER_LITERAL", "type");
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
		validateType(n.f0.accept(this, symbolTable), "int[]", "type");
		// expected f2 type: int or INTEGER_LITERAL
		validateType(n.f2.accept(this, symbolTable), "int", "INTEGER_LITERAL", "type");
		return "int";
	}

	/**
	 * f0 -> PrimaryExpression()
	 * f1 -> "."
	 * f2 -> "length"
	 */
	public String visit(ArrayLength n, SymbolTable symbolTable) throws Exception {
		// expected f0 type: int[]
		validateType(n.f0.accept(this, symbolTable), "int[]", "type");
		return "int";
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
		validateType(n.f3.accept(this, symbolTable), "int", "INTEGER_LITERAL", "type");
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
		validateType(n.f1.accept(this, symbolTable), "boolean", "BOOLEAN_LITERAL", "type");
		return "boolean";
	}

}

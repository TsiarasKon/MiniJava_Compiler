import syntaxtree.*;
import visitor.GJDepthFirst;

public class SemanticVisitor extends GJDepthFirst<String, String>{

	/**
	 * f0 -> Type()
	 * f1 -> Identifier()
	 * f2 -> ";"
	 */
	public String visit(VarDeclaration n, String argu) {
		String _ret=null;
		String typeStr = n.f0.accept(this, argu);
		String idStr = n.f1.accept(this, argu);
		System.out.println(typeStr + " " + idStr);
		n.f2.accept(this, argu);
		return _ret;
	}

	/**
	 * f0 -> "int"
	 */
	public String visit(IntegerType n, String argu) {
		return "int";
	}

	/**
	 * f0 -> <IDENTIFIER>
	 */
	public String visit(Identifier n, String argu) {
		return n.f0.toString();
	}

}

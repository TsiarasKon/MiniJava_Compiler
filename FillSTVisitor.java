import syntaxtree.*;
import visitor.GJDepthFirst;

public class FillSTVisitor extends GJDepthFirst<String, MainST>{

	/**
	 * f0 -> Type()
	 * f1 -> Identifier()
	 * f2 -> ";"
	 */
	public String visit(VarDeclaration n, MainST argu) {
		String _ret=null;
		n.f0.accept(this, argu);
		n.f1.accept(this, argu);
		n.f2.accept(this, argu);
		return _ret;
	}

	/**
	 * f0 -> "int"
	 */
	public String visit(IntegerType n, MainST argu) {
        return n.f0.toString();
	}

	/**
	 * f0 -> <IDENTIFIER>
	 */
	public String visit(Identifier n, MainST argu) {
		return n.f0.toString();
	}

}

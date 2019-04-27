import syntaxtree.*;
import visitor.*;
import java.io.*;

class Main {
    public static void main (String [] args){
	if(args.length != 1){
	    System.err.println("Usage: java Driver <inputFile>");
	    System.exit(1);
	}
	FileInputStream fis = null;
	try {
	    fis = new FileInputStream(args[0]);
	    MiniJavaParser parser = new MiniJavaParser(fis);
	    System.err.println("Program parsed successfully.");
		FillSTVisitor fSTVisitor = new FillSTVisitor();
	    Goal root = parser.Goal();
		SymbolTable symbolTable = new SymbolTable();
	    root.accept(fSTVisitor, symbolTable);
		System.err.println("Completed semantic check successfully.");
	} catch (ParseException ex) {
	    System.out.println(ex.getMessage());
	} catch (FileNotFoundException ex) {
	    System.err.println(ex.getMessage());
	} catch (SemanticException ignore) {
		// TODO?
	} catch (Exception ex) {		// shouldn't get here
		System.err.println("Unexpected error while performing semantic analysis; dumping stack trace:");
		ex.printStackTrace();
	}
	finally{
	    try{
		if(fis != null) fis.close();
	    }
	    catch(IOException ex){
		System.err.println(ex.getMessage());
	    }
	}
    }
}

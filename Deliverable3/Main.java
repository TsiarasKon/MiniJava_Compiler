import syntaxtree.Goal;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

class Main {

	public static void main (String [] args) {
		if (args.length < 1) {
			System.err.println("Usage: java <MainClassName> <file1> [file2] ... [fileN]");
			System.exit(1);
		}
		FileInputStream fis = null;
		for (int i = 0; i < args.length; i++) {
			System.out.println("\nFile #" + (i+1) + " - '" + args[i] + "':");
			try{
				fis = new FileInputStream(args[i]);
				MiniJavaParser parser = new MiniJavaParser(fis);
				Goal root = parser.Goal();
				System.out.println(" Parsing completed successfully.");
				SymbolTable symbolTable = new SymbolTable();
				FillSTVisitor fSTVisitor = new FillSTVisitor();
				root.accept(fSTVisitor, symbolTable);
				symbolTable.validateST();
				TypeCheckerVisitor typeCheckerVisitor = new TypeCheckerVisitor();
				root.accept(typeCheckerVisitor, symbolTable);
				System.out.println(" Semantic analysis completed successfully.");
				VTables vTables = new VTables();
				symbolTable.populateVTables(vTables);
				String llFileName = args[i].substring(0, args[i].length() - 5) + ".ll";
				LLVMGeneratorVisitor llvmGeneratorVisitor = new LLVMGeneratorVisitor(llFileName, symbolTable, vTables);
				root.accept(llvmGeneratorVisitor);
				System.out.println(" Generated LLVM file successfully at: '" + llFileName + "'");
			} catch (FileNotFoundException | ParseException | SemanticException ex) {
				System.err.println(ex.getMessage());
			} catch (Exception ex) {        // should never get here
				System.err.println(ex.getMessage());
				System.err.println(" Encountered unexpected error; dumping stack trace:");
				ex.printStackTrace();
			} finally {
				try {
					if (fis != null) fis.close();
				} catch (IOException ex) {
					System.err.println(ex.getMessage());
				}
			}
		}
	}
}

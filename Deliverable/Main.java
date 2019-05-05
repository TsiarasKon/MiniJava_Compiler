import syntaxtree.*;

import java.io.*;

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
				if (symbolTable.offsetsAvailable()) {
					System.out.println(" Class offsets:");
					symbolTable.printAllOffsets(" ");
				} else {
					System.out.println(" (Only Main Class was provided - there are no offsets to be printed)");
				}
				System.out.println();
			} catch (FileNotFoundException | ParseException | SemanticException ex) {
				System.err.println(ex.getMessage());
			} catch (Exception ex) {        // should never get here
				System.err.println(ex.getMessage());
				System.err.println(" Encountered unexpected error while performing semantic analysis; dumping stack trace:");
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

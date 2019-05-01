import syntaxtree.*;
import visitor.*;
import java.io.*;

class Main {
    public static void main (String [] args) {
		if (args.length < 1) {
			System.err.println("Usage: java <MainClassName> <file1> [file2] ... [fileN]");
			System.exit(1);
		}
		FileInputStream fis = null;
		for (int i = 0; i < args.length; i++) {
			System.out.println("\nFile #" + i + " - '" + args[i] + "':");
			try{
				fis = new FileInputStream(args[i]);
				MiniJavaParser parser = new MiniJavaParser(fis);
				Goal root = parser.Goal();
				System.out.println(" Parsing completed successfully.");
				SymbolTable symbolTable = new SymbolTable();
				FillSTVisitor fSTVisitor = new FillSTVisitor();
				root.accept(fSTVisitor, symbolTable);
				symbolTable.validateST();
				AnalyzerVisitor analyzerVisitor = new AnalyzerVisitor();
				root.accept(analyzerVisitor, symbolTable);
				System.out.println(" Semantic analysis completed successfully.");
				System.out.println(" Offsets:");
				symbolTable.printAllOffsets("  ");
			} catch (FileNotFoundException | ParseException | SemanticException ex) {
				System.err.println(ex.getMessage());
			} catch (Exception ex) {        // should never get here
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

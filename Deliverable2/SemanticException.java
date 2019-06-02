public class SemanticException extends Exception {

    public SemanticException(String errorMessage, int lineNumber, int columnNumber) {
        super(" Semantic error: [" + lineNumber + ":" + columnNumber + "] " + errorMessage);
    }

    public SemanticException(String errorMessage) {
        super(" Semantic error: " + errorMessage);
    }

}
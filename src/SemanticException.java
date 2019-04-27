public class SemanticException extends Exception {

    public SemanticException(String errorMessage) {
        super("Semantic error encountered: " + errorMessage);
    }

}
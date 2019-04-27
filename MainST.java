import java.util.LinkedHashMap;
import java.util.Map;

public class MainST {

    public Map<String, String> variableTypes;
    public Map<String, ClassST> classes;

    MainST() {
        variableTypes = new LinkedHashMap<>();
        classes = new LinkedHashMap<>();
    }

    public void printMainVars() {
        System.out.println("Main variables:");
        for (Map.Entry<String, String> entry : variableTypes.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
            System.out.println("  " + value + " - " + key);
        }
    }


    public class ClassST {
        public String className;
        public String extendsClassName;
        public Map<String, String> fieldTypes;
        public Map<String, MethodST> methods;

        ClassST(String _className, String _extendsClassName) {
            className = _className;
            extendsClassName = _extendsClassName;
            fieldTypes = new LinkedHashMap<>();
            methods = new LinkedHashMap<>();
        }

        ClassST(String _className) {
            this(_className, null);
        }
    }

    public class MethodST {
        public String methodName;
        public String returnType;
        public LinkedHashMap<String, String> argTypes;
        public Map<String, String> variableTypes;

        MethodST(String _methodName, String _returnType) {
            methodName = _methodName;
            returnType = _returnType;
            argTypes = new LinkedHashMap<>();
            variableTypes = new LinkedHashMap<>();
        }
    }

}
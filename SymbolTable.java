import java.util.LinkedHashMap;
import java.util.Map;

public class SymbolTable {

    public Map<String, ClassST> classes;

    SymbolTable() {
        classes = new LinkedHashMap<>();
    }

    public void addClass(String className, String extendsClassName) {
        if (classes.containsKey(className)) {
//            throw new Exception();      // TODO
        }
        ClassST classST = new ClassST(className, extendsClassName);
        classes.put(className, classST);
    }

    public void addClass(String className) {
        addClass(className, null);
    }

    public void addClassField(String className, String varName, String varType) {
        classes.get(className).addField(varName, varType);
    }

    public void addClassMethod(String className, String methodName, String returnType) {
        classes.get(className).addMethod(methodName, returnType);
    }

    public void addClassMethodParam(String className, String methodName, String paramType, String paramName) {
        classes.get(className).addMethodParam(methodName, paramType, paramName);
    }

    public void addMethodVar(String className, String methodName, String varType, String varName) {
        classes.get(className).addMethodVar(methodName, varType, varName);
    }

    public void printMainVars() {
        Map<String, String> mainVars = classes.get("HelloWorld").methods.get("main").variables;
        System.out.println("Main variables:");
        for (Map.Entry<String, String> entry : mainVars.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
            System.out.println("  " + value + " - " + key);
        }
    }


    private class ClassST {
        public String className;
        public String extendsClassName;
        public Map<String, String> fields;
        public Map<String, MethodST> methods;

        ClassST(String _className, String _extendsClassName) {
            className = _className;
            extendsClassName = _extendsClassName;
            fields = new LinkedHashMap<>();
            methods = new LinkedHashMap<>();
        }

//        ClassST(String _className) {
//            this(_className, null);
//        }

        void addField(String varName, String varType) {
            if (fields.containsKey(varName)) {
                // TODO
            }
            fields.put(varName, varType);
        }

        void addMethod(String methodName, String returnType) {
            if (methods.containsKey(methodName)) {
                // TODO
            }
            MethodST methodST = new MethodST(methodName, returnType);
            methods.put(methodName, methodST);
        }

        void addMethodParam(String methodName, String paramType, String paramName) {
            methods.get(methodName).addParam(paramType, paramName);
        }

        void addMethodVar(String methodName, String varType, String varName) {
            methods.get(methodName).addVar(varType, varName);
        }

    }

    private class MethodST {
        public String methodName;
        public String returnType;
        public LinkedHashMap<String, String> parameters;
        public Map<String, String> variables;

        MethodST(String _methodName, String _returnType) {
            methodName = _methodName;
            returnType = _returnType;
            parameters = new LinkedHashMap<>();
            variables = new LinkedHashMap<>();
        }

        void addParam(String paramType, String paramName) {
            if (parameters.containsKey(paramName)) {
                // TODO
            }
            parameters.put(paramName, paramType);
        }

        void addVar(String varType, String varName) {
            if (variables.containsKey(varName)) {
                // TODO
            }
            variables.put(varName, varType);
        }
        
    }

}
import java.util.LinkedHashMap;
import java.util.Map;

public class SymbolTable {

    private Map<String, ClassST> classes;

    SymbolTable() {
        classes = new LinkedHashMap<>();
    }

    public void addClass(String className, String extendsClassName) throws SemanticException {
        if (classes.containsKey(className)) {
            throw new SemanticException("");
        }
        ClassST classST = new ClassST(className, extendsClassName);
        classes.put(className, classST);
    }

    public void addClass(String className) throws SemanticException {
        addClass(className, null);
    }

    public void addClassField(String className, String varType, String varName) throws SemanticException {
        classes.get(className).addField(varType, varName);
    }

    public void addClassMethod(String className, String methodType, String methodName) throws SemanticException {
        classes.get(className).addMethod(methodType, methodName);
    }

    public void addClassMethodParam(String className, String methodName, String paramType, String paramName) throws SemanticException {
        classes.get(className).addMethodParam(methodName, paramType, paramName);
    }

    public void addMethodVar(String className, String methodName, String varType, String varName) throws SemanticException {
        classes.get(className).addMethodVar(methodName, varType, varName);
    }

    public void printAllOffsets(String lPadding) {
        boolean mainFlag = true;    // used only to ignore main
        for (Map.Entry<String, ClassST> entry : classes.entrySet()) {
            if (mainFlag) {
                mainFlag = false;
                continue;
            }
            entry.getValue().printClassOffsets(lPadding);
        }
    }


    private class ClassST {
        private String className;
        private String extendsClassName;
        private Map<String, String> fields;
        private Map<String, MethodST> methods;

        ClassST(String _className, String _extendsClassName) {
            className = _className;
            extendsClassName = _extendsClassName;
            fields = new LinkedHashMap<>();
            methods = new LinkedHashMap<>();
        }

        void addField(String varType, String varName) throws SemanticException {
            if (fields.containsKey(varName)) {
                throw new SemanticException("");
            }
            fields.put(varName, varType);
        }

        void addMethod(String methodType, String methodName) throws SemanticException {
            if (methods.containsKey(methodName)) {
                throw new SemanticException("");
            }
            MethodST methodST = new MethodST(methodType, methodName);
            methods.put(methodName, methodST);
        }

        void addMethodParam(String methodName, String paramType, String paramName) throws SemanticException {
            methods.get(methodName).addParam(paramType, paramName);
        }

        void addMethodVar(String methodName, String varType, String varName) throws SemanticException {
            methods.get(methodName).addVar(varType, varName);
        }

        public void printClassOffsets(String lPadding) {
            for (Map.Entry<String, String> entry : fields.entrySet()) {
                System.out.println(lPadding + className + "." + entry.getKey());
                // TODO: offset
            }
            for (Map.Entry<String, MethodST> entry : methods.entrySet()) {
                System.out.println(lPadding + className + "." + entry.getKey());
                // TODO: offset
            }
        }

    }

    private class MethodST {
        private String methodName;
        private String returnType;
        private LinkedHashMap<String, String> parameters;
        private Map<String, String> variables;

        MethodST(String _returnType, String _methodName) {
            methodName = _methodName;
            returnType = _returnType;
            parameters = new LinkedHashMap<>();
            variables = new LinkedHashMap<>();
        }

        void addParam(String paramType, String paramName) throws SemanticException {
            if (parameters.containsKey(paramName)) {
                throw new SemanticException("");
            }
            parameters.put(paramName, paramType);
        }

        void addVar(String varType, String varName) throws SemanticException {
            if (parameters.containsKey(varName) || variables.containsKey(varName)) {
                throw new SemanticException("");
            }
            variables.put(varName, varType);
        }
        
    }

}
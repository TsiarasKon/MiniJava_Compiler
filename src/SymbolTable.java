import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

public class SymbolTable {

    private Map<String, ClassST> classes;

    SymbolTable() {
        classes = new LinkedHashMap<>();
    }

    public void addClass(String className, String parentClassName) throws SemanticException {
        if (classes.containsKey(className)) {
            throw new SemanticException("exists");
        }
        if (!classes.containsKey(parentClassName)) {
            throw new SemanticException("extends");
        }
        ClassST classST = new ClassST(className, classes.get(parentClassName));
        classes.put(className, classST);
    }

    public void addClass(String className) throws SemanticException {
        if (classes.containsKey(className)) {
            throw new SemanticException("");
        }
        ClassST classST = new ClassST(className, null);
        classes.put(className, classST);
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

    private boolean isTypeValid(String type) {
        return (type.equals("int") || type.equals("boolean") || type.equals("int[]") || classes.containsKey(type));
    }

    // Performs type checking and catches invalid method parameters in declarations
    public void validateST() throws SemanticException {
        for (Map.Entry<String, ClassST> entry : classes.entrySet()) {
            entry.getValue().validateClassST();
        }
    }

    /* Offset calculating functions: */

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
        private ClassST parentClass;
        private Map<String, String> fields;
        private Map<String, MethodST> methods;
        private int fieldOffset;
        private int methodOffset;

        ClassST(String _className, ClassST _parentClass) {
            className = _className;
            parentClass = _parentClass;
            fields = new LinkedHashMap<>();
            methods = new LinkedHashMap<>();
            fieldOffset = methodOffset = -1;
        }

        ClassST getParentClass() {
            return parentClass;
        }

        int getFieldOffset() {
            return fieldOffset;
        }

        int getMethodOffset() {
            return methodOffset;
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

        void validateClassST() throws SemanticException {
            for (Map.Entry<String, String> entry : fields.entrySet()) {
                String fieldType = entry.getValue();
                if (!isTypeValid(fieldType)) {
                    throw new SemanticException("'" + className + "." + entry.getKey() + "' has type '" + fieldType +
                            "' which is never defined in the file");
                }
            }
            for (Map.Entry<String, MethodST> entry : methods.entrySet()) {
                entry.getValue().validateMethodST();
            }
        }

        /* Offset calculating functions: */

        private void calculateStartingFieldOffset() {
            if (parentClass == null) {
                fieldOffset = 0;
            } else {
                fieldOffset = parentClass.getFieldOffset();
            }
        }

        private void calculateStartingMethodOffset() {
            if (parentClass == null) {
                methodOffset = 0;
            } else {
                methodOffset = parentClass.getMethodOffset();
            }
        }

        private MethodST getOverriddenMethod(String methodName) {
            ClassST currParentClass = parentClass;
            while (currParentClass != null) {
                if (parentClass.methods.containsKey(methodName)) {
                    return parentClass.methods.get(methodName);
                }
                currParentClass = currParentClass.getParentClass();
            }
            return null;
        }

        void printClassOffsets(String lPadding) {
            calculateStartingFieldOffset();
            for (Map.Entry<String, String> entry : fields.entrySet()) {
                System.out.println(lPadding + className + "." + entry.getKey() + " : " + fieldOffset);
                String fieldType = entry.getValue();
                switch (fieldType) {
                    case "int":
                        fieldOffset += 4;
                        break;
                    case "boolean":
                        fieldOffset += 1;
                        break;
                    default:        // "int[]" and class pointers
                        fieldOffset += 8;
                }
            }
            calculateStartingMethodOffset();
            for (Map.Entry<String, MethodST> entry : methods.entrySet()) {
                String methodName = entry.getKey();
                if (getOverriddenMethod(methodName) == null) {
                    System.out.println(lPadding + className + "." + methodName + " : " + methodOffset);
                    methodOffset += 8;
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

            void validateMethodST() throws SemanticException {
                if (!methodName.equals("main")) {
                    if (!isTypeValid(returnType)) {
                        throw new SemanticException("'" + className + "." + methodName + "()' has return type '" +
                                returnType + "' which is never defined in the file");
                    }
                    // check if function parameters are same when the method is overridden:
                    MethodST parentMethod = getOverriddenMethod(methodName);
                    if (parentMethod != null) {
                        Iterator currIt = parameters.entrySet().iterator();
                        Iterator parentIt = parentMethod.parameters.entrySet().iterator();
                        while (currIt.hasNext() && parentIt.hasNext()) {
                            Map.Entry currEntry = (Map.Entry) currIt.next();
                            Map.Entry parentEntry = (Map.Entry) parentIt.next();
                            String currParamType = (String) currEntry.getValue();
                            String parentParamType = (String) parentEntry.getValue();
                            if (!currParamType.equals(parentParamType)) {
                                throw new SemanticException("parameter '" + currEntry.getKey() + "' of '" + className +
                                        "." + methodName + "()' has type '" + currParamType + "' while the same parameter " +
                                        "from overridden method has type '" + parentParamType + "'");
                            }
                        }
                        if (currIt.hasNext()) {
                            throw new SemanticException("'" + className + "." + methodName + "()' overrides a " +
                                    "method that has the same name but lesser number of arguments");
                        }
                        if (parentIt.hasNext()) {
                            throw new SemanticException("'" + className + "." + methodName + "()' overrides a " +
                                    "method that has the same name but greater number of arguments");
                        }
                    }
                }
                for (Map.Entry<String, String> entry : variables.entrySet()) {
                    String varType = entry.getValue();
                    if (!isTypeValid(varType)) {
                        throw new SemanticException("variable '" + entry.getKey() + "' of class '" + className + "." +
                                methodName + "()' has type '" + varType + "' which is never defined in the file");
                    }
                }
            }

        }

    }

}

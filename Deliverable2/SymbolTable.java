import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class SymbolTable {

    private Map<String, ClassST> classes;

    SymbolTable() {
        classes = new LinkedHashMap<>();
    }

    public void addClass(String className, String parentClassName, int lineNumber, int columnNumber) throws SemanticException {
        if (classes.containsKey(className)) {
            throw new SemanticException("class '" + className + "' is already defined", lineNumber, columnNumber);
        }
        if (!classes.containsKey(parentClassName)) {
            throw new SemanticException("class '" + className + "' extends '" + parentClassName + "' which has not been defined", lineNumber, columnNumber);
        }
        ClassST classST = new ClassST(className, classes.get(parentClassName));
        classes.put(className, classST);
    }

    public void addClass(String className, int lineNumber, int columnNumber) throws SemanticException {
        if (classes.containsKey(className)) {
            throw new SemanticException("class '" + className + "' is already defined", lineNumber, columnNumber);
        }
        ClassST classST = new ClassST(className, null);
        classes.put(className, classST);
    }

    public boolean addClassField(String className, String varType, String varName) {
        return classes.get(className).addField(varType, varName);
    }

    public boolean addClassMethod(String className, String methodType, String methodName) {
        return classes.get(className).addMethod(methodType, methodName);
    }

    public boolean addClassMethodParam(String className, String methodName, String paramType, String paramName) {
        return classes.get(className).addMethodParam(methodName, paramType, paramName);
    }

    public boolean addMethodVar(String className, String methodName, String varType, String varName) {
        return classes.get(className).addMethodVar(methodName, varType, varName);
    }

    public boolean classExists(String className) {
        return classes.containsKey(className);
    }

    public String getClassFieldType(String className, String varName) {
        return (classes.containsKey(className)) ? classes.get(className).getFieldType(varName) : null;
    }

    public String getClassMethodReturnType(String className, String methodName) {
        return (classes.containsKey(className)) ? classes.get(className).getMethodReturnType(methodName) : null;
    }

    public String getClassMethodVarType(String className, String methodName, String varName) {
        return (classes.containsKey(className)) ? classes.get(className).getMethodVarType(methodName, varName) : null;
    }

    public void validateClassMethodParameters(String className, String methodName, List<String> methodParameters, int lineNumber, int columnNumber) throws SemanticException {
        classes.get(className).validateMethodParameters(methodName, methodParameters, lineNumber, columnNumber);
    }

    public boolean isClassOrSubclass(String parentClassName, String inputClassName) {
        return (classes.containsKey(parentClassName)) ? classes.get(parentClassName).isSelfOrSubclass(inputClassName) : false;
    }

    private boolean isTypeValid(String type) {
        return (type.equals("int") || type.equals("boolean") || type.equals("int[]") || classes.containsKey(type));
    }

    /* Performs type checking and catches invalid method parameters in declarations
       Errors caught here will not have associated [line:col] printed */
    public void validateST() throws SemanticException {
        for (Map.Entry<String, ClassST> entry : classes.entrySet()) {
            entry.getValue().validateClassST();
        }
    }

    /* Offset-related functions: */

    public boolean offsetsAvailable() {
        return classes.size() > 1;
    }

    public void printAllOffsets(String lPadding) {
        boolean mainFlag = true;    // used only to ignore main
        for (Map.Entry<String, ClassST> entry : classes.entrySet()) {
            if (mainFlag) {
                mainFlag = false;
                continue;
            }
            ClassST currClass = entry.getValue();
            System.out.println('\n' + lPadding + "-----------Class " + currClass.className + "-----------");
            currClass.printClassOffsets(lPadding);
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
            fieldOffset = methodOffset = 0;
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

        boolean addField(String varType, String varName) {
            if (fields.containsKey(varName)) {
                return false;
            }
            fields.put(varName, varType);
            return true;
        }

        boolean addMethod(String methodType, String methodName) {
            if (methods.containsKey(methodName)) {
                return false;
            }
            MethodST methodST = new MethodST(methodType, methodName);
            methods.put(methodName, methodST);
            return true;
        }

        boolean addMethodParam(String methodName, String paramType, String paramName) {
            return methods.get(methodName).addParam(paramType, paramName);
        }

        boolean addMethodVar(String methodName, String varType, String varName) {
            return methods.get(methodName).addVar(varType, varName);
        }

        boolean isSelfOrSubclass(String inputClassName) {
            ClassST currClass = this;
            while (currClass != null) {
                if (currClass.className.equals(inputClassName)) {
                    return true;
                }
                currClass = currClass.getParentClass();
            }
            return false;
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

        String getFieldType(String varName) {
            ClassST currClass = this;
            while (currClass != null) {
                if (currClass.fields.containsKey(varName)) {
                    return currClass.fields.get(varName);
                }
                // field might exist in parent class
                currClass = currClass.getParentClass();
            }
            return null;
        }

        String getMethodReturnType(String methodName) {
            ClassST currClass = this;
            while (currClass != null) {
                if (currClass.methods.containsKey(methodName)) {
                    return currClass.methods.get(methodName).returnType;
                }
                currClass = currClass.getParentClass();
            }
            return null;
        }

        String getMethodVarType(String methodName, String varName) {
            String varTypeFromParentFields = null;
            ClassST currClass = this;
            while (currClass != null) {
                if (currClass.methods.containsKey(methodName)) {
                    String varTypeFromMethod = currClass.methods.get(methodName).getVarType(varName);
                    return (varTypeFromMethod != null) ? varTypeFromMethod : getFieldType(varName);
                }
                currClass = currClass.getParentClass();
            }
            return null;
        }

        void validateMethodParameters(String methodName, List<String> methodParameters, int lineNumber, int columnNumber) throws SemanticException {
            ClassST currClass = this;
            while (currClass != null) {
                if (currClass.methods.containsKey(methodName)) {
                    currClass.methods.get(methodName).validateParameters(methodParameters, lineNumber, columnNumber);
                    return;
                }
                currClass = currClass.getParentClass();
            }
            // should never get here; method will always exist or would have been caught by FillSTVisitor
            System.err.println("(!) Method '" + methodName + "' was not found during validation!");
        }

        /* Offset-related functions: */

        private void calculateStartingFieldOffset() {
            if (parentClass != null) {
                fieldOffset = parentClass.getFieldOffset();
            }
        }

        private void calculateStartingMethodOffset() {
            if (parentClass != null) {
                methodOffset = parentClass.getMethodOffset();
            }
        }

        private MethodST getOverriddenMethod(String methodName) {
            ClassST currParentClass = parentClass;
            while (currParentClass != null) {
                if (currParentClass.methods.containsKey(methodName)) {
                    return currParentClass.methods.get(methodName);
                }
                currParentClass = currParentClass.getParentClass();
            }
            return null;
        }

        void printClassOffsets(String lPadding) {
            calculateStartingFieldOffset();
            System.out.println(lPadding + "--Variables---");
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
            System.out.println(lPadding + "---Methods---");
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

            boolean addParam(String paramType, String paramName) {
                if (parameters.containsKey(paramName)) {
                    return false;
                }
                parameters.put(paramName, paramType);
                return true;
            }

            boolean addVar(String varType, String varName) {
                if (parameters.containsKey(varName) || variables.containsKey(varName)) {
                    return false;
                }
                variables.put(varName, varType);
                return true;
            }

            String getVarType(String varName) {
                return variables.getOrDefault(varName, parameters.getOrDefault(varName, fields.getOrDefault(varName, null)));
            }

            void validateParameters(List<String> methodParameters, int lineNumber, int columnNumber) throws SemanticException {
                Iterator currIt = parameters.entrySet().iterator();
                for (String currParam : methodParameters) {
                    if (!currIt.hasNext()) {
                        throw new SemanticException("tried to call '" + className + "." + methodName + "()' with more parameters than it has been defined", lineNumber, columnNumber);
                    }
                    Map.Entry currEntry = (Map.Entry) currIt.next();
                    String currActualParam = (String) currEntry.getValue();
                    if (!currParam.equals(currActualParam) && !isClassOrSubclass(currParam, currActualParam)) {
                        throw new SemanticException("tried to call '" + className + "." + methodName + "()' with a " +
                                "parameter of type '" + currParam + "' where type '" + currActualParam + "' was expected", lineNumber, columnNumber);
                    }
                }
                if (currIt.hasNext()) {
                    throw new SemanticException("tried to call '" + className + "." + methodName + "()' with fewer parameters than it has been defined", lineNumber, columnNumber);
                }
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
                                    "method of the same name but with lesser number of arguments");
                        }
                        if (parentIt.hasNext()) {
                            throw new SemanticException("'" + className + "." + methodName + "()' overrides a " +
                                    "method of the same name but with greater number of arguments");
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

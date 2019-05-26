import java.util.LinkedHashMap;
import java.util.Map;

public class VTables {

    public LinkedHashMap<String, ClassVTable> classesVTables;

    VTables() {
        classesVTables = new LinkedHashMap<>();
    }

    public static class ClassVTable {
        boolean isMainClass;
        LinkedHashMap<String, Integer> fieldsTable;
        LinkedHashMap<String, Integer> methodsTable;

        ClassVTable() {
            fieldsTable = new LinkedHashMap<>();
            methodsTable = new LinkedHashMap<>();
        }

    }

    public void printVTables(String lPadding) {
        for (Map.Entry<String, ClassVTable> entry : classesVTables.entrySet()) {
            String className = entry.getKey();
            ClassVTable currClassVTable = entry.getValue();
//            if (mainFlag) {
//                mainFlag = false;
//                continue;
//            }
            System.out.println('\n' + lPadding + "-----------Class " + className + "-----------");
            System.out.println(lPadding + "--Variables---");
            for (Map.Entry<String, Integer> fieldEntry : currClassVTable.fieldsTable.entrySet()) {
                System.out.println(lPadding + className + "." + fieldEntry.getKey() + " : " + fieldEntry.getValue());
            }
            System.out.println(lPadding + "---Methods---");
            for (Map.Entry<String, Integer> methodEntry : currClassVTable.methodsTable.entrySet()) {
                System.out.println(lPadding + className + "." + methodEntry.getKey() + " : " + methodEntry.getValue());
            }
        }
    }

}

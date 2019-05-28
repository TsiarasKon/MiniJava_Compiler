import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

public class VTables {

    public LinkedHashMap<String, ClassVTable> classesVTables;

    public VTables() {
        classesVTables = new LinkedHashMap<>();
    }

    public static class ClassVTable {
        public boolean isMainClass;
        public LinkedHashMap<String, Integer> fieldsTable;
        public LinkedHashMap<String, Integer> methodsTable;
        public LinkedHashMap<String, String> methodsFromTable;

        public ClassVTable() {
            fieldsTable = new LinkedHashMap<>();
            methodsTable = new LinkedHashMap<>();
            methodsFromTable = new LinkedHashMap<>();
        }

    }

    public void printVTables(String lPadding) {
        for (Map.Entry<String, ClassVTable> entry : classesVTables.entrySet()) {
            String className = entry.getKey();
            ClassVTable currClassVTable = entry.getValue();
            if (currClassVTable.isMainClass) {
                continue;
            }
            System.out.println('\n' + lPadding + "-----------Class " + className + "-----------");
            System.out.println(lPadding + "--Variables---");
            for (Map.Entry<String, Integer> fieldEntry : currClassVTable.fieldsTable.entrySet()) {
                System.out.println(lPadding + className + "." + fieldEntry.getKey() + " : " + fieldEntry.getValue());
            }
            Iterator currIt = currClassVTable.methodsFromTable.entrySet().iterator();
            System.out.println(lPadding + "---Methods---");
            for (Map.Entry<String, Integer> methodEntry : currClassVTable.methodsTable.entrySet()) {
                System.out.println(lPadding + ((Map.Entry) currIt.next()).getValue() + "." + methodEntry.getKey() + " : " + methodEntry.getValue());
            }
        }
    }

}

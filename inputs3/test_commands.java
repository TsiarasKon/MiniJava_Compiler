class Test{
    public static void main(String[] a){
        System.out.println(new Mine().myPrintInt());
    }
}

class Mine {
    public int myPrintInt() {
        int x;
        x = 42;
        return x;
    }

    public boolean myPrintBool() {
        boolean b;
        b = true;
        return b && false;
    }
}

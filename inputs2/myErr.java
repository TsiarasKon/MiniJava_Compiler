class HelloWorld {
    public static void main(String[] args) {
        boolean x;
        boolean y;
        x = y;
        while (x) {}
    }
}

class A {
    boolean x;
    int[] y;

    public int test(int x) {return 5;}
}

class B extends A {
    A a;
    B b;

    public B rett() {
//        erg = 4;
        return a;
    }
    public int test(int y) {return (3 + 7);}
}
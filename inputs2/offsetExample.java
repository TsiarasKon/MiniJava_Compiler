class Main {
    public static void main(String[] a) {System.out.println(new A().foo());}
}

class A {
    int i;
    boolean flag;
    int j;
    public int foo() { x=5; return x;}
    public boolean fa() { x=true; return x; }
}

class B extends A {
    A type;
    int k;
    public int foo() { return k; }
    public boolean bla() { x=true; return x; }
}

class C extends B {
    boolean k;
    A next;
}
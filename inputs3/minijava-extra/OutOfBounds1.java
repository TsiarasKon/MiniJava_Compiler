class OutOfBounds1 {
	public static void main(String[] a){
		System.out.println(new A().run());
	}
}

class A {
	public int run() {
		int[] a;
		int x;
		int y;
		a = new int[20];
		y = 1 - 3;
		System.out.println(a[0]);
		System.out.println(a[19]);
		x = 12345;
		return a[x];
	}
}

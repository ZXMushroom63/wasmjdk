public class Main {
    public static void main(String[] args) {
        System.out.println("Running fib(i=100)");

        int iterations = 100;
        long _n = 0;
        long n = 1;
        for (int i = 0; i < iterations; i++) {
            long tmp = n;
            n = n + _n;
            _n = tmp;
        }

        System.out.println("Result: " + n);
    }
}
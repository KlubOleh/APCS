package com.example.hello;

public final class Main {
    private Main() {
    }

    public static void main(String[] args) {
        System.out.println("Hello, World!");
        System.out.println("2 + 3 = " + MathUtils.add(2, 3));
    }
}

package com.example.hello;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

class CalculatorTest {

    @Test
    @DisplayName("BasicAddition")
    void BasicAddition() {
        assertEquals(5, Calculator.add(2, 3));
    }
}

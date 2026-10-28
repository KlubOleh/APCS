package com.example.hello;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class BasicAdditionTest {
    @Test
    @DisplayName("BasicAddition")
    void addsTwoNumbers() {
        assertEquals(5, MathUtils.add(2, 3));
    }
}

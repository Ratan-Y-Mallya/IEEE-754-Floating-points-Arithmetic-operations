# IEEE 754 Arithmetic Operations (Adder, Subtractor, Multiplier, Divider)

This repository implements IEEE 754 single-precision (32-bit) floating-point arithmetic operations, including addition, subtraction, multiplication, and division. The operations are designed to handle the IEEE 754 format, including normalization, rounding, and special cases like infinity and NaN.

## Table of Contents
- [Introduction](#introduction)
- [IEEE 754 Format](#ieee-754-format)
- [Arithmetic Operations](#arithmetic-operations)
- [Addition/Subtraction](#additionsubtraction)
- [Multiplication](#multiplication)
- [Division](#division)
- [How to Run](#how-to-run)
- [Reference Videos](#reference-videos)
- [Example Testbench](#example-testbench)
- [Results](#results)

---

## Introduction

IEEE 754 is the standard for floating-point arithmetic used in computer systems. This implementation focuses on single-precision (32-bit) floating-point numbers, supporting the following operations:
- Addition
- Subtraction
- Multiplication
- Division

---

## IEEE 754 Format

An IEEE 754 single-precision floating-point number consists of:

| **Field**       | **Bits** | **Description**                        |
|------------------|----------|----------------------------------------|
| Sign Bit (S)     | 1        | 0 for positive, 1 for negative         |
| Exponent (E)     | 8        | Biased exponent (actual = E - 127)     |
| Mantissa (M)     | 23       | Fractional part with an implied 1      |

Value representation:

\[
(-1)^S \times 2^{(E - 127)} \times (1.M)
\]

---

## Arithmetic Operations

### Addition/Subtraction
- Align exponents by shifting the mantissas.
- Add or subtract mantissas based on the sign bits.
- Normalize the result and adjust the exponent.
- Handle overflow, underflow, and rounding.

### Multiplication
- Add the exponents and subtract the bias (127).
- Multiply the mantissas.
- Normalize the result and adjust the exponent.
- Handle special cases like infinity and NaN.

### Division
- Subtract the exponents and add the bias (127).
- Divide the mantissas.
- Normalize the result and adjust the exponent.
- Handle special cases like division by zero, infinity, and NaN.

---

## How to Run

1. Install a Verilog simulator like [Icarus Verilog](http://iverilog.icarus.com/).
2. Clone this repository:
   ```bash
   git clone <gh repo clone Ratan-Y-Mallya/IEEE-754-Floating-points-Arithmetic-operations>
   cd ieee754_arithmetic
   ```
3. Compile and run the testbench:
   ```bash
   iverilog -o ieee754_tb ieee754_tb.v ieee754_arithmetic.v
   vvp ieee754_tb
   ```
4. View the output in the terminal or use a waveform viewer like GTKWave for detailed simulation.

---

## Reference Videos

The following videos provide a detailed explanation of IEEE 754 arithmetic operations:

1. [IEEE 754 Floating Point Multiplication (YouTube)](https://www.youtube.com/watch?v=s6eELXJuLTc&list=PL9un8tgZngo9-Y5dmi8Fh4dJEMixX6mz7&index=38)
2. [IEEE 754 Floating Point Division (YouTube)](https://www.youtube.com/watch?v=rqz-CmNpWCM&list=PL9un8tgZngo9-Y5dmi8Fh4dJEMixX6mz7&index=39)

---

## Example Testbench

Here is an example testbench to verify the arithmetic operations:

```verilog
`timescale 1ns / 1ps

module ieee754_tb;

    // Inputs
    reg [31:0] a, b;
    reg [1:0] operation; // 00: Add, 01: Subtract, 10: Multiply, 11: Divide

    // Outputs
    wire [31:0] result;

    // Instantiate the Unit Under Test (UUT)
    ieee754_arithmetic uut (
        .a(a),
        .b(b),
        .operation(operation),
        .result(result)
    );

    initial begin
        $monitor("Time = %0t | A = %h | B = %h | Operation = %b | Result = %h", $time, a, b, operation, result);

        // Test Addition
        a = 32'h3F800000; // 1.0
        b = 32'h40000000; // 2.0
        operation = 2'b00;
        #10;

        // Test Subtraction
        a = 32'h40400000; // 3.0
        b = 32'h40000000; // 2.0
        operation = 2'b01;
        #10;

        // Test Multiplication
        a = 32'h3F800000; // 1.0
        b = 32'h40000000; // 2.0
        operation = 2'b10;
        #10;

        // Test Division
        a = 32'h40400000; // 3.0
        b = 32'h40000000; // 2.0
        operation = 2'b11;
        #10;

        $stop;
    end

endmodule
```

---

## Results

The expected outputs for the testbench are:

| **Operation**   | **Inputs (Hex)**            | **Expected Output (Hex)** | **Explanation**       |
|------------------|-----------------------------|---------------------------|-----------------------|
| Addition         | A = `3F800000`, B = `40000000` | Result = `40400000`       | \(1.0 + 2.0 = 3.0\)   |
| Subtraction      | A = `40400000`, B = `40000000` | Result = `3F800000`       | \(3.0 - 2.0 = 1.0\)   |
| Multiplication   | A = `3F800000`, B = `40000000` | Result = `40000000`       | \(1.0 \times 2.0 = 2.0\) |
| Division         | A = `40400000`, B = `40000000` | Result = `3F800000`       | \(3.0 \div 2.0 = 1.5\) |

---

Feel free to explore the code and modify the testbench to test additional cases, such as handling special numbers (NaN, infinity, zero, etc.).

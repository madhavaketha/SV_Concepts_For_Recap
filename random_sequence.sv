//What is a randsequence in SystemVerilog?
//In SystemVerilog, randsequence is a construct that allows you to generate randomized sequences of operations/events based on grammar-like rules (similar to context-free grammar in compilers).
//It is used to model constrained random stimulus sequences instead of just randomizing data.

//Think of it like:
//randomize() → generates random data values.
//randsequence → generates random action sequences.

//Syntax
randsequence (production_name)
    production_name : rule1 | rule2 | rule3;
    rule1           : statement;
    rule2           : statement;
endsequence

//A production is like a grammar rule.
//You can add weights (:=) to control probability.
//Rules can call other productions (like recursion).

//Example – Simple Packet Transaction Sequence
//Let’s say you want to generate a random sequence of packet operations (read, write, reset).

program test;

    randsequence (main)  
        main         : operation operation operation; // 3 operations in sequence
        operation    : read := 2  // weight 2
                     | write := 2 // weight 2
                     | reset := 1; // weight 1

        read         : { $display("Read operation"); };
        write        : { $display("Write operation"); };
        reset        : { $display("Reset operation"); };
    endsequence  

endprogram

//Explanation
//main production generates 3 operations.
//Each operation can be read, write, or reset.
//Weights → Read & Write have higher chance (2) vs Reset (1).
//Simulation output (example):

//output:
//Write operation
//Read operation
//Reset operation
//Each run will generate a different random sequence of operations.

//Real Use Case
//In verification, you often need randomized traffic sequences, not just random values.
//For example:
//Generating AXI transactions: write bursts, read bursts, idle cycles.
//Protocol testing where ordering matters (e.g., DMA → Interrupt → CPU access).
//Creating test sequences that mimic realistic use cases.
//With randsequence, you can express this easily using grammar-like rules.
//
//✅ Key Benefits:
//Models complex sequences of events easily.
//Allows weighted randomization (bias towards certain ops).
//Recursive grammar → can model nested/looped sequences.
//More readable & maintainable than writing big randomize() constraints with control flow.

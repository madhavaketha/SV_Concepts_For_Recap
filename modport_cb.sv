//Why modports are needed
//Without modports:
//1.Every signal in the interface is seen as inout by default.
//2.The direction of data flow becomes unclear.
//3.You might accidentally drive a signal from multiple places.
//
//With modports:
//1.You restrict access to only the signals a module should drive or read.
//2.You can give different components different views of the same interface.
//
//Example
// Define the interface
interface my_if (input logic clk);
    logic req;
    logic gnt;
    logic [7:0] data;

    // Define modports
    modport master (
        output req, data,   // Master drives these
        input  gnt,         // Master reads this
        input  clk
    );

    modport slave (
        input  req, data,   // Slave reads these
        output gnt,         // Slave drives this
        input  clk
    );
endinterface

// Master module
module master_logic(my_if.master intf);
    always_ff @(posedge intf.clk) begin
        intf.req  <= 1;
        intf.data <= 8'hA5;
    end
endmodule

// Slave module
module slave_logic(my_if.slave intf);
    always_ff @(posedge intf.clk) begin
        if (intf.req)
            intf.gnt <= 1;
    end
endmodule

// Top module to connect everything
module top;
    logic clk;
    my_if intf(clk); // Create interface instance

    master_logic u_master(intf);
    slave_logic  u_slave(intf);

    always #5 clk = ~clk; // Clock generator
endmodule

//Summary:
//Direction enforcement –
//The compiler knows master can only write req/data and read gnt,while slave can only read req/data and write gnt.
//
//Cleaner connectivity –
//One interface instance can be passed to multiple modules with different "views".
//
//Better code safety –
//Prevents accidental multiple drivers on the same signal.
//
//💡 In short:
//modport in SystemVerilog is like giving different access permissions to the same interface for different modules — a bit like giving one person "read-only" access and another "write" access to the same shared file.


// ======================================================= clocking blocks ====================================================//
//Purpose of a Clocking Block
//In SystemVerilog, clocking blocks are used to synchronize signals between the DUT and the testbench.
//They mainly solve race conditions that can happen between:
//
//The testbench driving or sampling signals, and
//The DUT sampling or driving signals.
//
//👉 Without a clocking block:
//You may accidentally drive a signal at the same time the DUT samples it, causing glitches.
//You may sample DUT signals before they are updated, leading to mismatches.
//
//👉 With a clocking block:
//You can specify input skew and output skew relative to the clock.
//This ensures testbench drives happen slightly before DUT samples, and testbench samples happen after DUT drives.
//
//Example Without Clocking Block (Race Condition)

interface intf(input logic clk);
    logic req;
    logic gnt;
endinterface

module tb;
    bit clk;
    always #5 clk = ~clk;

    intf i(clk);

    // Testbench directly drives/samples
    initial begin
        i.req = 1;        // Drive at posedge
        @(posedge clk);
        $display("Sample gnt = %0b", i.gnt);  // May sample too early
    end
endmodule
//⚠️ Problem:
//Here req might change at the same posedge the DUT is also sampling it.
//Similarly, gnt may be read before DUT updates it.
//This creates a race condition.
//
//Example With Clocking Block (Safe & Synchronized)

interface intf(input logic clk);
    logic req;
    logic gnt;

    // Define a clocking block
    clocking cb @(posedge clk);
        default input #1step output #1step;  
        // input  -> sampled 1 step AFTER posedge
        // output -> driven 1 step BEFORE posedge
        output req;
        input  gnt;
    endclocking
endinterface

module tb;
    bit clk = 0;
    always #5 clk = ~clk;

    intf i(clk);

    initial begin
        // Drive using clocking block
        i.cb.req <= 1;          // Driven 1 step before clock edge
        @(i.cb);                // Wait for clocking event
        $display("Sample gnt = %0b", i.cb.gnt);  // Sample after DUT updates
    end
endmodule

//Key Points in the Example
//clocking cb @(posedge clk);
//   → Defines clocking block sensitive to posedge clk.
//default input #1step output #1step;
//   → Defines skews:
//output #1step: testbench drives just before clock edge → DUT sees stable signal.
//input #1step: testbench samples just after DUT updates signals.
//Access signals via i.cb.req and i.cb.gnt.
//Testbench uses clocking block, avoiding race.
//
//Importance
//✅ Eliminates race conditions.
//✅ Provides clean synchronization.
//✅ Makes testbench behavior predictable.
//✅ Widely used in UVM testbenches for driving and sampling DUT signals.

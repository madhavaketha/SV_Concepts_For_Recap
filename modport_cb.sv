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

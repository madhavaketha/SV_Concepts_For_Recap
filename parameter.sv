3. Ways to Change Parameter Values in Verification
A. During Instantiation in Testbench Top
my_ip #(.DATA_WIDTH(64)) u_my_ip (
    .clk(clk),
    .rst_n(rst_n),
    .data_in(data_in)
);
	• Here you override the parameter when you instantiate the DUT.

B. Using defparam (old style, avoid if possible)
defparam tb_top.u_my_ip.DATA_WIDTH = 64;
	• Works, but not recommended — can cause maintainability issues.

C. Using Plusargs/Macros at Compile Time
	• In your code:
module my_ip #(parameter DATA_WIDTH = `DEF_DATA_WIDTH) (...);
	• In compile command:
vlog +define+DEF_DATA_WIDTH=64
	• This lets you vary parameter values without touching the source code.

D. Using UVM Config DB (for runtime configuration — only works for signals or class fields)
	• ⚠ Important: Config DB won’t change RTL parameters, only configurable class variables or registers inside UVM components.
	• If you want run-time configurability, you need to replace parameter with a register/config signal in the RTL.

4. If You Really Need Run-time Control
If a design parameter is something you need to change during simulation, then it should not be a parameter — it should be:
	• An input port, or
	• A control register in a memory-mapped interface, or
	• A value driven from testbench via interface.
Example:
module my_ip (
    input logic clk,
    input logic rst_n,
    input logic [7:0] cfg_data_width
);
	• This allows you to change it dynamically through UVM sequences.


Type	Changeable at Runtime?	How to Change?
Parameter	❌ No	Override at instantiation / compile
Signal	✅ Yes	Drive from testbench or force/release

✅ Answer to your question:
If it’s a signal, you can trace the hierarchical path and drive it from your testbench.
If it’s a parameter, you cannot directly change it during simulation — you must override it at instantiation or during compile/elaboration. If you want it to be runtime configurable, the RTL must make it a signal instead of a parameter.


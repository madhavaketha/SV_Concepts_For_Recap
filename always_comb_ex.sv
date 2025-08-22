//simple use case where the difference between always @(*) and always_comb becomes clear.
//Use Case: A Simple Combinational Multiplexer
//Code Example
module mux_example;
  logic sel, a, b, y1, y2;

  // Using always @(*)
  always @(*) begin
    if (sel)
      y1 = a;
    else
      y1 = b;
  end

  // Using always_comb
  always_comb begin
    if (sel)
      y2 = a;
    else
      y2 = b;
  end

  initial begin
    // Initial values
    sel = 0; a = 1; b = 0;
    #5  sel = 1;
    #5  a   = 0;
    #5  $finish;
  end
endmodule

//Waveform Behavior
//| **Time**  | **sel** | **a** | **b** | **y1 (`@(*)`)**          | **y2 (`always_comb`)**     |
//| --------- | ------- | ----- | ----- | ------------------------ | -------------------------- |
//| **0 ns**  | 0       | 1     | 0     | **X** (not executed yet) | **0** (executed at time 0) |
//| **5 ns**  | 1       | 1     | 0     | **1**                    | **1**                      |
//| **10 ns** | 1       | 0     | 0     | **0**                    | **0**                      |

//Key Observations
//Time 0 Behavior
//always @(*) → y1 remains X until a change happens in sel, a, or b.
//always_comb → y2 is computed immediately at time 0, giving a proper initialized value.
//
//Stricter Checks
//If you accidentally forget the else branch:

always_comb begin
    if (sel)
        y2 = a;   // Missing else
end


//always_comb will flag an error (potential unintended latch).
//always @(*) will silently create a latch, which could cause mismatches between simulation and synthesis.
//
//Real-World Impact
//Verification : Avoids unknown (X) values propagating in early simulation time.
//Design safety: Catches issues like multiple drivers or incomplete assignments at compile time.
//Best Practice: Always use always_comb for combinational logic in SystemVerilog for more predictable and safer code.

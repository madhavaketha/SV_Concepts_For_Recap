//In SystemVerilog, issues like parallel case and full case — which were common in Verilog — are largely solved by language enhancements and better semantic checks.
//
//Here’s a clear breakdown:
//1. Understanding the Problems
//(a) Full-case problem
//Occurs when not all possible conditions are covered in a case statement.
//
//Example:
case(sel)
  2'b00: y = a;
  2'b01: y = b;
  // Missing cases for 2'b10 and 2'b11
endcase

//Issue:
//Simulation: y holds its previous value (implies a latch).
//Synthesis: Some tools might assume "full coverage" and optimize incorrectly.
//Mismatch between simulation and synthesis.
//
//(b) Parallel-case problem
//Occurs when multiple case items can match at the same time but the simulator only executes the first match.
//
//Example:
case(sel)
  2'b1?: y = a;
  2'b?1: y = b;  // Overlaps when sel = 2'b11
endcase

//Simulation executes first match only, but synthesis may optimize differently → functional mismatch.
//
//2. SystemVerilog Solutions
//SystemVerilog introduces qualifiers and stricter semantics to avoid these problems.
//
//(a) unique case
//Ensures only one branch can be true at a time.
//If no branch matches, simulator throws a runtime warning.
//
//Example:
unique case(sel)
  2'b00: y = a;
  2'b01: y = b;
  2'b10: y = c;
endcase


//Behavior:
//If multiple branches match → simulator error.
//If no branch matches → simulator warning.
//Avoids parallel-case problem.
//
//(b) unique0 case
//Similar to unique, but allows no match without a warning.
//Useful when a default action is intentionally not needed.
//
//Example:
unique0 case(sel)
  2'b00: y = a;
  2'b01: y = b;
endcase

//(c) priority case
//Evaluates branches in order like an if-else ladder.
//Ensures that at least one branch must match; otherwise, simulator warns.
//
//Example:
priority case(sel)
  2'b00: y = a;
  2'b01: y = b;
  2'b10: y = c;
endcase

//Avoids unintended optimizations when priority is required.
//
//(d) Use of default
//Even in unique or priority, adding a default helps cover unexpected conditions:

unique case(sel)
  2'b00: y = a;
  2'b01: y = b;
  default: y = 0;  // Safe fallback
endcase

//3. Example Showing the Fix
//Problematic Verilog
case(sel)
  2'b1?: y = a;
  2'b?1: y = b;
endcase

//When sel = 2'b11, both patterns match → simulation chooses the first → mismatch.
//SystemVerilog Fix

unique case(sel)
  2'b1?: y = a;
  2'b?1: y = b;
endcase


//Simulator will flag an error because both match, forcing you to fix the logic.
//
//4. Benefits of Using unique and priority
//| Feature / Issue                    | **Verilog case** | **SystemVerilog `unique/priority`** |
//| ---------------------------------- | ---------------- | ----------------------------------- |
//| Detect overlapping branches        | ❌ No             | ✔ Yes (runtime error for `unique`)  |
//| Detect uncovered branches          | ❌ No             | ✔ Warning for missing cases         |
//| Synthesis & simulation consistency | ❌ Risky          | ✔ Safe and consistent               |
//| Encourages safer coding style      | ❌ No enforcement | ✔ Enforced checks                   |
//
//5. Best Practices
//Use unique case for mutually exclusive choices.
//Use priority case for if-else style priority logic.
//Always provide a default for unexpected values unless exhaustive coverage is guaranteed.
//Enable compiler/simulator warnings for incomplete or overlapping cases to catch issues early.

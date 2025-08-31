Basic Assertions:
1.What are the types of assertions in SystemVerilog, and how do they differ?
    immediate and concurrent assertions in system verilog 
    immediate assertion are evaluated at a specific time point.
    concurrent assertion are evaluated over a period of time. 
  
2.Write a SystemVerilog assertion to check if a signal data becomes stable (does not change) for three consecutive clock cycles.
    
	property data_stable; 
	    @(posedge clk) $stable(data_stable) [*3];
	endproperty 
	assert property (data_stable) 
	  else $error("assertion failure");
	
3.How does a cover statement differ from a property statement in SystemVerilog assertions?
    A cover statement checks for coverage of certain conditions, while a property defines a behavior that can be checked or asserted.
	
Immediate Assertions:
4.What is the difference between an immediate assertion and a concurrent assertion?
  Immediate assertions check a condition instantaneously, while concurrent assertions monitor behaviors over time.

5.Write an immediate assertion to check if a signal valid is asserted high when the signal ready is high.
  assert (valid == 1 || ready == 0) else $error("Invalid condition: valid should be high when ready is high.");

Concurrent Assertions:
6.Define a concurrent assertion to ensure that when a signal req is asserted, the signal ack should be asserted within two clock cycles.
    property sample_req;
	   @(posedge clk) req |-> ##[1:2] ack;
	endproperty
	assert property (sample_req);
	
7.How do overlapping and non-overlapping repetitions differ in SystemVerilog assertions? Provide an example for each.
    @(posedge clk) a ##1 b [->3];
    @(posedge clk) a ##1 b [=3];

Assertion Scenarios:
8.Write a SystemVerilog assertion that ensures a burst write operation starts only when a signal burst_enable is high.
   property busrt_wr_st; 
    @(posedge clk) burst_enable |-> ##1 burst_start
   endproperty
   assert property (busrt_wr_st);
   
9.Create an assertion to verify that for a signal start, a signal done should occur within 5 clock cycles, and provide a failure condition.
   property start_to_done;
    @(posedge clk) start |-> ##[1:5] done;
   endproperty
   assert property (start_to_done) else $error("Done did not occur within 5 cycles of start.");
   
Advanced Assertions:
10.How would you use a disable condition in assertions to handle reset scenarios?
   property check_with_reset;
     @(posedge clk) disable iff (!reset) (condition);
   endproperty
  
11.Write an assertion to verify that a read address does not exceed the maximum memory address 0xFF.
   assert (read_addr <= 8'hFF) else $error("Read address exceeds maximum limit."); // immediate assertion 
   
UVM Assertions:
12.How can assertions be integrated into a UVM environment? Provide an example.
   class my_monitor extends uvm_monitor;
   virtual interface my_if vif;
   task run_phase(uvm_phase phase);
      forever begin
         @(posedge vif.clk);
         assert (vif.signal_a == 1'b1) else `uvm_error("ASSERTION FAILED", "signal_a is not 1");
      end
   endtask
   endclass

13.Explain the impact of enabling and disabling assertions dynamically in UVM testbenches.
   Dynamic Enabling/Disabling Assertions: Assertions can be enabled/disabled using $assertoff and $asserton. 
   In UVM, this can be controlled via simulation arguments or run-time configuration.
   
   
   
14.write an assertion to ensure that if a req is asserted, then the ack must be asserted within 2 cycles 

property p_ack_within_2_cycles;
  @(posedge clk) req |-> ##[1:2] ack;
endproperty

assert property (p_ack_within_2_cycles)
  else $fatal("ack was not asserted within 2 cycles of req");

15.write an assertion to ensure that when valid is asserted high, it remains high for eaxclty 3 consecutive clock cycles before de asserting 

property p_valid_exact_3_cycles;
  @(posedge clk)
    $rose(valid) |-> valid[*3] ##1 !valid;
	// $rose(valid) |-> ##1 valid ##1 valid ##1 !valid;
endproperty

assert property (p_valid_exact_3_cycles)
  else $fatal("valid was not held high for exactly 3 consecutive cycles");

16.write an assertion to verify that a signal(toggle_sig) toggles at least once in 10 clock cycles
 property toggle_event;
    @(posedge clk)
    disable iff (!reset_n)
    // within 10 cycles, at least once toggle detected:
    // Using 'or' over 10 cycles: eventually toggle_sig toggles compared to its previous cycle
    // 'toggle_sig != $past(toggle_sig)' detects toggle in current cycle compared to previous cycle
    // We want to say: at least once within 10 cycles, toggle detected
    // So, from now, in next 10 cycles, check if any toggle
    // 'or' of toggle_sig != $past(toggle_sig) over 10 cycles:

    // Use a temporal sequence: 10 cycles, any cycle has toggle
    // The '##[0:9]' means within 0 to 9 cycles after the current cycle.

    // So property is: eventually (within 10 cycles) toggle event happens
    // We'll write it as:
    (1'b1) |-> ##[0:9] (toggle_sig != $past(toggle_sig));
endproperty

17.write an assertion to detect a rising edge of signal (sig) and ensure that another signal(flag)remains low for 5 clock cycles after that ?

// Rising edge detection: sig && !$past(sig)
// After the rising edge, flag must remain low for 5 clock cycles
property flag_low_after_sig_rise;
  @(posedge clk)
  disable iff (!reset_n)
  (sig && !$past(sig)) |-> (##1 !flag[*5]);
  //$rose(sig) |-> (##1 !flag[*5]);
endproperty

assert_flag_low_after_sig_rise : assert property (flag_low_after_sig_rise)
  else $error("ERROR: 'flag' did not remain low for 5 cycles after rising edge on 'sig'");
  
18.write an assertion to check that a counter increments by 1 on every clock cycle ?

property counter_increments_when_enabled;
  @(posedge clk)
  disable iff (!reset_n)
  enable |-> counter == $past(counter) + 1;
endproperty

assert_counter_when_enabled : assert property (counter_increments_when_enabled)
  else $error("ERROR: counter did not increment by 1 when enable was high");



19. 
| Operator | Name                       | Description                                                                                                             |
| -------- | -------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `[*n]`   | **Consecutive Repetition** | Expression must be true for `n` **consecutive** clock cycles.                                                           |
| `[->n]`  | **Goto Non-Consecutive**   | Expression must be true for `n` **total (not necessarily consecutive)** matches; matches can be **scattered**.          |
| `[=n]`   | **Non-Consecutive Strict** | Expression must be true for **exactly** `n` cycles, **non-consecutively**, and **false in between** if not consecutive. |


| Feature                      | `[*n]`                    | `[->n]`                                  | `[=n]`                                      |
| ---------------------------- | ------------------------- | ---------------------------------------- | ------------------------------------------- |
| Consecutive matches required | ✅ Yes                    | ❌ No                                    | ❌ No                                        |
| Gaps (false cycles) allowed  | ❌ No                     | ✅ Yes                                   | ✅ Yes, but `b` must be **false** in between |
| Match count                  | Exactly `n`               | Exactly `n` (total matches)              | Exactly `n` (total matches, no overlap)     |
| Evaluation ends on           | Last match of final `b`   | After last `b` match and `##` transition | After last `b` match and `##` transition    |
| Use case                     | Data valid for `n` cycles | Retry counter, out-of-order matches      | Strict counting with false in between       |


// Consecutive: b must be high for 3 *continuous* cycles after a
property p_consecutive;
  @(posedge clk) $rose(a) |-> b[*3] ##1 c;
endproperty

// Non-consecutive loose: b must be high any 3 cycles after a
property p_goto;
  @(posedge clk) $rose(a) |-> b[->3] ##1 c;
endproperty

// Non-consecutive strict: b must be high in exactly 3 cycles, with false in between if needed
property p_strict;
  @(posedge clk) $rose(a) |-> b[=3] ##1 c;
endproperty

//Interpretation ::
//1. b[*3] (Consecutive):
//b must be high at 1, 2, 3 ✔️ Followed by c at 5 ✅
//
//2. b[->3] (Loose Goto):
//Any 3 times b is high → 1, 2, 3 (consecutive, or even 1, 5, 9) ✔️
//Just ensure 3 total b=1 matches, scattered allowed
//Then c occurs ✅
//
//3. b[=3] (Strict Non-Consecutive):
//b must be high exactly 3 times, possibly with gaps (e.g., 1, 5, 9) ✔️
//And must be low in-between each match ❗
//Then c occurs 1 cycle later ✅

19.Write an assertion to ensure that a signal ‘write‘ is not active during reset.
// Assertion: 'write' must be 0 during reset
property write_inactive_during_reset;
  @(posedge clk)
  !reset_n |-> !write;
endproperty

assert_write_inactive_during_reset : assert property (write_inactive_during_reset)
  else $error("ERROR: 'write' signal is active during reset");

20.How do you assert that a signal ‘data valid‘ remains high for 3 consecutive clock cycles once it becomes high?
// Assertion: When data_valid becomes high, it must stay high for 3 consecutive cycles
property data_valid_3_cycles;
  @(posedge clk)
  disable iff (!reset_n)
  (data_valid && !$past(data_valid)) |-> data_valid[*3];
endproperty

assert_data_valid_3_cycles : assert property (data_valid_3_cycles)
  else $error("ERROR: data_valid did not remain high for 3 consecutive cycles after becoming high");

21.Difference between 'assert property' and 'cover property'

//================================== assert ==================================//
Purpose:
1.Used to check that a given property always holds during simulation.
2.If it fails, the simulator throws an error (fatal or warning based on configuration).

💡 Example: Ensure ack follows req within 2 cycles.
property req_ack_response;
  @(posedge clk)
  disable iff (!reset_n)
  req |=> ##[1:2] ack;
endproperty

assert property (req_ack_response)
  else $error("ACK did not occur within 2 cycles of REQ");

Explanation:
1.On req going high, ack must occur within 1 to 2 clock cycles.
2.If not, assertion fails.

//================================== cover ==================================//
Purpose:
1.Used to verify that a certain event or sequence occurs at least once during simulation.
2.It does not fail if it doesn't happen — it's only used for coverage (functional completeness).

💡 Example: Check that a transaction from start to done happens at least once.
cover property (
  @(posedge clk)
  disable iff (!reset_n)
  start |=> ##[1:$] done
);

Explanation:
1.Once start goes high, done must occur eventually.
2.The coverpoint is hit once this happens, giving confidence that the testbench exercised this path.

// common example 
property valid_packet;
  @(posedge clk)
  req |-> ##1 grant;
endproperty

assert property (valid_packet);  // Run-time check
cover property  (valid_packet);   // Functional coverage


22.Write an assertion that checks a burst transfer of 4 cycles starting from ‘burst start‘ with ‘data valid‘ high in all cycles
property burst_transfer_4_cycles;
  @(posedge clk)
  disable iff (!reset_n)
  burst_start |-> data_valid[*4];
endproperty

assert_burst_transfer_4_cycles : assert property (burst_transfer_4_cycles)
  else $error("ERROR: data_valid was not high for all 4 cycles of the burst after burst_start");
  
//Explanation
Clock Cycle      :  C0  C1  C2  C3  C4
burst_start      :   0   1   0   0   0
data_valid       :   x   1   1   1   1  → ✅ Assertion passes



// ================================================== APB Protocol Assertion checks ====================================================//

//1. Reset Behavior: All control signals must go to known states during reset
property apb_reset_behavior;
  @(posedge PCLK) disable iff (!PRESETn)
  !PRESETn |-> (!PSEL && !PENABLE && !PWRITE);
endproperty

//1. PENABLE only after PSEL
//Description: In APB, PENABLE should only be asserted after PSEL has gone high.
property penable_after_psel;
  @(posedge PCLK)
  disable iff (!PRESETn)
  PENABLE |-> $past(PSEL);
endproperty
assert property(penable_after_psel);

//2. PWDATA stable after PENABLE high (during write)
property pwdata_stable_after_penable;
  @(posedge PCLK)
  disable iff (!PRESETn)
  (PSEL && PENABLE && PWRITE) |-> $stable(PWDATA);
endproperty
assert property(pwdata_stable_after_penable);

//3. PADDR stable during transfer
property paddr_stable;
  @(posedge PCLK)
  disable iff (!PRESETn)
  (PSEL && !PREADY) |-> $stable(PADDR);
endproperty
assert property(paddr_stable);

//4. PWRITE stable during transfer
property pwrite_stable;
  @(posedge PCLK)
  disable iff (!PRESETn)
  (PSEL && !PREADY) |-> $stable(PWRITE);
endproperty
assert property(pwrite_stable);

//5. PREADY only when PSEL is high
property pready_when_psel;
  @(posedge PCLK)
  disable iff (!PRESETn)
  PREADY |-> PSEL;
endproperty
assert property(pready_when_psel);

//6. PRDATA valid when PREADY is high for read
property prdata_valid_on_read;
  @(posedge PCLK)
  disable iff (!PRESETn)
  (PSEL && PENABLE && !PWRITE && PREADY) |-> !$isunknown(PRDATA);
endproperty
assert property(prdata_valid_on_read);

//7. PWDATA valid before PENABLE goes high
property pwdata_valid_before_penable;
  @(posedge PCLK)
  disable iff (!PRESETn)
  (PSEL && !PENABLE && PWRITE) |-> !$isunknown(PWDATA);
endproperty
assert property(pwdata_valid_before_penable);

//8. PSEL should not be high during reset
property psel_during_reset;
  @(posedge PCLK)
  !PRESETn |-> !PSEL;
endproperty
assert property(psel_during_reset);

//9. PSLVERR only valid when PREADY is high
property pslverr_only_with_pready;
  @(posedge PCLK)
  disable iff (!PRESETn)
  PSLVERR |-> PREADY;
endproperty
assert property(pslverr_only_with_pready);

//10. No transfer when PSEL is low
property no_transfer_when_psel_low;
  @(posedge PCLK)
  disable iff (!PRESETn)
  !PSEL |-> (!PENABLE && !$changed(PADDR) && !$changed(PWDATA));
endproperty
assert property(no_transfer_when_psel_low);

//11. PENABLE should only be high when PSEL is high
//Why?,APB protocol states: PENABLE is asserted only in the second cycle of an APB transfer (access phase), after PSEL.
property apb_penable_when_psel;
  @(posedge PCLK) disable iff (!PRESETn)
  PENABLE |-> PSEL;
endproperty

//12. PSEL must be asserted for at least one cycle before PENABLE
//Why?,Transfer starts with setup phase (PSEL=1, PENABLE=0) → then access phase (PSEL=1, PENABLE=1).
property apb_psel_before_penable;
  @(posedge PCLK) disable iff (!PRESETn)
  (PSEL && !PENABLE) |=> PENABLE;
endproperty

//13. Once PENABLE is asserted, it must remain high until PREADY is high
//Why?,Transfer continues until slave is ready.
property apb_penable_until_pready;
  @(posedge PCLK) disable iff (!PRESETn)
  (PSEL && PENABLE && !PREADY) |-> ##1 (PENABLE throughout (!PREADY));
endproperty
//Here, throughout ensures PENABLE stays high during wait.

//14. No change in address or control signals during active transfer
//Why?,Once PENABLE is high, PADDR, PWRITE, PSEL should remain stable.
property apb_signal_stability_during_transfer;
  @(posedge PCLK) disable iff (!PRESETn)
  (PSEL && PENABLE && !PREADY) |-> ##1
  ($stable(PADDR) && $stable(PWRITE) && $stable(PSEL));
endproperty

//15. Write data (PWDATA) must be stable during the access phase
//Why?,Changing write data mid-transfer may lead to data corruption.
property apb_pwdata_stability;
  @(posedge PCLK) disable iff (!PRESETn)
  (PWRITE && PSEL && PENABLE && !PREADY) |-> $stable(PWDATA);
endproperty

//16. PRDATA must be valid only when PREADY is high during a read
//Why?,Slave only drives valid data when ready.
property apb_prdata_valid;
  @(posedge PCLK) disable iff (!PRESETn)
  (PSEL && PENABLE && !PWRITE && PREADY) |-> !$isunknown(PRDATA);
endproperty

//17. No overlapping transfers allowed
//Why?,APB is a simple bus that does not allow pipelining or overlapping transactions.
property apb_no_overlap;
  @(posedge PCLK) disable iff (!PRESETn)
  (PSEL && PENABLE && !PREADY) |-> !((PSEL && !PENABLE) or (PSEL && PENABLE));
endproperty
//This prevents the new transfer from starting while one is still ongoing.

//18. Ensure read and write are mutually exclusive
//Why?,Both cannot be true at the same time.
property apb_rw_exclusive;
  @(posedge PCLK) disable iff (!PRESETn)
  !(PWRITE && !PWRITE);
endproperty
//Or simply check: PWRITE must be either 0 or 1 — not unknown.

//19. Completion of APB transaction: start with PSEL=1, end with PREADY=1
//Why?,Ensure every transaction starts and finishes cleanly.
property apb_transfer_complete;
  @(posedge PCLK) disable iff (!PRESETn)
  (PSEL && !PENABLE) |=> (PENABLE && !PREADY) ##[0:$] PREADY;
endproperty
//This means: after setup phase, transfer continues until PREADY completes.


//'throughout' : A throughout B means: Whenever sequence B is true, sequence A must also hold true for the entire duration of B.
//Example use case:If data_valid is high, then ready must remain high throughout the period that data_valid is high.

property p_ready_throughout_data_valid;
  @(posedge clk)
    data_valid |-> ready throughout data_valid;
endproperty

assert property (p_ready_throughout_data_valid)
  else $error("Ready de-asserted while data_valid is high");
//How it works:
//If data_valid is asserted, ready must remain high until data_valid de-asserts.
//Even one cycle of ready=0 while data_valid=1 will fail the assertion.

//'until' : A until B means: A must hold true on every cycle until B becomes true.When B is true, we stop checking.B does not have to overlap with the last occurrence of A.
//Example use case:req must stay high until ack goes high.

property p_req_until_ack;
  @(posedge clk)
    req |-> req until ack;
endproperty

assert property (p_req_until_ack)
  else $error("Request dropped before Ack");
//How it works:
//Once req is seen, it must stay high until ack is observed.
//The cycle when ack is high can have req low (no overlap required).

//'until_with' :A until_with B is similar to until, but B must overlap with the last cycle of A.So A must remain true up to and including the cycle where B is true.
//Example use case:req must stay high until the same cycle where ack goes high.
property p_req_until_with_ack;
  @(posedge clk)
    req |-> req until_with ack;
endproperty

assert property (p_req_until_with_ack)
  else $error("Request dropped before Ack in the same cycle");
//How it works:
//req must remain asserted until ack is asserted in the same cycle.
//This enforces a tighter handshake compared to until.

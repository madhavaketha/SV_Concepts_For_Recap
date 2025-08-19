In SystemVerilog, Event Regions define the execution order of simulation events within a single simulation time step (delta cycle). They ensure deterministic behavior when multiple processes interact (for example, drivers, monitors, assertions).

🔹 Event Regions in SystemVerilog
Each simulation time step is divided into several event regions. The most important are:

Preponed Region
Happens before the clock edge.
Used to sample values just before they change.
Assertions often sample signals here.

Active Region
Where most procedural blocks (always, initial, blocking assignments) execute.
Can have race conditions if multiple drivers act on the same signal.

Inactive Region
Executes after the Active region if events are scheduled with ->>.
Rarely used in testbenches.
Non-blocking Assign (NBA) Region

All non-blocking assignments (<=) update here, after Active region finishes.
Ensures consistency across RTL designs using <=.

Observed Region
Occurs after NBA.
Assertions (like assert property) sample signals here.

Reactive Region
After Observed region.
Used by testbench components (program blocks) to drive responses after DUT has settled.

Postponed Region
Final region in a time step.
For $monitor, $strobe, etc.
Ensures you see final stable values.


Execution Order at posedge clk
Preponed: Assertions sample signals.
Active: DUT always_ff sees d=0.
NBA: q <= d; updates after Active.
Observed: Assertions check correctness.
Reactive: Testbench sets d=1 (so DUT sees it only on next cycle).
Postponed: $monitor/$strobe display stable values.

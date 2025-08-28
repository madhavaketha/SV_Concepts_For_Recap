Static and automatic task in SV : 
Meaning of “automatic task”
	• Each call to the task gets its own separate copy of all local variables.
	• Calls can be reentrant (multiple calls running in parallel without overwriting each other’s data).
	• Ideal for parallel fork-join processes.
Meaning of “static task”
	• Only one copy of local variables exists for the whole simulation.
	• If multiple processes call it at the same time, they share those variables — so last writer wins.
	• Useful when you need to maintain state across calls (like a counter that persists).


module tb;
  task automatic auto_task();
    int val = 0;
    val++;
    $display("[%0t] auto_task val=%0d", $time, val);
  endtask

  task static static_task();
    int val = 0;
    val++;
    $display("[%0t] static_task val=%0d", $time, val);
  endtask

  initial begin
    fork
      auto_task();  // fresh val=1
      auto_task();  // fresh val=1 (different memory)
      static_task(); // val=1 (shared)
      static_task(); // val=2 (same memory)
    join
  end
endmodule

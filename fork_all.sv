//1. fork...join behavior
//In fork...join, the parent process waits for all child threads to complete.
//This means you cannot exit early or disable only one thread while others keep running.
//If you try to disable inside fork...join, it won’t have much effect because the parent process won’t continue until all child threads finish.

//2. Why you cannot disable specific threads in fork...join
//Because the execution model of fork...join requires all child threads to run to completion.
//The parent thread is suspended until every child finishes.
//So, even if you attempt to disable one child, the parent process still waits for it (and will be stuck).

//3. Alternative: fork...join_any / fork...join_none
//If you want more flexibility:
//fork...join_any → Parent continues after any one child finishes.
//fork...join_none → Parent continues immediately, doesn’t wait for children.

//With these, you can use named blocks or process handles to disable specific threads when needed.

//Example 1: Killing a specific thread using named blocks 
module tb;

  initial begin
    fork
      begin : thread1
        repeat (10) begin
          #5;
          $display("Thread1 running");
        end
      end
      begin : thread2
        repeat (10) begin
          #5;
          $display("Thread2 running");
        end
      end
      begin : thread3
        repeat (10) begin
          #5;
          $display("Thread3 running");
        end
      end
    join_none   // <--- allows parent to continue without waiting
    #20;
    disable thread2;  // Kill only thread2
    #100;
  end

endmodule

//👉 In this example:
//We used join_none so parent is free to continue.
//After 20 time units, we disable thread2 specifically.
//Threads 1 and 3 will continue running, but thread2 is killed.

//Example 1: Killing a specific thread using process handles
module tb;
  process p1, p2, p3;

  initial begin
    fork
      begin : T1
        p1 = process::self();
        $display("Thread 1 started");
        #50 $display("Thread 1 finished");
      end
      begin : T2
        p2 = process::self();
        $display("Thread 2 started");
        #100 $display("Thread 2 finished");
      end
      begin : T3
        p3 = process::self();
        $display("Thread 3 started");
        #200 $display("Thread 3 finished");
      end
    join_none

    #60;
    $display("Killing Thread 2 at time %0t", $time);
    p2.kill();  // kills only thread T2
  end
endmodule

//👉 Explanation:
//process::self() → gets a handle to the current running thread.
//p2.kill(); → stops only thread 2, while others continue normally.
//If you wanted to stop all, you’d either use disable fork; or call kill() on each process handle.

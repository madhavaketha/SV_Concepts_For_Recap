//1. What happens when you “just assign” objects? , In SystemVerilog:
//t2 = t1;
//This does not create a new object.
//It copies the handle, meaning:
//Both t1 and t2 now point to the same object in memory.
//Any change through t2 will also be visible in t1 (and vice versa).

//Example — Handle Assignment:
class transaction;
  int data;
endclass

module tb;
  transaction t1, t2;

  initial begin
    t1 = new();
    t1.data = 100;

    t2 = t1; // Just copying the handle
    t2.data = 200;

    $display("t1.data = %0d", t1.data); // 200 — oops, t1 changed too
  end
endmodule
//⚠ Problem: We lost the original value in t1.

//2. Why copy() is needed
//When you want two separate objects with the same field values, you must explicitly copy each field into a new object.
//This is what UVM’s copy() method does.

//Example — Explicit Copy:
class transaction;
  int data;

  function void copy(transaction rhs);
    this.data = rhs.data; // Copy field value
  endfunction
endclass

module tb;
  transaction t1, t2;

  initial begin
    t1 = new();
    t1.data = 100;

    t2 = new();
    t2.copy(t1); // Explicitly copy field data
    t2.data = 200;

    $display("t1.data = %0d", t1.data); // 100 — unchanged
  end
endmodule
//✅ Now t1 and t2 are independent objects.

//Summary:
//t2 = t1;	    Copies the handle — both point to same object
//t2.copy(t1);	Copies field values into an already new object


//What is $cast?
//$cast is a built-in SystemVerilog system task that is used for type casting — i.e., converting one class handle (or data type) into another, usually between base and derived classes in OOP.
//
//Syntax:
//$cast(target_handle, source_handle);
//
//target_handle → The variable you want to assign to (destination).
//source_handle → The object/handle you want to cast (source).
//It returns 1 (success) if casting is valid, otherwise 0 (failure).
//
//Why do we need $cast?
//In OOP with inheritance, a base class handle may point to a derived class object.
//When we want to access derived class-specific fields/methods from a base class handle, we need to safely cast.
//$cast ensures type-safety instead of a direct assignment.
//
//Example 1: Without $cast (unsafe direct assignment)

class Base;
  int id;
endclass

class Derived extends Base;
  int extra;
endclass

module test;
  Base b;
  Derived d;

  initial begin
    d = new();
    d.id = 10;
    d.extra = 99;

    // Assign derived to base - Allowed
    b = d;  
    $display("b.id = %0d", b.id);

    // Now if we try to access derived member
    // b.extra; // ❌ Compile error (b is only Base handle)
  end
endmodule
//Here, the base class handle (b) loses visibility of extra.
//
//Example 2: With $cast (safe downcasting)

module test_cast;
  Base b;
  Derived d, d2;

  initial begin
    d = new();
    d.id = 10;
    d.extra = 99;

    // Base handle can point to Derived
    b = d;

    // Downcast base -> derived
    if($cast(d2, b)) begin
      $display("Cast successful: id=%0d extra=%0d", d2.id, d2.extra);
    end else begin
      $display("Cast failed");
    end
  end
endmodule
//✅ Now we safely access extra because $cast checks the runtime type of b.
//
//Advantages of $cast
//Type Safety → Prevents invalid assignments.
//Run-time Check → Ensures object actually belongs to that type before casting.
//Supports Polymorphism → Useful in UVM when casting from uvm_object to actual transaction classes.

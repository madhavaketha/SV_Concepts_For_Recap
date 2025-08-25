Polymorphism in SystemVerilog
Polymorphism = “One interface, many implementations”
	• We define a common base class (parent) with a virtual method.
	• Child classes inherit from this base and override the method.
	• We store different child objects in the same base-class handle and call the method.
	• The method executed depends on the actual object type, not the handle type.


// ----------------------
// Parent (Base) Class
// ----------------------
class transaction;
  // Virtual method: allows child classes to override
  virtual function void display();
    $display("Base transaction: No specific protocol");
  endfunction
endclass


// ----------------------
// Child Class 1
// ----------------------
class axi_transaction extends transaction;
  // Override the parent's display() method
  function void display();
    $display("AXI transaction: Addr=0x100, Data=0xABCD");
  endfunction
endclass


// ----------------------
// Child Class 2
// ----------------------
class apb_transaction extends transaction;
  // Override the parent's display() method
  function void display();
    $display("APB transaction: Addr=0x200, Data=0x1234");
  endfunction
endclass


// ----------------------
// Testbench
// ----------------------
module tb;
  transaction t; // Base class handle

  initial begin
    // Polymorphism: Same handle, different object types

    // Point to AXI object
    t = new axi_transaction();
    t.display();  // Calls axi_transaction's version

    // Point to APB object
    t = new apb_transaction();
    t.display();  // Calls apb_transaction's version

    // Point to Base object
    t = new transaction();
    t.display();  // Calls base class version
  end
endmodule



Why we need both:
	1. Inheritance → Lets us share structure/code between parent & child.
		○ Child classes can reuse variables/methods from the parent.
	2. Virtual keyword → Without virtual, method binding happens at compile-time (static binding).
		○ With virtual, method binding happens at runtime (dynamic binding) so the correct overridden method is called based on the object type, not the handle type.

Real Verification Use Case
	• In a UVM environment, we might have a base sequence with a send_txn() method marked as virtual.
	• Different sequence classes override send_txn() to send AXI, APB, or PCIe transactions.
	• A single sequencer can store a list of base sequence handles and execute them without caring which protocol each one implements.



yes — you’re right that inheritance already lets a child class access the parent’s properties and methods.
But polymorphism is a runtime behavior, whereas inheritance is a compile-time structure.
Let’s break this down clearly:

1. Inheritance
	• Defines an “is-a” relationship.
	• Child gets everything from the parent:
		○ Variables
		○ Methods (can override them, or just reuse them)
	• Decided at compile-time — the compiler knows exactly what code will be run.
Example — Only Inheritance:
class parent;
  function void say_hello();
    $display("Hello from parent");
  endfunction
endclass
class child extends parent;
  function void say_child();
    $display("Hello from child");
  endfunction
endclass
module tb;
  initial begin
    child c = new();
    c.say_hello(); // Inherited from parent
    c.say_child(); // Defined in child
  end
endmodule
✅ Works fine — but no polymorphism yet.

2. Polymorphism
	• Lets one base class handle point to different types of objects at runtime.
	• Calls the overridden method of the actual object type.
	• Needs:
		○ Inheritance (to have a common base type)
		○ Virtual methods (so the runtime can choose the correct implementation)
Example — With Polymorphism:

class parent;
  virtual function void greet();
    $display("Greet from parent");
  endfunction
endclass
class child1 extends parent;
  function void greet();
    $display("Greet from child1");
  endfunction
endclass
class child2 extends parent;
  function void greet();
    $display("Greet from child2");
  endfunction
endclass
module tb;
  parent p; // Base class handle
initial begin
    p = new child1(); // At runtime
    p.greet(); // "Greet from child1"
    p = new child2(); // At runtime
    p.greet(); // "Greet from child2"
  end
endmodule
✅ Same handle (p), different behavior at runtime — that’s polymorphism.

Key Difference in One Line
	• Inheritance = “Child gets parent’s properties/methods” (static, compile-time relationship).
	• Polymorphism = “Same parent handle can call different child behaviors at runtime” (dynamic, run-time behavior).

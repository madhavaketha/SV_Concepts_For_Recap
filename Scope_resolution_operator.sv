//In SystemVerilog (and many other OOP languages), the scope resolution operator is ::.
//It’s used to access class members (variables, functions, tasks) or constants that belong to a specific scope — most often a class, package, or an enumeration — without having to create an object.

//1. Purpose
//To access static members (variables/methods) of a class without instantiating the class.
//To specify exactly which scope (class/package/enum) you want to use a member from, especially when multiple scopes have items with the same name.
//To access constants, typedefs, or functions inside a package or enum without ambiguity.

//2. Importance
//Without the :: operator:
//You’d have to create an object just to access static data/methods — which is unnecessary for constants or class-wide data.
//There could be naming conflicts between different packages or classes.
//You couldn’t directly use package-level definitions in modules or other classes.

//3. Example in SystemVerilog
//Accessing a static variable in a class
class Counter;
  static int count = 0; // Shared across all objects

  function void increment();
    count++;
  endfunction
endclass

module top;
  initial begin
    // Access static variable directly without creating object
    $display("Initial Count: %0d", Counter::count); 
    
    Counter c1 = new();
    c1.increment();
    $display("After increment: %0d", Counter::count);
  end
endmodule
//Why :: here?, Counter::count accesses a variable shared across all instances, no need to create an object just to read it.

//Accessing package contents
package math_pkg;
  parameter real PI = 3.14159;
  function real circle_area(real r);
    return PI * r * r;
  endfunction
endpackage

module top;
  import math_pkg::*; // or access directly

  initial begin
    $display("PI value: %f", math_pkg::PI); 
    $display("Area: %f", math_pkg::circle_area(5));
  end
endmodule
//Why :: here?, it specifies which package PI belongs to — useful if multiple packages have PI.

//Accessing enum members
typedef enum {RED, GREEN, BLUE} colors;

module top;
  initial begin
    $display("Color code: %0d", colors::RED); 
  end
endmodule
//Why :: here?, It avoids ambiguity and makes it clear RED is from colors enum.

//Key takeaway:
//The :: scope resolution operator gives direct access to a specific scope’s members without needing an object, and is essential for static members, packages, and enums.

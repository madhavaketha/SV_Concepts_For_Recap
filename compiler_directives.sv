//compiler directives
`ifndef SBD_PAD__SV
`define SBD_PAD__SV 
`endif 
//This prevents the file’s contents from being included more than once (similar to C/C++ include guards). If SBD_PAD__SV is not defined, define it and include the block; otherwise skip the block.

//ifdef MACRO … endif -- Conditional compilation: include block only if MACRO is defined.
`ifdef SIM_DEBUG
  $display("debug on");
`endif


//ifndef MACRO … endif -- Opposite of ifdef: include block only if MACRO is NOT defined.
`ifndef MY_HEADER_SV
`define MY_HEADER_SV
  // declarations or definitions here
`endif

//elsif MACRO and else -- Provide multiple branches for conditional compilation, similar to else-if.
`ifdef USE_A
  // use A
`elsif USE_B
  // use B
`else
  // default
`endif

//Short examples showing conditional compilation choices
//Compile-time switch to include debug methods:

`ifdef ENABLE_SBD_DEBUG
  function void debug_print();
    $display("total=%0d pass=%0d fail=%0d", total, pass, fail);
  endfunction
`endif

//==================================== Example code for compiler directives ======================================//
// config.svh
`ifndef PROJECT_CONFIG_SVH
`define PROJECT_CONFIG_SVH

// choose one of these for the build, or leave none to pick the default
`define USE_FAST_COMPARE
`define USE_EXACT_COMPARE

`endif

`include "config.svh"
`ifdef USE_FAST_COMPARE
  function int my_compare(pad_txn exp, pad_txn got);
    // fast approximate compare
  endfunction
`elsif USE_EXACT_COMPARE
  function int my_compare(pad_txn exp, pad_txn got);
    // strict field-by-field compare
  endfunction
`else
  function int my_compare(pad_txn exp, pad_txn got);
    // default compare
  endfunction
`endif
//==============================================================================================================//

//Difference between backtick (`) and hash (#) These two characters are used by different languages and preprocessor systems. Summary:

Hash # (in your shown C code)
1.Language/context: C/C++ preprocessor.
2.Usage:
       Starts preprocessor directives like #define, #include, #ifdef, #ifndef, #elif, #else, #endif, #undef.
       Inside macro definitions the single # (stringizing operator) turns a macro parameter into a quoted string; the double ## is the token-pasting (concatenation) operator.
3.Examples:
       #define FOO 42 // define macro
       #ifdef FOO // conditional compile
       #define S(x) #x // S(abc) -> "abc"
       #define P(a,b) a##b // P(foo,bar) -> foobar
	   
	   
Backtick ` (in SystemVerilog / Verilog)
1.Language/context: Verilog/SystemVerilog preprocessor.
2.Usage:
       Starts compiler/preprocessor directives in Verilog-family languages: define, include, ifdef, ifndef, elsif, else, endif, undef, and also UVM/SystemVerilog macros (e.g., `uvm_info).
       It is not used in C/C++ — it’s a separate preprocessor syntax for HDLs.
3.Examples:
       `define WIDTH 8
       `include "defs.svh"
        `ifdef SYNTHESIS 
		// ... 
		`endif
		

//what is the differnece between the #ifdef and #if defined ?
//case 1:Simple equivalence Both of these are equivalent and will include the block only when FOO is defined:
#ifdef FOO
/* code when FOO is defined */
#endif

#if defined(FOO)
/* code when FOO is defined */
#endif

//Note: #if defined FOO (without parentheses) is also accepted by most preprocessors, but defined(FOO) is clearer and portable.

//Case 2:Negation You can negate with #ifndef or with ! defined:
#ifndef FOO
/* code when FOO is not defined */
#endif


#if !defined(FOO)
/* same as above */
#endif

//Case 3:Complex conditions (where defined(...) is required) If you need to test multiple macros or combine with other numeric expressions, use #if and defined:
#if defined(FOO) && defined(BAR)
/* both defined */
#endif

#if defined(FOO) && (FOO == 1)
/* FOO must be defined and equal to 1 */
#endif

#if defined(FOO) || defined(BAR) && (VALUE > 10)
/* full expression evaluation with defined(...) operator */
#endif


//Readability and best practice
//Use #ifdef / #ifndef for simple presence checks — concise and common.
//Use #if defined(...) when you have combined conditions or need to evaluate expressions.
//Prefer defined(MACRO) with parentheses for clarity.
//Avoid relying on macros being defined to particular values unless documented — explicit checks reduce surprises.

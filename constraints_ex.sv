1.write a constaint to generate an array with values <=20 and the sum of the array elements equals to 100
2.write a constaint to generate this pattern 0102030405 
3.write a constaint to generate this pattern 
  0 0 0 1
  0 0 1 1
  0 1 1 1
  1 1 1 1
  
  class pattern_gen;
  rand bit matrix[4][4]; // 4 rows, 4 columns

  constraint c_pattern {
    foreach (matrix[i]) {
      int num_ones = i + 1;
      foreach (matrix[i][j]) {
        if (j < 4 - num_ones)
          matrix[i][j] == 0;
        else
          matrix[i][j] == 1;
      }
    }
  }

  function void display();
    foreach (matrix[i]) begin
      foreach (matrix[i][j])
        $write("%0d ", matrix[i][j]);
      $display("");//move to next line after finishing the row 
    end
  endfunction
endclass

module test;
  initial begin
    pattern_gen p = new();
    if (p.randomize())
      p.display();
    else
      $display("Randomization failed");
  end
endmodule

4. write a constaint to generate a fibonacci sequence 
   0 1 1 2 3 5 8 13 ........
   
   class packet;
     rand int arr[];
	 constraint c1 { 
	    arr.size() == 10;
		foreach (arr[i]) {
		   if(i==0)
		       arr[i] == 0;
		   else if(i==1) 
		       arr[i] == 1;
		   else 
		       arr[i] == arr[i-1] + arr[i-2];
		}
	 }	 			   
   endclass

5. How can we create a dynamic array of 10 entries, fill it with random data and then delete 8 th element 

module dynamic_array_example;

  // Declare dynamic array
  int dyn_array[];

  initial begin
    // Step 1: Allocate space for 10 entries
    dyn_array = new[10];

    // Step 2: Fill array with random values
    foreach (dyn_array[i])
      dyn_array[i] = $urandom_range(0, 100);

    // Display array before deletion
    $display("Array before deletion:");
    foreach (dyn_array[i])
    $display("dyn_array[%0d] = %0d", i, dyn_array[i]);

    // Step 3: Delete the 8th element (index 7)
    // Deletion isn't directly supported on dynamic arrays — use shift logic
    for (int i = 7; i < dyn_array.size() - 1; i++)
      dyn_array[i] = dyn_array[i + 1];

    // Shrink the array size by 1
    dyn_array = dyn_array.resize(dyn_array.size() - 1);

    //(or)//
    //dyn_array = {dyn_array[0:6] , dyn_array[8:9]}; // using concatination 
    							  
    // Display array after deletion
    $display("\nArray after deleting 8th element (index 7):");
    foreach (dyn_array[i])
    $display("dyn_array[%0d] = %0d", i, dyn_array[i]);
  end

endmodule

6.Write a program to find the maximum and minimum in an array without using built-in functions

module find_max_min;
  // Declare and initialize the array
  int array[5] = '{10, 25, 4, 19, 7}; 
  int max_value, min_value;

  initial begin
    // Initialize max_value and min_value to the first element of the array
    max_value = array[0];
    min_value = array[0];
    
    // Loop through the array to find the max and min
    for (int i = 1; i < array.size(); i++) begin
      if (array[i] > max_value) begin
        max_value = array[i]; // Update max_value
      end
      if (array[i] < min_value) begin
        min_value = array[i]; // Update min_value
      end
    end

    // Display the results
    $display("Array: %p", array);
    $display("Maximum Value: %0d", max_value);
    $display("Minimum Value: %0d", min_value);
  end
endmodule

7.write a code to reverse the hexadecimal number ABCD into DCBA in SV 

module generic_hex_reverse;
  // Parameterized width (must be multiple of 4)
  parameter int WIDTH = 16;
  
  logic [WIDTH-1:0] hex_in  = 16'hABCD;
  logic [WIDTH-1:0] hex_out;

  initial begin
    hex_out = '0;

    // Reverse each nibble (4-bit chunk)
    for (int i = 0; i < WIDTH; i += 4) begin
      hex_out[i +: 4] = hex_in[WIDTH - 4 - i +: 4];
    end

    // Display input and output
    $display("Original = 0x%0h", hex_in);
    $display("Reversed = 0x%0h", hex_out);
  end
endmodule

8. write a constraint to generate prime numbers 2 3 5 7 11 13 17 19 ....
   class packet;
      rand int arr[];
	  int prime_num [$];
	  
	  constraint c1 { 
	      arr.size() == 30;
		  foreach(arr[i]) { 
		    arr[i] == prime_fun(i);
		  }
	  }
	  
	  function int prime_func(input int i);
	    if( ((i%2!=0) && (i%3!=0) && (i%5!=0) && (i%7!=0) || ((i==2) || (i==3) || (i==5) || (i==7)) ) && (i>1) )
		    return i;
		else
		    return 0;			
	  endfunction
	  function void post_randomize();
	      foreach(arr[i]) begin 
		    if(arr[i] != 0) begin 
			  prime_num.push_back(arr[i]);
			end
		  end
	  endfunction 	  
   endclass

   // or //
class prime_gen;
  rand bit [6:0] num; // to generate number up to 127

  // constraint: limit range from 1 to 100
  constraint valid_range {
    num inside {[2:100]};
  }

  // post_randomize to ensure prime
  function void post_randomize();
    if (!is_prime(num)) begin
      // try again until prime is generated
      void'(this.randomize());
    end
    else begin
      $display("Randomized Prime Number: %0d", num);
    end
  endfunction

  // Prime checking logic
  function bit is_prime(int n);
    if (n < 2) return 0;
    for (int i = 2; i <= n/2; i++) begin
      if (n % i == 0) return 0;
    end
    return 1;
  endfunction
endclass

9.write a constraint so that every 3 rd number in an array is odd number 
  class third_odd_array;
  rand bit [7:0] arr[];  // array of 8-bit elements

  // Constraint: Array size between 6 and 12 for demo
  constraint size_c {
    arr.size() inside {[6:12]};
  }

  // Constraint: Every 3rd element (i.e., index % 3 == 2) should be odd
  constraint third_is_odd {
    foreach (arr[i]) {
      if (i % 3 == 2) {
        arr[i] % 2 == 1;  // Must be odd
      }
    }
  }

endclass

10.write a constraint to ensure there are non-consecutive ones in the number 
   class packet;
     rand bit [15:0] num;
	 constraint c1 {
	    foreach(num[i]){
		   if(num[i] == 1) {
		     num[i+1] == 0;
		   }
	    }
	 }
   endclass

11. write a constraint to generate this pattern 8 16 24 32 40 48 56 .....
  class packet; 
    rand int arr[];
	constraint c1 {
	    arr.size() == 10;
		foreach(arr[i]){
		  arr[i] == 8 * (i+1);
		}
	}
  endclass
  
11. write a constraint to generate this pattern 110011001100...
    class packet;
	 rand bit [15:0] num;
	 constraint c1{
	   foreach(num[i]){
	     if(i%4 <= 1) {
		   num[i] == 0;
		 }
		 else {
		   num[i] == 1;
		 }
	   }
	 }
	endclass

12.write a constraint to generate this pattern 000111222333..
  class packet;
    rand bit[3:0] arr[];
	constraint c1 {
	  arr.size() == 12;
	  foreach(arr[i]) {
	    if(i<3){
		  arr[i] == 0;
		}else {
		  arr[i] == arr[i-3] + 1;
		}
	  }
	}
  endclass

13.write a constraint to generate this pattern 1001100110011...
//1 0 0 1 1 0 0 1 1 0 0  1  1
//0 1 2 3 4 5 6 7 8 9 10 11 12

class pattern;
  rand bit [15:0] arr;
  constraint c1 {
    arr.size()==10;
	foreach(arr[i]){
	   if(i%4==0 || i%4==3){
	    arr[i] == 1;
	   }else{
	    arr[i] == 0;
	   }
	}
  }
endclass

14. write a constraint to generate a number that contain extly 10 no of ones without using $countones();
 class packet;
  rand bit arr[32];     // Unpacked array to store 0 or 1
  bit [31:0] num;        // Final number with 10 ones

  constraint c1 {
    // Each value should be either 0 or 1 — already true for bit type
    arr.sum() == 10; // Exactly 10 ones
  }

  function void post_randomize();
    num = 0;
    foreach (arr[i])
      num |= (arr[i] << i);
    $display("Randomized num = %b (%0d)", num, num);
  endfunction
endclass

module tb;
  initial begin
    packet p = new();
    void'(p.randomize());
  end
endmodule

   
15.write a constraint to generate gray code sequence 
class gray_gen;
  rand bit [3:0] bin_num;     // Binary number (4-bit)
       bit [3:0] gray_code;   // Corresponding gray code

  constraint c_gray {
    // gray_code should be equal to bin_num XOR (bin_num shifted right by 1)
    gray_code == (bin_num ^ (bin_num >> 1));
  }

  function void post_randomize();
    $display("Binary: %b -> Gray Code: %b", bin_num, gray_code);
  endfunction
endclass

| Binary (n) | n >> 1 | Gray Code = n ^ (n >> 1) |
| ---------- | ------ | ------------------------ |
| 000        | 000    | 000                      |
| 001        | 000    | 001                      |
| 010        | 001    | 011                      |
| 011        | 001    | 010                      |
| 100        | 010    | 110                      |
| 101        | 010    | 111                      |
| 110        | 011    | 101                      |
| 111        | 011    | 100                      |


16. write a constraint to generate an array where sum of digits is even positions is grater than the sum of digits in odd positions

class digit_array;
  rand bit [3:0] data[]; // each element: 0–9
  int sum_even, sum_odd;

  constraint c_size    { data.size() inside {[4:10]}; }
  constraint c_digits  { foreach (data[i]) data[i] inside {[0:9]}; }

  function void post_randomize();
    sum_even = 0;
    sum_odd  = 0;
    foreach (data[i]) begin
      if (i % 2 == 0)
        sum_even += data[i];
      else
        sum_odd  += data[i];
    end
  endfunction

  constraint c_sum {
    solve data before sum_even, sum_odd;
    sum_even > sum_odd;
  }

endclass

17. write a constraint to generate an array where the elements at even positions are positive and elements at odd postions are negative 

class packet;
 rand bit signed [5:0] arr[];
 constraint c1 {
    arr.size() == 20;
	foreach(arr[i]){
	  if (i%2 == 0) {
	    arr[i] > 0;
	  }
	  else {
	    arr[i] < 0;
	  }
	}
 }
endclass

18. write a constraint to generate power of 2 with out using multiplication operator 
 class packet;
    rand bit [15:0] arr[];
	constraint c1 {
	  arr.size() == 10;
	  foreach(arr[i]) {
	    arr[i] == 1 << (i+1); // means arr[i] == 1 is left shifted by i+1 positions 
	  }
	}
 endclass

19. write a constraint to generate an sorted array where the difference between the consecutive elements is atleast 2 
  class packet; 
    rand bit[3:0] arr[];
	foreach(arr[i]){
	 arr.size() == 10;
	 arr[i] >= arr[i] + 2;
	}
  endclass
  
20. write a constraint to generate this pattern 1 4 9 16 25 36 49 64 ....
   class pattern;
    rand bit [15:0] arr[];
	constraint c1 {
	 arr.size() == 10;
	 foreach(arr[i]) {
	    if(i>0) {
		  arr[i] = (i+1) * (i+1);
		}
	 }
	}
   endclass
   
21.write a constraint to generate a 2 consecutive 1's for 8 bit variable with the 1's positioned at any location?

  class packet;
    rand bit[7:0] num;
	constraint c1 {
	   $countones(num) == 2;
	   num & (num >> 1) != 0;
	}
  endclass
  
22. write a constraint for 8 bit dynamic array , ensuring that the size of array is greater than the previous array size '
  class packet;
    rand bit[7:0] arr[];
	bit [3:0] = 1;
	constraint c1 {
	   arr.size() == a;
	}
	
	function void post_randomize();
	  a = a+1; // a++
	endfunction 
  endclass

23. write a constraint to generate this pattern 0 9 1 99 2 999 3 9999 4 99999

0  9  1  99  2  999 3  9999 4  99999
0  1  2  3   4  5   6  7    8  9

class pattern;
 rand int arr[];
 constraint c1 {
    arr.size() == 10;
	foreach(arr[i]){
	   if(i%2==0){
	      arr[i] == i/2;
	   } else {
	      if(i==1){
		    arr[i] == 9;	  
		  }else{
		    arr[i] == 10*arr[i-2] + 9;
		  }
	   }
	}
 }
endclass

24.write a constraint to generate an array where the half of the elements are even and remaining are odd

class packet;
  rand bit[5:0] arr[];
  int len=0;
  constraint c1 {
    arr.size() == 10;
	len = arr.size() / 2;
	foreach (arr[i]){
	  if(i<len){
	    arr[i] % 2 == 0; //even
	  }else{
	    arr[i] % 2 == 1; //odd
	  }
	}
  }
endclass

25. write a function to cyclicly rotate an array in clock wise by one position?

function void rotate_clockwise_by_one(ref int arr[]);
  if (arr.size() <= 1)
    return;  // No need to rotate if 0 or 1 element

  int last = arr[arr.size() - 1];

  // Shift all elements to the right
  for (int i = arr.size() - 1; i > 0; i--) begin
    arr[i] = arr[i - 1];
  end

  // Place last element at the front
  arr[0] = last;
endfunction


module rotate_example;
  int data[] = '{10, 20, 30, 40, 50};

  initial begin
    $display("Before rotation: %p", data);
    rotate_clockwise_by_one(data);
    $display("After  rotation: %p", data); // Output: {50, 10, 20, 30, 40}
  end

  // Include the function inside or outside module
  function void rotate_clockwise_by_one(ref int arr[]);
    if (arr.size() <= 1)
      return;
    int last = arr[arr.size() - 1];
    for (int i = arr.size() - 1; i > 0; i--)
      arr[i] = arr[i - 1];
    arr[0] = last;
  endfunction

endmodule

Before rotation: '{10, 20, 30, 40, 50}
After  rotation: '{50, 10, 20, 30, 40}

26. write a constraint to generate an array where the elements form a mirror pattern 
class pattern;
   rand bit [7:0] arr[];
   constraint c1 {
     arr.size() inside {[10:20]};
	 foreach(arr[i]){
	    if(i < arr.size()/2){
		   arr[i] == arr[arr.size()-i-1]
		}
	 }
   }
endclass

27. write a function to sort an array in ascending order without using any built in method?

module sort_example;
  int data[] = '{25, 10, 40, 5, 90};
  initial begin
    $display("Before sorting: %p", data);
    sort_ascending(data);
    $display("After  sorting: %p", data);  // Expected: {5, 10, 25, 40, 90}
  end

  // Include the function inside or outside the module
  function void sort_ascending(ref int arr[]);
    int n = arr.size();
    for (int i = 0; i < n - 1; i++) begin
      for (int j = 0; j < n - i - 1; j++) begin
        if (arr[j] > arr[j + 1]) begin
          int temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;
        end
      end
    end
  endfunction
endmodule

28.write a constraint to generate a 3 consecutive 1's for 8 bit variable with the 1's positioned at any location?

  class packet;
    rand bit[7:0] num;
	constraint c1 {
	   $countones(num) == 3;
	   ((num & (num >> 1)) & (num >> 2)) != 0;
	}
  endclass
  
29. write a function to identify all the elements that occurs more than once in an array?

module duplicate_finder_simple;
  int data[] = '{10, 20, 10, 30, 40, 30, 50, 20};
  initial begin
    $display("Input array: %p", data);
    find_duplicates_simple(data);
  end

  function void find_duplicates_simple(input int arr[]);
    int n = arr.size();
    $display("Duplicate elements:");
    for (int i = 0; i < n; i++) begin
      bit already_checked = 0;
      // Check if arr[i] has already been processed
      for (int k = 0; k < i; k++) begin
        if (arr[k] == arr[i]) begin
          already_checked = 1;
          break; // Skips the remaining statements in the current looop iteration and proceeds to the next iteration
        end
      end
      if (already_checked)
        continue; //this continue statemnet skips the counting logic for arr[i] 

      // Count occurrences of arr[i]
      int count = 0;
      for (int j = 0; j < n; j++) begin
        if (arr[j] == arr[i])
          count++;
      end

      if (count > 1)
        $display("Value %0d occurred %0d times", arr[i], count);
    end
  endfunction

endmodule


30. write a constraint to generate an array where the first element repeats on every 4th position 
   class packet;
      rand bit[3:0] arr[];
	  constraint c1 {
	    arr.size() inside {[10:20]};
		foreach(arr[i]){
		  if(i>0){
		    if(i%4 == 0){
			   arr[i] == arr[0];
			}
			else {
			   arr[i] != arr[0];
			}
		  }
		}
	  }
   endclass
   
31.write a function to find how many times a specific number appears in an array. 

module test_count_occurrences;
  int data[] = '{10, 20, 10, 30, 40, 30, 50, 20};
  int target = 30;
  int result;

  function int count_occurrences(input int arr[], input int target);
  int count = 0;
  for (int i = 0; i < arr.size(); i++) begin
    if (arr[i] == target)
      count++;
  end
  return count;
  endfunction

  initial begin
    result = count_occurrences(data, target);
    $display("The number %0d appears %0d times in the array.", target, result);
  end
endmodule

32. write a constraint to generate an wave array where elements alternative between larger and smaller values. 
 class packet; 
    rand bit [15:0] arr[];
	constraint c1 {
	    arr.size() inside {[4:15]};
		foreach(arr[i]) {
		   if(i>0){
		     if(i%2 == 0){
			    arr[i] > arr[i-1];
			 }else {
			    arr[i] < arr[i-1];
			 }
		   }
		}
	}
 endclass

33. write a constraint to generate array of size 10 where only two elements are non-zero 
class packet;
   rand bit[9:0] num;
   rand bit[3:0] arr[];
   
   constraint c1{
       $countones(num) == 2;
	   arr.size() == 10;
	   foreach(num[i]) {
	       if(num[i] == 1) {
		       arr[i] != 0;
		   }else {
		       arr[i] == 0;
		   }
	   }
   }
endclass

34. write a constraint to ensure that all diagonal elements of an array is equals to 1 ?

class diagonal_array;
  rand bit [3:0] arr[][]; // Example 2D dynamic array of 4x4 bits

  // Constraint for size (square matrix)
  constraint c_size {
    arr.size() == 4;
    foreach (arr[i]) arr[i].size() == 4;
  }

  // Constraint to make all diagonal elements = 1
  constraint c_diagonal {
    foreach (arr[i]) arr[i][i] == 1;
  }
endclass

35. write a constraint to randomize a 32bit number such a pattern '10101' appears at random postion in the number while the rest of the values remain 0 ?
class pattern_gen;
  rand bit [31:0] val;
  rand int unsigned pos;

  constraint valid_pos {
    pos inside {[0:27]}; // 32-bit width - 5 bits (pattern length)
  }

  constraint embed_pattern {
    val == (5'b10101 << pos); // Insert pattern at the desired position
  }

  function void display();
    $display("Randomized value: %b", val);
    $display("Position: %0d", pos);
  endfunction
endclass

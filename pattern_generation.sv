*
**
***
****
*****

module pattern;
  int N = 5;
  initial begin
    for (int i = 1; i <= N; i++) begin
      for (int j = 1; j <= i; j++) begin
        $write("*");
      end
      $display();
    end
  end
endmodule


*****
****
***
**
*

module pattern;
  int N = 5;
  initial begin
    for (int i = N; i >= 1; i--) begin
      for (int j = 1; j <= i; j++)
        $write("*");
      $display();
    end
  end
endmodule

1
12
123
1234
12345

module pattern;
  int N = 5;
  initial begin
    for (int i = 1; i <= N; i++) begin
      for (int j = 1; j <= i; j++)
        $write("%0d", j);
      $display();
    end
  end
endmodule

1
22
333
4444
55555

module pattern;
  int N = 5;
  initial begin
   for (int i = 1; i <= 5; i++) begin
      for (int j = 1; j <= i; j++)
         $write("%0d", i);
      $display();
   end
  end
endmodule


12345
1234
123
12
1

for (int i = 5; i >= 1; i--) begin
  for (int j = 1; j <= i; j++)
    $write("%0d", j);
  $display();
end


54321
5432
543
54
5

for (int i = 5; i >= 1; i--) begin
  for (int j = 5; j >= i; j--)
    $write("%0d", j);
  $display();
end


0
01
012
0123
01234

for (int i = 0; i < 5; i++) begin
  for (int j = 0; j <= i; j++)
    $write("%0d", j);
  $display();
end


1
01
101
0101
10101

for (int i = 0; i < 5; i++) begin
  for (int j = 0; j <= i; j++) begin
    if ((i+j) % 2 == 0)
      $write("1");
    else
      $write("0");
  end
  $display();
end


1
10
101
1010
10101

for (int i = 1; i <= 5; i++) begin
  for (int j = 1; j <= i; j++) begin
    if (j % 2 == 1)
      $write("1");
    else
      $write("0");
  end
  $display();
end


1
23
456
78910

int num = 1;
for (int i = 1; i <= 4; i++) begin
  for (int j = 1; j <= i; j++) begin
    $write("%0d", num);
    num++;
  end
  $display();
end


5
54
543
5432
54321

for (int i = 1; i <= 5; i++) begin
  for (int j = 5; j >= 6-i; j--)
    $write("%0d", j);
  $display();
end


1
22
333
4444
55555
666666

for (int i = 1; i <= 6; i++) begin
  for (int j = 1; j <= i; j++)
    $write("%0d", i);
  $display();
end


    *
   ***
  *****
 *******
*********

int N = 5;
for (int i = 1; i <= N; i++) begin
  // Spaces
  for (int j = 1; j <= N-i; j++)
    $write(" ");
  // Stars
  for (int j = 1; j <= (2*i-1); j++)
    $write("*");
  $display();
end


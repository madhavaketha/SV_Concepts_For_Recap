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


*********
 *******
  *****
   ***
    *

int N = 5;
for (int i = N; i >= 1; i--) begin
  for (int j = 1; j <= N-i; j++)
    $write(" ");
  for (int j = 1; j <= 2*i-1; j++)
    $write("*");
  $display();
end

// DAIMOND 
    *
   ***
  *****
 *******
*********
 *******
  *****
   ***
    *

int N = 5;
// Upper half
for (int i = 1; i <= N; i++) begin
  for (int j = 1; j <= N-i; j++)
    $write(" ");
  for (int j = 1; j <= 2*i-1; j++)
    $write("*");
  $display();
end

// Lower half
for (int i = N-1; i >= 1; i--) begin
  for (int j = 1; j <= N-i; j++)
    $write(" ");
  for (int j = 1; j <= 2*i-1; j++)
    $write("*");
  $display();
end

//Floyd's triangle
1
23
456
78910
1112131415

int N = 5;
int num = 1;
for (int i = 1; i <= N; i++) begin
  for (int j = 1; j <= i; j++) begin
    $write("%0d ", num);
    num++;
  end
  $display();
end


1
121
12321
1234321
123454321

int N = 5;
for (int i = 1; i <= N; i++) begin
  // Increasing part
  for (int j = 1; j <= i; j++)
    $write("%0d", j);
  // Decreasing part
  for (int j = i-1; j >= 1; j--)
    $write("%0d", j);
  $display();
end

// BY using an array
int a[5] = '{1,2,3,4,5};
for (int i = 0; i < 5; i++) begin
  for (int j = 0; j <= i; j++)
    $write("%0d", a[j]);
  for (int j = i-1; j >= 0; j--)
    $write("%0d", a[j]);
  $display();
end


1 0 0 0
1 1 0 0
1 1 1 0
1 1 1 1

int a[4][4];
initial begin
  for (int i = 0; i < 4; i++) begin
    for (int j = 0; j < 4; j++) begin
      if (j <= i)
        a[i][j] = 1;
      else
        a[i][j] = 0;
      $write("%0d ", a[i][j]);
    end
    $display();
  end
end


1 1 1 1
0 1 1 1
0 0 1 1
0 0 0 1

for (int i = 0; i < 4; i++) begin
  for (int j = 0; j < 4; j++) begin
    if (j >= i)
      $write("1 ");
    else
      $write("0 ");
  end
  $display();
end


1 0 0 0
0 1 0 0
0 0 1 0
0 0 0 1

for (int i = 0; i < 4; i++) begin
  for (int j = 0; j < 4; j++) begin
    if (i == j)
      $write("1 ");
    else
      $write("0 ");
  end
  $display();
end


1 0 1 0
0 1 0 1
1 0 1 0
0 1 0 1

for (int i = 0; i < 4; i++) begin
  for (int j = 0; j < 4; j++) begin
    if ((i+j) % 2 == 0)
      $write("1 ");
    else
      $write("0 ");
  end
  $display();
end

//Hallow Square 
*****
*   *
*   *
*   *
*****

int N = 5;
for (int i = 0; i < N; i++) begin
  for (int j = 0; j < N; j++) begin
    if (i == 0 || i == N-1 ||
        j == 0 || j == N-1)
      $write("*");
    else
      $write(" ");
  end
  $display();
end

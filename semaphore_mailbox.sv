//Semaphores in SystemVerilog
//A semaphore is a synchronization object used to control access to shared resources.
//It is essentially a "token counter."
//When a process wants to use a shared resource, it waits to acquire a token from the semaphore.
//When done, it releases the token back.
//
//👉 Key points:
//Created using semaphore my_sem = new(n);
//n = number of tokens (how many processes can use the resource at a time).
//Methods:
//.get(n) → Acquires n tokens (waits if not available).
//.put(n) → Releases n tokens.
//.try_get(n) → Tries to acquire without waiting.
//
//✅ Use case:
//Suppose multiple drivers want to access a shared bus (like I²C, SPI). To avoid conflicts, a semaphore ensures only one driver at a time gets access.

semaphore bus_sem;
initial begin
  bus_sem = new(1); // Only 1 token, single driver can access at a time
end

task drive_on_bus();
  bus_sem.get(1);   // Acquire the bus
  $display("Driver %0d got the bus", $time);
  #10;              // Driving activity
  bus_sem.put(1);   // Release the bus
end

//Mailboxes in SystemVerilog
//A mailbox is a communication mechanism between processes.
//Think of it as a message queue.
//One process puts messages into the mailbox, another gets messages.
//Messages can be any object or data.
//
//👉 Key points:
//Created using mailbox my_mbox = new(size);
//size = max number of messages (if omitted, infinite).
//Methods:
//.put(msg) → Places a message in the mailbox.
//.get(msg) → Retrieves a message (waits if empty).
//.try_get(msg) → Retrieves if available (non-blocking).
//.peek(msg) → Reads without removing.
//
//✅ Use case:
//Used to pass transactions between generator → driver in a testbench.

mailbox gen2drv;
initial begin
  gen2drv = new(); // Infinite size
end
// Generator
task generator();
  transaction t;
  t = new();
  t.randomize();
  gen2drv.put(t);  // Send transaction
  $display("Generator sent transaction");
endtask

// Driver
task driver();
  transaction t;
  gen2drv.get(t);  // Receive transaction
  $display("Driver received transaction");
endtask

//🔑 Difference:
//| Feature  | Semaphore                         | Mailbox                                    |
//| -------- | --------------------------------- | ------------------------------------------ |
//| Purpose  | Synchronization (managing access) | Communication (message passing)            |
//| Data     | Just tokens (no data)             | Stores & transfers data/objects            |
//| Blocking | Waits until token is free         | Waits until message is available           |
//| Use Case | Shared bus, limited resources     | Generator to driver, monitor to scoreboard |
//
//
//👉 Summary:
//Semaphore = traffic signal 🚦 (controls access to a limited resource).
//Mailbox = post box 📮 (passes messages/transactions between processes).

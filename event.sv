//In SystemVerilog, an event is a synchronization mechanism used to coordinate activities between different processes (threads) in simulation.
//It doesn’t store any value; it simply acts as a signal to indicate that something has happened.
//
//1. Declaring and Triggering an Event
//Declaration
//event my_event;
//
//Triggering (Firing) the Event
//Use the -> operator:
//-> my_event;       // Trigger the event


//You can also trigger events with a variable:
//event done;
//-> done;  // triggers the "done" event
//
//2. Waiting for an Event
//There are two main ways to wait for an event:
//
//(a) Edge-Sensitive Event Control (@)
//@(my_event);       // Wait until the event is triggered
//
//
//Behavior: Waits for the next trigger of the event.
//Edge-sensitive: If the event was already triggered before this statement, the process will still wait for the next trigger.
//
//Example:
event my_event;

initial begin
    #10 -> my_event; // Trigger at 10ns
    #10 -> my_event; // Trigger again at 20ns
end

initial begin
    @(my_event); // Waits for first trigger (10ns)
    $display("First trigger detected at %0t", $time);
    @(my_event); // Waits for second trigger (20ns)
    $display("Second trigger detected at %0t", $time);
end

//(b) Level-Sensitive Event Control (wait)
//wait (my_event.triggered);
//
//Behavior: Checks the current state of the event.
//If the event is already triggered, it won’t wait and will proceed immediately.
//If not triggered yet, it waits until triggered.

//Example:
event my_event;

initial begin
    #10 -> my_event; // Trigger at 10ns
end

initial begin
    #5 wait(my_event.triggered);  // At 5ns: event not yet triggered, will wait
    $display("Detected trigger at %0t", $time);
end

//3. Key Difference between @ and wait
//| **Aspect**                     | **`@(event)` (Edge-sensitive)**                                 | **`wait(event.triggered)` (Level-sensitive)**                    |
//| ------------------------------ | --------------------------------------------------------------- | ---------------------------------------------------------------- |
//| **Sensitivity**                | Edge-sensitive (waits for the **next trigger**)                 | Level-sensitive (checks current trigger state)                   |
//| **If event already triggered** | Still **waits for next trigger**                                | Proceeds **immediately**                                         |
//| **Use case**                   | Sequential event handling (e.g., multiple triggers in sequence) | Conditional synchronization (e.g., proceed if already triggered) |


//4. Practical Example
//Producer-Consumer Synchronization

event data_ready;
int data;

initial begin : PRODUCER
    #10 data = 42;
    -> data_ready;  // notify consumer
end

initial begin : CONSUMER
    @(data_ready);  // wait until producer triggers
    $display("Data received = %0d at %0t", data, $time);
end

//Summary
//Events are used for process synchronization, not for storing values.
//Triggering is done with -> event_name.
//Edge-sensitive (@) waits for the next trigger.
//Level-sensitive (wait) proceeds if the event is already triggered or waits until it is.

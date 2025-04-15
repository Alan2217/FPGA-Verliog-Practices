/*Consider a finite state machine with inputs s and w. 
Assume that the FSM begins in a reset state called A, as depicted below.
The FSM remains in state A as long as s = 0, and it moves to state B when s = 1. 
Once in state B the FSM examines the value of the input w in the next three clock cycles.
If w = 1 in exactly two of these clock cycles, then the FSM has to set an output z to 1 in 
the following clock cycle. Otherwise z has to be 0. The FSM continues checking w for the next
three clock cycles, and so on. The timing diagram below illustrates the required values of z for different values of w.

Use as few states as possible. Note that the s input is used only in state A, so you need to consider just the w input. */

module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);
    reg [2:0] count,w_new;
    reg [1:0] state, next_state;
    parameter A=0,B=1;
    
    always @(*)
        begin
            case(state)
                A: next_state = s? B:A;
                B: next_state = B;      
            endcase
        end
    always @(posedge clk)
        begin
            if(reset) state<=A;
            else begin
            	state <=next_state;
            end
        end
    always @(posedge clk) begin
        if (reset) begin
            w_new <= 0;
        end
        else if (next_state == B) begin
            w_new <= {w_new[1:0], w};
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
        end
        else if (next_state == B) begin
            if (count == 3) begin
                count <= 1;
            end
            else begin
                count <= count + 1;
            end
        end
    end

    assign z = (count == 1 && (w_new == 3'b011 || w_new == 3'b110 || w_new == 3'b101));
endmodule

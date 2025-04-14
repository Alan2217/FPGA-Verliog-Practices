/*Implement a Mealy-type finite state machine that recognizes the sequence "101" on an input signal named x.
Your FSM should have an output signal, z, that is asserted to logic-1 when the "101" sequence is detected. 
Your FSM should also have an active-low asynchronous reset.
You may only have 3 states in your state machine. Your FSM should recognize overlapping sequences.*/

module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z ); 
    
    parameter s0=0,s1=1,s2=2;
    reg [2:0] state, next_state;
    always @(*) begin
        case(state)
            s0: next_state = x? s1:s0;
            s1: next_state = x? s1:s2;
            s2: next_state = x? s1:s0;
            default: next_state = 'x;
            
        endcase
    end
    always @(posedge clk, negedge aresetn)
        begin
            if(!aresetn) state <= s0;
            else state <= next_state;
        end
	
    always @(*) begin
        case(state)
        	s0: z=0;
            s1: z=0;
            s2: z=x;
            default: z = 1'bx;
        endcase
    end
endmodule

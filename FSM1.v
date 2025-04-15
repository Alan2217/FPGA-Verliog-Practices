/*Given the state-assigned table shown below, implement the finite-state machine. Reset should reset the FSM to state 000.
Present state
y[2:0]	Next state Y[2:0]	Output z
x=0	x=1
000	000	001	0
001	001	100	0
010	010	001	0
011	001	010	1
100	011	100	1
*/

module top_module (
    input clk,
    input reset,   // Synchronous reset
    input x,
    output z
);
    reg [2:0] p_state,next_state;
    
    
    always @(*)
        begin
            case(p_state)
                3'b000: begin next_state=x? 3'b001:3'b000; z=0; end
                3'b001: begin next_state=x? 3'b100:3'b001; z=0; end
                3'b010: begin next_state=x? 3'b001:3'b010; z=0; end
                3'b011: begin next_state=x? 3'b010:3'b001; z=1; end
                3'b100: begin next_state=x? 3'b100:3'b011; z=1; end
            endcase
        end
    always @(posedge clk)
        begin
            if(reset)  p_state <= 3'b000; 
            else p_state <= next_state;
        end

endmodule

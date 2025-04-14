/*Synchronous HDLC framing involves decoding a continuous bit stream of data to 
look for bit patterns that indicate the beginning and end of frames (packets). 
Seeing exactly 6 consecutive 1s (i.e., 01111110) is a "flag" that indicate frame boundaries.
To avoid the data stream from accidentally containing "flags", the sender inserts a zero after every 5 
consecutive 1s which the receiver must detect and discard. We also need to signal an error if there are 7 or more consecutive 1s.

Create a finite state machine to recognize these three sequences:

0111110: Signal a bit needs to be discarded (disc).
01111110: Flag the beginning/end of a frame (flag).
01111111...: Error (7 or more 1s) (err).
When the FSM is reset, it should be in a state that behaves as though the previous input were 0. */
module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);

    reg [3:0]   state, next_state;
    parameter none=0,s1=1,s2=2,s3=3,s4=4,s5=5,s6=6,error=7, discard=8,flagg=9;
    
    always @(*)
        begin
            case(state)
                none: next_state = in? s1: none;
                s1: next_state = in?s2:none;
                s2: next_state = in?s3:none;
                s3: next_state = in?s4:none;
                s4: next_state = in?s5:none;
                s5: next_state = in?s6:discard;
                s6: next_state = in?error:flagg;
                error: next_state = in? error:none;
                flagg: next_state = in?s1:none;
                discard: next_state = in?s1:none;
                
            endcase
        end
    
    always @(posedge clk)
        begin
            if(reset) state <= none;
            else state <= next_state;
        end
    
    assign disc = (state==discard);
    assign flag = (state==flagg);
    assign err = (state ==error);
endmodule

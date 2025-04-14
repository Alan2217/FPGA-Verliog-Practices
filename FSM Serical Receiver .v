/*In many (older) serial communications protocols,
each data byte is sent along with a start bit and a stop bit, 
to help the receiver delimit bytes from the stream of bits.
One common scheme is to use one start bit (0), 8 data bits, 
and 1 stop bit (1). The line is also at logic 1 when nothing is being transmitted (idle).


Design a finite state machine that will identify when bytes have been 
correctly received when given a stream of bits. It needs to identify the start bit, 
wait for all 8 data bits, then verify that the stop bit was correct. 
If the stop bit does not appear when expected, the FSM must wait until it finds 
a stop bit before attempting to receive the next byte. */

module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 
    reg [2:0] state, next_state;
    reg [3:0] i;
    parameter start=0, receive=1,d=2,error=3;
    always @(*)
        begin
            case(state)
                start: next_state=in? start:receive;
                receive: begin
                    if(in&(i==8)) next_state = d;
                    else if((!in)&(i==8)) next_state = error;
                    else next_state = receive;
                    end
                d: next_state = in ? start:receive;
                error: next_state = in ? start:error;
            endcase
        end
    
    always @(posedge clk)
        begin
            if(reset) begin state <= start; i<=0; end
            else begin
                if((state==error)|(state==d)) i<=0;
                else if(state==receive&(i<8)) i<= i+1;
                
                state <= next_state;
            end
        end
    
    assign done=(state==d);
endmodule

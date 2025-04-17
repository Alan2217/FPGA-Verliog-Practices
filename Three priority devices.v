/*This FSM acts as an arbiter circuit, which controls access to some type of resource by three requesting devices.
Each device makes its request for the resource by setting a signal r[i] = 1, where r[i] is either r[1], r[2], or r[3].
Each r[i] is an input signal to the FSM, and represents one of the three devices. The FSM stays in state A as long as 
there are no requests. When one or more request occurs, then the FSM decides which device receives a grant to use the 
resource and changes to a state that sets that device’s g[i] signal to 1. Each g[i] is an output from the FSM. 
There is a priority system, in that device 1 has a higher priority than device 2, and device 3 has the lowest priority. 
Hence, for example, device 3 will only receive a grant if it is the only device making a request when the FSM is in state A.
Once a device, i, is given a grant by the FSM, that device continues to receive the grant as long as its request, r[i] = 1.

Write complete Verilog code that represents this FSM. Use separate always blocks for the state table and the state flip-flops,
as done in lectures. Describe the FSM outputs, g[i], using either continuous assignment statement(s) or an always block 
(at your discretion). Assign any state codes that you wish to use.

*/


module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input [3:1] r,   // request
    output [3:1] g   // grant
); 
    reg [2:0] state, next_state;
    parameter A=0,B=1,C=2,D=3;
    always @(*)
        begin
            case(state)
                A: next_state=r[1]?B:(r[2]?C:(r[3]?D:A));
                B: next_state=r[1]?B:A;
                C: next_state=r[2]?C:A;
                D: next_state=r[3]?D:A;
            endcase
        end
    
    always @(posedge clk)
        begin
            if(~resetn) state <= A;
            else state<=next_state;
        end
    
    assign g[1]=(state==B);
    assign g[2]=(state==C);
    assign g[3]=(state==D);
endmodule

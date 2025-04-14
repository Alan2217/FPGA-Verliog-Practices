//Mealy machine implementation of the 2's complementer.

module top_module (
    input clk,
    input areset,
    input x,
    output z
); 
    parameter A=0, B=1;
    reg [1:0] state,next_state;
    always @(*)
        begin
            case(state)
                A: next_state = x? B:A;
                B: next_state = B;
            endcase
        end
    always @(*)
        begin
            case(state)
                A: z = x;
                B: z = !x;
            endcase
        end
    
    always@(posedge clk,posedge areset)
        begin
            if(areset) state <= A;
            else state <= next_state;
        end

endmodule

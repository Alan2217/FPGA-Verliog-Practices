module top_module (
    input clk,
    input [2:0] y,
    input x,
    output Y0,
    output z
);
    reg [2:0] next_state;
    
    
    always @(*)
        begin
            case(y)
                3'b000: begin next_state=x? 3'b001:3'b000; z=0; Y0 = next_state[0];end
                3'b001: begin next_state=x? 3'b100:3'b001; z=0; Y0 = next_state[0];end
                3'b010: begin next_state=x? 3'b001:3'b010; z=0; Y0 = next_state[0];end
                3'b011: begin next_state=x? 3'b010:3'b001; z=1; Y0 = next_state[0];end
                3'b100: begin next_state=x? 3'b100:3'b011; z=1; Y0 = next_state[0];end
            endcase
        end
    


endmodule


/* A large reservoir of water serves several users. 
In order to keep the level of water sufficientlyhigh, 
three sensors are placed vertically at 5-inch intervals.
When the water level is above the highestsensor (S), 
the input flow rate should be zero. When the level is
below the lowest sensor (S,), the flowrate should be 
at maximum (both Nominal flow valve and Supplemental flow valve opened). 
The flowrate when the level is between the upper and lower sensors is determined by two factors
: the water leveland the level previous to the last sensor change. Each water level has a nominal 
flow rate associated withit, as shown in the table below. If the sensor change indicates that 
  the previous level was lower than thecurrent level, the nominal flow rate should take place. 
  If the previous level was higher than the currentlevel, the flow rate should be increased by 
  opening the Supplemental flow valve (controlled by AFR).Draw the Moore model state diagram for
    the water reservoir controller, Clearly indicate all statetransitions and outputs for each state.
  The inputs to your FSM are S,, Sz and S;; the outputs are FRl,FR2, FR3 and AFR. */
module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 
    parameter A1=0, B1=1,B2=2,C1=3,C2=4,D1=5;
    reg [2:0] state, next;	
    always @(posedge clk) begin
        if(reset) state <=A1;
        else state <= next;
    end
	
    always @(*) begin
        case(state)
            A1: next = s[1] ? B1 : A1;
            B1: next = s[2] ? C1 : (s[1] ? B1:A1);
            B2: next = s[2] ? C1 : (s[1] ? B2:A1);
            C1: next = s[3] ? D1 : (s[2] ? C1:B2);
            C2: next = s[3] ? D1 : (s[2] ? C2:B2);
            D1: next = s[3] ? D1 : C2;
        endcase
    end
    
    always @(*) begin
        case(state)
            A1: {fr3,fr2,fr1,dfr} = 4'b 1111;
            B1: {fr3,fr2,fr1,dfr} = 4'b 0110;
            B2: {fr3,fr2,fr1,dfr} = 4'b 0111;
            C1: {fr3,fr2,fr1,dfr} = 4'b 0010;
            C2: {fr3,fr2,fr1,dfr} = 4'b 0011;
            D1: {fr3,fr2,fr1,dfr} = 4'b 0000;
      
        endcase
    end
endmodule

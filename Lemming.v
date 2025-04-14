//Lemmings can walk, fall, and dig, Lemmings aren't invulnerable. 
//If a Lemming falls for too long then hits the ground, it can splatter. 
//In particular, if a Lemming falls for more than 20 clock cycles then hits the ground, it 
//will splatter and cease walking, falling, or digging (all 4 outputs become 0), 
//forever (Or until the FSM gets reset). There is no upper limit on how far a Lemming can fall before hitting the ground. 
//Lemmings only splatter when hitting the ground; they do not splatter in mid-air.

module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 


    // parameter LEFT=0, RIGHT=1, ...
    reg [2:0]state, next_state;
    reg [31:0] count;
    parameter LEFT=0, RIGHT=1,FALL_L=2, FALL_R=3, DIG_L=4, DIG_R=5, SPLAT=6;
    always @(*) begin
        // State transition logic
        case(state) 
            LEFT: next_state = ground? (dig? DIG_L:(bump_left ? RIGHT : LEFT)) : FALL_L;
            RIGHT: next_state = ground? (dig? DIG_R:(bump_right ? LEFT : RIGHT)) : FALL_R;
            FALL_L: begin
                if(ground) begin
                	if (count >19) next_state = SPLAT; 
                	else  next_state = LEFT;
                end else
                next_state = ground? LEFT: FALL_L;
            end
            FALL_R: begin 
                if(ground) begin
                	if (count >19) next_state = SPLAT; 
                    else      next_state = RIGHT;
                end
                else 
                    next_state = ground? RIGHT : FALL_R;
            end
            DIG_L: 	next_state = ground? DIG_L:FALL_L;
            DIG_R: next_state = ground? DIG_R:FALL_R;
			SPLAT: next_state = SPLAT;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        if(areset) state <= LEFT;
        else if((state == FALL_L) | (state == FALL_R)) begin
            state <= next_state;
            count <= count +1;
        end else begin
            state <= next_state;
            count <= 0;
        end
            
            
    end

    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = ((state == FALL_L) | (state == FALL_R));
    assign digging =(state ==DIG_L)|(state == DIG_R);



endmodule

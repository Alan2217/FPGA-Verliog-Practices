module top_module (
    input clk,
    input areset,
    input x,
    output reg z
); 
    // 状态定义（One-hot / Binary 都可）
    parameter S0 = 2'd0,  // 初始，尚未遇到 1，z=0
              S1 = 2'd1,  // 刚遇到第一个 1，z=1
              S2 = 2'd2,  // 反转中，z=1
              S3 = 2'd3;  // 反转中，z=0

    reg [1:0] state, next_state;

    // 状态转移逻辑
    always @(*) begin
        case (state)
            S0: next_state = (x == 1'b1) ? S1 : S0;
            S1: next_state = (x == 1'b1) ? S3 : S2;
            S2: next_state = (x == 1'b1) ? S3 : S2;
            S3: next_state = (x == 1'b1) ? S3 : S2;
            default: next_state = S0;
        endcase
    end

    // Moore 输出逻辑（只由状态决定）
    always @(*) begin
        case (state)
            S0: z = 0;
            S1: z = 1;
            S2: z = 1;
            S3: z = 0;
            default: z = 0;
        endcase
    end

    // 异步复位 + 状态寄存器更新
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule

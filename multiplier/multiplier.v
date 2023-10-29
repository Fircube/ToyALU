// Booth 变换
module multiplier(
	input signed [15:0]          a,
    input signed [15:0]          b,
    output reg signed [31:0]     mul // 自带符号位拓展
);

    integer i,l;
    reg signed [15:-1] ext_b;
    reg signed [31:0] tmp;
    always @(*) begin
        ext_b = {b,1'b0};
        mul = 0;
        for (i = 0; i < 16; i = i + 2) begin
            l=i+1;
            if (ext_b[l -: 3] == 3'b000 || ext_b[l -: 3] == 3'b111) begin
                tmp = 0;
            end
            else if (ext_b[l -: 3] == 3'b001 || ext_b[l -: 3] == 3'b010) begin
                tmp = (a << i);
            end
            else if (ext_b[l -: 3] == 3'b011) begin
                tmp = (a << (i + 1));
            end
            else if (ext_b[l -: 3] == 3'b100) begin
                tmp = ((~a+1) << (i + 1));
            end
            else if (ext_b[l -: 3] == 3'b101 || ext_b[l -: 3] == 3'b110) begin
                tmp = ((~a+1) << i);
            end
            mul = mul + tmp;
        end
    end
endmodule

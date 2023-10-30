// wallace 3-2压缩
`include "../adder/adder-carry.v"

module multiplier(
	input signed [15:0]          a,
    input signed [15:0]          b,
    output reg signed [31:0]     mul // 自带符号位拓展
);
    integer i,l;
    reg signed [15:-1] ext_b;
    reg [31:0] tmp;
    // 最多8个PP
    reg [31:0] PP1,PP2,PP3,PP4,PP5,PP6,PP7,PP8;
    wire [31:0] s_01,c_01,s_02,c_02,s_11,c_11,s_12,c_12,s_21,c_21,s_31,c_31;
    wire [31:0] ans;

    // level 0
    CSA csa_level01(PP1,PP2,PP3,s_01,c_01);
    CSA csa_level02(PP4,PP5,PP6,s_02,c_02);

    // level 1
    CSA csa_level11(s_01,c_01,s_02,s_11,c_11);
    CSA csa_level12(c_02,PP7,PP8,s_12,c_12);

    // level 2
    CSA csa_level21(s_11,c_11,s_12,s_21,c_21);

    // level 3
    CSA csa_level31(s_21,c_21,c_12,s_31,c_31);

    Add add(s_31,c_31,ans);

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
            if(i==0) begin
                PP1=tmp;
            end
            else if(i==2) begin
                PP2=tmp;
            end
            else if(i==4) begin
                PP3=tmp;
            end
            else if(i==6) begin
                PP4=tmp;
            end
            else if(i==8) begin
                PP5=tmp;
            end
            else if(i==10) begin
                PP6=tmp;
            end
            else if(i==12) begin
                PP7=tmp;
            end
            else if(i==14) begin
                PP8=tmp;
            end
            // mul = mul + tmp;
        end
        mul = ans;
    end
endmodule

module CSA(
    input [31:0] x,
    input [31:0] y,
    input [31:0] z,
    output [31:0] s,
    output [31:0] c
);
    assign s = x ^ y ^ z;
    assign c = (x & y | x & z | y & z) << 1;
endmodule
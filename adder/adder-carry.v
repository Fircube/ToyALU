/* ACM Class System (I) Fall Assignment 1 
 *
 *
 * Implement your naive adder here
 * 
 * gUIDE:
 *   1. Create a RTL project in Vivado
 *   2. put this file into `Sources'
 *   3. put `test_adder.v' into `Simulation Sources'
 *   4. Run Behavioral Simulation
 *   5. Make sure to run at least 100 steps during the simulation (usually 100ns)
 *   6. You can see the results in `Tcl console'
 *
 */

module Add1(
	input a,
	input b,
	input c_in,

	output s,
	output g,
	output p
);
	assign s=a^b^c_in;
	assign g=a&b;
	assign p=a|b;
endmodule

module CLA_4(
	input [3:0] g,
	input [3:0] p,
	input c_in,

	output gm,
	output pm,
	output [3:0] c_out
);
	assign c_out[0]=g[0]|p[0]&c_in;
	assign c_out[1]=g[1]|p[1]&g[0]|p[1]&p[0]&c_in;
	assign c_out[2]=g[2]|p[2]&g[1]|p[2]&p[1]&g[0]|p[2]&p[1]&p[0]&c_in;
	assign c_out[3]=g[3]|p[3]&g[2]|p[3]&p[2]&g[1]|p[3]&p[2]&p[1]&g[0]|p[3]&p[2]&p[1]&p[0]&c_in;

	assign gm=g[3]|g[2]&p[3]|g[1]&p[3]&p[2]|g[0]&p[3]&p[2]&p[1];
	assign pm=p[3]&p[2]&p[1]&p[0];
endmodule

module Add4(
	input [3:0] a,
	input [3:0] b,
	input c_in,

	output [3:0] s,
	output gm,
	output pm,
	output c_out
);
	wire [3:0] g;
	wire [3:0] p;
	wire [3:0] co;

	Add1	a1	(.a(a[0]),.b(b[0]),.c_in(c_in),.s(s[0]),.g(g[0]),.p(p[0])),
			a2	(.a(a[1]),.b(b[1]),.c_in(co[0]),.s(s[1]),.g(g[1]),.p(p[1])),
			a3	(.a(a[2]),.b(b[2]),.c_in(co[1]),.s(s[2]),.g(g[2]),.p(p[2])),
			a4	(.a(a[3]),.b(b[3]),.c_in(co[2]),.s(s[3]),.g(g[3]),.p(p[3]));
	
	CLA_4	c	(.g(g),.p(p),.c_in(c_in),.gm(gm),.pm(pm),.c_out(co));

	assign c_out = co[3];
endmodule

module Add16(
	input [15:0]a,
	input [15:0]b,
	input c_in,

	output [15:0] s,
	output gm,
	output pm,
	output c_out
);
	wire [3:0] g;
	wire [3:0] p;
	wire [3:0] co;

	Add4 	a1	(.a(a[3:0]),.b(b[3:0]),.c_in(c_in),.s(s[3:0]),.gm(g[0]),.pm(p[0])),
			a2	(.a(a[7:4]),.b(b[7:4]),.c_in(co[0]),.s(s[7:4]),.gm(g[1]),.pm(p[1])),
			a3	(.a(a[11:8]),.b(b[11:8]),.c_in(co[1]),.s(s[11:8]),.gm(g[2]),.pm(p[2])),
			a4	(.a(a[15:12]),.b(b[15:12]),.c_in(co[2]),.s(s[15:12]),.gm(g[3]),.pm(p[3]));
	
	CLA_4	c	(.g(g),.p(p),.c_in(c_in),.gm(gm),.pm(pm),.c_out(co));
	assign c_out = co[3];
endmodule

module Add(
	// TODO: Write the ports of this module here
	//
	// Hint: 
	//   The module needs 4 ports, 
	//     the first 2 ports are 16-bit unsigned numbers as the inputs of the adder
	//     the third port is a 16-bit unsigned number as the output
	//	   the forth port is a one bit port as the carry flag
	// 
	input [31:0] a,
	input [31:0] b,
	output reg[31:0] sum
);
	wire [1:0] g;
	wire [1:0] p;
	wire [31:0] ans;
	wire c;

	Add16	a1	(.a(a[15:0]),.b(b[15:0]),.c_in(1'b0),.s(ans[15:0]),.gm(g[0]),.pm(p[0])),
			a2	(.a(a[31:16]),.b(b[31:16]),.c_in(g[0]),.s(ans[31:16]),.gm(g[1]),.pm(p[1]));
	
	always @(*) begin
		sum <= ans;
	end
endmodule

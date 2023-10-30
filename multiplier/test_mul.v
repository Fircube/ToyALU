`include "multiplier-wallace.v"

module test_mul;
	wire  signed [31:0] answer;
	reg signed [15:0] a, b;
	reg	signed [31:0] res;

	multiplier mul (a, b, answer);
	
	integer i;
	initial begin
		for(i=1; i<=100; i=i+1) begin
			a[15:0] = $random;
			b[15:0] = $random;
			res		= a * b;
			
			#1;
			$display("TESTCASE %d: %d * %d = %d", i, a, b, answer);

			if (answer !== res[31:0]) begin
				$display("Wrong Answer!");
			end
		end
		$display("Congratulations! You have passed all of the tests.");
		$finish;
	end
endmodule
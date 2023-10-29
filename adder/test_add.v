`include "adder-carry.v"

module test_add;
    reg     [31:0]      a;
    reg     [31:0]      b;
    wire    [31:0]      sum;

	reg	    [31:0]      res;
    Add add(a, b, sum);
    integer i;
    initial begin
		for(i=1; i<=100; i=i+1) begin
			a[31:0] = $random;
			b[31:0] = $random;
			res		= a + b;
			
			#1;
			$display("TESTCASE %d: %d + %d = %d", i, a, b, sum);

			if (sum !== res[31:0]) begin
				$display("Wrong Answer!");
			end
		end
		$display("Congratulations! You have passed all of the tests.");
		$finish;
	end
endmodule
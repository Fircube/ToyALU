/* ACM Class System (I) Fall Assignment 1 
 *
 *
 * Implement your naive adder here
 * 
 * GUIDE:
 *   1. Create a RTL project in Vivado
 *   2. Put this file into `Sources'
 *   3. Put `test_adder.v' into `Simulation Sources'
 *   4. Run Behavioral Simulation
 *   5. Make sure to run at least 100 steps during the simulation (usually 100ns)
 *   6. You can see the results in `Tcl console'
 *
 */

module Add(
	// TODO: Write the ports of this module here
	//
	// Hint: 
	//   The module needs 4 ports, 
	//     the first 2 ports are 16-bit unsigned numbers as the inputs of the adder
	//     the third port is a 16-bit unsigned number as the output
	//	   the forth port is a one bit port as the carry flag
	// 
	input       [31:0]          a,
    input       [31:0]          b,
    output reg  [31:0]          sum
);
	reg g[31:0];
    reg p[31:0];
    reg ans[31:0];
    integer i;
    
    always @(*) begin
        for(i=0;i<32;i=i+1) begin
        	g[i] = a[i]&b[i];
            p[i] = a[i]|b[i];
        end
        ans[0]=1'b0;
        for(i=0;i<31;i=i+1)begin
            ans[i+1]=g[i]|(p[i]&ans[i]);
        end
        for(i=0;i<32;i=i+1)begin
            sum[i]=a[i]^b[i]^ans[i];
        end
    end
endmodule

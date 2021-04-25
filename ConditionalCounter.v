module ConditionalCounter(inputClock, nReset, condition, count, outputClock);
	input inputClock, nReset;
	input [3:0] condition; 
	parameter MAX = 4'd9; // must be < 2^SIZE
	parameter SIZE = 4;
	output reg outputClock;
	output reg [SIZE - 1: 0] count;
	
	always @(negedge inputClock, negedge nReset)
	begin
		if (!nReset)
		begin
			count <= 0;
			outputClock <= 0;
		end
		else if (count == MAX / 2)
		begin
			count <= count + 1;
			outputClock <= 1;
		end
		else if (count >= MAX || (condition == 4'd2 && count >= 4'd3))
		begin
			count <= 0;
			outputClock <= 0;
		end
		else 
		begin
			count <= count + 1;
			outputClock <= outputClock;	
		end
	end
endmodule
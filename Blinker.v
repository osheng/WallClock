
module Blinker(inputValue, outputValue, selected, toggle);
	input [3:0] inputValue, selected;
	input	toggle;
	parameter ME = 4'd0;
	output [3:0] outputValue;

	assign outputValue  = ( ME == selected && toggle) ? 4'd0: inputValue;
endmodule

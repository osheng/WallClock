/*This is the top level module for this project

This project displays the time on the 6 seven-segment-displays.

To set time, use KEY[3] to select and KEY[2] to advance.

*/

module WallClock(SW, KEY, LED, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, CLOCK_50);
	input [9:0] SW;
	input [3:0] KEY;
	input CLOCK_50;

	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output [9:0] LED;
	
	assign LED[9:0] = 10'b11_1111_1111;
	
	wire n_reset, manual_clock, manual_reset, select;
	assign select = KEY[3];
	assign manual_clock = KEY[2];
	assign manual_reset = KEY[1];
	assign n_reset = KEY[0];
	
	
	
	
	localparam NONE_SELECTED = 4'd0;
	localparam SECONDS = 4'd1;
	localparam SECONDSx10 = 4'd2;
	localparam MINUTES = 4'd3;
	localparam MINUTESx10 = 4'd4;
	localparam HOURS = 4'd5;
	localparam HOURSx10 = 4'd6;


// Changing time with FSM	
//	always @(negedge KEY[3])
//	begin
//		case (selected)
//		NONE_SELECTED: selected = SECONDS;  
//		SECONDS: selected = SECONDSx10;
//		SECONDSx10: selected = MINUTES;
//		MINUTES: selected = MINUTESx10;
//		MINUTESx10: selected = HOURS;
//		HOURS: selected = HOURSx10;
//		HOURSx10: selected = NONE_SELECTED;
//		default:selected = NONE_SELECTED;
//		endcase
//	end

// Changing time with combinational logic
	wire [3:0] selected;
	assign selected = KEY[3:0];
	
	
	localparam SIZE = 26;

	wire [SIZE - 1:0] gargbage;
	wire [3:0] second_count;
	wire [3:0] decasecond_count;
	wire [3:0] minute_count;
	wire [3:0] decaminute_count;
	wire [3:0] hour_count;
	wire [3:0] decahour_count;
	
	wire decisecond_clock, second_clock, decasecond_clock,
			minute_clock, decaminute_clock, hour_clock, decahour_clock;


	wire pause_switch;
	assign pause_switch = SW[9];

	wire n_reset_button;
	assign n_reset_button = KEY[0];
	
	defparam decisecond_counter.MAX = 26'd49_999_999;
	defparam decisecond_counter.SIZE = SIZE;

	Counter decisecond_counter(.inputClock(CLOCK_50 || pause_switch),
		.nReset(n_reset), .count(garbage), .outputClock(decisecond_clock));

	Counter second_counter(.inputClock(decisecond_clock || ((selected == SECONDS) && manual_clock)),
		.nReset(n_reset || ((selected == SECONDS) && manual_reset)),
		.count(second_count), .outputClock(second_clock));

	defparam decasecond_counter.MAX = 6 - 1;
	Counter decasecond_counter(.inputClock(second_clock || (selected == SECONDSx10) && manual_clock),
		.nReset(n_reset || ((selected == SECONDSx10) && manual_reset)),
		.count(decasecond_count), .outputClock(decasecond_clock));
		
	Counter minute_counter(.inputClock(decasecond_clock || (selected == MINUTES) && manual_clock),
		.nReset(n_reset || ((selected == MINUTES) && manual_reset)),
		.count(minute_count), .outputClock(minute_clock));
	
	defparam decaminute_counter.MAX = 6 - 1;
	Counter decaminute_counter(.inputClock(minute_clock || (selected == MINUTESx10) && manual_clock),
		.nReset(n_reset || ((selected == MINUTESx10) && manual_reset)), 
		.count(decaminute_count), .outputClock(decaminute_clock));
	
	ConditionalCounter hour_counter(.inputClock(decaminute_clock || ((selected == HOURS) && manual_clock)),
		.nReset(n_reset || ((selected == HOURS) && manual_reset)),
		.condition(decahour_count), .count(hour_count), .outputClock(decahour_clock));
	
	defparam decahour_counter.MAX = 3 - 1;
	Counter decahour_counter(.inputClock(hour_clock || ((selected == HOURSx10) && manual_clock)),
		.nReset(n_reset || ((selected == SECONDS) && manual_reset)),
		.count(decahour_count), .outputClock(decahour_clock));
	
	wire [3:0] display0_input, display1_input, display2_intput, 
		display3_input, display4_input, display5_input;
	
	defparam blinker0.ME = SECONDS;
	Blinker blinker0(.inputValue(second_count), .outputValue(display0_input), 
		.selected(selected), .toggle(second_clock));
	
	defparam blinker1.ME = SECONDSx10;
	Blinker blinker1(.inputValue(decasecond_count), .outputValue(display1_input), 
		.selected(selected), .toggle(second_clock));
	
	defparam blinker2.ME = MINUTES;
	Blinker blinker2(.inputValue(minute_count), .outputValue(display2_input), 
		.selected(selected), .toggle(second_clock));
	
	defparam blinker3.ME = MINUTESx10;
	Blinker blinker3(.inputValue(decaminute_count), .outputValue(display3_input), 
		.selected(selected), .toggle(second_clock));
		
	defparam blinker4.ME = HOURS;
	Blinker blinker4(.inputValue(hour_count), .outputValue(display4_input), 
		.selected(selected), .toggle(second_clock));
	
	defparam blinker5.ME = HOURSx10;
	Blinker blinker5(.inputValue(decahour_count), .outputValue(display5_input), 
		.selected(selected), .toggle(second_clock));
	

	HexDisplayTranslator display0(.binInput(display0_input), .hexDisplayOutput(HEX0));
	HexDisplayTranslator display1(.binInput(display1_input), .hexDisplayOutput(HEX1));
	HexDisplayTranslator display2(.binInput(display2_input), .hexDisplayOutput(HEX2));
	HexDisplayTranslator display3(.binInput(display3_input), .hexDisplayOutput(HEX3));
	HexDisplayTranslator display4(.binInput(display4_input), .hexDisplayOutput(HEX4));
	HexDisplayTranslator display5(.binInput(display5_input), .hexDisplayOutput(HEX5));

endmodule
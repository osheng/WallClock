/*Converts 4-digit binary numbers for
 displaying on a seven segment display in hexedecimal*/

module HexDisplayTranslator(binInput, hexDisplayOutput);
    input [3:0] binInput;
    output reg [6:0] hexDisplayOutput;

    always @(*)
        case (binInput)
            4'h0: hexDisplayOutput = 7'b100_0000;
            4'h1: hexDisplayOutput = 7'b111_1001;
            4'h2: hexDisplayOutput = 7'b010_0100;
            4'h3: hexDisplayOutput = 7'b011_0000;
            4'h4: hexDisplayOutput = 7'b001_1001;
            4'h5: hexDisplayOutput = 7'b001_0010;
            4'h6: hexDisplayOutput = 7'b000_0010;
            4'h7: hexDisplayOutput = 7'b111_1000;
            4'h8: hexDisplayOutput = 7'b000_0000;
            4'h9: hexDisplayOutput = 7'b001_1000;
            4'hA: hexDisplayOutput = 7'b000_1000;
            4'hB: hexDisplayOutput = 7'b000_0011;
            4'hC: hexDisplayOutput = 7'b100_0110;
            4'hD: hexDisplayOutput = 7'b010_0001;
            4'hE: hexDisplayOutput = 7'b000_0110;
            4'hF: hexDisplayOutput = 7'b000_1110;
            default: hexDisplayOutput = 7'h7f;
        endcase
endmodule

// SevenSeg module:
// Provided a 5-bit binary value, between 00000 - 11111, this module will return the 7-bit output signal
// to properly display the number in Hexadecimal. 

module SevenSeg (num_bi, num_disp);
	input [4:0] num_bi; // 5-bit
	output reg [6:0] num_disp; // 7-bit

	// For num_disp, low logic means segment is ON & high logic means segment is OFF

	always @ (num_bi) begin
		case(num_bi)
			5'b00000: begin num_disp <= 7'b0001000; end // A
			5'b00001: begin num_disp <= 7'b0000011; end // b
			5'b00010: begin num_disp <= 7'b1000110; end // C
			5'b00011: begin num_disp <= 7'b0100001; end // d
			5'b00100: begin num_disp <= 7'b0000110; end // E
			5'b00101: begin num_disp <= 7'b0001110; end // F
			5'b00110: begin num_disp <= 7'b0010000; end // g
			5'b00111: begin num_disp <= 7'b0001011; end // h
			5'b01000: begin num_disp <= 7'b1111001; end // I
			5'b01001: begin num_disp <= 7'b1110001; end // J
			5'b01010: begin num_disp <= 7'b0001001; end // K
			5'b01011: begin num_disp <= 7'b1000111; end // L
			5'b01100: begin num_disp <= 7'b0110110; end // M (symbols)
			5'b01101: begin num_disp <= 7'b0101011; end // n 
			5'b01110: begin num_disp <= 7'b0100011; end // o
			5'b01111: begin num_disp <= 7'b0001100; end // p
			5'b10000: begin num_disp <= 7'b0011000; end // q
			5'b10001: begin num_disp <= 7'b0101111; end // r
			5'b10010: begin num_disp <= 7'b0010010; end // S
			5'b10011: begin num_disp <= 7'b0000111; end // t
			5'b10100: begin num_disp <= 7'b1000001; end // U
			5'b10101: begin num_disp <= 7'b1100011; end // v 
			5'b10110: begin num_disp <= 7'b0011011; end // W (symbols)
			5'b10111: begin num_disp <= 7'b0101101; end // x (symbols)
			5'b11000: begin num_disp <= 7'b0011001; end // Y
			5'b11001: begin num_disp <= 7'b0100100; end // Z
			5'b11010: begin num_disp <= 7'b1110111; end // space (_)
			5'b11011: begin num_disp <= 7'b0111111; end // dash (-)
			5'b11100: begin num_disp <= 7'b0110000; end // 3
			default: begin num_disp <= 7'b1111111; end // all off
		endcase
	end

endmodule

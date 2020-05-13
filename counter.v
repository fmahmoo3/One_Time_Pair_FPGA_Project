// counter module:
// This module is used to count up by one for every clock cycle that a button is active. The output is a 5-bit number between
// 00000 and 11010. This module will reset (wrap) to 00000 from 11010 due to 26 letters in alphabet.

module counter(
    // sequential logic variables
    clk, rst, 
    // count activator variable
    count_activator_button, 
    // output count variable
    count_val_out);

    // input variables
    input clk, rst, count_activator_button; // 1-bit
    // output variables
    output reg [4:0] count_val_out; // 5-bit

    always @(posedge clk) begin
        if(rst == 0) begin 
            // rst was clicked, rest count value to 0
            count_val_out <= 5'b00000;
        end
        else if(count_activator_button == 1) begin
            // reset was not pressed and button was pressed
            if(count_val_out == 5'b11010) begin
                // if the current count value is 27, wrap value to 0
                count_val_out <= 5'b00000;
            end
            else begin
                // if the current count value is NOT 27, increase value by 1
                count_val_out <= count_val_out + 1;
            end
        end
    end
endmodule

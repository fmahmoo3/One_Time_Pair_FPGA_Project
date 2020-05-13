// random_num_generator module:
// This module will use an embedded counter module to generate a true random number to the game.
// The input button to this module is active-low and may run for many clock cycles, in which
// time the counter module will increase count while remaining between 0000 and 1111. When this module
// is applied to system with high frequency clocks, the outputted value will truly be random due to the 
// short clock periods.

module random_num_generator(
    // sequential logic variables
    clk, rst, 
    // button input
    button_in, 
    // random number value
    rand_num);

    // input variables
    input clk, rst, button_in; // 1-bit
    // intermediate variable
    wire count_activator_button; // 1-bit
    // outpur variable
    output [4:0] rand_num; // 5-bit

    // assign the button signal sent to the counter as the complement of the button signal inputted
    // to the random_number_generator module because these modules interpret the button signal opposite
    // to eachother (counter button signal is active-1 and rng button signal is active-0)
    assign count_activator_button = ~button_in;

    // 1 instance of the counter module
    counter counter1(clk, rst, count_activator_button, rand_num);

endmodule
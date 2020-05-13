module OTP_Project (
    // hardware inputs
    clk, rst, 
    switch_val, letter_selection_button_unshaped, e_d_crypt_button, 
    // hardware outpts
    led_green, led_red, 
    letter_sensitivity_disp, letter_order_disp, letter_val_disp,
    letter_1_disp, letter_2_disp, letter_3_disp, letter_4_disp);

    input clk, rst, letter_selection_button_unshaped, e_d_crypt_button;
    input [4:0] switch_val;

    output led_green, led_red;
    output [6:0] letter_sensitivity_disp, letter_order_disp, letter_val_disp, letter_1_disp, letter_2_disp, letter_3_disp, letter_4_disp;

    wire letter_selection_button_shaped;

    wire [4:0] switch_val_propagated;
    wire just_loaded_pulse;

    wire [4:0] random_output;

    wire [4:0] cypher_text, cypher_key;
    wire just_encrpyted_pulse;

    wire [4:0] decrypted_text;
    wire just_decrpyted_pulse;

    wire [4:0] letter_sensitivity, letter_order, letter_val, letter_1_out, letter_2_out, letter_3_out, letter_4_out;

    // 1 instance of button shaper module
    button_shaper bs (letter_selection_button_unshaped, clk, rst, letter_selection_button_shaped); 

    // 1 instance of load letters module
    load_letters ll_cool_mj (rst, clk, letter_selection_button_shaped, switch_val, just_loaded_pulse, switch_val_propagated);

    // 1 instance of encryption module
    encryption_module em_sucks_like_blinkie_blinkie (rst, clk, just_loaded_pulse, switch_val_propagated, random_output, cypher_key, just_encrpyted_pulse, cypher_text);

    // 1 instance of random number generator module
    random_num_generator rng_ (clk, rst, letter_selection_button_unshaped, random_output);

    // 1 instance of decryption module
    decryption_module dm_ (rst, clk, just_encrpyted_pulse, cypher_text, cypher_key, just_decrpyted_pulse, decrypted_text);

    // 1 instance of display decoder module
    display_decoder dd_do_you_love (rst, clk, just_decrpyted_pulse, e_d_crypt_button, 
    switch_val_propagated, cypher_text, decrypted_text, 
    letter_sensitivity, letter_order, letter_val, 
    letter_1_out, letter_2_out, letter_3_out, letter_4_out, led_red, led_green);

    // 7 instance of seven seg module
    SevenSeg ss_abu_baker (letter_sensitivity, letter_sensitivity_disp);
    SevenSeg ss_arizzle (letter_order, letter_order_disp);
    SevenSeg ss_wrizzzle (letter_val, letter_val_disp);
    SevenSeg ss_mrizzzzle (letter_1_out, letter_1_disp);
    SevenSeg ss_srizzzzle (letter_2_out, letter_2_disp);
    SevenSeg ss_frizzzzzzzzzzzzzzzle (letter_3_out, letter_3_disp);
    SevenSeg ss_nrizzzzzzzzzzzzlihdihaskdlkajsfklale (letter_4_out, letter_4_disp);

endmodule

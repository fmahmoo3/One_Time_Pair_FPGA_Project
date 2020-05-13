module display_decoder (
    // sequential logic vars
    rst, clk, enable,
    // hardware
    button,
    // display vals
    switch_val_in, encrypted_text, decrypted_text,
    // displays when loading
    letter_sensitivity, letter_order, switch_val_out, 
    // displays fully-loaded
    letter_1_out, letter_2_out, letter_3_out, letter_4_out,
    // LED outputs
    led_red, led_green);

    // input vars
    input rst, clk, enable, button; // 1-bit
    input [4:0] switch_val_in, encrypted_text, decrypted_text; // 5-bit

    // output vars
    //letter sensitivity: L/U indicating upper or lowercase  
    //letter order: 1, 2, 3, 4, to indicate which chaaracter they're inputting
    output reg [5:0] letter_sensitivity, letter_order, switch_val_out, letter_1_out, letter_2_out, letter_3_out, letter_4_out;
    output reg led_green, led_red;

    // helper vars
    reg [4:0] letterE_1_save, letterE_2_save, letterE_3_save, letterE_4_save;
    reg [4:0] letterD_1_save, letterD_2_save, letterD_3_save, letterD_4_save;
    reg [2:0] state; // 3-bit


    //states 0-3 to load each character & state 4 is a state to stay in/wait til rst is pressed
    parameter state_load_l1 = 3'b000, state_load_l2 = 3'b001;
    parameter state_load_l3 = 3'b010, state_load_l4 = 3'b011;
    parameter state_fully_loaded = 3'b100;

    always @(posedge clk) begin
        if(rst == 0) begin
            // if rst is ACTIVE
            state <= state_load_l1;
            led_red <= 0;
            led_green <= 0;

            switch_val_out <= 5'b11011; // (-);;
            letter_sensitivity <= 5'b11011; // (-);
            letter_order <= 5'b11011; // (-);

            letter_1_out <= 5'b11011; // (-);
            letter_2_out <= 5'b11011; // (-);
            letter_3_out <= 5'b11011; // (-);
            letter_4_out <= 5'b11011; // (-);
        end
        else begin
            case (state)
                state_load_l1: begin
                    // do same actions as rst
                    led_red <= 0;
                    led_green <= 0;
                    letter_1_out <= 5'b11011; // (-);
                    letter_2_out <= 5'b11011; // (-);
                    letter_3_out <= 5'b11011; // (-);
                    letter_4_out <= 5'b11011; // (-);

                    letter_order <= 5'b01000;

                    if(switch_val_in > 5'b11010) begin 
			// this is to check if the user has input a valid character value
                        // turn on red LED
                        led_red <= 1;
                        switch_val_out <= 5'b11011;
                    end
                    else begin
                        led_red <= 0;
                        switch_val_out <= switch_val_in;
                    end

                    if (enable == 1) begin
                        // store values  
                        letterE_1_save <= encrypted_text;
                        letterD_1_save <= decrypted_text;
                        state <= state_load_l2;
                    end
                end
                state_load_l2: begin

                    letter_order <= 5'b11001;
                    switch_val_out <= switch_val_in;

                    if(switch_val_in > 5'b11010) begin
                        // turn on red LED
                        led_red <= 1;
                        switch_val_out <= 5'b11011;
                    end
                    else begin
                        led_red <= 0;
                        switch_val_out <= switch_val_in;
                    end

                    if (enable == 1) begin
                        // store values  
                        letterE_2_save <= encrypted_text;
                        letterD_2_save <= decrypted_text;
                        state <= state_load_l3;
                    end
                end
                state_load_l3: begin

                    letter_order <= 5'b11100;

                    if(switch_val_in > 5'b11010) begin
                        // turn on red LED
                        led_red <= 1;
                        switch_val_out <= 5'b11011;
                    end
                    else begin
                        led_red <= 0;
                        switch_val_out <= switch_val_in;
                    end

                    if (enable == 1) begin
                        // store values  
                        letterE_3_save <= encrypted_text;
                        letterD_3_save <= decrypted_text;
                        state <= state_load_l4;
                    end
                end
                state_load_l4: begin

                    letter_order <= 5'b11000;

                    if(switch_val_in > 5'b11010) begin
                        // turn on red LED
                        led_red <= 1;
                        switch_val_out <= 5'b11011;
                    end
                    else begin
                        led_red <= 0;
                        switch_val_out <= switch_val_in;
                    end

                    if (enable == 1) begin
                        // store values  
                        letterE_4_save <= encrypted_text;
                        letterD_4_save <= decrypted_text;
                        state <= state_fully_loaded;
                    end
                end
                state_fully_loaded: begin
                    letter_sensitivity <= 5'b11011; // (-)
                    switch_val_out <= 5'b11011; // (-)
                    letter_order <= 5'b11011; // (-)

                    if( button == 1 ) begin // show encrypted
                        letter_1_out <= letterE_1_save;
                        letter_2_out <= letterE_2_save;
                        letter_3_out <= letterE_3_save;
                        letter_4_out <= letterE_4_save;   
                    end
                    else begin // show decrypted
                        letter_1_out <= letterD_1_save;
                        letter_2_out <= letterD_2_save;
                        letter_3_out <= letterD_3_save;
                        letter_4_out <= letterD_4_save;  
                    end

                    led_red <= 0;
                    led_green <= 1;

                    if (enable == 1) begin
                        state <= state_load_l1;
                    end
                end
            endcase

            if (state != state_fully_loaded) begin
                case(switch_val_in)
                    // u = 5'b10100
                    // l = 5'b01011
                    // s = 5'b10010
                    5'b00000: begin letter_sensitivity <= 5'b10100; end // A
                    5'b00001: begin letter_sensitivity <= 5'b01011; end // b
                    5'b00010: begin letter_sensitivity <= 5'b10100; end // C
                    5'b00011: begin letter_sensitivity <= 5'b01011; end // d
                    5'b00100: begin letter_sensitivity <= 5'b10100; end // E
                    5'b00101: begin letter_sensitivity <= 5'b10100; end // F
                    5'b00110: begin letter_sensitivity <= 5'b01011; end // g
                    5'b00111: begin letter_sensitivity <= 5'b01011; end // h
                    5'b01000: begin letter_sensitivity <= 5'b10100; end // I
                    5'b01001: begin letter_sensitivity <= 5'b10100; end // J
                    5'b01010: begin letter_sensitivity <= 5'b10100; end // K
                    5'b01011: begin letter_sensitivity <= 5'b10100; end // L
                    5'b01100: begin letter_sensitivity <= 5'b10010; end // M (symbols)
                    5'b01101: begin letter_sensitivity <= 5'b01011; end // n 
                    5'b01110: begin letter_sensitivity <= 5'b01011; end // o
                    5'b01111: begin letter_sensitivity <= 5'b01011; end // p
                    5'b10000: begin letter_sensitivity <= 5'b01011; end // q
                    5'b10001: begin letter_sensitivity <= 5'b01011; end // r
                    5'b10010: begin letter_sensitivity <= 5'b10100; end // S
                    5'b10011: begin letter_sensitivity <= 5'b01011; end // t
                    5'b10100: begin letter_sensitivity <= 5'b10100; end // U
                    5'b10101: begin letter_sensitivity <= 5'b01011; end // v 
                    5'b10110: begin letter_sensitivity <= 5'b10010; end // W (symbols)
                    5'b10111: begin letter_sensitivity <= 5'b10010; end // x (symbols)
                    5'b11000: begin letter_sensitivity <= 5'b10100; end // Y
                    5'b11001: begin letter_sensitivity <= 5'b10100; end // Z
                    5'b11010: begin letter_sensitivity <= 5'b10010; end // space (_)
                    default: begin letter_sensitivity <= 5'b11011; end // display a dsh (-)
                endcase     
            end

        end
    end

endmodule


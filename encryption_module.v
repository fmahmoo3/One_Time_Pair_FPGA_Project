module encryption_module (
    // sequential logic vars
    rst, clk, 
    // loading user values vars
    enable, switch_val_in, 
    // input from rng
    rand_num,
    // output to decryption module
    cypher_key, enable_next,
    // output to both modules
    cypher_text);
    
    // input vars
    input rst, clk, enable; // 1-bit
    input [4:0] switch_val_in; // 5-bit
    input [4:0] rand_num; // 5-bit

    // output vars
    output reg enable_next; // 1-bit
    output reg [4:0] cypher_key, cypher_text; // 5-bit
    
    // helper vars
    reg [2:0] state; // 3-bit
    parameter state_load_l1 = 3'b000, state_load_l2 = 3'b001;
    parameter state_load_l3 = 3'b010, state_load_l4 = 3'b011;
    parameter state_fully_loaded = 3'b100;


    always @(posedge clk) begin
	// When reset button is pressed
        if(rst == 0) begin
            enable_next <= 0; // letter hasn't been encrypted yet
            cypher_key <= 0; // random key hasn't been generated
            cypher_text <= 0; // cypher text hasn't been generated
            state <= state_load_l1; // go to first state
        end
	// When reset button is not pressed
        else begin
            case (state)
		// First Character 
                state_load_l1: begin
		    // set enable_next == enable
		    // if enable = 1, letter is loaded & will be encrypted
		    // if enable = 0, letter hasn't been loaded & is not encrypted
                    enable_next <= enable; 

		    // When letter is LOADED --> encrypt
                    if (enable == 1) begin
                        cypher_key = rand_num; // cyper key = random num from RNG module
			
			// Determine Cypertext
			// Check if cypher key is greater than 26 (the last allowed input)
			// If 26 - letter value >= key --> add letter val + key
                        if( (5'b11010 - switch_val_in ) >= cypher_key) begin
                            cypher_text <= switch_val_in + cypher_key;
                        end
			// If 26 - letter < key --> do diff. algorithm to produce random cyphertext
                        else begin
                            cypher_text <= (5'b00000 + cypher_key - (5'b11010 - switch_val_in) - 1);
                        end

			// Go to next state 
                        state <= state_load_l2;
                    end
                end
		// Second Character
                state_load_l2: begin
		    // set enable_next == enable
		    // if enable = 1, letter is loaded & will be encrypted
		    // if enable = 0, letter hasn't been loaded & is not encrypted
                    enable_next <= enable;

		    // When letter is LOADED --> encrypt
                    if (enable == 1) begin
                        cypher_key = rand_num; // cyper key = random num from RNG module

			// Determine Cypertext
			// Check if cypher key is greater than 26 (the last allowed input)
			// If 26 - letter value >= key --> add letter val + key
                        if( (5'b11010 - switch_val_in ) >= cypher_key) begin
                            cypher_text <= switch_val_in + cypher_key;
                        end
			// If 26 - letter < key --> do diff. algorithm to produce random cyphertext
                        else begin
                            cypher_text <= (5'b00000 + cypher_key - (5'b11010 - switch_val_in) - 1);
                        end
			
			// save new cypher key
                        cypher_key <= cypher_key; 

			// Go to next state
                        state <= state_load_l3;
                    end
                end
		// Third Character
                state_load_l3: begin
		    // set enable_next == enable
		    // if enable = 1, letter is loaded & will be encrypted
		    // if enable = 0, letter hasn't been loaded & is not encrypted
                    enable_next <= enable;

		    // When letter is LOADED --> encrypt
                    if (enable == 1) begin
                        cypher_key = rand_num; // cyper key = random num from RNG module

			// Determine Cypertext
			// Check if cypher key is greater than 26 (the last allowed input)
			// If 26 - letter value >= key --> add letter val + key
                        if( (5'b11010 - switch_val_in ) >= cypher_key) begin
                            cypher_text <= switch_val_in + cypher_key;
                        end
			// If 26 - letter < key --> do diff. algorithm to produce random cyphertext
                        else begin
                            cypher_text <= (5'b00000 + cypher_key - (5'b11010 - switch_val_in) - 1);
                        end

			// save new cypher key
                        cypher_key <= cypher_key; 
			
			// Go to next state
                        state <= state_load_l4;
                    end
                end
		// Fourth Character
                state_load_l4: begin
		    // set enable_next == enable
		    // if enable = 1, letter is loaded & will be encrypted
		    // if enable = 0, letter hasn't been loaded & is not encrypted
                    enable_next <= enable;

		    // When letter is LOADED --> encrypt
                    if (enable == 1) begin
                        cypher_key = rand_num; // cyper key = random num from RNG module

			// Determine Cypertext
			// Check if cypher key is greater than 26 (the last allowed input)
			// If 26 - letter value >= key --> add letter val + key
                        if( (5'b11010 - switch_val_in ) >= cypher_key) begin
                            cypher_text <= switch_val_in + cypher_key;
                        end
			// If 26 - letter < key --> do diff. algorithm to produce random cyphertext
                        else begin
                            cypher_text <= (5'b00000 + cypher_key - (5'b11010 - switch_val_in) - 1);
                        end

			// save new cypher key
                        cypher_key <= cypher_key; 

			// Go to next state
                        state <= state_fully_loaded;
                    end
                end
		// All Four Characters Inputted
                state_fully_loaded: begin
		    // set enable_next == enable
		    // if enable = 1, new letter has been loaded
		    // if enable = 0, letter hasn't been loaded 
                    enable_next <= enable;

		    // When enable = 1, new letter is inputted --> start all over from beginning to first char
                    if (enable == 1) begin
                        state <= state_load_l1;
                    end
                end
            endcase
        end
    end
endmodule
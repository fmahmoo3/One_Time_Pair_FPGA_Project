module decryption_module (
    // sequential logic vars
    rst, clk, 
    // loading user values vars
    enable, cypher_text, cypher_key, 
    // output to decoder
    enable_next, decrypted_text);
    
    // input vars
    input rst, clk, enable; // 1-bit
    input [4:0] cypher_text, cypher_key; // 5-bit

    // output vars
    output reg [4:0] decrypted_text; // 5-bit
    output reg enable_next; // 1-bit
    
    // helper vars
    reg [2:0] state; // 3-bit
    parameter state_load_l1 = 3'b000, state_load_l2 = 3'b001;
    parameter state_load_l3 = 3'b010, state_load_l4 = 3'b011;
    parameter state_fully_loaded = 3'b100;


    always @(posedge clk) begin
	// When reset button is pressed
        if(rst == 0) begin
            state <= state_load_l1; // Go to first state
            decrypted_text <= 0;  // decrypted text hasn't been generated
            enable_next <= 0; // letter hasn't been decrypted
        end
	// When reset button is not pressed
        else begin
            case (state)
		// First Character
                state_load_l1: begin
		    // set enable_next == enable
		    // if enable = 1, new letter has been loaded
		    // if enable = 0, letter hasn't been loaded 
                    enable_next <= enable;

		    // When letter is LOADED --> decrypt
                    if (enable == 1) begin

			// Determine Decrypted Text based on cypher text and key comparison
                        if( cypher_text >= cypher_key) begin
                            decrypted_text <= cypher_text - cypher_key;
                        end
                        else begin
                            decrypted_text <= (5'b11010 - (cypher_key - cypher_text - 1));
                        end

			// Go to next state
                        state <= state_load_l2;
                    end
                end
		// Second Character
                state_load_l2: begin
		    // set enable_next == enable
		    // if enable = 1, new letter has been loaded
		    // if enable = 0, letter hasn't been loaded 
                    enable_next <= enable;

                    // When letter is LOADED --> decrypt
                    if (enable == 1) begin

			// Determine Decrypted Text based on cypher text and key comparison
                        if( cypher_text >= cypher_key) begin
                            decrypted_text <= cypher_text - cypher_key;
                        end
                        else begin
                            decrypted_text <= (5'b11010 - (cypher_key - cypher_text - 1));
                        end

			// Go to next state
                        state <= state_load_l3;
                    end
                end
		// Third Character
                state_load_l3: begin
		    // set enable_next == enable
		    // if enable = 1, new letter has been loaded
		    // if enable = 0, letter hasn't been loaded 
                    enable_next <= enable;
                   
                    // When letter is LOADED --> decrypt
                    if (enable == 1) begin

			// Determine Decrypted Text based on cypher text and key comparison
                        if( cypher_text >= cypher_key) begin
                            decrypted_text <= cypher_text - cypher_key;
                        end
                        else begin
                            decrypted_text <= (5'b11010 - (cypher_key - cypher_text - 1));
                        end
                        
			// Go to next state
                        state <= state_load_l4;
                    end
                end
		// Fourth Character
                state_load_l4: begin
		    // set enable_next == enable
		    // if enable = 1, new letter has been loaded
		    // if enable = 0, letter hasn't been loaded 
                    enable_next <= enable;
                                       
                    // When letter is LOADED --> decrypt
                    if (enable == 1) begin

			// Determine Decrypted Text based on cypher text and key comparison
                        if( cypher_text >= cypher_key) begin
                            decrypted_text <= cypher_text - cypher_key;
                        end
                        else begin
                            decrypted_text <= (5'b11010 - (cypher_key - cypher_text - 1));
                        end
                        
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

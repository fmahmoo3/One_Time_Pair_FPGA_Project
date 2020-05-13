module load_letters (
    // sequential logic vars
    rst, clk, 
    // loading user values vars
    button, switch_val_in, 
    // output to encryption module vars
    enable_next,
    // output to bpth modules var
    switch_val_out);
    
    // input vars
    input rst, clk, button; // 1-bit
    input [4:0] switch_val_in; // 5-bit

    // output vars
    output reg enable_next; // 1-bit
    output reg [4:0] switch_val_out; //  5-bit

    // helper vars
    reg [2:0] state; // 3-bit
    parameter state_load_l1 = 3'b000, state_load_l2 = 3'b001;
    parameter state_load_l3 = 3'b010, state_load_l4 = 3'b011;
    parameter state_fully_loaded = 3'b100;

    always @(posedge clk) begin
        if(rst == 0) begin
            // if rst is ACTIVE, switch val out & enable next must be 0
	    //to go into state one after a value is loaded
            enable_next <= 0;
            switch_val_out <= 5'b00000;

            state <= state_load_l1;
        end
        else begin
            case (state)
                state_load_l1: begin
                    enable_next <= 0;  //set enable next to 0 until button is pressed
                    switch_val_out <= switch_val_in;  //switch val out to be switch val in for the first character
                    
                    if (button == 1 && switch_val_in < 5'b11011) begin
			//checks for button press & valid switch value 
                        enable_next <= 1;
                        state <= state_load_l2;
                    end
                end
                state_load_l2: begin
                    enable_next <= 0;
                    switch_val_out <= switch_val_in;

                    if (button == 1 && switch_val_in < 5'b11011) begin
                        enable_next <= 1;
                        state <= state_load_l3;
                    end
                end
                state_load_l3: begin
                    enable_next <= 0;
                    switch_val_out <= switch_val_in;

                    if (button == 1 && switch_val_in < 5'b11011) begin
                        enable_next <= 1;
                        state <= state_load_l4;
                    end
                end
                state_load_l4: begin
                    enable_next <= 0;
                    switch_val_out <= switch_val_in;

                    if (button == 1 && switch_val_in < 5'b11011) begin
                        enable_next <= 1;
                        state <= state_fully_loaded;
                    end
                end
                state_fully_loaded: begin
		    //remains in this state since all characters are loaded 
		    //stays in this state until button is pressed
                    enable_next <= 0;
                    switch_val_out <= switch_val_in;

                    if (button == 1) begin
			//If button is pressed, go back to the first state to looad new letters
                        enable_next <= 1; 
                        state <= state_load_l1;
                    end
                end
            endcase
        end
    end
endmodule

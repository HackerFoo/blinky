module blinky (button, clk_50mhz, led, pwm_led);
   input button;
   input clk_50mhz;
   output [6:0] led;
	output pwm_led;
   reg [6:0] count;
	reg [6:0] pwm_count;
   reg [19:0] 	div;
   reg [2:0] 	hold;
	reg [5:0] display_timer;
	reg carry;
   wire 	clk_slow;

   // NOTE: button and LEDs are inverted
   //   i.e. button depressed => 0, LED on => 0

   assign led = display_timer != 6'b0 ? ~count : (carry ? 6'b0 : ~6'b0);
	assign pwm_led = ~carry;

   // button counter with debouncing logic
   // holding the button causes the counter
   // to automatically increment
   always @ (posedge clk_slow)
     begin
	if(~button)
	  case(hold)
	    0: begin
	       count <= count + 7'b1;
	       hold <= 1;
	    end
	    7: count <= count + 7'b1;
	    default: hold <= hold + 3'b1;
	  endcase
	else hold <= 3'b0;
     end
	  
	always @ (posedge clk_slow)
	begin
		if(~button) display_timer <= ~6'b0;
		else if(display_timer) display_timer = display_timer - 6'b1;
		else display_timer <= 6'b0;
	end

   // clock divider
   always @ (posedge clk_50mhz)
     begin
	div <= div + 20'b1;
     end

	always @ (posedge clk_50mhz)
	begin
		{carry, pwm_count} <= pwm_count + count;
	end
	  
   assign clk_slow = div[19];

endmodule

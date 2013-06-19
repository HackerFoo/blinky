module blinky (button, clk_50mhz, led);
input button;
input clk_50mhz;
output [7:0] led;
reg [7:0] count;
reg [21:0] div;
reg [2:0] hold;
wire clk_12hz;

// NOTE: button and LEDs are inverted
//   i.e. button depressed => 0, LED on => 0

assign led = ~count;

// button counter with debouncing logic
// holding the button causes the counter
// to automatically increment
always @ (posedge clk_12hz)
begin
  if(~button)
	 case(hold)
	   0: begin
		     count = count + 1;
			  hold = 1;
			end
		7: count = count + 1;
		default: hold = hold + 1;
	 endcase
  else hold = 0;
end

// clock divider
always @ (posedge clk_50mhz)
begin
  div = div + 1;
end

assign clk_12hz = div[21];

endmodule

module tb;

parameter	DATABIT_IN=32;
parameter	DATABIT_OUT=32;
parameter	RAM_ADDR_BIT=2;
parameter	RAM_ADDR_MAX=3;

// module bus(clk,rst,a_data,a_valid,b_ready,a_ready,b_data,b_valid);

reg 						clk,rst,a_valid,b_ready;
reg 	[DATABIT_IN-1:0]	a_data;
wire						a_ready,b_valid;
wire	[DATABIT_OUT-1:0]	b_data;


initial	begin
clk=1'b0;
rst=1'b0;
b_ready=1'd1;a_valid=1'd0;
#30 rst=1'b1; 
#210
// b_ready=1'd0;
a_valid=1'd1;
#(20*(RAM_ADDR_MAX+1))
a_valid=1'd0;
#21
b_ready=1'd0;
end 


integer seed1;
always	#20 a_data=$random(seed1)%400;//2的32次方-1

always	#10 clk=~clk;


bus top(clk,rst,a_data,a_valid,b_ready,a_ready,b_data,b_valid);

endmodule

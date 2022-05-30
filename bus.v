module bus(clk,rst,a_data,a_valid,b_ready,a_ready,b_data,b_valid);

parameter	DATABIT_IN=32;	//值为a_data的bit
parameter	DATABIT_OUT=32;	//值为b_data的bit
parameter	RAM_ADDR_BIT=2;	//值为floor（lg（RAM_ADDR_MAX））
parameter	RAM_ADDR_MAX=3;	//值为输入输出数据的周期数-1

input						clk,rst,a_valid,b_ready;
input	[DATABIT_IN-1:0]	a_data;
output						a_ready,b_valid;
output	[DATABIT_OUT-1:0]	b_data;
reg							a_ready,b_valid;
reg		[DATABIT_OUT-1:0]	b_data;

reg 						a_valid_delay1,b_ready_delay1;
reg 	[DATABIT_IN-1:0]	a_data_delay1;	

reg		[DATABIT_OUT-1:0]	write_data;
reg		[RAM_ADDR_BIT:0]	write_addr;
reg		[RAM_ADDR_BIT:0]	read_addr;
reg							write_en,read_en_t,read_en,read_en_delay1,write_1_time,read_ready;
wire	[DATABIT_OUT-1:0]	read_data;



ram u1 (
  .clka(clk),    
  .wea(write_en),      
  .addra(write_addr), 
  .dina(write_data),    
  .clkb(clk),  
  .enb(read_en),     
  .addrb(read_addr), 
  .doutb(read_data)
);

always@*	write_en=a_valid_delay1;
always@*	write_data=a_data_delay1;

always@(posedge clk)	begin
if(!rst)	begin 
	a_valid_delay1	<=0;
	b_ready_delay1	<=0;
	a_data_delay1	<=0;
	end 
else	begin 
	a_valid_delay1	<=a_valid;
	b_ready_delay1	<=b_ready;
	a_data_delay1	<=a_data;
	end 
end 

//////////////写地址
always@(posedge	clk)	begin
	if(!rst)	write_addr<=0;
	else if(a_valid_delay1)	write_addr<=write_addr+1'd1;
	else 		write_addr<=0;
end 

//////////////读使能信号
always@(posedge	clk)	begin
	if(!rst)	write_1_time<=1'd0;
	else if(a_valid_delay1)	write_1_time<=1'd1;
	else 		write_1_time<=write_1_time;
end 
always@*	read_ready=b_ready_delay1&(~a_valid_delay1)&write_1_time;//当ram里有数据（信号write_1_time==1）且不在写入且下一模块ready信号==1
always@(posedge clk)	begin
	if(!rst)	read_en_t<=1'd0;
	else if(read_ready)		read_en_t<=1'd1;
	else if(read_addr==RAM_ADDR_MAX)	read_en_t<=1'd0;
	else		read_en_t<=read_en_t;
end 
always@*	read_en =read_en_t|read_ready;

//////////////读数据地址
always@(posedge	clk)	begin	//控制valid和call_ready信号,将valid控制在4个周期
	if(!rst )		read_addr<=0;
	else if(read_ready || read_addr)	//外部激励和内部激励
					read_addr<=read_addr+1'd1;
	else	read_addr<=0;
end 

//////////////读有效信号和输出地址
always@(posedge clk)	begin	
	if(!rst)	begin
				read_en_delay1<=1'd0;
				b_valid<=1'd0;
				end 
	else		begin
				read_en_delay1<=read_en;
				b_valid<=read_en_delay1;
				end 
end 

//////////////读数据
always@*	b_data=read_data;



//////////////写请求信号
always@(posedge	clk)	begin
	if(!rst)	a_ready<=1'd1;
	else if(write_addr==RAM_ADDR_MAX)	a_ready<=1'd0;
	else if(read_addr==RAM_ADDR_MAX)		a_ready<=1'd1;
	else		a_ready<=a_ready;
end 
endmodule

/*yinjiamin
May 30, 2022
email:969633962@qq.com
all for free*/

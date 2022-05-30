module ram(
  clka,    // input wire clka
  wea,      // input wire [0 : 0] wea
  addra,  // input wire [1 : 0] addra
  dina,    // input wire [1023 : 0] dina
  clkb,    // input wire clkb
  enb,      // input wire enb *
  addrb,  // input wire [1 : 0] addrb*
  doutb  // output wire [1023 : 0] doutb*
);

parameter	DATABIT_IN=32;
parameter	DATABIT_OUT=32;
parameter	RAM_ADDR_BIT=2;
parameter	RAM_ADDR_MAX=3;

//寄存器48bit*32
input clka, clkb;
input wea, enb;
input[RAM_ADDR_BIT:0] addra, addrb;
input[DATABIT_OUT-1:0] dina;
output reg[DATABIT_OUT-1:0] doutb;


reg[DATABIT_OUT-1:0] memory_ram [0:RAM_ADDR_MAX];
reg[DATABIT_OUT-1:0] reg_out;
wire[1:0] flag;


assign flag = {wea, enb};

//------------write&read-------------
always@(posedge clka)
begin
    case(flag)
    2'b0:begin//idle
        reg_out <= reg_out;
    end
    2'b01:begin//read
        reg_out <= memory_ram[addrb];
    end
    2'b10:begin//write
        memory_ram[addra] <= dina;
    end
    default:begin//readfirst
        memory_ram[addra] <= dina;
        reg_out <= memory_ram[addrb];
    end
    endcase
end


//------------read register-----------
always@(posedge clkb)
begin
    doutb <= reg_out;
end


endmodule
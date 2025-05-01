module Contador # (
    parameter DIV = 4
)
(
    input  wire clk_in,
    input  wire rst_n,
    output reg clk_out
);

    // Insira seu código aqui
    reg [31:0] contador;

    always @(posedge clk_in or negedge rst_n) begin
      if(rst_n === 0) begin
        contador = 32'b0;
        clk_out  = 1'b0;
      end else begin
        if ( contador == (DIV-1) ) begin
          contador = 0;
          clk_out  = ~clk_out;
        end else
          contador = contador + 1;
      end
    end

endmodule

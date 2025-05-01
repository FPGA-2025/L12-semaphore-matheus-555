module Semaphore #(
    parameter CLK_FREQ = 100_000_000
) (
    input wire clk,
    input wire rst_n,

    input wire pedestrian,

    output wire green,
    output wire yellow,
    output wire red
);
    localparam  [1:0]ESTADO_VERMELHO = 2'b00;
    localparam  [1:0]ESTADO_VERDE    = 2'b01;
    localparam  [1:0]ESTADO_AMARELO  = 2'b10;

    localparam  TEMPO_VERMELHO = CLK_FREQ * 5;
    localparam  TEMPO_VERDE    = CLK_FREQ * 7;
    localparam  TEMPO_AMARELO  = CLK_FREQ / 2;

    reg [31:0]tempo;

    reg _green;
    reg _yellow;
    reg _red;

    reg [1:0]estado;
    reg [1:0]proximo_estado;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            estado = ESTADO_VERMELHO;
            tempo = 0;
        end
        else begin
            if (estado != proximo_estado)
                tempo = 0;
            else
                tempo = tempo + 1;

            estado = proximo_estado;
        end
    end

    always @(estado or tempo or pedestrian) begin
        case (estado)
            ESTADO_VERMELHO: begin
                if(tempo >= TEMPO_VERMELHO-1)
                    proximo_estado = ESTADO_VERDE;
                else
                    proximo_estado = ESTADO_VERMELHO;
            end

            ESTADO_VERDE: begin
                if(tempo >= TEMPO_VERDE-1 || pedestrian)
                    proximo_estado = ESTADO_AMARELO;
                else
                    proximo_estado = ESTADO_VERDE;
            end

            ESTADO_AMARELO: begin

                if(tempo >= TEMPO_AMARELO-1)
                    proximo_estado = ESTADO_VERMELHO;
                else
                    proximo_estado = ESTADO_AMARELO;
            end

            default: begin
                proximo_estado = ESTADO_VERMELHO;
            end
        endcase
    end

    always @(*) begin
        _green  = 1'b0;
        _yellow = 1'b0;
        _red    = 1'b0;

        case (estado)
            ESTADO_VERMELHO: begin
                _red = 1'b1;
            end

            ESTADO_VERDE: begin
                _green = 1'b1;
            end

            ESTADO_AMARELO: begin
                _yellow = 1'b1;
            end
        endcase
    end

    assign green  = _green;
    assign yellow = _yellow;
    assign red    = _red;
endmodule

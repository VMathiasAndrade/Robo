module PistaRobos (
    input clk,
    input insere,
    input reset,
    input [3:0] numero,
    output reg led_erro,
    output reg [3:0] EstadoDisplay,
	output reg C1, C2, C3, C4, C5, C6, C7 
);
//declaracao das entradas OK

    parameter S0 = 4'b0000,
              S1 = 4'b0001,
              S2 = 4'b0010,
              S3 = 4'b0011,
              S4 = 4'b0100,
              S5 = 4'b0101,
			  S6 = 4'b1111,
              SP = 4'b0110, // Sucesso Parcial
              F = 4'b0111; // Falha

// definicao dos estados OK



	reg [3:0] TP;
    reg [3:0] EstadoAtual, proxEstado;
    reg [3:0] pista [0:5]; // Pista com os números
    integer posic;
	integer parcial;
//variaveis internas OK

//Inicialização
    initial begin
        pista[0] = 4'b0101;
        pista[1] = 4'b1001;
        pista[2] = 4'b0000;
        pista[3] = 4'b0000;
        pista[4] = 4'b0111;
        pista[5] = 4'b0001;
        EstadoAtual = S0;
     posic = 0;
        led_erro = 0;
		  TP = S0;
		  parcial = 0;
        EstadoDisplay = S0;
    end


    always @(posedge (!insere)) begin
        proxEstado = EstadoAtual;
        case (EstadoAtual)
            S0: if (numero == pista[0]) proxEstado = S1; 
                else proxEstado = SP;
            S1: if (numero == pista[1]) proxEstado = S2; 
                else proxEstado = SP;
            S2: if (numero == pista[2]) proxEstado = S3; 
                else proxEstado = SP;
            S3: if (numero == pista[3]) proxEstado = S4; 
                else proxEstado = SP;
            S4: if (numero == pista[4]) proxEstado = S5; 
                else proxEstado = SP;
            S5: if (numero == pista[5]) proxEstado = S6; 
                else proxEstado = SP;
            SP: if (numero == pista posic) proxEstado = TP;
                else proxEstado = F;
            F: if (reset) proxEstado = S0;
        endcase
		end
    //Logica de prox Estado OK
    
    always @(posedge clk && !insere or posedge reset) begin
        if (reset) begin
            EstadoAtual <= S0;
         posic <= 0;
            led_erro <= 0;
				parcial = 0;
				TP <= S0;

            EstadoDisplay <= S0;
        end else begin
            EstadoAtual = proxEstado;

            case (proxEstado)
                S0: begin
                 posic = 0;
						  TP = S1;
                    EstadoDisplay <= numero; // Exibe o número inserido
                end
                S1: begin
                 posic = 1;
						  TP = S2;
                    EstadoDisplay <= numero; // Exibe o número inserido
                end
                S2: begin
                 posic = 2;
						  TP = S3;
                    EstadoDisplay <= numero; // Exibe o número inserido
                end
                S3: begin
                 posic <= 3;
						  TP = S4;
                    EstadoDisplay <= numero; // Exibe o número inserido
                end
                S4: begin
                 posic = 4;
						  TP = S5;
                    EstadoDisplay <= numero; // Exibe o número inserido
                end
	             S5: begin
                 posic = 5;
						  TP = S6;
                    EstadoDisplay <= numero; // Exibe o número inserido
                end				 
                S6: begin
                 posic = 0;
						  if(led_erro == 1) begin
								EstadoDisplay <= 4'b1011; // Exibe o número inserido no estado de erro
						  end 
						  else begin
								EstadoDisplay <= 4'b1010; // Exibe o número inserido
						  end
                end
                SP: begin
						  if (led_erro == 1) begin
								EstadoDisplay <= 4'b1100; // Exibe o último número inserido, não "F"
						  end
						  parcial = 1;
						  led_erro <= 1; // Um erro cometido

						  EstadoDisplay <= numero;
					 end
                F: begin
                    led_erro <= 1; // Falha final
                    EstadoDisplay <= 4'b1100; // Exibe o último número inserido, não "F"
					 end
            endcase
        end
    end
	//atualização do estado atual e as saídas OK

	 always @(insere) begin

		  case (EstadoDisplay)
            4'b0000: {C1, C2, C3, C4, C5, C6, C7} = 7'b0000001; // '0' - Estado S0
            4'b0001: {C1, C2, C3, C4, C5, C6, C7} = 7'b1001111; // '1' - Estado S1
            4'b0010: {C1, C2, C3, C4, C5, C6, C7} = 7'b0010010; // '2' - Estado S2
            4'b0011: {C1, C2, C3, C4, C5, C6, C7} = 7'b0000110; // '3' - Estado S3
            4'b0100: {C1, C2, C3, C4, C5, C6, C7} = 7'b1001100; // '4' - Estado S4
            4'b0101: {C1, C2, C3, C4, C5, C6, C7} = 7'b0100100; // '5' - Estado S5
			4'b0110: {C1, C2, C3, C4, C5, C6, C7} = 7'b0100000;
			4'b0111: {C1, C2, C3, C4, C5, C6, C7} = 7'b0001111;
			4'b1000: {C1, C2, C3, C4, C5, C6, C7} = 7'b0000000;
			4'b1001: {C1, C2, C3, C4, C5, C6, C7} = 7'b0000100;
            4'b1010: {C1, C2, C3, C4, C5, C6, C7} = 7'b0100100; // '6' - Estado SP
            4'b1011: {C1, C2, C3, C4, C5, C6, C7} = 7'b0011000; // '7' - Estado F
			4'b1100: {C1, C2, C3, C4, C5, C6, C7} = 7'b0111000;
            default: {C1, C2, C3, C4, C5, C6, C7} = 7'b0000000; // Desligado
        endcase
    end

endmodule
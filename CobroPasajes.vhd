library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.all;
--Juan Pablo Ortega
entity CobroPasajes is
    Port (clk,tipocobro,tipopas: in  STD_LOGIC;
           tarjeta,monedas,pasgeneral,pasmedio,cambio,error: out STD_LOGIC;
			  valor: inout integer range 0 to 50;
			  cambiov: out integer range 0 to 50);
end CobroPasajes;

architecture arqpas of CobroPasajes is
    type  estados  is  (A,B,C,D,E); 
	 signal  pres,fut:  estados;	 
begin   
    primer: process(clk,pres,tipocobro,tipopas,valor)
begin
	    case pres is
		     when A =>		  
			     pasgeneral <= '0';
				  pasmedio <= '0';
				  cambio <= '0';
				  error <= '0';
				  tarjeta <= '0'; monedas <= '0';
				  if (tipocobro = '0')then
				      fut <= B;
				  else
				      fut <= C;
				  end if;				  
			  when B => 
			     tarjeta <= '1';
				  monedas <= '0';
				  cambio <= '0';
				  error <= '0';
				  if (tipopas = '1')then
				      pasgeneral <= '0';
						pasmedio <= '1';
				  else
				      pasgeneral <= '1';
						pasmedio <= '0';     
				  end if;
	           fut <= A;
				  
			  when C => 
				  cambio <= '0';
				  tarjeta <= '0';
				  monedas <= '1';
				  error <= '0';
				  if (valor = 15 and tipopas = '1')then
				      pasgeneral <= '0';
						pasmedio <= '1';
						cambiov <= 0;
						fut <= A;
				   else
				    if (valor = 30 and tipopas = '0')then
				      pasgeneral <= '1';
						pasmedio <= '0';
						cambiov <= 0;
						fut <= A;
                else 
				      fut <= D;				  
				   end if; 
				    end if;
				  
			 when D =>
			     --Solo se admite monedas que den el valor de 15-30-50 ctvs
				  cambio <= '1';
				  tarjeta <= '0';
				  monedas <= '1';
				  error <= '0';
				  if (valor = 30 and tipopas = '1')then
				      pasgeneral <= '0';
						pasmedio <= '1';
						cambiov <= 15;
						fut <= A;
				  elsif (valor = 50 and tipopas = '1')then
				      pasgeneral <= '0';
						pasmedio <= '1';
						cambiov <= 35;
						fut <= A;
              elsif (valor = 50 and tipopas = '0')then
				      pasgeneral <= '1';
						pasmedio <= '0';
						cambiov <= 20;
						fut <= A;
              else
				      fut <= E;
				  end if;           			
         when E =>
			     pasgeneral <= '0';
				  pasmedio <= '0'; 
				  cambio <= '0'; 
				  tarjeta <= '0';
				  monedas <= '0';
              error <= '1';
				  fut <= A;			  
	end case; 
	end process primer;
	
	segundo: process (clk) begin
    if(clk' event and clk='1')then 
		   pres <= fut;
		end if;
	  end process segundo;
end arqpas;


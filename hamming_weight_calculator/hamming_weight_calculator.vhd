library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.math_real.all;

---------------------------------------------------------------------------

entity hamming_weight_calculator is
	generic (N: integer := 7); --number of bits of input and output
		port(
			hwc_in: in std_logic_vector(N-1 downto 0);
			hwc_led_out: out std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
			hwc_ssd_out: out std_logic_vector(6 downto 0)
		);
end entity;

---------------------------------------------------------------------------

architecture a_hamming_weight_calculator of hamming_weight_calculator is

	component hamming_calculator is
		port(
			x: in std_logic_vector(N-1 downto 0);
			y: out std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
			integer_out: out integer range 0 to 255
		);
	end component;
	
	component ssd_driver is
		port(
			bcd_in: in std_logic_vector(3 downto 0);
			decimal_out: out std_logic_vector(6 downto 0)
		);
	end component;
	
	signal calc_out_sig: integer range 0 to 255;
	signal driver_in_sig: std_logic_vector(3 downto 0);
	
begin
	
	driver_in_sig <= conv_std_logic_vector(calc_out_sig, 4);	--4 means bits for driver input (BCD)
	
	hwc_calculator: hamming_calculator port map(x=>hwc_in, y=>hwc_led_out, integer_out=>calc_out_sig);
	
	hwc_ssd: ssd_driver port map(bcd_in=>driver_in_sig, decimal_out=>hwc_ssd_out);
	
end architecture;
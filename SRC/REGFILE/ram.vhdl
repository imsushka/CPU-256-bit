LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.config.all;
use work.ds0001.all;
use work.rfiface.all;

entity dpram is
  port (
    inclock   : in  std_logic;
    wraddress : in  std_logic_vector (rfrange);
    wren      : in  std_logic;
    data      : in  std_logic_vector (size_b);
--    inclocken : in std_logic;
    rdaddress : in  std_logic_vector (rfrange);
--    rden      : in  std_logic;
    q         : out std_logic_vector (size_b)
  );
end;

architecture behav of dpram is
  type dregtype is array (0 to 31) of std_logic_vector(size_b);
  signal rfd : dregtype;
--  signal ra : std_logic_vector (rfrange);

begin

  p : process(inclock)
  begin
    if rising_edge(inclock) then
      if wren = '1' then
   	  rfd(conv_integer(unsigned(wraddress))) <= data; 
      end if;
--      if rden = '1' then
          q <= rfd(conv_integer(unsigned(rdaddress)));
--      end if;
    end if;
  end process;

--  q <= rfd(conv_integer(unsigned(rdaddress)));
--  q <= rfd(conv_integer(unsigned(ra)));

end;

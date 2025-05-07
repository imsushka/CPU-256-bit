library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.conv_integer;

entity stack is
  port (
  ra, rd, wr : in std_logic_vector(10 downto 0);
  od : out std_logic
  );
end;

architecture Behavioral of stack is

begin

s : process(ra, rd, wr)

begin
  temp := st;
  case ra(1 downto 0) is
  when "00" => -- stack reg
    if wr = '1' then
      st := rd;
    end if;
  when "01" => -- inc stack
    st   := st + 1;
  when "10" => -- dec stack
    st   := st - 1;
    temp := st;
  when others =>
  end case;
  
  od := temp;
end process;

end;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.conv_integer;

entity comp is
  port (
  r1, r2 : in std_logic_vector(10 downto 0);
  o : out std_logic
  );
end;

architecture Behavioral of comp is

constant RS_NONE     : std_logic_vector(2 downto 0) := "000";
constant RS_BYTE     : std_logic_vector(2 downto 0) := "001";
constant RS_WORD     : std_logic_vector(2 downto 0) := "010";
constant RS_DWORD    : std_logic_vector(2 downto 0) := "011";
constant RS_QWORD    : std_logic_vector(2 downto 0) := "100";
constant RS_OWORD    : std_logic_vector(2 downto 0) := "101";
constant RS_HWORD    : std_logic_vector(2 downto 0) := "110";
constant RS_SQWORD   : std_logic_vector(2 downto 0) := "111";

constant RAS_BYTE    : std_logic_vector(9 downto 0) := "1111111111";
constant RAS_WORD    : std_logic_vector(9 downto 0) := "1111111110";
constant RAS_DWORD   : std_logic_vector(9 downto 0) := "1111111100";
constant RAS_QWORD   : std_logic_vector(9 downto 0) := "1111111000";
constant RAS_OWORD   : std_logic_vector(9 downto 0) := "1111110000";
constant RAS_HWORD   : std_logic_vector(9 downto 0) := "1111100000";

constant ROS_BYTE    : std_logic_vector(10 downto 0) := "00000000000";
constant ROS_WORD    : std_logic_vector(10 downto 0) := "10000000000";
constant ROS_DWORD   : std_logic_vector(10 downto 0) := "11000000000";
constant ROS_QWORD   : std_logic_vector(10 downto 0) := "11100000000";
constant ROS_OWORD   : std_logic_vector(10 downto 0) := "11110000000";
constant ROS_HWORD   : std_logic_vector(10 downto 0) := "11111000000";

constant RS_ZERO_B   : std_logic_vector(  7 downto 0) := (others => '0');
constant RS_ZERO_W   : std_logic_vector( 15 downto 0) := (others => '0');
constant RS_ZERO_D   : std_logic_vector( 31 downto 0) := (others => '0');
constant RS_ZERO_Q   : std_logic_vector( 63 downto 0) := (others => '0');
constant RS_ZERO_O   : std_logic_vector(127 downto 0) := (others => '0');
constant RS_ZERO_H   : std_logic_vector(255 downto 0) := (others => '0');

begin
cmp0 : process(r1, r2)
  variable r1q, r2q : std_logic_vector(9 downto 0);
  variable r1o, r2o : std_logic_vector(9 downto 0);
  variable r1a, r2a : std_logic_vector(9 downto 0);
  variable r1s, r2s : std_logic_vector(2 downto 0);
  variable cmp      : std_logic;

begin
  r1a := (others => '0');
  r2a := (others => '0');
  r1s := (others => '0');
  r2s := (others => '0');
  r1q := (others => '0');
  r2q := (others => '0');
  case r1(10 downto 5) is
  when "111111" => -- special reg
    r1a(4 downto 0) := r1(4 downto 0);
    r1s := RS_SQWORD;
  when "111110" => -- RH reg
    r1a(9 downto 5) := r1(4 downto 0);
    r2q := RAS_HWORD;
    r1s := RS_HWORD;
  when "11110-" => -- RO reg
    r1a(9 downto 4) := r1(5 downto 0);
    r2q := RAS_OWORD;
    r1s := RS_OWORD;
  when "1110--" => -- RQ reg
    r1a(9 downto 3) := r1(6 downto 0);
    r2q := RAS_QWORD;
    r1s := RS_QWORD;
  when "110---" => -- RD reg
    r1a(9 downto 2) := r1(7 downto 0);
    r2q := RAS_DWORD;
    r1s := RS_DWORD;
  when "10----" => -- RW reg
    r1a(9 downto 1) := r1(8 downto 0);
    r2q := RAS_WORD;
    r1s := RS_WORD;
  when "0-----" => -- RB reg
    r1a(9 downto 0) := r1(9 downto 0);
    r2q := RAS_BYTE;
    r1s := RS_BYTE;
  when others =>
    r1s := RS_NONE;
  end case;

  case r2(10 downto 5) is
  when "111111" => -- special reg
    r2a(4 downto 0) := r2(4 downto 0);
    r2s := RS_SQWORD;
  when "111110" => -- RH reg
    r2a(9 downto 5) := r2(4 downto 0);
    r1q := RAS_HWORD;
    r2s := RS_HWORD;
  when "11110-" => -- RO reg
    r2a(9 downto 4) := r2(5 downto 0);
    r1q := RAS_OWORD;
    r2s := RS_OWORD;
  when "1110--" => -- RQ reg
    r2a(9 downto 3) := r2(6 downto 0);
    r1q := RAS_QWORD;
    r2s := RS_QWORD;
  when "110---" => -- RD reg
    r2a(9 downto 2) := r2(7 downto 0);
    r1q := RAS_DWORD;
    r2s := RS_DWORD;
  when "10----" => -- RW reg
    r2a(9 downto 1) := r2(8 downto 0);
    r1q := RAS_WORD;
    r2s := RS_WORD;
  when "0-----" => -- RB reg
    r2a(9 downto 0) := r2(9 downto 0);
    r1q := RAS_BYTE;
    r2s := RS_BYTE;
  when others =>
    r2s := RS_NONE;
  end case;

  r1o := r1a and r1q;
  r2o := r2a and r2q;

  if r1o = r2o then
    cmp := '1';
  else
    cmp := '0';
  end if;

  o <= cmp;
end process;

end;

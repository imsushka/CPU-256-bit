--------------------------------------------------------------------------
--
--  Copyright (C) 1998, Dmitry Sushentsov
--  e-mail:	info @ dspu.info
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 1, or (at your option)
--  any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
--
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--
--  Behavioural architecture of register file.
--
LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.config.all;
use work.ds0001.all;
use work.rfiface.all;

entity rf_mux_in is
  port (
    ain  : in  std_logic_vector(rfrange);
    sin  : in  RSize;
    d    : in  RData;
    mask : out std_logic_vector(ramsize);
    q    : out RData);
end;

architecture behaviour of rf_mux_in is
  
begin

  p: process (ain, sin, d)

    variable qout : RData;
    variable mout : std_logic_vector(ramsize);

  begin
      qout := (others => '0');
      mout := (others => '0');
      case ain(4 downto 0) is
      when "00000" =>
        case sin is
        when RS_BYTE  => qout(byte_00) := d(byte_00); mout( 0) := '1';
        when RS_WORD  => qout(word_00) := d(word_00); mout( 1 downto  0) := "11";
        when RS_DWORD => qout(dword_00) := d(dword_00); mout( 3 downto  0) := "1111";
        when RS_QWORD => qout(qword_00) := d(qword_00); mout( 7 downto  0) := (others => '1');
        when RS_OWORD => qout(oword_00) := d(oword_00); mout(15 downto  0) := (others => '1');
        when RS_HWORD => qout := d; mout(31 downto 0) := (others => '1');
        when others   => null;
        end case;
      when "00001" =>
        case sin is
        when RS_BYTE  => qout(byte_01) := d(byte_00); mout( 1) := '1';
        when others   => null;
        end case;
      when "00010" =>
        case sin is
        when RS_BYTE  => qout(byte_02) := d(byte_00); mout( 2) := '1';
        when RS_WORD  => qout(word_01) := d(word_00); mout( 3 downto  2) := "11";
        when others   => null;
        end case;
      when "00011" =>
        case sin is
        when RS_BYTE  => qout(byte_03) := d(byte_00); mout( 3) := '1';
        when others   => null;
        end case;
      when "00100" =>
        case sin is
        when RS_BYTE  => qout(byte_04) := d(byte_00); mout( 4) := '1';
        when RS_WORD  => qout(word_02) := d(word_00); mout( 5 downto  4) := "11";
        when RS_DWORD => qout(dword_01) := d(dword_00); mout( 7 downto  4) := "1111";
        when others   => null;
        end case;
      when "00101" =>
        case sin is
        when RS_BYTE  => qout(byte_05) := d(byte_00); mout( 5) := '1';
        when others   => null;
        end case;
      when "00110" =>
        case sin is
        when RS_BYTE  => qout(byte_06) := d(byte_00); mout( 6) := '1';
        when RS_WORD  => qout(word_03) := d(word_00); mout( 7 downto  6) := "11";
        when others   => null;
        end case;
      when "00111" =>
        case sin is
        when RS_BYTE  => qout(byte_07) := d(byte_00); mout( 7) := '1';
        when others   => null;
        end case;
      when "01000" =>
        case sin is
        when RS_BYTE  => qout(byte_08) := d(byte_00); mout( 8) := '1';
        when RS_WORD  => qout(word_04) := d(word_00); mout( 9 downto  8) := "11";
        when RS_DWORD => qout(dword_02) := d(dword_00); mout(11 downto  8) := "1111";
        when RS_QWORD => qout(qword_01) := d(qword_00); mout(15 downto  8) := (others => '1');
        when others   => null;
        end case;
      when "01001" =>
        case sin is
        when RS_BYTE  => qout(byte_09) := d(byte_00); mout( 9) := '1';
        when others   => null;
        end case;
      when "01010" =>
        case sin is
        when RS_BYTE  => qout(byte_10) := d(byte_00); mout(10) := '1';
        when RS_WORD  => qout(word_05) := d(word_00); mout(11 downto 10) := "11";
        when others   => null;
        end case;
      when "01011" =>
        case sin is
        when RS_BYTE  => qout(byte_11) := d(byte_00); mout(11) := '1';
        when others   => null;
        end case;
      when "01100" =>
        case sin is
        when RS_BYTE  => qout(byte_12) := d(byte_00); mout(12) := '1';
        when RS_WORD  => qout(word_06) := d(word_00); mout(13 downto 12) := "11";
        when RS_DWORD => qout(dword_03) := d(dword_00); mout(15 downto 12) := "1111";
        when others   => null;
        end case;
      when "01101" =>
        case sin is
        when RS_BYTE  => qout(byte_13) := d(byte_00); mout(13) := '1';
        when others   => null;
        end case;
      when "01110" =>
        case sin is
        when RS_BYTE  => qout(byte_14) := d(byte_00); mout(14) := '1';
        when RS_WORD  => qout(word_07) := d(word_00); mout(15 downto 14) := "11";
        when others   => null;
        end case;
      when "01111" =>
        case sin is
        when RS_BYTE  => qout(byte_15) := d(byte_00); mout(15) := '1';
        when others   => null;
        end case;
      when "10000" =>
        case sin is
        when RS_BYTE  => qout(byte_16) := d(byte_00); mout(16) := '1';
        when RS_WORD  => qout(word_08) := d(word_00); mout(17 downto 16) := "11";
        when RS_DWORD => qout(dword_04) := d(dword_00); mout(19 downto 16) := "1111";
        when RS_QWORD => qout(qword_02) := d(qword_00); mout(23 downto 16) := (others => '1');
        when RS_OWORD => qout(oword_01) := d(oword_00); mout(31 downto 16) := (others => '1');
        when others   => null;
        end case;
      when "10001" =>
        case sin is
        when RS_BYTE  => qout(byte_17) := d(byte_00); mout(17) := '1';
        when others   => null;
        end case;
      when "10010" =>
        case sin is
        when RS_BYTE  => qout(byte_18) := d(byte_00); mout(18) := '1';
        when RS_WORD  => qout(word_09) := d(word_00); mout(19 downto 18) := "11";
        when others   => null;
        end case;
      when "10011" =>
        case sin is
        when RS_BYTE  => qout(byte_19) := d(byte_00); mout(19) := '1';
        when others   => null;
        end case;
      when "10100" =>
        case sin is
        when RS_BYTE  => qout(byte_20) := d(byte_00); mout(20) := '1';
        when RS_WORD  => qout(word_10) := d(word_00); mout(21 downto 20) := "11";
        when RS_DWORD => qout(dword_05) := d(dword_00); mout(23 downto 20) := "1111";
        when others   => null;
        end case;
      when "10101" =>
        case sin is
        when RS_BYTE  => qout(byte_21) := d(byte_00); mout(21) := '1';
        when others   => null;
        end case;
      when "10110" =>
        case sin is
        when RS_BYTE  => qout(byte_22) := d(byte_00); mout(22) := '1';
        when RS_WORD  => qout(word_11) := d(word_00); mout(23 downto 22) := "11";
        when others   => null;
        end case;
      when "10111" =>
        case sin is
        when RS_BYTE  => qout(byte_23) := d(byte_00); mout(23) := '1';
        when others   => null;
        end case;
      when "11000" =>
        case sin is
        when RS_BYTE  => qout(byte_24) := d(byte_00); mout(24) := '1';
        when RS_WORD  => qout(word_12) := d(word_00); mout(25 downto 24) := "11";
        when RS_DWORD => qout(dword_06) := d(dword_00); mout(27 downto 24) := "1111";
        when RS_QWORD => qout(qword_03) := d(qword_00); mout(31 downto 24) := (others => '1');
        when others   => null;
        end case;
      when "11001" =>
        case sin is
        when RS_BYTE  => qout(byte_25) := d(byte_00); mout(25) := '1';
        when others   => null;
        end case;
      when "11010" =>
        case sin is
        when RS_BYTE  => qout(byte_26) := d(byte_00); mout(26) := '1';
        when RS_WORD  => qout(word_13) := d(word_00); mout(27 downto 26) := "11";
        when others   => null;
        end case;
      when "11011" =>
        case sin is
        when RS_BYTE  => qout(byte_27) := d(byte_00); mout(27) := '1';
        when others   => null;
        end case;
      when "11100" =>
        case sin is
        when RS_BYTE  => qout(byte_28) := d(byte_00); mout(28) := '1';
        when RS_WORD  => qout(word_14) := d(word_00); mout(29 downto 28) := "11";
        when RS_DWORD => qout(dword_07) := d(dword_00); mout(31 downto 28) := "1111";
        when others   => null;
        end case;
      when "11101" =>
        case sin is
        when RS_BYTE  => qout(byte_29) := d(byte_00); mout(29) := '1';
        when others   => null;
        end case;
      when "11110" =>
        case sin is
        when RS_BYTE  => qout(byte_30) := d(byte_00); mout(30) := '1';
        when RS_WORD  => qout(word_15) := d(word_00); mout(31 downto 30) := "11";
        when others   => null;
        end case;
      when "11111" =>
        case sin is
        when RS_BYTE  => qout(byte_31) := d(byte_00); mout(31) := '1';
        when others   => null;
        end case;
      when others     => null;
      end case;

      q <= qout;
      mask <= mout;
  end process;

end behaviour;

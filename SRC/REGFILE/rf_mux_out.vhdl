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

entity rf_mux_out is
  port (
    ain : in  std_logic_vector(rfrange);
    sin : in  RSize;
    d   : in  RData;
    q   : out RData
  );
end;

architecture behaviour of rf_mux_out is
  
begin

  p: process (ain, sin, d)

    variable qout : RData;

  begin
      qout := (others => '0');

      case ain(4 downto 0) is
      when "00000" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_00);
        when RS_WORD  => qout(word_00)  := d(word_00);
        when RS_DWORD => qout(dword_00) := d(dword_00);
        when RS_QWORD => qout(qword_00) := d(qword_00);
        when RS_OWORD => qout(oword_00) := d(oword_00);
        when RS_HWORD => qout := d;
        when others  => null;
        end case;
      when "00001" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_01);
        when others  => null;
        end case;
      when "00010" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_02);
        when RS_WORD  => qout(word_00)  := d(word_01);
        when others  => null;
        end case;
      when "00011" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_03);
        when others  => null;
        end case;
      when "00100" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_04);
        when RS_WORD  => qout(word_00)  := d(word_02);
        when RS_DWORD => qout(dword_00) := d(dword_01);
        when others  => null;
        end case;
      when "00101" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_05);
        when others  => null;
        end case;
      when "00110" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_06);
        when RS_WORD  => qout(word_00)  := d(word_03);
        when others  => null;
        end case;
      when "00111" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_07);
        when others  => null;
        end case;
      when "01000" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_08);
        when RS_WORD  => qout(word_00)  := d(word_04);
        when RS_DWORD => qout(dword_00) := d(dword_02);
        when RS_QWORD => qout(qword_00) := d(qword_01);
        when others  => null;
        end case;
      when "01001" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_09);
        when others  => null;
        end case;
      when "01010" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_10);
        when RS_WORD  => qout(word_00)  := d(word_05);
        when others  => null;
        end case;
      when "01011" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_11);
        when others  => null;
        end case;
      when "01100" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_12);
        when RS_WORD  => qout(word_00)  := d(word_06);
        when RS_DWORD => qout(dword_00) := d(dword_03);
        when others  => null;
        end case;
      when "01101" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_13);
        when others  => null;
        end case;
      when "01110" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_14);
        when RS_WORD  => qout(word_00)  := d(word_07);
        when others  => null;
        end case;
      when "01111" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_15);
        when others  => null;
        end case;
      when "10000" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_16);
        when RS_WORD  => qout(word_00)  := d(word_08);
        when RS_DWORD => qout(dword_00) := d(dword_04);
        when RS_QWORD => qout(qword_00) := d(qword_02);
        when RS_OWORD => qout(oword_00) := d(oword_01);
        when others  => null;
        end case;
      when "10001" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_17);
        when others  => null;
        end case;
      when "10010" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_18);
        when RS_WORD  => qout(word_00)  := d(word_09);
        when others  => null;
        end case;
      when "10011" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_19);
        when others  => null;
        end case;
      when "10100" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_20);
        when RS_WORD  => qout(word_00)  := d(word_10);
        when RS_DWORD => qout(dword_00) := d(dword_05);
        when others  => null;
        end case;
      when "10101" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_21);
        when others  => null;
        end case;
      when "10110" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_22);
        when RS_WORD  => qout(word_00)  := d(word_11);
        when others  => null;
        end case;
      when "10111" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_23);
        when others  => null;
        end case;
      when "11000" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_24);
        when RS_WORD  => qout(word_00)  := d(word_12);
        when RS_DWORD => qout(dword_00) := d(dword_06);
        when RS_QWORD => qout(qword_00) := d(qword_03);
        when others  => null;
        end case;
      when "11001" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_25);
        when others  => null;
        end case;
      when "11010" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_26);
        when RS_WORD  => qout(word_00)  := d(word_13);
        when others  => null;
        end case;
      when "11011" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_27);
        when others  => null;
        end case;
      when "11100" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_28);
        when RS_WORD  => qout(word_00)  := d(word_14);
        when RS_DWORD => qout(dword_00) := d(dword_07);
        when others  => null;
        end case;
      when "11101" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_29);
        when others  => null;
        end case;
      when "11110" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_30);
        when RS_WORD  => qout(word_00)  := d(word_15);
        when others  => null;
        end case;
      when "11111" =>
        case sin is
        when RS_BYTE  => qout(byte_00)  := d(byte_31);
        when others  => null;
        end case;
      when others  => null;
      end case;

      q <= qout;
  end process;

end behaviour;

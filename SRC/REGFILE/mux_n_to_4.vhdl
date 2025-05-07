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

entity mux_n_to_4 is
  port (
    blk1 : in  std_logic_vector(blocksize);
    blk2 : in  std_logic_vector(blocksize);
    blk3 : in  std_logic_vector(blocksize);
    blk4 : in  std_logic_vector(blocksize);

    rf   : in  rfoblock;

    rf01 : out rfotyperec;
    rf02 : out rfotyperec;
    rf03 : out rfotyperec;
    rf04 : out rfotyperec
  );
end;

architecture behaviour of mux_n_to_4 is
  
begin

  p: process (blk1, blk2, blk3, blk4, rf)

  variable dd1 : rfotyperec;
  variable dd2 : rfotyperec;
  variable dd3 : rfotyperec;
  variable dd4 : rfotyperec;

  begin
    l: for i in blockrange loop 
      if i = conv_integer(unsigned(blk1)) then
        dd1 := rf(i);
      end if;
      if i = conv_integer(unsigned(blk2)) then
        dd2 := rf(i);
      end if;
      if i = conv_integer(unsigned(blk3)) then
        dd3 := rf(i);
      end if;
      if i = conv_integer(unsigned(blk4)) then
        dd4 := rf(i);
      end if;
    end loop l;

    rf01 <= dd1;
    rf02 <= dd2;
    rf03 <= dd3;
    rf04 <= dd4;
  end process;

end behaviour;

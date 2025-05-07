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

entity mux_n_to_1 is
  port (
    blk  : in  std_logic_vector(blocksize);

    rfi  : in  rfoblock;

    rfo  : out rfotyperec
  );
end;

architecture behaviour of mux_n_to_1 is
  
begin

  p: process (blk, rfi)

  variable dd : rfotyperec;

  begin
    l0: for i in blockrange loop 
      if i = conv_integer(unsigned(blk)) then
        dd := rfi(i);
      end if;
    end loop l0;

    rfo <= dd;
  end process;

end behaviour;

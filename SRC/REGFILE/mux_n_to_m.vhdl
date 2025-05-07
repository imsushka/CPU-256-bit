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

entity mux_n_to_m is
  port (
    blks : in  blocks;

    rf   : in  rfoblock;

    rfs  : out rfocpu
  );
end;

architecture behaviour of mux_n_to_m is
  
begin

  p: process (blks, rf)

  variable dd : rfocpu;

  begin
    lj: for j in cpurange loop 
      dd(j).d1 := (others => '0');
      dd(j).d2 := (others => '0');
      li: for i in blockrange loop 
        if i = conv_integer(unsigned(blks(j))) then
          dd(j).d1 := rf(i).d1;
          dd(j).d2 := rf(i).d2;
        end if;
      end loop li;
    end loop lj;

    rfs <= dd;
  end process;

end behaviour;

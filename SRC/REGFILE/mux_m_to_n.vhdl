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

entity mux_m_to_n is
  port (
    blks : in  blocks;

    rfs  : in  rficpu;

    rf   : out rfiblock
  );
end;

architecture behaviour of mux_m_to_n is
  
begin
  p: process (blks, rfs)

  variable rfti : rfiblock;

  begin
    li: for i in blockrange loop 
      rfti(i).rda1 := (others => '0');
      rfti(i).rds1 := (others => '0');
      rfti(i).rda2 := (others => '0');
      rfti(i).rds2 := (others => '0');
      rfti(i).wra  := (others => '0');
      rfti(i).wrd  := (others => '0');
      rfti(i).wrs  := (others => '0');
      rfti(i).wren := '0';
      lj: for j in cpurange loop 
        if i = conv_integer(unsigned(blks(j))) then
          rfti(i).rda1 := rfti(i).rda1 or rfs(j).rda1;
          rfti(i).rds1 := rfti(i).rds1 or rfs(j).rds1;
          rfti(i).rda2 := rfti(i).rda2 or rfs(j).rda2;
          rfti(i).rds2 := rfti(i).rds2 or rfs(j).rds2;
          rfti(i).wra  := rfti(i).wra  or rfs(j).wra;
          rfti(i).wrd  := rfti(i).wrd  or rfs(j).wrd;
          rfti(i).wrs  := rfti(i).wrs  or rfs(j).wrs;
          rfti(i).wren := rfti(i).wren or rfs(j).wren;
--          rfti(i) := rfs(j);
        end if;
      end loop lj;
    end loop li;

    rf <= rfti;
  end process;
end behaviour;

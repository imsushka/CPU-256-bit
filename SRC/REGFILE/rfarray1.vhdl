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
--use work.ramlib.all;

entity rfarray1 is
  port (
    clk   : in  std_logic;

    blk1  : in  std_logic_vector(blocksize);
    rfai1 : in  rfityperec;
    rfao1 : out rfotyperec
  );
end;

architecture behaviour of rfarray1 is

component mux_1_to_n
  port (
    blk  : in  std_logic_vector(blocksize);

    rfi  : in  rfityperec;

    rfo  : out rfiblock
  );
end component;
  
component mux_n_to_1
  port (
    blk  : in  std_logic_vector(blocksize);

    rfi  : in  rfoblock;

    rfo  : out rfotyperec
  );
end component;

component rf
  port (
    clk  : in std_logic;

    rfin : in  rfityperec;

    rfout: out rfotyperec
  );
end component;

signal rfi  : rfiblock;
signal rfo  : rfoblock;

begin
  m: mux_1_to_n
	port map (blk1, rfai1, rfi);

  r: for i in blockrange generate
    f: rf
	port map (clk, rfi(i), rfo(i));
  end generate;

  d: mux_n_to_1
	port map (blk1, rfo, rfao1);

end behaviour;                                    

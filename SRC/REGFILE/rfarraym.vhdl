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

entity rfarraym is
  port (
    clk   : in  std_logic;

    blk1  : in  std_logic_vector(blocksize);
    rfai1 : in  rfityperec;
    rfao1 : out rfotyperec;

    blk2  : in  std_logic_vector(blocksize);
    rfai2 : in  rfityperec;
    rfao2 : out rfotyperec;

    blk3  : in  std_logic_vector(blocksize);
    rfai3 : in  rfityperec;
    rfao3 : out rfotyperec;

    blk4  : in  std_logic_vector(blocksize);
    rfai4 : in  rfityperec;
    rfao4 : out rfotyperec
  );
end;

architecture behaviour of rfarraym is

component mux_m_to_n
  port (
    blks : in  blocks;

    rfs  : in  rficpu;

    rf   : out rfiblock
  );
end component;
  
component mux_n_to_m
  port (
    blks : in  blocks;

    rf   : in  rfoblock;

    rfs  : out rfocpu
  );
end component;

component rf
  port (
    clk  : in std_logic;

    rfin : in  rfityperec;

    rfout: out rfotyperec
  );
end component;

signal blks : blocks;
signal rfi  : rfiblock;
signal rfo  : rfoblock;
signal rfai : rficpu;
signal rfao : rfocpu;

begin
  blks(0) <= blk1;
--  blks(1) <= blk2;
--  blks(2) <= blk3;
--  blks(3) <= blk4;

  rfai(0) <= rfai1;
--  rfai(1) <= rfai2;
--  rfai(2) <= rfai3;
--  rfai(3) <= rfai4;

  m: mux_m_to_n
	port map (blks, rfai, rfi);

  r: for i in blockrange generate
    f: rf
	port map (clk, rfi(i), rfo(i));
  end generate;

  d: mux_n_to_m
	port map (blks, rfo, rfao);

  rfao1	<= rfao(0);
--  rfao2 <= rfao(1);
--  rfao3 <= rfao(2);
--  rfao4 <= rfao(3);

end behaviour;                                    

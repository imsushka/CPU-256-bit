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

entity rf is
  port (
    clk  : in std_logic;

    rfin : in  rfityperec;

    rfout: out rfotyperec
  );
end;

architecture behaviour of rf is
  
component rf_mux_in
  port (
    ain  : in  std_logic_vector(rfrange);
    sin  : in  RSize;
    d    : in  RData;
    mask : out std_logic_vector(ramsize);
    q    : out RData
  );
end component;

component rf_mux_out
  port (
    ain  : in  std_logic_vector(rfrange);
    sin  : in  RSize;
    d    : in  RData;
    q    : out RData
  );
end component;

component dpram
  port (
    inclock   : in  std_logic;
    wraddress : in  std_logic_vector (rfrange);
    wren      : in  std_logic;
    data      : in  std_logic_vector (size_b);
    rdaddress : in  std_logic_vector (rfrange);
    q         : out std_logic_vector (size_b)
  );
end component;

signal mm  : std_logic_vector(ramsize);
signal qq  : RData;
signal dd1 : RData;
signal dd2 : RData;
signal wr  : std_logic_vector(ramsize);

begin
  m: rf_mux_in
	port map(rfin.wra(addrlo), rfin.wrs, rfin.wrd,  mm, qq);

  r: for i in ramrange generate
    wr(i) <= rfin.wren and mm(i);
    g1: dpram
	port map (clk, rfin.wra(addrhi), wr(i), qq(i*8+7 downto i*8), rfin.rda1(addrhi), dd1(i*8+7 downto i*8));
    g2: dpram
	port map (clk, rfin.wra(addrhi), wr(i), qq(i*8+7 downto i*8), rfin.rda2(addrhi), dd2(i*8+7 downto i*8));
  end generate;

  d1: rf_mux_out
	port map(rfin.rda1(addrlo), rfin.rds1, dd1, rfout.d1);

  d2: rf_mux_out
	port map(rfin.rda2(addrlo), rfin.rds2, dd2, rfout.d2);

end behaviour;

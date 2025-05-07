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

library IEEE;
use IEEE.std_logic_1164.all;
use work.config.all;
use work.ds0001.all;
use work.iu0001.all;
use work.iuiface.all;
library arith_lib;
--use arith_lib.arith_lib.all;

entity iu_stage1 is
  port (
    reset : in  std_logic;
    hold  : in  std_logic;		-- hold PC (Wait DATA CACHE)

    st1   : in  stage1_type;		-- Jump address

    pc    : out SAddress		-- Curent PC
  );
end;

architecture Behavioral of iu_stage1 is

signal r : SAddress;

begin
  r(PCLOW-1 downto 0) <= (others => '0');
--  p0 : inc
--	generic map(62, fast)
--	port map(st1.pc(SAbits-1 downto PCLOW), r(SAbits-1 downto PCLOW));

  st : process(reset, hold, st1, r)
    variable v : SAddress;
  begin
    if reset = '0' then
      v := (others => '0');
      v(SAbits-1 downto SAbits-6) := (others => '1');
    elsif hold = '1' then
      v := st1.pc;
    elsif st1.e = '1' then
      v := st1.eaddr;
    elsif st1.j = '1' then
      v := st1.jaddr;
    elsif st1.b = '1' then
      v := st1.baddr;
    else
      v := r;
    end if;
    pc <= v;
  end process;
end;

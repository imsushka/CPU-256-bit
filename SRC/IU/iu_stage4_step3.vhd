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

entity iu_stage4_step3 is
  port (
    o   : in  std_logic_vector(ops_range);
    t   : in  std_logic_vector(typs_range);
    o1s : out std_logic_vector(1 downto 0);
    o2s : out std_logic_vector(2 downto 0);
    ras : out std_logic_vector(2 downto 0);
    rss : out std_logic;
    cnt : out std_logic_vector(2 downto 0);
    wi  : out std_logic;
    wd  : out std_logic
  );
end;

architecture Behavioral of iu_stage4_step3 is

begin
  m : process(o, t)
  variable qo1s : std_logic_vector(1 downto 0);
  variable qo2s : std_logic_vector(2 downto 0);
  variable qras : std_logic_vector(2 downto 0);
  variable qrss : std_logic;
  variable qcnt : std_logic_vector(2 downto 0);
  variable qwi  : std_logic;
  variable qwd  : std_logic;
  begin
    qo1s := DASIS;
    qo2s := D2ASIS;
    qras := AREG1;
    qrss := SREG1;
    qcnt := STEP0;
    qwi  := '0';
    qwd  := '0';

    case t is
    when B4 | B8 => -- Store REG1 to (Memory)
      qo2s := D2ZERO;
      qras := AOFS;
    when B5 | B9 => -- Store REG2 to (Memory)
      qo1s := DZERO;
      qras := AOFS;
    when B6 | BA =>
      if o = OP_SWAP then
        qcnt := STEP4;
        qo1s := DZERO;
      end if;
      qo2s := D2DATA;
    when B7 | BB =>
      if o = OP_SWAP then
        qcnt := STEP4;
        qo2s := D2ZERO;
        qras := AREG2;
      end if;
      qo1s := DDATA;
    when others => null;
    end case;

    o1s <= qo1s;
    o2s <= qo2s;
    ras <= qras;
    rss <= qrss;
    cnt <= qcnt;
    wi  <= qwi;
    wd  <= qwd;
    
  end process;
end;

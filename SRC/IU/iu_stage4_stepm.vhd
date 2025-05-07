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

entity iu_stage4_stepm is
  port (
    o   : in  std_logic_vector(ops_range);
    t   : in  std_logic_vector(2 downto 0);

    o1s0: in  std_logic_vector(1 downto 0);
    o2s0: in  std_logic_vector(2 downto 0);
    ras0: in  std_logic_vector(2 downto 0);
    rss0: in  std_logic;                   
    cnt0: in  std_logic_vector(2 downto 0);
    wi0 : in  std_logic;
    wd0 : in  std_logic;
    o1s1: in  std_logic_vector(1 downto 0);
    o2s1: in  std_logic_vector(2 downto 0);
    ras1: in  std_logic_vector(2 downto 0);
    rss1: in  std_logic;                   
    cnt1: in  std_logic_vector(2 downto 0);
    wi1 : in  std_logic;
    wd1 : in  std_logic;
    o1s2: in  std_logic_vector(1 downto 0);
    o2s2: in  std_logic_vector(2 downto 0);
    ras2: in  std_logic_vector(2 downto 0);
    rss2: in  std_logic;                   
    cnt2: in  std_logic_vector(2 downto 0);
    wi2 : in  std_logic;
    wd2 : in  std_logic;
    o1s3: in  std_logic_vector(1 downto 0);
    o2s3: in  std_logic_vector(2 downto 0);
    ras3: in  std_logic_vector(2 downto 0);
    rss3: in  std_logic;                   
    cnt3: in  std_logic_vector(2 downto 0);
    wi3 : in  std_logic;
    wd3 : in  std_logic;
    o1s4: in  std_logic_vector(1 downto 0);
    o2s4: in  std_logic_vector(2 downto 0);
    ras4: in  std_logic_vector(2 downto 0);
    rss4: in  std_logic;                   
    cnt4: in  std_logic_vector(2 downto 0);
    wi4 : in  std_logic;
    wd4 : in  std_logic;

    o1s : out std_logic_vector(1 downto 0);
    o2s : out std_logic_vector(2 downto 0);
    ras : out std_logic_vector(2 downto 0);
    rss : out std_logic;                   
    cnt : out std_logic_vector(2 downto 0);
    wi  : out std_logic;
    wd  : out std_logic
  );
end;

architecture Behavioral of iu_stage4_stepm is

begin
  m : process(o, t, o1s0, o2s0, ras0, rss0, cnt0, wi0, wd0,
		o1s1, o2s1, ras1, rss1, cnt1, wi1, wd1,
		o1s2, o2s2, ras2, rss2, cnt2, wi2, wd2,
		o1s3, o2s3, ras3, rss3, cnt3, wi3, wd3,
		o1s4, o2s4, ras4, rss4, cnt4, wi4, wd4)
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
    when STEP0  => qo1s := o1s0; qo2s := o2s0; qras := ras0; qrss := rss0; qcnt := cnt0; qwi := wi0; qwd := wd0;
    when STEP1  => qo1s := o1s1; qo2s := o2s1; qras := ras1; qrss := rss1; qcnt := cnt1; qwi := wi1; qwd := wd1;
    when STEP2  => qo1s := o1s2; qo2s := o2s2; qras := ras2; qrss := rss2; qcnt := cnt2; qwi := wi2; qwd := wd2;
    when STEP3  => qo1s := o1s3; qo2s := o2s3; qras := ras3; qrss := rss3; qcnt := cnt3; qwi := wi3; qwd := wd3;
    when others => qo1s := o1s4; qo2s := o2s4; qras := ras4; qrss := rss4; qcnt := cnt4; qwi := wi4; qwd := wd4;
    end case;

    if o = OP_MOVE then
      qo1s := DZERO;
    end if;

    if o = OP_SPECIAL then
      qo1s := DPC;
    end if;

    o1s <= qo1s;
    o2s <= qo2s;
    ras <= qras;
    rss <= qrss;
    cnt <= qcnt;
    wi  <= qwi;
    wd  <= qwd;
    
  end process;
end;

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

entity iu_st5_sh is
  port (
    op   : in  ALUOp;	-- Alu operation
    op1d : in  IUData;	-- source operand 1
    op1s : in  IUSize;	-- size source operand 1
    op2d : in  IUData;	-- source operand 2
    icci : in  IUICC;	-- integer condition codes
    res  : out IUData;	-- data forward from execute stage
    icco : out IUICC	-- integer condition codes
  );
end;

architecture Behavioral of iu_st5_sh is

begin
  p0 : process(op, op1d, op1s, op2d, icci)

    variable c : std_logic;
    variable o : std_logic;
    variable z : std_logic;
    variable n : std_logic;
    variable ta : std_logic;
    variable tb : std_logic;
    variable tr : std_logic;
    variable a : std_logic_vector(iuddblrange);
    variable b : std_logic_vector(7 downto 0);
    variable r : IUData;

  begin
    n := icci(3);
    z := icci(2);
    o := icci(1);
    c := icci(0);

    b := op2d(7 downto 0);

    a(IUDrange) := op1d;
    a(IUDdblhi) := RS_ZERO_SYS;
    if op = ALU_SLL then -- logic left
      a(IUDrange) := RS_ZERO_SYS;
      a(IUDdblhi) := op1d;
      b := not b;
    end if;
    if op = ALU_SAR then -- right arith
      case op1s is
      when RS_BYTE   => a(IUDbits*2-1 downto   8) := (others => a(  7));
      when RS_WORD   => a(IUDbits*2-1 downto  16) := (others => a( 15));
      when RS_DWORD  => a(IUDbits*2-1 downto  32) := (others => a( 31));
      when RS_QWORD  => a(IUDbits*2-1 downto  64) := (others => a( 63));
      when RS_OWORD  => a(IUDbits*2-1 downto 128) := (others => a(127));
      when RS_HWORD  => a(IUDbits*2-1 downto 256) := (others => a(255));
      when others    => null;
      end case;
    end if;

    if b(7) = '1' then
      a(IUDbits+127 downto 0) := a(IUDbits+255 downto 128);
    end if;
    if b(6) = '1' then
      a(IUDbits+ 63 downto 0) := a(IUDbits+127 downto 64);
    end if;
    if b(5) = '1' then
      a(IUDbits+ 31 downto 0) := a(IUDbits+ 63 downto 32);
    end if;
    if b(4) = '1' then
      a(IUDbits+ 15 downto 0) := a(IUDbits+ 31 downto 16);
    end if;
    if b(3) = '1' then
      a(IUDbits+  7 downto 0) := a(IUDbits+ 15 downto 8);
    end if;
    if b(2) = '1' then
      a(IUDbits+  3 downto 0) := a(IUDbits+  7 downto 4);
    end if;
    if b(1) = '1' then
      a(IUDbits+  1 downto 0) := a(IUDbits+  3 downto 2);
    end if;
    if b(0) = '1' then
      a(IUDbits-  1 downto 0) := a(IUDbits     downto 1);
    end if;
    r := a(IUDrange);

    res  <= r;
    icco <= n & z & o & c;
  end process;
end;

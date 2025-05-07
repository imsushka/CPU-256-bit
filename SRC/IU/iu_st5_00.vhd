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

entity iu_st5_00 is
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

architecture Behavioral of iu_st5_00 is

begin
  p0 : process(op, op1d, op1s, op2d, icci)

    variable c : std_logic;
    variable o : std_logic;
    variable z : std_logic;
    variable n : std_logic;
    variable ta : std_logic;
    variable tb : std_logic;
    variable tr : std_logic;
    variable a : iudata;
    variable tmp : iudata;
    variable b : iudata;
    variable r : iudata;

  begin
    a := op1d;
    b := op2d;

    r := (others => '0');

    res  <= r;
    icco <= icci;
  end process;
end;

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

entity iu_stage5 is
  port (
    st5   : in  stage5_type;
    icci  : in  IUICC;

    icco  : out IUICC;
    jump  : out std_logic;

    st6   : out stage6_type
  );
end;

architecture Behavioral of iu_stage5 is

component iu_st5_as
  port (
    op   : in  ALUOp;	-- Alu operation
    op1d : in  IUData;	-- source operand 1
    op1s : in  IUSize;	-- size source operand 1
    op2d : in  IUData;	-- source operand 2
    icci : in  IUICC;	-- integer condition codes
    res  : out IUData;	-- data forward from execute stage
    icco : out IUICC	-- integer condition codes
  );
end component;

component iu_st5_l
  port (
    op   : in  ALUOp;	-- Alu operation
    op1d : in  IUData;	-- source operand 1
    op1s : in  IUSize;	-- size source operand 1
    op2d : in  IUData;	-- source operand 2
    icci : in  IUICC;	-- integer condition codes
    res  : out IUData;	-- data forward from execute stage
    icco : out IUICC	-- integer condition codes
  );
end component;

component iu_st5_sh
  port (
    op   : in  ALUOp;	-- Alu operation
    op1d : in  IUData;	-- source operand 1
    op1s : in  IUSize;	-- size source operand 1
    op2d : in  IUData;	-- source operand 2
    icci : in  IUICC;	-- integer condition codes
    res  : out IUData;	-- data forward from execute stage
    icco : out IUICC	-- integer condition codes
  );
end component;

component iu_st5_r
  port (
    op   : in  ALUOp;	-- Alu operation
    op1d : in  IUData;	-- source operand 1
    op1s : in  IUSize;	-- size source operand 1
    op2d : in  IUData;	-- source operand 2
    icci : in  IUICC;	-- integer condition codes
    res  : out IUData;	-- data forward from execute stage
    icco : out IUICC	-- integer condition codes
  );
end component;

component iu_st5_j
  port (
    op   : in  ALUOp;	-- Alu operation
    op1d : in  IUData;	-- source operand 1
    op1s : in  IUSize;	-- size source operand 1
    op2d : in  IUData;	-- source operand 2
    icci : in  IUICC;	-- integer condition codes
    res  : out IUData;	-- data forward from execute stage
    icco : out IUICC	-- integer condition codes
  );
end component;

component iu_st5_m
  port (
    op   : in  ALUOp;	-- Alu operation
    op1d : in  IUData;	-- source operand 1
    op1s : in  IUSize;	-- size source operand 1
    op2d : in  IUData;	-- source operand 2
    icci : in  IUICC;	-- integer condition codes
    res  : out IUData;	-- data forward from execute stage
    icco : out IUICC	-- integer condition codes
  );
end component;

component iu_st5_00
  port (
    op   : in  ALUOp;	-- Alu operation
    op1d : in  IUData;	-- source operand 1
    op1s : in  IUSize;	-- size source operand 1
    op2d : in  IUData;	-- source operand 2
    icci : in  IUICC;	-- integer condition codes
    res  : out IUData;	-- data forward from execute stage
    icco : out IUICC	-- integer condition codes
  );
end component;

component iu_st5_01
  port (
    op   : in  ALUOp;	-- Alu operation
    op1d : in  IUData;	-- source operand 1
    op1s : in  IUSize;	-- size source operand 1
    op2d : in  IUData;	-- source operand 2
    icci : in  IUICC;	-- integer condition codes
    res  : out IUData;	-- data forward from execute stage
    icco : out IUICC	-- integer condition codes
  );
end component;

signal res0, res1, res2, res3, res4, res5, res6, res7 : IUData;
signal icc0, icc1, icc2, icc3, icc4, icc5, icc6, icc7 : IUICC;

begin
  st51: iu_st5_as
	port map(st5.op, st5.op1d, st5.ress, st5.op2d, icci, res0, icc0);

  st52: iu_st5_l
	port map(st5.op, st5.op1d, st5.ress, st5.op2d, icci, res1, icc1);

  st53: iu_st5_sh
	port map(st5.op, st5.op1d, st5.ress, st5.op2d, icci, res2, icc2);

  st54: iu_st5_r
	port map(st5.op, st5.op1d, st5.ress, st5.op2d, icci, res3, icc3);

  st55: iu_st5_j
	port map(st5.op, st5.op1d, st5.ress, st5.op2d, icci, res4, icc4);

  st56: iu_st5_m
	port map(st5.op, st5.op1d, st5.ress, st5.op2d, icci, res5, icc5);

  st57: iu_st5_00
	port map(st5.op, st5.op1d, st5.ress, st5.op2d, icci, res6, icc6);

  st58: iu_st5_01
	port map(st5.op, st5.op1d, st5.ress, st5.op2d, icci, res7, icc7);

  mux0 : process (st5.op, icci, st5.sel, res0, icc0, res1, icc1, res2, icc2 , res3, icc3, res4, icc4, res5, icc5, res6, icc6, res7, icc7)

    variable dout : IUData;
    variable icc  : IUICC;
    variable zv   : std_logic;

  begin
    dout := (others => '0');
    icc  := (others => '0');

    case st5.sel is
    when ALU_R_ADD =>
      dout := res0;
      icc  := icc0;
    when ALU_R_LOGIC =>
      dout := res1;
      icc  := icc1;
    when ALU_R_SHIFT =>
      dout := res2;
      icc  := icc2;
    when ALU_R_ROTAT =>
      dout := res3;
      icc  := icc3;
    when ALU_R_JUMP =>
      dout := res4;
      icc  := icc4;
    when ALU_R_MULT =>
      dout := res5;
      icc  := icc5;
    when ALU_R_00 =>
      dout := res6;
      icc  := icc6;
    when others =>
      dout := res7;
      icc  := icc7;
    end case;

    zv := '0';
    st6.wrd <= dout;
    if (st5.sel = ALU_R_ADD) and (st5.op = ALU_NOP) then
      icco <= icci;
      jump <= '0';
    elsif st5.sel = ALU_R_JUMP then
      icco <= icci;
      jump <= dout(iudbits-1);
    else
      zv := dout(0);
      for i in 1 to IUDbits-1 loop
        zv := zv or dout(i);
      end loop;

      icco(0) <= icc(0);
      icco(1) <= icc(1);
      icco(2) <= not zv;
      icco(3) <= icc(3);
      jump <= '0';
    end if;
  end process;

  st6.wren <= st5.wren;
  st6.wrrm <= st5.wrrm;
  st6.wra  <= st5.resa;
  st6.wrs  <= st5.ress;
end;

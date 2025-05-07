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

entity iu_st5_r is
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

architecture Behavioral of iu_st5_r is

begin
  p0 : process(op, op1d, op1s, op2d, icci)

    variable c  : std_logic;
    variable o  : std_logic;
    variable z  : std_logic;
    variable n  : std_logic;
    variable ta : std_logic;
    variable tb : std_logic;
    variable tr : std_logic;
    variable a  : IUData;
    variable tmp : IUData;
    variable b  : std_logic_vector(7 downto 0);
    variable r  : IUData;

  begin
    a := op1d;
    b := op2d(7 downto 0);

    n := icci(3);
    z := icci(2);
    o := icci(1);
    c := icci(0);

    tb := '0';
    if (op = ALU_RRC) or (op = ALU_RLC) then
      tb := '1';
    end if;
    if (op = ALU_ROL) or (op = ALU_RLC) then
      b := not b;
    end if;

    if b(7) = '1' then
      tr := c;
      c := a(127); 
      if tb = '0' then
        tmp(127 downto 0) := a(127 downto 0);
      else
        tmp(127 downto 0) := a(126 downto 0) & tr;
      end if;   
      case op1s is
      when RS_BYTE   => c := tr;
      when RS_WORD   => c := tr;
      when RS_DWORD  => c := tr;
      when RS_QWORD  => c := tr;
      when RS_OWORD  => a(size_o) := tmp(127 downto 0);
      when RS_HWORD  => a(size_h) := tmp(127 downto 0) & a(255 downto 128);
      when others    => c := tr;
      end case;
    end if;
    if b(6) = '1' then
      tr := c;
      c := a(63); 
      if tb = '0' then
        tmp(63 downto 0) := a(63 downto 0);
      else
        tmp(63 downto 0) := a(62 downto 0) & tr;
      end if;   
      case op1s is
      when RS_BYTE   => c := tr;
      when RS_WORD   => c := tr;
      when RS_DWORD  => c := tr;
      when RS_QWORD  => a(size_q) := tmp(63 downto 0);
      when RS_OWORD  => a(size_o) := tmp(63 downto 0) & a(127 downto 64);
      when RS_HWORD  => a(size_h) := tmp(63 downto 0) & a(255 downto 64);
      when others    => c := tr;
      end case;
    end if;
    if b(5) = '1' then
      tr := c;
      c := a(31); 
      if tb = '0' then
        tmp(31 downto 0) := a(31 downto 0);
      else
        tmp(31 downto 0) := a(30 downto 0) & tr;
      end if;   
      case op1s is
      when RS_BYTE   => c := tr;
      when RS_WORD   => c := tr;
      when RS_DWORD  => a(size_d) := tmp(31 downto 0);
      when RS_QWORD  => a(size_q) := tmp(31 downto 0) & a( 63 downto 32);
      when RS_OWORD  => a(size_o) := tmp(31 downto 0) & a(127 downto 32);
      when RS_HWORD  => a(size_h) := tmp(31 downto 0) & a(255 downto 32);
      when others    => c := tr;
      end case;
    end if;
    if b(4) = '1' then
      tr := c;
      c := a(15); 
      if tb = '0' then
        tmp(15 downto 0) := a(15 downto 0);
      else
        tmp(15 downto 0) := a(14 downto 0) & tr;
      end if;   
      case op1s is
      when RS_BYTE   => c := tr;
      when RS_WORD   => a(size_w) := tmp(15 downto 0);
      when RS_DWORD  => a(size_d) := tmp(15 downto 0) & a( 31 downto 16);
      when RS_QWORD  => a(size_q) := tmp(15 downto 0) & a( 63 downto 16);
      when RS_OWORD  => a(size_o) := tmp(15 downto 0) & a(127 downto 16);
      when RS_HWORD  => a(size_h) := tmp(15 downto 0) & a(255 downto 16);
      when others    => c := tr;
      end case;
    end if;
    if b(3) = '1' then
      tr := c;
      c := a(7); 
      if tb = '0' then
        tmp(7 downto 0) := a(7 downto 0);
      else
        tmp(7 downto 0) := a(6 downto 0) & tr;
      end if;   
      case op1s is
      when RS_BYTE   => a(size_b) := tmp( 7 downto 0);
      when RS_WORD   => a(size_w) := tmp( 7 downto 0) & a( 15 downto  8);
      when RS_DWORD  => a(size_d) := tmp( 7 downto 0) & a( 31 downto  8);
      when RS_QWORD  => a(size_q) := tmp( 7 downto 0) & a( 63 downto  8);
      when RS_OWORD  => a(size_o) := tmp( 7 downto 0) & a(127 downto  8);
      when RS_HWORD  => a(size_h) := tmp( 7 downto 0) & a(255 downto  8);
      when others    => c := tr;
      end case;
    end if;
    if b(2) = '1' then
      tr := c;
      c := a(3); 
      if tb = '0' then
        tmp(3 downto 0) := a(3 downto 0);
      else
        tmp(3 downto 0) := a(2 downto 0) & tr;
      end if;   
      case op1s is
      when RS_BYTE   => a(size_b) := tmp( 3 downto 0) & a(  7 downto  4);
      when RS_WORD   => a(size_w) := tmp( 3 downto 0) & a( 15 downto  4);
      when RS_DWORD  => a(size_d) := tmp( 3 downto 0) & a( 31 downto  4);
      when RS_QWORD  => a(size_q) := tmp( 3 downto 0) & a( 63 downto  4);
      when RS_OWORD  => a(size_o) := tmp( 3 downto 0) & a(127 downto  4);
      when RS_HWORD  => a(size_h) := tmp( 3 downto 0) & a(255 downto  4);
      when others    => c := tr;
      end case;
    end if;
    if b(1) = '1' then
      tr := c;
      c := a(1); 
      if tb = '0' then
        tmp(1 downto 0) := a(1 downto 0);
      else
        tmp(1 downto 0) := a(0) & tr;
      end if;   
      case op1s is
      when RS_BYTE   => a(size_b) := tmp( 1 downto 0) & a(  7 downto  2);
      when RS_WORD   => a(size_w) := tmp( 1 downto 0) & a( 15 downto  2);
      when RS_DWORD  => a(size_d) := tmp( 1 downto 0) & a( 31 downto  2);
      when RS_QWORD  => a(size_q) := tmp( 1 downto 0) & a( 63 downto  2);
      when RS_OWORD  => a(size_o) := tmp( 1 downto 0) & a(127 downto  2);
      when RS_HWORD  => a(size_h) := tmp( 1 downto 0) & a(255 downto  2);
      when others    => c := tr;
      end case;
    end if;
    if b(0) = '1' then
      tr := c;
      c := a(0); 
      if tb = '0' then
        tmp(0) := a(0);
      else
        tmp(0) := tr;
      end if;   
      case op1s is
      when RS_BYTE   => a(size_b) := tmp(0) & a(  7 downto 1);
      when RS_WORD   => a(size_w) := tmp(0) & a( 15 downto 1);
      when RS_DWORD  => a(size_d) := tmp(0) & a( 31 downto 1);
      when RS_QWORD  => a(size_q) := tmp(0) & a( 63 downto 1);
      when RS_OWORD  => a(size_o) := tmp(0) & a(127 downto 1);
      when RS_HWORD  => a(size_h) := tmp(0) & a(255 downto 1);
      when others    => c := tr;
      end case;
    end if;
    r := a;

    res  <= r;
    icco <= n & z & o & c;
  end process;
end;

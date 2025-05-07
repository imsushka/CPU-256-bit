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

entity mux_4_to_n is
  port (
    blk1 : in  std_logic_vector(blocksize);
    blk2 : in  std_logic_vector(blocksize);
    blk3 : in  std_logic_vector(blocksize);
    blk4 : in  std_logic_vector(blocksize);

    rf01 : in  rfityperec;
    rf02 : in  rfityperec;
    rf03 : in  rfityperec;
    rf04 : in  rfityperec;

    rf   : out rfiblock
  );
end;

architecture behaviour of mux_4_to_n is
  
begin
  p: process (blk1, blk2, blk3, blk4, rf01, rf02, rf03, rf04)

  variable rfti : rfiblock;

  begin
    l: for i in blockrange loop 
      if i = conv_integer(unsigned(blk1)) then
        rfti(i) := rf01;
      elsif i = conv_integer(unsigned(blk2)) then
        rfti(i) := rf02;
      elsif i = conv_integer(unsigned(blk3)) then
        rfti(i) := rf03;
      elsif i = conv_integer(unsigned(blk4)) then
        rfti(i) := rf04;
      else
        rfti(i).rda1 := (others => '0');
        rfti(i).rds1 := (others => '0');
        rfti(i).rda2 := (others => '0');
        rfti(i).rds2 := (others => '0');
        rfti(i).wra  := (others => '0');
        rfti(i).wrd  := (others => '0');
        rfti(i).wrs  := (others => '0');
        rfti(i).wren := '0';
      end if;
    end loop l;

    rf <= rfti;
  end process;
end behaviour;

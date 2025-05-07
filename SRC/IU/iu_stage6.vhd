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
use work.iface.all;

entity iu_stage6 is
  port (
    st6   : in  stage6_type;

    mem   : out memd_in_type;
    rf    : out rfw_in_type
  );
end;

architecture Behavioral of iu_stage6 is

begin
  process(st6)

  begin
    mem.waddr  <= st6.wra;
    mem.data   <= st6.wrd;
    mem.wsize  <= st6.wrs;
    mem.wreq   <= st6.wren and not st6.wrrm;
    rf.wren    <= st6.wren and st6.wrrm;
  end process;
end;

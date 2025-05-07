-----------------------------------------------------------------------------
-- Entity:      ifaces
-- File:        iface.vhd
-- Author:      
-- Description: Package with type declarations for module interconnections
------------------------------------------------------------------------------
-- Version control:
-- 17-12-1997:  First implemetation
------------------------------------------------------------------------------
  
library IEEE;
use IEEE.std_logic_1164.all;
use work.config.all;
use work.ds0001.all;

package rfiface is


-------------------------------------------------------------------------------
type rf_type is record
  a     : RAddress;	-- source operand 1
  d     : RData;	-- source operand 1
  s     : RSize;	-- source operand 1
end record;

-------------------------------------------------------------------------------
-- register file inputs
type rfr_in_type is record
  rd1addr : RAddress; -- read address 1
  rd1size : RSize;
  rd2addr : RAddress; -- read address 2
  rd2size : RSize;
end record;

type rfw_in_type is record
--  wraddr 	: RAddress; -- write address
--  wrdata 	: RData; -- write data
--  wrsize        : IUSize;
  wren          : std_logic;                           -- write enable
end record;

type rf_out_type is record
  data1   : RData; -- read data 1
  data2   : RData; -- read data 2
end record;

type rfityperec is record
  rda1 : RAddress;
  rds1 : RSize;
  rda2 : RAddress;
  rds2 : RSize;
  wra  : RAddress;
  wrd  : RData;
  wrs  : RSize;
  wren : std_logic;
end record;
type rfiblock is array (blockrange) of rfityperec;
type rficpu   is array (cpurange) of rfityperec;

type rftyperec is record
  rda1 : RAddress;
  rdd1 : RData;
  rds1 : RSize;
  rda2 : RAddress;
  rdd2 : RData;
  rds2 : RSize;
  wra  : RAddress;
  wrd  : RData;
  wrs  : RSize;
  wren : std_logic;
end record;
type rftype is array (blockrange) of rftyperec;

type rfotyperec is record
  d1 : RData;
  d2 : RData;
end record;
type rfoblock is array (blockrange) of rfotyperec;
type rfocpu   is array (cpurange) of rfotyperec;

type blocks   is array (cpurange) of std_logic_vector(blocksize);

end;

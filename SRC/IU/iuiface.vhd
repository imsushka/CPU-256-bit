-----------------------------------------------------------------------------
-- Entity:      iuifaces
-- File:        iuiface.vhd
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
use work.iu0001.all;

package iuiface is

type stage1_type is record
  pc    : SAddress;	-- program counter
  b     : std_logic;			-- select branch address
  baddr : SAddress;	-- branch address
  j     : std_logic;			-- select jump address
  jaddr : SAddress;	-- jump address
  e     : std_logic;			-- select exception address
  eaddr : SAddress;	-- exception address
end record;

type stage2i_type is record
  pc    : SAddress;	-- program counter
  inst  : IUInst;	-- instruction
end record;

type stage2o_type is record
  pc    : SAddress;	-- program counter
  inst  : IUInst;	-- instruction
  rf1a  : RAddress;	-- source operand 1
  rf1s  : IUSize;	-- source operand 1
  rf1t  : std_logic_vector(1 downto 0);
  rf2a  : RAddress;	-- source operand 2
  rf2s  : IUSize;	-- source operand 2
  rf2t  : std_logic_vector(1 downto 0);
  flags : std_logic_vector(size_d);
end record;

type stage3i_type is record
  pc    : SAddress;	-- program counter
  inst  : IUInst;	-- instruction
  rf1a  : RAddress;	-- source operand 1
  rf1d  : IUData;	-- source operand 1
  rf1s  : IUSize;	-- source operand 1
  rf2a  : RAddress;	-- source operand 2
  rf2d  : IUData;	-- source operand 2
  rf2s  : IUSize;	-- source operand 2
end record;

type stage3o_type is record
  pc    : SAddress;	-- program counter
  inst  : IUInst;	-- instruction
  flags : std_logic_vector(size_w);	-- 
  rf1a  : RAddress;	-- source operand 1
  rf1d  : IUData;	-- source operand 1
  rf1s  : IUSize;	-- source operand 1
  rf2a  : RAddress;	-- source operand 2
  rf2d  : IUData;	-- source operand 2
  rf2s  : IUSize;	-- source operand 2
end record;

type stage4_type is record
  hold  : std_logic;			-- hold PC (multi-cycle inst.)
  pc    : SAddress;	-- program counter
--  inst  : IUInst;	-- instruction
  flags : std_logic_vector(size_d);	-- program counter
  imm   : IUInst;	-- immediate data 1
  immd  : IUInst;	-- immediate data 2
  cnt   : std_logic_vector(cnt_range);	-- cycle number (multi-cycle inst)
  rf1a  : RAddress;	-- source operand 1
  rf1d  : IUData;	-- source operand 1
  rf1s  : IUSize;	-- source operand 1
  rf2a  : RAddress;	-- source operand 2
  rf2d  : IUData;	-- source operand 2
  rf2s  : IUSize;	-- source operand 2
--  ofs   : SAddress;	-- program counter
  data  : IUData;	-- source operand 3
end record;

type stage5_type is record
  op1d  : IUData;	-- operand 1
  op2d  : IUData;	-- operand 2
  ress  : IUSize;	-- size result operand
  resa  : SAddress;	-- addr result operand
  op    : ALUOp;	-- Alu operation
  sel   : std_logic_vector(asel_range);	-- Alu result select
  wren  : std_logic;	--
  wrrm  : std_logic;	--
end record;

type stage6_type is record
  wra   : SAddress;	--
  wrd   : IUData;	--
  wrs   : IUSize;	--
  wren  : std_logic;	--
  wrrm  : std_logic;	--
end record;

end;

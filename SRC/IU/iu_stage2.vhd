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

entity iu_stage2 is
  port (
    reset : in  std_logic;
    st2i  : in  stage2i_type;

--    rdea  : in  RAddress;
--    rdes  : in  IUSize;
--    rexa  : in  RAddress;
--    rexs  : in  IUSize;

    st2o  : out stage2o_type
  );
end;

architecture Behavioral of iu_stage2 is

begin
  st : process(reset, st2i)--, rdea, rdes, rexa, rexs)
  variable v   : stage2o_type;
  variable rs  : Registers;
  variable rt  : RAddress;
  variable rext : RAddress;
  variable rdet : RAddress;
  variable rsa : RAddress;
  variable rss : IUSize;

  variable op      : std_logic_vector(ops_range);
  variable typeop  : std_logic_vector(typs_range);
  variable spec    : std_logic_vector(spec_range);

  variable aluop   : ALUOp;
  variable alusel  : std_logic_vector(asel_range);
  variable aluwr   : std_logic;

  variable inst0  : std_logic;
  variable inst1  : std_logic;
  variable inst2  : std_logic;

  variable aluerr  : std_logic;
  variable alu2wd  : std_logic;
  variable alu3wd  : std_logic;

  variable test0  : std_logic;
  variable test1  : std_logic;
  variable test2  : std_logic;

  variable test3  : std_logic;
  variable test4  : std_logic;

  begin
    v.pc   := st2i.pc;
    v.inst := st2i.inst;

    op     := st2i.inst(op_pos);
    typeop := st2i.inst(typ_pos);
    spec   := st2i.inst(spec_pos);

    aluop  := ALU_NOP;
    alusel := ALU_R_ADD;
    aluwr  := '0';
    aluerr := '0';

    inst0 := '0';
    inst1 := '0';
    inst2 := '0';

    test0 := '0';
    test1 := '0';
    test2 := '0';

    test3 := '0';
    test4 := '0';

    case op is
    when OP_MOVE    => inst0 := '1'; aluop := ALU_ADD; alusel := ALU_R_ADD; aluwr  := '1';
    when OP_SWAP    => inst1 := '1'; aluop := ALU_ADD; alusel := ALU_R_ADD; aluwr  := '1';
    when OP_ADD     => inst0 := '1'; aluop := ALU_ADD; alusel := ALU_R_ADD; aluwr  := '1';
    when OP_ADDC    => inst0 := '1'; aluop := ALU_ADC; alusel := ALU_R_ADD; aluwr  := '1';
    when OP_SUB     => inst0 := '1'; aluop := ALU_SUB; alusel := ALU_R_ADD; aluwr  := '1';
    when OP_SUBC    => inst0 := '1'; aluop := ALU_SBC; alusel := ALU_R_ADD; aluwr  := '1';
    when OP_COMP    => inst0 := '1'; aluop := ALU_SUB; alusel := ALU_R_ADD;
    when OP_AND     => inst0 := '1'; aluop := ALU_AND; alusel := ALU_R_LOGIC; aluwr  := '1';
    when OP_OR      => inst0 := '1'; aluop := ALU_OR;  alusel := ALU_R_LOGIC; aluwr  := '1';
    when OP_XOR     => inst0 := '1'; aluop := ALU_XOR; alusel := ALU_R_LOGIC; aluwr  := '1';
    when OP_MUL     => inst0 := '1'; aluop := ALU_MUL; alusel := ALU_R_MULT; aluwr  := '1';
    when OP_MULS    => inst0 := '1'; aluop := ALU_MLS; alusel := ALU_R_MULT; aluwr  := '1';
    when OP_DIV     => inst0 := '1'; aluop := ALU_DIV; alusel := ALU_R_MULT; aluwr  := '1';
    when OP_DIVS    => inst0 := '1'; aluop := ALU_DVS; alusel := ALU_R_MULT; aluwr  := '1';
    when OP_SLR     => inst0 := '1'; aluop := ALU_SLR; alusel := ALU_R_SHIFT; aluwr  := '1';
    when OP_SLL     => inst0 := '1'; aluop := ALU_SLL; alusel := ALU_R_SHIFT; aluwr  := '1';
    when OP_SAR     => inst0 := '1'; aluop := ALU_SAR; alusel := ALU_R_SHIFT; aluwr  := '1';
    when OP_ROR     => inst0 := '1'; aluop := ALU_ROR; alusel := ALU_R_ROTAT; aluwr  := '1';
    when OP_ROL     => inst0 := '1'; aluop := ALU_ROL; alusel := ALU_R_ROTAT; aluwr  := '1';
    when OP_RORC    => inst0 := '1'; aluop := ALU_RRC; alusel := ALU_R_ROTAT; aluwr  := '1';
    when OP_ROLC    => inst0 := '1'; aluop := ALU_RLC; alusel := ALU_R_ROTAT; aluwr  := '1';
    when OP_SPECIAL => inst2 := '1';
    when others => aluerr := '1';
    end case;

    case typeop is
    when B0 | B2 | B4 | B6 | B8 | BA => -- Only reg
      test0 := '1';
    when B3 | B5 | B7 | B9 | BB =>      -- Mem
      test1 := '1';
    when B1 | BC | BD =>                -- Imm
      test2 := '1';
    when others => aluerr := '1';
    end case;

    case typeop is
    when B4 | B5 | B8 | B9 | BC =>
      test3 := '1';
    when B6 | B7 | BA | BB | BD =>
      test4 := '1';
    when others => null;
    end case;

    if inst0 = '1' then
      if (test0 or test1 or test2) = '0' then
        aluerr := '1';
      end if;
    end if;

    if inst1 = '1' then
      if (test0 or test1) = '0' then
        aluerr := '1';
      end if;
    end if;

    if inst2 = '1' then
      if ((test0 or test2) = '1') and (spec = OPS_JUMP) then
        aluop  := st2i.inst(cond_pos);
        alusel := ALU_R_JUMP;
      else
        aluerr := '1';
      end if;
    end if;

    if reset = '0' then
      aluop  := ALU_NOP;
      alusel := ALU_R_ADD;
      aluwr  := '0';
      aluerr := '1';
    end if;

    alu2wd := test3 and not aluerr;
    alu3wd := test4 and not aluerr;

    v.flags := op & typeop & alu3wd & alu2wd & aluerr & aluwr & alusel & aluop & st2i.inst(reg2_pos);
-------------------------------------------------------------------------------
--    rdet := (others => '0');
--    rext := (others => '0');
--    case rdes is
--    when RS_BYTE  => rdet := RAS_BYTE;
--    when RS_WORD  => rdet := RAS_WORD;
--    when RS_DWORD => rdet := RAS_DWORD;
--    when RS_QWORD => rdet := RAS_QWORD;
--    when RS_OWORD => rdet := RAS_OWORD;
--    when RS_HWORD => rdet := RAS_HWORD;
--    when others   => null;
--    end case;

--    case rexs is
--    when RS_BYTE  => rext := RAS_BYTE;
--    when RS_WORD  => rext := RAS_WORD;
--    when RS_DWORD => rext := RAS_DWORD;
--    when RS_QWORD => rext := RAS_QWORD;
--    when RS_OWORD => rext := RAS_OWORD;
--    when RS_HWORD => rext := RAS_HWORD;
--    when others   => null;
--    end case;

    rs  := st2i.inst(reg1_pos);
--    rt  := (others => '0');
    rsa := (others => '0');
    rss := (others => '0');
    if     rs(10 downto 5) = "111111" then -- special reg
      rsa(4 downto 0) := rs(4 downto 0);
      rss := RS_SQWORD;
    elsif  rs(10 downto 5) = "111110" then -- RH reg
      rsa(9 downto 5) := rs(4 downto 0);
--      rt  := RAS_HWORD;
      rss := RS_HWORD;
    elsif  rs(10 downto 6) = "11110"  then -- RO reg
      rsa(9 downto 4) := rs(5 downto 0);
--      rt  := RAS_OWORD;
      rss := RS_OWORD;
    elsif  rs(10 downto 7) = "1110"   then -- RQ reg
      rsa(9 downto 3) := rs(6 downto 0);
--      rt  := RAS_QWORD;
      rss := RS_QWORD;
    elsif  rs(10 downto 8) = "110"    then -- RD reg
      rsa(9 downto 2) := rs(7 downto 0);
--      rt  := RAS_DWORD;
      rss := RS_DWORD;
    elsif  rs(10 downto 9) = "10"     then -- RW reg
      rsa(9 downto 1) := rs(8 downto 0);
--      rt  := RAS_WORD;
      rss := RS_WORD;
    elsif  rs(10)          = '0'      then -- RB reg
      rsa(9 downto 0) := rs(9 downto 0);
--      rt  := RAS_BYTE;
      rss := RS_BYTE;
    else
      rss := RS_NONE;
    end if;
    v.rf1a := rsa;
    v.rf1s := rss;
--    if (rdea and rt) = (rsa and rdet) then
--      v.rf1t(0) := '1';
--    else
--      v.rf1t(0) := '0';
--    end if;
--    if (rexa and rt) = (rsa and rext) then
--      v.rf1t(1) := '1';
--    else
--      v.rf1t(1) := '0';
--    end if;

    rs  := st2i.inst(reg2_pos);
--    rt  := (others => '0');
    rsa := (others => '0');
    rss := (others => '0');
    if     rs(10 downto 5) = "111111" then -- special reg
      rsa(4 downto 0) := rs(4 downto 0);
      rss := RS_SQWORD;
    elsif  rs(10 downto 5) = "111110" then -- RH reg
      rsa(9 downto 5) := rs(4 downto 0);
--      rt  := RAS_HWORD;
      rss := RS_HWORD;
    elsif  rs(10 downto 6) = "11110"  then -- RO reg
      rsa(9 downto 4) := rs(5 downto 0);
--      rt  := RAS_OWORD;
      rss := RS_OWORD;
    elsif  rs(10 downto 7) = "1110"   then -- RQ reg
      rsa(9 downto 3) := rs(6 downto 0);
--      rt  := RAS_QWORD;
      rss := RS_QWORD;
    elsif  rs(10 downto 8) = "110"    then -- RD reg
      rsa(9 downto 2) := rs(7 downto 0);
--      rt  := RAS_DWORD;
      rss := RS_DWORD;
    elsif  rs(10 downto 9) = "10"     then -- RW reg
      rsa(9 downto 1) := rs(8 downto 0);
--      rt  := RAS_WORD;
      rss := RS_WORD;
    elsif  rs(10)          = '0'      then -- RB reg
      rsa(9 downto 0) := rs(9 downto 0);
--      rt  := RAS_BYTE;
      rss := RS_BYTE;
    else
      rss := RS_NONE;
    end if;
    v.rf2a := rsa;
    v.rf2s := rss;
--    if (rdea and rt) = (rsa and rdet) then
--      v.rf2t(0) := '1';
--    else
--      v.rf2t(0) := '0';
--    end if;
--    if (rexa and rt) = (rsa and rext) then
--      v.rf2t(1) := '1';
--    else
--      v.rf2t(1) := '0';
--    end if;

    st2o <= v;
  end process;
end;

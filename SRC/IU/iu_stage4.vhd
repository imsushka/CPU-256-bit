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
library arith_lib;
--use arith_lib.arith_lib.all;

entity iu_stage4 is
  port (
    st4   : in  stage4_type;

    st4in : out stage4_type;

    hold  : out std_logic;			-- hold PC
    mema  : out SAddress;
    mems  : out IUSize;
    memr  : out std_logic;

    st5in : out stage5_type
  );
end;

architecture Behavioral of iu_stage4 is

component iu_stage4_step0
  port (
    o   : in  std_logic_vector(ops_range);
    t   : in  std_logic_vector(typs_range);
    o1s : out std_logic_vector(1 downto 0);
    o2s : out std_logic_vector(2 downto 0);
    ras : out std_logic_vector(2 downto 0);
    rss : out std_logic;
    cnt : out std_logic_vector(2 downto 0);
    wi  : out std_logic;
    wd  : out std_logic
  );
end component;

component iu_stage4_step1
  port (
    o   : in  std_logic_vector(ops_range);
    t   : in  std_logic_vector(typs_range);
    o1s : out std_logic_vector(1 downto 0);
    o2s : out std_logic_vector(2 downto 0);
    ras : out std_logic_vector(2 downto 0);
    rss : out std_logic;                   
    cnt : out std_logic_vector(2 downto 0);
    wi  : out std_logic;
    wd  : out std_logic
  );
end component;

component iu_stage4_step2
  port (
    o   : in  std_logic_vector(ops_range);
    t   : in  std_logic_vector(typs_range);
    o1s : out std_logic_vector(1 downto 0);
    o2s : out std_logic_vector(2 downto 0);
    ras : out std_logic_vector(2 downto 0);
    rss : out std_logic;                   
    cnt : out std_logic_vector(2 downto 0);
    wi  : out std_logic;
    wd  : out std_logic
  );
end component;

component iu_stage4_step3
  port (
    o   : in  std_logic_vector(ops_range);
    t   : in  std_logic_vector(typs_range);
    o1s : out std_logic_vector(1 downto 0);
    o2s : out std_logic_vector(2 downto 0);
    ras : out std_logic_vector(2 downto 0);
    rss : out std_logic;                   
    cnt : out std_logic_vector(2 downto 0);
    wi  : out std_logic;
    wd  : out std_logic
  );
end component;

component iu_stage4_step4
  port (
    o   : in  std_logic_vector(ops_range);
    t   : in  std_logic_vector(typs_range);
    o1s : out std_logic_vector(1 downto 0);
    o2s : out std_logic_vector(2 downto 0);
    ras : out std_logic_vector(2 downto 0);
    rss : out std_logic;                   
    cnt : out std_logic_vector(2 downto 0);
    wi  : out std_logic;
    wd  : out std_logic
  );
end component;

component iu_stage4_stepm
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
end component;

signal t32   : SAddress;
signal t64   : SAddress;
signal t1_32 : SAddress;
signal t2_32 : SAddress;
signal t1_64 : SAddress;
signal t2_64 : SAddress;

signal ofs   : SAddress;
signal sel_addr : std_logic_vector(2 downto 0);
signal sel_size : std_logic;
signal sel_op1  : std_logic_vector(1 downto 0);
signal sel_op2  : std_logic_vector(2 downto 0);

signal zero  : IUData;
signal temp0, temp1, temp3,
       temp2 : IUData;

signal rss0  : std_logic;
signal ras0  : std_logic_vector(2 downto 0);
signal o1s0  : std_logic_vector(1 downto 0);
signal o2s0  : std_logic_vector(2 downto 0);
signal wi0   : std_logic;
signal wd0   : std_logic;
signal cnt0  : std_logic_vector(2 downto 0);
signal rss1  : std_logic;
signal ras1  : std_logic_vector(2 downto 0);
signal o1s1  : std_logic_vector(1 downto 0);
signal o2s1  : std_logic_vector(2 downto 0);
signal wi1   : std_logic;
signal wd1   : std_logic;
signal cnt1  : std_logic_vector(2 downto 0);
signal rss2  : std_logic;
signal ras2  : std_logic_vector(2 downto 0);
signal o1s2  : std_logic_vector(1 downto 0);
signal o2s2  : std_logic_vector(2 downto 0);
signal wi2   : std_logic;
signal wd2   : std_logic;
signal cnt2  : std_logic_vector(2 downto 0);
signal rss3  : std_logic;
signal ras3  : std_logic_vector(2 downto 0);
signal o1s3  : std_logic_vector(1 downto 0);
signal o2s3  : std_logic_vector(2 downto 0);
signal wi3   : std_logic;
signal wd3   : std_logic;
signal cnt3  : std_logic_vector(2 downto 0);
signal rss4  : std_logic;
signal ras4  : std_logic_vector(2 downto 0);
signal o1s4  : std_logic_vector(1 downto 0);
signal o2s4  : std_logic_vector(2 downto 0);
signal wi4   : std_logic;
signal wd4   : std_logic;
signal cnt4  : std_logic_vector(2 downto 0);

signal wi    : std_logic;
signal wd    : std_logic;
signal cnt   : std_logic_vector(2 downto 0);

begin
  zero <= RS_ZERO_SYS;
  t32  <= RS_ZERO_D & st4.imm;
  t64  <= st4.imm & st4.immd;
--  p0 : add
--	generic map (64, fast)
--	Port Map (st4.rf1d(qword_00), t32, t1_32);
--  p1 : add
--	generic map (64, fast)
--	Port Map (st4.rf2d(qword_00), t32, t2_32);
--  p2 : add
--	generic map (64, fast)
--	Port Map (st4.rf1d(qword_00), t64, t1_64);
--  p3 : add
--	generic map (64, fast)
--	Port Map (st4.rf2d(qword_00), t64, t2_64);

  s0 : iu_stage4_step0
	port map (st4.flags(op_pos), st4.flags(typ_pos),
		o1s0, o2s0, ras0, rss0, cnt0, wi0, wd0);

  s1 : iu_stage4_step1
	port map (st4.flags(op_pos), st4.flags(typ_pos),
		o1s1, o2s1, ras1, rss1, cnt1, wi1, wd1);

  s2 : iu_stage4_step2
	port map (st4.flags(op_pos), st4.flags(typ_pos),
		o1s2, o2s2, ras2, rss2, cnt2, wi2, wd2);

  s3 : iu_stage4_step3
	port map (st4.flags(op_pos), st4.flags(typ_pos),
		o1s3, o2s3, ras3, rss3, cnt3, wi3, wd3);

  s4 : iu_stage4_step4
	port map (st4.flags(op_pos), st4.flags(typ_pos),
		o1s4, o2s4, ras4, rss4, cnt4, wi4, wd4);

  s5 : iu_stage4_stepm
	port map (st4.flags(op_pos), st4.cnt,
		o1s0, o2s0, ras0, rss0, cnt0, wi0, wd0,
		o1s1, o2s1, ras1, rss1, cnt1, wi1, wd1,
		o1s2, o2s2, ras2, rss2, cnt2, wi2, wd2,
		o1s3, o2s3, ras3, rss3, cnt3, wi3, wd3,
		o1s4, o2s4, ras4, rss4, cnt4, wi4, wd4,
		sel_op1,  sel_op2,  sel_addr, sel_size, cnt, wi, wd);

-------------------------------------------------------------------------------
-- Check for illegal and privileged instructions

  st1 : process(st4, cnt, wi, wd)

  variable v : stage4_type;

  variable op      : std_logic_vector(ops_range);
  variable typeop  : std_logic_vector(typs_range);

  variable rs2     : Registers;
  variable ress    : std_logic;
  variable resa    : std_logic_vector(2 downto 0);
  variable op1sel  : std_logic_vector(1 downto 0);
  variable op2sel  : std_logic_vector(2 downto 0);

  variable wait_i  : std_logic;
  variable wait_d  : std_logic;
  variable hold_m  : std_logic;

  variable aluop   : ALUOp;
  variable alusel  : std_logic_vector(asel_range); 
  variable aluwr   : std_logic;
  variable alumr   : std_logic;
  variable aluerr  : std_logic;

  begin
    v := st4;

--    aluop  := st4.flags(cond_pos);
--    alusel := st4.flags(asel_pos);
--    aluwr  := st4.flags(awr_pos);
    aluerr := st4.flags(aerr_pos);

    v.cnt  := cnt;

    if st4.hold = '1' then
--      typeop := B0;
      v.cnt  := st4.cnt;
    end if;

-- operands

    wait_i := wi;
    wait_d := wd;
    hold_m := st4.hold;

-------------------------------------------------------------------------------
--   -STEP ALL-STEP SWAP-
-- 0 - 1 step - 2 steps - xxxx REG1,   REG2
-- 1 - 1 step - 0 steps - xxxx REG1,   #11
-- 2 - 2 step - 3 steps - xxxx REG1,   (REG2)
-- 3 - 2 step - 3 steps - xxxx (REG1), REG2
-- 4 - 3 step - 4 steps - xxxx REG1,   ($32)
-- 5 - 3 step - 4 steps - xxxx ($32),  REG2
-- 6 - 4 step - 5 steps - xxxx REG1,   ($64)
-- 7 - 4 step - 5 steps - xxxx ($64),  REG2
-- 8 - 3 step - 4 steps - xxxx REG1,   (REG2+$32)
-- 9 - 3 step - 4 steps - xxxx (REG1+$32), REG2
-- A - 4 step - 5 steps - xxxx REG1,   (REG2+$64)
-- B - 4 step - 5 steps - xxxx (REG1+$64), REG2
-- C - 2 step - 3 steps - xxxx REG1,   #32
-- D - 3 step - 4 steps - xxxx REG1,   #64
-- E - 0 step - 0 steps - xxxx #32
-- F - 0 step - 0 steps - xxxx #64
-------------------------------------------------------------------------------
    case st4.cnt is
    when STEP1 =>
      case st4.flags(typ_pos) is
      when B6 | B7 | BA | BB | BD => v.immd := st4.imm;
      when others => null;
      end case;
    when others => null;
    end case;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--    if (alusel = ALU_R_ADD) or (alusel = ALU_R_MULT) then
--      case st4.rf1s is
--      when RS_BYTE  => op1d(IUDbits-1 downto   8) := (others => op1d(  7));
--      when RS_WORD  => op1d(IUDbits-1 downto  16) := (others => op1d( 15));
--      when RS_DWORD => op1d(IUDbits-1 downto  32) := (others => op1d( 31));
--      when RS_QWORD => op1d(IUDbits-1 downto  64) := (others => op1d( 63));
--      when RS_OWORD => op1d(IUDbits-1 downto 128) := (others => op1d(127));
--      when others   => null;
--      end case;
--
--      case st4.rf2s is
--      when RS_BYTE  => op2d(IUDbits-1 downto   8) := (others => op2d(  7));
--      when RS_WORD  => op2d(IUDbits-1 downto  16) := (others => op2d( 15));
--      when RS_DWORD => op2d(IUDbits-1 downto  32) := (others => op2d( 31));
--      when RS_QWORD => op2d(IUDbits-1 downto  64) := (others => op2d( 63));
--      when RS_OWORD => op2d(IUDbits-1 downto 128) := (others => op2d(127));
--      when others   => null;
--      end case;
--    end if;
-------------------------------------------------------------------------------
    if st4.hold = '0' then
      if aluerr = '1' then
        v.hold := '0';
        v.cnt  := STEP0;
      else
        v.hold := wait_i or wait_d;
      end if;
    else
      v.hold := '1';
    end if;

    hold  <= wait_d or hold_m;

    st4in <= v;
  end process;

  ma : process(st4.flags(typ_pos), st4.rf1d(qword_00), st4.rf2d(qword_00), 
		t32, t64, t1_32, t2_32, t1_64, t2_64)
  variable o : SAddress;
  begin
    case st4.flags(typ_pos) is
    when B2 => o := st4.rf2d(qword_00);
    when B3 => o := st4.rf1d(qword_00);
    when B4 => o := t32;
    when B5 => o := t32;
    when B6 => o := t64;
    when B7 => o := t64;
    when B8 => o := t1_32;
    when B9 => o := t2_32;
    when BA => o := t1_64;
    when BB => o := t2_64;
    when others => o := (others => '0');
    end case;
    ofs <= o;
  end process;

  ms : process(st4.flags(typ_pos), st4.rf1s, st4.rf2s)
  variable o : IUSize;
  begin
    case st4.flags(typ_pos) is
    when B2 | B4 | B6 | B8 | BA => o := st4.rf1s;
    when B3 | B5 | B7 | B9 | BB => o := st4.rf2s;
    when others => o := (others => '0');
    end case;
    mems <= o;
  end process;

  mema <= ofs;
  memr <= wd and not st4.flags(aerr_pos);

  ra : process(sel_addr, st4.rf1a, st4.rf2a, ofs, st4.rf1d(qword_00), t32, t1_32, t64, t1_64)
  variable o : SAddress;
  variable a : std_logic;
  begin
    o := (others => '0');
    a := '0';
    case sel_addr is
    when AREG1 => a := '1'; o(9 downto 0) := st4.rf1a;
    when AREG2 => a := '1'; o(9 downto 0) := st4.rf1a;
    when AOFS  => a := '0'; o := ofs;
    when AR1D  => a := '0'; o := st4.rf1d(qword_00);
    when AT32  => a := '0'; o := t32;
    when AT132 => a := '0'; o := t1_32;
    when AT64  => a := '0'; o := t64;
    when AT164 => a := '0'; o := t1_64;
    when others => null;
    end case;
    st5in.resa <= o;
    st5in.wrrm <= a;
  end process;

  st5in.ress <= st4.rf1s when sel_size = SREG1 else st4.rf2s;

  temp0 <= RS_ZERO_O & RS_ZERO_Q & st4.pc;
  op1 : process(sel_op1, st4.rf1d, st4.data, temp0)
  variable o : IUData;
  begin
    case sel_op1 is
    when DASIS => o := st4.rf1d;
--    when DZERO => o := (others => '0');
    when DDATA => o := st4.data;
    when DPC   => o := temp0;
    when others => o := (others => '0');
    end case;
    st5in.op1d <= o;
  end process;

  temp1(IUDbits-1 downto 11) <= (others => st4.flags(10));
  temp1(regs_range)          <= st4.flags(reg2_pos);
  temp2 <= RS_ZERO_O & RS_ZERO_Q & t32;
  temp3 <= RS_ZERO_O & RS_ZERO_Q & t64;
  op2 : process(sel_op2, st4.rf2d, st4.data, temp1, temp2, temp3)
  variable o : IUData;
  begin
--    ofs := (others => '0');
    case sel_op2 is
    when D2ASIS => o := st4.rf2d;
--    when D2ZERO => ofs := a1;
    when D2DATA => o := st4.data;
    when D2DAT1 => o := temp1;
    when D2DAT2 => o := temp2;
    when D2DAT3 => o := temp3;
    when others => o := (others => '0');
    end case;
    st5in.op2d <= o;
  end process;

  st5in.sel  <= st4.flags(asel_pos) when (wd or wi) = '0' else ALU_R_ADD;
  st5in.op   <= st4.flags(cond_pos) when (wd or wi) = '0' else ALU_NOP;
  st5in.wren <= st4.flags(awr_pos)  when (wd or wi) = '0' else '0';

end;

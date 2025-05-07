-----------------------------------------------------------------------------
-- Entity: 	iu
-- File:	iu.vhd
-- Author:	Dmitry Sushentsov
-- Description:	DS001 integer unit. Consists of 3 pipline stages: fetch,
--		decode, execute
--              memory and write-back.
--              Each stage is implemented in a separate process.
------------------------------------------------------------------------------
-- Version control:
-- 01-08-2004:	First implemetation
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.config.all;
use work.ds0001.all;
use work.iu0001.all;
use work.iface.all;
use work.iuiface.all;

entity iu is
  port (
    clk   : in  std_logic;
    reset : in  std_logic;

    holdn : in  std_logic;

    mii   : out memi_in_type;
    mio   : in  memi_out_type;
    mdi   : out memd_in_type;
    mdo   : in  memd_out_type;

    rfr   : out rfr_in_type;
    rfw   : out rfw_in_type;
    rfo   : in  rf_out_type
  );
end;

architecture Behavioral of iu is

component iu_stage1
  port (
    reset : in  std_logic;
    hold  : in  std_logic;		-- hold PC (Wait DATA CACHE)

    st1   : in  stage1_type;		-- Jump address

    pc    : out SAddress		-- Curent PC
  );
end component;

component iu_stage2
  port (
    reset : in  std_logic;
    st2i  : in  stage2i_type;

--    rdea  : in  RAddress;
--    rdes  : in  IUSize;
--    rexa  : in  RAddress;
--    rexs  : in  IUSize;

    st2o  : out stage2o_type
  );
end component;

component iu_stage4
  port (
    st4   : in  stage4_type;

    st4in : out stage4_type;

    hold  : out std_logic;		-- hold PC

    mema  : out SAddress;
    mems  : out IUSize;
    memr  : out std_logic;

    st5in : out stage5_type
  );
end component;

component iu_stage5
  port (
    st5   : in  stage5_type;
    icci  : in  IUICC;

    icco  : out IUICC;
    jump  : out std_logic;

    st6   : out stage6_type
  );
end component;

component iu_stage6
  port (
    st6   : in  stage6_type;

    mem   : out memd_in_type;
    rf    : out rfw_in_type
  );
end component;

-- registers
signal st1   : stage1_type;
signal st2   : stage2i_type;
signal st2in : stage2o_type;
signal st4, st4in : stage4_type;
signal st5, st5in : stage5_type;
signal st6in : stage6_type;

signal mema : SAddress;
signal mems : IUSize;
signal memr : std_logic;

signal pc        : SAddress;
signal newinst   : IUInst;
signal newdata   : IUData;
signal hold      : std_logic;
signal hold_inst : std_logic;
signal hold_data : std_logic;
signal icc       : IUICC;
signal iccin     : IUICC;
signal jump      : std_logic;

begin

  s1: iu_stage1
	port map(reset, hold, st1, pc);

  mii.addr <= pc;

  s2: iu_stage2
	port map(reset, st2, st2in);

  rfr.rd1addr <= st2in.rf1a;
  rfr.rd1size <= st2in.rf1s;
  rfr.rd2addr <= st2in.rf2a;
  rfr.rd2size <= st2in.rf2s;

  s4: iu_stage4
	port map(st4, st4in, hold, mema, mems, memr, st5in);

  mdi.raddr  <= mema;
  mdi.rsize  <= mems;
  mdi.rreq   <= memr;

  s5: iu_stage5
	port map(st5, icc, iccin, jump, st6in);

  mdi.waddr  <= st6in.wra;
  mdi.data   <= st6in.wrd;
  mdi.wsize  <= st6in.wrs;
  mdi.wreq   <= st6in.wren and not st6in.wrrm;
  rfw.wren   <= st6in.wren and st6in.wrrm;

------------------------------------------------------------------------------
  instmux : process(clk, mio)
  begin
    newinst <= mio.data; --(size_d);
    hold_inst <= not mio.ready;
  end process;

  datamux : process(clk, mdo)
  begin
    newdata <= mdo.data;
    hold_data <= not mdo.ready;
  end process;

  piperegs : process (clk)
  begin
    if rising_edge(clk) then
      if holdn = '1' then

      st1.pc   <= pc;

      st2.pc   <= pc;
      st2.inst <= newinst;

      st4.cnt  <= st4in.cnt;
      st4.immd <= st4in.immd;
      st4.data <= newdata;
      st4.imm  <= st2in.inst;
      st4.hold <= hold_inst or hold_data;

      if st4in.hold = '0' then
        st4.pc    <= st2in.pc;  
        st4.flags <= st2in.flags;

        st4.rf1a  <= st2in.rf1a;
        st4.rf1d  <= rfo.data1; 
        st4.rf1s  <= st2in.rf1s;
        st4.rf2a  <= st2in.rf2a;
        st4.rf2d  <= rfo.data2; 
        st4.rf2s  <= st2in.rf2s;
      else
        st4.pc    <= st4in.pc;
        st4.flags <= st4in.flags;

        st4.rf1a  <= st4in.rf1a;
        st4.rf1d  <= st4in.rf1d;
        st4.rf1s  <= st4in.rf1s;
        st4.rf2a  <= st4in.rf2a;
        st4.rf2d  <= st4in.rf2d;
        st4.rf2s  <= st4in.rf2s;
      end if;

      st5 <= st5in;
      icc <= iccin;

      st1.jaddr <= st6in.wrd(size_q);
      st1.j     <= jump;

      end if;
    end if;
  end process;

end;

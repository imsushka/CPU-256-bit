-----------------------------------------------------------------------------
-- Package:     iu0001
-- File:        iu0001.vhd
-- Author:      Dmitry Sushentsov         
-- Description: Package with DS0001 instruction definitions
------------------------------------------------------------------------------
-- Version control:
-- 01-09-2004:  First implemetation
-- 01-09-2004:  Release 1.0
------------------------------------------------------------------------------
   
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.conv_unsigned;
use work.config.all;
use work.ds0001.all;

package iu0001 is

subtype ops_range    is natural range   5 downto  0;
subtype typs_range   is natural range   3 downto  0;
subtype regs_range   is natural range  10 downto  0;
subtype cond_range   is natural range   3 downto  0;
subtype spec_range   is natural range   6 downto  0;
subtype cnt_range    is natural range   2 downto  0;
subtype icc_range    is natural range   3 downto  0;
subtype aops_range   is natural range   3 downto  0;
subtype asel_range   is natural range   2 downto  0;

subtype op_pos       is natural range  31 downto 26;
subtype typ_pos      is natural range  25 downto 22;
subtype reg1_pos     is natural range  21 downto 11;
subtype reg2_pos     is natural range  10 downto  0;
subtype cond_pos     is natural range  14 downto 11;
subtype spec_pos     is natural range  21 downto 15;

constant awr_pos  :  integer := 18;
constant aerr_pos :  integer := 19;
subtype asel_pos     is natural range  17 downto 15;
            
subtype IUDDblHi     is natural range IUDbits*2-1 downto IUDbits;
         
subtype IUIrange     is natural range IUIbits-1 downto 0;
subtype IUDrange     is natural range IUDbits-1 downto 0;
subtype IUDDblRange  is natural range IUDbits*2-1 downto 0;

subtype IUData       is std_logic_vector(IUDrange);
subtype IUSize       is std_logic_vector(size_range);
subtype IUICC        is std_logic_vector(icc_range);
subtype Registers    is std_logic_vector(Regs_range);
subtype ALUOp        is std_logic_vector(aops_range);

constant RS_ZERO_SYS : std_logic_vector(IUDrange)   := (others => '0');

-- OP codes (INST[31..26])
constant OP_MOVE     : std_logic_vector(ops_range)  := "000000";
constant OP_COMP     : std_logic_vector(ops_range)  := "000001";
constant OP_SWAP     : std_logic_vector(ops_range)  := "000010";
constant OP_AND      : std_logic_vector(ops_range)  := "000011";
constant OP_OR       : std_logic_vector(ops_range)  := "000100";
constant OP_XOR      : std_logic_vector(ops_range)  := "000101";
constant OP_SLR      : std_logic_vector(ops_range)  := "000110";
constant OP_SLL      : std_logic_vector(ops_range)  := "000111";
constant OP_SAR      : std_logic_vector(ops_range)  := "001000";
constant OP_ROR      : std_logic_vector(ops_range)  := "001001";
constant OP_RORC     : std_logic_vector(ops_range)  := "001010";
constant OP_ROL      : std_logic_vector(ops_range)  := "001011";
constant OP_ROLC     : std_logic_vector(ops_range)  := "001100";
constant OP_ADD      : std_logic_vector(ops_range)  := "001101";
constant OP_ADDC     : std_logic_vector(ops_range)  := "001110";
constant OP_ADDS     : std_logic_vector(ops_range)  := "001111";
constant OP_SUB      : std_logic_vector(ops_range)  := "010000";
constant OP_SUBC     : std_logic_vector(ops_range)  := "010001";
constant OP_SUBS     : std_logic_vector(ops_range)  := "010010";
constant OP_MUL      : std_logic_vector(ops_range)  := "010011";
constant OP_MULS     : std_logic_vector(ops_range)  := "010100";
constant OP_DIV      : std_logic_vector(ops_range)  := "010101";
constant OP_DIVS     : std_logic_vector(ops_range)  := "010110";
constant OP_SPECIAL  : std_logic_vector(ops_range)  := "010111";
constant OP_FREE1    : std_logic_vector(ops_range)  := "011000";
constant OP_FREE2    : std_logic_vector(ops_range)  := "011001";
constant OP_FREE3    : std_logic_vector(ops_range)  := "011010";
constant OP_FREE4    : std_logic_vector(ops_range)  := "011011";
constant OP_FREE5    : std_logic_vector(ops_range)  := "011100";
constant OP_FREE6    : std_logic_vector(ops_range)  := "011101";
constant OP_FREE7    : std_logic_vector(ops_range)  := "011110";
constant OP_FREE8    : std_logic_vector(ops_range)  := "011111";
                                                    
constant OP_FPU      : std_logic_vector(ops_range)  := "100000";
constant OPF_MOVE    : std_logic_vector(ops_range)  := "100000";
constant OPF_COMP    : std_logic_vector(ops_range)  := "100001";
constant OPF_SWAP    : std_logic_vector(ops_range)  := "100010";
constant OPF_ADD     : std_logic_vector(ops_range)  := "100011";
constant OPF_SUB     : std_logic_vector(ops_range)  := "100100";
constant OPF_MUL     : std_logic_vector(ops_range)  := "100101";
constant OPF_DIV     : std_logic_vector(ops_range)  := "100110";

constant OP_CPU      : std_logic_vector(ops_range)  := "110000";

constant OPS_JUMP    : std_logic_vector(spec_range) := "0000000";
constant OPS_CALL    : std_logic_vector(spec_range) := "0000001";
constant OPS_RET     : std_logic_vector(spec_range) := "0000010";
constant OPS_INT     : std_logic_vector(spec_range) := "0000011";
constant OPS_PUSH    : std_logic_vector(spec_range) := "0000100";
constant OPS_POP     : std_logic_vector(spec_range) := "0000101";

-- TYPEO codes (INST[25..22])
constant B0          : std_logic_vector(typs_range) := "0000";
constant B1          : std_logic_vector(typs_range) := "0001";
constant B2          : std_logic_vector(typs_range) := "0010";
constant B3          : std_logic_vector(typs_range) := "0011";
constant B4          : std_logic_vector(typs_range) := "0100";
constant B5          : std_logic_vector(typs_range) := "0101";
constant B6          : std_logic_vector(typs_range) := "0110";
constant B7          : std_logic_vector(typs_range) := "0111";
constant B8          : std_logic_vector(typs_range) := "1000";
constant B9          : std_logic_vector(typs_range) := "1001";
constant BA          : std_logic_vector(typs_range) := "1010";
constant BB          : std_logic_vector(typs_range) := "1011";
constant BC          : std_logic_vector(typs_range) := "1100";
constant BD          : std_logic_vector(typs_range) := "1101";
constant BE          : std_logic_vector(typs_range) := "1110";
constant BF          : std_logic_vector(typs_range) := "1111";

constant DASIS       : std_logic_vector(1 downto  0) := "00";
constant DZERO       : std_logic_vector(1 downto  0) := "01";
constant DDATA       : std_logic_vector(1 downto  0) := "10";
constant DPC         : std_logic_vector(1 downto  0) := "11";

constant D2ASIS      : std_logic_vector(2 downto  0) := "000";
constant D2ZERO      : std_logic_vector(2 downto  0) := "001";
constant D2DATA      : std_logic_vector(2 downto  0) := "010";
constant D2DAT1      : std_logic_vector(2 downto  0) := "011";
constant D2DAT2      : std_logic_vector(2 downto  0) := "100";
constant D2DAT3      : std_logic_vector(2 downto  0) := "101";

constant SREG1       : std_logic := '0';
constant SREG2       : std_logic := '1';

constant AREG1       : std_logic_vector(2 downto  0) := "000";
constant AREG2       : std_logic_vector(2 downto  0) := "001";
constant AR1D        : std_logic_vector(2 downto  0) := "010";
constant AT32        : std_logic_vector(2 downto  0) := "100";
constant AT132       : std_logic_vector(2 downto  0) := "101";
constant AT64        : std_logic_vector(2 downto  0) := "110";
constant AT164       : std_logic_vector(2 downto  0) := "111";
constant AOFS        : std_logic_vector(2 downto  0) := "011";

constant STEP0       : std_logic_vector(cnt_range)  := "000";
constant STEP1       : std_logic_vector(cnt_range)  := "001";
constant STEP2       : std_logic_vector(cnt_range)  := "010";
constant STEP3       : std_logic_vector(cnt_range)  := "011";
constant STEP4       : std_logic_vector(cnt_range)  := "100";
constant STEP5       : std_logic_vector(cnt_range)  := "101";
constant STEP6       : std_logic_vector(cnt_range)  := "110";
constant STEP7       : std_logic_vector(cnt_range)  := "111";

-- ALU operation codes
constant ALU_NOP     : std_logic_vector(aops_range) := "0000";

-- ADD/SUB block
constant ALU_ADD     : std_logic_vector(aops_range) := "0001";
constant ALU_SUB     : std_logic_vector(aops_range) := "0010";
constant ALU_ADC     : std_logic_vector(aops_range) := "0011";
constant ALU_SBC     : std_logic_vector(aops_range) := "0100";
constant ALU_ADS     : std_logic_vector(aops_range) := "0101";
constant ALU_SBS     : std_logic_vector(aops_range) := "0110";

-- MUL/DIV block
constant ALU_MUL     : std_logic_vector(aops_range) := "0001";
constant ALU_DIV     : std_logic_vector(aops_range) := "0010";
constant ALU_MLS     : std_logic_vector(aops_range) := "0011";
constant ALU_DVS     : std_logic_vector(aops_range) := "0100";
constant ALU_MOD     : std_logic_vector(aops_range) := "0101";

-- LOGIC block
constant ALU_AND     : std_logic_vector(aops_range) := "0001";
constant ALU_OR      : std_logic_vector(aops_range) := "0010";
constant ALU_XOR     : std_logic_vector(aops_range) := "0011";
constant ALU_ABS     : std_logic_vector(aops_range) := "0100";
constant ALU_NOT     : std_logic_vector(aops_range) := "0101";
constant ALU_NEG     : std_logic_vector(aops_range) := "0110";
             
-- SHIFT/ROTATE block        
constant ALU_SLL     : std_logic_vector(aops_range) := "0001";
constant ALU_SLR     : std_logic_vector(aops_range) := "0010";
constant ALU_SAR     : std_logic_vector(aops_range) := "0011";
constant ALU_ROL     : std_logic_vector(aops_range) := "0100";
constant ALU_ROR     : std_logic_vector(aops_range) := "0101";
constant ALU_RLC     : std_logic_vector(aops_range) := "0110";
constant ALU_RRC     : std_logic_vector(aops_range) := "0111";

-- ALU result select
constant ALU_R_ADD   : std_logic_vector(asel_range) := "000";
constant ALU_R_SHIFT : std_logic_vector(asel_range) := "001";
constant ALU_R_LOGIC : std_logic_vector(asel_range) := "010";
constant ALU_R_ROTAT : std_logic_vector(asel_range) := "011";
constant ALU_R_JUMP  : std_logic_vector(asel_range) := "100";
constant ALU_R_MULT  : std_logic_vector(asel_range) := "101";
constant ALU_R_00    : std_logic_vector(asel_range) := "110";
constant ALU_R_01    : std_logic_vector(asel_range) := "111";

-- Load types
constant RAS_BYTE    : std_logic_vector(rarange) := "1111111111";
constant RAS_WORD    : std_logic_vector(rarange) := "1111111110";
constant RAS_DWORD   : std_logic_vector(rarange) := "1111111100";
constant RAS_QWORD   : std_logic_vector(rarange) := "1111111000";
constant RAS_OWORD   : std_logic_vector(rarange) := "1111110000";
constant RAS_HWORD   : std_logic_vector(rarange) := "1111100000";

end;

-- TB EXAMPLE PFRL 2023-2024

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use std.textio.all;

entity probability_0 is
end entity probability_0;

architecture probability_0_arch of probability_0 is

  constant clock_period : time      := 20 ns;
  signal   tb_clk       : std_logic := '0';
  signal   tb_rst       : std_logic;
  signal   tb_start     : std_logic;
  signal   tb_done      : std_logic;
  signal   tb_add       : std_logic_vector(15 downto 0);
  signal   tb_k         : std_logic_vector(9 downto 0);

  signal tb_o_mem_addr   : std_logic_vector(15 downto 0);
  signal exc_o_mem_addr  : std_logic_vector(15 downto 0);
  signal init_o_mem_addr : std_logic_vector(15 downto 0);
  signal tb_o_mem_data   : std_logic_vector(7 downto 0);
  signal exc_o_mem_data  : std_logic_vector(7 downto 0);
  signal init_o_mem_data : std_logic_vector(7 downto 0);
  signal tb_i_mem_data   : std_logic_vector(7 downto 0);
  signal tb_o_mem_we     : std_logic;
  signal tb_o_mem_en     : std_logic;
  signal exc_o_mem_we    : std_logic;
  signal exc_o_mem_en    : std_logic;
  signal init_o_mem_we   : std_logic;
  signal init_o_mem_en   : std_logic;

  type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);

  signal ram : ram_type := (OTHERS => "00000000");

  constant scenario_length : integer := 428;

  type scenario_type is array (0 to scenario_length * 2 - 1) of integer;

  signal   scenario_input   : scenario_type := (103,  0, 33,  0, 173,  0, 75,  0, 5,  0, 163,  0, 13,  0, 69,  0, 157,  0, 55,  0, 217,  0, 175,  0, 226,  0, 91,  0, 80,  0, 89,  0, 66,  0, 109,  0, 249,  0, 186,  0, 163,  0, 238,  0, 59,  0, 239,  0, 185,  0, 193,  0, 237,  0, 176,  0, 206,  0, 99,  0, 19,  0, 181,  0, 132,  0, 64,  0, 1,  0, 10,  0, 99,  0, 142,  0, 79,  0, 1,  0, 69,  0, 169,  0, 49,  0, 167,  0, 5,  0, 129,  0, 1,  0, 198,  0, 238,  0, 122,  0, 1,  0, 18,  0, 106,  0, 188,  0, 2,  0, 36,  0, 126,  0, 111,  0, 212,  0, 204,  0, 83,  0, 103,  0, 130,  0, 215,  0, 168,  0, 4,  0, 97,  0, 12,  0, 146,  0, 177,  0, 141,  0, 215,  0, 91,  0, 62,  0, 254,  0, 223,  0, 191,  0, 1,  0, 39,  0, 46,  0, 123,  0, 167,  0, 191,  0, 101,  0, 100,  0, 65,  0, 138,  0, 98,  0, 49,  0, 222,  0, 47,  0, 132,  0, 71,  0, 50,  0, 219,  0, 111,  0, 181,  0, 62,  0, 250,  0, 72,  0, 239,  0, 136,  0, 159,  0, 202,  0, 198,  0, 30,  0, 42,  0, 6,  0, 31,  0, 208,  0, 179,  0, 27,  0, 121,  0, 115,  0, 128,  0, 93,  0, 53,  0, 138,  0, 192,  0, 102,  0, 233,  0, 111,  0, 234,  0, 176,  0, 33,  0, 198,  0, 32,  0, 214,  0, 132,  0, 27,  0, 158,  0, 243,  0, 36,  0, 189,  0, 190,  0, 234,  0, 220,  0, 105,  0, 113,  0, 123,  0, 58,  0, 37,  0, 22,  0, 179,  0, 25,  0, 151,  0, 145,  0, 205,  0, 161,  0, 209,  0, 52,  0, 139,  0, 65,  0, 158,  0, 60,  0, 226,  0, 228,  0, 219,  0, 185,  0, 106,  0, 247,  0, 216,  0, 94,  0, 28,  0, 150,  0, 157,  0, 134,  0, 242,  0, 7,  0, 119,  0, 111,  0, 65,  0, 29,  0, 133,  0, 117,  0, 181,  0, 156,  0, 7,  0, 131,  0, 190,  0, 216,  0, 55,  0, 74,  0, 153,  0, 213,  0, 7,  0, 124,  0, 58,  0, 98,  0, 182,  0, 36,  0, 217,  0, 143,  0, 131,  0, 117,  0, 165,  0, 160,  0, 252,  0, 153,  0, 39,  0, 243,  0, 136,  0, 231,  0, 17,  0, 141,  0, 93,  0, 198,  0, 170,  0, 227,  0, 74,  0, 105,  0, 188,  0, 129,  0, 51,  0, 214,  0, 214,  0, 185,  0, 210,  0, 18,  0, 29,  0, 137,  0, 54,  0, 246,  0, 152,  0, 57,  0, 109,  0, 63,  0, 89,  0, 233,  0, 88,  0, 128,  0, 221,  0, 224,  0, 232,  0, 111,  0, 237,  0, 70,  0, 54,  0, 152,  0, 43,  0, 1,  0, 129,  0, 103,  0, 130,  0, 181,  0, 189,  0, 217,  0, 111,  0, 145,  0, 107,  0, 12,  0, 27,  0, 33,  0, 131,  0, 180,  0, 218,  0, 240,  0, 115,  0, 52,  0, 90,  0, 203,  0, 53,  0, 183,  0, 44,  0, 30,  0, 39,  0, 153,  0, 227,  0, 94,  0, 51,  0, 142,  0, 95,  0, 180,  0, 118,  0, 97,  0, 233,  0, 52,  0, 186,  0, 217,  0, 197,  0, 38,  0, 229,  0, 97,  0, 72,  0, 105,  0, 149,  0, 162,  0, 217,  0, 136,  0, 86,  0, 179,  0, 211,  0, 11,  0, 108,  0, 0,  0, 41,  0, 147,  0, 25,  0, 141,  0, 241,  0, 76,  0, 28,  0, 208,  0, 129,  0, 146,  0, 51,  0, 107,  0, 71,  0, 109,  0, 196,  0, 140,  0, 148,  0, 171,  0, 109,  0, 92,  0, 148,  0, 130,  0, 254,  0, 238,  0, 11,  0, 212,  0, 34,  0, 222,  0, 224,  0, 142,  0, 94,  0, 137,  0, 35,  0, 120,  0, 23,  0, 148,  0, 68,  0, 179,  0, 102,  0, 197,  0, 197,  0, 25,  0, 177,  0, 13,  0, 134,  0, 118,  0, 26,  0, 154,  0, 161,  0, 135,  0, 118,  0, 182,  0, 11,  0, 244,  0, 37,  0, 149,  0, 202,  0, 71,  0, 244,  0, 171,  0, 214,  0, 83,  0, 180,  0, 121,  0, 75,  0, 204,  0, 14,  0, 16,  0, 128,  0, 243,  0, 85,  0, 197,  0, 140,  0, 7,  0, 211,  0, 147,  0, 253,  0, 109,  0, 46,  0, 31,  0, 244,  0, 37,  0, 85,  0, 127,  0, 26,  0, 249,  0, 149,  0, 228,  0, 66,  0, 138,  0, 16,  0, 152,  0, 221,  0, 197,  0, 145,  0, 169,  0, 18,  0, 31,  0, 185,  0, 18,  0, 20,  0, 15,  0, 215,  0, 32,  0, 150,  0, 43,  0, 179,  0, 20,  0, 152,  0, 98,  0, 178,  0, 14,  0, 135,  0, 9,  0, 13,  0, 161,  0, 130,  0, 162,  0, 7,  0, 68,  0, 45,  0, 150,  0, 220,  0, 139,  0, 219,  0, 237,  0, 53,  0, 237,  0, 14,  0, 110,  0, 0,  0, 161,  0, 252,  0);
  signal   scenario_full    : scenario_type := (103, 31, 33, 31, 173, 31, 75, 31, 5, 31, 163, 31, 13, 31, 69, 31, 157, 31, 55, 31, 217, 31, 175, 31, 226, 31, 91, 31, 80, 31, 89, 31, 66, 31, 109, 31, 249, 31, 186, 31, 163, 31, 238, 31, 59, 31, 239, 31, 185, 31, 193, 31, 237, 31, 176, 31, 206, 31, 99, 31, 19, 31, 181, 31, 132, 31, 64, 31, 1, 31, 10, 31, 99, 31, 142, 31, 79, 31, 1, 31, 69, 31, 169, 31, 49, 31, 167, 31, 5, 31, 129, 31, 1, 31, 198, 31, 238, 31, 122, 31, 1, 31, 18, 31, 106, 31, 188, 31, 2, 31, 36, 31, 126, 31, 111, 31, 212, 31, 204, 31, 83, 31, 103, 31, 130, 31, 215, 31, 168, 31, 4, 31, 97, 31, 12, 31, 146, 31, 177, 31, 141, 31, 215, 31, 91, 31, 62, 31, 254, 31, 223, 31, 191, 31, 1, 31, 39, 31, 46, 31, 123, 31, 167, 31, 191, 31, 101, 31, 100, 31, 65, 31, 138, 31, 98, 31, 49, 31, 222, 31, 47, 31, 132, 31, 71, 31, 50, 31, 219, 31, 111, 31, 181, 31, 62, 31, 250, 31, 72, 31, 239, 31, 136, 31, 159, 31, 202, 31, 198, 31, 30, 31, 42, 31, 6, 31, 31, 31, 208, 31, 179, 31, 27, 31, 121, 31, 115, 31, 128, 31, 93, 31, 53, 31, 138, 31, 192, 31, 102, 31, 233, 31, 111, 31, 234, 31, 176, 31, 33, 31, 198, 31, 32, 31, 214, 31, 132, 31, 27, 31, 158, 31, 243, 31, 36, 31, 189, 31, 190, 31, 234, 31, 220, 31, 105, 31, 113, 31, 123, 31, 58, 31, 37, 31, 22, 31, 179, 31, 25, 31, 151, 31, 145, 31, 205, 31, 161, 31, 209, 31, 52, 31, 139, 31, 65, 31, 158, 31, 60, 31, 226, 31, 228, 31, 219, 31, 185, 31, 106, 31, 247, 31, 216, 31, 94, 31, 28, 31, 150, 31, 157, 31, 134, 31, 242, 31, 7, 31, 119, 31, 111, 31, 65, 31, 29, 31, 133, 31, 117, 31, 181, 31, 156, 31, 7, 31, 131, 31, 190, 31, 216, 31, 55, 31, 74, 31, 153, 31, 213, 31, 7, 31, 124, 31, 58, 31, 98, 31, 182, 31, 36, 31, 217, 31, 143, 31, 131, 31, 117, 31, 165, 31, 160, 31, 252, 31, 153, 31, 39, 31, 243, 31, 136, 31, 231, 31, 17, 31, 141, 31, 93, 31, 198, 31, 170, 31, 227, 31, 74, 31, 105, 31, 188, 31, 129, 31, 51, 31, 214, 31, 214, 31, 185, 31, 210, 31, 18, 31, 29, 31, 137, 31, 54, 31, 246, 31, 152, 31, 57, 31, 109, 31, 63, 31, 89, 31, 233, 31, 88, 31, 128, 31, 221, 31, 224, 31, 232, 31, 111, 31, 237, 31, 70, 31, 54, 31, 152, 31, 43, 31, 1, 31, 129, 31, 103, 31, 130, 31, 181, 31, 189, 31, 217, 31, 111, 31, 145, 31, 107, 31, 12, 31, 27, 31, 33, 31, 131, 31, 180, 31, 218, 31, 240, 31, 115, 31, 52, 31, 90, 31, 203, 31, 53, 31, 183, 31, 44, 31, 30, 31, 39, 31, 153, 31, 227, 31, 94, 31, 51, 31, 142, 31, 95, 31, 180, 31, 118, 31, 97, 31, 233, 31, 52, 31, 186, 31, 217, 31, 197, 31, 38, 31, 229, 31, 97, 31, 72, 31, 105, 31, 149, 31, 162, 31, 217, 31, 136, 31, 86, 31, 179, 31, 211, 31, 11, 31, 108, 31, 108, 30, 41, 31, 147, 31, 25, 31, 141, 31, 241, 31, 76, 31, 28, 31, 208, 31, 129, 31, 146, 31, 51, 31, 107, 31, 71, 31, 109, 31, 196, 31, 140, 31, 148, 31, 171, 31, 109, 31, 92, 31, 148, 31, 130, 31, 254, 31, 238, 31, 11, 31, 212, 31, 34, 31, 222, 31, 224, 31, 142, 31, 94, 31, 137, 31, 35, 31, 120, 31, 23, 31, 148, 31, 68, 31, 179, 31, 102, 31, 197, 31, 197, 31, 25, 31, 177, 31, 13, 31, 134, 31, 118, 31, 26, 31, 154, 31, 161, 31, 135, 31, 118, 31, 182, 31, 11, 31, 244, 31, 37, 31, 149, 31, 202, 31, 71, 31, 244, 31, 171, 31, 214, 31, 83, 31, 180, 31, 121, 31, 75, 31, 204, 31, 14, 31, 16, 31, 128, 31, 243, 31, 85, 31, 197, 31, 140, 31, 7, 31, 211, 31, 147, 31, 253, 31, 109, 31, 46, 31, 31, 31, 244, 31, 37, 31, 85, 31, 127, 31, 26, 31, 249, 31, 149, 31, 228, 31, 66, 31, 138, 31, 16, 31, 152, 31, 221, 31, 197, 31, 145, 31, 169, 31, 18, 31, 31, 31, 185, 31, 18, 31, 20, 31, 15, 31, 215, 31, 32, 31, 150, 31, 43, 31, 179, 31, 20, 31, 152, 31, 98, 31, 178, 31, 14, 31, 135, 31, 9, 31, 13, 31, 161, 31, 130, 31, 162, 31, 7, 31, 68, 31, 45, 31, 150, 31, 220, 31, 139, 31, 219, 31, 237, 31, 53, 31, 237, 31, 14, 31, 110, 31, 110, 30, 161, 31, 252, 31);
  constant scenario_address : integer       := 387;

  signal memory_control : std_logic := '0';

  component project_reti_logiche is
    port (
      i_clk   : in    std_logic;
      i_rst   : in    std_logic;
      i_start : in    std_logic;
      i_add   : in    std_logic_vector(15 downto 0);
      i_k     : in    std_logic_vector(9 downto 0);

      o_done : out   std_logic;

      o_mem_addr : out   std_logic_vector(15 downto 0);
      i_mem_data : in    std_logic_vector(7 downto 0);
      o_mem_data : out   std_logic_vector(7 downto 0);
      o_mem_we   : out   std_logic;
      o_mem_en   : out   std_logic
    );
  end component project_reti_logiche;

begin

  uut : component project_reti_logiche
    port map (
      i_clk   => tb_clk,
      i_rst   => tb_rst,
      i_start => tb_start,
      i_add   => tb_add,
      i_k     => tb_k,

      o_done => tb_done,

      o_mem_addr => exc_o_mem_addr,
      i_mem_data => tb_i_mem_data,
      o_mem_data => exc_o_mem_data,
      o_mem_we   => exc_o_mem_we,
      o_mem_en   => exc_o_mem_en
    );

  -- Clock generation
  tb_clk <= not tb_clk after clock_period / 2;

  -- Process related to the memory
  mem : process (tb_clk) is
  begin

    if (tb_clk'event and tb_clk = '1') then
      if (tb_o_mem_en = '1') then
        if (tb_o_mem_we = '1') then
          ram(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
          tb_i_mem_data                            <= tb_o_mem_data after 1 ns;
        else
          tb_i_mem_data <= ram(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
        end if;
      end if;
    end if;

  end process mem;

  memory_signal_swapper : process (memory_control, init_o_mem_addr, init_o_mem_data,
                                   init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                   exc_o_mem_data, exc_o_mem_en, exc_o_mem_we) is
  begin

    -- This is necessary for the testbench to work: we swap the memory
    -- signals from the component to the testbench when needed.

    tb_o_mem_addr <= init_o_mem_addr;
    tb_o_mem_data <= init_o_mem_data;
    tb_o_mem_en   <= init_o_mem_en;
    tb_o_mem_we   <= init_o_mem_we;

    if (memory_control = '1') then
      tb_o_mem_addr <= exc_o_mem_addr;
      tb_o_mem_data <= exc_o_mem_data;
      tb_o_mem_en   <= exc_o_mem_en;
      tb_o_mem_we   <= exc_o_mem_we;
    end if;

  end process memory_signal_swapper;

  -- This process provides the correct scenario on the signal controlled by the TB
  create_scenario : process is
  begin

    wait for 50 ns;

    -- Signal initialization and reset of the component
    tb_start <= '0';
    tb_add   <= (others => '0');                                                  -- All zeros
    tb_k     <= (others => '0');                                                  -- All zeros
    tb_rst   <= '1';

    -- Wait some time for the component to reset...
    wait for 50 ns;

    tb_rst         <= '0';
    memory_control <= '0';                                                        -- Memory controlled by the testbench

    wait until falling_edge(tb_clk);                                              -- Skew the testbench transitions with respect to the clock

    -- Configure the memory
    for i in 0 to scenario_length * 2 - 1 loop

      init_o_mem_addr <= std_logic_vector(to_unsigned(scenario_address + i, 16));
      init_o_mem_data <= std_logic_vector(to_unsigned(scenario_input(i), 8));
      init_o_mem_en   <= '1';
      init_o_mem_we   <= '1';
      wait until rising_edge(tb_clk);

    end loop;

    wait until falling_edge(tb_clk);

    memory_control <= '1';                                                        -- Memory controlled by the component

    tb_add <= std_logic_vector(to_unsigned(scenario_address, 16));
    tb_k   <= std_logic_vector(to_unsigned(scenario_length, 10));

    tb_start <= '1';

    while tb_done /= '1' loop

      wait until rising_edge(tb_clk);

    end loop;

    wait for 5 ns;

    tb_start <= '0';

    wait;

  end process create_scenario;

  -- Process without sensitivity list designed to test the actual component.
  test_routine : process is
  begin

    wait until tb_rst = '1';
    wait for 25 ns;
    assert tb_done = '0'
      report "TEST FALLITO o_done !=0 during reset"
      severity failure;
    wait until tb_rst = '0';

    wait until falling_edge(tb_clk);
    assert tb_done = '0'
      report "TEST FALLITO o_done !=0 after reset before start"
      severity failure;

    wait until rising_edge(tb_start);

    while tb_done /= '1' loop

      wait until rising_edge(tb_clk);

    end loop;

    assert tb_o_mem_en = '0' or tb_o_mem_we = '0'
      report "TEST FALLITO o_mem_en !=0 memory should not be written after done."
      severity failure;

    for i in 0 to scenario_length * 2 - 1 loop

      assert ram(scenario_address + i) = std_logic_vector(to_unsigned(scenario_full(i), 8))
        report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(ram(scenario_address + i))))
        severity failure;

    end loop;

    wait until falling_edge(tb_start);
    assert tb_done = '1'
      report "TEST FALLITO o_done !=0 after reset before start"
      severity failure;
    wait until falling_edge(tb_done);

    assert false
      report "Simulation Ended! TEST PASSATO (EXAMPLE)"
      severity failure;

  end process test_routine;

end architecture probability_0_arch;

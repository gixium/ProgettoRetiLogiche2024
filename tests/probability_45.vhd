-- TB EXAMPLE PFRL 2023-2024

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use std.textio.all;

entity probability_45 is
end entity probability_45;

architecture probability_45_arch of probability_45 is

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

  constant scenario_length : integer := 133;

  type scenario_type is array (0 to scenario_length * 2 - 1) of integer;

  signal   scenario_input   : scenario_type := (56,  0, 193,  0, 215,  0, 0,  0, 0,  0, 78,  0, 11,  0, 34,  0, 242,  0, 0,  0, 120,  0, 167,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 136,  0, 113,  0, 116,  0, 0,  0, 81,  0, 172,  0, 0,  0, 172,  0, 0,  0, 90,  0, 0,  0, 0,  0, 0,  0, 50,  0, 0,  0, 0,  0, 126,  0, 243,  0, 2,  0, 137,  0, 0,  0, 0,  0, 10,  0, 108,  0, 0,  0, 124,  0, 58,  0, 118,  0, 141,  0, 32,  0, 162,  0, 0,  0, 145,  0, 0,  0, 0,  0, 226,  0, 0,  0, 0,  0, 0,  0, 222,  0, 74,  0, 102,  0, 200,  0, 71,  0, 152,  0, 0,  0, 0,  0, 0,  0, 37,  0, 171,  0, 127,  0, 25,  0, 126,  0, 137,  0, 0,  0, 134,  0, 0,  0, 0,  0, 0,  0, 114,  0, 0,  0, 126,  0, 102,  0, 254,  0, 115,  0, 190,  0, 17,  0, 0,  0, 174,  0, 126,  0, 210,  0, 248,  0, 0,  0, 121,  0, 0,  0, 0,  0, 88,  0, 25,  0, 82,  0, 0,  0, 0,  0, 0,  0, 0,  0, 208,  0, 232,  0, 170,  0, 0,  0, 204,  0, 247,  0, 0,  0, 0,  0, 0,  0, 142,  0, 132,  0, 147,  0, 0,  0, 0,  0, 0,  0, 0,  0, 33,  0, 1,  0, 0,  0, 0,  0, 114,  0, 0,  0, 23,  0, 0,  0, 0,  0, 48,  0, 173,  0, 98,  0, 130,  0, 94,  0, 0,  0, 0,  0);
  signal   scenario_full    : scenario_type := (56, 31, 193, 31, 215, 31, 215, 30, 215, 29, 78, 31, 11, 31, 34, 31, 242, 31, 242, 30, 120, 31, 167, 31, 167, 30, 167, 29, 167, 28, 167, 27, 167, 26, 167, 25, 136, 31, 113, 31, 116, 31, 116, 30, 81, 31, 172, 31, 172, 30, 172, 31, 172, 30, 90, 31, 90, 30, 90, 29, 90, 28, 50, 31, 50, 30, 50, 29, 126, 31, 243, 31, 2, 31, 137, 31, 137, 30, 137, 29, 10, 31, 108, 31, 108, 30, 124, 31, 58, 31, 118, 31, 141, 31, 32, 31, 162, 31, 162, 30, 145, 31, 145, 30, 145, 29, 226, 31, 226, 30, 226, 29, 226, 28, 222, 31, 74, 31, 102, 31, 200, 31, 71, 31, 152, 31, 152, 30, 152, 29, 152, 28, 37, 31, 171, 31, 127, 31, 25, 31, 126, 31, 137, 31, 137, 30, 134, 31, 134, 30, 134, 29, 134, 28, 114, 31, 114, 30, 126, 31, 102, 31, 254, 31, 115, 31, 190, 31, 17, 31, 17, 30, 174, 31, 126, 31, 210, 31, 248, 31, 248, 30, 121, 31, 121, 30, 121, 29, 88, 31, 25, 31, 82, 31, 82, 30, 82, 29, 82, 28, 82, 27, 208, 31, 232, 31, 170, 31, 170, 30, 204, 31, 247, 31, 247, 30, 247, 29, 247, 28, 142, 31, 132, 31, 147, 31, 147, 30, 147, 29, 147, 28, 147, 27, 33, 31, 1, 31, 1, 30, 1, 29, 114, 31, 114, 30, 23, 31, 23, 30, 23, 29, 48, 31, 173, 31, 98, 31, 130, 31, 94, 31, 94, 30, 94, 29);
  constant scenario_address : integer       := 646;

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

end architecture probability_45_arch;

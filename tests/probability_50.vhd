-- TB EXAMPLE PFRL 2023-2024

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use std.textio.all;

entity probability_50 is
end entity probability_50;

architecture probability_50_arch of probability_50 is

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

  constant scenario_length : integer := 177;

  type scenario_type is array (0 to scenario_length * 2 - 1) of integer;

  signal   scenario_input   : scenario_type := (0,  0, 39,  0, 0,  0, 245,  0, 85,  0, 0,  0, 0,  0, 0,  0, 0,  0, 101,  0, 210,  0, 245,  0, 0,  0, 0,  0, 82,  0, 231,  0, 253,  0, 135,  0, 60,  0, 101,  0, 0,  0, 247,  0, 40,  0, 228,  0, 0,  0, 0,  0, 161,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 233,  0, 0,  0, 0,  0, 0,  0, 196,  0, 135,  0, 21,  0, 177,  0, 236,  0, 103,  0, 0,  0, 85,  0, 57,  0, 0,  0, 189,  0, 0,  0, 1,  0, 249,  0, 0,  0, 131,  0, 0,  0, 195,  0, 231,  0, 199,  0, 35,  0, 0,  0, 0,  0, 0,  0, 76,  0, 0,  0, 163,  0, 0,  0, 146,  0, 0,  0, 0,  0, 215,  0, 82,  0, 0,  0, 0,  0, 0,  0, 0,  0, 48,  0, 0,  0, 44,  0, 0,  0, 0,  0, 227,  0, 0,  0, 204,  0, 0,  0, 0,  0, 62,  0, 68,  0, 22,  0, 0,  0, 103,  0, 0,  0, 92,  0, 0,  0, 0,  0, 0,  0, 0,  0, 34,  0, 18,  0, 0,  0, 0,  0, 233,  0, 0,  0, 0,  0, 0,  0, 88,  0, 149,  0, 35,  0, 0,  0, 65,  0, 0,  0, 191,  0, 0,  0, 118,  0, 0,  0, 165,  0, 0,  0, 0,  0, 233,  0, 0,  0, 0,  0, 208,  0, 0,  0, 45,  0, 41,  0, 0,  0, 0,  0, 37,  0, 231,  0, 0,  0, 0,  0, 0,  0, 39,  0, 0,  0, 161,  0, 0,  0, 0,  0, 0,  0, 0,  0, 76,  0, 0,  0, 0,  0, 139,  0, 30,  0, 255,  0, 0,  0, 67,  0, 36,  0, 98,  0, 172,  0, 221,  0, 0,  0, 0,  0, 182,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 100,  0, 73,  0, 185,  0, 0,  0, 0,  0, 0,  0, 133,  0, 0,  0, 157,  0, 0,  0, 198,  0, 105,  0, 53,  0, 0,  0, 245,  0, 0,  0, 80,  0, 14,  0, 23,  0, 116,  0, 112,  0);
  signal   scenario_full    : scenario_type := (0, 0, 39, 31, 39, 30, 245, 31, 85, 31, 85, 30, 85, 29, 85, 28, 85, 27, 101, 31, 210, 31, 245, 31, 245, 30, 245, 29, 82, 31, 231, 31, 253, 31, 135, 31, 60, 31, 101, 31, 101, 30, 247, 31, 40, 31, 228, 31, 228, 30, 228, 29, 161, 31, 161, 30, 161, 29, 161, 28, 161, 27, 161, 26, 233, 31, 233, 30, 233, 29, 233, 28, 196, 31, 135, 31, 21, 31, 177, 31, 236, 31, 103, 31, 103, 30, 85, 31, 57, 31, 57, 30, 189, 31, 189, 30, 1, 31, 249, 31, 249, 30, 131, 31, 131, 30, 195, 31, 231, 31, 199, 31, 35, 31, 35, 30, 35, 29, 35, 28, 76, 31, 76, 30, 163, 31, 163, 30, 146, 31, 146, 30, 146, 29, 215, 31, 82, 31, 82, 30, 82, 29, 82, 28, 82, 27, 48, 31, 48, 30, 44, 31, 44, 30, 44, 29, 227, 31, 227, 30, 204, 31, 204, 30, 204, 29, 62, 31, 68, 31, 22, 31, 22, 30, 103, 31, 103, 30, 92, 31, 92, 30, 92, 29, 92, 28, 92, 27, 34, 31, 18, 31, 18, 30, 18, 29, 233, 31, 233, 30, 233, 29, 233, 28, 88, 31, 149, 31, 35, 31, 35, 30, 65, 31, 65, 30, 191, 31, 191, 30, 118, 31, 118, 30, 165, 31, 165, 30, 165, 29, 233, 31, 233, 30, 233, 29, 208, 31, 208, 30, 45, 31, 41, 31, 41, 30, 41, 29, 37, 31, 231, 31, 231, 30, 231, 29, 231, 28, 39, 31, 39, 30, 161, 31, 161, 30, 161, 29, 161, 28, 161, 27, 76, 31, 76, 30, 76, 29, 139, 31, 30, 31, 255, 31, 255, 30, 67, 31, 36, 31, 98, 31, 172, 31, 221, 31, 221, 30, 221, 29, 182, 31, 182, 30, 182, 29, 182, 28, 182, 27, 182, 26, 100, 31, 73, 31, 185, 31, 185, 30, 185, 29, 185, 28, 133, 31, 133, 30, 157, 31, 157, 30, 198, 31, 105, 31, 53, 31, 53, 30, 245, 31, 245, 30, 80, 31, 14, 31, 23, 31, 116, 31, 112, 31);
  constant scenario_address : integer       := 662;

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

end architecture probability_50_arch;

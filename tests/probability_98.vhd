-- TB EXAMPLE PFRL 2023-2024

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use std.textio.all;

entity probability_98 is
end entity probability_98;

architecture probability_98_arch of probability_98 is

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

  constant scenario_length : integer := 49;

  type scenario_type is array (0 to scenario_length * 2 - 1) of integer;

  signal   scenario_input   : scenario_type := (0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 121,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0);
  signal   scenario_full    : scenario_type := (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 121, 31, 121, 30, 121, 29, 121, 28, 121, 27, 121, 26, 121, 25, 121, 24, 121, 23, 121, 22, 121, 21);
  constant scenario_address : integer       := 272;

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

end architecture probability_98_arch;

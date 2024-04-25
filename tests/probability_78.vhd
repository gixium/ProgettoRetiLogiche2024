-- TB EXAMPLE PFRL 2023-2024

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use std.textio.all;

entity probability_78 is
end entity probability_78;

architecture probability_78_arch of probability_78 is

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

  constant scenario_length : integer := 174;

  type scenario_type is array (0 to scenario_length * 2 - 1) of integer;

  signal   scenario_input   : scenario_type := (0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 6,  0, 0,  0, 9,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 31,  0, 0,  0, 0,  0, 218,  0, 0,  0, 0,  0, 0,  0, 0,  0, 200,  0, 182,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 111,  0, 116,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 78,  0, 0,  0, 252,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 223,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 133,  0, 149,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 80,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 69,  0, 0,  0, 0,  0, 0,  0, 49,  0, 0,  0, 108,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 144,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 184,  0, 0,  0, 0,  0, 0,  0, 25,  0, 0,  0, 0,  0, 0,  0, 234,  0, 0,  0, 86,  0, 0,  0, 0,  0, 0,  0, 0,  0, 133,  0, 0,  0, 139,  0, 0,  0, 0,  0, 0,  0, 0,  0, 104,  0, 0,  0, 52,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 155,  0, 96,  0, 0,  0, 235,  0, 0,  0, 47,  0, 0,  0, 43,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 110,  0, 0,  0, 0,  0, 23,  0, 217,  0, 210,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 94,  0, 0,  0, 0,  0, 0,  0);
  signal   scenario_full    : scenario_type := (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 31, 6, 30, 9, 31, 9, 30, 9, 29, 9, 28, 9, 27, 9, 26, 31, 31, 31, 30, 31, 29, 218, 31, 218, 30, 218, 29, 218, 28, 218, 27, 200, 31, 182, 31, 182, 30, 182, 29, 182, 28, 182, 27, 182, 26, 182, 25, 182, 24, 182, 23, 182, 22, 182, 21, 182, 20, 111, 31, 116, 31, 116, 30, 116, 29, 116, 28, 116, 27, 116, 26, 78, 31, 78, 30, 252, 31, 252, 30, 252, 29, 252, 28, 252, 27, 252, 26, 252, 25, 252, 24, 252, 23, 252, 22, 252, 21, 252, 20, 252, 19, 252, 18, 223, 31, 223, 30, 223, 29, 223, 28, 223, 27, 223, 26, 223, 25, 223, 24, 223, 23, 223, 22, 223, 21, 223, 20, 223, 19, 223, 18, 223, 17, 223, 16, 133, 31, 149, 31, 149, 30, 149, 29, 149, 28, 149, 27, 149, 26, 80, 31, 80, 30, 80, 29, 80, 28, 80, 27, 80, 26, 80, 25, 69, 31, 69, 30, 69, 29, 69, 28, 49, 31, 49, 30, 108, 31, 108, 30, 108, 29, 108, 28, 108, 27, 108, 26, 108, 25, 144, 31, 144, 30, 144, 29, 144, 28, 144, 27, 144, 26, 144, 25, 144, 24, 144, 23, 144, 22, 144, 21, 144, 20, 144, 19, 184, 31, 184, 30, 184, 29, 184, 28, 25, 31, 25, 30, 25, 29, 25, 28, 234, 31, 234, 30, 86, 31, 86, 30, 86, 29, 86, 28, 86, 27, 133, 31, 133, 30, 139, 31, 139, 30, 139, 29, 139, 28, 139, 27, 104, 31, 104, 30, 52, 31, 52, 30, 52, 29, 52, 28, 52, 27, 52, 26, 52, 25, 155, 31, 96, 31, 96, 30, 235, 31, 235, 30, 47, 31, 47, 30, 43, 31, 43, 30, 43, 29, 43, 28, 43, 27, 43, 26, 43, 25, 43, 24, 110, 31, 110, 30, 110, 29, 23, 31, 217, 31, 210, 31, 210, 30, 210, 29, 210, 28, 210, 27, 210, 26, 94, 31, 94, 30, 94, 29, 94, 28);
  constant scenario_address : integer       := 942;

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

end architecture probability_78_arch;

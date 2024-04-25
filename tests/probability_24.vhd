-- TB EXAMPLE PFRL 2023-2024

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use std.textio.all;

entity probability_24 is
end entity probability_24;

architecture probability_24_arch of probability_24 is

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

  constant scenario_length : integer := 134;

  type scenario_type is array (0 to scenario_length * 2 - 1) of integer;

  signal   scenario_input   : scenario_type := (66,  0, 194,  0, 108,  0, 14,  0, 253,  0, 190,  0, 233,  0, 145,  0, 22,  0, 22,  0, 0,  0, 0,  0, 238,  0, 49,  0, 23,  0, 0,  0, 186,  0, 0,  0, 119,  0, 157,  0, 223,  0, 154,  0, 109,  0, 92,  0, 253,  0, 22,  0, 226,  0, 188,  0, 253,  0, 191,  0, 167,  0, 0,  0, 51,  0, 0,  0, 15,  0, 0,  0, 148,  0, 248,  0, 148,  0, 188,  0, 0,  0, 148,  0, 157,  0, 191,  0, 197,  0, 197,  0, 180,  0, 65,  0, 162,  0, 0,  0, 240,  0, 50,  0, 118,  0, 14,  0, 142,  0, 53,  0, 53,  0, 33,  0, 242,  0, 0,  0, 242,  0, 74,  0, 0,  0, 0,  0, 32,  0, 0,  0, 0,  0, 198,  0, 252,  0, 110,  0, 51,  0, 204,  0, 0,  0, 225,  0, 60,  0, 137,  0, 87,  0, 240,  0, 220,  0, 249,  0, 222,  0, 125,  0, 0,  0, 5,  0, 156,  0, 124,  0, 59,  0, 209,  0, 175,  0, 0,  0, 180,  0, 82,  0, 74,  0, 169,  0, 57,  0, 124,  0, 156,  0, 18,  0, 0,  0, 90,  0, 128,  0, 55,  0, 0,  0, 68,  0, 0,  0, 37,  0, 206,  0, 49,  0, 0,  0, 91,  0, 0,  0, 181,  0, 233,  0, 0,  0, 204,  0, 54,  0, 104,  0, 0,  0, 0,  0, 0,  0, 0,  0, 125,  0, 43,  0, 19,  0, 0,  0, 100,  0, 143,  0, 132,  0, 119,  0, 147,  0, 222,  0, 0,  0, 202,  0, 198,  0);
  signal   scenario_full    : scenario_type := (66, 31, 194, 31, 108, 31, 14, 31, 253, 31, 190, 31, 233, 31, 145, 31, 22, 31, 22, 31, 22, 30, 22, 29, 238, 31, 49, 31, 23, 31, 23, 30, 186, 31, 186, 30, 119, 31, 157, 31, 223, 31, 154, 31, 109, 31, 92, 31, 253, 31, 22, 31, 226, 31, 188, 31, 253, 31, 191, 31, 167, 31, 167, 30, 51, 31, 51, 30, 15, 31, 15, 30, 148, 31, 248, 31, 148, 31, 188, 31, 188, 30, 148, 31, 157, 31, 191, 31, 197, 31, 197, 31, 180, 31, 65, 31, 162, 31, 162, 30, 240, 31, 50, 31, 118, 31, 14, 31, 142, 31, 53, 31, 53, 31, 33, 31, 242, 31, 242, 30, 242, 31, 74, 31, 74, 30, 74, 29, 32, 31, 32, 30, 32, 29, 198, 31, 252, 31, 110, 31, 51, 31, 204, 31, 204, 30, 225, 31, 60, 31, 137, 31, 87, 31, 240, 31, 220, 31, 249, 31, 222, 31, 125, 31, 125, 30, 5, 31, 156, 31, 124, 31, 59, 31, 209, 31, 175, 31, 175, 30, 180, 31, 82, 31, 74, 31, 169, 31, 57, 31, 124, 31, 156, 31, 18, 31, 18, 30, 90, 31, 128, 31, 55, 31, 55, 30, 68, 31, 68, 30, 37, 31, 206, 31, 49, 31, 49, 30, 91, 31, 91, 30, 181, 31, 233, 31, 233, 30, 204, 31, 54, 31, 104, 31, 104, 30, 104, 29, 104, 28, 104, 27, 125, 31, 43, 31, 19, 31, 19, 30, 100, 31, 143, 31, 132, 31, 119, 31, 147, 31, 222, 31, 222, 30, 202, 31, 198, 31);
  constant scenario_address : integer       := 455;

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

end architecture probability_24_arch;

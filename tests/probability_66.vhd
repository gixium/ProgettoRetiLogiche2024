-- TB EXAMPLE PFRL 2023-2024

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use std.textio.all;

entity probability_66 is
end entity probability_66;

architecture probability_66_arch of probability_66 is

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

  constant scenario_length : integer := 193;

  type scenario_type is array (0 to scenario_length * 2 - 1) of integer;

  signal   scenario_input   : scenario_type := (0,  0, 14,  0, 0,  0, 0,  0, 84,  0, 0,  0, 0,  0, 163,  0, 0,  0, 0,  0, 101,  0, 0,  0, 222,  0, 0,  0, 0,  0, 0,  0, 186,  0, 0,  0, 182,  0, 0,  0, 185,  0, 0,  0, 0,  0, 222,  0, 113,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 251,  0, 41,  0, 0,  0, 0,  0, 0,  0, 15,  0, 100,  0, 64,  0, 0,  0, 202,  0, 0,  0, 226,  0, 254,  0, 0,  0, 225,  0, 42,  0, 0,  0, 0,  0, 0,  0, 14,  0, 103,  0, 0,  0, 237,  0, 0,  0, 0,  0, 0,  0, 0,  0, 191,  0, 0,  0, 0,  0, 49,  0, 224,  0, 0,  0, 0,  0, 161,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 66,  0, 0,  0, 207,  0, 0,  0, 152,  0, 0,  0, 0,  0, 0,  0, 90,  0, 0,  0, 0,  0, 193,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 118,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 143,  0, 80,  0, 0,  0, 209,  0, 0,  0, 83,  0, 131,  0, 120,  0, 118,  0, 95,  0, 0,  0, 208,  0, 0,  0, 0,  0, 4,  0, 208,  0, 237,  0, 0,  0, 0,  0, 159,  0, 0,  0, 0,  0, 53,  0, 138,  0, 0,  0, 0,  0, 0,  0, 147,  0, 0,  0, 66,  0, 42,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 93,  0, 189,  0, 0,  0, 0,  0, 244,  0, 0,  0, 154,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 248,  0, 129,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 80,  0, 255,  0, 136,  0, 230,  0, 3,  0, 0,  0, 192,  0, 72,  0, 11,  0, 0,  0, 0,  0, 86,  0, 75,  0, 107,  0, 0,  0, 229,  0, 0,  0, 212,  0, 0,  0, 94,  0, 71,  0, 82,  0, 0,  0, 0,  0, 197,  0, 245,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 117,  0, 21,  0);
  signal   scenario_full    : scenario_type := (0, 0, 14, 31, 14, 30, 14, 29, 84, 31, 84, 30, 84, 29, 163, 31, 163, 30, 163, 29, 101, 31, 101, 30, 222, 31, 222, 30, 222, 29, 222, 28, 186, 31, 186, 30, 182, 31, 182, 30, 185, 31, 185, 30, 185, 29, 222, 31, 113, 31, 113, 30, 113, 29, 113, 28, 113, 27, 113, 26, 113, 25, 113, 24, 251, 31, 41, 31, 41, 30, 41, 29, 41, 28, 15, 31, 100, 31, 64, 31, 64, 30, 202, 31, 202, 30, 226, 31, 254, 31, 254, 30, 225, 31, 42, 31, 42, 30, 42, 29, 42, 28, 14, 31, 103, 31, 103, 30, 237, 31, 237, 30, 237, 29, 237, 28, 237, 27, 191, 31, 191, 30, 191, 29, 49, 31, 224, 31, 224, 30, 224, 29, 161, 31, 161, 30, 161, 29, 161, 28, 161, 27, 161, 26, 66, 31, 66, 30, 207, 31, 207, 30, 152, 31, 152, 30, 152, 29, 152, 28, 90, 31, 90, 30, 90, 29, 193, 31, 193, 30, 193, 29, 193, 28, 193, 27, 193, 26, 193, 25, 193, 24, 193, 23, 193, 22, 193, 21, 118, 31, 118, 30, 118, 29, 118, 28, 118, 27, 118, 26, 143, 31, 80, 31, 80, 30, 209, 31, 209, 30, 83, 31, 131, 31, 120, 31, 118, 31, 95, 31, 95, 30, 208, 31, 208, 30, 208, 29, 4, 31, 208, 31, 237, 31, 237, 30, 237, 29, 159, 31, 159, 30, 159, 29, 53, 31, 138, 31, 138, 30, 138, 29, 138, 28, 147, 31, 147, 30, 66, 31, 42, 31, 42, 30, 42, 29, 42, 28, 42, 27, 42, 26, 42, 25, 93, 31, 189, 31, 189, 30, 189, 29, 244, 31, 244, 30, 154, 31, 154, 30, 154, 29, 154, 28, 154, 27, 154, 26, 154, 25, 248, 31, 129, 31, 129, 30, 129, 29, 129, 28, 129, 27, 129, 26, 129, 25, 129, 24, 80, 31, 255, 31, 136, 31, 230, 31, 3, 31, 3, 30, 192, 31, 72, 31, 11, 31, 11, 30, 11, 29, 86, 31, 75, 31, 107, 31, 107, 30, 229, 31, 229, 30, 212, 31, 212, 30, 94, 31, 71, 31, 82, 31, 82, 30, 82, 29, 197, 31, 245, 31, 245, 30, 245, 29, 245, 28, 245, 27, 245, 26, 245, 25, 117, 31, 21, 31);
  constant scenario_address : integer       := 370;

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

end architecture probability_66_arch;

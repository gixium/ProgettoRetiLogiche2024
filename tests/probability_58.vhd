-- TB EXAMPLE PFRL 2023-2024

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use std.textio.all;

entity probability_8 is
end entity probability_8;

architecture probability_8_arch of probability_8 is

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

  constant scenario_length : integer := 351;

  type scenario_type is array (0 to scenario_length * 2 - 1) of integer;

  signal   scenario_input   : scenario_type := (0,  0, 138,  0, 0,  0, 175,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 129,  0, 0,  0, 0,  0, 58,  0, 0,  0, 0,  0, 151,  0, 158,  0, 0,  0, 99,  0, 0,  0, 0,  0, 0,  0, 212,  0, 123,  0, 0,  0, 151,  0, 0,  0, 193,  0, 0,  0, 219,  0, 0,  0, 187,  0, 0,  0, 116,  0, 162,  0, 0,  0, 0,  0, 0,  0, 0,  0, 205,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 249,  0, 1,  0, 0,  0, 0,  0, 0,  0, 30,  0, 212,  0, 0,  0, 23,  0, 134,  0, 0,  0, 0,  0, 122,  0, 0,  0, 0,  0, 0,  0, 0,  0, 140,  0, 0,  0, 0,  0, 0,  0, 176,  0, 0,  0, 38,  0, 0,  0, 111,  0, 102,  0, 66,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 85,  0, 0,  0, 0,  0, 0,  0, 176,  0, 0,  0, 0,  0, 110,  0, 0,  0, 224,  0, 232,  0, 193,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 105,  0, 0,  0, 135,  0, 144,  0, 98,  0, 247,  0, 246,  0, 164,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 238,  0, 0,  0, 0,  0, 153,  0, 0,  0, 0,  0, 0,  0, 51,  0, 78,  0, 0,  0, 84,  0, 0,  0, 0,  0, 0,  0, 121,  0, 103,  0, 73,  0, 0,  0, 9,  0, 129,  0, 0,  0, 0,  0, 227,  0, 0,  0, 199,  0, 191,  0, 0,  0, 0,  0, 0,  0, 18,  0, 212,  0, 175,  0, 0,  0, 104,  0, 128,  0, 131,  0, 0,  0, 0,  0, 183,  0, 0,  0, 142,  0, 67,  0, 121,  0, 0,  0, 0,  0, 43,  0, 0,  0, 0,  0, 0,  0, 197,  0, 0,  0, 41,  0, 150,  0, 91,  0, 0,  0, 150,  0, 83,  0, 0,  0, 33,  0, 0,  0, 0,  0, 45,  0, 0,  0, 178,  0, 0,  0, 0,  0, 0,  0, 0,  0, 151,  0, 0,  0, 179,  0, 0,  0, 0,  0, 100,  0, 0,  0, 220,  0, 143,  0, 0,  0, 0,  0, 0,  0, 157,  0, 0,  0, 163,  0, 0,  0, 0,  0, 0,  0, 0,  0, 200,  0, 0,  0, 0,  0, 21,  0, 78,  0, 0,  0, 0,  0, 0,  0, 0,  0, 148,  0, 0,  0, 6,  0, 99,  0, 251,  0, 0,  0, 192,  0, 4,  0, 85,  0, 0,  0, 24,  0, 29,  0, 0,  0, 0,  0, 0,  0, 80,  0, 205,  0, 0,  0, 187,  0, 0,  0, 28,  0, 0,  0, 0,  0, 0,  0, 128,  0, 0,  0, 0,  0, 0,  0, 161,  0, 0,  0, 0,  0, 110,  0, 0,  0, 0,  0, 209,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 165,  0, 0,  0, 0,  0, 88,  0, 73,  0, 0,  0, 0,  0, 78,  0, 0,  0, 0,  0, 201,  0, 0,  0, 0,  0, 118,  0, 0,  0, 0,  0, 0,  0, 50,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 111,  0, 0,  0, 0,  0, 0,  0, 15,  0, 138,  0, 38,  0, 240,  0, 0,  0, 131,  0, 87,  0, 192,  0, 4,  0, 0,  0, 161,  0, 0,  0, 0,  0, 0,  0, 84,  0, 135,  0, 0,  0, 2,  0, 0,  0, 40,  0, 0,  0, 0,  0, 27,  0, 0,  0, 141,  0, 0,  0, 216,  0, 252,  0, 37,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 92,  0, 195,  0, 0,  0, 0,  0, 187,  0, 202,  0, 0,  0, 0,  0, 85,  0, 0,  0, 65,  0, 0,  0, 0,  0, 0,  0, 0,  0, 188,  0, 224,  0, 37,  0, 25,  0, 51,  0, 0,  0, 167,  0, 213,  0, 0,  0, 219,  0, 250,  0, 0,  0, 41,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 0,  0, 101,  0, 46,  0, 110,  0, 0,  0);
  signal   scenario_full    : scenario_type := (0, 0, 138, 31, 138, 30, 175, 31, 175, 30, 175, 29, 175, 28, 175, 27, 175, 26, 129, 31, 129, 30, 129, 29, 58, 31, 58, 30, 58, 29, 151, 31, 158, 31, 158, 30, 99, 31, 99, 30, 99, 29, 99, 28, 212, 31, 123, 31, 123, 30, 151, 31, 151, 30, 193, 31, 193, 30, 219, 31, 219, 30, 187, 31, 187, 30, 116, 31, 162, 31, 162, 30, 162, 29, 162, 28, 162, 27, 205, 31, 205, 30, 205, 29, 205, 28, 205, 27, 205, 26, 205, 25, 205, 24, 205, 23, 205, 22, 205, 21, 249, 31, 1, 31, 1, 30, 1, 29, 1, 28, 30, 31, 212, 31, 212, 30, 23, 31, 134, 31, 134, 30, 134, 29, 122, 31, 122, 30, 122, 29, 122, 28, 122, 27, 140, 31, 140, 30, 140, 29, 140, 28, 176, 31, 176, 30, 38, 31, 38, 30, 111, 31, 102, 31, 66, 31, 66, 30, 66, 29, 66, 28, 66, 27, 66, 26, 85, 31, 85, 30, 85, 29, 85, 28, 176, 31, 176, 30, 176, 29, 110, 31, 110, 30, 224, 31, 232, 31, 193, 31, 193, 30, 193, 29, 193, 28, 193, 27, 193, 26, 193, 25, 105, 31, 105, 30, 135, 31, 144, 31, 98, 31, 247, 31, 246, 31, 164, 31, 164, 30, 164, 29, 164, 28, 164, 27, 164, 26, 238, 31, 238, 30, 238, 29, 153, 31, 153, 30, 153, 29, 153, 28, 51, 31, 78, 31, 78, 30, 84, 31, 84, 30, 84, 29, 84, 28, 121, 31, 103, 31, 73, 31, 73, 30, 9, 31, 129, 31, 129, 30, 129, 29, 227, 31, 227, 30, 199, 31, 191, 31, 191, 30, 191, 29, 191, 28, 18, 31, 212, 31, 175, 31, 175, 30, 104, 31, 128, 31, 131, 31, 131, 30, 131, 29, 183, 31, 183, 30, 142, 31, 67, 31, 121, 31, 121, 30, 121, 29, 43, 31, 43, 30, 43, 29, 43, 28, 197, 31, 197, 30, 41, 31, 150, 31, 91, 31, 91, 30, 150, 31, 83, 31, 83, 30, 33, 31, 33, 30, 33, 29, 45, 31, 45, 30, 178, 31, 178, 30, 178, 29, 178, 28, 178, 27, 151, 31, 151, 30, 179, 31, 179, 30, 179, 29, 100, 31, 100, 30, 220, 31, 143, 31, 143, 30, 143, 29, 143, 28, 157, 31, 157, 30, 163, 31, 163, 30, 163, 29, 163, 28, 163, 27, 200, 31, 200, 30, 200, 29, 21, 31, 78, 31, 78, 30, 78, 29, 78, 28, 78, 27, 148, 31, 148, 30, 6, 31, 99, 31, 251, 31, 251, 30, 192, 31, 4, 31, 85, 31, 85, 30, 24, 31, 29, 31, 29, 30, 29, 29, 29, 28, 80, 31, 205, 31, 205, 30, 187, 31, 187, 30, 28, 31, 28, 30, 28, 29, 28, 28, 128, 31, 128, 30, 128, 29, 128, 28, 161, 31, 161, 30, 161, 29, 110, 31, 110, 30, 110, 29, 209, 31, 209, 30, 209, 29, 209, 28, 209, 27, 209, 26, 165, 31, 165, 30, 165, 29, 88, 31, 73, 31, 73, 30, 73, 29, 78, 31, 78, 30, 78, 29, 201, 31, 201, 30, 201, 29, 118, 31, 118, 30, 118, 29, 118, 28, 50, 31, 50, 30, 50, 29, 50, 28, 50, 27, 50, 26, 111, 31, 111, 30, 111, 29, 111, 28, 15, 31, 138, 31, 38, 31, 240, 31, 240, 30, 131, 31, 87, 31, 192, 31, 4, 31, 4, 30, 161, 31, 161, 30, 161, 29, 161, 28, 84, 31, 135, 31, 135, 30, 2, 31, 2, 30, 40, 31, 40, 30, 40, 29, 27, 31, 27, 30, 141, 31, 141, 30, 216, 31, 252, 31, 37, 31, 37, 30, 37, 29, 37, 28, 37, 27, 37, 26, 92, 31, 195, 31, 195, 30, 195, 29, 187, 31, 202, 31, 202, 30, 202, 29, 85, 31, 85, 30, 65, 31, 65, 30, 65, 29, 65, 28, 65, 27, 188, 31, 224, 31, 37, 31, 25, 31, 51, 31, 51, 30, 167, 31, 213, 31, 213, 30, 219, 31, 250, 31, 250, 30, 41, 31, 41, 30, 41, 29, 41, 28, 41, 27, 41, 26, 41, 25, 41, 24, 41, 23, 101, 31, 46, 31, 110, 31, 110, 30);
  constant scenario_address : integer       := 1456;

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

end architecture probability_8_arch;

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- A word is the first byte in the sequence.
-- K words correspond to 2K bytes, where the second byte is the credibility value.

entity project_reti_logiche is
  port (
    i_clk   : in    std_logic;                     -- Clock
    i_rst   : in    std_logic;                     -- Reset
    i_start : in    std_logic;                     -- Start
    i_add   : in    std_logic_vector(15 downto 0); -- Start address
    i_k     : in    std_logic_vector(9 downto 0);  -- Sequence length

    o_done : out   std_logic; -- Elaboration finished

    o_mem_addr : out   std_logic_vector(15 downto 0); -- Memory address to read/write
    i_mem_data : in    std_logic_vector(7 downto 0);  -- Word read from the memory
    o_mem_data : out   std_logic_vector(7 downto 0);  -- Word or credibility value to write to the memory
    o_mem_we   : out   std_logic;                     -- Enable memory write if '1', read if '0'
    o_mem_en   : out   std_logic                      -- Enable memory communication
  );
end entity project_reti_logiche;

architecture main of project_reti_logiche is

  type state is (
    reset,
    start,
    check,
    read_w,
    wait_w,
    write_w,
    write_c,
    next_add,
    done,
    idle
  );

  signal current_state : state;

  signal words_left : unsigned(i_k'range);

  signal current_address : std_logic_vector(o_mem_addr'range);

  signal last_non_zero_word : unsigned(i_mem_data'range);

  signal credibility_value : unsigned(o_mem_data'range);

  constant max_credibility_value : unsigned := to_unsigned(31, credibility_value'length);

begin

  state_transition : process (i_rst, i_clk) is
  begin

    if (i_rst = '1') then                        -- Asynchronous reset
      current_state <= reset;
    elsif rising_edge(i_clk) then                -- Synchronous logic

      case current_state is

        when reset =>

          if (i_start = '1') then
            current_state <= start;
          end if;

        when start =>

          current_state <= check;

        when check =>

          if (words_left /= 0) then
            current_state <= read_w;
          else
            current_state <= done;
          end if;

        when read_w =>

          current_state <= wait_w;

        when wait_w =>

          current_state <= write_w;

        when write_w =>

          current_state <= write_c;

        when write_c =>

          current_state <= next_add;

        when next_add =>

          current_state <= check;

        when done =>

          if (i_start = '0') then
            current_state <= idle;
          end if;

        when idle =>

          if (i_start = '1') then
            current_state <= start;
          end if;

      end case;

    end if;

  end process state_transition;

  output : process (current_state) is
  begin

    o_mem_en <= '0';
    o_mem_we <= '0';

    o_mem_addr <= (others => '0');
    o_mem_data <= (others => '0');

    o_done <= '0';

    case current_state is

      when read_w =>

        o_mem_en <= '1';

        o_mem_addr <= current_address;

      when write_w =>

        o_mem_en <= '1';
        o_mem_we <= '1';

        if (unsigned(i_mem_data) = 0) then
          o_mem_addr <= current_address;
          o_mem_data <= std_logic_vector(last_non_zero_word);
        end if;

      when write_c =>

        o_mem_en <= '1';
        o_mem_we <= '1';

        o_mem_addr <= std_logic_vector(unsigned(current_address) + 1);
        o_mem_data <= std_logic_vector(credibility_value);

      when done =>

        o_done <= '1';

      when others =>

        null;

    end case;

  end process output;

  registers : process (i_rst, i_clk) is
  begin

    if (i_rst = '1') then
      current_address    <= (others => '0');
      words_left         <= to_unsigned(0, words_left'length);
      last_non_zero_word <= to_unsigned(0, last_non_zero_word'length);
      credibility_value  <= to_unsigned(0, credibility_value'length);
    elsif rising_edge(i_clk) then

      case current_state is

        when start =>

          current_address    <= i_add;
          words_left         <= unsigned(i_k);
          last_non_zero_word <= to_unsigned(0, last_non_zero_word'length);
          credibility_value  <= to_unsigned(0, credibility_value'length);

        when write_w =>

          if (unsigned(i_mem_data) /= 0) then
            last_non_zero_word <= unsigned(i_mem_data);
            credibility_value  <= max_credibility_value;
          else
            if (credibility_value /= 0) then
              credibility_value <= credibility_value - 1;
            end if;
          end if;

        when next_add =>

          current_address <= std_logic_vector(unsigned(current_address) + 2);
          words_left      <= words_left - 1;

        when others =>

          null;

      end case;

    end if;

  end process registers;

end architecture main;

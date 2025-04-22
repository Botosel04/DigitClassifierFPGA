library IEEE;
use    IEEE.STD_LOGIC_1164.ALL;
use    IEEE.NUMERIC_STD.ALL;
use work.Types.all;


entity Layer is
  generic (
    input_size  : positive := 784;
    output_size : positive := 128
  );
  port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    start         : in  std_logic;
    input_weights : in  vector_t(0 to input_size*output_size-1);
    input_bias    : in  vector_t(0 to output_size-1);
    input_vector  : in  vector_t(0 to input_size-1);
    output_vector : out vector_t(0 to output_size-1);
    output_ready  : out std_logic
  );
end entity Layer;

        
architecture Behavioral of Layer is
  constant ACC_WIDTH : integer := 16;
  subtype acc_t      is signed(ACC_WIDTH-1 downto 0);
  signal neuron_done : std_logic_vector(0 to output_size-1);
  constant ALL_ONES : std_logic_vector(0 to output_size-1) := (others => '1');  
begin
    
  label0 : for i in 0 to output_size-1 generate
    signal acc    : acc_t := (others => '0');
    signal j_idx  : integer range 0 to input_size := 0;
    signal done_i : std_logic := '0';
    signal all_done : std_logic := '0';

  begin
    proc_neuron: process(clk, reset)
    begin
      if reset = '1' then
        j_idx      <= 0;
        acc        <= (others => '0');
        done_i     <= '0';

      elsif rising_edge(clk) then
        if start = '1' then

          if j_idx = 0 then
            acc <= resize(input_bias(i), ACC_WIDTH);
          end if;
          if j_idx < input_size then
            acc   <= acc
                   + resize(input_vector(j_idx), ACC_WIDTH)
                   * resize(input_weights(i*input_size + j_idx), ACC_WIDTH);
            j_idx <= j_idx + 1;

          else
            if acc < 0 then
              output_vector(i) <= (others => '0');
            else
              output_vector(i) <= resize(acc, output_vector(i)'length);
            end if;
            done_i <= '1';
          end if;

        else
          j_idx  <= 0;
          done_i <= '0';
        end if;
      end if;
    end process proc_neuron;

    neuron_done(i) <= done_i;
    all_done <= '1' when neuron_done = ALL_ONES else '0';
    
  end generate label0;

end architecture Behavioral;

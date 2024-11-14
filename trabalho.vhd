LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY pacman_state_machine IS
	PORT (
		clk : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		start : IN STD_LOGIC;
		ghost_near : IN STD_LOGIC;
		dot_eaten : IN STD_LOGIC;
		power_pellet : IN STD_LOGIC;
		game_over : OUT STD_LOGIC;
		state_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END pacman_state_machine;

ARCHITECTURE Behavioral OF pacman_state_machine IS
	TYPE state_type IS (IDLE, MOVING, EATING, ESCAPING, GAME_OVER);
	SIGNAL state, next_state : state_type;
BEGIN

	-- Process for state transition
	PROCESS (clk, reset)
	BEGIN
		IF reset = '1' THEN
			state <= IDLE;
		ELSIF rising_edge(clk) THEN
			state <= next_state;
		END IF;
	END PROCESS;

	-- Process for next state logic
	PROCESS (state, start, ghost_near, dot_eaten, power_pellet)
	BEGIN
		CASE state IS
			WHEN IDLE =>
				IF start = '1' THEN
					next_state <= MOVING;
				ELSE
					next_state <= IDLE;
				END IF;

			WHEN MOVING =>
				IF dot_eaten = '1' THEN
					next_state <= EATING;
				ELSIF ghost_near = '1' AND power_pellet = '0' THEN
					next_state <= ESCAPING;
				ELSIF power_pellet = '1' THEN
					next_state <= EATING;
				ELSE
					next_state <= MOVING;
				END IF;

			WHEN EATING =>
				IF dot_eaten = '0' THEN
					next_state <= MOVING;
				END IF;

			WHEN ESCAPING =>
				IF ghost_near = '0' THEN
					next_state <= MOVING;
				END IF;

			WHEN GAME_OVER =>
				next_state <= GAME_OVER;

			WHEN OTHERS =>
				next_state <= IDLE;
		END CASE;
	END PROCESS;

	-- Output logic
	PROCESS (state)
	BEGIN
		CASE state IS
			WHEN IDLE =>
				game_over <= '0';
				state_out <= "000";

			WHEN MOVING =>
				game_over <= '0';
				state_out <= "001";

			WHEN EATING =>
				game_over <= '0';
				state_out <= "010";

			WHEN ESCAPING =>
				game_over <= '0';
				state_out <= "011";

			WHEN GAME_OVER =>
				game_over <= '1';
				state_out <= "100";

			WHEN OTHERS =>
				game_over <= '0';
				state_out <= "000";
		END CASE;
	END PROCESS;
END Behavioral;
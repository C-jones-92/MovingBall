----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2022 11:01:16 AM
-- Design Name: 
-- Module Name: MovingBall - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MovingBall is
port(
      pixel_clk : IN std_logic;
      SW : in std_logic_vector(15 downto 0);
      scr2 : inout std_logic_vector(3 downto 0);
      paddleX : in std_logic_vector(11 downto 0);
      paddleY : in std_logic_vector(11 downto 0); 
      hcount : IN std_logic_vector(11 downto 0);
      vcount : IN std_logic_vector(11 downto 0);  
      leftmousebutton: in std_logic;        
      enable : OUT std_logic;
      reset  : in std_logic;
      red_out : OUT std_logic_vector(3 downto 0);
      green_out : OUT std_logic_vector(3 downto 0);
      blue_out : OUT std_logic_vector(3 downto 0));
end MovingBall;

architecture Behavioral of MovingBall is

type displayrom is array(0 to 255) of std_logic_vector(1 downto 0);
constant ball : displayrom :=(
    "01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01",
	"01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01",
	"01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01",
	"01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01",
	"01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01",
	"01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01",
	"01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01",
	"01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01",
	"01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01",
	"01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01",
	"01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01",
	"01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01",
	"01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01",
	"01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01",
	"01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01",
	"01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01"
	);
constant OFFSET: std_logic_vector(4 downto 0) := "10000";   -- 16

signal BallPixel : std_logic_vector(1 downto 0) := (others => '0');
signal enableBall : std_logic := '0';
signal xdiff: std_logic_vector(3 downto 0) := (others => '0');
signal ydiff: std_logic_vector(3 downto 0) := (others => '0');
signal xpos : std_logic_vector(11 downto 0):= (others => '0');
signal ypos : std_logic_vector(11 downto 0):= (others => '0');
signal DeltaX: std_logic_vector(3 downto 0) := "0001";
signal DeltaY: std_logic_vector(3 downto 0) := "0001";
signal jumpSpeed : std_logic_vector(23 downto 0) := x"0493E0";
signal count : std_logic_vector(23 downto 0) := (others => '0');
signal count2 : std_logic_vector(31 downto 0) := (others => '0');
signal count3 : std_logic_vector(31 downto 0) := (others => '0');
signal xint : std_logic_vector(11 downto 0);
signal yint : std_logic_vector(11 downto 0);
constant xmin : std_logic_vector(11 downto 0) := "000000000000";
constant ymin : std_logic_vector(11 downto 0) := "000000001111";
constant xmax : std_logic_vector(11 downto 0) := "010011110000";
constant ymax : std_logic_vector(11 downto 0) := "001111110000";
signal risky : std_logic;
signal temp : std_logic_vector(3 downto 0);
signal countJump : integer range 0 to 64 := 0;
begin
   x_diff: process(hcount, xpos)
   variable temp_diff: std_logic_vector(11 downto 0) := (others => '0');
   begin
         temp_diff := hcount - xpos;
         xdiff <= temp_diff(3 downto 0);
   end process x_diff;
   
   y_diff: process(vcount, xpos)
   variable temp_diff: std_logic_vector(11 downto 0) := (others => '0');
   begin
         temp_diff := vcount - ypos;
         ydiff <= temp_diff(3 downto 0);
   end process y_diff;
   
   setPos: process(pixel_clk) begin
       if(rising_edge(pixel_clk)) then
       if(leftmousebutton = '1') then
        risky <= not(risky);
        end if;
        if(sw(15) = '1') then
            jumpspeed <= x"0249f0";
        else
            jumpspeed <= x"0493E0";
        end if;
            count <= count + 1;
            count2 <= count2 + 1;
            if(count > JumpSpeed) then
                count <= (others => '0');
                    if(deltax(3 downto 3) = "1") then
                            xint <= xpos - deltax(2 downto 0);
                    else
                            xint <= xpos + deltax(2 downto 0);
                    end if;
                    
                    if(deltay(3 downto 3) = "1") then
                            yint <= ypos - deltay(2 downto 0);
                    else
                            yint <= ypos + deltay(2 downto 0);
                    end if; 
                    
                    if((xint >= paddleX and xint <= paddleX + 32) and (yint = paddleY or yint = paddleY+16 or yint = paddley+deltay or yint = paddley+16-deltay)) or 
                    ((xint+16 >= paddleX and xint+16 <= paddleX + 32) and (yint = paddleY or yint = paddleY+16 or yint = paddley+deltay or yint = paddley+16-deltay)) or
                    ((xint >= paddleX and xint <= paddleX + 32) and (yint = paddleY or yint+16 = paddleY+16 or yint = paddley+deltay or yint = paddley+16-deltay)) or
                    ((xint+16 >= paddleX and xint+16 <= paddleX + 32) and (yint = paddleY or yint+16 = paddleY+16 or yint = paddley+deltay or yint = paddley+16-deltay)) then
                        deltax <= count2(15 downto 13)&'1';
                        deltay <= count2(11 downto 9)&'1';
                        countJump <= 0;
                        if(risky = '1') then
                                temp <= "0000" + deltax(2 downto 0) + deltay(2 downto 0);
                                scr2 <= scr2 + temp;
                        else
                            if(scr2 = "1001") then
                                scr2 <= "0000";
                            else
                                if(SW(15) = '1') then
                                scr2 <= scr2 +2;
                                else
                                scr2 <= scr2 +1;
                                end if;
                            end if;
                        end if; 
                    end if;
                    
                    if(xint < deltax(2 downto 0)) then
                        deltax <= '0' & count2(13 downto 12) & '1';  
                        xpos <= xmin;
                        countJump <= countJump +1;    
                    elsif(xint > xmax) then
                        deltax <= '1' & count2(4 downto 3) & '1';
                        xpos <= xmax;
                        countJump <= countJump +1;  
                    else
                        xpos <= xint;
                        countJump <= countJump +1;  
                    end if;
                   
                    if(yint <= 15) then
                        deltay <= '0' & count2(18 downto 17) & '1';
                        ypos <= ymin;
                        countJump <= countJump +1;  
                    elsif(yint > ymax) then
                        deltay <= '1' & count2(1 downto 0)  & '1';   
                        ypos <= ymax; 
                        countJump <= countJump +1;     
                    else
                        ypos <= yint;
                        countJump <= countJump +1;  
                    end if;      
                    
                    if(countJump > 64) then
                        scr2 <= "1111";
                    end if;
                              
            end if;
        end if;
   end process;        
   BallPixel <= ball(conv_integer(ydiff & xdiff));
   
   enable_Ball: process(pixel_clk, hcount, vcount, xpos, ypos)
   begin
      if(rising_edge(pixel_clk)) then
         if((hcount >= xpos +X"001" and hcount < (xpos + OFFSET - X"001") and vcount >= ypos and vcount < (ypos + OFFSET)) and (BallPixel = "00" or BallPixel = "01")) then
            enableBall <= '1';
         else
            enableBall<= '0';
         end if;
      end if;
   end process enable_Ball;
   
    enable <= enableBall;
    
     process(pixel_clk)
   begin
         if(rising_edge(pixel_clk)) then
            if(enableBall = '1') then   
               if(BallPixel = "01" and SW(15) = '1') then
                  red_out <= (others => '1');
                  green_out <= (others => '0');
                  blue_out <= (others => '0');
               elsif(BallPixel = "01") then
                    red_out <= (others => '1');
                  green_out <= (others => '1');
                  blue_out <= (others => '1');
               end if;
            end if;
      end if;
   end process;
  
end Behavioral;


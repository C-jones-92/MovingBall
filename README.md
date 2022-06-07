# MovingBall
Change the mouse cursor based on switches SW(15 downto 13) as follows:
These switches do not have any effect on the VGA background picture.
SW(15) = ‘0’ displays the original arrow cursor
SW(15) = ‘1’ displays a square 16x16 cursor
SW(14) = ‘0’ displays the cursor with its original white color
SW(14) = ‘1’ changes the cursor color to red in both the arrow and square case.
SW(13) = ‘0’ displays the mouse cursor, specified by SW(14), SW(15).
SW(13) = ‘1’ turns off the mouse cursor, regardless of SW(14), SW(15).

Change the background VGA picture based on switches SW(12 downto 11) as follows.
These switches do not have any effect on the mouse cursor.
 SW(12) = ‘0’ displays the original moving colorful pattern
 SW(12) = ‘1’ displays exactly the same colorful pattern, however, it freezes its movement
 SW(11) = ‘0’ displays either moving or frozen colorful pattern, specified by SW(12)
 SW(11) = ‘1’ VGA background is solid-blue (every pixel is blue). 

The SW(15 downto 12)* 64 specifies the new PingX
The SW(11 downto 8)* 64 specifies the new PingY. 

SW(7 downto 6) is the interval between jumps (doesn’t have to be precise).
 00 is 3ms 01 is 5ms 10 is 10 ms 11 is 20 ms.
o SW(5 downto 3) is unsigned DeltaX value, i.e., the increase in X coordinate at every jump
o SW(2 downto 0) is unsigned DeltaY value, i.e., the increase in Y coordinate at every jump
o Of course, choosing DeltaX=0 and DeltaY=0 freezes the ball!
 Here is an example of how the ball moves and disappears:
o Reset brings the ball back to (0,0)
o Assume SW(5 downto 3)=”110” and SW(2 downto 0)=”011”. So, DeltaX=6, DeltaY=3.
o Assume SW(7 downto 6)=”00”. So, the ball is moving 3 ms per jump
o The ball will move like this: (0,0)  (6,3)… So, 3ms later, the ball is at (6,3)
o Notice that the x is growing a lot faster. We know that the X coordinate 1280 is out of
range, however, 1279 is not. Since the ball spans (0…31) in the X dimension, we can
never let the top left corner go beyond 1279-31=1248.
o Since DeltaX is 6, we will reach 1248 after 208 jumps.
o Let us go back to the ball movement. It was
o (0,0)(6,3)(12,6)(18,9) … (1236,618)(1242,621)(1248,624)(1254,627)
o (1254,627) epresents an out-of-range X coordinate, because it will force a portion of the
ball to be drawn outside the VGA screen
o So, the (1248,624) is the last ball you draw at the 208
th jump.
o Once you realize that (1254,627) is out or range, you will draw NOTHING at that 209th
jump; i.e., the ball disappears at the 209th jump, which is about 600ms later.
o At the 210th jump, you are back to (0,0) and everything repeats.

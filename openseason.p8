pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
  -- Open Season --
-- Martin og Andreas --
function _init()
	scene=1
	
end

function _update()
 //skifter scene
	updatescene={
		[1]=function() return update_scroller() end,
		[2]=function() return update_menu() end,
		[3]=function() return update_game() end,
		[4]=function() return update_win() end,
		[5]=function() return update_lose() end} //definere scene
	updatescene[scene]() //bestemmer scene
end

function _draw()
	drawscene={
		[1]=function() return draw_scroller() end,
		[2]=function() return draw_menu() end,
		[3]=function() return draw_game() end,
		[4]=function() return draw_win() end,
		[5]=function() return draw_lose() end }//definere scene
	drawscene[scene]() //bestemmer scene
end

-->8
--scroller og menu--
       --scroller--
function update_scroller()
	if time()>3 then scene=2 end

end


function draw_scroller()
cls()
	print("scroller") //test screen
end

        --menu--
function update_menu()
	if btn(❎) then scene=3 end
	
end


function draw_menu()
cls()
	print("open season",44,12) 
	print("➡️ for settings",36,100)
	print("⬅️ for maps and weapons",20,108)
	
end
-->8
--game--
function init_game()

end


function update_game()

end


function draw_game()
cls()
print("game") //test screen
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000000010000000001000000000010000000001000000000100000000001000000000100000000010000000000100000000010000000001000000000010
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777777777777777777777777777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
777777777777777777777777777777777777000000e1000000000100000000001000000000100000000010000000000100000000010000000001000000000010
000000000000000000000000000000000000e000000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000e000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000ee00000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000e00000e000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000e00000e000000000000000000000000000000000000000000000000000000000000000000000000000000ee
000000000000000000000000000000000000000000e00000e000000000000000000000000000000000000000000000000000000000000000000000000000ee00
0000000000000000000000000000000000000000000e00000ee00000000000000000000000000000000000000000000000000000000000000000000000ee0000
77777777777777777777777777777777777700000000e000000e00000000000000000000000000000000000000000000000000000000000000000000ee000000
000000000000000000000000000000000000ee0000000ee00000e00000000000000000000000000000000000000000000000000000000000000000ee00000000
00100000000010000000001000000000010000e00001000e00000e00000000001000000000100000000010000000000100000000010000000001ee0000000010
000000000000000000000000000000000000000e00000000e00000e00000000000000000000000000000000000000000000000000000000000ee000000000eee
0000000000000000000000000000000000000000ee0000000e00000e00000000000000000000000000000000000000000000000000000000ee000000000ee000
000000000000000000000000000000000000000000e0000000e00000e00000000000000000000000000000000000000000000000000000ee000000000ee00000
0000000000000000000000000000000000000000000e0000000e00000e00000000000000000000000000000000000000000000000000ee00000000eee0000000
77777777777777777777777777777777777700000000ee000000e00000e00000000000000000000000000000000000000000000000ee00000000ee0000000000
000000000000000000000000000000000000ee00000000e000000ee0000e00000000000000000000000000000000000000000000ee00000000ee000000000000
00000000000000000000000000000000000000ee0000000ee000000e0000e00000000000000000000000000000000000000000ee00000000ee000000000000ee
0000000000000000000000000000000000000000e00000000e000000e0000e00000000000000000000000000000000000000ee0000000eee00000000000eee00
00000000000000000000000000000000000000000ee0000000e000000e0000e00000000000000000000000000000000000ee0000000ee00000000000eee00000
0010000000001000000000100000000001000000000ee000000ee10000e0000e10000000001000000000100000000001ee0000000ee00000000100ee00000010
000000000000000000000000000000000000000000000ee000000e00000e0000e22222222222222222222222222222ee000000eee0000000000eee0000000000
777777777777777777777777777777777777e0000000000e000000ee0000ee00000000000000000000000000000000000000ee0000000000eee00000000000ee
0000000000000000000000000000000000000ee000000000ee000000e00000e00000000000000000000000000000000000ee000000000eee00000000000eee00
000000000000000000000000000000000000000ee000000000ee00000e00000e00000000000000000000000000000000ee000000000ee00000000000eee00000
00000000000000000000000000000000000000000ee000000000e00000ee0000e22222222222222222222222222222ee00000000eee000000000eeee00000000
0000000000000000000000000000000000000000000ee00000000ee00000e0000000000000000000000000000000000000000eee000000000eee000000000000
000000000000000000000000000000000000000000000ee00000000ee0000e0000000000000000000000000000000000000ee000000000eee000000000000000
00000000000000000000000000000000000000000000000ee00000000ee000ee00000000000000000000000000000000eee0000000eeee000000000000000eee
777777777777777777777777777777777777e000000000000ee00000000e0000e22222222222222222222222222222ee0000000eee000000000000000eeee000
0000000000000000000000000000000000000ee000000000000ee0000000ee00000000000000000000000000000000000000eee00000000000000eeee0000000
001000000000100000000010000000000100000eee01000000000ee0000000ee10000000001000000000100000000001eeee0000010000000eeee00000000010
000000000000000000000000000000000000000000eee0000000000ee0000000e22222222222222222222222222222ee0000000000000eeee000000000000000
000000000000000000000000000000000000000000000ee0000000000ee0000000000000000000000000000000000000000000000eeee0000000000000000000
00000000000000000000000000000000000000000000000eee000000000ee0000000000000000000000000000000000000000eeee000000000000000000eeeee
00000000000000000000000000000000000000000000000000eee00000000ee0000000000000000000000000000000000eeee00000000000000000eeeee00000
00000000000000000000000000000000000000000000000000000ee00000000ee22222222222222222222222222222eee0000000000000000eeeee0000000000
777777777777777777777777777777777777ee00000000000000000eee0000000000000000000000000000000000000000000000000eeeeee000000000000000
00000000000000000000000000000000000000eeee0000000000000000eee00000000000000000000000000000000000000000eeeee000000000000000000000
000000000000000000000000000000000000000000eeee000000000000000ee0000000000000000000000000000000000eeeee00000000000000000000000000
0000000000000000000000000000000000000000000000eeee0000000000000ee22222222222222222222222222222eee00000000000000000000000000eeeee
00100000000010000000001000000000010000000001000000eeee0000000000100000000010000000001000000000010000000001000000000eeeeeeee00010
000000000000000000000000000000000000000000000000000000eeee0000000000000000000000000000000000000000000000000eeeeeeee0000000000000
0000000000000000000000000000000000000000000000000000000000eeee0000000000000000000000000000000000000eeeeeeee000000000000000000000
777777777777777777777777777777777777eee00000000000000000000000eee22222222222222222222222222222eeeee00000000000000000000000000000
000000000000000000000000000000000000000eeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000eeeeeeee00000000000000000000000000000000000000000000000000000000000000eeeeeeeeeeee
000000000000000000000000000000000000000000000000000000eeeeeee00000000000000000000000000000000000000000eeeeeeeeeeeeee000000000000
0000000000000000000000000000000000000000000000000000000000000eeee22222222222222222222222222222eeeeeeee00000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
777777777777777777777777777777777777eeeeeeeeeeeeeeeeeeeeeeeeeeeee22222222222222222222222222222eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000000010000000001000000000010000000001000000000100000000001000000000100000000010000000000100000000010000000001000000000010
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000000010000000001000000000010000000001000000000100000000001000000000100000000010000000000100000000010000000001000000000010
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000077700000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000077700077000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000007700000000777000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000007770000000000000770000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000777777777777777777777700000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000070000000007000000000700000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000070000000770770000007000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000007000077000007700007000000000000000000000000000000000000000000000000000000
00100000000010000000001000000000010000000001000000000107007700001000077070100000000010000000000100000000010000000001000000000010
00000000000000000000000000000000000000000000000000000000777777777777777770000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000000010000000001000000000010000000001000000000100000000001000000000100000000010000000000100000000010000000001000000000010
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000000010000000001000000000010000000001000000000100000000001000000000100000000010000000000100000000010000000001000000000010
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000000010000000001000000000010000000001000000000100000000001000000000100000000010000000000100000000010000000001000000000010
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000


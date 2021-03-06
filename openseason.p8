pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- Open Season --
-- by Martin og Andreas --
cartdata("persistent")
menuitem(2,"menu",function() scene=2 init_settings() end)

function _init()
	poke(0x5f2d,1)
	scene=1 //starter ved scorller
	maps={nr=1,sp=201,x=0,y=0,sx=0,sy=0,col=11}
	gun={nr=2,sp=156,s=21,x=54,y=118,w=1,h=1,b=17,c=32}
end

function _update()
 //skifter scene
	updatescene={
		[1]=function() return update_scroller() end,
		[2]=function() return update_menu() end,
		[3]=function() return update_game() end,
		[4]=function() return update_win() end,
		[5]=function() return update_lose() end,
		[6]=function() return update_settings() end} //definere scene
	updatescene[scene]() //bestemmer scene
end

function _draw()
	drawscene={
		[1]=function() return draw_scroller() end,
		[2]=function() return draw_menu() end,
		[3]=function() return draw_game() end,
		[4]=function() return draw_win() end,
		[5]=function() return draw_lose() end,
		[6]=function() return draw_settings() end }//definere scene
	drawscene[scene]() //bestemmer scene
end

-->8
--scroller, menu og settings--
       --scroller--
function update_scroller()
	if time()>2 then 
		scene=2 
		init_settings() 
		clearpal()
	end
end


function draw_scroller()
	cls()
	local intro_y=60
	for v=12,7,-1 do
		intro_y+=1
		print("by weebo productions",25,intro_y,v)
	end
	print("highscore set:",40,112,8)
	print(dget(3).."/"
	..dget(2).."-"..dget(1).." "
	..dget(4)..":"..dget(5),37,120,7)
end

        --menu--
function update_menu()
	if btn(❎) then scene=3 init_game() sfx(05) end
	if btn(⬅️) then scene=6 sfx(6) end
end


function draw_menu()
	pal(10,12+128,1) //aendre baggrund
	cls()
	--map
	map(48)
	color(7)
	spr(192,36,5,7,2) //open (logo)
	spr(224,20,23,11,2) //season (logo)
	print("highscore:"..dget(0),40,44)
	print("🅾️ for instructions",24,92)
	print("⬅️ for settings",31,100,7)
	print("press ❎ to start",28,108,8) 
	if btn(🅾️) then 
		
		cls(10) print("instructions",40,28,7)
		print("instructions",40,27,8 )
		print("move mouse to aim",30,42,7)
		print("left click to shoot",28,50,7)
		print("right click to reload",24,58,7)
		print("press ❎ to start",28,108,8) 
	end
end
       --settings--
function init_settings()
	settings=1
	--standard map
	arrow1=35
	--standard gun
	arrow2=75 
end
        
function update_settings()
	if btn(➡️) then scene=2 sfx(06) end
	if btnp(⬇️) then settings+=1 sfx(04) end
	if btnp(⬆️) then settings-=1 sfx(04) end
	if settings>6 then settings=1 end
	if settings<1 then settings=6 end
	
	--bane config
	config_map={
		[1]=function() arrow1=35 maps.x=0 
			maps.nr=1 maps.col=11 maps.sp=201 
			end,
		[2]=function() arrow1=43 maps.x=16 
			maps.nr=2 maps.col=3 maps.sp=168 
			end,
		[3]=function() arrow1=51 maps.x=32 
			maps.nr=3 maps.col=7 maps.sp=235 
			end} 
	if btnp(❎) and settings>0 and settings<4
		then config_map[settings]() sfx(07) end
	
	--vaaben config
	config_gun={
		[4]=function() arrow2=67 gun.sp=76 
			gun.s=23 gun.nr=1 gun.b=16 gun.c=32 end,
		[5]=function() arrow2=75 gun.sp=156 
			gun.s=21 gun.nr=2 gun.b=17 gun.c=32 end,
		[6]=function() arrow2=83 gun.sp=72 
			gun.s=22 gun.nr=3 gun.b=18 gun.c=48 end}
	if btnp(❎) and settings>3 and settings<7 
		then config_gun[settings]() sfx(07) end
end

function draw_settings()
	cls(10)
	pal(10,12+128,1)
	pal(13,2+128,1)
	print("settings",46,17,7)
	print("settings",46,16,8)
	color(7)
	print("map",56,28)
	line(16,34,116,34)
	spr(02,14,arrow1)
	spr(02,14,arrow2)
	print("safari",20,36,7)
	print("jungle",20,44,7)
	print("polar",20,52,7)
	print("weapon",48,60)
	line(16,66,116,66)
	print("double barrel shotgun",20,68,7)
	print("single barrel shotgun",20,76,7)
	print("rifle",20,84,7)
	
	draw_map={
		[1]=function() print("safari",20,37,8) end,
		[2]=function() print("jungle",20,45,8) end,
		[3]=function() print("polar",20,53,8) end}
	if settings>0 and settings<4 
		then draw_map[settings]() end
	draw_gun={
		[4]=function() print("double barrel shotgun",20,69,8) end,
		[5]=function() print("single barrel shotgun",20,77,8) end,
		[6]=function() print("rifle",20,85,8) end} 
	if settings>3 and settings<7 then
	 draw_gun[settings]() end 
	print("➡️ for menu",40,114,7)
	print("press ❎ to choose",28,120,8)
	
	color(7)
end

-->8
--game--
function init_game()
	clearpal() //nulstiller farve palletet
	time_game=time() //naar spillet starter
	birds={} //alle fugle
	land_animals={} //alle land dyr
	sight={rl_time=time(),reloaded=true
	,ready=true,wait=time(),aim=false} //alt med vaaben at goere
	player={kills=0,score=0,♥=0}
	init_specific={
		[1]=function() sight.shots=2 
			sight.time=2 end,
		[2]=function() sight.shots=1 
			sight.time=1 end,
		[3]=function() sight.shots=1 
			sight.time=2 end} //specifikt for vaaben nr
	init_specific[gun.nr]()
	sight.bullets=sight.shots //fyld magasin
	--effekter 
	shake={kraft=0,t=time()}	
	curve={sp=gun.c,k=0,x=gun.x+12,y=118}
	
	highscore_beat=false //highscore
end

--------------dyr-------------
function add_animal(types,tbl,sprite,lives)
	//types=type of animal
	//tbl=table sp=sprite_nr
	
	if types=="land" then
		add(tbl,{sp=sprite,x=rnd(120)
		,y=102-rnd(38),dx=2-rnd(4)
		,dy=2-rnd(4),w=2,h=2
		,lvs=lives,shot=false
		,flp=false,sitting=false
		,lvs_max=3,an_t=time()}) 
	elseif types=="bird" then
		add(tbl,{sp=sprite,x=rnd(120)
			,y=rnd(65),dx=2-rnd(4)
			,dy=0.5-rnd(1),w=1,h=1,lvs=lives
			,shot=false,flp=false
			,lvs_max=3,an_t=time()})
	end
	
end

function move_animal() 
	for la in all(land_animals) do
		la.x+=la.dx
		if la.x>121 or la.x<0 then
			la.dx*=-1
		end
	end
	
	for b in all(birds) do
		b.x+=b.dx
		b.y+=b.dy
		if b.x<0 or b.x>120 then
			b.dx*=-1
		end
		if b.y<0 or b.y>66 then
			b.dy*=-1
		end
		if sgn(b.dx)==-1 then
			b.flp=true
		else b.flp=false
		end
	end
end

-----collision sigte og dyr----
function collision()
	sight.aim=false
	for la in all(land_animals) do
		if collide(sight.x+4,sight.y+4,2,la.x+8,la.y+8,2) then
			sight.aim=true
			if sight.shoot==true then
				la.lvs-=1
				sight.shoot=false
				player.♥+=1
			end
		end
		if la.lvs<1 then 
			del(land_animals,la) 
			player.kills+=1
			player.score+=la.lvs_max+2
		end
	end
	
	
	for b in all(birds) do
		if collide(sight.x+4,sight.y+4,2,b.x+4,b.y+4,2) then
			sight.aim=true
			if sight.shoot==true then
				b.lvs-=1
				sight.shoot=false
				player.♥+=1
			end
		end
		if b.lvs<1 then 
			del(birds,b) 
			player.kills+=1
			player.score+=b.lvs_max+3
		end
	end
end

--------sight and reload-------
function sights()
	sight.x=stat(32) //mus x
	sight.y=stat(33) //mus y
	--antal skud
	if sight.bullets<1 then
		sight.redy=false
		sight.reloaded=false
		sight.bullets=0
	end
	--reload knap
	if stat(34)==2 then
		sight.bullets=sight.shots
		sight.reloaded=true
		sight.rl_time=time()
	end
	--reload tid
	if time()-sight.rl_time<sight.time then
		sight.ready=false
	elseif time()-sight.rl_time>sight.time
		and sight.reloaded==true then
		sight.ready=true
	end
	--skyde
	if stat(34)==1 and sight.ready 
	and sight.reloaded and time()-sight.wait>0.5 then
		sight.shoot=true
		sight.bullets-=1
		sight.ready=false
		sight.wait=time()
		if gun.nr==1 then
			sfx(00) shake.kraft=2
			shake.t=time()
		elseif gun.nr==2 then
			sfx(01) shake.kraft=2
			shake.t=time()
		elseif gun.nr==3 then
			sfx(02) shake.kraft=1
			shake.t=time()
		end
		
		if sight.bullets<0 then 
		sight.bullets=0 end
	else sight.shoot=false end
	
end

-----------update--------------
function update_game()
	move_animal() 
	sights()
	collision()
	
	//tilfoj dyr
	if #land_animals<4 then
		add_animal("land"
		,land_animals,maps.sp,3,false)
	end
	
	if maps.nr==2 then
		if #birds<4 then
			add_animal("bird"
			,birds,141,3,false)
		end
	end
	
	--highscore opdatering
	if dget(0)<player.score then
		dset(0,player.score)
		highscore_beat=true
		--vedvarende opbevaring
		dset(1,stat(90)) dset(2,stat(91))
		dset(3,stat(92)) dset(4,stat(93))
		dset(5,stat(94))
	end
	
end


-------------draw--------------
function draw_game()
	cls()
	map(maps.x,maps.y,maps.sx,maps.sy,16,16)
	draw_specific={
		[1]=function() pal(12,12+128,1) 
			pal(11,4+128,1) pal(13,15,1)
			pal(10,11+128,1)
		end,
		[2]=function() pal(12,12+128,1)
		pal(2,11+128,1) pal(10,11+128,1)
		end,
		[3]=function() pal(10,12+128,1)
		pal(2,1+128,1) spr(64,64,8,8,8,true) end} //per map
	draw_specific[maps.nr]()
	
	--camera
	camera(0,shaking(0))
	
	--tegn dyr og liv
	for la in all(land_animals) do
		spr(la.sp,la.x,la.y,la.w,la.h,la.flp)
		if maps.nr==1 then
			la.sp=anim(la.sp,2,maps.sp+2,maps.sp,la.an_t,0.5)[1]
			la.an_t=anim(la.sp,2,maps.sp+2,maps.sp,la.an_t,0.5)[2]
		elseif maps.nr==2 then
			la.sp=anim(la.sp,2,170,168,la.an_t,0.5)[1]
			la.an_t=anim(la.sp,2,170,168,la.an_t,0.5)[2]
		elseif maps.nr==3 then
			la.sp=anim(la.sp,2,maps.sp+2,maps.sp,la.an_t,0.5)[1]
			la.an_t=anim(la.sp,2,maps.sp+2,maps.sp,la.an_t,0.5)[2]
		end
		life_x=0
		for lvs=1,la.lvs,1 do
			life_x+=6
			print("♥",la.x+life_x-10,la.y-4,8)
		end
	end

	for b in all(birds) do
		b.sp=anim(b.sp,1,143,141,b.an_t,0.1)[1]
		b.an_t=anim(b.sp,1,143,141,b.an_t,0.1)[2]
		spr(b.sp,b.x,b.y,b.w,b.h,b.flp)
		life_x=0
		for lvs=1,b.lvs,1 do
			life_x+=6
			print("♥",b.x+life_x-10,b.y-4,8)
		end
	end
	
	--sigte 
	if sight.aim==false then //normal
		if maps.nr==3 then
		spr(gun.s+16,sight.x,sight.y)
		else spr(gun.s,sight.x,sight.y) end
	elseif sight.shoot==true or sight.aim==true then //skyd
		spr(gun.s-16,sight.x,sight.y)
	end
	
	--bullets
	rectfill(8,112,18,126,6)
	if gun.nr==1 then 
		if sight.bullets==2 then
			spr(gun.b,10,114)
		elseif sight.bullets==1 then
			spr(17,10,114) 
		end
	elseif gun.nr==3 or gun.nr==2  then
		if sight.bullets==1 then
			spr(gun.b,10,114)
		end
	end
	
	--point, kills, highscore m.m
	print(player.score.."◆",8,8,2)
	print(player.♥.."♥",8,16,8)
	print(player.kills.."🐱",8,24,8)
	if highscore_beat==true then
		print("highscore beat",56,8,8)
	end
	--vaaben og  farver
	pal(14,5+128,1)
	pal(15,1+128,1)
	if time()-time_game>0.1 then
		gun.x=sight.x-11
	end
	spr(gun.sp,gun.x,104,4,3)
	
	
	--reload
	if sight.reloaded==false or 
	sight.ready==true then
	 curve.x=gun.x+12
	 curve.k=0.1
	end
	if sight.ready==false 
		and sight.reloaded==false then
		print("reload",gun.x+3,117,8)
	elseif sight.ready==false
		and sight.reloaded==true and sight.shoot==false then
		print("reloading",gun.x,117,9)
		curve.k+=0.06
		sight.shoot=false
		if gun.nr==1 then
		 spr(curve.sp,(curving(curve.x)[1]-10),(curving(curve.x)[2])-8)
		 spr(curve.sp,(curving(curve.x)[1]),(curving(curve.x)[2]))
		else 
			spr(curve.sp,curving(curve.x)[1],curving(curve.x)[2])
		end
	end
	
	
end

-->8
--help functions
---------clear colors----------
function clearpal()
	for col=0,16,1 do
		pal(col,col,1)
		col+=1
	end
end

----------collision------------
-----------cirkler-------------
function collide(sx,sy,sr,ax,ay,ar)
	// s=gun sight (sigte)
	// a=animal (dyr)
	// ba=balances (mellemregninger)
	ba={radisum=((sr+ar)^2),
	dist=(((sx-ax)^2)+((sy-ay)^2))}
	
	if ba.dist==ba.radisum then 
		//roer hinanden
		return false
	elseif ba.radisum<ba.dist then
		//roer ikke hinanden
		return false
	elseif ba.radisum>ba.dist then
		//overlapper
		return true
	end
end

----------shake effect---------
function shaking(n)
	//n=normal shake
	
	if time()-shake.t>0.5 then
		cam_y=n
	else
		cam_y=rnd(2)*shake.kraft 
	end
	
	return cam_y
end

-->8

-->8
--animation af figure
function anim(sp,w,mx,mn,an_t,an_w)
	//sp=sprite w=tykkelse
	//mx=max sp  mn=min sp
	//an_t=tids var an_w=wait var
	local sprite=sp
	if time()-an_t>an_w then
		sprite+=w
		an_t=time()
		if sprite>mx then
			sprite=mn
		end
	end
	
	return {[1]=sprite,[2]=an_t}
end

--animation af skud som reloades
function curving(x)
	//x=x start  y=y start
	if curve.k>0.7 then
		curve.sp=49
	else curve.sp=gun.c end
	curve.x+=1
	curve.y=118+(sin(curve.k)*15)
		
	return {[1]=curve.x,[2]=curve.y}
	
end 

__gfx__
00000000cccccccc800000000000000000000000770880770078870077088077ddddddddddddddddcccccccc7777777733333333333333333333333333333333
00000000cccccccc880000000000000000000000700880070708807070000007d2ddddddddddddddccaaaccc7777777733333333333333333333333222223333
00700700cccccccc888000000000000000000000000000007008800700000000db3aab2ddddd44ddccaaaccc7777717733333333333333333333332aaaaabb33
00077000cccccccc888800000000000000000000880000888880088880000008dddbaddddd4dd4ddcc333ccc77777c1733322222333333333333322aaaaaabbb
00077000cccccccc888d00000000000000000000880000888880088880000008d2dabd2dd4d4d444cc333ccc777777c13322aaaa33333333333332aaaaaaaabb
00700700cccccccc88d000000000000000000000000000007008800700000000dadbadbdd4dd4dd4cc333ccc7777777c332aaaaa33333333333322aaaaaaaabb
00000000cccccccc8d0000000000000000000000700880070708807070000007da3a3aadddd4d44dccc4cccc77777777332aaaaaaab3333333332aaaaaaaaabb
00000000ccccccccd00000000000000000000000770880770078870077088077dddabdddddd4d4ddccc4cccc77777777332aaaaaaab3333333332aaaaaaaaabb
88808880888000000f9000000000000000000000770770770077770077077077ddddddddd44d44dddddddddd77777777332aaaaaabb33333333332aaaaaaaabb
8880888088800000f99900000000000000000000700770070707707070000007ddddddddddd44d4dd2d3dddd777c1777222aaaaab3333333333333332aaaabbb
8880888088800000f99900000000000000000000000000007007700700000000dddaa3dd4d44d4dddbdaad2d7777c17722aaaaaabbbbb333333333322aaaab33
8880888088800000f99900000000000000000000770000777770077770000007dd2baddd444d4dd4dadaadbd77777c172aaaaaaaaaaabb333333332aaaaaab33
8880888088800000f99900000000000000000000770000777770077770000007dddabdddddd4d444daaabaad777777c72aaaaaaaaaaaabb3333322aaaaaaabbb
8880888088800000f99900000000000000000000000000007007700700000000dd2ba3dd4d4d4ddddddbaddd77777777332aaaaaaaaaabb33222aaaaaaaaaabb
8880888088800000000000000000000000000000700770070707707070000007dddaadddd4d4d44dddaaa3dd77777777332aaaaaaaaaabb332aaaaaaaaaaaabb
9990999099900000f99900000000000000000000770770770077770077077077dddabddddd44d4dddddaaddd77777777332aaaaaaaaaaab332aaaaaaaaaaaabb
005885003333333377777777ddddddddaaaaaaaa110770110017710011077011777777777777777777777777cccccccc3b444bbbbbbbbbb333333333333b443b
058888503333333377777777ddddddddaaaaaaaa1007700101077010100000017767777777777aaaaaa77777ccaaaccc3b444333b33b33333333b3333b3b44b3
058888803333333377777777ddddddddaaaaaaaa00000000100770010000000077776677777aaaaaaaaaa777ccaaacccb4444333b33bb333333bb3333b3b44b3
058888803333333377777777ddddddddaaaaaaaa7700007777700777700000077676666777aaaaaaaaaaaa77cc333ccc3bb44333bb33bb33333b33333b3b4444
005888803333333377777777ddddddddaaaaaaaa7700007777700777700000077776667777aaaaaaaaaaaa77cc333ccc33b443333b333b3333b333333b3b44b3
000999903333333377777777ddddddddaaaaaaaa000000001007700100000000767666677aaaaaaaaaaaaaa7cc333ccc33b443333b333b3333b333333b3b443b
000966903333333377777777ddddddddaaaaaaaa100770010107701010000001777766777aaaaaaaaaaaaaa73ac4cc3333b4433333b33b33333b3333b44444b3
000099903333333377777777ddddddddaaaaaaaa110770110017710011077011776777777aaaaaaaaaaaaaa7a3c4ccaa33b443333b333b3333b33333b33bb43b
0000000000000000000000000000000000000000000000000000000000000000000000007aaaaaaaaaaaaaa7ccccaccc33b4433333b33b333b33333bb33b4433
0009900000000000000000000000000000000000000000000000000000000000000000007aaaaaaaaaaaaaa7cccc3ccc33b44b3333b3bb3333b3333b333b4433
0099990000000000000000000000000000000000000000000000000000000000000000007aaaaaaaaaaaaaa7cccaaacc33b4443333bb333333bb333bb33b4433
00999990000000000000000000000000000000000000000000000000000000000000000077aaaaaaaaaaaa77ccc333ccb4444333333bb333333b3333b333b433
00099999000000000000000000000000000000000000000000000000000000000000000077aaaaaaaaaaaa77ccaaaaac3bb4433333b3b333333b3333b33b4433
000099690000000000000000000000000000000000000000000000000000000000000000777aaaaaaaaaa777cc33333c33b443333b33b333333b3333b33b4443
00000999000000000000000000000000000000000000000000000000000000000000000077777aaaaaa777773ccc4cc333b44333bb33b333333b3333b33b4433
0000000000000000000000000000000000000000000000000000000000000000000000007777777777777777a3cc4caa33b44333b333b333333b3333b33b4433
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000000000000000000000000000000110000001100000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000066600000000000000000000000066556600665566000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000000006666600000000000000000000006ee55eeffee55ee600000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000000000665556600000000000000000000ee555555ff555555ee0000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000000006565556560000000000000000000e5555555ff5555555e0000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000000656666656000000000000000000e55555555ff55555555e000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000000666555666000000000000000000e55555555ff55555555e000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000e656666656e00000000000000000e15555555ff55555551e000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000e666555666e00000000000000000611155555ff555551116000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000e656555656e0000000000000000ee666611661166116666ee00000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000000066566666166000000000000000555ffff1155ff5511ffff5550000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000000ee660050066ee000000000000001ffffffffffffffffffffff10000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000005516000500061550000000000000e776655ffffffffff556677e0000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000001ff600050006ff1000000000000055ffffffffffffffffffff550000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000e7665558555667e000000000000055ffffffffffffffffffff550000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000055f600050006f550000000000000666ffffffffffffffffff6660000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000055ff6005006ff5500000000000006777777776655667777777760000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000666ff66666ff666000000000000ff5511ffffffffffffff1155ff000
22cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000006777776167777760000000000091ffffffffffffffffffffffff1900
aa222cccccccccccccccccccccccccccc222cccccccccccccccccccccccccccc0000000ff5511fffff1155ff000000000955666111ffff1111ffff1116665590
ccaaa2ccccccccccccccccccccccccc22aaa2ccccccccccccccccccccccccccc00000091fffffffffffffff190000000051ffffffffffff55ffffffffffff150
7cccca22cccccccccccccccccccccc2aaacca2cccccccccccccccccccccccccc000009556611ff111ff1166559000000551ffffffffffff55ffffffffffff155
7777ccaa2ccccccccccccccccccc22aaccaaaa2ccccccccccccccccccccccccc0000551ffffffff5ffffffff1550000051fffffffffffff55fffffffffffff15
77777ccca2ccccccccccccccccc2aaac77a6ca2ccccccccccccccccccccccccc000051fffffffff5fffffffff150000051fffffffffffff55fffffffffffff15
7777777cca2ccccccccccccccc2accc777a6caa22ccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
77777777cca2cccccccccccccc2ac77777a67caaa2cccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
777777777ca2ccccccccccccc2aac7777aa677ccaa222ccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
777777777cca2ccccccccccc22ac77777a667777caaaa2cccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
7777777777ccacccccccccc2aacc7777aa6777777cccaa2ccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
77777777777ca22ccccccc22ac777777a66777777777caa2cccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
677777777777caa2ccccc2aaac77777aa677777777777caa2ccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
a67777777777ccca2ccc22acc77777aa66777777777777caa2cccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
aa677777777777cca2c2aac7777777a6677777777777777ca2ccccccccccccccaaaaaa7aaaaaaaaa00007777700000003333aaaa000000000000000000000000
caa777777777777caa2aac7777777aa6677777777777777caa2cccccccccccccaaaa77777aaaaaaa0007777777000000a3737aaa000300000003000000030000
7ca6777777777777c2aac7777777aaaa6777777777777777caa2222cccccccccaaa7777777aaaaaa0077777777700000a3399aaa330333000000330000003300
7caa7777777777772aac7777777aa67a66777777777777777caaaaa2ccccccccaa777777777aaaaa0774447444770000a33ccaaa333c73000333730003337300
77ca677777777772aac77777777a667aa66777777777777777ccccaa2ccccccca77444744477aaaa0744444444470000a33ccaaa03c33990033cc9900333c990
77caa6777777772aac77777777aa6777aa67777777777777777777ca2ccccccca74444444447aaaa474c7444c7474000a33ccaaa9c33300093c33000933c3000
777caa67777772aac77777777aa677777a66777777777777777777ca2ccccccc474c7444c7474aaa474cc444cc474000a9aa9aaa000000000033000000c33000
7777ca6777772aac7aa66777aa6777777aa66777777777777aaaa77aa2cccccc474cc444cc474aaa074cc404cc470000aaaaaaaa000000000000000000030000
7777caa677772ac7aaca677aa677777777aa66777777777aaacca77ca2cccccca74cc404cc47aaaa007444e44470000000000000000000000000000000000000
77777ca677772acaaccaa6aa67777777777aa667777777aacc77aa7ca2ccccccaa7444e4447aaaaa000774447700000000000000000000616000000000000000
77777caa67772aaac77caaa6777777777777aa6677aaaaac7777caaaa2ccccccaaa7744477aa4aaa000007770000400000000000000006e1e600000000000000
777777ca6777aacc7777ca667777777aaa666a667aaccccc77777ccca222ccccaaaaa777aaaa7aaa0000777770007000000000000000ee515ee0000000000000
777777caa67aac777777caa6777777aaaaaa6aa7aac777777777777caaaa2cccaaaa77777aaa7aaa0000777770077000000000000000e55555e0000000000000
7777777ca6aacc777777cca677777aaca6caa6aaac77777777777777ccaa2cccaaaa77777aa77aaa000777777777000000000000000e5555555e000000000000
7777777caaacc77777777caa67777ac7aa6caa6ac7777777777777aa77aca2ccaaa777777777aaaa000774747700000000000000000e5555555e000000000000
7777777aaacc777777777cca6777aac77a67caaac777777777777aaaaaaca2ccaaa7747477aaaaaa00040404040000000000000000e555555555e00000000000
77777aaacc777777777777caa67aac777aa67ccaaa66677777777acccccca2cc000077777000000000007777700000000000000000e555555555e00000000000
7777acccc77777777777777caaaac77777a6777ccaaaa6777777aac7777cca2c000777777700000000077777770000000000000000e155555551e00000000000
777ac7777777777777777777caac777777aa67777cccaa6777aaac677777ca220077777777700000007777777770000000000000006115555511600000000000
77aac7777777777777777777caac7777777aa6777777caa77aacca667777ccaa07744474447700000774447444770000000000000ee661616166ee0000000000
77acc7777777777777777777aac777777777a67777777ca6aac77aa677777cca0744444444470000074444444447000000000000551ff15f51ff155000000000
77ac7777777777777777777aac7777777777aa67777777caac777aa6677777cc474c7444c7474000474c7444c7474000000000001fffffffffffff1000000000
77ac777777777777777777aac777777777777a67777777aac77777aa66777777474cc444cc474000474cc444cc47400000000000e765fffffff567e000000000
7ac777777777777777777aac7777777777777aa6777777ac7777777aa6667777074cc404cc470000074cc404cc4700000000000055fffffffffff55000000000
ac7777777777777777777ac77777777777777aa67777aaac77777777aaa66777007444e444700000007444e4447000000000000055fffffffffff55000000000
ac777777777777777777aac777777777777777a6777aacc77777777777aa66770007744477000000000774447700000000000000666fffffffff666000000000
ac77777777777777777aac7777777777777777aa67aac77777777777777aaa670000077700000000000007770040000000000000677777616777776000000000
ac77777777777777777ac777777777777777777a6aac7777777777777777aa67000077777000000000007777707700000000000ff5511fffff1155ff00000000
ac7777777777777777aac777777777777777777aaac777777777777777777aa60000777770077000000077777007000000000091fffffffffffffff190000000
ac777777777777777aac77777777777777777777aa77777777777777777777a600077477777700000007777477770000000009556611ff111ff1166559000000
ac77777777777777aac777777777777777777777ac77777777777777777777aa000774747700000000077474770000000000551ffffffff5ffffffff15500000
ac7777777777777acc7777777777777777777777ac777777777777777777777a00040004000000000000040004000000000051fffffffff5fffffffff1500000
00bbbbbbb300000bbbbbbbbb3000bbbbbbb3000bbb33000bbb330000aaa444444aaaaaaa00044444400004000004444440000000aaaaaaaaaaaaaaaa00000000
0bbbbbbbbb30000bbbbbbbbbb300bbbbbbb3300bbb33000bbb330000a4444444444aa4aa04444444444090000444444444400000aaaaaaaaaaaaaaaa00000000
bbbbbbbbbbb3000bbbbbbbbbb330bbbbbbb3300bb8b3300bbb3300004499444499449aaa44994444994409004499444499440400aaaaaaaaaaaaaaaa00000000
bbb33333b7b3300bbb333338b330bb333333300b808b330bbb330000449799997944a9aa44979999794409004497999979449000aaaa66666aaaaaaa00000000
bbb333337b73300bbb30000bb330bb333333300b808bb33bbb330000444999999444a9aa44499999944409004449999994440900aaa6666666aaaaaa00000000
bbb33000b7b3300bbb8bb88bb330bb330000000b888bbb3bbb3300004499c99c994499aa4499c99c994499004499c99c99449900aa666666666aaaaa00000000
bbb33000bbb3300bbbbb80883300bbbbbb30000bb83bbbbbbb3300004499c99c994499aa4499c99c994499004499c99c994499005a67c6667c6aaaaa00000000
bbb33000bbb3300bbbb800080000bbbbbb33000bbb33bbbbbb33000044997ee7994499aa44997ee79944990044997ee7994499005a6cc666cc6aaaaa00000000
bbb33000bbb3300bbb3300000000bb333333000bbb330bbbbb33000044477777744499aa444777777444990044477777744499005a61c666c16aaaaa00000000
bbb33000bbb3300bbb3300080000bb333333000bbb3300bbbb33000044467777644499aa444677776444990044467777644499005a661666166aaaaa00000000
bbb33000bbb3300bbb3300008000bb330000000bbb33000bbb33000044446666444499aab4446666444b9900b4446666444b99005aa6666666aaaa5600000000
bbbbbbbbbbb3300bbb3308000000bbbbbbb3000bbb33000bbb330000a4444444444999aa0b44444444b999000b44444444b9990066656111656aaa5600000000
0bbbbbbbbb33300bbb3300000000bbbbbbb3300bbb33000bbb330000a4444444444a99aa0b44444444b099000b44444444b0990066665ddd566a566600000000
00bbbbbbb333000bbb3300000000bbbbbbb3300bbb33000bbb330000a9444444449a99aa09bb4444bb90990009bb4444bb9000005aa55ddd5555666a00000000
00033333333000033333000800003333333330033330000333300000a99a4444a99aaaaa0990b44b099000000990b44b09900000aaa66ddd66666aaa00000000
00003333330000003330000000000333333300033300000333000000a99aa44aa99aaaaa09900bb00000000000000bb009900000aaaa6666666aaaaa00000000
00ccccccccc00000008ccccc10000ccccccc80000009999999890000000999999990000999f0000999f000000000000000000000000000000000000000000000
0ccccccccccc00000008cccc1000ccccccccc8000899999998989000009999999999000999f0000999f000000000000000000000000000000000000000000000
ccccccccccccc0000008cccc100ccccccccccc800999999999899900099999999999f009999f000999f000000000000000000000000000000000000000000000
ccc1111111ccc10080811111100ccc11111ccc808999fffffff999f00999fffff999f0099999f00999f000000000666660000000000066666000000000000000
ccc100000011110088810000000ccc10000ccc100999f000000ffff00999f0000999f00999999f0999f000000006666666000000000666666600000000000000
ccc10000000000008cc10000000ccc10000ccc800999f000000000000999f0000999f009999999f999f000000066666666600000006666666660000000000000
ccccccc000000000cc8ccccc100ccccccccccc1009999999999f00000999f0000999f0099999977877f000000067c6667c6000000067c6667c60000000000000
0ccccc8770000000cccccccc100ccccccccccc10009999999999f0000999f0000989f00999f9979897f00000006cc666cc600000006cc666cc60000000000000
00ccccc887708000cccccccc100ccccccccccc100009999999999f000999f0000989f00999f0988988f000000061c666c16000000061c666c160000000000000
0001111118888100ccc11111100ccc10000ccc100000ffffff9999f00999f0000999f00999f0079897f000000066166616600000006616661660000000000000
000000000c8cc100ccc10000000ccc1000787c1000000000009999f00999f0000988800999f0077877f000000006666666000000000666666600050000000000
ccc000000cccc100ccc10000000ccc100708c71009990000009999f00999f0000880000999f0000999f000000065611165600056006561116560560000000000
cccccccccc8cc100cccccccc100ccc10088c881009999999999999f0099998998800800999f0000999f0000000665ddd5660566000665ddd5665660000000000
cccccccccccc1100cccccccc100ccc100708c7100999999999999ff0009999898000000999f0000999f0000000055ddd5555660000055ddd5555000000000000
0cccccccccc11000cccccccc100ccc1000787c10009999999999ff00000999998800000999f0000999f0000000066ddd6666000000066ddd6666000000000000
0011111111110000111111111001111000011110000ffffffffff0000000fffff000000fff00000fff0000000000550005500000000550000055000000000000
__label__
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssrrrssssrssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssrsssssrrrsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssrrrssrrrrrssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssrsssrrrsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssrrrssssrssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssss888ss88s88ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssss8ssss88888ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssss888ss88888ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
sss88s88s88s88888s88ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
sss88888888888s88888ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
sss88888s88888s88888ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssss888sss888sss888sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
sssss8sssss8sssss8ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssss88ss8sssss8sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
sssssssss8338888888sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
sssssss338738s888s8sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
sssssss338s98s888s8sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssss93888ss88888ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
sssssssss33sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
sssssssss3ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss88s88s88s88s88s88ssssssssssssssssssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss88888s88888s88888ssssssssssssssssssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss88888s88888s88888ssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss888sss888sss888sssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss88s88s88s88s88s88sssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss88888s88888s88888sssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss88888s88888388888sssssssssssssssssssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss888ss388833s888ssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss77s883773sss8sssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss7ssss337s9ssssssssssssssssssssssssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss33sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss8ss37338ssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss8s99s338ssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss3s339sssssssssssssssssssssssssssss88s88s88s88s88s88sssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss7sss33s7ssssssssssssssssssssssssssssss88888s88888s88888sssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss77s88377ssssssssssssssssssssssssssssss88888s88888s88888sssssssssss
sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss888sss888sss888ssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss8sssss8sssss8sssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss3sssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss33sssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss33373sssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssrsssssssssssssssssssssssssssssssssssssssssssssssrsss333s99ssssssssssssssssss
ssssssssssssssssssssssssssrrrsssssssssssssssssssssss3sssssrrrsssssssssssssrrrsssssssssssssssssssssss3ss933s3ssssssssssssssssssss
ssssssssssssssssssssssssssrrrssssssssssssssssssssssrrrssssrrrsssssssssssssrrrssssssssssssssssssssssrrrssss33ssssssssssssssssssss
ssssssssssssssssssssssssss333ssssssssssssssssssssss333ssss333sssssssssssss333ssssssssssssssssssssss333ssss3sssssssssssssssssssss
ssssssssssssssssssssssssss333sssssssssssssssssssssrrrrrsss333sssssssssssss333sssssssssssssssssssssrrrrrsssssssssssssssssssssssss
ssssssssssssssssssssssssss333sssssssssssssssssssss33333sss333sssssssssssss333sssssssssssssssssssss33333sssssssssssssssssssssssss
ssssssssssssssssssssssss3rs4ss33ssssssssssssssss3sss4ss33rs4ss33ssssssss3rs4ss33ssssssssssssssss3sss4ss3ssssssssssssssssssssssss
ssssssssssssssssssssssssr3s4ssrrssssssssssssssssr3ss4srrr3s4ssrrssssssssr3s4ssrrssssssssssssssssr3ss4srrssssssssssssssssssssssss
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333338838838838838838833333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333338888838888838888833333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333338888838888838888833333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333888333888333888333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333383333787773383333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333337777777333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333377777777733333333333333333333333883883883883333333333333333333
33333333333333333333333333333333333333333333333333333333333333333774447444773333333333333333333333888883888883333333333333333333
33333333333333333333333333333333333333333333333333333333333333333744444444473333333333333333333333888883888883333333333333333333
3333333333333333333333333333333333333333333333333333333333333333474s7444s7474333333333333333333333388833388833333333333333333333
3333333333333333333333333333333333333333333333333333333333333333474ss444ss474333333333333333333333338333378777333333333333333333
3333333333333333333333333333333333333333333333333333333333333333374ss434ss473333333333333333333333333333777777733333333333333333
3333333333333333333333333333333333333333333333333333333333333333337444l444733333333333333333333333333337777777773333333333333333
33333333333333333333333333333333333333333333333333333333333333333337744477333333333333333333333333333377444744477333333333333333
33333333333333333333333333333333333333333333333333333333333333333333377733333333333333333333333333333374444444447333333333333333
33333333333333333333333333333333333338838838838833333333333333333333777773333333333333333333333333333474s7444s747433333333333333
33333333333333333333333333333333333338888838888833333333333333333333777773377333333333333333333333333474ss444ss47433333rrrrr3333
33333333333333333333333333333333333338888838888833333333333333333337747777773333333333333333333333333374ss434ss4733333rrrrrrbb33
333rrrrr333883883883883883883333333333888333888333333333333333333337747477333333333333333333333333333337444l444733333rrrrrrrrbbb
33rrrrrr3338888838888838888833333333333833337877733333333333333333343334333333333333333333333333333333337744477333333rrrrrrrrrbb
33rrrrrr333888883888883888883333333333333337777777333333333333333333333333333333333333333333333333333333337773333333rrrrrrrrrrbb
33rrrrrrrrb388833388833388833333333333333377777777733333333333333333333333333333333333333333333333333333377777333333rrrrrrrrrrbb
33rrrrrrrrb338333378777338333333333333333774447444773333333333333333333333333333333333333333333333333333377777337733rrrrrrrrrrbb
33rrrrrrrbb3333337777777333333333333333337444444444733333333333333333333333333333333333333333333333333337747777773333rrrrrrrrrbb
rrrrrrrrb3333333777777777333333333333333474s7444s74743333333333333333333333333333333333333333333333333337747477333333333rrrrrbbb
rrrrrrrrbbbbb337744474447733333333333333474ss444ss474333333333333333333333333333333333333333333333333333433343333333333rrrrrrb33
rrrrrrrrrrrrbb37444444444733333333333333374ss434ss47333333333333333333333333333333333333333333333333333333333333333333rrrrrrrb33
rrrrrrrrrrrrrb474s7444s74743333333333333337444l444733333333333333333333333333333333333333333333333333333333333333333rrrrrrrrrbbb
33rrrrrrrrrrrb474ss444ss47433333333333333337744477333333333333333333333333333333333333333333333333333333333333333rrrrrrrrrrrrrbb
33rrrrrrrrrrrbb74ss434ss47333333333333333333377733333333333333333333333333333333333333333333333333333333333333333rrrrrrrrrrrrrbb
33rrrrrrrrrrrrb37444l44473333333333333333333777773333333333333333333333333333333333333333333333333333333333333333rrrrrrrrrrrrrbb
3b444bbbbbbbbbb337744477333333333333333333337777733773333333331133333311333333333333333333333333333333333333333333333333333b443b
3b444333b33b33333337773333333333333333333337747777773333333366556633665566333333333333333333333333333333333333333333b3333b3b44b3
b4444333b33bb33333777773333333333333333333377474773333333336ll55llhhll55ll63333333333333333333333333333333333333333bb3333b3b44b3
3bb44333bb33bb33337777733773333333333333333433343333333333ll555555hh555555ll333333333333333333333333333333333333333b33333b3b4444
33b443333b333b33377477777733333333333333333333333333333333l5555555hh5555555l33333333333333333333333333333333333333b333333b3b44b3
33b443333b333b3337747477333333333333333333333333333333333l55555555hh55555555l3333333333333333333333333333333333333b333333b3b443b
33b4433333b33b3334333433333333333333333333333333333333333l55555555hh55555555l33333333333333333333333333333333333333b3333b44444b3
33b443333b333b3333333333333333333333333333333333333333333l15555555hh55555551l3333333333333333333333333333333333333b33333b33bb43b
33b443336666666666633333333333333333333333333333333333333611155555hh555551116333333333333333333333333333333333333b33333bb33b4433
33b44b33666666666663333333333333333333333333333333333333ll666611661166116666ll333333333333333333333333333333333333b3333b333b4433
33b4443366888666666333333333333333333333333333333333333555hhhh1155hh5511hhhh55533333333333333333333333333333333333bb333bb33b4433
b4444333668886666663333333333333333333333333333333333331hhhhhhhhhhhhhhhhhhhhhh1333333333333333333333333333333333333b3333b333b433
3bb4433366888666666333333333333333333333333333333333333l776655hhhhhhhhhh556677l333333333333333333333333333333333333b3333b33b4433
33b443336688866666633333333333333333333333333333333333355hhhhhhhhhhhhhhhhhhhh55333333333333333333333333333333333333b3333b33b4443
33b443336688866666633333333333333333333333333333333333355hhhhhhhhhhhhhhhhhhhh55333333333333333333333333333333333333b3333b33b4433
33b4433366888666666333333333333333333333333333333333333666hhhhhhhhhhhhhhhhhh666333333333333333333333333333333333333b3333b33b4433
33333333668886666663333333333333333333333333333333333336777777776655667777777763333333333333333333333333333333333333333333333333
333333336699966666633333333333333333333333333333333333hh5511hhhhhhhhhhhhhh1155hh333333333333333333333333333333333333333333333333
3333333366666666666333333333333333333333333333333333391hhhhhhhhhhhhhhhhhhhhhhhh1933333333333333333333333333333333333333333333333
3333333366666666666333333333333333333333333333333333955666111hhhh1111hhhh1116665593333333333333333333333333333333333333333333333
333333336666666666633333333333333333333333333333333351hhhhhhhhhhhh55hhhhhhhhhhhh153333333333333333333333333333333333333333333333
333333336666666666633333333333333333333333333333333551hhhhhhhhhhhh55hhhhhhhhhhhh155333333333333333333333333333333333333333333333
33333333666666666663333333333333333333333333333333351hhhhhhhhhhhhh55hhhhhhhhhhhhh15333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333351hhhhhhhhhhhhh55hhhhhhhhhhhhh15333333333333333333333333333333333333333333333

__map__
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101012424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101404142434445464701010101010101012424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101505152535455565701010101010101012424248c24242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101606162636465666701010101010101012424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101707172737475767701010101010101012424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101808182838485868701010101010101012424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101909192939495969701010101010101012424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101a0a1a2a3a4a5a6a701010101010101012424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010a0101010a010a01010a0101010101012b01013b2b012b01013b010101b0b1b2b3b4b5b6b701010101010101012424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323082323232323230823232323232321212121212121212121212121212121222222222222222222222222222222222424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a2323092323231823232323182319232121212121212121212121212121212122222222222222221b222222220b22222424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
232323232323232323232323232323230c0d2121212121212121212121210e0f2822280b2222222222222222222222222424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
232318230823232323230923232323231c1d2121212121212121212121211e1f222822222222222222222222222222222424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
232323232323231a23232323182323232c2d2121212121212121212121212e2f2222222222220b222222222222220b222424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08232319231823232308232323231a233c3d2121212121212121212121213e3f221b2222222222222222221b2222222224888924242424c7c8242424cdce242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
23232323232323232323232323232323212121212121212121212121212121212222220b2222221b222222222222222224989924242424d7d8242424ddde242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000002000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010200002865026650256501e6501c65019640176401564013640116200f6200e6200c6200b620096100861006610056100461003610026100061000610006000060000600006000000000000000000000000000
000200002f6702d6702b6702867027660256602366021660206601e6601c6601a640196401864017640156401464012640106400f6300e6300e6300d6300c6300c6300b6300a6200a62009620096200861008610
000200002e6702f67030670306702d6602963029630246301e6301d6301c6301b63019630176201662014620136201262011620106200e6200d6200c620096100861008610096100961009610086100861008610
000f00000c0500c0500c0500d0500e0500f0501205015050170501a0501c0501e0501f0502105022050271501f150271501f150271101f110271101e1102611013730117300e7500c7500a750087500775006750
001000001c75000000000000000000700007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00040000040500605008050090500c0500e05011050140501b0502105022050230502505026000270002300023000230000000000000000000000000000000000000000000000000000000000000000000000000
000500001605018050190500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000023050230502405027050290502a0402d020300503005027000220002100023000270002c0002f000300002f0002e0002a0002700025000240002400026000280002a0002d0002d0002a0002600025000

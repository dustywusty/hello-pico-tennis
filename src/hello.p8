pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

debug = false

-- ball
b = {
  color = yellow,
  radius = 2,
  speed = 1,
  x = 40,
  x_direction = 1,
  y = 0,
  y_direction = 1,
}

-- pad
p = {
  color = white,
  height = 1,
  speed = 7.5,
  width = 15,
  x = 24,
  y = 110,
}

gameover = false
score = 0

function _init()
  cls()
end

function _update()
  -- restart
  if (btn(fire2)) then
    restart()
  end

  if gameover then
    return
  end

  -- controller / paddle direction
  if (btn(left) and p.x > 0) then
    p.x -= 1 * p.speed
  elseif (btn(right) and (p.x + p.width) < 128) then
    p.x += 1 * p.speed
  end

  -- ball & paddle collision detection
  if ((b.x - b.radius >= p.x and b.x - b.radius <= (p.x + p.width)) or (b.x + b.radius >= p.x and b.x + b.radius <= (p.x + p.width)))
      and (b.y + b.radius == p.y + p.height) then
    b.x_direction = -b.x_direction
    b.y_direction = -b.y_direction
    
    b.speed += 1
    score += 1

    sfx(1)
  end

  -- ball direction and speed
  b.x += b.x_direction * b.speed
  b.y += b.y_direction * b.speed

  -- outer wall boundaries
  if b.x > 127 or b.x < 0 then
    b.x_direction = -b.x_direction
    sfx(0)
  end

  if b.y < 0 then
    b.y_direction = -b.y_direction
    sfx(0)
  end

  -- game over
  if b.y > 127 then
    gameover = true
    score = 0
    sfx(2)
  end  
end

function _draw()
  cls()

  if debug then
    print("B "..b.x..","..b.y.." "..b.speed,0,1,red)
    print("P "..p.x..","..p.y.." "..p.speed,0,10,red)
  end

  if gameover then
    print("game over",46,64,yellow)
    print("x to restart",42,74,yellow)
    return
  end

  print("score "..score,0,120,yellow)
  
  circfill(b.x,b.y,b.radius,b.color)
  rectfill(p.x,p.y,p.x + p.width,p.y + p.height,p.color)
end

function restart()
  gameover = false
  b.x = rnd(127)
  b.y = 0
  b.speed = 1
  score = 0
end

__sfx__
000100002e7502d750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000003475000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000355001550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

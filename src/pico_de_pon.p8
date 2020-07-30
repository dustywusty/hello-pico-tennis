pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

-- curse of the lich king
-- created by @johanpeitz
-- audio by @gruber_music

-- special thanks to all testers
-- at the megadome discord

-- sorry for uncommented code,
-- had to strip it out to make
-- the whole thing fit! 😐
--  / johan

function _init()
  m_name, m_anim, m_col, m_prop, m_hp, m_atk, m_range, m_sight, m_depth, m_itemchance = explode("hero,a rat,a ghoul,pot,chest,shelves,door,door,altar,gate,lever,gate,spikes,an eyeball,an imp,box,a troll,pot,a skeleton,anvil,body,a toxic rat,a ghost,^raq'zul,well"),explodeval("240,192,224,29,13,15,4,5,25,7,31,9,47,228,244,212,208,27,196,24,11,216,200,248,22"),explodeval("8,8,12,7,7,7,7,7,7,7,7,7,7,14,14,9,3,7,7,7,7,11,7,1,7"),explodeval("0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,0,1,1,0,0,0,1"),explodeval("6,1,6,1,1,1,1,1,1,1,1,1,1,10,10,15,22,1,12,1,1,4,12,45,1"),explodeval("3,1,1,0,0,0,0,0,0,0,0,0,5,0,1,0,3,0,2,0,0,0,1,4,0"),explodeval("1,1,1,1,0,0,0,0,0,0,0,0,0,4,1,1,1,1,1,0,0,1,1,4,0"),explodeval("4,3,3,0,0,0,0,0,0,0,0,0,0,5,3,3,3,0,4,0,0,3,4,5,0"),explodeval("0,1,2,0,0,0,0,0,0,0,0,0,3,5,3,99,6,0,4,0,0,4,7,99,0"),explodeval("0,0,0,4,10,2,0,0,0,0,0,0,0,0,0,0,0,4,0,0,4,0,0,0,0")
  i_name, i_type, i_spr, i_atk, i_heal, i_hpmax, i_depth = explode("apple,carrot,bread,soup,steak,vial,potion,stick,dagger,scimitar,battleaxe,spear,broadsword,club,sword"),explodeval("0,0,0,0,0,0,0,1,1,1,1,1,1,1,1"),explodeval("0,0,0,0,0,0,0,76,92,100,120,104,96,108,124"),explodeval("0,0,0,0,0,0,0,1,2,6,3,7,8,5,4"),explodeval("1,2,5,10,15,0,0,0,0,0,0,0,0,0,0"),explodeval("0,0,0,0,0,1,3,0,0,0,0,0,0,0,0"),explodeval("1,2,3,4,5,2,4,1,2,6,3,7,8,5,4")
  i_trait,i_status={"","cursed ","holy "},explode" , of blight, of confusion, of the basilisk, of the leech"
  dirx,diry=explodeval"-1,1,0,0,-1,1,1,-1",explodeval"0,0,-1,1,1,-1,1,-1"
  dpal,lpal=explodeval"0,0,1,5,1,1,13,6,4,4,9,3,13,5,1,1",explodeval"1,5,4,11,9,13,7,7,14,10,7,7,7,6,15,7"
  _glyphs,_kerning,fdat={},{},[[  0000.0004! 0000.824c" 0000.0168# 0000.0204$ 0001.7490% 0002.1508& 0000.2f40' 0000.004c( 0008.9252) 0005.248a* 0000.5540+ 0000.2e80, 0004.8004- 0000.0e00. 0000.8004/ 0004.a5200 0001.5b501 0001.24d22 0003.95183 0001.c5184 0002.4f685 0001.c6786 0001.56507 0001.29388 0001.55509 0001.4d50: 0000.8204; 0004.8204< 0002.22a0= 0000.71c0> 0000.a888? 0001.0518@ 0001.1b50^a0002.fb50^b0001.d758^c0003.1270^d0001.db58^e0003.9678^f0000.b278^g0003.5270^h0002.df68^i0000.924c^j0005.2492^k0002.d768^l0003.9248^m0002.dfe8^n0002.db58^o0001.5b50^p0000.bb58^q0011.5b50^r0002.bb58^s0001.c470^t0001.24b8^u0003.5b68^v0001.5b68^w0002.ff68^x0002.d568^y000a.6b68^z0003.9538[ 000c.925a\ 0012.2448] 000d.249a^^0000.0150_ 0003.8000` 0000.008aa 0003.5b80b 0001.dac8c 0001.1282d 0003.5ba0e 0001.1e80f 0004.b252g 000e.7b80h 0002.dac8i 0000.920cj 0005.2412k 0002.d748l 0000.924cm 0002.dec0n 0002.dac0o 0001.5a80p 0005.dac0q 0013.5b80r 0000.9740s 0001.a2c2t 0001.12cau 0003.5b40v 0001.5b40w 0002.fb40x 0002.a540y 000e.6b40z 0001.94c2{ 0019.22b0| 0004.924c} 000d.2898~ 0000.1f00^*0000.7bc0]]
  for i=0,#fdat/11 do
    local p=1+i*11
    local char=sub(fdat,p,p+1)
    _glyphs[char],_kerning[char]=
    tonum("0x"..sub(fdat,p+2,p+10)),4
  end
  swap_state(title_state)
end

function level_init()
  make_player()
  pl.depth,pl.win,inventory=1,false,{}
  inventory.items,sleep=0,0
  give_item(make_item(8),true)
  give_item(make_item(1),true)
  hud=add_window(0,115,{" "},128)
  hud.hud=true
  make_new_level()
  music"2"
  if pl.depth==1 then
    add_modal(10,10,
    explode"^chills run down your spine as,you enter the ^lich ^king's lair.,,^you have travelled light but,hopefully you will find more,supplies hidden down here.,,^rumor has it ^raq'zul resides on,the 8th floor. ^descend his lair,and destroy him!"
    ,108)
  end
end

function make_new_level()
  phase,hash,entities,particles,floaters,fog,floater_delay,num_rooms=0,{},{},{},{},{},0,2+pl.depth*2
  for x=0,127 do
    fog[x]={}
    for y=0,31 do
      fog[x][y]=2
      hash[y]={}
    end
  end
  generate_level(num_rooms)
  camtx,camty,move_cam=pl.tx,pl.ty,false
  update_fog()
  if (pl.depth>1) show_alert("^floor "..pl.depth,nil,60).delay=30
end

function make_entities()
  for i=0,127 do
    for j=0,31 do
      local tile=mget(i,j)
      if tile==17 then
        pl.tx,pl.ty=i,j
        add(entities,pl)
      else
        local id=indexof(m_anim,mget(i,j))
        if id>0 then
          if m_prop[id]==1then
            tm=make_prop(id,i,j)
            mset(i,j,1)
          else
            tm=make_mob(id,i,j)
            mset(i,j,1)
          end
          add(hash[tx2hash(tm.tx)],tm)
        end
      end
    end
  end
end

function make_player(tx,ty)
  pl=make_e(1,{
    mob=true,
    fs=2,
    weapon=nil,
    tx=tx, ty=ty,
    logic=player_logic
  })
end

function player_logic(e)
  if e.hp>0 then
    if e.paralyzed>0 then
      phase+=1
      move_anim(e,0,0,0)
    else
      if e.confused>0 then
        next_btn=intrnd(4)
      end
      if next_btn>=0 and next_btn<4 then
        if move_entity(e,dirx[next_btn+1],diry[next_btn+1]) then
          update_fog()
          phase+=1
        end
      elseif next_btn==5 then
        show_inventory()
      end
    end
    next_btn=-1
  else
    if e.hit_count==0 then
      e.hit_count=-1
      add_modal(32,32,{
        "",
        "^killed by "..pl.hit_by.name,
        "on floor "..pl.depth..".",
        ""
      },nil,
function ()
      fadeout()
      swap_state(title_state)
      end)
    end
  end
end

function make_prop(id,tx,ty)
  local p=make_e(id,{
    prop=true,
    tx=tx, ty=ty,
    walkable=false
  })
  p.block_los = id==7 or id==8
  if id==5 or id==9 or id==20 or id==25 then
    p.uf=
function(p)
    if chance(0.03) and not p.used then
      add_rising_particle(p,explodeval"5,6,13,7,12")
    end
    update_entity(p)
  end
end
if id==13 then
  p.trap,p.walkable=true,true
  p.logic=
function(e)
  local m=get_entity(e.tx,e.ty,"mob")
  if m then
    change_entity_hp(m,e,-e.atk)
    e.logic=nil
    e.frames[1]-=1
    sfx"54"
  end
end
end
return p
end

function make_mob(id,tx,ty)
m=make_e(id,{
mob=true,
fs=4,
dir=chance"0.5" and 1 or -1,
tx=tx, ty=ty,
logic=wait_logic
})
if id==15 or id==24 then
m.after_attack=blink
end
return m
end

function confused_logic(e)
local options={}
for i=1,4 do
if is_floor(mget(e.tx+dirx[i],e.ty+diry[i])) then
  add(options,i)
end
end
if #options>0 then
local d=rnd_elem(options)
move_entity(e,dirx[d],diry[d])
e.fc,e.frame=0,0
else
end
if e.confused==0 then
e.logic=chase_logic
end
end

function paralyzed_logic(e)
if e.paralyzed==0 then
e.logic=chase_logic
wait_logic(e)
end
end

function flee_logic(e)
local bdist,bdir=0,0
for i=1,4 do
local dstx=e.tx+dirx[i]
local dsty=e.ty+diry[i]
if is_walkable(dstx,dsty,"move") then
  local dist=distance(pl.tx,pl.ty,dstx,dsty)
  if dist>bdist then
    bdir,bdist=i,dist
  end
end
end
if bdir>0 then
move_entity(e,dirx[bdir],diry[bdir])
e.fc,e.frame=0,0
end
local dist=distance(e.tx,e.ty,pl.tx,pl.ty)
if (dist>e.sight) e.logic=wait_logic
end

function chase_logic(e)
e.attacked=false
local cansee=false
if los(e.tx,e.ty,pl.tx,pl.ty,e.sight) then
e.gx,e.gy=pl.tx,pl.ty
cansee=true
end
local dist=distance(e.tx,e.ty,pl.tx,pl.ty)
local perp=e.tx-pl.tx==0 or e.ty-pl.ty==0
if dist<=e.range and perp and cansee then
if e.id==24 then
  if dist==1 then
    e.atk=5
    change_entity_hp(e,e,2)
  else
    e.atk=1
  end
end
attack_entity(e,pl)
e.attacked=true
local dx=ssgn(pl.tx-e.tx)
local dy=ssgn(pl.ty-e.ty)
move_anim(e,dx,dy,4)
if e.id==22 then
  pl.poisoned+=3
elseif e.id==23 and chance"0.5" then
  pl.paralyzed=2
end
if e.range>1 then
  if e.id==14 or (e.id==24 and dist>1) then
    pl.confused+=2
    sfx"55"
    local x,y=e.tx,e.ty
    for i=0,dist,0.125 do
      add_particle(
      (x+i*dx)*8+3,
      (y+i*dy)*8+3,
      0,0,2+rnd(5),
      explodeval("8,9,10,7")
      )
    end
    sleep=20
  end
end
else
local bdist,bdir=999,intrnd"4"+1
for i=1,4 do
  local dstx,dsty=e.tx+dirx[i],e.ty+diry[i]
  if is_walkable(dstx,dsty,"move") then
    dist=distance(e.gx,e.gy,dstx,dsty)
    if dist<bdist then
      bdir,bdist=i,dist
    end
  end
end
move_entity(e,dirx[bdir],diry[bdir])
e.fc,e.frame=0,0
if e.tx==e.gx and e.ty==e.gy then
  sfx"56"
  add_floater("?",e,10)
  e.logic=wait_logic
end
end
end

function wait_logic(e)
if (distance(e.tx,e.ty,pl.tx,pl.ty)>e.sight) return
if los(e.tx,e.ty,pl.tx,pl.ty,e.sight) then
sfx"57"
add_floater("!",e,10)
e.gx,e.gy,e.logic=pl.tx,pl.ty,chase_logic
if (e.id==16) e.logic=flee_logic
end
end

function move_anim(e,dx,dy,dist)
e.mt,e.odist,e.ox,e.oy,e.dx,e.dy=0,dist,dist*dx,dist*dy,dx,dy
if dist!=0 then
e.fc,e.frame=0,0
end
if e.confused>0 then
e.dir=rnd_elem({1,-1})
else
if (dy==0) e.dir=dx<0 and -1 or 1
end
end

function tx2hash(tx)
return flr(tx/8)
end

function addhash(e)
add(hash[tx2hash(e.tx)],e)
end

function delhash(e)
del(hash[tx2hash(e.tx)],e)
end

function move_entity(e,dx,dy)
local dstx,dsty=e.tx+dx,e.ty+dy
local tile=mget(dstx,dsty)
if is_walkable(dstx,dsty,"move") then
delhash(e)
e.tx,e.ty=dstx,dsty
addhash(e)
move_anim(e,dx,dy,-8)
sfx(62+e.t%2)
return true
elseif e==pl then
move_anim(e,dx,dy,3)
if interact(e,dstx,dsty) then
  return true
end
sfx"37"
end
return false
end

function is_walkable(tx,ty,mode)
local tile=mget(tx,ty)
if mode=="los" then
if not fget(tile,1) then
  local e=get_entity(tx,ty)
  if (not e) return true
  if (e.block_los) return false
  return true
end
return false
elseif mode=="move" then
if not fget(tile,0) then
  local e=get_entity(tx,ty,"mob")
  if not e then
    e=get_entity(tx,ty)
    if (not e) return true
    if (e.walkable) return true
  end
end
return false
end
return false
end

function get_entity(tx,ty,typ)
local arr=hash[tx2hash(tx)]
for e in all(arr) do
if e.hp>0 and e.tx==tx and e.ty==ty then
  if typ and not e[typ] then
  else
    return e
  end
end
end
return nil
end

function interact(mob,tx,ty)
local e=get_entity(tx,ty,"mob")
if (e) return attack_entity(mob,e)
e=get_entity(tx,ty)
if (not e) return false
if (e.used) return false
if e.id==20 then
if not tried_anvil then
  tried_anvil=true
  return add_modal(22,28,explode"^a mighty anvil...,,^spend a turn on this,hefty piece to bestow,a wepaon with special,powers - if you have,the right items.")
end
if pl.weapon==nil then
  show_alert("^equip weapon to alter...")
  return false
elseif pl.weapon.trait!=1 or pl.weapon.status!=1 then
  show_alert("^weapon must be untampered...")
  return false
end
local foods={}
for i=1,8 do
  local itm=inventory[i]
  if itm and itm.type==0 and itm.trait==2 then
    add(foods,itm)
  end
end
if #foods==0 then
  show_alert("^cursed food required...")
  return false
end
discard_item(rnd_elem(foods),true)
if chance(1-0.05*pl.weapon.atk) then
  sfx"32"
  sleep=24
  enchant_item(pl.weapon,true)
  show_alert(item_name(pl.weapon),1).delay=30
else
  sfx"38"
  sleep=10
  show_alert(pl.weapon.name.." shattererd!")
  discard_item(pl.weapon,true)
end
end
if e.id==25 then
if not tried_well then
  tried_well=true
  return add_modal(22,28,explode"^a shallow pool...,,^the strangely clear water,has the power to free,a weapon from its curse.,^it only costs a turn")
end
if not pl.weapon or pl.weapon.trait!=2 then
  show_alert("^dip a cursed weapon in the pool...")
  return false
else
  show_alert("^"..pl.weapon.name.." is no longer cursed!")
  sleep,e.frames[1],e.used,pl.weapon.trait=10,21,true,1
  sfx"46"
end
end
if e.id==9 then
if not tried_altar then
  tried_altar=true
  return add_modal(22,28,explode"^a holy altar...,,^the book on the table has,the answers you need.,^spend a turn here to,identify a mysterious item.")
end
local unids={}
for i=1,8 do
  local itm=inventory[i]
  if itm and not itm.identified then
    add(unids,itm)
  end
end
if #unids>0 then
  local itm=rnd_elem(unids)
  sfx(45+itm.trait)
  sleep,itm.identified=10,true
  show_alert(item_name(itm),3)
else
  show_alert("^nothing to identify...")
  return false
end
end
if e.id==7 or e.id==8 then
sfx(61)
delhash(e)
del(entities,e)
end
for id in all(explodeval"4,5,6,18,21") do
if e.id==id and not e.used then
  local itmid,csnd
  if id==5 then
    csnd,itmid=49,get_depth_item(explodeval("8,9,10,11,12,13,14,15"))
  elseif id==6 then
    csnd=60
    if e.hasitem then
      itmid=get_depth_item({6,7})
    end
  else
    csnd=id==21 and 60 or 50
    if e.hasitem then
      itmid=get_depth_item(explodeval("1,2,3,4,5"))
    elseif chance"0.1" then
      addhash(make_mob(chance(0.7) and 2 or 22,tx,ty))
    end
  end
  if itmid then
    if inventory.items<8 then
      give_item(make_item(itmid))
      e.used=true
    else
      show_alert("^can't carry any more...")
      return sfx"37"
    end
  else
    e.used=true
  end
  if e.used then
    sfx(csnd)
    e.frames[1]-=1
    if (id==4 or id==18 or id==21) e.walkable=true
  end
end
end
return true
end

function get_depth_item(selection)
local pool={}
for id in all(selection) do
if (i_depth[id]<=pl.depth) add(pool,id)
end
return rnd_elem(pool)
end

function win_game()
music"-1"
sfx"6"
for i=1,50 do
flip()
end
fadeout()
music"23"
add_modal(8,24,
explode("^as the ^lich king lets out a final;scream, something shifts in the;air. ^you feel lighter, as if an;invisible burden has lifted.;;^raq'zul is defeated and you;return to the surface knowing;that the world has become;a better place.",";")
,112,
function ()
pl.win=false
music"-1"
fadeout()
swap_state(title_state)
end
)
end

function add_floater(str,e,c,delay)
if (delay) floater_delay+=delay
add(floaters,{
str=str,
e=e,
dy=1,
oy=0,
c=c,
life=25,
delay=floater_delay
})
if (not delay) floater_delay+=2
end

function level_update()
if sleep==0 then
if phase==0 then
pl.logic(pl)
elseif phase==2 then
if mget(pl.tx,pl.ty)==16 then
  sfx"53"
  fadeout()
  pl.depth+=1
  return make_new_level()
elseif pl.win then
  win_game()
else
  for e in all(entities) do
    if not e.trap and e!=pl and e.hp>0 and e.logic then
      update_entity_status(e)
      e.logic(e)
    end
  end
  for e in all(entities) do
    if (e.trap and e.logic) e.logic(e)
  end
  phase+=1
  if pl.confused>0 or pl.paralyzed>0 then
    sleep=20
  end
end
end
if phase==3 then
local atk,move_on=false,true
for e in all(entities) do
  if (e.mt<1) move_on=false
  if (e.attacked) atk=true
end
if (not atk or move_on) phase+=1
end
else
sleep-=1
end
for e in all(entities) do
if e.uf(e) then
if e==pl and phase==1 then
  phase+=1
end
end
end
if phase>3 then
sort(entities,"ty")
phase=0
update_entity_status(pl)
end
for p in all(particles) do
if (p.uf) p.uf(p)
p.life-=1
if (p.life<=0) del(particles,p)
end
if (floater_delay>0) floater_delay-=1
for f in all(floaters) do
if f.delay>0 then
f.delay-=1
else
f.oy-=f.dy
f.dy*=0.8
f.life-=1
if (f.life<=0) del(floaters,f)
end
end
end

function level_draw()
local dz=2
if pl.tx<camtx-dz then
camtx-=1
move_cam=true
elseif pl.tx>camtx+dz then
camtx+=1
move_cam=true
elseif pl.ty<camty-dz then
camty-=1
move_cam=true
elseif pl.ty>camty+dz then
camty+=1
move_cam=true
end
if move_cam then
camera((camtx-8)*8+pl.ox+4,
(camty-8)*8+pl.oy+4)
else
camera((camtx-8)*8+4,
(camty-8)*8+4)
end
if (pl.ox==0 and pl.oy==0) move_cam=false
cls()
fmap(camtx-8,camty-8)
for e in all(entities) do
e.df(e)
end
for p in all(particles) do
pset(p.x,p.y,rnd_elem(p.c))
end
for f in all(floaters) do
if f.delay==0 then
pr(f.str,
f.e.tx*8-tlen(f.str)/2+4+f.e.ox,
f.e.ty*8-4+f.oy+f.e.oy,
f.c,1)
end
end
camera()
spr(174,1,0,2,2)
local col,btny=12,6
if inventory.items==8 then
btny+=sin(time())+1
col=8
end
if pl.hp>0 and not modal_top then
pr("[*]",16,7,5 )
pr("[*]",16,btny,col )
end
end
last_pal=0

function set_pal(p)
if (p==last_pal) return
if not p then
pal()
pal(14,1)
else
for i=1,16 do
pal(i-1,p[i])
end
end
last_pal=pal
end

function fmap(tx,ty)
for x=tx,min(127,tx+16) do
for y=ty,min(31,ty+16) do
if x>=0 and y>=0 then
  local fv=fog[x][y]
  if fv==1 then
    set_pal(dpal)
  elseif fv==0 then
    set_pal()
  end
  local tile=mget(x,y)
  if fv!=2 and tile>0 then
    spr(tile,x*8,y*8)
  end
end
end
end
pal()
fillp()
end

function los(x1,y1,x2,y2,sight)
local frst,sx,sy,dx,dy=true
local dist=distance(x1,y1,x2,y2)
if (dist>sight) return false
if (dist==1) return true
if x1<x2 then
sx,dx=1,x2-x1
else
sx,dx=-1,x1-x2
end
if y1<y2 then
sy,dy=1,y2-y1
else
sy,dy=-1,y1-y2
end
local err,e2=dx-dy,nil
while not(x1==x2 and y1==y2) do
if not frst then
if not is_walkable(x1,y1,"los") then
  return false
end
end
frst,e2=false,err+err
if e2>-dy then
err-=dy
x1+=sx
end
if e2<dx then
err+=dx
y1+=sy
end
end
return true
end

function inbounds(tx,ty)
if (tx<0 or ty<0 or tx>=127 or ty>=31) return false
return true
end

function update_fog()
local r,px,py=pl.sight+1,pl.tx,pl.ty
for ty=py-r,py+r do
for tx=px-r,px+r do
if inbounds(tx,ty) then
  if fog[tx][ty]==0 then
    local d=distance(px,py,tx,ty)
    if (d<r+1) fog[tx][ty]=1
  end
  if los(px,py,tx,ty,pl.sight) then
    fog[tx][ty]=0
  end
end
end
end
end
level_state={
init=level_init,
update=level_update,
draw=level_draw
}

function round(x)
  return flr(x+0.5)
end

function chance(x)
  return rnd()<x+0
end

function add_params(src,dst)
  for k,v in pairs(src) do
    dst[k]=v
  end
end

function strchr(str,c)
  for i=1,#str do
    if (sub(str,i,i)==c) return i
  end

  return -1
end

function indexof(a,e)
  for i=1,#a do
    if (a[i]==e) return i
  end

  return -1
end

function ssgn(x)
  return x<0 and -1 or x>0 and 1 or 0
end

function distance(ax,ay,bx,by)
  local dx,dy=ax-bx,ay-by
  return sqrt(dx*dx+dy*dy)
end

function sort(a,p)
  for i=1,#a do
    local j = i
    while j > 1 and a[j-1][p] > a[j][p] do       a[j],a[j-1] = a[j-1],a[j]
      j = j - 1
    end
  end
end

function intrnd(r)
  return flr(rnd(max(0,r)))
end

function rnd_elem(a)
  return a[intrnd(#a)+1]
end

function explode(s,delim)
if (not delim) delim=","
local retval,lastpos={},1
for i=1,#s do
if sub(s,i,i)==delim then
add(retval,sub(s, lastpos, i-1))
i+=1
lastpos=i
end
end
add(retval,sub(s,lastpos,#s))
return retval
end

function explodeval(_arr)
  return toval(explode(_arr))
end

function toval(_arr)
  local _retarr={}
  for _i in all(_arr) do
    add(_retarr,flr(_i+0))
  end
  return _retarr
end

function tlen(str)
  local l,i=0,1

  while i<=#str do
    local char=sub(str,i,i)
    if char=="^" then
      char=sub(str,i,i+1)
      i+=1
    else
      char=char.." "
    end
    l+=_kerning[char]
    i+=1
  end
  return l
end

function pr(str,x0,y0,c1,c2)
local x1,i=x0,1
while i<=#str do
local char=sub(str,i,i)
if char=="\n" then
y0+=7
x1=x0
else
if char=="^" then
  char=sub(str,i,i+1)
  i+=1
else
  char=char.." "
end
local px,k=_glyphs[char],4
for j=1,2 do
  px=shr(px,1)
  if (band(px,0x0.0001)>0) k-=j
end
for y=0,5 do
  for x=0,2 do
    px=shr(px,1)
    if band(px,0x0.0001)>0 then
      pset(x1+x,y0+y,c1)
      if (c2) pset(x1+x,y0+y+1,c2)
    end
  end
end
x1+=k
_kerning[char]=k
end
i+=1
end
end
next_btn, state, next_state, change_state ,fade_progress,fade_pal= -1, {}, {}, false,1,explodeval"0,0,1,5,1,1,13,6,4,4,9,3,13,5,4,4"

function swap_state(_s)
  next_state,change_state =_s,true
end

function _update()
  if next_btn<0 then
    for i=0,5 do
      if (btnp(i)) next_btn=i
    end
  end
  if change_state then
    state, change_state, windows = next_state, false,{}
    state.init()
  end
  if update_windows() then
    state.update()
  end
  if fade_progress>0 then
    fade_progress-=0.075
  end
end

function update_fade()
  for i=0,15 do
    local col,k=i,6*fade_progress
    for j=1,k do
      col=fade_pal[col+1]
    end
    pal(i,col,1)
  end
end

function fadeout()
  while fade_progress<1 do
    fade_progress=min(fade_progress+0.05,1)
    update_fade()
    flip()
  end
end

function _draw()
  state.draw()
  camera()
  draw_windows()
  update_fade()
end

function make_e(id,params)
  local e={
    id=id,
    name=m_name[id],
    col=m_col[id],
    sight=m_sight[id],
    range=m_range[id],
    hp=m_hp[id],
    hpmax=m_hp[id],
    atk=m_atk[id],
    hasitem=chance(m_itemchance[id]/10),
    lvl=1,
    poisoned=0,
    confused=0,
    paralyzed=0,
    t=0,
    mt=0,
    tx=0, ty=0,
    ox=0, oy=0,
    dx=0, dy=0,
    odist=0,
    dir=1,
    xp=0,
    hit_count=0,
    df=draw_entity,
    uf=update_entity,
    fc=0,
    fs=0,
    frame=0,
    frames={m_anim[id]},
  }
  if (params) add_params(params,e)
  if e.mob then
    for i=1,3 do
      add(e.frames,m_anim[id]+i)
    end
  end
  add(entities,e)
  return e
end

function xp_req(lvl)
  local xp=0
  for i=1,lvl do
    local ii=i+1
    xp+=ii*ii-4
  end
  return xp
end

function give_xp(e,xp)
  e.xp+=xp
  floater_delay+=10
  add_floater("+"..xp,e,12)
  while e.xp>=xp_req(e.lvl+1) do
    level_up(e)
  end
end

function level_up(e)
  sfx"52"
  e.lvl+=1
  e.atk+=1
  e.hpmax+=3
  e.hp=pl.hpmax
  floater_delay+=10
  add_floater("^level up",e,12,5)
  add_floater("^a^t^k +1",e,12,25)
  add_floater("^max ^h^p &+3",e,12,25)
  add_floater("^h^p refilled!",e,12,25)
end

function get_dmg(e)
  return e.atk+(e.weapon and e.weapon.atk or 0)
end

function attack_entity(a,d)
  if change_entity_hp(d,a,-get_dmg(a)) then
    if a==pl then
      give_xp(a,1)
      if d.id==16 then
        local itm=make_item(1+intrnd"5",3)
        itm.identified=true
        give_item(itm)
      elseif d.id==24 then
        pl.win,d.frames,d.fc,d.frame=    true,{252},0,0
      end
    end
      sfx"58"
      else
      sfx"59"
      end
      if a.weapon then
        local aws=a.weapon.status
        if aws==2 then
          d.poisoned+=3
        elseif chance"0.5" and aws==3 and d.id!=24 then
          d.confused+=5
          d.logic=confused_logic
        elseif chance"0.3" and aws==4 and d.id!=24 then
          d.paralyzed+=2
          d.logic=paralyzed_logic
        elseif chance"0.3" and aws==5 then
          change_entity_hp(a,a,1)
        end
        if a.weapon.trait==2 then
          a.weapon.atk-=1
        if a.weapon.atk<=0 then
          local itm=a.weapon
          show_alert(itm.name.." shattered!")
          itm.trait=1
          unequip_item(itm,true)
          discard_item(itm,true)
          sfx"38"
      end
    end
  end
  return true
end

function change_entity_hp(de,se,dmg)
de.hp=min(de.hp+dmg,de.hpmax)
de.hit_count,de.hit_by=10,se
if dmg!=0 then
if dmg>0 then
add_floater("+"..dmg,de,11,10)
else
add_floater(""..dmg,de,8)
end
end
if dmg<0 and se.tx then
for i=1,8 do
add_particle(
de.tx*8+2+rnd(4),
de.ty*8+3+rnd(2),
ssgn(de.tx-se.tx)*(1+rnd(1)),
ssgn(de.ty-se.ty)*(0.3+rnd(0.3)),
5+rnd(5),
{de.col},

function(p)
  p.x+=p.dx
  p.dx*=0.8
  p.y+=p.dy
  p.dy+=0.1
end
)
end
end
if de==pl and pl.hp<=0 then
sfx"51"
music"24"
pl.hit_count,pl.fs,pl.frames=100,5,explodeval"232,232,232,232,232,232,232,232,233,234,235"
end
return de.hp<=0
end

function blink(e)
if (e.hp<=0) return
for i=0,7 do
add_rising_particle(e,explodeval"15,15,14,7")
end
delhash(e)
local moved=false
while not moved do
local dx,dy=intrnd"7"-3,intrnd"7"-3
local dstx,dsty=e.tx+dx,e.ty+dy
if is_floor(mget(dstx,dsty)) and is_walkable(dstx,dsty,"move") then
e.tx+=dx
e.ty+=dy
e.logic,moved=chase_logic,true
end
end
addhash(e)
end

function add_particle(x,y,dx,dy,life,c,uf)
add(particles,{
x=x,y=y,
dx=dx or 0,
dy=dy or 0,
life=life,
c=c,
uf=uf
})
end

function update_entity_status(e)
  if e.poisoned>0 then
    e.poisoned-=1
    change_entity_hp(e,e,-1)
    e.hit_by={name="poison"}
  end
  if e.paralyzed>0 then
    e.paralyzed-=1
  end
  if e.confused>0 then
    e.confused-=1
  end
end

function update_entity(e)
if (e.mt<=1) e.mt+=0.125
if e==pl then
if e.mt<=1 then
e.ox, e.oy = e.dx*e.odist*(1-e.mt), e.dy*e.odist*(1-e.mt)
end
else
e.ox*=0.5
e.oy*=0.5
end
if e.hit_count>0 then
e.hit_count-=1
else
if e.hp<=0 then
delhash(e)
del(entities,e)
end
end
if e.t%8==0 and e.poisoned>0 then
add_rising_particle(e,explodeval"3,11,10,5")
end
if e.mt>=1 and e.attacked then
if e.after_attack then
e.after_attack(e)
e.attacked=false
end
end
update_entity_anim(e)
return e.mt>=1
end

function add_rising_particle(e,cols)
add_particle(
e.tx*8+1+rnd(6)+e.ox,
e.ty*8+rnd(6)+e.oy,
0,-0.1-rnd(0.2),
30+rnd(20),
cols,

function(p)
p.y+=p.dy
end
)
end

function update_entity_anim(e)
  e.t+=1
  e.fc+=1
  if e.fc > e.fs then
    e.frame+=1
    e.fc=0
    if e.frame >= #e.frames then
      e.frame-=1
    end
  end
end

function draw_entity(e)
if (fog[e.tx][e.ty]==2) return
local x,y=e.tx*8+e.ox,e.ty*8+e.oy
if fog[e.tx][e.ty]==1 then
set_pal(dpal)
end
if e.hit_count>0 and e.t%3==0 then
set_pal(lpal)
end
spr(e.frames[1+e.frame],
x, y,
1, 1,
e.dir==-1)
pal()
if e.weapon and e.hp>0 then
spr(e.weapon.spr+e.frame,
x+e.dir, y,
1, 1,
e.dir==-1)
end
if e.hp>0 then
local indicator=""
if (e.confused>0) indicator="?"
if (e.paralyzed>0) indicator="..."
pr(indicator,x+6-2*#indicator,y-6,10)
end
end
windows,modal_top,modal_stack={},nil,{}
s_time=0

function show_alert(txt,hdr,life)
  local w=add_window(0,24,{txt})
  w.x,w.hdr=63-w.w/2,hdr
  w.life=life or 60
  return w
end

function add_modal(x,y,lines,width,on_close)
  local w=add_window(x,y,lines,width)
  w.btn,w.on_close,modal_top=true,on_close,w
  add(modal_stack,w)
end

function add_window(x,y,lines,width)
  local w={x=x,y=y,lines=lines}
  w.h,w.w,w.delay=#lines*7+5,41,0
  for l in all(lines) do
    w.w=max(w.w,tlen(l)+7)
  end
  if (width) w.w=width
    add(windows,w)
  return w
end

function close_modal_top()
  if (modal_top.header) modal_top.header.life=1
  modal_top.life=1
  del(modal_stack,modal_top)
  modal_top=modal_stack[#modal_stack]
end

function update_windows()
if modal_top then
if modal_top.cursor then
if next_btn==2 then
  modal_top.cursor-=1
  s_time=0.25
  sfx"34"
elseif next_btn==3 then
  modal_top.cursor+=1
  s_time=0.25
  sfx"34"
elseif next_btn==5 then
  if modal_top.on_select then
    modal_top.on_select()
  end
end
if modal_top then
  modal_top.cursor=mid(1,modal_top.cursor,#modal_top.lines)
end
end
if next_btn==4 then
sfx"35"
if (modal_top.on_close) modal_top.on_close()
close_modal_top()
end
next_btn=-1
end
return modal_top==nil
end

function draw_windows()
for w in all(windows) do
if w.delay==0 then
local wx,wy,ww,wh=w.x,w.y,w.w,w.h
if w.on_close then
  spr(pl.win and 160 or 144,wx+ww/2-20,wy-10,5,1)
end
rectfill(wx,wy,wx+ww-1,wy+wh-1,1)
rect(wx,wy+1,wx+ww-1,wy+wh-1,2)
rect(wx,wy,wx+ww-1,wy+wh-2,9)
spr(118,wx,wy)
local twy=wy+3
local cx=w.cursor and 4 or 0
if (w.cursor) wx+=8
for i=1,#w.lines do
  local c=7
  if w.cursor==i then
    c=10
    spr(119,wx-5,twy)
  end
  local sx,tw,www=0,tlen(w.lines[i]),ww-4-cx*3
  if tw>www and w.cursor==i and w==modal_top then
    local diff=(www-tw)/2
    sx=diff+round(diff*sin(s_time))
    s_time+=0.008
  end
  clip(wx+cx,wy+3,ww-4-cx*3,wh-6)
  pr(w.lines[i],4+wx+sx,twy,c,2)
  clip()
  twy+=7
end
if w.hdr then
  local hdrs=explodeval"151,4,167,5,183,3"
  spr(hdrs[w.hdr],wx+3,wy-1,hdrs[w.hdr+1],1)
end
if w.hud then
  spr(149,7,118)
  pr(pl.hp.."/"..pl.hpmax,17,118,7)
  spr(165,44,118,2,1)
  pr(""..get_dmg(pl),58,118,7)
  spr(181,74,118,2,1)
  pr(pl.lvl.." ("..pl.xp.."/"..xp_req(pl.lvl+1)..")",86,118,7)
end
if w.life and w.delay==0 then
  if (w.cursor) w.cursor=999
  w.life-=1
  if w.life<0 then
    local diff=w.h/4
    w.y+=diff/2
    w.h-=diff
    if (w.h<8) del(windows,w)
  end
else
  if w.btn then
    pr("^close (c)",wx+ww-32-cx*2,wy+wh+1,12,5)
  end
end
else
w.delay-=1
end
end
end

function unequip_item(itm,skip_snd)
if (not itm) return true
if (itm.trait==2) then
sfx"42"
show_alert(itm.name.." is stuck!",nil,60)
return false
end
if (not skip_snd) sfx"39"
pl.hpmax-=itm.hpmax
itm.equipped,pl.weapon=nil,nil
return true
end

function discard_item(itm,skip_snd)
if itm.equipped then
if not unequip_item(itm) then
return
end
end
if (not skip_snd) sfx"41"
inventory.items-=1
for i=1,8 do
if inventory[i]==itm then
inventory[i]=nil
return
end
end
end

function on_item_select()
local itm,cmd,spend_turn=inventory[modal_stack[1].cursor],modal_top.lines[modal_top.cursor],false
if cmd=="discard" then
discard_item(itm)
elseif cmd=="use" then
use_item(pl,itm)
discard_item(itm,true)
spend_turn=true
elseif cmd=="equip" then
use_item(pl,itm)
elseif cmd=="unequip" then
unequip_item(itm)
end
close_modal_top()
modal_stack[1].lines=get_inventory_text()
if spend_turn then
close_modal_top()
phase+=1
move_anim(pl,0,0,0)
end
end

function on_inv_select()
local itm=inventory[modal_top.cursor]
if itm then
sfx"33"
add_modal(
modal_top.x+8,
modal_top.y+3+modal_top.cursor*6,{
"use",
"discard"
},
50)
if itm.type==1 then
modal_top.lines[1]=itm.equipped and "unequip" or "equip"
end
modal_top.on_select=on_item_select
modal_top.btn=nil
end
end

function show_inventory()
  sfx"36"
  add_modal(16,12,get_inventory_text(),96)
  modal_top.cursor,modal_top.on_select=1,on_inv_select
  modal_top.header=add_window(modal_top.x,
  modal_top.y-10,
  {"^b^a^c^k^p^a^c^k"})
end

function item_name(itm)
  local str="mysterious "..itm.name
  if itm.identified then
    str=i_trait[itm.trait]..itm.name..i_status[itm.status]
  end
  return str
end

function get_inventory_text()
  local lines={}
  for i=1,8 do
    local itm=inventory[i]
    if itm then
      local str=item_name(itm)
      if (itm.equipped) str="$ "..str.." "
        add(lines,str)
      else
        add(lines,"###")
      end
  end
  return lines
end

function bless_item(itm)
  itm.trait=3
  if (itm.heal>0) itm.heal+=1+flr(itm.heal*rnd(0.5))
  if (itm.hpmax>0) itm.hpmax+=1+flr(itm.hpmax*rnd(0.5))
  if (itm.atk>0) itm.atk+=1+flr(itm.atk*rnd(0.5))
end

function curse_item(itm)
  itm.trait=2
  itm.heal=0
  itm.hpmax=0
end

function enchant_item(itm)
  itm.status,itm.atk=intrnd(4)+2,flr(itm.atk*0.7)
end

item_count=0

function make_item(id,trait)
item_count+=1
local itm={
ic=item_count,
name=i_name[id],
spr=i_spr[id],
type=i_type[id],
atk=flr(i_atk[id]+rnd(0.2*i_atk[id])),
heal=i_heal[id],
hpmax=i_hpmax[id],
trait=1,
status=1,
identified=pl.depth<=2 and true or chance"0.2"
}
if not trait then
if chance"0.1" and pl.depth>=4 then
trait=3
elseif chance"0.4" and pl.depth>=2 then
trait=2
end
end
if trait==3 then
bless_item(itm)
elseif trait==2 then
curse_item(itm)
end
if pl.depth>3 and itm.type==1 and chance(trait==2 and 0.3 or 0.1) then
enchant_item(itm)
end
return itm
end

function use_item(e,itm)
if itm.type==0 then
floater_delay+=20
sleep=30
if itm.hpmax!=0 then
add_floater("&+"..itm.hpmax,e,11)
e.hpmax+=itm.hpmax
end
sfx(42+itm.trait)
if itm.trait==2 then
e.hit_by=itm
local r=rnd()
if r<0.2 then
  itm.heal=5
elseif r<0.4 then
  e.poisoned+=3
  show_alert("^b^l^e^h! ^poisonous!").delay=20
elseif r<0.6 then
  e.confused+=4
  show_alert("^feeling dizzy...").delay=20
elseif r<0.8 then
  e.paralyzed+=3
  show_alert("^g^l^u^p! ^can't move!").delay=20
else
  show_alert("^ouf... ^it's rotten!").delay=20
  itm.heal=-1
end
end
change_entity_hp(e,itm,itm.heal)
elseif itm.type==1 then
if unequip_item(e.weapon) then
e.weapon=itm
itm.equipped,itm.identified=true,true
sfx"40"
end
end
end

function get_free_slot()
for i=1,8 do
if (inventory[i]==nil) return i
end
return nil
end

function give_item(itm,hide_msg)
local slot=get_free_slot()
if slot then
if (not hide_msg) show_alert(item_name(itm),5)
inventory[slot]=itm
inventory.items+=1
end
return slot
end

function title_init()
reload()
t,story=0,"  ^to become immortal, the lich\n king ^raq'zul casts a powerful\n   spell. ^draining the world\n     of life and happiness.\n\n  ^brave souls descend into his\n     lair, but none return.\n\n  ^now it is your turn. ^defeat\n ^raq'zul, break the curse, and\n       end the suffering!"
music"0"
end

function title_update()
t+=1
if (t>768) t=0
if next_btn>=4 then
sfx"53"
fadeout()
swap_state(level_state)
end
next_btn=-1
end

function title_draw()
cls""
map(112,0)
spr(139,44,27,5,2)
clip(0,50,128,33)
pr(story,16,86-t/7,6,2)
clip()
fillp"0b0101101001011010.1"
rect(0,50,127,82,0)
fillp()
pr("(*) ^embark",46,104,12,5)
pr("^created by @^johan^peitz\n^audio by @^gruber_^music      v1.2",26,115,5,1)
end
title_state={
init=title_init,
update=title_update,
draw=title_draw
}
floor_weights=explodeval("0,0,0,1,2,2,3,3,3")

function generate_level(num_rooms)
rooms,dropped,removed,size={},0,0,num_rooms
mobs_placed,mobs_to_place=0,xp_req(pl.depth+1)-xp_req(pl.depth)
mobs_per_room=flr(0.5+mobs_to_place/size)-1
t_floor,t_wall,t_door_h,t_door_v=1,48,4,5
memset(0x2000,0,0xfff)
make_room("entry",5+intrnd"3",5+intrnd"3")
make_room"storage"
for i=#rooms,size-1 do
if chance"0.1" then
make_room"storage"
else
make_room"n/a"
end
end
size=#rooms
room_pool={}
add(room_pool, pl.depth<8 and "exit" or "boss")
for i=1,pl.depth/2 do
add(room_pool,"treasure")
end
if (pl.depth>=3) add(room_pool,"shrine")
if (pl.depth>=4) then
add(room_pool,"smithy")
add(room_pool,"pool")
end
while #rooms>0 or #room_pool>0 do
if #rooms==0 and #room_pool>0 then
make_room(room_pool[1])
del(room_pool, room_pool[1])
end
for r in all(rooms) do
if not place_room(r) then
  local dirs=explodeval"1,2,2,2,3,4"
  local rd=rnd_elem(dirs)
  r.x+=dirx[rd]
  r.y+=diry[rd]
  r.dir=rd
else
  del(rooms,r)
end
end
end
while mobs_placed<=mobs_to_place do
place_mob(intrnd"128",intrnd"32")
end
mobs_to_place=mobs_placed+pl.depth-3
while mobs_placed<=mobs_to_place do
place_mob(intrnd"128",intrnd"32",212)
end
auto_tile(48)
make_entities()
wall_fix()
end

function make_room(typ,w,h)
local r=add(rooms,{
x=12,
y=12,
w=5+intrnd(7),
h=5+intrnd(5),
oob=0,
dir=0,
typ=typ,
floor=0
})
r.floor=rnd_elem(floor_weights)
if w then
r.w,r.h=w,h
end
if typ=="boss" then
r.w,r.h=11,8
end
return r
end

function mset_flr(x,y,tile)
if is_floor(mget(x,y)) then
mset(x,y,tile)
return true
end
return false
end

function place_room(r)
local rx,ry,rw,rh=r.x,r.y,r.w,r.h
if ry<0 or ry+rh>31 or
rx<0 or rx+rw>127 then
r.oob+=1
if r.oob>5 then
add(room_pool,r.typ)
del(rooms,r)
dropped+=1
end
return false
end
r.oob=0
for tx=rx+1,rx+rw-2 do
for ty=ry+1,ry+rh-2 do
if mget(tx,ty)!=0 then
  return false
end
end
end
local bg={}
for tx=rx,rx+rw-1 do
bg[tx]={}
for ty=ry,ry+rh-1 do
bg[tx][ty]=mget(tx,ty)
end
end
for tx=rx,rx+rw-1 do
for ty=ry,ry+rh-1 do
local tile=t_floor
if r.floor>0 then
  tile=get_floor(28+4*r.floor)
end
if tx==rx or ty==ry or
tx==rx+rw-1 or
ty==ry+rh-1 then
  tile=t_wall
end
mset(tx,ty,tile)
end
end
if chance"0.4" then
for i=1,rnd(r.w/2) do
local x,y=get_rnd_pos(r)
local tle=27+2*intrnd"2"
if (chance"0.1") tle=11
mset_flr(x,y,tle)
end
end
if pl.depth>=m_depth[13] then
if chance"0.2" then
for i=1,1+rnd(r.w/2) do
  local x,y=get_rnd_pos(r)
  mset_flr(x,y,47)
end
end
end
rcx,rcy=rx+rw/2,ry+rh/2
if r.typ=="entry" then
rset"17"
mset(rcx-1,rcy-1,t_wall)
mset(rcx-1,rcy,t_wall)
elseif r.typ=="boss" then
place_piece(27,rx+2,ry+2)
place_piece(0,rx+6,ry+3)
rset"248"
elseif r.typ=="exit" then
rset"16"
elseif r.typ=="pool" then
rset"22"
elseif r.typ=="smithy" then
rset"24"
mset(rcx-1,rcy,23)
elseif r.typ=="shrine" then
rset"25"
mset(rcx+1,rcy,71)
elseif r.typ=="storage" then
for i=1,rnd(r.w) do
local x,y=get_rnd_pos(r)
mset(x,y,27+2*intrnd"2")
end
for i=1,r.w-2 do
if chance"0.5" then
  mset(rx+i,ry+1,15)
end
end
elseif r.typ=="treasure" then
for i=1,1+rnd(r.w) do
local x,y=get_rnd_pos(r)
mset(x,y,47)
end
rset"13"
elseif rw>=6 and rh>=6 then
local amnt=flr((rw-2)/5)
for ix=0,amnt-1 do
place_piece(2*pl.depth-2+intrnd"14",
rx+1+intrnd"2"+ix*4,
ry+2+intrnd(r.h-7))
end
end
local prev_mobs_placed=mobs_placed
if r.typ!="entry" then
for i=1,mobs_per_room do
local x,y=get_rnd_pos(r)
place_mob(x,y)
end
end
dc,doors=0,get_doors(rx+rw-1,ry,rx+rw-1,ry+rh-1)
door_helper()
doors=get_doors(rx,ry,rx,ry+rh-1)
door_helper()
doors=get_doors(rx,ry+rh-1,rx+rw-1,ry+rh-1)
door_helper()
doors=get_doors(rx,ry,rx+rw-1,ry)
door_helper()
if dc==0 and r.typ!="entry" then
for tx=rx,rx+rw-1 do
for ty=ry,ry+rh-1 do
  mset(tx,ty,bg[tx][ty])
end
end
add(room_pool,r.typ)
mobs_placed=prev_mobs_placed
removed+=1
return true
end
return true
end

function door_helper()
dc+=#doors
place_a_door(doors)
end

function rset(id)
mset(rcx,rcy,id)
end

function place_piece(p,tx,ty)
for x=0,2 do
for y=0,2 do
local op,np=sget(p*3+x,64+y)
if op==15 then
  np=t_wall
else
  np=op+63
end
if np!=t_wall and chance(pl.depth/10) then
  np+=16
end
if op>0 then
  mset(x+tx,y+ty,np)
end
end
end
end

function place_mob(x,y,id)
local mobs={}
for i=2,#m_depth do
if m_prop[i]==0 and m_depth[i]<=pl.depth then
add(mobs,m_anim[i])
end
end
if (not id) then
id=rnd_elem(mobs)
end
if mset_flr(x,y,id) then
mobs_placed+=1
end
end

function get_rnd_pos(r)
return r.x+1+rnd(r.w-2),r.y+1+rnd(r.h-2)
end

function get_floor(offset)
if (chance(0.2)) return t_floor
return offset+rnd_elem({0,1,2})
end

function place_a_door(doors)
local door=rnd_elem(doors)
if (not door) return
mset(door.x,door.y,chance(0.7) and door.tile or t_floor)
del(doors,door)
end

function get_doors(x1,y1,x2,y2)
local ds={}
local sx,sy,dist
if x1==x2 then
dist,sx,sy=y2-y1+1,0,1
else
dist,sx,sy=x2-x1+1,1,0
end
for i=1,dist do
local t1,t2=mget(x1+sy,y1+sx),mget(x1-sy,y1-sx)
if is_floor(t1) and is_floor(t2) then
add(ds,{x=x1,y=y1,tile=(sx==1 and t_door_h or t_door_v)})
end
x1+=sx
y1+=sy
end
return ds
end

function is_floor(id)
if (id==1 or id==2 or (id>=32 and id<=44)) return true
return false
end

function wall_fix()
for i=0,127 do
for j=0,31 do
local t1,t2=mget(i,j),mget(i,j+1)
if fget(t1,7) then
  if (t2==1) mset(i,j+1,2)
  for ii=32,40,4 do
    if (t2>=ii and t2<=ii+2) mset(i,j+1,ii+3)
  end
  if (t2==0) mset(i,j+1,3)
end
end
end
end

function auto_tile(st)
for i=0,127 do
for j=0,31 do
if mget(i,j) ==st then
  local nt,bm=0,explodeval"2,4,1,8"
  for d=1,4 do
    if (fget(mget(i+dirx[d],j+diry[d]),7)) nt+=bm[d]
  end
  mset(i,j,nt+st)
end
end
end
end
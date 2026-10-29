--[[
    ═══════════════════════════════════════════════════════════
    listwork's hub • MM2 script
    Автор: listwork • ТГК: @listwork1
    Версия: v1.1 • Багфикс: v7.5
    ═══════════════════════════════════════════════════════════
]]
print("[LWH] Автор: listwork • @listwork1 • BOOT v1.1 BF v7.5")
local P=game:GetService("Players") local UIS=game:GetService("UserInputService")
local W=game:GetService("Workspace") local L=game:GetService("Lighting")
local RS=game:GetService("RunService") local SG=game:GetService("StarterGui")
local lp=P.LocalPlayer if not lp then warn("[LWH] no LP") return end
local pg=lp:WaitForChild("PlayerGui",10) if not pg then warn("[LWH] no PG") return end
print("[LWH] pg ok")
pcall(function() SG:SetCore("SendNotification",{Title="listwork's hub",Text="v1.1 BF v7.5",Duration=5}) end)
for _,ch in ipairs(pg:GetChildren()) do if ch:IsA("ScreenGui") and (ch.Name:find("LWH") or ch.Name:find("listwork")) then pcall(function() ch:Destroy() end) end end

local function merge(d,s) local o={} for k,v in pairs(d) do o[k]=((s and s[k])~=nil) and s[k] or v end return o end
local S=merge({farm=false,aim=false,hitbox=false,killaura=false,autoknife=false,esp=true,roles=true,fullbright=false,noclip=false,infjump=false,walkspeed=false},getgenv().LWH_STATE)
local FC=merge({mode="coins",moveSpeed=30,range=100,autoReset=true},getgenv().LWH_FARM)
local CFG=merge({lang="RU",accentIdx=1,uiscale=1},getgenv().LWH_CFG)
getgenv().LWH_STATE=S getgenv().LWH_FARM=FC getgenv().LWH_CFG=CFG
local FSEL=getgenv().LWH_FLING_SEL or "none" local REST_NC={} local spawnPt=nil
pcall(function() if lp.Character then local h=lp.Character:FindFirstChild("HumanoidRootPart") if h then spawnPt=h.CFrame end end end)

local PAL={Color3.fromRGB(208,188,255),Color3.fromRGB(120,180,255),Color3.fromRGB(100,220,240),Color3.fromRGB(100,220,190),Color3.fromRGB(140,230,140),Color3.fromRGB(200,240,120),Color3.fromRGB(240,220,120),Color3.fromRGB(255,180,110),Color3.fromRGB(255,120,120),Color3.fromRGB(255,150,200),Color3.fromRGB(240,130,230),Color3.fromRGB(190,140,255)}
local BG=Color3.fromRGB(22,22,26) local SURF=Color3.fromRGB(32,32,38)
local SHI=Color3.fromRGB(48,48,56) local SHI2=Color3.fromRGB(62,62,72)
local TXT=Color3.fromRGB(235,235,240) local TXT2=Color3.fromRGB(175,175,185)
local F=Enum.Font.GothamMedium local FB=Enum.Font.GothamBold
local function GA() return PAL[CFG.accentIdx] or PAL[1] end

-- forward
local pl, plS, uiscale_el

local LANG={
 RU={farm="Автофарм",aim="Аимбот",hitbox="Хитбокс",killaura="KillAura",autoknife="Авто-нож",esp="ESP игроков",roles="Подсветка ролей",fullbright="Fullbright",noclip="Noclip",infjump="Беск. прыжок",speed="Скорость 35",fling="Fling",teleport="Телепорт",settings="Настройки",mode="РЕЖИМ СБОРА",mc="Монеты",mcandy="Конфеты",speedL="Скорость",range="Радиус",ars="Авто-ресет",on="ON",off="OFF",sel="ВЫБЕРИ ИГРОКА",none="никого",act="ДЕЙСТВИЯ",fa="Флингнуть",fall="Флингнуть ВСЕХ",tpn="TP к ближайшему",tpm="TP на карту",tpl="TP в лобби",lang="ЯЗЫК",acc="АКЦЕНТНЫЙ ЦВЕТ",about="О СКРИПТЕ",copy="copy @listwork1",auth="Автор: listwork",tg="ТГК: @listwork1",ncLock="Noclip (LOCKED)",uisz="Размер окна"},
 EN={farm="AutoFarm",aim="Aimbot",hitbox="Hitbox",killaura="KillAura",autoknife="AutoKnife",esp="ESP",roles="Role HL",fullbright="Fullbright",noclip="Noclip",infjump="InfJump",speed="Speed 35",fling="Fling",teleport="Teleport",settings="Settings",mode="COLLECT",mc="Coins",mcandy="Candy",speedL="Speed",range="Range",ars="Auto-reset",on="ON",off="OFF",sel="SELECT PLAYER",none="nobody",act="ACTIONS",fa="Fling",fall="Fling ALL",tpn="TP Nearest",tpm="TP to Map",tpl="TP to Lobby",lang="LANGUAGE",acc="ACCENT",about="ABOUT",copy="copy @listwork1",auth="Author: listwork",tg="TG: @listwork1",ncLock="Noclip (LOCKED)",uisz="Window size"}}
local function T(k) return (LANG[CFG.lang] or LANG.RU)[k] or k end

-- SPLASH
local sg=Instance.new("ScreenGui") sg.Name="LWH_Splash" sg.ResetOnSpawn=false sg.IgnoreGuiInset=true sg.DisplayOrder=200 sg.Parent=pg
local scrim=Instance.new("Frame",sg) scrim.Size=UDim2.new(1,0,1,0) scrim.BackgroundColor3=Color3.new() scrim.BackgroundTransparency=0.4
local sc=Instance.new("Frame",scrim) sc.Size=UDim2.new(0,260,0,200) sc.Position=UDim2.new(0.5,0,0.5,0) sc.AnchorPoint=Vector2.new(0.5,0.5) sc.BackgroundColor3=SURF sc.BorderSizePixel=0
Instance.new("UICorner",sc).CornerRadius=UDim.new(0,16)
local sl=Instance.new("Frame",sc) sl.Size=UDim2.new(0,52,0,52) sl.Position=UDim2.new(0.5,0,0,20) sl.AnchorPoint=Vector2.new(0.5,0) sl.BackgroundColor3=GA()
Instance.new("UICorner",sl).CornerRadius=UDim.new(1,0)
local slt=Instance.new("TextLabel",sl) slt.Size=UDim2.new(1,0,1,0) slt.BackgroundTransparency=1 slt.Text="L" slt.TextColor3=Color3.fromRGB(15,15,20) slt.Font=FB slt.TextSize=28
local st=Instance.new("TextLabel",sc) st.Size=UDim2.new(1,-20,0,20) st.Position=UDim2.new(0,10,0,82) st.BackgroundTransparency=1 st.Text="listwork's hub" st.TextColor3=GA() st.Font=FB st.TextSize=15
local sa=Instance.new("TextLabel",sc) sa.Size=UDim2.new(1,-20,0,14) sa.Position=UDim2.new(0,10,0,104) sa.BackgroundTransparency=1 sa.Text="Автор: listwork • @listwork1" sa.TextColor3=TXT2 sa.Font=F sa.TextSize=9
local str=Instance.new("Frame",sc) str.Size=UDim2.new(1,-40,0,5) str.Position=UDim2.new(0,20,0,128) str.BackgroundColor3=SHI2
Instance.new("UICorner",str).CornerRadius=UDim.new(1,0)
local sfl=Instance.new("Frame",str) sfl.Size=UDim2.new(0,0,1,0) sfl.BackgroundColor3=GA()
Instance.new("UICorner",sfl).CornerRadius=UDim.new(1,0)
local spc=Instance.new("TextLabel",sc) spc.Size=UDim2.new(1,-20,0,14) spc.Position=UDim2.new(0,10,0,138) spc.BackgroundTransparency=1 spc.Text="0%" spc.TextColor3=GA() spc.Font=FB spc.TextSize=10
local svr=Instance.new("TextLabel",sc) svr.Size=UDim2.new(1,-20,0,12) svr.Position=UDim2.new(0,10,0,168) svr.BackgroundTransparency=1 svr.Text="v1.1 • BF v7.5 • t.me/listwork1" svr.TextColor3=TXT2 svr.Font=F svr.TextSize=8
print("[LWH] splash ok")

-- MAIN GUI
local gui=Instance.new("ScreenGui") gui.Name="LWH_Main" gui.ResetOnSpawn=false gui.IgnoreGuiInset=true gui.DisplayOrder=100 gui.Parent=pg
local cam=W.CurrentCamera local cw=0 while not cam and cw<30 do task.wait(0.1); cam=W.CurrentCamera; cw=cw+1 end
local vp=cam and cam.ViewportSize or Vector2.new(800,600) if vp.X<200 then vp=Vector2.new(800,600) end
local PW=math.min(540,vp.X-40) local PH=math.min(460,vp.Y-120)
local LW=math.floor(PW*0.42) local RX=LW+14 local RW=PW-RX-10
print("[LWH] vp:",vp.X,vp.Y,"PW:",PW,"PH:",PH)

local pn=Instance.new("Frame",gui) pn.Size=UDim2.new(0,PW,0,PH) pn.Position=UDim2.new(0.5,0,0.5,0) pn.AnchorPoint=Vector2.new(0.5,0.5) pn.BackgroundColor3=BG pn.BorderSizePixel=0 pn.Visible=false pn.Active=true pn.ZIndex=50
Instance.new("UICorner",pn).CornerRadius=UDim.new(0,12)
local pSt=Instance.new("UIStroke",pn) pSt.Color=SHI2 pSt.Thickness=1
uiscale_el=Instance.new("UIScale",pn) uiscale_el.Scale=CFG.uiscale or 1

local tb=Instance.new("Frame",pn) tb.Size=UDim2.new(1,0,0,36) tb.BackgroundColor3=SURF tb.BorderSizePixel=0 tb.ZIndex=51
Instance.new("UICorner",tb).CornerRadius=UDim.new(0,12)
local tc=Instance.new("Frame",tb) tc.Size=UDim2.new(1,0,0,10) tc.Position=UDim2.new(0,0,1,-10) tc.BackgroundColor3=SURF tc.BorderSizePixel=0 tc.ZIndex=51
local dot=Instance.new("Frame",tb) dot.Size=UDim2.new(0,8,0,8) dot.Position=UDim2.new(0,12,0.5,-4) dot.BackgroundColor3=GA() dot.BorderSizePixel=0 dot.ZIndex=52
Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
local nlb=Instance.new("TextLabel",tb) nlb.Size=UDim2.new(0,120,1,0) nlb.Position=UDim2.new(0,26,0,0) nlb.BackgroundTransparency=1 nlb.Text="listwork's hub" nlb.TextColor3=TXT nlb.Font=FB nlb.TextSize=12 nlb.TextXAlignment=Enum.TextXAlignment.Left nlb.ZIndex=52
local vlb=Instance.new("TextLabel",tb) vlb.Size=UDim2.new(0,110,1,0) vlb.Position=UDim2.new(0,146,0,0) vlb.BackgroundTransparency=1 vlb.Text="v1.1 • BF v7.5" vlb.TextColor3=TXT vlb.TextTransparency=0.55 vlb.Font=F vlb.TextSize=9 vlb.TextXAlignment=Enum.TextXAlignment.Left vlb.ZIndex=52
local mb=Instance.new("TextButton",tb) mb.Size=UDim2.new(0,40,0,32) mb.Position=UDim2.new(1,-44,0,2) mb.BackgroundColor3=SHI mb.Text="_" mb.TextColor3=TXT mb.Font=FB mb.TextSize=18 mb.BorderSizePixel=0 mb.ZIndex=54
Instance.new("UICorner",mb).CornerRadius=UDim.new(0,6)

-- Resize handle (drag уголком правый-нижний)
local rh=Instance.new("TextButton",pn)
rh.Size=UDim2.new(0,24,0,24); rh.Position=UDim2.new(1,-28,1,-28)
rh.AnchorPoint=Vector2.new(1,1); rh.BackgroundColor3=GA(); rh.BackgroundTransparency=0.55
rh.Text="⤡"; rh.TextColor3=Color3.fromRGB(15,15,20); rh.TextSize=14; rh.Font=FB
rh.BorderSizePixel=0; rh.ZIndex=60
Instance.new("UICorner",rh).CornerRadius=UDim.new(0,8)

local lf=Instance.new("Frame",pn) lf.Size=UDim2.new(0,LW,1,-48) lf.Position=UDim2.new(0,8,0,44) lf.BackgroundColor3=SHI lf.BorderSizePixel=0 lf.ZIndex=51
Instance.new("UICorner",lf).CornerRadius=UDim.new(0,8)
local ls=Instance.new("ScrollingFrame",lf) ls.Size=UDim2.new(1,-8,1,-8) ls.Position=UDim2.new(0,4,0,4) ls.BackgroundTransparency=1 ls.BorderSizePixel=0 ls.CanvasSize=UDim2.new(0,0,0,0) ls.AutomaticCanvasSize=Enum.AutomaticSize.Y ls.ScrollBarThickness=3 ls.ScrollBarImageColor3=GA() ls.ZIndex=52
local ll=Instance.new("UIListLayout",ls) ll.Padding=UDim.new(0,3) ll.SortOrder=Enum.SortOrder.LayoutOrder

local rf=Instance.new("Frame",pn) rf.Size=UDim2.new(0,RW,1,-48) rf.Position=UDim2.new(0,RX,0,44) rf.BackgroundColor3=SURF rf.BorderSizePixel=0 rf.ZIndex=51
Instance.new("UICorner",rf).CornerRadius=UDim.new(0,8)
local rt=Instance.new("TextLabel",rf) rt.Size=UDim2.new(1,-16,0,28) rt.Position=UDim2.new(0,8,0,6) rt.BackgroundTransparency=1 rt.Text="" rt.TextColor3=GA() rt.Font=FB rt.TextSize=13 rt.TextXAlignment=Enum.TextXAlignment.Left rt.ZIndex=52
local rs=Instance.new("ScrollingFrame",rf) rs.Size=UDim2.new(1,-16,1,-42) rs.Position=UDim2.new(0,8,0,36) rs.BackgroundTransparency=1 rs.BorderSizePixel=0 rs.CanvasSize=UDim2.new(0,0,0,0) rs.AutomaticCanvasSize=Enum.AutomaticSize.Y rs.ScrollBarThickness=3 rs.ScrollBarImageColor3=GA() rs.ZIndex=52
local rl=Instance.new("UIListLayout",rs) rl.Padding=UDim.new(0,5) rl.SortOrder=Enum.SortOrder.LayoutOrder
print("[LWH] ui struct ok")

-- HELPERS
local sliders={}
local function bc(b,fn) local l=0 local function h() local n=os.clock() if n-l<0.2 then return end l=n pcall(fn) end pcall(function() b.Activated:Connect(h) end) pcall(function() b.MouseButton1Click:Connect(h) end) end
local function cr() for _,ch in ipairs(rs:GetChildren()) do if not ch:IsA("UIListLayout") then ch:Destroy() end end sliders={} end
local function addSec(t) local l=Instance.new("TextLabel",rs) l.Size=UDim2.new(1,0,0,14) l.BackgroundTransparency=1 l.Text="  "..t l.TextColor3=GA() l.TextXAlignment=Enum.TextXAlignment.Left l.Font=FB l.TextSize=9 l.ZIndex=53 end
local function addTog(t,g,s)
 local b=Instance.new("TextButton",rs) b.Text="" b.Size=UDim2.new(1,0,0,38) b.BorderSizePixel=0 b.AutoButtonColor=false b.ZIndex=53
 Instance.new("UICorner",b).CornerRadius=UDim.new(0,6) local sk=Instance.new("UIStroke",b) sk.Thickness=1
 local l=Instance.new("TextLabel",b) l.Size=UDim2.new(1,-60,1,0) l.Position=UDim2.new(0,12,0,0) l.BackgroundTransparency=1 l.Text=t l.TextXAlignment=Enum.TextXAlignment.Left l.Font=FB l.TextSize=12 l.ZIndex=54
 local bd=Instance.new("TextLabel",b) bd.Size=UDim2.new(0,44,0,20) bd.Position=UDim2.new(1,-52,0.5,-10) bd.Font=FB bd.TextSize=9 bd.BorderSizePixel=0 bd.ZIndex=54 Instance.new("UICorner",bd).CornerRadius=UDim.new(1,0)
 local function rf_() local on=g() b.BackgroundColor3=on and GA() or SHI sk.Color=on and GA() or SHI2 sk.Transparency=on and 0.4 or 0.9 l.TextColor3=on and Color3.fromRGB(15,15,20) or TXT bd.BackgroundColor3=on and Color3.fromRGB(15,15,20) or SHI2 bd.TextColor3=on and GA() or TXT2 bd.Text=on and T("on") or T("off") end
 rf_() bc(b,function() s(not g()) rf_() end)
end
local function addLocked()
 local b=Instance.new("TextButton",rs) b.Text="" b.Size=UDim2.new(1,0,0,38) b.BackgroundColor3=GA() b.BorderSizePixel=0 b.AutoButtonColor=false b.ZIndex=53
 Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
 local l=Instance.new("TextLabel",b) l.Size=UDim2.new(1,-70,1,0) l.Position=UDim2.new(0,12,0,0) l.BackgroundTransparency=1 l.Text=T("ncLock") l.TextXAlignment=Enum.TextXAlignment.Left l.TextColor3=Color3.fromRGB(15,15,20) l.Font=FB l.TextSize=12 l.ZIndex=54
 local bd=Instance.new("TextLabel",b) bd.Size=UDim2.new(0,54,0,20) bd.Position=UDim2.new(1,-62,0.5,-10) bd.BackgroundColor3=Color3.fromRGB(15,15,20) bd.TextColor3=GA() bd.Text="LOCK" bd.Font=FB bd.TextSize=9 bd.BorderSizePixel=0 bd.ZIndex=54 Instance.new("UICorner",bd).CornerRadius=UDim.new(1,0)
end
local function addSld(t,mn,mx,st,g,s,fmt)
 local b=Instance.new("Frame",rs) b.Size=UDim2.new(1,0,0,62) b.BackgroundColor3=SHI b.BorderSizePixel=0 b.ZIndex=53
 Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
 local l=Instance.new("TextLabel",b) l.Size=UDim2.new(1,-80,0,18) l.Position=UDim2.new(0,12,0,6) l.BackgroundTransparency=1 l.Text=t l.TextColor3=TXT l.TextXAlignment=Enum.TextXAlignment.Left l.Font=FB l.TextSize=11 l.ZIndex=54
 local vl=Instance.new("TextLabel",b) vl.Size=UDim2.new(0,70,0,18) vl.Position=UDim2.new(1,-82,0,6) vl.BackgroundTransparency=1 vl.Text=fmt(g()) vl.TextColor3=GA() vl.TextXAlignment=Enum.TextXAlignment.Right vl.Font=FB vl.TextSize=11 vl.ZIndex=54
 local tt=Instance.new("TextButton",b) tt.Size=UDim2.new(1,-24,0,26) tt.Position=UDim2.new(0,12,0,30) tt.BackgroundTransparency=1 tt.Text="" tt.AutoButtonColor=false tt.ZIndex=54
 local tbg=Instance.new("Frame",tt) tbg.Size=UDim2.new(1,0,0,4) tbg.Position=UDim2.new(0,0,0.5,-2) tbg.BackgroundColor3=SHI2 tbg.BorderSizePixel=0 tbg.ZIndex=54 Instance.new("UICorner",tbg).CornerRadius=UDim.new(1,0)
 local fl=Instance.new("Frame",tbg) fl.Size=UDim2.new(0,0,1,0) fl.BackgroundColor3=GA() fl.BorderSizePixel=0 fl.ZIndex=55 Instance.new("UICorner",fl).CornerRadius=UDim.new(1,0)
 local kn=Instance.new("Frame",tbg) kn.Size=UDim2.new(0,12,0,12) kn.AnchorPoint=Vector2.new(0.5,0.5) kn.Position=UDim2.new(0,0,0.5,0) kn.BackgroundColor3=GA() kn.BorderSizePixel=0 kn.ZIndex=56 Instance.new("UICorner",kn).CornerRadius=UDim.new(1,0)
 local function rf_() local c=g() local p=(c-mn)/(mx-mn) if p<0 then p=0 end if p>1 then p=1 end fl.Size=UDim2.new(p,0,1,0) kn.Position=UDim2.new(p,0,0.5,0) vl.Text=fmt(c) end
 rf_()
 local function sbx(x) local ap=tt.AbsolutePosition local sz=tt.AbsoluteSize if sz.X<5 then return end local p=(x-ap.X)/sz.X if p<0 then p=0 end if p>1 then p=1 end local r=mn+(mx-mn)*p local sn=math.floor(r/st+0.5)*st if sn<mn then sn=mn end if sn>mx then sn=mx end s(sn) rf_() end
 table.insert(sliders,{track=tt,setByX=sbx})
 local mi=Instance.new("TextButton",b) mi.Size=UDim2.new(0,22,0,22) mi.Position=UDim2.new(1,-54,0,32) mi.BackgroundColor3=SHI2 mi.Text="-" mi.TextColor3=TXT mi.Font=FB mi.TextSize=14 mi.BorderSizePixel=0 mi.ZIndex=56 Instance.new("UICorner",mi).CornerRadius=UDim.new(1,0)
 bc(mi,function() local c=g()-st if c<mn then c=mn end s(c) rf_() end)
 local pl2=Instance.new("TextButton",b) pl2.Size=UDim2.new(0,22,0,22) pl2.Position=UDim2.new(1,-26,0,32) pl2.BackgroundColor3=SHI2 pl2.Text="+" pl2.TextColor3=TXT pl2.Font=FB pl2.TextSize=14 pl2.BorderSizePixel=0 pl2.ZIndex=56 Instance.new("UICorner",pl2).CornerRadius=UDim.new(1,0)
 bc(pl2,function() local c=g()+st if c>mx then c=mx end s(c) rf_() end)
end
local function addAct(t,fn)
 local b=Instance.new("TextButton",rs) b.Text="" b.Size=UDim2.new(1,0,0,38) b.BackgroundColor3=SHI b.BorderSizePixel=0 b.AutoButtonColor=false b.ZIndex=53
 Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
 local l=Instance.new("TextLabel",b) l.Size=UDim2.new(1,-44,1,0) l.Position=UDim2.new(0,12,0,0) l.BackgroundTransparency=1 l.Text=t l.TextXAlignment=Enum.TextXAlignment.Left l.TextColor3=TXT l.Font=FB l.TextSize=12 l.ZIndex=54
 local ar=Instance.new("TextLabel",b) ar.Text="→" ar.Size=UDim2.new(0,30,1,0) ar.Position=UDim2.new(1,-34,0,0) ar.BackgroundTransparency=1 ar.TextColor3=GA() ar.Font=FB ar.TextSize=13 ar.ZIndex=54
 bc(b,fn)
end
UIS.InputBegan:Connect(function(i)
 if i.UserInputType~=Enum.UserInputType.Touch and i.UserInputType~=Enum.UserInputType.MouseButton1 then return end
 for _,s in ipairs(sliders) do if s.track and s.track.Parent then local ap=s.track.AbsolutePosition local sz=s.track.AbsoluteSize if sz.X>5 and sz.Y>5 then if i.Position.X>=ap.X and i.Position.X<=ap.X+sz.X and i.Position.Y>=ap.Y and i.Position.Y<=ap.Y+sz.Y then sliders._active=s s.setByX(i.Position.X) break end end end end
end)
UIS.InputChanged:Connect(function(i)
 if not sliders._active then return end
 if i.UserInputType~=Enum.UserInputType.Touch and i.UserInputType~=Enum.UserInputType.MouseMovement then return end
 sliders._active.setByX(i.Position.X)
end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then sliders._active=nil end end)
print("[LWH] helpers ok")

-- FLING
local function doFling(name)
 if name=="none" then return end
 local t=P:FindFirstChild(name) if not t or not t.Character then return end
 local h=t.Character:FindFirstChild("HumanoidRootPart") if not h then return end
 for _,pt in ipairs(t.Character:GetDescendants()) do if pt:IsA("BasePart") then pt.Anchored=false pt.CanCollide=false end end
 pcall(function() h.AssemblyLinearVelocity=Vector3.new(math.random(-800,800),1500,math.random(-800,800)) h.AssemblyAngularVelocity=Vector3.new(500,500,500) end)
 local sp
 pcall(function()
  sp=Instance.new("Part") sp.Size=Vector3.new(4,4,4) sp.Transparency=1 sp.CanCollide=false sp.CFrame=h.CFrame sp.Parent=W
  local w=Instance.new("WeldConstraint",sp) w.Part0=sp w.Part1=h
  local av=Instance.new("BodyAngularVelocity",sp) av.AngularVelocity=Vector3.new(99999,99999,99999) av.MaxTorque=Vector3.new(math.huge,math.huge,math.huge)
  local bv=Instance.new("BodyVelocity",sp) bv.Velocity=Vector3.new(math.random(-300,300),1200,math.random(-300,300)) bv.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
 end)
 print("[LWH] FLING:",name)
 task.delay(3,function() if sp then pcall(function() sp:Destroy() end) end end)
end

-- ROLES
local RC={murderer=Color3.fromRGB(255,60,60),sheriff=Color3.fromRGB(60,150,255),innocent=Color3.fromRGB(100,255,100),dead=Color3.fromRGB(255,255,255)}
local seen={}
local function alive(p) if not p or not p.Character then return false end local h=p.Character:FindFirstChildOfClass("Humanoid") return h and h.Health>0 end
local function upd(p) if not p or not p.Character then return end for _,t in ipairs(p.Character:GetDescendants()) do if t:IsA("Tool") then local n=t.Name:lower() if n:find("knife") then seen[p]="murderer" end if n:find("gun") then seen[p]="sheriff" end end end if p==lp then local bp=p:FindFirstChild("Backpack") if bp then for _,t in ipairs(bp:GetChildren()) do local n=t.Name:lower() if n:find("knife") then seen[p]="murderer" end if n:find("gun") then seen[p]="sheriff" end end end end end
local function dRole(p)
 if not p then return nil end
 if not alive(p) then return "dead" end
 local ok,r=pcall(function() return p:GetAttribute("Role") end)
 if ok and r then local l=string.lower(tostring(r)) if l:find("murder") then return "murderer" end if l:find("sheriff") then return "sheriff" end if l:find("innocent") then return "innocent" end end
 local ok2,tm=pcall(function() return p.Team end)
 if ok2 and tm then local tn=string.lower(tm.Name) if tn:find("murder") then return "murderer" end if tn:find("sheriff") then return "sheriff" end end
 for _,t in ipairs(p.Character:GetDescendants()) do if t:IsA("Tool") then local n=t.Name:lower() if n:find("knife") then return "murderer" end if n:find("gun") then return "sheriff" end end end
 if seen[p] then return seen[p] end
 return "innocent"
end
for _,p in ipairs(P:GetPlayers()) do p.CharacterAdded:Connect(function() seen[p]=nil end) end
P.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() seen[p]=nil end) end)

-- ESP
local espF=Instance.new("Folder",gui) espF.Name="LWH_ESP"
local hlc={}
local function sHL(c,r)
 if not c or not c.Parent then if hlc[c] then pcall(function() hlc[c]:Destroy() end) hlc[c]=nil end return end
 local col=RC[r] if not col or r=="dead" then if hlc[c] then pcall(function() hlc[c]:Destroy() end) hlc[c]=nil end return end
 if hlc[c] then pcall(function() hlc[c].FillColor=col hlc[c].OutlineColor=col end) return end
 local hl pcall(function() hl=Instance.new("Highlight") hl.Adornee=c hl.FillColor=col hl.FillTransparency=0.7 hl.OutlineColor=col hl.Parent=c end)
 if hl then hlc[c]=hl end
end
local function mkESP(c,name)
 if not c or espF:FindFirstChild(name) then return end
 local h=c:WaitForChild("Head",5) if not h then return end
 local bi=Instance.new("BillboardGui",espF) bi.Name=name bi.Adornee=h bi.Size=UDim2.new(0,180,0,40) bi.AlwaysOnTop=true bi.StudsOffset=Vector3.new(0,3,0)
 local n=Instance.new("TextLabel",bi) n.Text=name n.Size=UDim2.new(1,0,0.55,0) n.BackgroundTransparency=1 n.TextColor3=Color3.new(1,1,1) n.TextStrokeTransparency=0.2 n.Font=FB n.TextScaled=true
 local r=Instance.new("TextLabel",bi) r.Text="" r.Size=UDim2.new(1,0,0.45,0) r.Position=UDim2.new(0,0,0.55,0) r.BackgroundTransparency=1 r.TextColor3=Color3.new(1,1,1) r.TextStrokeTransparency=0.2 r.Font=FB r.TextScaled=true
 task.spawn(function()
  while bi.Parent do
   bi.Enabled=S.esp r.Visible=S.roles
   local hrp=lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
   if hrp and h.Parent then n.Text=name.." ["..math.floor((hrp.Position-h.Position).Magnitude).."m]" end
   if S.roles then
    local p2=P:FindFirstChild(name) upd(p2) local rk=dRole(p2)
    if rk=="dead" then r.Text="" pcall(sHL,c,nil)
    elseif rk=="murderer" then r.Text="Murderer" r.TextColor3=RC.murderer pcall(sHL,c,"murderer")
    elseif rk=="sheriff" then r.Text="Sheriff" r.TextColor3=RC.sheriff pcall(sHL,c,"sheriff")
    else r.Text="" r.TextColor3=RC.innocent pcall(sHL,c,"innocent") end
   else pcall(sHL,c,nil) end
   task.wait(0.2)
  end
  if bi then bi:Destroy() end
 end)
end
local function tk(p) if p==lp then return end if p.Character then mkESP(p.Character,p.Name) end p.CharacterAdded:Connect(function(c) task.wait(0.3) mkESP(c,p.Name) end) p.CharacterRemoving:Connect(function() local e=espF:FindFirstChild(p.Name) if e then e:Destroy() end end) end
for _,p in ipairs(P:GetPlayers()) do tk(p) end P.PlayerAdded:Connect(tk)
P.PlayerRemoving:Connect(function(p) local e=espF:FindFirstChild(p.Name) if e then e:Destroy() end end)
print("[LWH] esp ok")

-- PICKUP
local plist={} local pset={}
local function isPick(o)
 if not o then return false end
 if not (o:IsA("BasePart") or o:IsA("Model") or o:IsA("Tool")) then return false end
 local n=string.lower(o.Name) if #n<3 then return false end
 local c=n:find("coin") or n:find("money") or n:find("cash")
 local k=n:find("candy") or n:find("sweet") or n:find("treat") or n:find("chocolate") or n:find("lollipop") or n:find("halloween")
 if FC.mode=="coins" then return c end
 if FC.mode=="candy" then return k end
 return false
end
local function rebPick()
 plist={} pset={}
 for _,o in ipairs(W:GetDescendants()) do if isPick(o) and not pset[o] then pset[o]=true table.insert(plist,o) end end
 print("[LWH] pickup:",#plist)
end
task.spawn(rebPick)
W.DescendantAdded:Connect(function(o) if isPick(o) and not pset[o] then pset[o]=true table.insert(plist,o) end end)
W.DescendantRemoving:Connect(function(o) if pset[o] then pset[o]=nil local i=table.find(plist,o) if i then table.remove(plist,i) end end end)

-- CURRENCY
local function cc()
 local ls=lp:FindFirstChild("leaderstats")
 if ls then for _,st in ipairs(ls:GetChildren()) do if st:IsA("IntValue") or st:IsA("NumberValue") then local n=st.Name:lower() if n:find("coin") or n:find("money") or n:find("cash") or n:find("candy") or n:find("sweet") then return st.Value end end end end
 local bp=lp:FindFirstChild("Backpack") if not bp then return 0 end
 local c=0 for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then c=c+1 end end return c
end

-- FARM LOOP
local fBV=nil local tgt=nil
local function tick()
 if not S.farm then if fBV then pcall(function() fBV:Destroy() end) fBV=nil end tgt=nil local h=lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=16 end return end
 local ch=lp.Character local hrp=ch and ch:FindFirstChild("HumanoidRootPart") local hum=ch and ch:FindFirstChildOfClass("Humanoid")
 if not hrp or not hum then return end
 hum.WalkSpeed=0
 if FC.autoReset then local cur=cc() local th=(FC.mode=="candy") and 50 or 40 if cur>=th then if fBV then fBV.Velocity=Vector3.zero end hum.Health=0 tgt=nil print("[LWH] reset:",cur,"/",th) return end end
 if tgt and not tgt.Parent then tgt=nil end
 if not tgt then local pos=hrp.Position local md2=FC.range*FC.range local best,bd=nil,md2 for _,o in ipairs(plist) do if o.Parent then local t=o if o:IsA("Model") then t=o:FindFirstChildWhichIsA("BasePart") or o.PrimaryPart end if t and t.Position then local tp=t.Position local dx=tp.X-pos.X local dy=tp.Y-pos.Y local dz=tp.Z-pos.Z local d2=dx*dx+dy*dy+dz*dz if d2<bd then bd=d2 best=t end end end end tgt=best end
 if not tgt then return end
 local tp=tgt.Position local dx=tp.X-hrp.Position.X local dy=tp.Y-hrp.Position.Y local dz=tp.Z-hrp.Position.Z local d2=dx*dx+dy*dy+dz*dz
 if d2>12.25 then
  if not fBV or not fBV.Parent then fBV=Instance.new("BodyVelocity") fBV.MaxForce=Vector3.new(math.huge,math.huge,math.huge) fBV.P=50000 fBV.Parent=hrp end
  local d=math.sqrt(d2) if d>0.1 then fBV.Velocity=Vector3.new(dx/d,dy/d,dz/d)*FC.moveSpeed end
 else
  if fBV then fBV.Velocity=Vector3.zero end
  if type(firetouchinterest)=="function" then pcall(function() firetouchinterest(hrp,tgt,0) firetouchinterest(hrp,tgt,1) end) end
  tgt=nil
 end
end
task.spawn(function() while true do task.wait(0.03) pcall(tick) end end)

-- MODE ROW
local function addModes()
 local row=Instance.new("Frame",rs) row.Size=UDim2.new(1,0,0,34) row.BackgroundTransparency=1 row.ZIndex=53
 local opts={"coins","candy"} local lbls={coins=T("mc"),candy=T("mcandy")} local btns={}
 for i,o in ipairs(opts) do
  local b=Instance.new("TextButton",row) b.Text="" b.Size=UDim2.new(0.5,-4,1,0) b.Position=UDim2.new((i-1)/2,3,0,0) b.BorderSizePixel=0 b.AutoButtonColor=false b.ZIndex=54
  Instance.new("UICorner",b).CornerRadius=UDim.new(0,6) local sk=Instance.new("UIStroke",b) sk.Thickness=1
  local inl=Instance.new("TextLabel",b) inl.Size=UDim2.new(1,0,1,0) inl.BackgroundTransparency=1 inl.Text=lbls[o] inl.TextXAlignment=Enum.TextXAlignment.Center inl.Font=FB inl.TextSize=11 inl.ZIndex=55
  local function rf_() local on=FC.mode==o b.BackgroundColor3=on and GA() or SHI sk.Color=on and GA() or SHI2 sk.Transparency=on and 0.4 or 0.9 inl.TextColor3=on and Color3.fromRGB(15,15,20) or TXT2 end
  rf_() bc(b,function() FC.mode=o for _,r in pairs(btns) do pcall(r) end rebPick() end) table.insert(btns,rf_)
 end
end

-- ACCENTS (обновляет и pill цвет!)
local function addAcc()
 local grid=Instance.new("Frame",rs) grid.Size=UDim2.new(1,0,0,120) grid.BackgroundColor3=SHI grid.BorderSizePixel=0 grid.ZIndex=53
 Instance.new("UICorner",grid).CornerRadius=UDim.new(0,8)
 local BT=32 local PD=6 local RW=4*BT+3*PD local btns={}
 for i,ac in ipairs(PAL) do
  local col=(i-1)%4 local row=math.floor((i-1)/4)
  local b=Instance.new("TextButton",grid) b.Text="" b.Size=UDim2.new(0,BT,0,BT) b.AnchorPoint=Vector2.new(0.5,0)
  b.Position=UDim2.new(0.5,-RW/2+BT/2+col*(BT+PD),0,PD+row*(BT+PD)) b.BackgroundColor3=ac b.BorderSizePixel=0 b.AutoButtonColor=false b.ZIndex=54
  Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)
  local sk=Instance.new("UIStroke",b) sk.Thickness=2 sk.Color=ac
  local function rf_() local on=CFG.accentIdx==i sk.Color=on and Color3.fromRGB(255,255,255) or ac sk.Transparency=on and 0 or 1 end
  rf_() bc(b,function()
   CFG.accentIdx=i getgenv().LWH_CFG=CFG
   for _,r in pairs(btns) do pcall(r) end
   dot.BackgroundColor3=GA()
   sl.BackgroundColor3=GA()
   st.TextColor3=GA()
   sfl.BackgroundColor3=GA()
   spc.TextColor3=GA()
   rt.TextColor3=GA()
   if pl then pl.TextColor3=GA() end  -- ← цвет текста pill
   if plS then plS.Color=GA() end    -- ← обводка pill
   ls.ScrollBarImageColor3=GA()
   rs.ScrollBarImageColor3=GA()
   showF(cur)
  end)
  table.insert(btns,rf_)
 end
end

-- FUNC BTNS + showF
local funcs={} local cur="farm" local showF
showF=function(id)
 cur=id cr()
 local titles={farm=T("farm"),aim=T("aim"),hitbox=T("hitbox"),killaura=T("killaura"),autoknife=T("autoknife"),esp=T("esp"),roles=T("roles"),fullbright=T("fullbright"),noclip=T("noclip"),infjump=T("infjump"),speed=T("speed"),fling=T("fling"),teleport=T("teleport"),settings=T("settings")}
 rt.Text=titles[id] or id
 for fid,d in pairs(funcs) do local on=fid==id d.btn.BackgroundColor3=on and GA() or SURF d.lbl.TextColor3=on and Color3.fromRGB(15,15,20) or TXT2 d.sk.Color=on and GA() or SHI2 d.sk.Transparency=on and 0.4 or 1 end
 if id=="farm" then
  addTog(T("farm"),function() return S.farm end,function(v) S.farm=v if funcs.noclip then pcall(funcs.noclip.rf) end end)
  addSec(T("mode")) addModes() addSec("ПАРАМЕТРЫ")
  addSld(T("speedL"),8,60,1,function() return FC.moveSpeed end,function(v) FC.moveSpeed=v end,function(v) return v.." st/s" end)
  addSld(T("range"),20,250,5,function() return FC.range end,function(v) FC.range=v end,function(v) return v.." st" end)
  addSec("СБРОС") addTog(T("ars"),function() return FC.autoReset end,function(v) FC.autoReset=v end)
 elseif id=="teleport" then
  addSec("TELEPORT")
  addAct(T("tpn"),function() local hrp=lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") if not hrp then return end local best,bd=nil,math.huge for _,p in ipairs(P:GetPlayers()) do if p~=lp and p.Character then local th=p.Character:FindFirstChild("HumanoidRootPart") if th then local d=(hrp.Position-th.Position).Magnitude if d<bd then bd=d best=th end end end end if best then hrp.CFrame=best.CFrame*CFrame.new(0,0,3) end end)
  addAct(T("tpm"),function() local hrp=lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") if not hrp then return end local s,c=Vector3.zero,0 for _,p in ipairs(P:GetPlayers()) do if p~=lp and p.Character then local th=p.Character:FindFirstChild("HumanoidRootPart") if th then s=s+th.Position c=c+1 end end end if c>0 then hrp.CFrame=CFrame.new(s/c+Vector3.new(0,5,0)) end end)
  addAct(T("tpl"),function() local hrp=lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") if not hrp then return end for _,o in ipairs(W:GetDescendants()) do if o:IsA("SpawnLocation") then hrp.CFrame=CFrame.new(o.Position+Vector3.new(0,5,0)) return end end if spawnPt then hrp.CFrame=spawnPt end end)
 elseif id=="fling" then
  addSec(T("sel"))
  local lsc=Instance.new("ScrollingFrame",rs) lsc.Size=UDim2.new(1,0,0,200) lsc.BackgroundColor3=SHI lsc.BorderSizePixel=0 lsc.CanvasSize=UDim2.new(0,0,0,0) lsc.AutomaticCanvasSize=Enum.AutomaticSize.Y lsc.ScrollBarThickness=3 lsc.ScrollBarImageColor3=GA() lsc.ZIndex=53
  Instance.new("UICorner",lsc).CornerRadius=UDim.new(0,6)
  local ll2=Instance.new("UIListLayout",lsc) ll2.Padding=UDim.new(0,3) ll2.SortOrder=Enum.SortOrder.LayoutOrder
  local pd=Instance.new("UIPadding",lsc) pd.PaddingTop=UDim.new(0,3) pd.PaddingBottom=UDim.new(0,3) pd.PaddingLeft=UDim.new(0,3) pd.PaddingRight=UDim.new(0,3)
  local rf_ rf_=function()
   for _,ch in ipairs(lsc:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
   local nb=Instance.new("TextButton",lsc) nb.Text="  "..T("none") nb.Size=UDim2.new(1,-4,0,28) nb.BackgroundColor3=(FSEL=="none") and GA() or SURF nb.TextColor3=(FSEL=="none") and Color3.fromRGB(15,15,20) or TXT nb.TextXAlignment=Enum.TextXAlignment.Left nb.Font=FB nb.TextSize=11 nb.BorderSizePixel=0 nb.ZIndex=54 Instance.new("UICorner",nb).CornerRadius=UDim.new(0,4)
   bc(nb,function() FSEL="none" getgenv().LWH_FLING_SEL="none" rf_() end)
   for _,p in ipairs(P:GetPlayers()) do if p~=lp then
    local b=Instance.new("TextButton",lsc) b.Text="  "..p.Name b.Size=UDim2.new(1,-4,0,28) b.BackgroundColor3=(FSEL==p.Name) and GA() or SURF b.TextColor3=(FSEL==p.Name) and Color3.fromRGB(15,15,20) or TXT b.TextXAlignment=Enum.TextXAlignment.Left b.Font=FB b.TextSize=11 b.BorderSizePixel=0 b.ZIndex=54 Instance.new("UICorner",b).CornerRadius=UDim.new(0,4)
    bc(b,function() FSEL=p.Name getgenv().LWH_FLING_SEL=p.Name rf_() end)
   end end
  end rf_()
  addSec(T("act")) addAct(T("fa"),function() doFling(FSEL) end)
  addAct(T("fall"),function() for _,p in ipairs(P:GetPlayers()) do if p~=lp then pcall(doFling,p.Name) task.wait(0.15) end end end)
 elseif id=="settings" then
  addSec(T("acc")) addAcc()
  -- Resize slider
  addSec(T("uisz"))
  addSld(T("uisz"),50,150,5,
   function() return math.floor((uiscale_el.Scale or 1)*100) end,
   function(v) uiscale_el.Scale=v/100 CFG.uiscale=v/100 getgenv().LWH_CFG=CFG end,
   function(v) return v.."%" end)
  addSec(T("lang"))
  local lr=Instance.new("Frame",rs) lr.Size=UDim2.new(1,0,0,44) lr.BackgroundColor3=SHI lr.BorderSizePixel=0 lr.ZIndex=53
  Instance.new("UICorner",lr).CornerRadius=UDim.new(0,8)
  local lb={}
  for i,code in ipairs({"RU","EN"}) do
   local b=Instance.new("TextButton",lr) b.Text=code b.Size=UDim2.new(0.5,-6,1,-8) b.Position=UDim2.new((i-1)/2,3,0,4) b.BorderSizePixel=0 b.AutoButtonColor=false b.ZIndex=54 b.Font=FB b.TextSize=13
   Instance.new("UICorner",b).CornerRadius=UDim.new(0,6) local sk=Instance.new("UIStroke",b) sk.Thickness=1
   local function rf_() local on=CFG.lang==code b.BackgroundColor3=on and GA() or SURF b.TextColor3=on and Color3.fromRGB(15,15,20) or TXT2 sk.Color=on and GA() or SHI2 sk.Transparency=on and 0.4 or 0.9 end
   rf_() bc(b,function() CFG.lang=code getgenv().LWH_CFG=CFG for _,d in pairs(funcs) do if d.rft then pcall(d.rft) end end showF(cur) end) table.insert(lb,rf_)
  end
  addSec(T("about"))
  local ac=Instance.new("Frame",rs) ac.Size=UDim2.new(1,0,0,90) ac.BackgroundColor3=SHI ac.BorderSizePixel=0 ac.ZIndex=53
  Instance.new("UICorner",ac).CornerRadius=UDim.new(0,8)
  local a1=Instance.new("TextLabel",ac) a1.Size=UDim2.new(1,-20,0,20) a1.Position=UDim2.new(0,12,0,10) a1.BackgroundTransparency=1 a1.Text=T("auth") a1.TextColor3=GA() a1.TextXAlignment=Enum.TextXAlignment.Left a1.Font=FB a1.TextSize=14 a1.ZIndex=54
  local a2=Instance.new("TextLabel",ac) a2.Size=UDim2.new(1,-20,0,18) a2.Position=UDim2.new(0,12,0,32) a2.BackgroundTransparency=1 a2.Text=T("tg") a2.TextColor3=TXT a2.TextXAlignment=Enum.TextXAlignment.Left a2.Font=F a2.TextSize=12 a2.ZIndex=54
  local a3=Instance.new("TextLabel",ac) a3.Size=UDim2.new(1,-20,0,14) a3.Position=UDim2.new(0,12,0,54) a3.BackgroundTransparency=1 a3.Text="listwork's hub v1.1 • BF v7.5" a3.TextColor3=TXT2 a3.TextXAlignment=Enum.TextXAlignment.Left a3.Font=F a3.TextSize=9 a3.ZIndex=54
  local cp=Instance.new("TextButton",ac) cp.Size=UDim2.new(1,-24,0,24) cp.Position=UDim2.new(0,12,0,60) cp.BackgroundColor3=GA() cp.Text=T("copy") cp.TextColor3=Color3.fromRGB(15,15,20) cp.Font=FB cp.TextSize=10 cp.BorderSizePixel=0 cp.ZIndex=54 Instance.new("UICorner",cp).CornerRadius=UDim.new(0,6)
  bc(cp,function() if type(setclipboard)=="function" then pcall(setclipboard,"@listwork1") cp.Text="✔" task.wait(1) cp.Text=T("copy") end end)
 elseif id=="noclip" then
  if S.farm then addLocked() else addTog(T("noclip"),function() return S.noclip end,function(v) S.noclip=v end) end
 else addTog(titles[id] or id,function() return S[id] end,function(v) S[id]=v end) end
end

local function mkFB(id,isT)
 local b=Instance.new("TextButton",ls) b.Text="" b.Size=UDim2.new(1,0,0,34) b.BackgroundColor3=SURF b.BorderSizePixel=0 b.AutoButtonColor=false b.ZIndex=53
 Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
 local sk=Instance.new("UIStroke",b) sk.Color=SHI2 sk.Thickness=1
 local l=Instance.new("TextLabel",b) l.Size=UDim2.new(1,-40,1,0) l.Position=UDim2.new(0,10,0,0) l.BackgroundTransparency=1 l.Text="" l.TextColor3=TXT2 l.TextXAlignment=Enum.TextXAlignment.Left l.Font=FB l.TextSize=11 l.ZIndex=54
 local dt=Instance.new("Frame",b) dt.Size=UDim2.new(0,6,0,6) dt.Position=UDim2.new(1,-16,0.5,-3) dt.BorderSizePixel=0 dt.ZIndex=54 Instance.new("UICorner",dt).CornerRadius=UDim.new(1,0)
 local function rfdt() if isT then dt.Visible=true local on=S[id] if id=="noclip" and S.farm then on=true end dt.BackgroundColor3=on and GA() or SHI2 else dt.Visible=false end end
 local function rft() local ts={farm=T("farm"),aim=T("aim"),hitbox=T("hitbox"),killaura=T("killaura"),autoknife=T("autoknife"),esp=T("esp"),roles=T("roles"),fullbright=T("fullbright"),noclip=T("noclip"),infjump=T("infjump"),speed=T("speed"),fling=T("fling"),teleport=T("teleport"),settings=T("settings")} l.Text=ts[id] or id end
 rfdt() rft()
 funcs[id]={btn=b,lbl=l,sk=sk,rf=rfdt,rft=rft}
 bc(b,function() showF(id) end)
end
mkFB("farm",true) mkFB("aim",true) mkFB("hitbox",true) mkFB("killaura",true) mkFB("autoknife",true) mkFB("esp",true) mkFB("roles",true) mkFB("fullbright",true) mkFB("noclip",true) mkFB("infjump",true) mkFB("speed",true) mkFB("fling",false) mkFB("teleport",false) mkFB("settings",false)
print("[LWH] func btns ok")
showF("farm")

-- PILL (теперь pl и plS видны в addAcc)
pl=Instance.new("TextButton",gui) pl.Name="Pill" pl.Size=UDim2.new(0,180,0,44) pl.Position=UDim2.new(0.5,-90,0,16) pl.BackgroundColor3=SHI2 pl.Text="listwork's hub" pl.TextColor3=GA() pl.TextSize=13 pl.Font=FB pl.BorderSizePixel=0 pl.Visible=false pl.ZIndex=60 pl.AutoButtonColor=false
Instance.new("UICorner",pl).CornerRadius=UDim.new(1,0)
plS=Instance.new("UIStroke",pl) plS.Color=GA() plS.Thickness=2 plS.Transparency=0.3
local pld=false local pls=nil local plsp=nil
pl.InputBegan:Connect(function(i) if i.UserInputType~=Enum.UserInputType.Touch and i.UserInputType~=Enum.UserInputType.MouseButton1 then return end pld=true pls=i.Position plsp=pl.Position end)
UIS.InputChanged:Connect(function(i) if not pld or not pls or not plsp then return end if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement then local d=i.Position-pls pl.Position=UDim2.new(plsp.X.Scale,plsp.X.Offset+d.X,plsp.Y.Scale,plsp.Y.Offset+d.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then pld=false pls=nil plsp=nil end end)

local function setO(v) if v then pn.Position=UDim2.new(0.5,0,0.5,0) end pn.Visible=v pl.Visible=not v end
bc(mb,function() setO(false) end)
bc(pl,function() setO(true) end)

-- DRAG PANEL
local dg=false local ds=nil local dsp=nil
UIS.InputBegan:Connect(function(i)
 if i.UserInputType~=Enum.UserInputType.Touch and i.UserInputType~=Enum.UserInputType.MouseButton1 then return end
 if not pn.Visible then return end
 local pos=i.Position local tap=tb.AbsolutePosition local tsz=tb.AbsoluteSize
 if pos.X<tap.X or pos.X>tap.X+tsz.X or pos.Y<tap.Y or pos.Y>tap.Y+tsz.Y then return end
 local map=mb.AbsolutePosition local msz=mb.AbsoluteSize
 if pos.X>=map.X and pos.X<=map.X+msz.X and pos.Y>=map.Y and pos.Y<=map.Y+msz.Y then return end
 dg=true ds=pos dsp=pn.Position
end)
UIS.InputChanged:Connect(function(i) if not dg or not ds or not dsp then return end if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement then local d=i.Position-ds pn.Position=UDim2.new(dsp.X.Scale,dsp.X.Offset+d.X,dsp.Y.Scale,dsp.Y.Offset+d.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then dg=false ds=nil dsp=nil end end)
print("[LWH] drag+pill ok")

-- RESIZE через уголок
local rdrag=false local rstart=nil local rscaleStart=nil
rh.InputBegan:Connect(function(i)
 if i.UserInputType~=Enum.UserInputType.Touch and i.UserInputType~=Enum.UserInputType.MouseButton1 then return end
 rdrag=true rstart=i.Position rscaleStart=uiscale_el.Scale
end)
UIS.InputChanged:Connect(function(i)
 if not rdrag or not rstart then return end
 if i.UserInputType~=Enum.UserInputType.Touch and i.UserInputType~=Enum.UserInputType.MouseMovement then return end
 local d=i.Position-rstart
 local ns=rscaleStart+(d.X+d.Y)/400
 if ns<0.5 then ns=0.5 end
 if ns>1.5 then ns=1.5 end
 uiscale_el.Scale=ns CFG.uiscale=ns getgenv().LWH_CFG=CFG
end)
UIS.InputEnded:Connect(function(i)
 if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
  rdrag=false rstart=nil rscaleStart=nil
 end
end)
print("[LWH] resize ok")

-- LOGIC
local leA=0 local lJA=0
RS.Heartbeat:Connect(function()
 if S.hitbox then for _,p in ipairs(P:GetPlayers()) do if p~=lp and p.Character then local hrp=p.Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.Size=Vector3.new(12,12,12) hrp.Transparency=1 hrp.CanCollide=false end end end end
 if S.autoknife then local ch=lp.Character local hu=ch and ch:FindFirstChildOfClass("Humanoid") if hu then local eq=ch:FindFirstChild("Knife") if not eq and os.clock()-leA>1 then local bp=lp:FindFirstChild("Backpack") local k=bp and bp:FindFirstChild("Knife") if k then leA=os.clock() pcall(function() hu:EquipTool(k) end) end end end end
 if S.infjump then local hrp=lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") if hrp and (UIS:IsKeyDown(Enum.KeyCode.Space) or os.clock()-lJA<0.5) then pcall(function() hrp.AssemblyLinearVelocity=Vector3.new(hrp.AssemblyLinearVelocity.X,55,hrp.AssemblyLinearVelocity.Z) end) end end
end)
UIS.JumpRequest:Connect(function() if S.infjump then lJA=os.clock() end end)
RS.Stepped:Connect(function()
 local nc=S.noclip or S.farm
 if nc then local c=lp.Character if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then REST_NC[p]=true p.CanCollide=false end end end
 elseif next(REST_NC) then for p in pairs(REST_NC) do if p and p.Parent then pcall(function() p.CanCollide=true end) end end REST_NC={} end
end)
task.spawn(function() while true do task.wait(0.3) local h=lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") if S.walkspeed and h then h.WalkSpeed=35 end end end)
local fbP=false
task.spawn(function() while true do task.wait(0.2) if S.fullbright and not fbP then L.Ambient=Color3.fromRGB(180,180,180) L.OutdoorAmbient=Color3.fromRGB(180,180,180) L.Brightness=3 L.FogEnd=1e6 fbP=true elseif not S.fullbright and fbP then L.Ambient=Color3.fromRGB(70,70,70) L.OutdoorAmbient=Color3.fromRGB(128,128,128) L.Brightness=2 L.FogEnd=100000 fbP=false end end end)
print("[LWH] logic ok")

-- SPLASH RUN
task.spawn(function()
 local st2=os.clock() local dur=1.5
 while true do local t=math.min((os.clock()-st2)/dur,1) sfl.Size=UDim2.new(t,0,1,0) spc.Text=math.floor(t*100).."%" if t>=1 then break end task.wait(0.05) end
 spc.Text="100%" task.wait(0.3)
 pcall(function() sg:Destroy() end)
 setO(true)
 print("[LWH] splash done")
end)

getgenv().LWH={state=S,farmCfg=FC,cleanup=function() if gui then pcall(function() gui:Destroy() end) end if sg then pcall(function() sg:Destroy() end) end end}
print("[LWH] v1.1 BF v7.5 loaded OK")
print("[LWH] Автор: listwork • ТГК: @listwork1")

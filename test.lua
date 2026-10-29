--[[ listwork's hub • MM2 • t.me/listwork1 ]]
if not game:IsLoaded() then game.Loaded:Wait() end
local P=game:GetService("Players")
local RS=game:GetService("RunService")
local W=game:GetService("Workspace")
local UIS=game:GetService("UserInputService")
local VIM=game:GetService("VirtualInputManager")
local Li=game:GetService("Lighting")
local G=(getgenv and getgenv()) or _G
local VER="v1.2"
local LP=P.LocalPlayer
if not LP then repeat task.wait(0.1);LP=P.LocalPlayer until LP end
if G.LWH and G.LWH.cleanup then pcall(G.LWH.cleanup) end

local S=G.LWH_STATE or {farm=false,aim=false,esp=true,roles=true,pickup=true,hitbox=false,fullbright=false,noclip=false,infjump=false,walkspeed=false,killaura=false,autoknife=false}
G.LWH_STATE=S
local CFG=G.LWH_CFG or {lang="RU",accent=Color3.fromRGB(208,188,255)}
G.LWH_CFG=CFG
local REST=G.LWH_RESTORE or {hitbox={},noclip={},walkspeed=nil,fullbright=nil}
G.LWH_RESTORE=REST
local FC=G.LWH_FARM or {target="nearest",range=15,rate=0.1,autoEquip=true,onlyMurderer=false}
G.LWH_FARM=FC

local conns={}
local running=true
local function cx(s,f) local c=s:Connect(f) table.insert(conns,c) return c end
local function sf(f,...) local ok,r=pcall(f,...) return ok and r end

--═══════ i18n ═══════
local L={
 RU={combat="БОЙ",visual="ВИЗУАЛ",utils="УТИЛИТЫ",about="О СКРИПТЕ",
  farm="Автофарм",aim="Аимбот",hitbox="Хитбокс",killaura="KillAura",autoknife="Авто-нож",
  esp="ESP",roles="Роли",fullbright="Fullbright",pickup="Подбор",noclip="Noclip",
  infjump="InfJump",walkspeed="Speed",tp="TP",
  lang="Язык",accent="Акцент",author="Автор: listwork",tg="ТГК: @listwork1",
  on="ON",off="OFF",murderer="Убийца",sheriff="Шериф",innocent="Невинный",
  unknown="?",farmSettings="НАСТРОЙКИ ФАРМА",target="Цель",range="Дальность",
  rate="Темп",autoEquip="Автоэквип",onlyM="Только убийцы",
  nearest="Ближний",murder="Убийца",lowhp="Слабый",
  loading="Загрузка",done="Готово"},
 EN={combat="COMBAT",visual="VISUAL",utils="UTILITIES",about="ABOUT",
  farm="AutoFarm",aim="Aimbot",hitbox="Hitbox",killaura="KillAura",autoknife="AutoKnife",
  esp="ESP",roles="Roles",fullbright="Fullbright",pickup="Pickup",noclip="Noclip",
  infjump="InfJump",walkspeed="Speed",tp="TP",
  lang="Language",accent="Accent",author="Author: listwork",tg="TG: @listwork1",
  on="ON",off="OFF",murderer="Murderer",sheriff="Sheriff",innocent="Innocent",
  unknown="?",farmSettings="FARM SETTINGS",target="Target",range="Range",
  rate="Rate",autoEquip="AutoEquip",onlyM="Murderers only",
  nearest="Nearest",murder="Murderer",lowhp="Low HP",
  loading="Loading",done="Done"}
}
local function T(k) return (L[CFG.lang] or L.RU)[k] or k end

--═══════ M3 tokens ═══════
local M={surface=Color3.fromRGB(20,18,24),surfaceCont=Color3.fromRGB(30,27,34),
 surfaceHigh=Color3.fromRGB(40,36,45),primary=CFG.accent,
 primaryCont=CFG.accent:Lerp(Color3.new(),0.4),
 onSurface=Color3.fromRGB(230,224,236),onSurfaceVar=Color3.fromRGB(200,194,208),
 tertiary=Color3.fromRGB(255,200,220)}
local FONT=Enum.Font.GothamMedium
local FB=Enum.Font.GothamBold
local PAL={Color3.fromRGB(208,188,255),Color3.fromRGB(255,180,171),Color3.fromRGB(180,255,200),Color3.fromRGB(255,220,150),Color3.fromRGB(150,220,255),Color3.fromRGB(255,170,220),Color3.fromRGB(200,255,150),Color3.fromRGB(255,150,150),Color3.fromRGB(180,180,255),Color3.fromRGB(150,255,220),Color3.fromRGB(255,200,140),Color3.fromRGB(220,180,255),Color3.fromRGB(140,200,140),Color3.fromRGB(255,140,180),Color3.fromRGB(180,220,255),Color3.fromRGB(235,235,235)}

--═══════ role logic ═══════
local function myRole()
  local ok,r=pcall(function() return LP:GetAttribute("Role") end)
  if ok and r then
    local l=string.lower(tostring(r))
    if l:find("murder") then return "murderer" end
    if l:find("sheriff") then return "sheriff" end
    if l:find("innocent") then return "innocent" end
  end
  for _,src in ipairs{LP.Character,LP:FindFirstChild("Backpack")} do
    if src then
      for _,t in ipairs(src:GetChildren()) do
        local n=t.Name:lower()
        if n:find("knife") then return "murderer" end
        if n:find("gun") then return "sheriff" end
      end
    end
  end
  return nil
end
local rCache={t=0,v=nil}
local function myRoleC()
  if os.clock()-rCache.t<1 then return rCache.v end
  rCache.v=myRole(); rCache.t=os.clock(); return rCache.v
end
local function pRole(p)
  if not p then return nil end
  if p==LP then return myRoleC() end
  local c=p.Character
  if c then
    for _,t in ipairs(c:GetChildren()) do
      if t:IsA("Tool") then
        local n=t.Name:lower()
        if n:find("knife") then return "murderer" end
        if n:find("gun") then return "sheriff" end
      end
    end
  end
  return nil
end
local function rTag(p)
  local k=pRole(p)
  if k=="murderer" then return T("murderer") end
  if k=="sheriff" then return T("sheriff") end
  if k=="innocent" then return T("innocent") end
  return nil
end
local function canAtk(head)
  if not head or not head.Parent then return false end
  local mr=myRoleC()
  if mr=="murderer" then return true end
  if mr=="sheriff" then
    for _,p in ipairs(P:GetPlayers()) do
      if p~=LP and p.Character==head.Parent then return pRole(p)=="murderer" end
    end
  end
  return false
end

--═══════ cleanup ═══════
pcall(function()
  local cg=game:GetService("CoreGui")
  if cg then for _,n in ipairs{"ListworksHub","LWH_ESP","LWH_Splash"} do local x=cg:FindFirstChild(n) if x then x:Destroy() end end end
end)
if LP then
  local pg=LP:FindFirstChild("PlayerGui")
  if pg then for _,n in ipairs{"ListworksHub","LWH_ESP","LWH_Splash"} do local x=pg:FindFirstChild(n) if x then x:Destroy() end end end
end

--═══════ SPLASH ═══════
local sp=Instance.new("ScreenGui")
sp.Name="LWH_Splash"; sp.ResetOnSpawn=false; sp.IgnoreGuiInset=true; sp.DisplayOrder=999
pcall(function() sp.Parent=game:GetService("CoreGui") end)
if not sp.Parent then sp.Parent=LP:WaitForChild("PlayerGui") end

local sc=Instance.new("Frame",sp)
sc.Size=UDim2.new(1,0,1,0); sc.BackgroundColor3=Color3.new(); sc.BackgroundTransparency=1; sc.BorderSizePixel=0

local cd=Instance.new("Frame",sc)
cd.Size=UDim2.new(0,280,0,300); cd.Position=UDim2.new(0.5,0,0.5,0); cd.AnchorPoint=Vector2.new(0.5,0.5)
cd.BackgroundColor3=M.surfaceCont; cd.BackgroundTransparency=1; cd.BorderSizePixel=0
Instance.new("UICorner",cd).CornerRadius=UDim.new(0,28)
local cs=Instance.new("UIStroke",cd); cs.Color=M.surfaceHigh; cs.Thickness=1; cs.Transparency=1
local cSc=Instance.new("UIScale",cd); cSc.Scale=0.85

local lg=Instance.new("Frame",cd)
lg.Size=UDim2.new(0,72,0,72); lg.Position=UDim2.new(0.5,0,0,36); lg.AnchorPoint=Vector2.new(0.5,0)
lg.BackgroundColor3=CFG.accent; lg.BackgroundTransparency=1; lg.BorderSizePixel=0
Instance.new("UICorner",lg).CornerRadius=UDim.new(1,0)
local lgT=Instance.new("TextLabel",lg)
lgT.Size=UDim2.new(1,0,1,0); lgT.BackgroundTransparency=1; lgT.Text="L"
lgT.TextColor3=Color3.fromRGB(30,20,40); lgT.TextTransparency=1
lgT.Font=FB; lgT.TextSize=38

local tl=Instance.new("TextLabel",cd)
tl.Size=UDim2.new(1,-32,0,28); tl.Position=UDim2.new(0,16,0,124); tl.BackgroundTransparency=1
tl.Text="listwork's hub"; tl.TextColor3=CFG.accent; tl.TextTransparency=1
tl.Font=FB; tl.TextSize=20

local sl=Instance.new("TextLabel",cd)
sl.Size=UDim2.new(1,-32,0,18); sl.Position=UDim2.new(0,16,0,154); sl.BackgroundTransparency=1
sl.Text="MM2 • Material You"; sl.TextColor3=M.onSurfaceVar; sl.TextTransparency=1
sl.Font=FONT; sl.TextSize=12

local tr=Instance.new("Frame",cd)
tr.Size=UDim2.new(1,-64,0,6); tr.Position=UDim2.new(0,32,0,194)
tr.BackgroundColor3=M.surfaceHigh; tr.BackgroundTransparency=1; tr.BorderSizePixel=0
Instance.new("UICorner",tr).CornerRadius=UDim.new(1,0)
local fl=Instance.new("Frame",tr)
fl.Size=UDim2.new(0,0,1,0); fl.BackgroundColor3=CFG.accent; fl.BackgroundTransparency=1; fl.BorderSizePixel=0
Instance.new("UICorner",fl).CornerRadius=UDim.new(1,0)

local st=Instance.new("TextLabel",cd)
st.Size=UDim2.new(1,-32,0,18); st.Position=UDim2.new(0,16,0,208); st.BackgroundTransparency=1
st.Text=T("loading").."..."; st.TextColor3=M.onSurface; st.TextTransparency=1
st.Font=FB; st.TextSize=12

local pt=Instance.new("TextLabel",cd)
pt.Size=UDim2.new(1,-32,0,16); pt.Position=UDim2.new(0,16,0,228); pt.BackgroundTransparency=1
pt.Text="0%"; pt.TextColor3=CFG.accent; pt.TextTransparency=1
pt.Font=FB; pt.TextSize=11

local vl=Instance.new("TextLabel",cd)
vl.Size=UDim2.new(1,-32,0,16); vl.Position=UDim2.new(0,16,0,250); vl.BackgroundTransparency=1
vl.Text=VER.." • @listwork1"; vl.TextColor3=M.onSurfaceVar; vl.TextTransparency=1
vl.Font=FONT; vl.TextSize=10

local function fadeIn()
  for _,o in ipairs{{sc,"BackgroundTransparency",0.4},{cd,"BackgroundTransparency",0},{cs,"Transparency",0},{lg,"BackgroundTransparency",0},{tr,"BackgroundTransparency",0},{fl,"BackgroundTransparency",0}} do
    game:GetService("TweenService"):Create(o[1],TweenInfo.new(0.3),{[o[2]]=o[3]}):Play()
  end
  game:GetService("TweenService"):Create(cSc,TweenInfo.new(0.4,Enum.EasingStyle.Back),{Scale=1}):Play()
  task.wait(0.15)
  for _,o in ipairs{{lgT,"TextTransparency",0},{tl,"TextTransparency",0},{sl,"TextTransparency",0},{st,"TextTransparency",0},{pt,"TextTransparency",0},{vl,"TextTransparency",0.45}} do
    game:GetService("TweenService"):Create(o[1],TweenInfo.new(0.3),{[o[2]]=o[3]}):Play()
  end
end
local function fadeOut()
  for _,o in ipairs{sc,cd,lg,tr,fl} do
    game:GetService("TweenService"):Create(o,TweenInfo.new(0.35),{BackgroundTransparency=1}):Play()
  end
  game:GetService("TweenService"):Create(cs,TweenInfo.new(0.35),{Transparency=1}):Play()
  for _,t in ipairs{lgT,tl,sl,st,pt,vl} do
    game:GetService("TweenService"):Create(t,TweenInfo.new(0.3),{TextTransparency=1}):Play()
  end
  game:GetService("TweenService"):Create(cSc,TweenInfo.new(0.4),{Scale=0.9}):Play()
  task.wait(0.45)
  if sp then pcall(function() sp:Destroy() end) end
end

--═══════ GUI ROOT ═══════
local gui=Instance.new("ScreenGui")
gui.Name="ListworksHub"; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true
pcall(function() gui.Parent=game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent=LP:WaitForChild("PlayerGui") end
local uiS=Instance.new("UIScale",gui)
local function adapt()
  local c=W.CurrentCamera; if not c then return end
  local m=math.min(c.ViewportSize.X,c.ViewportSize.Y)
  uiS.Scale=m<500 and 0.75 or (m<800 and 0.9 or 1)
end
adapt()
cx(W.CurrentCamera:GetPropertyChangedSignal("ViewportSize"),adapt)

--═══════ helpers ═══════
local lastClick=0
local lastEquip=0
local lastJump=0
local hasTouch=type(firetouchinterest)=="function"
local hasCb=type(setclipboard)=="function"
local pc={}

local function nearest()
  local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
  if not hrp then return nil end
  local best,bd,bh=nil,math.huge,math.huge
  for _,p in ipairs(P:GetPlayers()) do
    if p~=LP and p.Character then
      local h=p.Character:FindFirstChild("Head")
      local hu=p.Character:FindFirstChildOfClass("Humanoid")
      if h and hu and hu.Health>0 then
        local d=(hrp.Position-h.Position).Magnitude
        if d<=FC.range then
          local isM=pRole(p)=="murderer"
          if not (FC.onlyMurderer and not isM) then
            if FC.target=="lowhp" and hu.Health<bh then bh,b,bd=hu.Health,h,d
            elseif FC.target=="murderer" and isM and d<bd then bd,b=d,h
            elseif FC.target=="nearest" and d<bd then bd,b=d,h end
          end
        end
      end
    end
  end
  return b
end

local function fire(head)
  if not head or not canAtk(head) then return end
  if os.clock()-lastClick<FC.rate then return end
  local ch=LP.Character; if not ch then return end
  local tool=ch:FindFirstChildOfClass("Tool")
  if not tool then
    if FC.autoEquip and os.clock()-lastEquip>1 then
      local bp=LP:FindFirstChild("Backpack")
      local hu=ch:FindFirstChildOfClass("Humanoid")
      if bp and hu then
        local k=bp:FindFirstChild("Knife") or bp:FindFirstChild("Gun")
        if k then lastEquip=os.clock(); sf(function() hu:EquipTool(k) end) end
      end
    end
    return
  end
  local n=tool.Name:lower()
  if not (n:find("knife") or n:find("gun")) then return end
  lastClick=os.clock()
  local ok=sf(function()
    local m=LP:GetMouse()
    VIM:SendMouseButtonEvent(m.X,m.Y,0,true,game,1)
    VIM:SendMouseButtonEvent(m.X,m.Y,0,false,game,1)
  end)
  if not ok and type(mouse1click)=="function" then sf(mouse1click) end
end

local function tpN()
  local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
  if not hrp then return end
  local b,bd=nil,math.huge
  for _,p in ipairs(P:GetPlayers()) do
    if p~=LP and p.Character then
      local th=p.Character:FindFirstChild("HumanoidRootPart")
      if th then local d=(hrp.Position-th.Position).Magnitude; if d<bd then bd,b=d,th end end
    end
  end
  if b then hrp.CFrame=b.CFrame*CFrame.new(0,0,3) end
end

local function setFB(v)
  if v and not REST.fullbright then
    REST.fullbright={Ambient=Li.Ambient,OutdoorAmbient=Li.OutdoorAmbient,Brightness=Li.Brightness,FogEnd=Li.FogEnd}
    Li.Ambient=Color3.fromRGB(180,180,180); Li.OutdoorAmbient=Color3.fromRGB(180,180,180)
    Li.Brightness=3; Li.FogEnd=1e6
  elseif not v and REST.fullbright then
    for k,val in pairs(REST.fullbright) do pcall(function() Li[k]=val end) end
    REST.fullbright=nil
  end
end

--═══════ ESP ═══════
local espF=Instance.new("Folder")
espF.Name="LWH_ESP"
pcall(function() espF.Parent=game:GetService("CoreGui") end)
if not espF.Parent then espF.Parent=LP:WaitForChild("PlayerGui") end

local accFns={}
local function onAcc(f) table.insert(accFns,f) end

local function mkEsp(ch,nm)
  if not ch or espF:FindFirstChild(nm) then return end
  local h=ch:WaitForChild("Head",5); if not h then return end
  local bi=Instance.new("BillboardGui",espF)
  bi.Name=nm; bi.Adornee=h; bi.AlwaysOnTop=true
  bi.Size=UDim2.new(0,200,0,44); bi.StudsOffset=Vector3.new(0,2.6,0)
  local n=Instance.new("TextLabel",bi)
  n.Size=UDim2.new(1,0,0.55,0); n.BackgroundTransparency=1
  n.TextColor3=Color3.fromRGB(255,100,100); n.TextStrokeTransparency=0.2
  n.Text=nm; n.Font=FB; n.TextScaled=true
  local r=Instance.new("TextLabel",bi)
  r.Size=UDim2.new(1,0,0.45,0); r.Position=UDim2.new(0,0,0.55,0)
  r.BackgroundTransparency=1; r.TextColor3=M.primary; r.TextStrokeTransparency=0.2
  r.Font=FONT; r.TextScaled=true
  onAcc(function(c) if r.Parent then r.TextColor3=c end end)
  task.spawn(function()
    while running and bi.Parent do
      bi.Enabled=S.esp; r.Visible=S.roles
      local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
      if hrp and h.Parent then
        n.Text=nm.." ["..math.floor((hrp.Position-h.Position).Magnitude).."m]"
        r.Text=rTag(P:FindFirstChild(nm)) or ""
      end
      task.wait(0.4)
    end
    if bi then bi:Destroy() end
  end)
end

local function track(p)
  if p==LP then return end
  if p.Character then mkEsp(p.Character,p.Name) end
  cx(p.CharacterAdded,function(c) task.wait(0.5); mkEsp(c,p.Name) end)
  cx(p.CharacterRemoving,function()
    local e=espF:FindFirstChild(p.Name); if e then e:Destroy() end
    REST.hitbox[p]=nil
  end)
end
for _,p in ipairs(P:GetPlayers()) do track(p) end
cx(P.PlayerAdded,track)
cx(P.PlayerRemoving,function(p)
  local e=espF:FindFirstChild(p.Name); if e then e:Destroy() end
  REST.hitbox[p]=nil
end)

--═══════ pickup ═══════
local function pickable(o)
  if not o then return false end
  if not (o:IsA("BasePart") or o:IsA("Model")) then return false end
  if o:IsA("BasePart") and o.Parent and o.Parent:IsA("Model") then
    local pn=string.lower(o.Parent.Name)
    if pn:find("coin") or pn:find("gun") or pn:find("knife") or pn:find("money") then return false end
  end
  local n=o.Name; if #n<3 then return false end
  local f=string.lower(string.sub(n,1,1))
  if not (f=="c" or f=="g" or f=="k" or f=="i" or f=="m") then return false end
  local l=string.lower(n)
  return l:find("coin") or l:find("gun") or l:find("knife") or l:find("item") or l:find("money")
end
task.spawn(function()
  for _,o in ipairs(W:GetDescendants()) do if pickable(o) then table.insert(pc,o) end end
end)
cx(W.DescendantAdded,function(o) if pickable(o) then table.insert(pc,o) end end)
cx(W.DescendantRemoving,function(o)
  local i=table.find(pc,o); if i then table.remove(pc,i) end
end)

--═══════ MAIN LOOPS ═══════
cx(RS.Heartbeat,function()
  -- Hitbox
  if S.hitbox then
    for _,p in ipairs(P:GetPlayers()) do
      if p~=LP and p.Character then
        local hrp=p.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
          REST.hitbox[p]=REST.hitbox[p] or hrp.Size
          hrp.Size=Vector3.new(12,12,12); hrp.Transparency=1; hrp.CanCollide=false
        end
      end
    end
  elseif next(REST.hitbox) then
    for p,sz in pairs(REST.hitbox) do
      local hrp=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
      if hrp then hrp.Size=sz; hrp.Transparency=0; hrp.CanCollide=true end
    end
    for k in pairs(REST.hitbox) do REST.hitbox[k]=nil end
  end
  -- AutoKnife
  if S.autoknife then
    local ch=LP.Character
    local hu=ch and ch:FindFirstChildOfClass("Humanoid")
    if hu then
      local eq=ch:FindFirstChild("Knife")
      if not eq and os.clock()-lastEquip>1 then
        local bp=LP:FindFirstChild("Backpack")
        local k=bp and bp:FindFirstChild("Knife")
        if k then lastEquip=os.clock(); sf(function() hu:EquipTool(k) end) end
      end
      local hrp=ch:FindFirstChild("HumanoidRootPart")
      if hrp and eq then
        for _,p in ipairs(P:GetPlayers()) do
          if p~=LP and p.Character then
            local th=p.Character:FindFirstChild("HumanoidRootPart")
            if th and (hrp.Position-th.Position).Magnitude<6 then
              fire(p.Character:FindFirstChild("Head")); break
            end
          end
        end
      end
    end
  end
  -- InfJump
  if S.infjump then
    local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if hrp and (UIS:IsKeyDown(Enum.KeyCode.Space) or os.clock()-lastJump<0.5) then
      sf(function() hrp.AssemblyLinearVelocity=Vector3.new(hrp.AssemblyLinearVelocity.X,55,hrp.AssemblyLinearVelocity.Z) end)
    end
  end
  -- KillAura
  if S.killaura then
    local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
      for _,p in ipairs(P:GetPlayers()) do
        if p~=LP and p.Character then
          local th=p.Character:FindFirstChild("HumanoidRootPart")
          if th and (hrp.Position-th.Position).Magnitude<10 then
            fire(p.Character:FindFirstChild("Head")); break
          end
        end
      end
    end
  end
end)

RS:BindToRenderStep("LWH_Aim",Enum.RenderPriority.Camera.Value+1,function()
  if S.aim then
    local t=nearest()
    if t then
      local c=W.CurrentCamera
      if c then c.CFrame=CFrame.new(c.CFrame.Position,t.Position) end
    end
  end
end)

task.spawn(function()
  while running do
    if S.farm then local t=nearest(); if t then fire(t) end end
    task.wait(0.05)
  end
end)

cx(RS.Stepped,function()
  if S.noclip then
    local c=LP.Character
    if c then
      for _,p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide then
          REST.noclip[p]=true; p.CanCollide=false
        end
      end
    end
  elseif next(REST.noclip) then
    for p in pairs(REST.noclip) do
      if p and p.Parent then sf(function() p.CanCollide=true end) end
    end
    for k in pairs(REST.noclip) do REST.noclip[k]=nil end
  end
end)

cx(UIS.JumpRequest,function() if S.infjump then lastJump=os.clock() end end)

task.spawn(function()
  while running do
    task.wait(0.5)
    if S.pickup and hasTouch then
      local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
      if hrp then
        for _,o in ipairs(pc) do
          if o.Parent then
            local t=o:IsA("Model") and o:FindFirstChildWhichIsA("BasePart") or o
            if t and (hrp.Position-t.Position).Magnitude<35 then
              sf(function() firetouchinterest(hrp,t,0); firetouchinterest(hrp,t,1) end)
            end
          end
        end
      end
    end
  end
end)

task.spawn(function()
  while running do
    task.wait(0.3)
    local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if S.walkspeed then
      if h then
        if REST.walkspeed==nil then REST.walkspeed=h.WalkSpeed end
        h.WalkSpeed=35
      end
    elseif REST.walkspeed~=nil then
      if h then h.WalkSpeed=REST.walkspeed end
      REST.walkspeed=nil
    end
  end
end)

--═══════ UI ═══════
local function bind(btn,fn)
  local last=0
  local function h()
    local n=os.clock(); if n-last<0.08 then return end
    last=n; sf(fn)
  end
  cx(btn.MouseButton1Click,h)
  sf(function() cx(btn.TouchTap,h) end)
end

local fab=Instance.new("TextButton",gui)
fab.Size=UDim2.new(0,54,0,54); fab.Position=UDim2.new(0,16,0.5,-27)
fab.AnchorPoint=Vector2.new(0,0.5); fab.BackgroundColor3=M.primaryCont
fab.Text="≡"; fab.TextColor3=M.onSurface; fab.TextSize=22
fab.Font=FB; fab.AutoButtonColor=false; fab.BorderSizePixel=0
Instance.new("UICorner",fab).CornerRadius=UDim.new(1,0)

local vpX=W.CurrentCamera and W.CurrentCamera.ViewportSize.X or 400
local pw=math.min(340,math.max(280,vpX-40))

local panel=Instance.new("Frame",gui)
panel.Size=UDim2.new(0,pw,0,540); panel.Position=UDim2.new(0,-(pw+60),0.5,-270)
panel.BackgroundColor3=M.surface; panel.BorderSizePixel=0; panel.Active=false
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,24)
Instance.new("UIStroke",panel).Color=M.surfaceHigh

local hdr=Instance.new("Frame",panel)
hdr.Size=UDim2.new(1,-24,0,60); hdr.Position=UDim2.new(0,12,0,12)
hdr.BackgroundColor3=M.surfaceCont; hdr.BorderSizePixel=0
Instance.new("UICorner",hdr).CornerRadius=UDim.new(0,20)
local hT=Instance.new("TextLabel",hdr)
hT.Size=UDim2.new(1,-100,0,24); hT.Position=UDim2.new(0,16,0,6)
hT.BackgroundTransparency=1; hT.Text="listwork's hub"
hT.TextColor3=M.primary; hT.TextXAlignment=Enum.TextXAlignment.Left
hT.Font=FB; hT.TextSize=17
local hS=Instance.new("TextLabel",hdr)
hS.Size=UDim2.new(1,-100,0,16); hS.Position=UDim2.new(0,16,0,32)
hS.BackgroundTransparency=1; hS.Text="MM2 • "..VER
hS.TextColor3=M.onSurfaceVar; hS.TextXAlignment=Enum.TextXAlignment.Left
hS.Font=FONT; hS.TextSize=11

local closeBtn=Instance.new("TextButton",hdr)
closeBtn.Size=UDim2.new(0,32,0,32); closeBtn.Position=UDim2.new(1,-40,0,14)
closeBtn.BackgroundColor3=M.surfaceHigh; closeBtn.Text="✕"
closeBtn.TextColor3=M.onSurface; closeBtn.Font=FB; closeBtn.TextSize=14
closeBtn.BorderSizePixel=0
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(1,0)

local tabsBar=Instance.new("Frame",panel)
tabsBar.Size=UDim2.new(1,-24,0,36); tabsBar.Position=UDim2.new(0,12,0,80)
tabsBar.BackgroundTransparency=1
local tbL=Instance.new("UIListLayout",tabsBar)
tbL.FillDirection=Enum.FillDirection.Horizontal
tbL.Padding=UDim.new(0,5); tbL.SortOrder=Enum.SortOrder.LayoutOrder

local scroll=Instance.new("ScrollingFrame",panel)
scroll.Size=UDim2.new(1,-24,1,-124); scroll.Position=UDim2.new(0,12,0,120)
scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0
scroll.CanvasSize=UDim2.new(0,0,0,0); scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
scroll.ScrollBarThickness=3
local sL=Instance.new("UIListLayout",scroll)
sL.Padding=UDim.new(0,6); sL.SortOrder=Enum.SortOrder.LayoutOrder

local pages={}
local activeTab="combat"
local LO=0
local function nextLO() LO=LO+1; return LO end

local function mkPage(n)
  local p=Instance.new("Frame",scroll)
  p.LayoutOrder=nextLO(); p.Size=UDim2.new(1,-6,0,0)
  p.BackgroundTransparency=1; p.AutomaticSize=Enum.AutomaticSize.Y
  p.Visible=(n=="combat")
  local pl=Instance.new("UIListLayout",p)
  pl.Padding=UDim.new(0,6); pl.SortOrder=Enum.SortOrder.LayoutOrder
  pages[n]=p
end
for _,n in ipairs{"combat","visual","utils","about"} do mkPage(n) end

local refreshFns={}
local function regR(f) table.insert(refreshFns,f) end
local function refreshAll() for _,f in ipairs(refreshFns) do sf(f) end end

local function setTab(n)
  activeTab=n
  for k,p in pairs(pages) do p.Visible=(k==n) end
  refreshAll()
end

local function mkTab(n,label,order)
  local b=Instance.new("TextButton",tabsBar)
  b.LayoutOrder=order; b.Size=UDim2.new(0,74,1,0)
  b.BackgroundColor3=M.surfaceCont; b.Text=T(label)
  b.TextColor3=M.onSurfaceVar; b.Font=FB; b.TextSize=11
  b.BorderSizePixel=0
  Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)
  regR(function()
    b.Text=T(label)
    local on=activeTab==n
    b.BackgroundColor3=on and M.primaryCont or M.surfaceCont
    b.TextColor3=on and M.primary or M.onSurfaceVar
  end)
  bind(b,function() setTab(n) end)
end
mkTab("combat","combat",1); mkTab("visual","visual",2)
mkTab("utils","utils",3); mkTab("about","about",4)

local function mkCard(parent,label,key,guard)
  local c=Instance.new("TextButton",parent)
  c.LayoutOrder=nextLO(); c.Size=UDim2.new(1,0,0,52)
  c.Text=""; c.BorderSizePixel=0; c.AutoButtonColor=false
  Instance.new("UICorner",c).CornerRadius=UDim.new(0,14)
  local sk=Instance.new("UIStroke",c); sk.Thickness=1
  local lb=Instance.new("TextLabel",c)
  lb.Size=UDim2.new(1,-70,1,0); lb.Position=UDim2.new(0,14,0,0)
  lb.BackgroundTransparency=1; lb.Text=T(label)
  lb.TextXAlignment=Enum.TextXAlignment.Left; lb.Font=FB; lb.TextSize=13
  local bd=Instance.new("TextLabel",c)
  bd.Size=UDim2.new(0,54,0,24); bd.Position=UDim2.new(1,-62,0.5,-12)
  bd.Font=FB; bd.TextSize=10; bd.BorderSizePixel=0
  Instance.new("UICorner",bd).CornerRadius=UDim.new(1,0)
  local function refresh()
    local on=S[key]
    c.BackgroundColor3=on and M.primaryCont or M.surfaceCont
    sk.Color=on and M.primary or M.surfaceHigh
    lb.TextColor3=on and M.primary or M.onSurface
    lb.Text=T(label)
    bd.BackgroundColor3=on and M.primary or M.surfaceHigh
    bd.TextColor3=on and M.onSurface or M.onSurfaceVar
    bd.Text=on and T("on") or T("off")
  end
  regR(refresh); refresh()
  bind(c,function()
    local nv=not S[key]
    if guard and not guard(nv) then return end
    S[key]=nv; refresh()
  end)
end

local function mkToggle(parent,label,get,set)
  local c=Instance.new("TextButton",parent)
  c.LayoutOrder=nextLO(); c.Size=UDim2.new(1,0,0,44)
  c.Text=""; c.BorderSizePixel=0; c.AutoButtonColor=false
  Instance.new("UICorner",c).CornerRadius=UDim.new(0,12)
  local sk=Instance.new("UIStroke",c); sk.Thickness=1
  local lb=Instance.new("TextLabel",c)
  lb.Size=UDim2.new(1,-70,1,0); lb.Position=UDim2.new(0,14,0,0)
  lb.BackgroundTransparency=1; lb.Text=T(label)
  lb.TextXAlignment=Enum.TextXAlignment.Left; lb.Font=FB; lb.TextSize=12
  local bd=Instance.new("TextLabel",c)
  bd.Size=UDim2.new(0,54,0,22); bd.Position=UDim2.new(1,-62,0.5,-11)
  bd.Font=FB; bd.TextSize=10; bd.BorderSizePixel=0
  Instance.new("UICorner",bd).CornerRadius=UDim.new(1,0)
  local function refresh()
    local on=get()
    c.BackgroundColor3=on and M.primaryCont or M.surfaceCont
    sk.Color=on and M.primary or M.surfaceHigh
    lb.TextColor3=on and M.primary or M.onSurface
    lb.Text=T(label)
    bd.BackgroundColor3=on and M.primary or M.surfaceHigh
    bd.TextColor3=on and M.onSurface or M.onSurfaceVar
    bd.Text=on and T("on") or T("off")
  end
  regR(refresh); refresh()
  bind(c,function() set(not get()); refresh() end)
end

local function mkCycle(parent,label,opts,get,set,fmt)
  local c=Instance.new("TextButton",parent)
  c.LayoutOrder=nextLO(); c.Size=UDim2.new(1,0,0,44)
  c.BackgroundColor3=M.surfaceCont; c.Text=""; c.BorderSizePixel=0; c.AutoButtonColor=false
  Instance.new("UICorner",c).CornerRadius=UDim.new(0,12)
  local sk=Instance.new("UIStroke",c); sk.Color=M.surfaceHigh; sk.Thickness=1
  local lb=Instance.new("TextLabel",c)
  lb.Size=UDim2.new(1,-100,1,0); lb.Position=UDim2.new(0,14,0,0)
  lb.BackgroundTransparency=1; lb.Text=T(label)
  lb.TextXAlignment=Enum.TextXAlignment.Left
  lb.Font=FB; lb.TextSize=12; lb.TextColor3=M.onSurface
  local vL=Instance.new("TextLabel",c)
  vL.Size=UDim2.new(0,86,1,0); vL.Position=UDim2.new(1,-96,0,0)
  vL.BackgroundTransparency=1; vL.TextXAlignment=Enum.TextXAlignment.Right
  vL.Font=FB; vL.TextSize=11; vL.TextColor3=M.primary
  local function refresh()
    lb.Text=T(label)
    vL.Text=fmt(get())
  end
  regR(refresh); refresh()
  bind(c,function()
    local cur=get()
    for i,v in ipairs(opts) do
      if v==cur then set(opts[i%#opts+1]); break end
    end
    refresh()
  end)
end

local function mkAction(parent,label,fn)
  local c=Instance.new("TextButton",parent)
  c.LayoutOrder=nextLO(); c.Size=UDim2.new(1,0,0,52)
  c.BackgroundColor3=M.surfaceCont; c.Text=""; c.BorderSizePixel=0; c.AutoButtonColor=false
  Instance.new("UICorner",c).CornerRadius=UDim.new(0,14)
  local sk=Instance.new("UIStroke",c); sk.Color=M.surfaceHigh; sk.Thickness=1
  local lb=Instance.new("TextLabel",c)
  lb.Size=UDim2.new(1,-50,1,0); lb.Position=UDim2.new(0,14,0,0)
  lb.BackgroundTransparency=1; lb.Text=T(label)
  lb.TextXAlignment=Enum.TextXAlignment.Left
  lb.Font=FB; lb.TextSize=13; lb.TextColor3=M.onSurface
  local ar=Instance.new("TextLabel",c)
  ar.Size=UDim2.new(0,40,1,0); ar.Position=UDim2.new(1,-44,0,0)
  ar.BackgroundTransparency=1; ar.Text="→"; ar.TextColor3=M.primary
  ar.Font=FB; ar.TextSize=16
  regR(function() lb.Text=T(label) end)
  bind(c,fn)
end

local function mkDiv(parent,label)
  local f=Instance.new("Frame",parent)
  f.LayoutOrder=nextLO(); f.Size=UDim2.new(1,0,0,22)
  f.BackgroundTransparency=1
  local l=Instance.new("TextLabel",f)
  l.Size=UDim2.new(1,0,1,0); l.Position=UDim2.new(0,12,0,0)
  l.BackgroundTransparency=1; l.TextColor3=M.tertiary
  l.TextXAlignment=Enum.TextXAlignment.Left
  l.Font=FB; l.TextSize=10
  regR(function() l.Text=T(label) end)
end

-- guards
local function guardFarm(v)
  if not v then return true end
  local r=myRoleC()
  if r=="murderer" or r=="sheriff" then return true end
  warn("[lwh] Farm: нужен нож/пушка")
  return false
end
local function guardAK(v)
  if not v then return true end
  local bp=LP:FindFirstChild("Backpack")
  local c=LP.Character
  local k=(c and c:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife"))
  if not k then warn("[lwh] AutoKnife: ножа нет") return false end
  return true
end

-- COMBAT
mkCard(pages.combat,"farm","farm",guardFarm)
mkCard(pages.combat,"aim","aim")
mkCard(pages.combat,"hitbox","hitbox")
mkCard(pages.combat,"killaura","killaura")
mkCard(pages.combat,"autoknife","autoknife",guardAK)
mkDiv(pages.combat,"farmSettings")
mkCycle(pages.combat,"target",{"nearest","murderer","lowhp"},
  function() return FC.target end,
  function(v) FC.target=v end,
  function(v) return T(v=="murderer" and "murder" or v) end)
mkCycle(pages.combat,"range",{10,15,20,25,30},
  function() return FC.range end,
  function(v) FC.range=v end,
  function(v) return v.." studs" end)
mkCycle(pages.combat,"rate",{0.05,0.1,0.15,0.25},
  function() return FC.rate end,
  function(v) FC.rate=v end,
  function(v) return v.."s" end)
mkToggle(pages.combat,"autoEquip",
  function() return FC.autoEquip end,
  function(v) FC.autoEquip=v end)
mkToggle(pages.combat,"onlyM",
  function() return FC.onlyMurderer end,
  function(v) FC.onlyMurderer=v end)

-- VISUAL
mkCard(pages.visual,"esp","esp")
mkCard(pages.visual,"roles","roles")
mkCard(pages.visual,"fullbright","fullbright",function(v) setFB(v) return true end)

-- UTILS
mkCard(pages.utils,"pickup","pickup")
mkCard(pages.utils,"noclip","noclip")
mkCard(pages.utils,"infjump","infjump")
mkCard(pages.utils,"walkspeed","walkspeed")
mkAction(pages.utils,"tp",tpN)

-- ABOUT
mkDiv(pages.about,"about")
local ac=Instance.new("Frame",pages.about)
ac.LayoutOrder=nextLO(); ac.Size=UDim2.new(1,0,0,156)
ac.BackgroundColor3=M.surfaceCont; ac.BorderSizePixel=0
Instance.new("UICorner",ac).CornerRadius=UDim.new(0,18)
local aL=Instance.new("TextLabel",ac)
aL.Size=UDim2.new(1,-28,0,22); aL.Position=UDim2.new(0,14,0,14)
aL.BackgroundTransparency=1; aL.TextColor3=M.onSurface; aL.TextXAlignment=Enum.TextXAlignment.Left
aL.Font=FB; aL.TextSize=15; aL.Text=T("author")
local tL=Instance.new("TextLabel",ac)
tL.Size=UDim2.new(1,-28,0,20); tL.Position=UDim2.new(0,14,0,38)
tL.BackgroundTransparency=1; tL.TextColor3=M.primary; tL.TextXAlignment=Enum.TextXAlignment.Left
tL.Font=FONT; tL.TextSize=13; tL.Text=T("tg")
local vL=Instance.new("TextLabel",ac)
vL.Size=UDim2.new(1,-28,0,18); vL.Position=UDim2.new(0,14,0,60)
vL.BackgroundTransparency=1; vL.TextColor3=M.onSurfaceVar; vL.TextXAlignment=Enum.TextXAlignment.Left
vL.Font=FONT; vL.TextSize=11; vL.Text=VER
local rL=Instance.new("TextLabel",ac)
rL.Size=UDim2.new(1,-28,0,20); rL.Position=UDim2.new(0,14,0,80)
rL.BackgroundTransparency=1; rL.TextColor3=M.tertiary; rL.TextXAlignment=Enum.TextXAlignment.Left
rL.Font=FB; rL.TextSize=11
local copyB=Instance.new("TextButton",ac)
copyB.Size=UDim2.new(0,130,0,28); copyB.Position=UDim2.new(0,14,0,108)
copyB.BackgroundColor3=M.primaryCont; copyB.Text="copy @listwork1"
copyB.TextColor3=M.primary; copyB.Font=FB; copyB.TextSize=10; copyB.BorderSizePixel=0
Instance.new("UICorner",copyB).CornerRadius=UDim.new(1,0)
onAcc(function(c)
  tL.TextColor3=c; copyB.TextColor3=c
end)
task.spawn(function()
  while running do
    task.wait(1.5)
    if rL.Parent then
      rCache.t=0
      local r=myRoleC()
      local rs=T("unknown")
      if r=="murderer" then rs=T("murderer")
      elseif r=="sheriff" then rs=T("sheriff")
      elseif r=="innocent" then rs=T("innocent") end
      rL.Text="Role: "..rs
    end
  end
end)
bind(copyB,function()
  if hasCb then sf(setclipboard,"listwork1") end
  copyB.Text="✔"; task.wait(1.5); copyB.Text="copy @listwork1"
end)

mkDiv(pages.about,"lang")
local lr=Instance.new("Frame",pages.about)
lr.LayoutOrder=nextLO(); lr.Size=UDim2.new(1,0,0,44)
lr.BackgroundColor3=M.surfaceCont; lr.BorderSizePixel=0
Instance.new("UICorner",lr).CornerRadius=UDim.new(0,14)
local rb=Instance.new("TextButton",lr)
rb.Size=UDim2.new(0.5,-6,1,-10); rb.Position=UDim2.new(0,4,0,5)
rb.BackgroundColor3=M.surfaceHigh; rb.Text="RU"; rb.TextColor3=M.onSurface
rb.Font=FB; rb.TextSize=12; rb.BorderSizePixel=0
Instance.new("UICorner",rb).CornerRadius=UDim.new(0,10)
local eb=Instance.new("TextButton",lr)
eb.Size=UDim2.new(0.5,-6,1,-10); eb.Position=UDim2.new(0.5,2,0,5)
eb.BackgroundColor3=M.surfaceHigh; eb.Text="EN"; eb.TextColor3=M.onSurface
eb.Font=FB; eb.TextSize=12; eb.BorderSizePixel=0
Instance.new("UICorner",eb).CornerRadius=UDim.new(0,10)
regR(function()
  rb.BackgroundColor3=CFG.lang=="RU" and M.primaryCont or M.surfaceHigh
  eb.BackgroundColor3=CFG.lang=="EN" and M.primaryCont or M.surfaceHigh
end)
bind(rb,function() if CFG.lang~="RU" then CFG.lang="RU"; refreshAll() end end)
bind(eb,function() if CFG.lang~="EN" then CFG.lang="EN"; refreshAll() end end)

mkDiv(pages.about,"accent")
local gr=Instance.new("Frame",pages.about)
gr.LayoutOrder=nextLO(); gr.Size=UDim2.new(1,0,0,144)
gr.BackgroundColor3=M.surfaceCont; gr.BorderSizePixel=0
Instance.new("UICorner",gr).CornerRadius=UDim.new(0,14)
local gL=Instance.new("UIGridLayout",gr)
gL.CellSize=UDim2.new(0,28,0,28); gL.CellPadding=UDim2.new(0,5,0,5)
gL.HorizontalAlignment=Enum.HorizontalAlignment.Center
gL.VerticalAlignment=Enum.VerticalAlignment.Center
for i,c3 in ipairs(PAL) do
  local b=Instance.new("TextButton",gr)
  b.LayoutOrder=i; b.Size=UDim2.new(0,28,0,28)
  b.BackgroundColor3=c3; b.Text=""; b.BorderSizePixel=0
  Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)
  bind(b,function()
    CFG.accent=c3
    M.primary=c3; M.primaryCont=c3:Lerp(Color3.new(),0.4)
    for _,f in ipairs(accFns) do sf(f,c3) end
    refreshAll()
  end)
end

-- OPEN/CLOSE
local opened=false
local function setOpen(v)
  opened=v
  game:GetService("TweenService"):Create(panel,TweenInfo.new(0.28,Enum.EasingStyle.Emphasized),{
    Position=v and UDim2.new(0,80,0.5,-270) or UDim2.new(0,-(pw+60),0.5,-270)
  }):Play()
end
bind(fab,function() setOpen(not opened) end)
bind(closeBtn,function() setOpen(false) end)

cx(UIS.InputBegan,function(i,g)
  if g then return end
  if i.KeyCode==Enum.KeyCode.F1 then
    if S.farm then S.farm=false; refreshAll()
    else if guardFarm(true) then S.farm=true; refreshAll() end end
  end
  if i.KeyCode==Enum.KeyCode.RightShift then setOpen(not opened) end
end)

setTab("combat")
if S.fullbright then setFB(true) end

--═══════ CLEANUP ═══════
G.LWH={
  state=S,farmCfg=FC,version=VER,
  cleanup=function()
    running=false
    pcall(function() RS:UnbindFromRenderStep("LWH_Aim") end)
    for _,c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    if gui then pcall(function() gui:Destroy() end) end
    if espF then pcall(function() espF:Destroy() end) end
    if sp then pcall(function() sp:Destroy() end) end
    if REST.fullbright then
      for k,val in pairs(REST.fullbright) do pcall(function() Li[k]=val end) end
    end
    for p in pairs(REST.noclip) do
      if p and p.Parent then pcall(function() p.CanCollide=true end) end
    end
    for k in pairs(REST.noclip) do REST.noclip[k]=nil end
    for p,sz in pairs(REST.hitbox) do
      local hrp=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
      if hrp then pcall(function() hrp.Size=sz; hrp.Transparency=0 end) end
    end
    for k in pairs(REST.hitbox) do REST.hitbox[k]=nil end
    local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h and REST.walkspeed then h.WalkSpeed=REST.walkspeed end
    REST.walkspeed=nil
    for i=#pc,1,-1 do pc[i]=nil end
  end,
}

--═══════ SPLASH RUN ═══════
task.spawn(function()
  fadeIn()
  local start=os.clock(); local dur=1.5
  while true do
    if not sp or not sp.Parent then return end
    local t=math.min((os.clock()-start)/dur,1)
    fl.Size=UDim2.new(t,0,1,0)
    pt.Text=math.floor(t*100).."%"
    if t>=1 then break end
    task.wait(0.03)
  end
  st.Text=T("done").." ✓"; pt.Text="100%"; fl.Size=UDim2.new(1,0,1,0)
  task.wait(0.35)
  fadeOut()
end)
task.delay(6,function() if sp and sp.Parent then pcall(function() sp:Destroy() end) end end)

print("[listwork's hub] "..VER.." loaded • t.me/listwork1")

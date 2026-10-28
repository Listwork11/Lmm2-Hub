--[[listwork]]
 not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Tween = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local GENV = (getgenv and getgenv()) or _G

local VERSION = "v1.1"
local BUGFIX = "v1.4"

local LP = Players.LocalPlayer
if not LP then
repeat task.wait(0.1); LP = Players.LocalPlayer until LP
end

if GENV.LWH and GENV.LWH.cleanup then pcall(GENV.LWH.cleanup) end

local S = GENV.LWH_STATE or {
farm=false, aim=false, esp=true, roles=true, pickup=true,
hitbox=false, fullbright=false, noclip=false, infjump=false,
walkspeed=false, killaura=false, autoknife=false,
}
GENV.LWH_STATE = S
local CFG = GENV.LWH_CFG or { lang="RU", accent=Color3.fromRGB(208,188,255) }
GENV.LWH_CFG = CFG
GENV.LWH_RESTORE = GENV.LWH_RESTORE or { fullbright=nil, hitbox={}, noclip={}, walkspeed=nil }
local FARM_CFG = GENV.LWH_FARM or {
target = "nearest", range = 15, rate = 0.1,
autoEquip = true, onlyMurderer = false,
}
GENV.LWH_FARM = FARM_CFG

local conns = {}
local running = true
local refreshFns = {}
local accentFns = {}
local espRoleFns = {}
local pickupCandidates = {}
local LO = 0
local function nextLO() LO = LO + 1; return LO end

local function connect(sig, fn)
local c = sig:Connect(fn); table.insert(conns, c); return c
end
local function safe(fn, ...) local ok, r = pcall(fn, ...); return ok and r end
local function regRefresh(fn) table.insert(refreshFns, fn) end
local function onAccent(fn) table.insert(accentFns, fn) end
local function refreshAll() for _, fn in ipairs(refreshFns) do safe(fn) end end

local function derivePrimaryCont(c) return c:Lerp(Color3.new(0,0,0), 0.4) end
local function deriveOnPrimary(c)
local lum = 0.299c.R + 0.587c.G + 0.114*c.B
if lum > 0.6 then return Color3.fromRGB(30,20,40) end
return Color3.fromRGB(245,240,255)
end

local M3 = {
surface=Color3.fromRGB(20,18,24), surfaceCont=Color3.fromRGB(30,27,34),
surfaceHigh=Color3.fromRGB(40,36,45),
primary=CFG.accent, primaryCont=derivePrimaryCont(CFG.accent),
onPrimary=deriveOnPrimary(CFG.accent),
secondaryCont=Color3.fromRGB(60,55,70),
onSurface=Color3.fromRGB(230,224,236),
onSurfaceVar=Color3.fromRGB(200,194,208),
outline=Color3.fromRGB(147,143,155),
tertiary=Color3.fromRGB(255,200,220),
}

local function applyAccent(c)
M3.primary = c; M3.primaryCont = derivePrimaryCont(c); M3.onPrimary = deriveOnPrimary(c)
for _, fn in ipairs(accentFns) do safe(fn, c) end
for _, fn in ipairs(espRoleFns) do safe(fn, c) end
refreshAll()
end

local L = {
RU = { combat="БОЙ", visual="ВИЗУАЛ", utils="УТИЛИТЫ", about="О СКРИПТЕ",
farm="Автофарм", aim="Аимбот", hitbox="Хитбокс", killaura="KillAura",
esp="ESP игроков", roles="Подсветка ролей", fullbright="Fullbright",
pickup="Автоподбор", noclip="Noclip", infjump="Беск. прыжок",
walkspeed="Скорость ходьбы", autoknife="Авто-нож", tp="TP к ближнему",
lang="Язык", accent="Акцентный цвет", author="Автор: listwork",
tg="ТГК: listwork1", on="ВКЛ", off="ВЫКЛ", copy="копировать",
copied="✔ скопировано", murderer="Убийца", sheriff="Шериф",
version="Версия", role="Роль", roleUnknown="не определена",
roleInnocent="Невинный", farmSettings="НАСТРОЙКИ ФАРМА",
farmTarget="Цель", farmRange="Дальность", farmRate="Темп",
farmAutoEquip="Автоэквип", farmOnlyM="Только убийцы",
target_nearest="Ближний", target_murderer="Убийца",
target_lowhp="Слабый" },
EN = { combat="COMBAT", visual="VISUAL", utils="UTILITIES", about="ABOUT",
farm="AutoFarm", aim="Aimbot", hitbox="Hitbox", killaura="KillAura",
esp="Player ESP", roles="Role Highlight", fullbright="Fullbright",
pickup="AutoPickup", noclip="Noclip", infjump="Infinite Jump",
walkspeed="WalkSpeed", autoknife="Auto Knife", tp="TP to Nearest",
lang="Language", accent="Accent Color", author="Author: listwork",
tg="TG: listwork1", on="ON", off="OFF", copy="copy",
copied="✔ copied", murderer="Murderer", sheriff="Sheriff",
version="Version", role="Role", roleUnknown="unknown",
roleInnocent="Innocent", farmSettings="FARM SETTINGS",
farmTarget="Target", farmRange="Range", farmRate="Rate",
farmAutoEquip="AutoEquip", farmOnlyM="Murderers only",
target_nearest="Nearest", target_murderer="Murderer",
target_lowhp="Low HP" },
}
local function T(k) return (L[CFG.lang] or L.RU)[k] or k end

local FONT=Enum.Font.GothamMedium
local FONT_BOLD=Enum.Font.GothamBold

local PALETTE = {
Color3.fromRGB(208,188,255), Color3.fromRGB(255,180,171),
Color3.fromRGB(180,255,200), Color3.fromRGB(255,220,150),
Color3.fromRGB(150,220,255), Color3.fromRGB(255,170,220),
Color3.fromRGB(200,255,150), Color3.fromRGB(255,150,150),
Color3.fromRGB(180,180,255), Color3.fromRGB(150,255,220),
Color3.fromRGB(255,200,140), Color3.fromRGB(220,180,255),
Color3.fromRGB(140,200,140), Color3.fromRGB(255,140,180),
Color3.fromRGB(180,220,255), Color3.fromRGB(235,235,235),
}

local function getMyRole()
local ok, r = pcall(function() return LP:GetAttribute("Role") end)
if ok and r then
local lr = string.lower(tostring(r))
if lr:find("murder") then return "murderer" end
if lr:find("sheriff") then return "sheriff" end
if lr:find("innocent") then return "innocent" end
end
local sources = { LP.Character, LP:FindFirstChild("Backpack") }
for _, src in ipairs(sources) do
if src then
for _, t in ipairs(src:GetChildren()) do
local n = t.Name:lower()
if n:find("knife") then return "murderer" end
if n:find("gun") then return "sheriff" end
end
end
end
return nil
end

local roleCache = { at = 0, role = nil }
local function getMyRoleCached()
if os.clock() - roleCache.at < 1 then return roleCache.role end
roleCache.role = getMyRole()
roleCache.at = os.clock()
return roleCache.role
end

local function getPlayerRoleKey(p)
if not p then return nil end
if p == LP then return getMyRoleCached() end
local c = p.Character
if c then
for _, t in ipairs(c:GetChildren()) do
if t:IsA("Tool") then
local n = t.Name:lower()
if n:find("knife") then return "murderer" end
if n:find("gun") then return "sheriff" end
end
end
end
return nil
end

local function roleTag(p)
local k = getPlayerRoleKey(p)
if k == "murderer" then return T("murderer") end
if k == "sheriff" then return T("sheriff") end
if k == "innocent" then return T("roleInnocent") end
return nil
end

local function isTargetMurderer(head)
if not head then return false end
local parentChar = head.Parent
if not parentChar then return false end
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LP and p.Character == parentChar then
return getPlayerRoleKey(p) == "murderer"
end
end
return false
end

local function canAttack(head)
if not head then return false end
local myRole = getMyRoleCached()
if myRole == "murderer" then return true end
if myRole == "sheriff" then return isTargetMurderer(head) end
return false
end

pcall(function()
local cg = game:GetService("CoreGui")
if not cg then return end
local a = cg:FindFirstChild("ListworksHub"); if a then a:Destroy() end
local b = cg:FindFirstChild("LWH_ESP"); if b then b:Destroy() end
end)
if LP then
local pg = LP:FindFirstChild("PlayerGui")
if pg then
local a = pg:FindFirstChild("ListworksHub"); if a then a:Destroy() end
local b = pg:FindFirstChild("LWH_ESP"); if b then b:Destroy() end
end
end

local gui = Instance.new("ScreenGui")
gui.Name="ListworksHub"; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
pcall(function() gui.Parent=game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent=LP:WaitForChild("PlayerGui") end

local uiScale = Instance.new("UIScale", gui)
local function adapt()
local cam = Workspace.CurrentCamera
if not cam then return end
local vp = cam.ViewportSize
local m = math.min(vp.X, vp.Y)
uiScale.Scale = m<500 and 0.72 or (m<800 and 0.9 or 1.0)
end
adapt()

local camConn
local function hookCamera()
if camConn then
pcall(function() camConn:Disconnect() end)
local i = table.find(conns, camConn)
if i then table.remove(conns, i) end
camConn = nil
end
adapt()
local cam = Workspace.CurrentCamera
if cam then
camConn = cam:GetPropertyChangedSignal("ViewportSize"):Connect(adapt)
table.insert(conns, camConn)
end
end
hookCamera()
connect(Workspace:GetPropertyChangedSignal("CurrentCamera"), hookCamera)

local restore = GENV.LWH_RESTORE
local lastClickAt = 0
local lastJumpAt = 0
local lastEquipAt = 0
local hasTouch = type(firetouchinterest) == "function"
local hasClipboard = type(setclipboard) == "function"
if not hasTouch then
warn("[listwork's hub "..VERSION.."] firetouchinterest недоступен — автоподбор отключён")
end
if not hasClipboard then
warn("[listwork's hub "..VERSION.."] setclipboard недоступен")
end

local function nearestTarget()
local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
if not hrp then return nil end
local mode = FARM_CFG.target
local maxR = FARM_CFG.range
local onlyM = FARM_CFG.onlyMurderer
local best, bestDist, bestHP = nil, math.huge, math.huge
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LP and p.Character then
local head = p.Character:FindFirstChild("Head")
local hum = p.Character:FindFirstChildOfClass("Humanoid")
if head and hum and hum.Health > 0 then
local d = (hrp.Position - head.Position).Magnitude
if d <= maxR then
local isM = getPlayerRoleKey(p) == "murderer"
if onlyM and not isM then
else
if mode == "lowhp" then
if hum.Health < bestHP then
bestHP, best, bestDist = hum.Health, head, d
end
elseif mode == "murderer" then
if isM and d < bestDist then
bestDist, best = d, head
end
else
if d < bestDist then
bestDist, best = d, head
end
end
end
end
end
end
end
return best
end

local function fireClick(head)
if not head then return end
if not canAttack(head) then return end
if os.clock() - lastClickAt < FARM_CFG.rate then return end
local char = LP.Character
if not char then return end
local tool = char:FindFirstChildOfClass("Tool")
if not tool then
if FARM_CFG.autoEquip and os.clock() - lastEquipAt > 1 then
local bp = LP:FindFirstChild("Backpack")
local hum = char:FindFirstChildOfClass("Humanoid")
if bp and hum then
local knife = bp:FindFirstChild("Knife")
local gun = bp:FindFirstChild("Gun")
if knife then
lastEquipAt = os.clock()
safe(function() hum:EquipTool(knife) end)
elseif gun then
lastEquipAt = os.clock()
safe(function() hum:EquipTool(gun) end)
end
end
end
return
end
local n = tool.Name:lower()
if not (n:find("knife") or n:find("gun")) then return end
lastClickAt = os.clock()
local ok2 = safe(function()
local m = LP:GetMouse()
VIM:SendMouseButtonEvent(m.X, m.Y, 0, true, game, 1)
VIM:SendMouseButtonEvent(m.X, m.Y, 0, false, game, 1)
end)
if not ok2 and type(mouse1click) == "function" then safe(mouse1click) end
end

local function tpNearest()
local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
if not hrp then return end
local best,bd=nil,math.huge
for _,p in ipairs(Players:GetPlayers()) do
if p~=LP and p.Character then
local th=p.Character:FindFirstChild("HumanoidRootPart")
if th then
local d=(hrp.Position-th.Position).Magnitude
if d<bd then bd,best=d,th end
end
end
end
if best then hrp.CFrame = best.CFrame * CFrame.new(0,0,3) end
end

local function setFullbright(v)
if v and not restore.fullbright then
restore.fullbright = {
Ambient=Lighting.Ambient, OutdoorAmbient=Lighting.OutdoorAmbient,
Brightness=Lighting.Brightness, FogEnd=Lighting.FogEnd,
}
Lighting.Ambient=Color3.fromRGB(180,180,180)
Lighting.OutdoorAmbient=Color3.fromRGB(180,180,180)
Lighting.Brightness=3; Lighting.FogEnd=1e6
elseif not v and restore.fullbright then
for k,val in pairs(restore.fullbright) do
pcall(function() Lighting[k]=val end)
end
restore.fullbright = nil
end
end

local espFolder = Instance.new("Folder")
espFolder.Name="LWH_ESP"
pcall(function() espFolder.Parent=game:GetService("CoreGui") end)
if not espFolder.Parent then espFolder.Parent=LP:WaitForChild("PlayerGui") end

local function makeESP(char, pname)
if not char or espFolder:FindFirstChild(pname) then return end
local h=char:WaitForChild("Head",5); if not h then return end
local bill=Instance.new("BillboardGui", espFolder)
bill.Name=pname; bill.Adornee=h
bill.Size=UDim2.new(0,200,0,46); bill.AlwaysOnTop=true
bill.StudsOffset=Vector3.new(0,2.8,0)
local nm=Instance.new("TextLabel", bill)
nm.Size=UDim2.new(1,0,0.55,0); nm.BackgroundTransparency=1
nm.TextColor3=Color3.fromRGB(255,100,100); nm.TextStrokeTransparency=0.2
nm.Text=pname; nm.Font=FONT_BOLD; nm.TextScaled=true
local role=Instance.new("TextLabel", bill)
role.Size=UDim2.new(1,0,0.45,0); role.Position=UDim2.new(0,0,0.55,0)
role.BackgroundTransparency=1; role.TextColor3=M3.primary
role.TextStrokeTransparency=0.2; role.Font=FONT; role.TextScaled=true
local listener = function(c) if role.Parent then role.TextColor3=c end end
table.insert(espRoleFns, listener)
task.spawn(function()
while running and bill.Parent do
bill.Enabled=S.esp; role.Visible=S.roles
local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
if hrp and h.Parent then
local d=math.floor((hrp.Position-h.Position).Magnitude)
nm.Text=pname.." ["..d.."m]"
role.Text=roleTag(Players:FindFirstChild(pname)) or ""
end
task.wait(0.4)
end
local i = table.find(espRoleFns, listener)
if i then table.remove(espRoleFns, i) end
if bill then bill:Destroy() end
end)
end

local function track(p)
if p==LP then return end
if p.Character then makeESP(p.Character,p.Name) end
connect(p.CharacterAdded, function(c) task.wait(0.5); makeESP(c,p.Name) end)
connect(p.CharacterRemoving, function()
local e = espFolder:FindFirstChild(p.Name); if e then e:Destroy() end
restore.hitbox[p] = nil
end)
end
for _,p in ipairs(Players:GetPlayers()) do track(p) end
connect(Players.PlayerAdded, track)
connect(Players.PlayerRemoving, function(p)
local e=espFolder:FindFirstChild(p.Name); if e then e:Destroy() end
restore.hitbox[p] = nil
end)

local function isPickupable(obj)
if not obj then return false end
if not (obj:IsA("BasePart") or obj:IsA("Model")) then return false end
if obj:IsA("BasePart") and obj.Parent and obj.Parent:IsA("Model") then
local pn = string.lower(obj.Parent.Name)
if pn:find("coin") or pn:find("gun") or pn:find("knife") or pn:find("money") or pn:find("item") then
return false
end
end
local n = obj.Name
if #n < 3 then return false end
local f = string.lower(string.sub(n, 1, 1))
if f ~= "c" and f ~= "g" and f ~= "k" and f ~= "i" and f ~= "m" then return false end
local l = string.lower(n)
return l:find("coin") ~= nil or l:find("gun") ~= nil
or l:find("knife") ~= nil or l:find("item") ~= nil
or l:find("money") ~= nil
end

task.spawn(function()
for _, obj in ipairs(Workspace:GetDescendants()) do
if isPickupable(obj) then table.insert(pickupCandidates, obj) end
end
end)
connect(Workspace.DescendantAdded, function(obj)
if isPickupable(obj) then table.insert(pickupCandidates, obj) end
end)
connect(Workspace.DescendantRemoving, function(obj)
local i = table.find(pickupCandidates, obj)
if i then table.remove(pickupCandidates, i) end
end)

connect(RunService.Heartbeat, function()
if S.hitbox then
for _,p in ipairs(Players:GetPlayers()) do
if p~=LP and p.Character then
local hrp=p.Character:FindFirstChild("HumanoidRootPart")
if hrp then
restore.hitbox[p] = restore.hitbox[p] or hrp.Size
hrp.Size=Vector3.new(12,12,12)
hrp.Transparency=1; hrp.CanCollide=false; hrp.Massless=true
end
end
end
elseif next(restore.hitbox) then
for p,sz in pairs(restore.hitbox) do
local hrp=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
if hrp then hrp.Size=sz; hrp.Transparency=0 end
end
for k in pairs(restore.hitbox) do restore.hitbox[k] = nil end
end

if S.autoknife then
local char=LP.Character
local hum=char and char:FindFirstChildOfClass("Humanoid")
if hum then
local equipped = char:FindFirstChild("Knife")
if not equipped and os.clock() - lastEquipAt > 1 then
local bp = LP:FindFirstChild("Backpack")
local knife = bp and bp:FindFirstChild("Knife")
if knife then
lastEquipAt = os.clock()
safe(function() hum:EquipTool(knife) end)
end
end
local hrp=char and char:FindFirstChild("HumanoidRootPart")
if hrp and equipped then
for _,p in ipairs(Players:GetPlayers()) do
if p~=LP and p.Character then
local th=p.Character:FindFirstChild("HumanoidRootPart")
if th and (hrp.Position-th.Position).Magnitude<6 then
fireClick(p.Character:FindFirstChild("Head"))
break
end
end
end
end
end
end

if S.infjump then
local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
if hrp and (UIS:IsKeyDown(Enum.KeyCode.Space) or os.clock() - lastJumpAt < 0.5) then
safe(function()
hrp.AssemblyLinearVelocity = Vector3.new(
hrp.AssemblyLinearVelocity.X, 55, hrp.AssemblyLinearVelocity.Z)
end)
end
end

if S.killaura then
local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
if hrp then
for _,p in ipairs(Players:GetPlayers()) do
if p~=LP and p.Character then
local th=p.Character:FindFirstChild("HumanoidRootPart")
if th and (hrp.Position-th.Position).Magnitude<10 then
fireClick(p.Character:FindFirstChild("Head"))
break
end
end
end
end
end
end)

RunService:BindToRenderStep("LWH_Aim", Enum.RenderPriority.Camera.Value + 1, function()
if S.aim then
local tgt = nearestTarget()
if tgt then
local cam=Workspace.CurrentCamera
if cam then cam.CFrame=CFrame.new(cam.CFrame.Position,tgt.Position) end
end
end
end)

task.spawn(function()
while running do
if S.farm then
local tgt = nearestTarget()
if tgt then fireClick(tgt) end
end
task.wait(0.05)
end
end)

connect(RunService.Stepped, function()
if S.noclip then
local c=LP.Character
if c then
for _,p in ipairs(c:GetDescendants()) do
if p:IsA("BasePart") and p.CanCollide then
restore.noclip[p] = true
p.CanCollide=false
end
end
end
elseif next(restore.noclip) then
for p in pairs(restore.noclip) do
if p and p.Parent then safe(function() p.CanCollide=true end) end
end
for k in pairs(restore.noclip) do restore.noclip[k] = nil end
end
end)

connect(UIS.JumpRequest, function()
if S.infjump then lastJumpAt = os.clock() end
end)

task.spawn(function()
while running do
task.wait(0.5)
if S.pickup and hasTouch then
local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
if hrp then
for _,obj in ipairs(pickupCandidates) do
if obj.Parent then
local target = obj
if obj:IsA("Model") then
target = obj:FindFirstChildWhichIsA("BasePart")
end
if target and (hrp.Position-target.Position).Magnitude<35 then
safe(function()
firetouchinterest(hrp,target,0)
firetouchinterest(hrp,target,1)
end)
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
if restore.walkspeed == nil then restore.walkspeed = h.WalkSpeed end
h.WalkSpeed = 35
end
elseif restore.walkspeed ~= nil then
if h then h.WalkSpeed = restore.walkspeed end
restore.walkspeed = nil
end
end
end)

local fab, panel, activeTab = nil, nil, "combat"
local tabButtons = {}

local function bindClick(btn, fn)
local last = 0
local function handler()
local now = os.clock()
if now - last < 0.08 then return end
last = now
safe(fn)
end
connect(btn.MouseButton1Click, handler)
safe(function() connect(btn.TouchTap, handler) end)
end

fab=Instance.new("TextButton", gui)
fab.Size=UDim2.new(0,56,0,56); fab.Position=UDim2.new(0,20,0.5,-28)
fab.AnchorPoint=Vector2.new(0,0.5); fab.BackgroundColor3=M3.primaryCont
fab.Text="≡"; fab.TextColor3=M3.onPrimary; fab.TextSize=22
fab.Font=FONT_BOLD; fab.AutoButtonColor=false; fab.BorderSizePixel=0
Instance.new("UICorner", fab).CornerRadius=UDim.new(1,0)
onAccent(function()
fab.BackgroundColor3=M3.primaryCont
fab.TextColor3=M3.onPrimary
end)

local cam = Workspace.CurrentCamera
local vpW = cam and cam.ViewportSize.X or 400
local panelW = math.min(360, math.max(280, vpW - 40))

panel=Instance.new("Frame", gui)
panel.Name="ListworksHub_Panel"
panel.Size=UDim2.new(0,panelW,0,560)
panel.Position=UDim2.new(0,-(panelW+60),0.5,-280)
panel.BackgroundColor3=M3.surface; panel.BorderSizePixel=0
panel.Active=false; panel.Draggable=false
Instance.new("UICorner", panel).CornerRadius=UDim.new(0,24)
local pStroke=Instance.new("UIStroke", panel)
pStroke.Color=M3.surfaceHigh; pStroke.Thickness=1

local head=Instance.new("Frame", panel)
head.Size=UDim2.new(1,-24,0,64); head.Position=UDim2.new(0,12,0,12)
head.BackgroundColor3=M3.surfaceCont; head.BorderSizePixel=0
Instance.new("UICorner", head).CornerRadius=UDim.new(0,20)
local hT=Instance.new("TextLabel", head)
hT.Size=UDim2.new(1,-110,0,26); hT.Position=UDim2.new(0,16,0,6)
hT.BackgroundTransparency=1; hT.Text="listwork's hub"
hT.TextColor3=M3.primary; hT.TextXAlignment=Enum.TextXAlignment.Left
hT.Font=FONT_BOLD; hT.TextSize=18
onAccent(function(c) hT.TextColor3=c end)
local hS=Instance.new("TextLabel", head)
hS.Size=UDim2.new(1,-160,0,18); hS.Position=UDim2.new(0,16,0,32)
hS.BackgroundTransparency=1
hS.Text="MM2 • Material You • "..VERSION
hS.TextColor3=M3.onSurfaceVar; hS.TextXAlignment=Enum.TextXAlignment.Left
hS.Font=FONT; hS.TextSize=12
local hBF=Instance.new("TextLabel", head)
hBF.Size=UDim2.new(0,72,0,18); hBF.Position=UDim2.new(1,-142,0,32)
hBF.BackgroundTransparency=1
hBF.Text="BF "..BUGFIX
hBF.TextColor3=M3.onSurfaceVar
hBF.TextTransparency=0.55
hBF.TextXAlignment=Enum.TextXAlignment.Right
hBF.Font=FONT_BOLD; hBF.TextSize=10
regRefresh(function() hBF.Text = "BF "..BUGFIX end)

local closeBtn=Instance.new("TextButton", head)
closeBtn.Size=UDim2.new(0,36,0,36); closeBtn.Position=UDim2.new(1,-44,0,14)
closeBtn.BackgroundColor3=M3.secondaryCont; closeBtn.Text="✕"
closeBtn.TextColor3=M3.onSurface; closeBtn.Font=FONT_BOLD
closeBtn.TextSize=16; closeBtn.BorderSizePixel=0
Instance.new("UICorner", closeBtn).CornerRadius=UDim.new(1,0)

local tabBar=Instance.new("Frame", panel)
tabBar.Size=UDim2.new(1,-24,0,40); tabBar.Position=UDim2.new(0,12,0,84)
tabBar.BackgroundTransparency=1
local tLay=Instance.new("UIListLayout", tabBar)
tLay.FillDirection=Enum.FillDirection.Horizontal
tLay.Padding=UDim.new(0,6); tLay.SortOrder=Enum.SortOrder.LayoutOrder

local scroll=Instance.new("ScrollingFrame", panel)
scroll.Size=UDim2.new(1,-24,1,-136); scroll.Position=UDim2.new(0,12,0,130)
scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0
scroll.CanvasSize=UDim2.new(0,0,0,0)
scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
scroll.ScrollBarThickness=4; scroll.ScrollBarImageColor3=M3.primary
onAccent(function(c) scroll.ScrollBarImageColor3=c end)
local sLay=Instance.new("UIListLayout", scroll)
sLay.Padding=UDim.new(0,8); sLay.SortOrder=Enum.SortOrder.LayoutOrder

local pages = {}
local function mkPage(name)
local page=Instance.new("Frame", scroll)
page.LayoutOrder = nextLO()
page.Size=UDim2.new(1,-8,0,0); page.BackgroundTransparency=1
page.AutomaticSize=Enum.AutomaticSize.Y; page.Visible=(name=="combat")
local pl=Instance.new("UIListLayout", page)
pl.Padding=UDim.new(0,8); pl.SortOrder=Enum.SortOrder.LayoutOrder
pages[name]=page
end
for _,n in ipairs({"combat","visual","utils","about"}) do mkPage(n) end

local function setActiveTab(name)
activeTab = name
for k,p in pairs(pages) do p.Visible=(k==name) end
refreshAll()
end

local function mkTab(name, labelKey, order)
local btn=Instance.new("TextButton", tabBar)
btn.LayoutOrder=order
btn.Size=UDim2.new(0,76,1,0); btn.BackgroundColor3=M3.surfaceCont
btn.Text=T(labelKey); btn.TextColor3=M3.onSurfaceVar
btn.Font=FONT_BOLD; btn.TextSize=12; btn.BorderSizePixel=0
Instance.new("UICorner", btn).CornerRadius=UDim.new(1,0)
tabButtons[name]=btn
regRefresh(function()
btn.Text = T(labelKey)
local on = (activeTab==name)
btn.BackgroundColor3 = on and M3.primaryCont or M3.surfaceCont
btn.TextColor3 = on and M3.primary or M3.onSurfaceVar
end)
bindClick(btn, function() setActiveTab(name) end)
end
mkTab("combat","combat",1); mkTab("visual","visual",2)
mkTab("utils","utils",3); mkTab("about","about",4)

local function mkCard(parent, labelKey, stateKey, cb, opts)
opts = opts or {}
local disabled = opts.disabled == true
local guard = opts.guard
local card=Instance.new("TextButton", parent)
card.LayoutOrder = nextLO()
card.Size=UDim2.new(1,-8,0,56); card.Text=""
card.BorderSizePixel=0; card.AutoButtonColor=false
Instance.new("UICorner", card).CornerRadius=UDim.new(0,16)
local stroke=Instance.new("UIStroke", card); stroke.Thickness=1
local lbl=Instance.new("TextLabel", card)
lbl.Size=UDim2.new(1,-80,1,0); lbl.Position=UDim2.new(0,16,0,0)
lbl.BackgroundTransparency=1
lbl.TextXAlignment=Enum.TextXAlignment.Left
lbl.Font=FONT_BOLD; lbl.TextSize=14
local badge=Instance.new("TextLabel", card)
badge.Size=UDim2.new(0,60,0,26); badge.Position=UDim2.new(1,-70,0.5,-13)
badge.Font=FONT_BOLD; badge.TextSize=11; badge.BorderSizePixel=0
Instance.new("UICorner", badge).CornerRadius=UDim.new(1,0)

local function refresh()
local on = S[stateKey] and not disabled
card.BackgroundColor3 = on and M3.primaryCont or M3.surfaceCont
stroke.Color = on and M3.primary or M3.surfaceHigh
lbl.TextColor3 = on and M3.primary or M3.onSurface
if disabled then
badge.BackgroundColor3 = M3.surfaceHigh
badge.TextColor3 = M3.onSurfaceVar
badge.Text = "N/A"
else
badge.BackgroundColor3 = on and M3.primary or M3.surfaceHigh
badge.TextColor3 = on and M3.onPrimary or M3.onSurfaceVar
badge.Text = on and T("on") or T("off")
end
lbl.Text = T(labelKey)
end
regRefresh(refresh); refresh()

bindClick(card, function()
if disabled then return end
local newVal = not S[stateKey]
if guard and not guard(newVal) then return end
S[stateKey]=newVal
refresh()
if cb then cb(newVal) end
end)
return card
end

local function mkToggleCard(parent, labelKey, getFn, setFn)
local card=Instance.new("TextButton", parent)
card.LayoutOrder = nextLO()
card.Size=UDim2.new(1,-8,0,48); card.Text=""
card.BorderSizePixel=0; card.AutoButtonColor=false
Instance.new("UICorner", card).CornerRadius=UDim.new(0,14)
local stroke=Instance.new("UIStroke", card); stroke.Thickness=1
local lbl=Instance.new("TextLabel", card)
lbl.Size=UDim2.new(1,-80,1,0); lbl.Position=UDim2.new(0,14,0,0)
lbl.BackgroundTransparency=1; lbl.TextXAlignment=Enum.TextXAlignment.Left
lbl.Font=FONT_BOLD; lbl.TextSize=13
local badge=Instance.new("TextLabel", card)
badge.Size=UDim2.new(0,60,0,24); badge.Position=UDim2.new(1,-68,0.5,-12)
badge.Font=FONT_BOLD; badge.TextSize=11; badge.BorderSizePixel=0
Instance.new("UICorner", badge).CornerRadius=UDim.new(1,0)
local function refresh()
local on = getFn()
card.BackgroundColor3 = on and M3.primaryCont or M3.surfaceCont
stroke.Color = on and M3.primary or M3.surfaceHigh
lbl.TextColor3 = on and M3.primary or M3.onSurface
lbl.Text = T(labelKey)
badge.BackgroundColor3 = on and M3.primary or M3.surfaceHigh
badge.TextColor3 = on and M3.onPrimary or M3.onSurfaceVar
badge.Text = on and T("on") or T("off")
end
regRefresh(refresh); refresh()
bindClick(card, function()
setFn(not getFn()); refresh()
end)
return card
end

local function mkCycleCard(parent, labelKey, opts, getFn, setFn, formatFn)
local card=Instance.new("TextButton", parent)
card.LayoutOrder = nextLO()
card.Size=UDim2.new(1,-8,0,48); card.Text=""
card.BorderSizePixel=0; card.AutoButtonColor=false
card.BackgroundColor3 = M3.surfaceCont
Instance.new("UICorner", card).CornerRadius=UDim.new(0,14)
local stroke = Instance.new("UIStroke", card)
stroke.Color = M3.surfaceHigh; stroke.Thickness = 1
local lbl=Instance.new("TextLabel", card)
lbl.Size=UDim2.new(1,-110,1,0); lbl.Position=UDim2.new(0,14,0,0)
lbl.BackgroundTransparency=1; lbl.TextXAlignment=Enum.TextXAlignment.Left
lbl.Font=FONT_BOLD; lbl.TextSize=13; lbl.TextColor3=M3.onSurface
local valLbl=Instance.new("TextLabel", card)
valLbl.Size=UDim2.new(0,96,1,0); valLbl.Position=UDim2.new(1,-106,0,0)
valLbl.BackgroundTransparency=1
valLbl.TextXAlignment=Enum.TextXAlignment.Right
valLbl.Font=FONT_BOLD; valLbl.TextSize=12
local function refresh()
lbl.Text = T(labelKey)
valLbl.Text = formatFn(getFn())
valLbl.TextColor3 = M3.primary
lbl.TextColor3 = M3.onSurface
end
regRefresh(refresh); refresh()
bindClick(card, function()
local cur = getFn()
for i, v in ipairs(opts) do
if v == cur then
setFn(opts[i % #opts + 1])
break
end
end
refresh()
end)
return card
end

local function mkAction(parent, labelKey, fn)
local card=Instance.new("TextButton", parent)
card.LayoutOrder = nextLO()
card.Size=UDim2.new(1,-8,0,56); card.BackgroundColor3=M3.surfaceCont
card.Text=""; card.BorderSizePixel=0; card.AutoButtonColor=false
Instance.new("UICorner", card).CornerRadius=UDim.new(0,16)
local stroke=Instance.new("UIStroke", card)
stroke.Color=M3.surfaceHigh; stroke.Thickness=1
local lbl=Instance.new("TextLabel", card)
lbl.Size=UDim2.new(1,-80,1,0); lbl.Position=UDim2.new(0,16,0,0)
lbl.BackgroundTransparency=1
lbl.TextColor3=M3.onSurface; lbl.TextXAlignment=Enum.TextXAlignment.Left
lbl.Font=FONT_BOLD; lbl.TextSize=14
local arrow=Instance.new("TextLabel", card)
arrow.Size=UDim2.new(0,60,0,26); arrow.Position=UDim2.new(1,-70,0.5,-13)
arrow.BackgroundTransparency=1; arrow.Text="→"
arrow.TextColor3=M3.primary; arrow.Font=FONT_BOLD; arrow.TextSize=16
onAccent(function() arrow.TextColor3=M3.primary end)
regRefresh(function() lbl.Text=T(labelKey) end)
bindClick(card, fn)
return card
end

local function mkDivider(parent, labelKey)
local f=Instance.new("Frame", parent)
f.LayoutOrder = nextLO()
f.Size=UDim2.new(1,-8,0,26); f.BackgroundTransparency=1
local l=Instance.new("TextLabel", f)
l.Size=UDim2.new(1,-16,1,0); l.Position=UDim2.new(0,16,0,0)
l.BackgroundTransparency=1; l.TextColor3=M3.tertiary
l.TextXAlignment=Enum.TextXAlignment.Left
l.Font=FONT_BOLD; l.TextSize=11
regRefresh(function() l.Text=T(labelKey) end)
end

local farmGuard = function(v)
if not v then return true end
local myRole = getMyRoleCached()
if myRole == "murderer" or myRole == "sheriff" then return true end
if myRole == "innocent" then
warn("[listwork's hub] Farm недоступен Innocent — нет оружия")
return false
end
warn("[listwork's hub] Farm: роль не определена")
return false
end

local autoknifeGuard = function(v)
if not v then return true end
local bp = LP:FindFirstChild("Backpack")
local c = LP.Character
local hasKnife = (c and c:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife"))
if not hasKnife then
warn("[listwork's hub] AutoKnife: нож не найден")
return false
end
return true
end

mkCard(pages.combat, "farm", "farm", nil, { guard = farmGuard })
mkCard(pages.combat, "aim", "aim")
mkCard(pages.combat, "hitbox", "hitbox")
mkCard(pages.combat, "killaura", "killaura")
mkCard(pages.combat, "autoknife", "autoknife", nil, { guard = autoknifeGuard })

mkDivider(pages.combat, "farmSettings")
local TARGET_MODES = {"nearest", "murderer", "lowhp"}
local RANGE_OPTS = {10, 15, 20, 25, 30}
local RATE_OPTS = {0.05, 0.1, 0.15, 0.25}
mkCycleCard(pages.combat, "farmTarget", TARGET_MODES,
function() return FARM_CFG.target end,
function(v) FARM_CFG.target = v end,
function(v) return T("target_"..v) end)
mkCycleCard(pages.combat, "farmRange", RANGE_OPTS,
function() return FARM_CFG.range end,
function(v) FARM_CFG.range = v end,
function(v) return v.." studs" end)
mkCycleCard(pages.combat, "farmRate", RATE_OPTS,
function() return FARM_CFG.rate end,
function(v) FARM_CFG.rate = v end,
function(v) return v.."s" end)
mkToggleCard(pages.combat, "farmAutoEquip",
function() return FARM_CFG.autoEquip end,
function(v) FARM_CFG.autoEquip = v end)
mkToggleCard(pages.combat, "farmOnlyM",
function() return FARM_CFG.onlyMurderer end,
function(v) FARM_CFG.onlyMurderer = v end)

mkCard(pages.visual, "esp", "esp")
mkCard(pages.visual, "roles", "roles")
mkCard(pages.visual, "fullbright", "fullbright", setFullbright)

mkCard(pages.utils, "pickup", "pickup", nil, { disabled = not hasTouch })
mkCard(pages.utils, "noclip", "noclip")
mkCard(pages.utils, "infjump", "infjump")
mkCard(pages.utils, "walkspeed", "walkspeed")
mkAction(pages.utils, "tp", tpNearest)

mkDivider(pages.about, "about")
local authorCard=Instance.new("Frame", pages.about)
authorCard.LayoutOrder = nextLO()
authorCard.Size=UDim2.new(1,-8,0,172)
authorCard.BackgroundColor3=M3.surfaceCont; authorCard.BorderSizePixel=0
Instance.new("UICorner", authorCard).CornerRadius=UDim.new(0,20)
local aL=Instance.new("TextLabel", authorCard)
aL.Size=UDim2.new(1,-32,0,24); aL.Position=UDim2.new(0,16,0,14)
aL.BackgroundTransparency=1; aL.TextColor3=M3.onSurface
aL.TextXAlignment=Enum.TextXAlignment.Left
aL.Font=FONT_BOLD; aL.TextSize=16
local tL=Instance.new("TextLabel", authorCard)
tL.Size=UDim2.new(1,-32,0,22); tL.Position=UDim2.new(0,16,0,42)
tL.BackgroundTransparency=1; tL.TextColor3=M3.primary
tL.TextXAlignment=Enum.TextXAlignment.Left
tL.Font=FONT; tL.TextSize=14
local vL=Instance.new("TextLabel", authorCard)
vL.Size=UDim2.new(0.5,-32,0,18); vL.Position=UDim2.new(0,16,0,66)
vL.BackgroundTransparency=1; vL.TextColor3=M3.onSurfaceVar
vL.TextXAlignment=Enum.TextXAlignment.Left
vL.Font=FONT; vL.TextSize=12
local vBF=Instance.new("TextLabel", authorCard)
vBF.Size=UDim2.new(0.5,0,0,18); vBF.Position=UDim2.new(0.5,0,0,66)
vBF.BackgroundTransparency=1; vBF.TextColor3=M3.onSurfaceVar
vBF.TextTransparency=0.55
vBF.TextXAlignment=Enum.TextXAlignment.Left
vBF.Font=FONT_BOLD; vBF.TextSize=11
local roleLbl=Instance.new("TextLabel", authorCard)
roleLbl.Size=UDim2.new(1,-32,0,20); roleLbl.Position=UDim2.new(0,16,0,88)
roleLbl.BackgroundTransparency=1; roleLbl.TextColor3=M3.tertiary
roleLbl.TextXAlignment=Enum.TextXAlignment.Left
roleLbl.Font=FONT_BOLD; roleLbl.TextSize=12
onAccent(function() tL.TextColor3=M3.primary end)
local copyTg=Instance.new("TextButton", authorCard)
copyTg.Size=UDim2.new(0,140,0,30); copyTg.Position=UDim2.new(0,16,0,112)
copyTg.BackgroundColor3=M3.primaryCont; copyTg.TextColor3=M3.primary
copyTg.Font=FONT_BOLD; copyTg.TextSize=11; copyTg.BorderSizePixel=0
Instance.new("UICorner", copyTg).CornerRadius=UDim.new(1,0)
onAccent(function()
copyTg.BackgroundColor3=M3.primaryCont
copyTg.TextColor3=M3.primary
end)
regRefresh(function()
aL.Text=T("author"); tL.Text=T("tg")
vL.Text=T("version")..": "..VERSION
vBF.Text="bug fix "..BUGFIX
local r = getMyRoleCached()
local rs = T("roleUnknown")
if r == "murderer" then rs = T("murderer")
elseif r == "sheriff" then rs = T("sheriff")
elseif r == "innocent" then rs = T("roleInnocent") end
roleLbl.Text = T("role")..": "..rs
copyTg.Text=T("copy").." @listwork1"
end)

task.spawn(function()
while running do
task.wait(1.5)
if roleLbl and roleLbl.Parent then
roleCache.at = 0
local r = getMyRoleCached()
local rs = T("roleUnknown")
if r == "murderer" then rs = T("murderer")
elseif r == "sheriff" then rs = T("sheriff")
elseif r == "innocent" then rs = T("roleInnocent") end
roleLbl.Text = T("role")..": "..rs
end
end
end)

bindClick(copyTg, function()
if hasClipboard then safe(setclipboard, "listwork1") end
copyTg.Text=T("copied")
task.wait(1.5); copyTg.Text=T("copy").." @listwork1"
end)

mkDivider(pages.about, "lang")
local langRow=Instance.new("Frame", pages.about)
langRow.LayoutOrder = nextLO()
langRow.Size=UDim2.new(1,-8,0,48); langRow.BackgroundColor3=M3.surfaceCont
langRow.BorderSizePixel=0
Instance.new("UICorner", langRow).CornerRadius=UDim.new(0,16)
local ruBtn=Instance.new("TextButton", langRow)
ruBtn.Size=UDim2.new(0.5,-8,1,-12); ruBtn.Position=UDim2.new(0,4,0,6)
ruBtn.Text="Русский"; ruBtn.TextColor3=M3.onSurface
ruBtn.Font=FONT_BOLD; ruBtn.TextSize=13; ruBtn.BorderSizePixel=0
Instance.new("UICorner", ruBtn).CornerRadius=UDim.new(0,12)
local enBtn=Instance.new("TextButton", langRow)
enBtn.Size=UDim2.new(0.5,-8,1,-12); enBtn.Position=UDim2.new(0.5,4,0,6)
enBtn.Text="English"; enBtn.TextColor3=M3.onSurface
enBtn.Font=FONT_BOLD; enBtn.TextSize=13; enBtn.BorderSizePixel=0
Instance.new("UICorner", enBtn).CornerRadius=UDim.new(0,12)
regRefresh(function()
ruBtn.BackgroundColor3=CFG.lang=="RU" and M3.primaryCont or M3.surfaceHigh
enBtn.BackgroundColor3=CFG.lang=="EN" and M3.primaryCont or M3.surfaceHigh
end)
bindClick(ruBtn, function()
if CFG.lang~="RU" then CFG.lang="RU"; refreshAll() end
end)
bindClick(enBtn, function()
if CFG.lang~="EN" then CFG.lang="EN"; refreshAll() end
end)

mkDivider(pages.about, "accent")
local grid=Instance.new("Frame", pages.about)
grid.LayoutOrder = nextLO()
grid.Size=UDim2.new(1,-8,0,152); grid.BackgroundColor3=M3.surfaceCont
grid.BorderSizePixel=0
Instance.new("UICorner", grid).CornerRadius=UDim.new(0,16)
local gridLay=Instance.new("UIGridLayout", grid)
gridLay.CellSize=UDim2.new(0,32,0,32)
gridLay.CellPadding=UDim2.new(0,6,0,6)
gridLay.SortOrder=Enum.SortOrder.LayoutOrder
gridLay.HorizontalAlignment=Enum.HorizontalAlignment.Center
gridLay.VerticalAlignment=Enum.VerticalAlignment.Center
for i,c in ipairs(PALETTE) do
local b=Instance.new("TextButton", grid)
b.LayoutOrder=i; b.Size=UDim2.new(0,32,0,32)
b.BackgroundColor3=c; b.Text=""; b.BorderSizePixel=0
Instance.new("UICorner", b).CornerRadius=UDim.new(1,0)
bindClick(b, function() CFG.accent=c; applyAccent(c) end)
end

local opened=false
local function setOpen(v)
opened=v
Tween:Create(panel, TweenInfo.new(0.28,Enum.EasingStyle.Emphasized), {
Position=v and UDim2.new(0,90,0.5,-280)
or UDim2.new(0,-(panelW+60),0.5,-280)
}):Play()
end
bindClick(fab, function() setOpen(not opened) end)
bindClick(closeBtn, function() setOpen(false) end)

connect(UIS.InputBegan, function(i,g)
if g then return end
if i.KeyCodeEnum.KeyCode.F1 then
if S.farm then
S.farm = false; refreshAll()
else
if farmGuard(true) then S.farm = true; refreshAll() end
end
end
if i.KeyCodeEnum.KeyCode.RightShift then setOpen(not opened) end
end)

setActiveTab("combat")
applyAccent(CFG.accent)

if S.fullbright then setFullbright(true) end

GENV.LWH = {
state = S, farmCfg = FARM_CFG,
version = VERSION, bugfix = BUGFIX,
cleanup = function()
running = false
pcall(function() RunService:UnbindFromRenderStep("LWH_Aim") end)
for _,c in ipairs(conns) do pcall(function() c:Disconnect() end) end
if gui then pcall(function() gui:Destroy() end) end
if espFolder then pcall(function() espFolder:Destroy() end) end
if restore.fullbright then
for k,val in pairs(restore.fullbright) do
pcall(function() Lighting[k]=val end)
end
restore.fullbright = nil
end
for p in pairs(restore.noclip) do
if p and p.Parent then pcall(function() p.CanCollide=true end) end
end
for k in pairs(restore.noclip) do restore.noclip[k] = nil end
for p,sz in pairs(restore.hitbox) do
local hrp=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
if hrp then pcall(function() hrp.Size=sz; hrp.Transparency=0 end) end
end
for k in pairs(restore.hitbox) do restore.hitbox[k] = nil end
local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
if h and restore.walkspeed then h.WalkSpeed = restore.walkspeed end
restore.walkspeed = nil
for i = #pickupCandidates, 1, -1 do pickupCandidates[i] = nil end
end,
}

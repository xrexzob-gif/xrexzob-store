-- =====================================================
--          xrex zob - Premium Emote GUI v5
--   Auto-load emot & animasi dari 7yd7 GitHub
--   Tab EMOT & ANIMASI terpisah
--   Sticker bulat floating (klik buka/tutup)
--   Speed control emote/animasi
-- =====================================================

if _G.XRexZobRunning then return end
_G.XRexZobRunning = true

-- =====================================================
-- URL DATA (dari 7yd7 sniper-Emote repository)
-- =====================================================
local URL_EMOT = "https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/EmoteSniper.json"
local URL_ANIM = "https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/AnimationSniper.json"

-- =====================================================
-- ICON STICKER (ganti ID asset gambar lo di sini)
-- =====================================================
local STICKER_IMAGE = "rbxassetid://4483361525"

-- =====================================================
-- DATA FALLBACK (dipakai kalau GitHub gagal)
-- =====================================================
local FALLBACK_EMOTES = {
    {id=3360686498, name="Stadium"},   {id=3360692915, name="Tilt"},
    {id=3576968026, name="Shrug"},     {id=3360689775, name="Salute"},
    {id=507770239,  name="Wave"},      {id=507770677,  name="Cheer"},
    {id=507770818,  name="Laugh"},     {id=507771019,  name="Dance"},
    {id=507776043,  name="Dance2"},    {id=507777268,  name="Dance3"},
    {id=3576823,    name="Robot"},     {id=4052796268, name="Clapping"},
    {id=4197966900, name="Air Guitar"},{id=4806381674, name="Old School"},
    {id=5261950170, name="Samba"},     {id=5610118060, name="Breakdance"},
    {id=6056875955, name="Moonwalk"},  {id=6519551651, name="Headbang"},
    {id=7393164870, name="Floss"},     {id=7712012531, name="Dab"},
    {id=7831712567, name="Worm"},      {id=8158547440, name="Griddy"},
    {id=8308296113, name="Savage"},    {id=8472614831, name="Renegade"},
    {id=8639614157, name="Woah"},      {id=6637501979, name="Gangnam Style"},
}
local FALLBACK_ANIMS = {
    {id=507766388, name="Idle"},       {id=507777826, name="Walk"},
    {id=507767714, name="Run"},        {id=507765000, name="Jump"},
    {id=507767968, name="Fall"},       {id=507765644, name="Climb"},
    {id=507784897, name="Swim"},       {id=507785072, name="Swim Idle"},
    {id=2506281703,name="Sit"},        {id=182393478, name="Tool None"},
    {id=129631525, name="Tool Slash"}, {id=616906778, name="Ninja Walk"},
    {id=616945932, name="Ninja Idle"}, {id=616944091, name="Ninja Jump"},
    {id=616163682, name="Zombie Walk"},{id=616158929, name="Zombie Idle"},
    {id=616009598, name="Robot Walk"}, {id=616008369, name="Robot Idle"},
}

-- =====================================================
-- SERVICES
-- =====================================================
local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")
local HttpService      = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PAGE   = 15  -- kartu per halaman

-- =====================================================
-- STATE
-- =====================================================
local State = {
    tab         = "emot",
    EMOTES      = FALLBACK_EMOTES,
    ANIMATIONS  = FALLBACK_ANIMS,
    searchEmot  = "",
    searchAnim  = "",
    favEmot     = {},
    favAnim     = {},
    showFavEmot = false,
    showFavAnim = false,
    pageEmot    = 1,
    pageAnim    = 1,
    curTrack    = nil,
    speed       = 1,
    open        = true,
    loadingEmot = false,
    loadingAnim = false,
}

-- =====================================================
-- PLAY + SPEED
-- =====================================================
local function playAnim(id)
    local char = player.Character; if not char then return end
    local hum  = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local anim = hum:FindFirstChildOfClass("Animator"); if not anim then return end
    if State.curTrack then
        pcall(function() State.curTrack:Stop(); State.curTrack:Destroy() end)
        State.curTrack = nil
    end
    local obj = Instance.new("Animation")
    obj.AnimationId = "rbxassetid://" .. tostring(id)
    local ok, track = pcall(function() return anim:LoadAnimation(obj) end)
    if ok and track then
        track.Priority = Enum.AnimationPriority.Action
        track.Looped   = true
        track:Play()
        track:AdjustSpeed(State.speed)
        State.curTrack = track
    end
end

local function stopAnim()
    if State.curTrack then
        pcall(function() State.curTrack:Stop() end)
        State.curTrack = nil
    end
end

-- =====================================================
-- CLEAR OLD GUI
-- =====================================================
local OLD = CoreGui:FindFirstChild("XRexZobGUI")
if OLD then OLD:Destroy() end

local Screen = Instance.new("ScreenGui")
Screen.Name="XRexZobGUI"; Screen.ResetOnSpawn=false
Screen.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; Screen.Parent=CoreGui

-- helpers
local function corner(r,p) Instance.new("UICorner",p).CornerRadius=UDim.new(0,r) end
local function stroke(col,th,p) local s=Instance.new("UIStroke",p); s.Color=col; s.Thickness=th end

-- WARNA
local C_BG     = Color3.fromRGB(13,13,18)
local C_HDR    = Color3.fromRGB(20,20,28)
local C_CARD   = Color3.fromRGB(30,18,54)
local C_PURPLE = Color3.fromRGB(115,45,215)
local C_BORDER = Color3.fromRGB(45,35,75)
local C_ORANGE = Color3.fromRGB(245,155,35)
local C_WHITE  = Color3.new(1,1,1)
local C_GRAY   = Color3.fromRGB(155,155,175)
local C_GOLD   = Color3.fromRGB(255,210,0)
local C_GREEN  = Color3.fromRGB(50,200,100)
local C_RED    = Color3.fromRGB(220,55,55)
local C_DKPURP = Color3.fromRGB(28,20,50)

-- =====================================================
-- STICKER (tombol bulat floating)
-- =====================================================
local Sticker = Instance.new("ImageButton")
Sticker.Name="Sticker"; Sticker.Size=UDim2.new(0,54,0,54)
Sticker.Position=UDim2.new(0.5,-27,0.07,0)
Sticker.Image=STICKER_IMAGE
Sticker.BackgroundColor3=Color3.fromRGB(20,12,36); Sticker.BorderSizePixel=0
Sticker.ZIndex=10; Sticker.Parent=Screen; corner(999,Sticker)
local StickerStroke = Instance.new("UIStroke",Sticker)
StickerStroke.Color=C_PURPLE; StickerStroke.Thickness=2.5

local StickerLbl=Instance.new("TextLabel")
StickerLbl.Size=UDim2.new(0,62,0,14); StickerLbl.Position=UDim2.new(0.5,-31,1,3)
StickerLbl.BackgroundTransparency=1; StickerLbl.Text="xrex zob"
StickerLbl.TextColor3=Color3.fromRGB(200,180,255); StickerLbl.Font=Enum.Font.GothamBold
StickerLbl.TextSize=8; StickerLbl.ZIndex=10; StickerLbl.Parent=Sticker

-- =====================================================
-- MAIN FRAME
-- =====================================================
local Main=Instance.new("Frame")
Main.Name="Main"; Main.Size=UDim2.new(0,680,0,620)
Main.Position=UDim2.new(0.5,-340,0.5,-310)
Main.BackgroundColor3=C_BG; Main.BackgroundTransparency=0.04
Main.BorderSizePixel=0; Main.ClipsDescendants=true; Main.Parent=Screen
corner(14,Main); stroke(C_BORDER,1.5,Main)

-- â”€â”€ HEADER â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local Hdr=Instance.new("Frame")
Hdr.Size=UDim2.new(1,0,0,58); Hdr.BackgroundColor3=C_HDR; Hdr.BorderSizePixel=0; Hdr.Parent=Main
corner(14,Hdr)
-- patch bawah
local HP=Instance.new("Frame",Hdr); HP.Size=UDim2.new(1,0,0,14); HP.Position=UDim2.new(0,0,1,-14)
HP.BackgroundColor3=C_HDR; HP.BorderSizePixel=0

-- icon kecil
local HIcon=Instance.new("ImageLabel")
HIcon.Size=UDim2.new(0,28,0,28); HIcon.Position=UDim2.new(0,12,0.5,-14)
HIcon.BackgroundTransparency=1; HIcon.Image=STICKER_IMAGE; HIcon.Parent=Hdr

-- title
local HTitle=Instance.new("TextLabel")
HTitle.Size=UDim2.new(0,220,1,0); HTitle.Position=UDim2.new(0,46,0,0)
HTitle.BackgroundTransparency=1; HTitle.Text="EMOTES | xrex zob"
HTitle.TextColor3=C_ORANGE; HTitle.Font=Enum.Font.GothamBold
HTitle.TextSize=16; HTitle.TextXAlignment=Enum.TextXAlignment.Left; HTitle.Parent=Hdr

-- search box
local SBox=Instance.new("TextBox")
SBox.Size=UDim2.new(0,178,0,32); SBox.Position=UDim2.new(0,272,0.5,-16)
SBox.BackgroundColor3=Color3.fromRGB(22,22,30); SBox.BorderSizePixel=0
SBox.PlaceholderText="Cari emote..."; SBox.PlaceholderColor3=Color3.fromRGB(100,85,150)
SBox.Text=""; SBox.TextColor3=C_WHITE; SBox.Font=Enum.Font.Gotham; SBox.TextSize=12
SBox.ClearTextOnFocus=false; SBox.Parent=Hdr; corner(8,SBox)
stroke(Color3.fromRGB(40,40,58),1,SBox)

-- FAV
local FavBtn=Instance.new("TextButton")
FavBtn.Size=UDim2.new(0,44,0,32); FavBtn.Position=UDim2.new(0,454,0.5,-16)
FavBtn.BackgroundColor3=Color3.fromRGB(36,28,52); FavBtn.BorderSizePixel=0
FavBtn.Text="FAV"; FavBtn.TextColor3=C_GOLD
FavBtn.Font=Enum.Font.GothamBold; FavBtn.TextSize=11; FavBtn.Parent=Hdr; corner(6,FavBtn)

-- STOP
local StopBtn=Instance.new("TextButton")
StopBtn.Size=UDim2.new(0,50,0,32); StopBtn.Position=UDim2.new(0,502,0.5,-16)
StopBtn.BackgroundColor3=Color3.fromRGB(48,18,18); StopBtn.BorderSizePixel=0
StopBtn.Text="STOP"; StopBtn.TextColor3=C_RED
StopBtn.Font=Enum.Font.GothamBold; StopBtn.TextSize=11; StopBtn.Parent=Hdr; corner(6,StopBtn)

-- CLOSE X
local CloseBtn=Instance.new("TextButton")
CloseBtn.Size=UDim2.new(0,36,0,32); CloseBtn.Position=UDim2.new(1,-42,0.5,-16)
CloseBtn.BackgroundColor3=Color3.fromRGB(50,50,62); CloseBtn.BorderSizePixel=0
CloseBtn.Text="X"; CloseBtn.TextColor3=C_WHITE
CloseBtn.Font=Enum.Font.GothamBold; CloseBtn.TextSize=14; CloseBtn.Parent=Hdr; corner(6,CloseBtn)

-- â”€â”€ TAB BAR â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local TabBar=Instance.new("Frame")
TabBar.Size=UDim2.new(1,0,0,40); TabBar.Position=UDim2.new(0,0,0,58)
TabBar.BackgroundColor3=C_HDR; TabBar.BorderSizePixel=0; TabBar.Parent=Main

local TabEmot=Instance.new("TextButton")
TabEmot.Size=UDim2.new(0.5,-3,0,32); TabEmot.Position=UDim2.new(0,2,0,4)
TabEmot.BackgroundColor3=C_PURPLE; TabEmot.BorderSizePixel=0
TabEmot.Text="EMOT"; TabEmot.TextColor3=C_WHITE
TabEmot.Font=Enum.Font.GothamBold; TabEmot.TextSize=14; TabEmot.Parent=TabBar; corner(7,TabEmot)

local TabAnim=Instance.new("TextButton")
TabAnim.Size=UDim2.new(0.5,-3,0,32); TabAnim.Position=UDim2.new(0.5,1,0,4)
TabAnim.BackgroundColor3=C_DKPURP; TabAnim.BorderSizePixel=0
TabAnim.Text="ANIMASI"; TabAnim.TextColor3=C_GRAY
TabAnim.Font=Enum.Font.GothamBold; TabAnim.TextSize=14; TabAnim.Parent=TabBar; corner(7,TabAnim)

-- â”€â”€ SPEED BAR â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local SpeedBar=Instance.new("Frame")
SpeedBar.Size=UDim2.new(1,0,0,36); SpeedBar.Position=UDim2.new(0,0,0,98)
SpeedBar.BackgroundColor3=C_DKPURP; SpeedBar.BorderSizePixel=0; SpeedBar.Parent=Main

local SpeedLbl=Instance.new("TextLabel")
SpeedLbl.Size=UDim2.new(0,110,1,0); SpeedLbl.Position=UDim2.new(0,10,0,0)
SpeedLbl.BackgroundTransparency=1; SpeedLbl.Text="Kecepatan Emot:"
SpeedLbl.TextColor3=C_GRAY; SpeedLbl.Font=Enum.Font.GothamBold; SpeedLbl.TextSize=12
SpeedLbl.TextXAlignment=Enum.TextXAlignment.Left; SpeedLbl.Parent=SpeedBar

-- tombol - 
local BtnSlow=Instance.new("TextButton")
BtnSlow.Size=UDim2.new(0,30,0,26); BtnSlow.Position=UDim2.new(0,120,0.5,-13)
BtnSlow.BackgroundColor3=Color3.fromRGB(40,30,65); BtnSlow.BorderSizePixel=0
BtnSlow.Text="-"; BtnSlow.TextColor3=C_WHITE; BtnSlow.Font=Enum.Font.GothamBold; BtnSlow.TextSize=16
BtnSlow.Parent=SpeedBar; corner(5,BtnSlow)

-- speed display box
local SpeedBox=Instance.new("TextBox")
SpeedBox.Size=UDim2.new(0,56,0,26); SpeedBox.Position=UDim2.new(0,154,0.5,-13)
SpeedBox.BackgroundColor3=Color3.fromRGB(22,18,36); SpeedBox.BorderSizePixel=0
SpeedBox.Text="1"; SpeedBox.TextColor3=C_ORANGE
SpeedBox.Font=Enum.Font.GothamBold; SpeedBox.TextSize=14; SpeedBox.TextXAlignment=Enum.TextXAlignment.Center
SpeedBox.Parent=SpeedBar; corner(6,SpeedBox)
stroke(C_PURPLE,1,SpeedBox)

-- tombol +
local BtnFast=Instance.new("TextButton")
BtnFast.Size=UDim2.new(0,30,0,26); BtnFast.Position=UDim2.new(0,214,0.5,-13)
BtnFast.BackgroundColor3=Color3.fromRGB(40,30,65); BtnFast.BorderSizePixel=0
BtnFast.Text="+"; BtnFast.TextColor3=C_WHITE; BtnFast.Font=Enum.Font.GothamBold; BtnFast.TextSize=16
BtnFast.Parent=SpeedBar; corner(5,BtnFast)

-- preset speed buttons
local PRESETS = {{t="0.5x",v=0.5},{t="1x",v=1},{t="1.5x",v=1.5},{t="2x",v=2},{t="3x",v=3}}
for i,pr in ipairs(PRESETS) do
    local pb=Instance.new("TextButton")
    pb.Size=UDim2.new(0,40,0,22); pb.Position=UDim2.new(0,250+(i-1)*46,0.5,-11)
    pb.BackgroundColor3=Color3.fromRGB(36,26,58); pb.BorderSizePixel=0
    pb.Text=pr.t; pb.TextColor3=Color3.fromRGB(190,170,240)
    pb.Font=Enum.Font.GothamBold; pb.TextSize=10; pb.Parent=SpeedBar; corner(5,pb)
    local pv=pr.v
    pb.MouseButton1Click:Connect(function()
        State.speed=pv; SpeedBox.Text=tostring(pv)
        if State.curTrack then pcall(function() State.curTrack:AdjustSpeed(pv) end) end
    end)
end

-- status label (loading, error)
local StatusLbl=Instance.new("TextLabel")
StatusLbl.Size=UDim2.new(1,-20,0,20); StatusLbl.Position=UDim2.new(0,10,0,134)
StatusLbl.BackgroundTransparency=1; StatusLbl.Text=""
StatusLbl.TextColor3=C_GREEN; StatusLbl.Font=Enum.Font.Gotham; StatusLbl.TextSize=11
StatusLbl.TextXAlignment=Enum.TextXAlignment.Left; StatusLbl.Visible=false; StatusLbl.Parent=Main

-- â”€â”€ GRID SCROLL â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local GScroll=Instance.new("ScrollingFrame")
GScroll.Size=UDim2.new(1,-16,1,-202); GScroll.Position=UDim2.new(0,8,0,138)
GScroll.BackgroundTransparency=1; GScroll.BorderSizePixel=0
GScroll.ScrollBarThickness=3; GScroll.ScrollBarImageColor3=Color3.fromRGB(120,90,230)
GScroll.CanvasSize=UDim2.new(0,0,0,0); GScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
GScroll.Parent=Main

local GL=Instance.new("UIGridLayout",GScroll)
GL.CellSize=UDim2.new(0,118,0,158); GL.CellPadding=UDim2.new(0,7,0,8)
GL.HorizontalAlignment=Enum.HorizontalAlignment.Center; GL.SortOrder=Enum.SortOrder.LayoutOrder

do local gp=Instance.new("UIPadding",GScroll)
   gp.PaddingTop=UDim.new(0,8); gp.PaddingBottom=UDim.new(0,8) end

-- â”€â”€ BOTTOM NAV â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local BBar=Instance.new("Frame")
BBar.Size=UDim2.new(1,0,0,52); BBar.Position=UDim2.new(0,0,1,-52)
BBar.BackgroundColor3=C_HDR; BBar.BorderSizePixel=0; BBar.Parent=Main

local BPrev=Instance.new("TextButton")
BPrev.Size=UDim2.new(0,88,0,36); BPrev.Position=UDim2.new(0,10,0.5,-18)
BPrev.BackgroundColor3=Color3.fromRGB(38,28,62); BPrev.BorderSizePixel=0
BPrev.Text="< Prev"; BPrev.TextColor3=C_WHITE
BPrev.Font=Enum.Font.GothamBold; BPrev.TextSize=13; BPrev.Parent=BBar; corner(7,BPrev)

local PageLbl=Instance.new("TextLabel")
PageLbl.Size=UDim2.new(0,140,1,0); PageLbl.Position=UDim2.new(0.5,-70,0,0)
PageLbl.BackgroundTransparency=1; PageLbl.Text="Hal 1 / 1"
PageLbl.TextColor3=Color3.fromRGB(180,165,220); PageLbl.Font=Enum.Font.GothamBold; PageLbl.TextSize=13
PageLbl.Parent=BBar

local BNext=Instance.new("TextButton")
BNext.Size=UDim2.new(0,88,0,36); BNext.Position=UDim2.new(1,-98,0.5,-18)
BNext.BackgroundColor3=Color3.fromRGB(38,28,62); BNext.BorderSizePixel=0
BNext.Text="Next >"; BNext.TextColor3=C_WHITE
BNext.Font=Enum.Font.GothamBold; BNext.TextSize=13; BNext.Parent=BBar; corner(7,BNext)

-- Reload button
local ReloadBtn=Instance.new("TextButton")
ReloadBtn.Size=UDim2.new(0,68,0,30); ReloadBtn.Position=UDim2.new(0.5,52,0.5,-15)
ReloadBtn.BackgroundColor3=Color3.fromRGB(20,40,25); ReloadBtn.BorderSizePixel=0
ReloadBtn.Text="Reload"; ReloadBtn.TextColor3=C_GREEN
ReloadBtn.Font=Enum.Font.GothamBold; ReloadBtn.TextSize=11; ReloadBtn.Parent=BBar; corner(6,ReloadBtn)

-- =====================================================
-- DRAG (header drag main, sticker drag diri sendiri)
-- =====================================================
local function makeDrag(handle, target)
    local dr,ds,dp=false,nil,nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dr=true; ds=i.Position; dp=target.Position end end)
    UserInputService.InputChanged:Connect(function(i)
        if dr and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-ds
            target.Position=UDim2.new(dp.X.Scale,dp.X.Offset+d.X,dp.Y.Scale,dp.Y.Offset+d.Y) end end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dr=false end end)
end
makeDrag(Hdr, Main)

-- sticker drag + klik toggle
do
    local dr,ds,dp,moved=false,nil,nil,false
    Sticker.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dr=true; moved=false; ds=i.Position; dp=Sticker.Position end end)
    UserInputService.InputChanged:Connect(function(i)
        if dr and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-ds
            if math.abs(d.X)>5 or math.abs(d.Y)>5 then moved=true end
            Sticker.Position=UDim2.new(dp.X.Scale,dp.X.Offset+d.X,dp.Y.Scale,dp.Y.Offset+d.Y) end end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            if not moved then
                State.open=not State.open; Main.Visible=State.open
                StickerStroke.Color = State.open and C_PURPLE or Color3.fromRGB(70,70,90)
            end
            dr=false end end)
end

CloseBtn.MouseButton1Click:Connect(function()
    State.open=false; Main.Visible=false
    StickerStroke.Color=Color3.fromRGB(70,70,90)
end)

-- =====================================================
-- STATUS HELPER
-- =====================================================
local function showStatus(msg, col, secs)
    StatusLbl.Text=msg; StatusLbl.TextColor3=col or C_GREEN; StatusLbl.Visible=true
    task.delay(secs or 4, function()
        pcall(function() if StatusLbl.Text==msg then StatusLbl.Visible=false end end) end)
end

-- =====================================================
-- RENDER GRID
-- =====================================================
local function getList()
    local isE  = State.tab=="emot"
    local raw  = isE and State.EMOTES or State.ANIMATIONS
    local srch = (isE and State.searchEmot or State.searchAnim):lower()
    local fav  = isE and State.favEmot or State.favAnim
    local sf   = isE and State.showFavEmot or State.showFavAnim
    local out  = {}
    for _,item in ipairs(raw) do
        local nm=(item.name or ""):lower()
        if (srch=="" or nm:find(srch,1,true)) and (not sf or fav[item.id]) then
            table.insert(out,item) end end
    return out
end

local function totalPages(l) return math.max(1,math.ceil(#l/PAGE)) end

local function renderGrid()
    for _,c in ipairs(GScroll:GetChildren()) do
        if not c:IsA("UIGridLayout") and not c:IsA("UIPadding") then c:Destroy() end end

    local isE = State.tab=="emot"
    local fav = isE and State.favEmot or State.favAnim
    local lst = getList()
    local tp  = totalPages(lst)
    local cur = isE and State.pageEmot or State.pageAnim
    cur=math.max(1,math.min(cur,tp))
    if isE then State.pageEmot=cur else State.pageAnim=cur end
    PageLbl.Text="Hal "..cur.." / "..tp

    local s=(cur-1)*PAGE+1
    local e=math.min(cur*PAGE,#lst)

    for i=s,e do
        local item=lst[i]; if not item then break end
        local iid=item.id

        -- KARTU
        local Card=Instance.new("Frame")
        Card.BackgroundColor3=C_CARD; Card.BorderSizePixel=0
        Card.LayoutOrder=i; Card.Parent=GScroll; corner(9,Card)
        do local cs=Instance.new("UIStroke",Card)
           cs.Color=Color3.fromRGB(55,35,90); cs.Thickness=1 end

        -- FAV badge
        local isFav=fav[iid]==true
        local FB=Instance.new("TextButton")
        FB.Size=UDim2.new(0,34,0,20); FB.Position=UDim2.new(0,2,0,3)
        FB.BackgroundColor3=isFav and Color3.fromRGB(58,46,12) or Color3.fromRGB(32,22,52)
        FB.BorderSizePixel=0; FB.Text=isFav and "FAV" or "fav"
        FB.TextColor3=isFav and C_GOLD or C_GRAY
        FB.Font=Enum.Font.GothamBold; FB.TextSize=9; FB.ZIndex=4; FB.Parent=Card; corner(4,FB)
        FB.MouseButton1Click:Connect(function()
            if fav[iid] then fav[iid]=nil; FB.Text="fav"; FB.TextColor3=C_GRAY
                FB.BackgroundColor3=Color3.fromRGB(32,22,52)
            else fav[iid]=true; FB.Text="FAV"; FB.TextColor3=C_GOLD
                FB.BackgroundColor3=Color3.fromRGB(58,46,12) end end)

        -- THUMBNAIL
        local TF=Instance.new("Frame")
        TF.Size=UDim2.new(1,-12,0,80); TF.Position=UDim2.new(0,6,0,26)
        TF.BackgroundColor3=Color3.fromRGB(16,10,28); TF.BorderSizePixel=0
        TF.Parent=Card; corner(7,TF)

        local Thumb=Instance.new("ImageLabel",TF)
        Thumb.Size=UDim2.new(1,0,1,0); Thumb.BackgroundTransparency=1
        Thumb.Image="rbxthumb://type=Asset&id="..tostring(iid).."&w=150&h=150"
        Thumb.ScaleType=Enum.ScaleType.Fit

        -- NAMA
        local Nm=Instance.new("TextLabel")
        Nm.Size=UDim2.new(1,-6,0,26); Nm.Position=UDim2.new(0,3,0,108)
        Nm.BackgroundTransparency=1; Nm.Text=item.name or "?"
        Nm.TextColor3=Color3.fromRGB(228,218,248); Nm.Font=Enum.Font.GothamMedium; Nm.TextSize=9
        Nm.TextWrapped=true; Nm.Parent=Card

        -- MAINKAN
        local Pl=Instance.new("TextButton")
        Pl.Size=UDim2.new(0.84,0,0,20); Pl.Position=UDim2.new(0.08,0,1,-24)
        Pl.BackgroundColor3=C_PURPLE; Pl.BorderSizePixel=0
        Pl.Text="Mainkan"; Pl.TextColor3=C_WHITE
        Pl.Font=Enum.Font.GothamBold; Pl.TextSize=9; Pl.ZIndex=4; Pl.Parent=Card; corner(4,Pl)
        Pl.MouseButton1Click:Connect(function()
            playAnim(iid); Pl.BackgroundColor3=C_GREEN
            task.delay(0.6,function() pcall(function() Pl.BackgroundColor3=C_PURPLE end) end) end)
    end
end

-- =====================================================
-- TAB SWITCH
-- =====================================================
local function switchTab(tab)
    State.tab=tab
    if tab=="emot" then
        TabEmot.BackgroundColor3=C_PURPLE; TabEmot.TextColor3=C_WHITE
        TabAnim.BackgroundColor3=C_DKPURP; TabAnim.TextColor3=C_GRAY
        SBox.PlaceholderText="Cari emote..."; SBox.Text=State.searchEmot
        HTitle.Text="EMOTES | xrex zob"
        FavBtn.TextColor3=State.showFavEmot and C_GOLD or C_GRAY
    else
        TabAnim.BackgroundColor3=C_PURPLE; TabAnim.TextColor3=C_WHITE
        TabEmot.BackgroundColor3=C_DKPURP; TabEmot.TextColor3=C_GRAY
        SBox.PlaceholderText="Cari animasi..."; SBox.Text=State.searchAnim
        HTitle.Text="ANIMASI | xrex zob"
        FavBtn.TextColor3=State.showFavAnim and C_GOLD or C_GRAY
    end
    renderGrid()
end

TabEmot.MouseButton1Click:Connect(function() switchTab("emot") end)
TabAnim.MouseButton1Click:Connect(function() switchTab("animasi") end)

-- =====================================================
-- SEARCH
-- =====================================================
SBox:GetPropertyChangedSignal("Text"):Connect(function()
    if State.tab=="emot" then State.searchEmot=SBox.Text; State.pageEmot=1
    else State.searchAnim=SBox.Text; State.pageAnim=1 end; renderGrid() end)

-- =====================================================
-- FAV TOGGLE
-- =====================================================
FavBtn.MouseButton1Click:Connect(function()
    if State.tab=="emot" then
        State.showFavEmot=not State.showFavEmot
        FavBtn.TextColor3=State.showFavEmot and C_GOLD or C_GRAY; State.pageEmot=1
    else
        State.showFavAnim=not State.showFavAnim
        FavBtn.TextColor3=State.showFavAnim and C_GOLD or C_GRAY; State.pageAnim=1
    end; renderGrid() end)

-- =====================================================
-- STOP
-- =====================================================
StopBtn.MouseButton1Click:Connect(function() stopAnim() end)

-- =====================================================
-- SPEED CONTROLS
-- =====================================================
local function applySpeed(v)
    v=math.max(0.1, math.min(10, v))
    State.speed=v
    SpeedBox.Text=string.format("%.1f",v)
    if State.curTrack then pcall(function() State.curTrack:AdjustSpeed(v) end) end
end

BtnSlow.MouseButton1Click:Connect(function()
    applySpeed(math.max(0.1, State.speed - 0.25)) end)
BtnFast.MouseButton1Click:Connect(function()
    applySpeed(math.min(10, State.speed + 0.25)) end)
SpeedBox.FocusLost:Connect(function()
    local v=tonumber(SpeedBox.Text); if v then applySpeed(v)
    else SpeedBox.Text=string.format("%.1f",State.speed) end end)

-- =====================================================
-- NAVIGASI HALAMAN
-- =====================================================
BPrev.MouseButton1Click:Connect(function()
    if State.tab=="emot" then State.pageEmot=math.max(1,State.pageEmot-1)
    else State.pageAnim=math.max(1,State.pageAnim-1) end; renderGrid() end)
BNext.MouseButton1Click:Connect(function()
    local tp=totalPages(getList())
    if State.tab=="emot" then State.pageEmot=math.min(tp,State.pageEmot+1)
    else State.pageAnim=math.min(tp,State.pageAnim+1) end; renderGrid() end)

-- =====================================================
-- GITHUB LOADER (format 7yd7: {data:[{id,name}]})
-- =====================================================
local function fetchData(url, onSuccess, label)
    task.spawn(function()
        showStatus("Loading "..label.." dari server...", C_ORANGE, 15)
        local ok,res=pcall(function() return game:HttpGet(url) end)
        if ok and res and res~="" then
            local ok2,decoded=pcall(function() return HttpService:JSONDecode(res) end)
            if ok2 and decoded then
                local list = decoded.data or decoded
                if type(list)=="table" and #list>0 then
                    local out={}
                    for _,item in ipairs(list) do
                        local id=tonumber(item.id)
                        if id and id>0 then
                            table.insert(out,{id=id, name=item.name or ("ID:"..id)})
                        end
                    end
                    if #out>0 then
                        onSuccess(out)
                        showStatus(label.." loaded: "..(#out).." item!", C_GREEN)
                        return
                    end
                end
            end
        end
        showStatus("Gagal load "..label..", pakai data default!", C_RED, 6)
    end)
end

local function loadAll()
    fetchData(URL_EMOT, function(d)
        State.EMOTES=d; State.pageEmot=1
        if State.tab=="emot" then renderGrid() end
    end, "Emote")
    fetchData(URL_ANIM, function(d)
        State.ANIMATIONS=d; State.pageAnim=1
        if State.tab=="animasi" then renderGrid() end
    end, "Animasi")
end

ReloadBtn.MouseButton1Click:Connect(loadAll)

-- =====================================================
-- INIT
-- =====================================================
switchTab("emot")
task.delay(0.5, loadAll)  -- auto-load saat script dijalankan

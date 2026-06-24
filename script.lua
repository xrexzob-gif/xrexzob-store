--[[
    xrex zob - Emote & Animasi GUI
    - Tab EMOT dan ANIMASI TERPISAH
    - Grid 5 kolom, kartu kotak
    - Tombol "Mainkan", bintang favorit, search
    - Bisa drag, minimize
    - Tidak ada yang dihapus
]]

if _G.XRexZobRunning then return end
_G.XRexZobRunning = true

local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PAGE   = 15  -- 15 per halaman (3 baris x 5 kolom)

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  DATA EMOT
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local EMOTES = {
    {name="Wave",                id=3576519},
    {name="Tilt",                id=3585369},
    {name="Shrug",               id=3576625},
    {name="Cheer",               id=3576517},
    {name="Salute",              id=3576690},
    {name="Point",               id=3576628},
    {name="Laugh",               id=3576567},
    {name="Dance",               id=3576516},
    {name="Dance2",              id=3576521},
    {name="Dance3",              id=3576524},
    {name="Stadium",             id=3576630},
    {name="Zombie Walk",         id=3576795},
    {name="Ninja Run",           id=616945806},
    {name="Robot",               id=3576823},
    {name="Superpose",           id=4849487550},
    {name="Hyped",               id=5915779043},
    {name="Bawl",                id=7715078963},
    {name="Confused",            id=7719258686},
    {name="Clapping",            id=4052796268},
    {name="Air Guitar",          id=4197966900},
    {name="Pop Lock",            id=4740219636},
    {name="Old School",          id=4806381674},
    {name="Spooky",              id=4925758807},
    {name="Samba",               id=5261950170},
    {name="Breakdance",          id=5610118060},
    {name="Flip",                id=5699995704},
    {name="Shuffle",             id=5915779043},
    {name="Moonwalk",            id=6056875955},
    {name="Splits",              id=6152312069},
    {name="Cartwheel",           id=6399178571},
    {name="Headbang",            id=6519551651},
    {name="Running Man",         id=6763252898},
    {name="Electric Slide",      id=6906211573},
    {name="Whip",                id=7019763349},
    {name="Nae Nae",             id=7225765484},
    {name="Floss",               id=7393164870},
    {name="Dab",                 id=7712012531},
    {name="Worm",                id=7831712567},
    {name="Griddy",              id=8158547440},
    {name="Savage",              id=8308296113},
    {name="Renegade",            id=8472614831},
    {name="Woah",                id=8639614157},
    {name="Macarena",            id=8808614889},
    {name="Thriller",            id=8979614789},
    {name="Harlem Shake",        id=9152614789},
    {name="Jump On It",          id=9325614789},
    {name="Gangnam Style",       id=6637501979},
    {name="Backflip",            id=5699995704},
    {name="Best Friends",        id=4608310012},
    {name="Twerk",               id=5004685692},
}

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  DATA ANIMASI
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local ANIMATIONS = {
    {name="Idle 1",              id=180435571},
    {name="Idle 2",              id=180435792},
    {name="Walk",                id=180426354},
    {name="Run",                 id=180426839},
    {name="Jump",                id=125750702},
    {name="Fall",                id=180436148},
    {name="Climb",               id=180436334},
    {name="Swim",                id=180436463},
    {name="Swim Idle",           id=180436922},
    {name="Sit",                 id=2506281703},
    {name="Tool None",           id=182393478},
    {name="Tool Slash",          id=129631525},
    {name="Tool Lunge",          id=129632391},
    {name="Ninja Walk",          id=616906778},
    {name="Ninja Idle",          id=616945932},
    {name="Ninja Jump",          id=616944091},
    {name="Ninja Fall",          id=616943774},
    {name="Zombie Walk",         id=616163682},
    {name="Zombie Idle",         id=616158929},
    {name="Robot Walk",          id=616009598},
    {name="Robot Idle",          id=616008369},
    {name="Superhero Idle",      id=616163682},
    {name="Superhero Walk",      id=616009598},
    {name="Superhero Run",       id=616906778},
    {name="Mage Walk",           id=616906778},
    {name="Pirate Idle",         id=616945932},
    {name="Pirate Walk",         id=616906778},
    {name="Werewolf Walk",       id=616906778},
    {name="Dragon Walk",         id=616163682},
    {name="Dragon Idle",         id=616158929},
    {name="Vampire Walk",        id=616009598},
    {name="Vampire Idle",        id=616008369},
    {name="Knight Walk",         id=616906778},
    {name="Elf Walk",            id=616163682},
    {name="Witch Walk",          id=616009598},
    {name="Alien Walk",          id=616906778},
    {name="Ghost Walk",          id=616163682},
    {name="Ghost Idle",          id=616158929},
    {name="Troll Walk",          id=616009598},
    {name="Troll Idle",          id=616008369},
    {name="Bunny Hop",           id=616906778},
    {name="Slide",               id=616906778},
    {name="Crouch Walk",         id=616163682},
    {name="Sneak Walk",          id=616158929},
    {name="Tip Toe Walk",        id=616009598},
    {name="Stumble Walk",        id=616008369},
    {name="Monkey Walk",         id=616906778},
    {name="Crab Walk",           id=616163682},
    {name="Bear Walk",           id=616158929},
    {name="Duck Walk",           id=616009598},
}

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  STATE
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local State = {
    tab         = "emot",
    searchEmot  = "",
    searchAnim  = "",
    favEmot     = {},
    favAnim     = {},
    showFavEmot = false,
    showFavAnim = false,
    pageEmot    = 1,
    pageAnim    = 1,
    curTrack    = nil,
}

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  PLAY ANIMATION
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local function playAnim(id)
    local char = player.Character
    if not char then return end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local anim = char:FindFirstChildOfClass("Animator")
              or hum:FindFirstChildOfClass("Animator")
    if not anim then return end

    if State.curTrack then
        pcall(function() State.curTrack:Stop() end)
        State.curTrack = nil
    end

    local animObj = Instance.new("Animation")
    animObj.AnimationId = "rbxassetid://" .. tostring(id)
    local ok, track = pcall(function() return anim:LoadAnimation(animObj) end)
    if ok and track then
        State.curTrack = track
        track:Play()
    end
end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  BUILD SCREEN GUI
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local OLD = CoreGui:FindFirstChild("XRexZobGUI")
if OLD then OLD:Destroy() end

local Screen = Instance.new("ScreenGui")
Screen.Name            = "XRexZobGUI"
Screen.ResetOnSpawn    = false
Screen.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
Screen.Parent          = CoreGui

-- â”€â”€ MAIN PANEL â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local Main = Instance.new("Frame")
Main.Name              = "Main"
Main.Size              = UDim2.new(0, 680, 0, 570)
Main.Position          = UDim2.new(0.5, -340, 0.5, -285)
Main.BackgroundColor3  = Color3.fromRGB(22, 22, 28)
Main.BorderSizePixel   = 0
Main.ClipsDescendants  = true
Main.Parent            = Screen

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent       = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color     = Color3.fromRGB(100, 50, 200)
MainStroke.Thickness = 2
MainStroke.Parent    = Main

-- â”€â”€ HEADER (drag + title + search + fav + stop) â”€â”€
local Header = Instance.new("Frame")
Header.Size             = UDim2.new(1, 0, 0, 54)
Header.Position         = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
Header.BorderSizePixel  = 0
Header.Parent           = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent       = Header

-- patch bawah header biar nyambung ke bawah
local HeaderPatch = Instance.new("Frame")
HeaderPatch.Size            = UDim2.new(1, 0, 0, 14)
HeaderPatch.Position        = UDim2.new(0, 0, 1, -14)
HeaderPatch.BackgroundColor3= Color3.fromRGB(28, 28, 36)
HeaderPatch.BorderSizePixel = 0
HeaderPatch.Parent          = Header

-- icon emot
local HeaderIcon = Instance.new("ImageLabel")
HeaderIcon.Size                = UDim2.new(0, 30, 0, 30)
HeaderIcon.Position            = UDim2.new(0, 12, 0.5, -15)
HeaderIcon.BackgroundTransparency = 1
HeaderIcon.Image               = "rbxassetid://7072706796"
HeaderIcon.Parent              = Header

-- title
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size              = UDim2.new(0, 160, 1, 0)
HeaderTitle.Position          = UDim2.new(0, 48, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text              = "EMOTES | xrex zob"
HeaderTitle.TextColor3        = Color3.fromRGB(200, 200, 255)
HeaderTitle.Font              = Enum.Font.GothamBold
HeaderTitle.TextSize          = 15
HeaderTitle.TextXAlignment    = Enum.TextXAlignment.Left
HeaderTitle.Parent            = Header

-- search box
local SearchBox = Instance.new("TextBox")
SearchBox.Size              = UDim2.new(0, 200, 0, 32)
SearchBox.Position          = UDim2.new(0, 215, 0.5, -16)
SearchBox.BackgroundColor3  = Color3.fromRGB(38, 38, 50)
SearchBox.BorderSizePixel   = 0
SearchBox.PlaceholderText   = "Search emotes..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(140, 120, 200)
SearchBox.Text              = ""
SearchBox.TextColor3        = Color3.new(1, 1, 1)
SearchBox.Font              = Enum.Font.Gotham
SearchBox.TextSize          = 13
SearchBox.ClearTextOnFocus  = false
SearchBox.Parent            = Header

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 8)
SearchCorner.Parent       = SearchBox

-- favorit star button
local FavBtn = Instance.new("TextButton")
FavBtn.Size              = UDim2.new(0, 38, 0, 38)
FavBtn.Position          = UDim2.new(0, 422, 0.5, -19)
FavBtn.BackgroundTransparency = 1
FavBtn.BorderSizePixel   = 0
FavBtn.Text              = "â˜†"
FavBtn.TextColor3        = Color3.fromRGB(220, 220, 60)
FavBtn.Font              = Enum.Font.GothamBold
FavBtn.TextSize          = 24
FavBtn.Parent            = Header

-- stop animasi
local StopBtn = Instance.new("TextButton")
StopBtn.Size             = UDim2.new(0, 36, 0, 32)
StopBtn.Position         = UDim2.new(0, 464, 0.5, -16)
StopBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 62)
StopBtn.BorderSizePixel  = 0
StopBtn.Text             = "â– "
StopBtn.TextColor3       = Color3.fromRGB(255, 80, 80)
StopBtn.Font             = Enum.Font.GothamBold
StopBtn.TextSize         = 16
StopBtn.Parent           = Header

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 6)
StopCorner.Parent       = StopBtn

-- minimize button
local MinBtn = Instance.new("TextButton")
MinBtn.Size             = UDim2.new(0, 36, 0, 32)
MinBtn.Position         = UDim2.new(1, -44, 0.5, -16)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 62)
MinBtn.BorderSizePixel  = 0
MinBtn.Text             = "â€”"
MinBtn.TextColor3       = Color3.new(1, 1, 1)
MinBtn.Font             = Enum.Font.GothamBold
MinBtn.TextSize         = 18
MinBtn.Parent           = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent       = MinBtn

-- â”€â”€ TAB BAR (EMOT | ANIMASI) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local TabBar = Instance.new("Frame")
TabBar.Size            = UDim2.new(1, 0, 0, 38)
TabBar.Position        = UDim2.new(0, 0, 0, 54)
TabBar.BackgroundColor3= Color3.fromRGB(28, 28, 36)
TabBar.BorderSizePixel = 0
TabBar.Parent          = Main

local TabEmot = Instance.new("TextButton")
TabEmot.Size             = UDim2.new(0.5, -2, 0, 30)
TabEmot.Position         = UDim2.new(0, 2, 0, 4)
TabEmot.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
TabEmot.BorderSizePixel  = 0
TabEmot.Text             = "ðŸ˜Š  EMOT"
TabEmot.TextColor3       = Color3.new(1, 1, 1)
TabEmot.Font             = Enum.Font.GothamBold
TabEmot.TextSize         = 13
TabEmot.Parent           = TabBar

local TabEmotCorner = Instance.new("UICorner")
TabEmotCorner.CornerRadius = UDim.new(0, 6)
TabEmotCorner.Parent       = TabEmot

local TabAnim = Instance.new("TextButton")
TabAnim.Size             = UDim2.new(0.5, -2, 0, 30)
TabAnim.Position         = UDim2.new(0.5, 0, 0, 4)
TabAnim.BackgroundColor3 = Color3.fromRGB(36, 36, 46)
TabAnim.BorderSizePixel  = 0
TabAnim.Text             = "ðŸŽ¬  ANIMASI"
TabAnim.TextColor3       = Color3.fromRGB(160, 160, 180)
TabAnim.Font             = Enum.Font.GothamBold
TabAnim.TextSize         = 13
TabAnim.Parent           = TabBar

local TabAnimCorner = Instance.new("UICorner")
TabAnimCorner.CornerRadius = UDim.new(0, 6)
TabAnimCorner.Parent       = TabAnim

-- â”€â”€ SCROLL GRID â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local GridScroll = Instance.new("ScrollingFrame")
GridScroll.Size                = UDim2.new(1, -10, 1, -148)
GridScroll.Position            = UDim2.new(0, 5, 0, 96)
GridScroll.BackgroundTransparency = 1
GridScroll.BorderSizePixel     = 0
GridScroll.ScrollBarThickness  = 4
GridScroll.ScrollBarImageColor3= Color3.fromRGB(100, 50, 200)
GridScroll.CanvasSize          = UDim2.new(0, 0, 0, 0)
GridScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
GridScroll.Parent              = Main

local GridLayout = Instance.new("UIGridLayout")
GridLayout.CellSize           = UDim2.new(0, 122, 0, 168)
GridLayout.CellPadding        = UDim2.new(0, 6, 0, 8)
GridLayout.HorizontalAlignment= Enum.HorizontalAlignment.Center
GridLayout.SortOrder          = Enum.SortOrder.LayoutOrder
GridLayout.Parent             = GridScroll

local GridPad = Instance.new("UIPadding")
GridPad.PaddingTop    = UDim.new(0, 8)
GridPad.PaddingBottom = UDim.new(0, 8)
GridPad.Parent        = GridScroll

-- â”€â”€ BOTTOM NAV â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local BottomBar = Instance.new("Frame")
BottomBar.Size            = UDim2.new(1, 0, 0, 46)
BottomBar.Position        = UDim2.new(0, 0, 1, -46)
BottomBar.BackgroundColor3= Color3.fromRGB(28, 28, 36)
BottomBar.BorderSizePixel = 0
BottomBar.Parent          = Main

local BtnPrev = Instance.new("TextButton")
BtnPrev.Size             = UDim2.new(0, 90, 0, 32)
BtnPrev.Position         = UDim2.new(0, 10, 0.5, -16)
BtnPrev.BackgroundColor3 = Color3.fromRGB(44, 44, 56)
BtnPrev.BorderSizePixel  = 0
BtnPrev.Text             = "â—€  Prev"
BtnPrev.TextColor3       = Color3.new(1, 1, 1)
BtnPrev.Font             = Enum.Font.GothamBold
BtnPrev.TextSize         = 13
BtnPrev.Parent           = BottomBar

local BtnPrevCorner = Instance.new("UICorner")
BtnPrevCorner.CornerRadius = UDim.new(0, 6)
BtnPrevCorner.Parent       = BtnPrev

local PageLabel = Instance.new("TextLabel")
PageLabel.Size              = UDim2.new(0, 140, 1, 0)
PageLabel.Position          = UDim2.new(0.5, -70, 0, 0)
PageLabel.BackgroundTransparency = 1
PageLabel.Text              = "Hal 1 / 1"
PageLabel.TextColor3        = Color3.fromRGB(180, 170, 210)
PageLabel.Font              = Enum.Font.GothamBold
PageLabel.TextSize          = 13
PageLabel.Parent            = BottomBar

local BtnNext = Instance.new("TextButton")
BtnNext.Size             = UDim2.new(0, 90, 0, 32)
BtnNext.Position         = UDim2.new(1, -100, 0.5, -16)
BtnNext.BackgroundColor3 = Color3.fromRGB(44, 44, 56)
BtnNext.BorderSizePixel  = 0
BtnNext.Text             = "Next  â–¶"
BtnNext.TextColor3       = Color3.new(1, 1, 1)
BtnNext.Font             = Enum.Font.GothamBold
BtnNext.TextSize         = 13
BtnNext.Parent           = BottomBar

local BtnNextCorner = Instance.new("UICorner")
BtnNextCorner.CornerRadius = UDim.new(0, 6)
BtnNextCorner.Parent       = BtnNext

-- â”€â”€ MINI BAR â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local MiniBar = Instance.new("Frame")
MiniBar.Name            = "MiniBar"
MiniBar.Size            = UDim2.new(0, 230, 0, 40)
MiniBar.Position        = Main.Position
MiniBar.BackgroundColor3= Color3.fromRGB(28, 28, 36)
MiniBar.BorderSizePixel = 0
MiniBar.Visible         = false
MiniBar.Parent          = Screen

local MiniCornerFrame = Instance.new("UICorner")
MiniCornerFrame.CornerRadius = UDim.new(0, 10)
MiniCornerFrame.Parent       = MiniBar

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color     = Color3.fromRGB(100, 50, 200)
MiniStroke.Thickness = 2
MiniStroke.Parent    = MiniBar

local MiniLabel = Instance.new("TextLabel")
MiniLabel.Size              = UDim2.new(1, -50, 1, 0)
MiniLabel.Position          = UDim2.new(0, 12, 0, 0)
MiniLabel.BackgroundTransparency = 1
MiniLabel.Text              = "ðŸ˜Š  xrex zob"
MiniLabel.TextColor3        = Color3.fromRGB(0, 230, 140)
MiniLabel.Font              = Enum.Font.GothamBold
MiniLabel.TextSize          = 14
MiniLabel.TextXAlignment    = Enum.TextXAlignment.Left
MiniLabel.Parent            = MiniBar

local MiniOpenBtn = Instance.new("TextButton")
MiniOpenBtn.Size             = UDim2.new(0, 36, 0, 30)
MiniOpenBtn.Position         = UDim2.new(1, -42, 0.5, -15)
MiniOpenBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 90)
MiniOpenBtn.BorderSizePixel  = 0
MiniOpenBtn.Text             = "â–²"
MiniOpenBtn.TextColor3       = Color3.new(1, 1, 1)
MiniOpenBtn.Font             = Enum.Font.GothamBold
MiniOpenBtn.TextSize         = 16
MiniOpenBtn.Parent           = MiniBar

local MiniOpenCorner = Instance.new("UICorner")
MiniOpenCorner.CornerRadius = UDim.new(0, 6)
MiniOpenCorner.Parent       = MiniOpenBtn

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  DRAG
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local function makeDraggable(handle, target, companion)
    local drag, ds, dp = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            ds   = i.Position
            dp   = target.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not drag then return end
        if i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        local d = i.Position - ds
        local np = UDim2.new(dp.X.Scale, dp.X.Offset + d.X, dp.Y.Scale, dp.Y.Offset + d.Y)
        target.Position = np
        if companion then companion.Position = np end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
end

makeDraggable(Header,  Main,    MiniBar)
makeDraggable(MiniBar, MiniBar, nil)

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  RENDER GRID
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local PURPLE  = Color3.fromRGB(100, 50, 200)
local DARK_BG = Color3.fromRGB(28, 28, 36)
local CARD_BG = Color3.fromRGB(30, 30, 40)

local function getList()
    local isEmot  = State.tab == "emot"
    local raw     = isEmot and EMOTES or ANIMATIONS
    local search  = isEmot and State.searchEmot or State.searchAnim
    local favSet  = isEmot and State.favEmot or State.favAnim
    local showFav = isEmot and State.showFavEmot or State.showFavAnim

    local out = {}
    for _, item in ipairs(raw) do
        local nameMatch = search == "" or item.name:lower():find(search:lower(), 1, true)
        local favMatch  = not showFav or favSet[item.id]
        if nameMatch and favMatch then
            table.insert(out, item)
        end
    end
    return out
end

local function totalPages(list)
    return math.max(1, math.ceil(#list / PAGE))
end

local function renderGrid()
    -- Hapus kartu lama saja (bukan layout)
    for _, c in ipairs(GridScroll:GetChildren()) do
        if not c:IsA("UIGridLayout") and not c:IsA("UIPadding") then
            c:Destroy()
        end
    end

    local isEmot  = State.tab == "emot"
    local favSet  = isEmot and State.favEmot or State.favAnim
    local curPage = isEmot and State.pageEmot or State.pageAnim
    local list    = getList()
    local tp      = totalPages(list)

    curPage = math.max(1, math.min(curPage, tp))
    if isEmot then State.pageEmot = curPage else State.pageAnim = curPage end

    PageLabel.Text = "Hal " .. curPage .. " / " .. tp

    local startI = (curPage - 1) * PAGE + 1
    local endI   = math.min(curPage * PAGE, #list)

    for i = startI, endI do
        local item = list[i]
        if not item then break end

        -- â”€â”€ KARTU â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        local Card = Instance.new("Frame")
        Card.BackgroundColor3 = CARD_BG
        Card.BorderSizePixel  = 0
        Card.LayoutOrder      = i
        Card.Parent           = GridScroll

        local CardCorner = Instance.new("UICorner")
        CardCorner.CornerRadius = UDim.new(0, 10)
        CardCorner.Parent       = Card

        local CardStroke = Instance.new("UIStroke")
        CardStroke.Color     = Color3.fromRGB(55, 55, 72)
        CardStroke.Thickness = 1
        CardStroke.Parent    = Card

        -- Bintang favorit
        local StarBtn = Instance.new("TextButton")
        StarBtn.Size              = UDim2.new(0, 26, 0, 26)
        StarBtn.Position          = UDim2.new(0, 4, 0, 4)
        StarBtn.BackgroundTransparency = 1
        StarBtn.BorderSizePixel   = 0
        StarBtn.Text              = favSet[item.id] and "â˜…" or "â˜†"
        StarBtn.TextColor3        = favSet[item.id]
                                    and Color3.fromRGB(255, 215, 0)
                                    or  Color3.fromRGB(160, 160, 170)
        StarBtn.Font              = Enum.Font.GothamBold
        StarBtn.TextSize          = 20
        StarBtn.ZIndex            = 4
        StarBtn.Parent            = Card

        local iid = item.id
        StarBtn.MouseButton1Click:Connect(function()
            if favSet[iid] then
                favSet[iid]          = nil
                StarBtn.Text         = "â˜†"
                StarBtn.TextColor3   = Color3.fromRGB(160, 160, 170)
            else
                favSet[iid]          = true
                StarBtn.Text         = "â˜…"
                StarBtn.TextColor3   = Color3.fromRGB(255, 215, 0)
            end
        end)

        -- Preview gambar
        local Img = Instance.new("ImageLabel")
        Img.Size              = UDim2.new(1, -12, 0, 88)
        Img.Position          = UDim2.new(0, 6, 0, 32)
        Img.BackgroundColor3  = Color3.fromRGB(22, 22, 30)
        Img.BorderSizePixel   = 0
        Img.Image             = "rbxthumb://type=Asset&id=" .. tostring(iid) .. "&w=150&h=150"
        Img.ScaleType         = Enum.ScaleType.Fit
        Img.Parent            = Card

        local ImgCorner = Instance.new("UICorner")
        ImgCorner.CornerRadius = UDim.new(0, 6)
        ImgCorner.Parent       = Img

        -- Nama emot/animasi
        local NameLbl = Instance.new("TextLabel")
        NameLbl.Size              = UDim2.new(1, -8, 0, 30)
        NameLbl.Position          = UDim2.new(0, 4, 0, 124)
        NameLbl.BackgroundTransparency = 1
        NameLbl.Text              = item.name
        NameLbl.TextColor3        = Color3.fromRGB(210, 205, 230)
        NameLbl.Font              = Enum.Font.Gotham
        NameLbl.TextSize          = 11
        NameLbl.TextWrapped       = true
        NameLbl.Parent            = Card

        -- Tombol MAINKAN
        local PlayBtn = Instance.new("TextButton")
        PlayBtn.Size             = UDim2.new(1, -12, 0, 28)
        PlayBtn.Position         = UDim2.new(0, 6, 1, -32)
        PlayBtn.BackgroundColor3 = PURPLE
        PlayBtn.BorderSizePixel  = 0
        PlayBtn.Text             = "Mainkan"
        PlayBtn.TextColor3       = Color3.new(1, 1, 1)
        PlayBtn.Font             = Enum.Font.GothamBold
        PlayBtn.TextSize         = 12
        PlayBtn.ZIndex           = 4
        PlayBtn.Parent           = Card

        local PlayCorner = Instance.new("UICorner")
        PlayCorner.CornerRadius = UDim.new(0, 6)
        PlayCorner.Parent       = PlayBtn

        PlayBtn.MouseButton1Click:Connect(function()
            playAnim(iid)
            PlayBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
            task.delay(0.5, function()
                PlayBtn.BackgroundColor3 = PURPLE
            end)
        end)
    end
end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  TAB SWITCH
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local function switchTab(tab)
    State.tab = tab
    if tab == "emot" then
        TabEmot.BackgroundColor3  = PURPLE
        TabEmot.TextColor3        = Color3.new(1, 1, 1)
        TabAnim.BackgroundColor3  = Color3.fromRGB(36, 36, 46)
        TabAnim.TextColor3        = Color3.fromRGB(160, 160, 180)
        SearchBox.PlaceholderText = "Search emotes..."
        SearchBox.Text            = State.searchEmot
        FavBtn.Text               = State.showFavEmot and "â˜…" or "â˜†"
        HeaderTitle.Text          = "EMOTES | xrex zob"
        MiniLabel.Text            = "ðŸ˜Š  xrex zob"
    else
        TabAnim.BackgroundColor3  = PURPLE
        TabAnim.TextColor3        = Color3.new(1, 1, 1)
        TabEmot.BackgroundColor3  = Color3.fromRGB(36, 36, 46)
        TabEmot.TextColor3        = Color3.fromRGB(160, 160, 180)
        SearchBox.PlaceholderText = "Search animasi..."
        SearchBox.Text            = State.searchAnim
        FavBtn.Text               = State.showFavAnim and "â˜…" or "â˜†"
        HeaderTitle.Text          = "ANIMASI | xrex zob"
        MiniLabel.Text            = "ðŸŽ¬  xrex zob"
    end
    renderGrid()
end

TabEmot.MouseButton1Click:Connect(function() switchTab("emot") end)
TabAnim.MouseButton1Click:Connect(function() switchTab("animasi") end)

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  SEARCH
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    if State.tab == "emot" then
        State.searchEmot = SearchBox.Text
        State.pageEmot   = 1
    else
        State.searchAnim = SearchBox.Text
        State.pageAnim   = 1
    end
    renderGrid()
end)

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  FAVORIT
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
FavBtn.MouseButton1Click:Connect(function()
    if State.tab == "emot" then
        State.showFavEmot = not State.showFavEmot
        FavBtn.Text       = State.showFavEmot and "â˜…" or "â˜†"
        State.pageEmot    = 1
    else
        State.showFavAnim = not State.showFavAnim
        FavBtn.Text       = State.showFavAnim and "â˜…" or "â˜†"
        State.pageAnim    = 1
    end
    renderGrid()
end)

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  STOP
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
StopBtn.MouseButton1Click:Connect(function()
    if State.curTrack then
        pcall(function() State.curTrack:Stop() end)
        State.curTrack = nil
    end
end)

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  NAVIGASI HALAMAN
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
BtnPrev.MouseButton1Click:Connect(function()
    if State.tab == "emot" then
        State.pageEmot = math.max(1, State.pageEmot - 1)
    else
        State.pageAnim = math.max(1, State.pageAnim - 1)
    end
    renderGrid()
end)

BtnNext.MouseButton1Click:Connect(function()
    local tp = totalPages(getList())
    if State.tab == "emot" then
        State.pageEmot = math.min(tp, State.pageEmot + 1)
    else
        State.pageAnim = math.min(tp, State.pageAnim + 1)
    end
    renderGrid()
end)

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  MINIMIZE / RESTORE
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
MinBtn.MouseButton1Click:Connect(function()
    Main.Visible    = false
    MiniBar.Visible = true
    MiniBar.Position = Main.Position
end)

MiniOpenBtn.MouseButton1Click:Connect(function()
    MiniBar.Visible = false
    Main.Visible    = true
end)

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  INIT
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
switchTab("emot")

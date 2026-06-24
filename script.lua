--[[
    xrex zob - Emote GUI Patch
    - Tombol KOTAK (bukan bulat)
    - Nama: xrex zob
    - Bisa diminimize & dikecilkan biar g nutupin layar
    - Bisa di-drag pindah posisi

    PENTING:
    - Script ini TIDAK menghapus apapun
    - Bagian EMOT dan ANIMASI tetap BEDA & UTUH
    - Script ini cuma nambahin title bar di atas GUI asli
    - Tombol dibuat kotak tapi isinya (emot/animasi) nggak berubah

    CARA PAKAI:
    1. Run dulu emote script lo sendiri (dari github lo)
    2. Baru run script ini sebagai patch
]]

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- =============================================
-- PATCH GUI: Bikin semua jadi KOTAK
-- =============================================
local function makeSquare(parent)
    if not parent then return end
    for _, v in ipairs(parent:GetDescendants()) do
        if v:IsA("UICorner") then
            v.CornerRadius = UDim.new(0, 0)
        end
    end
    local ownCorner = parent:FindFirstChildWhichIsA("UICorner")
    if ownCorner then
        ownCorner.CornerRadius = UDim.new(0, 0)
    end
end

-- =============================================
-- CARI GUI DI COREGUI
-- =============================================
local function findEmoteGUI()
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            local bg = gui:FindFirstChild("Background", true)
            local top = gui:FindFirstChild("Top", true)
            if bg or top then
                return gui
            end
        end
    end
    return nil
end

-- =============================================
-- TAMBAH TITLE BAR + MINIMIZE + RESIZE
-- =============================================
local function addMinimizeAndTitle(gui)
    if not gui then return end

    makeSquare(gui)

    local mainFrame = gui:FindFirstChild("Background", true)
    if not mainFrame then
        for _, v in ipairs(gui:GetDescendants()) do
            if v:IsA("Frame") and v.Size.X.Scale > 0.3 then
                mainFrame = v
                break
            end
        end
    end

    if not mainFrame then
        warn("xrex zob | Frame utama tidak ditemukan")
        return
    end

    -- Bersih dulu kalau udah pernah di-patch
    for _, name in ipairs({"XRexZobTitle", "XRexZobMinBtn", "XRexZobMinimized"}) do
        local old = gui:FindFirstChild(name)
        if old then old:Destroy() end
    end

    -- ========== TITLE BAR ==========
    local titleBar = Instance.new("Frame")
    titleBar.Name = "XRexZobTitle"
    titleBar.Size = UDim2.new(0, 220, 0, 26)
    titleBar.Position = UDim2.new(0, 0, 0, -28)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 200
    titleBar.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.new(0, 8, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "xrex zob"
    titleLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 201
    titleLabel.Parent = titleBar

    -- ========== TOMBOL RESIZE (biru) ==========
    local sizeBtn = Instance.new("TextButton")
    sizeBtn.Size = UDim2.new(0, 26, 0, 22)
    sizeBtn.Position = UDim2.new(1, -56, 0, 2)
    sizeBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 200)
    sizeBtn.BorderSizePixel = 0
    sizeBtn.Text = "âŠ¡"
    sizeBtn.TextColor3 = Color3.new(1, 1, 1)
    sizeBtn.Font = Enum.Font.GothamBold
    sizeBtn.TextSize = 13
    sizeBtn.ZIndex = 202
    sizeBtn.Parent = titleBar

    -- ========== TOMBOL MINIMIZE (merah) ==========
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "MinBtn"
    minBtn.Size = UDim2.new(0, 26, 0, 22)
    minBtn.Position = UDim2.new(1, -28, 0, 2)
    minBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    minBtn.BorderSizePixel = 0
    minBtn.Text = "â€”"
    minBtn.TextColor3 = Color3.new(1, 1, 1)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 14
    minBtn.ZIndex = 202
    minBtn.Parent = titleBar

    -- ========== MINIMIZED BAR ==========
    local minimizedBar = Instance.new("Frame")
    minimizedBar.Name = "XRexZobMinimized"
    minimizedBar.Size = UDim2.new(0, 120, 0, 26)
    minimizedBar.Position = mainFrame.Position + UDim2.new(0, 0, 0, -28)
    minimizedBar.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    minimizedBar.BorderSizePixel = 0
    minimizedBar.Visible = false
    minimizedBar.ZIndex = 300
    minimizedBar.Parent = mainFrame.Parent

    local minBarLabel = Instance.new("TextLabel")
    minBarLabel.Size = UDim2.new(1, -30, 1, 0)
    minBarLabel.Position = UDim2.new(0, 8, 0, 0)
    minBarLabel.BackgroundTransparency = 1
    minBarLabel.Text = "xrex zob"
    minBarLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    minBarLabel.Font = Enum.Font.GothamBold
    minBarLabel.TextSize = 12
    minBarLabel.TextXAlignment = Enum.TextXAlignment.Left
    minBarLabel.ZIndex = 301
    minBarLabel.Parent = minimizedBar

    local restoreBtn = Instance.new("TextButton")
    restoreBtn.Size = UDim2.new(0, 26, 0, 22)
    restoreBtn.Position = UDim2.new(1, -28, 0, 2)
    restoreBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    restoreBtn.BorderSizePixel = 0
    restoreBtn.Text = "â–²"
    restoreBtn.TextColor3 = Color3.new(1, 1, 1)
    restoreBtn.Font = Enum.Font.GothamBold
    restoreBtn.TextSize = 12
    restoreBtn.ZIndex = 302
    restoreBtn.Parent = minimizedBar

    -- ========== DRAG ==========
    local dragging = false
    local dragStart, startPos

    local function updateDrag(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        minimizedBar.Position = mainFrame.Position + UDim2.new(0, 0, 0, -28)
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = mainFrame.Position
        end
    end)
    minimizedBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = mainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then updateDrag(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- ========== MINIMIZE / RESTORE ==========
    minBtn.MouseButton1Click:Connect(function()
        minimizedBar.Position = mainFrame.Position + UDim2.new(0, 0, 0, -28)
        mainFrame.Visible = false
        minimizedBar.Visible = true
    end)
    restoreBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        minimizedBar.Visible = false
    end)

    -- ========== RESIZE ==========
    local isSmall = false
    local originalSize = mainFrame.Size
    local smallSize = UDim2.new(originalSize.X.Scale * 0.65, originalSize.X.Offset * 0.65, originalSize.Y.Scale * 0.65, originalSize.Y.Offset * 0.65)

    sizeBtn.MouseButton1Click:Connect(function()
        if not isSmall then
            isSmall = true
            mainFrame.Size = smallSize
            sizeBtn.Text = "âŠž"
        else
            isSmall = false
            mainFrame.Size = originalSize
            sizeBtn.Text = "âŠ¡"
        end
    end)

    print("xrex zob | Done! GUI kotak, bisa minimize & resize.")
end

-- =============================================
-- MAIN: Tunggu GUI muncul lalu patch
-- =============================================
local patchDone = false
local attempts = 0

task.spawn(function()
    while not patchDone and attempts < 30 do
        attempts = attempts + 1
        local gui = findEmoteGUI()
        if gui then
            addMinimizeAndTitle(gui)
            patchDone = true
            gui.DescendantAdded:Connect(function(v)
                if v:IsA("UICorner") then
                    task.wait(0.05)
                    v.CornerRadius = UDim.new(0, 0)
                end
            end)
        else
            task.wait(1)
        end
    end
    if not patchDone then
        warn("xrex zob | GUI emote tidak ditemukan. Pastiin emote script lo udah jalan dulu!")
    end
end)

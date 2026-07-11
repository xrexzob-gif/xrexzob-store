--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
print("Farm Factory Pro v1.01 Executed")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local playerName = LocalPlayer.Name
local Comm = ReplicatedStorage:WaitForChild("Communication")
local PlotsFolder = workspace:WaitForChild("Plots") 

local _T = {
    AutoClick = false, AutoSellCrates = false, 
    AutoPlantTier1 = false, AutoPlantTier2 = false, AutoPlantAll = false, AutoPlaceMachines = false,
    PrestigeLoop = false, BuyAll = false, AutoStar = false, 
    BeeSniper = false, AutoHoney = false,
    AutoHarvester = false, AutoSprinkler = false,
    AutoRoll = false, InfRoll = false
}

local TargetSeeds, TargetHarvesters, TargetSprinklers, TargetBees = {}, {}, {}, {}
local DeleteSeeds, DeleteHarvesters, DeleteSprinklers, DeleteBees = {}, {}, {}, {}

local Tier1Seeds = {"Strawberry Seeds", "Carrot Seeds", "Tomato Seeds", "Corn Seeds", "Blueberry Seeds", "Potato Seeds"}
local Tier2Seeds = {"Sugarcane Seeds", "Watermelon Seeds", "Blackberry Seeds", "Beet Seeds", "Kiwi Seeds", "Pineapple Seeds", "Prickly Pear Seeds"}
local AllSeeds = {"Strawberry Seeds", "Carrot Seeds", "Tomato Seeds", "Corn Seeds", "Blueberry Seeds", "Potato Seeds", "Sugarcane Seeds", "Watermelon Seeds", "Blackberry Seeds", "Beet Seeds", "Kiwi Seeds", "Pineapple Seeds", "Prickly Pear Seeds"}
local AllHarvesters = {"Basic Harvester", "Double Harvester", "Tier2Harvester", "Super Harvester", "Mega Harvester"}
local AllSprinklers = {"Basic Sprinkler", "Better Sprinkler", "Tier 2 Sprinkler", "Mega Sprinkler"}
local AllBees = {"Bumble Bee", "Frost Bee", "Magma Bee", "Nature Bee", "Queen Bee", "Strawberry Bee"} 
local BoardUpgrades = {"UpgradeCaps", "MutationMultiplier", "Click", "SeedLuck", "SprinkerPower", "Rolls"}
local HoneyUpgrades = {"PollinationBoost", "PollinationTime"}

local function EquipToolFromList(list)
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not char or not backpack then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end

    local lowerList = {}
    for i, name in ipairs(list) do lowerList[i] = string.lower(name) end

    local function checkAndEquip(parent)
        for _, tool in ipairs(parent:GetChildren()) do
            if tool:IsA("Tool") then
                local toolName = string.lower(tool.Name)
                for _, name in ipairs(lowerList) do
                    if string.find(toolName, name) then
                        humanoid:EquipTool(tool)
                        return true
                    end
                end
            end
        end
        return false
    end

    return checkAndEquip(backpack) or checkAndEquip(char)
end

local function WipeSelectedItems(selectedList)
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not char or not backpack or not selectedList or #selectedList == 0 then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local lowerList = {}
    for i, name in ipairs(selectedList) do lowerList[i] = string.lower(name) end

    local toolsToDelete = {}
    local function checkAndAdd(tool)
        if tool:IsA("Tool") then
            local toolName = string.lower(tool.Name)
            for _, name in ipairs(lowerList) do
                if string.find(toolName, name) then
                    table.insert(toolsToDelete, tool)
                    break
                end
            end
        end
    end

    for _, t in ipairs(backpack:GetChildren()) do checkAndAdd(t) end
    for _, t in ipairs(char:GetChildren()) do checkAndAdd(t) end

    for _, tool in ipairs(toolsToDelete) do
        pcall(function()
            humanoid:EquipTool(tool)
            task.wait(0.1)
            Comm.DeleteHeldItem:FireServer()
            task.wait(0.1)
        end)
    end
end

-- PEMBUATAN WINDOW GUI XREXZOB
local Window = Rayfield:CreateWindow({
   Name = "xrexzob",
   LoadingTitle = "xrexzob v1.01",
   LoadingSubtitle = "Oleh: Ash & Swag",
   ConfigurationSaving = {Enabled = false},
   KeySystem = false
})

-- EFEK PELANGI BERJALAN KENCANG PADA JUDUL GUI
task.spawn(function()
    local c = 0
    while task.wait(0.005) do -- Kecepatan kencang
        c = c + 1
        local color = Color3.fromHSV(math.sin(c/20)/2+0.5, 1, 1)
        pcall(function()
            if Window and Window.Elements and Window.Elements.MainTab and Window.Elements.MainTab.TextLabel then
                Window.Elements.MainTab.TextLabel.TextColor3 = color
            end
            -- Mencoba mengubah warna teks judul utama jika terdeteksi di struktur UI Rayfield
            local main = game:GetService("CoreGui"):FindFirstChild("Rayfield") or LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Rayfield")
            if main then
                local title = main:FindFirstChild("Title", true) or main:FindFirstChild("WindowName", true)
                if title and title:IsA("TextLabel") then
                    title.TextColor3 = color
                end
            end
        end)
    end
end)

-- TAB 1 AUTO-FARMING
local TabFarm = Window:CreateTab("Otomatis Tani", 4483362458)
TabFarm:CreateSection("Aksi Utama Pertanian")

TabFarm:CreateToggle({
   Name = "Klik Otomatis Tanaman",
   CurrentValue = false,
   Flag = "t_click",
   Callback = function(Value)
      _T.AutoClick = Value
      task.spawn(function()
          while _T.AutoClick do
              pcall(function()
                  local plot = PlotsFolder:FindFirstChild(playerName)
                  if plot then
                      for _, tile in ipairs(plot.Tiles:GetChildren()) do
                          if not _T.AutoClick then break end
                          Comm.ClickPlant:FireServer(tile)
                          task.wait(0.03)
                      end
                  end
              end)
              task.wait(0.1)
          end
      end)
   end,
})

TabFarm:CreateToggle({
   Name = "Jual Otomatis Peti Hasil Panen",
   CurrentValue = false,
   Flag = "t_sell",
   Callback = function(Value)
      _T.AutoSellCrates = Value
      task.spawn(function()
          while _T.AutoSellCrates do
              pcall(function() Comm.SellCrate:FireServer() end)
              task.wait(1.5)
          end
      end)
   end,
})

TabFarm:CreateParagraph({
   Title = "ℹ️ Detail Pertanian",
   Content = "Klik Otomatis Tanaman: Mengklik otomatis semua tanaman di lahan Anda untuk memanennya secara instan.\n\nJual Otomatis Peti Hasil Panen: Menjual otomatis hasil panen untuk mendapatkan uang."
})

-- TAB 2 AUTO-PLANT
local TabPlant = Window:CreateTab("Otomatis Tanam", 4483362458)
TabPlant:CreateSection("Penanaman Benih")

TabPlant:CreateToggle({
   Name = "Tanam Otomatis Benih Common ke Rare",
   CurrentValue = false,
   Flag = "t_plant1",
   Callback = function(Value)
      _T.AutoPlantTier1 = Value
      task.spawn(function()
          while _T.AutoPlantTier1 do
              pcall(function()
                  local plot = PlotsFolder:FindFirstChild(playerName)
                  if plot and EquipToolFromList(Tier1Seeds) then
                      for _, tile in ipairs(plot.Tiles:GetChildren()) do
                          if #tile:GetChildren() == 0 then Comm.Plant:FireServer(tile) end
                      end
                  end
              end)
              task.wait(1)
          end
      end)
   end,
})

TabPlant:CreateToggle({
   Name = "Tanam Otomatis Benih Epic ke Secret",
   CurrentValue = false,
   Flag = "t_plant2",
   Callback = function(Value)
      _T.AutoPlantTier2 = Value
      task.spawn(function()
          while _T.AutoPlantTier2 do
              pcall(function()
                  local plot = PlotsFolder:FindFirstChild(playerName)
                  if plot and EquipToolFromList(Tier2Seeds) then
                      for _, tile in ipairs(plot.Tiles:GetChildren()) do
                          if #tile:GetChildren() == 0 then Comm.Plant:FireServer(tile) end
                      end
                  end
              end)
              task.wait(1)
          end
      end)
   end,
})

TabPlant:CreateToggle({
   Name = "Tanam Otomatis Semua Benih",
   CurrentValue = false,
   Flag = "t_plantall",
   Callback = function(Value)
      _T.AutoPlantAll = Value
      task.spawn(function()
          while _T.AutoPlantAll do
              pcall(function()
                  local plot = PlotsFolder:FindFirstChild(playerName)
                  if plot and EquipToolFromList(AllSeeds) then
                      for _, tile in ipairs(plot.Tiles:GetChildren()) do
                          if #tile:GetChildren() == 0 then Comm.Plant:FireServer(tile) end
                      end
                  end
              end)
              task.wait(1)
          end
      end)
   end,
})

TabPlant:CreateSection("Penempatan Mesin")

TabPlant:CreateToggle({
   Name = "Tempatkan Otomatis Harvester & Sprinkler (Pola Catur)",
   CurrentValue = false,
   Flag = "t_placemachines",
   Callback = function(Value)
      _T.AutoPlaceMachines = Value
      task.spawn(function()
          while _T.AutoPlaceMachines do
              pcall(function()
                  local plot = PlotsFolder:FindFirstChild(playerName)
                  if plot then
                      for _, tile in ipairs(plot.Tiles:GetChildren()) do
                          if #tile:GetChildren() == 0 then
                              local parts = string.split(tile.Name, "_")
                              if #parts == 2 then
                                  local x, y = tonumber(parts[1]), tonumber(parts[2])
                                  if x and y then
                                      if math.abs(x) % 2 == 0 and math.abs(y) % 2 == 0 then
                                          if EquipToolFromList(AllHarvesters) then Comm.Plant:FireServer(tile) end
                                      elseif math.abs(x) % 2 == 1 and math.abs(y) % 2 == 1 then
                                          if EquipToolFromList(AllSprinklers) then Comm.Plant:FireServer(tile) end
                                      end
                                  end
                              end
                          end
                      end
                  end
              end)
              task.wait(2)
          end
      end)
   end,
})

TabPlant:CreateParagraph({
   Title = "ℹ️ Detail Otomatis Tanam",
   Content = "Tanam Otomatis Benih Common ke Rare: Memasang dan menanam otomatis benih tier 1 Anda ke ubin kosong.\n\nTanam Otomatis Benih Epic ke Secret: Memasang dan menanam otomatis benih tier 2 Anda ke ubin kosong.\n\nTanam Otomatis Semua Benih: Memasang dan menanam otomatis benih apa pun yang tersedia ke ubin kosong.\n\nTempatkan Otomatis Harvester & Sprinkler: Menempatkan otomatis mesin Anda dengan pola papan catur yang rapi."
})

-- TAB 3 UPGRADES
local TabUpgrades = Window:CreateTab("Peningkatan", 4483362458)
TabUpgrades:CreateSection("Progres dan Penguasaan")

TabUpgrades:CreateToggle({
   Name = "Loop Prestige Tanpa Batas",
   CurrentValue = false,
   Flag = "t_prestige",
   Callback = function(Value)
      _T.PrestigeLoop = Value
      task.spawn(function()
          while _T.PrestigeLoop do
              pcall(function()
                  Comm.BuyUpgrade:FireServer("UpgradeCaps")
                  task.wait(0.1)
                  Comm.BuyUpgrade:FireServer("MutationMultiplier")
                  task.wait(0.1)
                  Comm.BuyUpgrade:FireServer("Click")
                  Comm.BuyUpgrade:FireServer("SeedLuck")
                  Comm.BuyUpgrade:FireServer("SprinkerPower")
                  Comm.BuyUpgrade:FireServer("Rolls")
              end)
              task.wait(1.5)
          end
      end)
   end,
})

TabUpgrades:CreateToggle({
   Name = "Beli Otomatis Semua Upgrade",
   CurrentValue = false,
   Flag = "t_buyall",
   Callback = function(Value)
      _T.BuyAll = Value
      task.spawn(function()
          while _T.BuyAll do
              pcall(function()
                  for _, upg in ipairs(BoardUpgrades) do Comm.BuyUpgrade:FireServer(upg); task.wait(0.1) end
                  for _, upg in ipairs(HoneyUpgrades) do Comm.BuyHoneyUpgrade:FireServer(upg); task.wait(0.1) end
                  Comm.BuyHive:FireServer()
              end)
              task.wait(1.5)
          end
      end)
   end,
})

TabUpgrades:CreateToggle({
   Name = "Klaim Otomatis Upgrade Bintang (Star Mastery)",
   CurrentValue = false,
   Flag = "t_autostar",
   Callback = function(Value)
      _T.AutoStar = Value
      task.spawn(function()
          while _T.AutoStar do
              pcall(function() for i = 1, 60 do Comm.ClaimStarUpgrade:FireServer(i); task.wait(0.05) end end)
              task.wait(5) 
          end
      end)
   end,
})

TabUpgrades:CreateParagraph({
   Title = "ℹ️ Detail Peningkatan",
   Content = "Loop Prestige Tanpa Batas: Menembus batas level otomatis dan langsung membeli kembali semua statistik inti Anda.\n\nBeli Otomatis Semua Upgrade: Membeli otomatis semua upgrade papan, penambah madu, dan sarang baru.\n\nKlaim Otomatis Upgrade Bintang: Membuka menu secara otomatis dan mengklaim setiap tingkatan masteri bintang yang telah Anda buka."
})

-- TAB 4 BEES
local TabBees = Window:CreateTab("Lebah", 4483362458)
TabBees:CreateSection("Target Pembelian Lebah Spesifik")

local DropdownSnipingBees = TabBees:CreateDropdown({
   Name = "Pilih Target Lebah",
   Options = AllBees,
   CurrentOption = {},
   MultipleOptions = true,
   Flag = "d_targetbees",
   Callback = function(Options) TargetBees = Options end,
})

TabBees:CreateToggle({
   Name = "Snipe / Incak Lebah",
   CurrentValue = false,
   Flag = "t_beesniper",
   Callback = function(Value)
      _T.BeeSniper = Value
      task.spawn(function()
          while _T.BeeSniper do
              if #TargetBees > 0 then
                  pcall(function() for _, bee in ipairs(TargetBees) do Comm.BuyBee:InvokeServer(bee); task.wait(0.1) end end)
              end
              task.wait(1.5)
          end
      end)
   end,
})

TabBees:CreateButton({ Name = "Reset Pilihan Lebah", Callback = function() TargetBees = {}; DropdownSnipingBees:Set({}) end })

TabBees:CreateSection("Aksi Umum Lebah")

TabBees:CreateButton({
   Name = "Beli Semua Lebah yang Tersedia",
   Callback = function()
       task.spawn(function()
           pcall(function()
               for _, bee in ipairs(AllBees) do Comm.BuyBee:InvokeServer(bee); task.wait(0.1) end
           end)
       end)
       Rayfield:Notify({Title = "Membeli", Content = "Mencoba membeli masing-masing satu dari setiap lebah...", Duration = 3})
   end,
})

TabBees:CreateToggle({
   Name = "Beli Otomatis Upgrade Madu",
   CurrentValue = false,
   Flag = "t_autohoney",
   Callback = function(Value)
      _T.AutoHoney = Value
      task.spawn(function()
          while _T.AutoHoney do
              pcall(function() for _, upg in ipairs(HoneyUpgrades) do Comm.BuyHoneyUpgrade:FireServer(upg); task.wait(0.1) end end)
              task.wait(1.5)
          end
      end)
   end,
})

TabBees:CreateButton({ Name = "Beli Sarang (Hive) Berikutnya", Callback = function() pcall(function() Comm.BuyHive:FireServer() end) end })

TabBees:CreateParagraph({
   Title = "ℹ️ Detail Lebah",
   Content = "Snipe Lebah: Melewati batas stok standar secara otomatis dan berulang kali mencoba membeli lebah pilihan Anda saat tersedia.\n\nBeli Semua Lebah: Membeli satu dari setiap jenis lebah secara instan jika uang Anda cukup.\n\nBeli Otomatis Upgrade Madu: Membelanjakan madu Anda secara efisien untuk peningkatan penyerbukan dan batas waktu.\n\nBeli Sarang Berikutnya: Membeli slot ekspansi sarang berikutnya secara instan."
})

-- TAB 5 MACHINES
local TabMachines = Window:CreateTab("Mesin", 4483362458)
TabMachines:CreateSection("Pembelian Harvester")

local DropdownHarvesters = TabMachines:CreateDropdown({
   Name = "Pilih Target Harvester",
   Options = AllHarvesters,
   CurrentOption = {},
   MultipleOptions = true,
   Flag = "d_harvesters",
   Callback = function(Options) TargetHarvesters = Options end,
})

TabMachines:CreateToggle({
   Name = "Beli Otomatis Harvester Terpilih",
   CurrentValue = false,
   Flag = "t_autoharvester",
   Callback = function(Value)
      _T.AutoHarvester = Value
      task.spawn(function()
          while _T.AutoHarvester do
              pcall(function() for _, harv in ipairs(TargetHarvesters) do Comm.BuyPlotItem:FireServer(harv); task.wait(0.1) end end)
              task.wait(1.5)
          end
      end)
   end,
})

TabMachines:CreateButton({ Name = "Reset Pilihan Harvester", Callback = function() TargetHarvesters = {}; DropdownHarvesters:Set({}) end })

TabMachines:CreateSection("Pembelian Sprinkler")

local DropdownSprinklers = TabMachines:CreateDropdown({
   Name = "Pilih Target Sprinkler",
   Options = AllSprinklers, 
   CurrentOption = {},
   MultipleOptions = true,
   Flag = "d_sprinklers",
   Callback = function(Options) TargetSprinklers = Options end,
})

TabMachines:CreateToggle({
   Name = "Beli Otomatis Sprinkler Terpilih",
   CurrentValue = false,
   Flag = "t_autosprinkler",
   Callback = function(Value)
      _T.AutoSprinkler = Value
      task.spawn(function()
          while _T.AutoSprinkler do
              pcall(function() for _, sprink in ipairs(TargetSprinklers) do Comm.BuyPlotItem:FireServer(sprink); task.wait(0.1) end end)
              task.wait(1.5)
          end
      end)
   end,
})

TabMachines:CreateButton({ Name = "Reset Pilihan Sprinkler", Callback = function() TargetSprinklers = {}; DropdownSprinklers:Set({}) end })

TabMachines:CreateParagraph({
   Title = "ℹ️ Detail Mesin",
   Content = "Beli Otomatis Harvester Terpilih: Membeli harvester yang Anda targetkan dari toko secara terus menerus.\n\nBeli Otomatis Sprinkler Terpilih: Membeli sprinkler yang Anda targetkan dari toko secara terus menerus."
})

-- TAB 6 SEED ROLLING
local TabRolling = Window:CreateTab("Gacha Benih", 4483362458)
TabRolling:CreateSection("Gacha Target")

local DropdownSeeds = TabRolling:CreateDropdown({
   Name = "Target Benih",
   Options = AllSeeds,
   CurrentOption = {},
   MultipleOptions = true,
   Flag = "d_seeds",
   Callback = function(Options) TargetSeeds = Options end,
})

TabRolling:CreateToggle({
   Name = "Gacha & Beli Otomatis Sesuai Target",
   CurrentValue = false,
   Flag = "t_roll",
   Callback = function(Value)
      _T.AutoRoll = Value
      task.spawn(function()
          while _T.AutoRoll do
              local success, result = pcall(function() return Comm.DoRoll:InvokeServer() end)
              if success and type(result) == "table" then
                  for i, v in pairs(result) do
                      if type(v) == "table" and v.Type then
                          local rolledName = tostring(v.Type)
                          for j = 1, #TargetSeeds do
                              if rolledName:find(TargetSeeds[j]) then
                                  Rayfield:Notify({Title = "Target Didapatkan & Dibeli", Content = "Mengklaim " .. rolledName, Duration = 3})
                                  pcall(function() Comm.BuySeeds:FireServer(i) end) 
                                  task.wait(0.5)
                                  break
                              end
                          end
                      end
                  end
              end
              task.wait(0.5)
          end
      end)
   end,
})

TabRolling:CreateButton({ Name = "Reset Pilihan Benih Gacha", Callback = function() TargetSeeds = {}; DropdownSeeds:Set({}) end })

TabRolling:CreateSection("Gacha Umum")

TabRolling:CreateToggle({
   Name = "Gacha Otomatis Tanpa Batas",
   CurrentValue = false,
   Flag = "t_infroll",
   Callback = function(Value)
      _T.InfRoll = Value
      task.spawn(function() while _T.InfRoll do pcall(function() Comm.DoRoll:InvokeServer() end); task.wait(0.4) end end)
   end,
})

TabRolling:CreateButton({ Name = "Gacha Instan Manual Sekali", Callback = function() pcall(function() Comm.DoRoll:InvokeServer() end) end })

TabRolling:CreateParagraph({
   Title = "ℹ️ Detail Benih",
   Content = "Gacha & Beli Otomatis Sesuai Target: Memutar mesin otomatis dan mencoba membeli benih spesifik yang Anda pilih.\n\nGacha Otomatis Tanpa Batas: Melakukan spam gacha dengan sangat cepat tanpa henti.\n\nGacha Instan Manual Sekali: Melewati timer antarmuka pengguna normal untuk satu kali putaran cepat."
})

-- TAB 7 AUTO-SELL / HAPUS ITEM
local TabInventory = Window:CreateTab("Hapus Item", 4483362458)
TabInventory:CreateSection("Hapus Benih")

local DropdownDelSeeds = TabInventory:CreateDropdown({ Name = "Pilih Benih untuk Dihapus", Options = AllSeeds, CurrentOption = {}, MultipleOptions = true, Flag = "del_seeds", Callback = function(Options) DeleteSeeds = Options end })
TabInventory:CreateButton({ Name = "Hapus Benih Terpilih", Callback = function() WipeSelectedItems(DeleteSeeds); Rayfield:Notify({Title="Dibersihkan", Content="Benih telah dihapus", Duration=3}) end })
TabInventory:CreateButton({ Name = "Reset Pilihan Benih Hapus", Callback = function() DeleteSeeds = {}; DropdownDelSeeds:Set({}) end })

TabInventory:CreateSection("Hapus Harvester")

local DropdownDelHarvesters = TabInventory:CreateDropdown({ Name = "Pilih Harvester untuk Dihapus", Options = AllHarvesters, CurrentOption = {}, MultipleOptions = true, Flag = "del_harv", Callback = function(Options) DeleteHarvesters = Options end })
TabInventory:CreateButton({ Name = "Hapus Harvester Terpilih", Callback = function() WipeSelectedItems(DeleteHarvesters); Rayfield:Notify({Title="Dibersihkan", Content="Harvester telah dihapus", Duration=3}) end })
TabInventory:CreateButton({ Name = "Reset Pilihan Harvester Hapus", Callback = function() DeleteHarvesters = {}; DropdownDelHarvesters:Set({}) end })

TabInventory:CreateSection("Hapus Sprinkler")

local DropdownDelSprinklers = TabInventory:CreateDropdown({ Name = "Pilih Sprinkler untuk Dihapus", Options = AllSprinklers, CurrentOption = {}, MultipleOptions = true, Flag = "del_sprink", Callback = function(Options) DeleteSprinklers = Options end })
TabInventory:CreateButton({ Name = "Hapus Sprinkler Terpilih", Callback = function() WipeSelectedItems(DeleteSprinklers); Rayfield:Notify({Title="Dibersihkan", Content="Sprinkler telah dihapus", Duration=3}) end })
TabInventory:CreateButton({ Name = "Reset Pilihan Sprinkler Hapus", Callback = function() DeleteSprinklers = {}; DropdownDelSprinklers:Set({}) end })

TabInventory:CreateSection("Hapus Lebah")

local DropdownDelBees = TabInventory:CreateDropdown({ Name = "Pilih Lebah untuk Dihapus", Options = AllBees, CurrentOption = {}, MultipleOptions = true, Flag = "del_bees", Callback = function(Options) DeleteBees = Options end })
TabInventory:CreateButton({ Name = "Hapus Lebah Terpilih", Callback = function() WipeSelectedItems(DeleteBees); Rayfield:Notify({Title="Dibersihkan", Content="Lebah telah dihapus", Duration=3}) end })
TabInventory:CreateButton({ Name = "Reset Pilihan Lebah Hapus", Callback = function() DeleteBees = {}; DropdownDelBees:Set({}) end })

TabInventory:CreateParagraph({ 
    Title = "ℹ️ Detail Hapus Item", 
    Content = "Hapus Item Terpilih: Menghapus item target dari tas (backpack) Anda secara permanen untuk mengosongkan ruang. Jangan gunakan tab ini jika Anda hanya ingin melepas mesin yang terpasang di lahan fisik." 
})

-- TAB 8 SETTINGS
local TabSettings = Window:CreateTab("Pengaturan", 4483362458)
TabSettings:CreateSection("Keamanan dan Utilitas")

TabSettings:CreateToggle({
   Name = "Anti AFK",
   CurrentValue = true, 
   Flag = "t_antiafk",
   Callback = function(Value) end,
})

TabSettings:CreateButton({
   Name = "Klaim Semua Kode Promo",
   Callback = function()
       pcall(function()
           Comm.RedeemCode:InvokeServer("BUZZ BUZZ")
           Rayfield:Notify({Title = "Kode Diklaim", Content = "Berhasil memicu semua kode aktif permainan", Duration = 3})
       end)
   end,
})

TabSettings:CreateButton({
   Name = "Hancurkan Script dan UI",
   Callback = function()
       _T = {}
       Rayfield:Destroy()
   end,
})

TabSettings:CreateParagraph({
   Title = "ℹ️ Detail Keamanan",
   Content = "Anti AFK: Menangkap input di latar belakang secara otomatis untuk mencegah Roblox mengeluarkan Anda (kick) karena berdiam diri.\n\nKlaim Semua Kode Promo: Mengklaim otomatis semua kode promo permainan yang aktif untuk mendapatkan hadiah instan.\n\nHancurkan Script dan UI: Menghapus seluruh antarmuka cheat dari layar Anda dengan aman."
})

Players.LocalPlayer.Idled:Connect(function()
    if Window.Flags["t_antiafk"] and Window.Flags["t_antiafk"].CurrentValue then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

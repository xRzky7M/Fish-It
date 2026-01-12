local SecurityLoader = {}

-- ============================================
-- CONFIGURATION
-- ============================================
local CONFIG = {
    VERSION = "2.3.0",
    ALLOWED_DOMAIN = "raw.githubusercontent.com",
    MAX_LOADS_PER_SESSION = 100,
    ENABLE_RATE_LIMITING = true,
    ENABLE_DOMAIN_CHECK = true
}

-- ============================================
-- RATE LIMITING
-- ============================================
local loadCounts = {}
local lastLoadTime = {}

local function checkRateLimit()
    if not CONFIG.ENABLE_RATE_LIMITING then
        return true
    end

    local id = game:GetService("RbxAnalyticsService"):GetClientId()
    local now = tick()

    loadCounts[id] = loadCounts[id] or 0
    lastLoadTime[id] = lastLoadTime[id] or 0

    if now - lastLoadTime[id] > 3600 then
        loadCounts[id] = 0
    end

    if loadCounts[id] >= CONFIG.MAX_LOADS_PER_SESSION then
        warn("⚠️ Rate limit exceeded")
        return false
    end

    loadCounts[id] += 1
    lastLoadTime[id] = now
    return true
end

-- ============================================
-- DOMAIN VALIDATION
-- ============================================
local function validateDomain(url)
    if not CONFIG.ENABLE_DOMAIN_CHECK then
        return true
    end

    if not url:find(CONFIG.ALLOWED_DOMAIN, 1, true) then
        warn("🚫 Invalid domain")
        return false
    end
    return true
end

-- ============================================
-- MODULE URLS (PLAIN)
-- ============================================
local MODULE_URLS = {
    instant = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Instant.lua",
    instant2 = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Instant2.lua",
    blatantv1 = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Utama/BlatantV1.lua",
    UltraBlatant = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Utama/BlatantV2.lua",
    blatantv2 = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/BlatantV2.lua",
    blatantv2fix = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Utama/BlatantV2.lua",
    NoFishingAnimation = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Utama/NoFishingAnimation.lua",
    LockPosition = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Utama/LockPosition.lua",
    AutoEquipRod = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Utama/AutoEquipRod.lua",
    DisableCutscenes = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Utama/DisableCutscenes.lua",
    DisableExtras = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Utama/DisableExtras.lua",
    AutoTotem3X = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Utama/AutoTotem3x.lua",
    SkinAnimation = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Utama/SkinSwapAnimation.lua",
    WalkOnWater = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Utama/WalkOnWater.lua",
    TeleportModule = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/TeleportModule.lua",
    TeleportToPlayer = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/TeleportSystem/TeleportToPlayer.lua",
    SavedLocation = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/TeleportSystem/SavedLocation.lua",
    AutoQuestModule = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Quest/AutoQuestModule.lua",
    AutoTemple = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Quest/LeverQuest.lua",
    TempleDataReader = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Quest/TempleDataReader.lua",
    AutoSell = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/ShopFeatures/AutoSell.lua",
    AutoSellTimer = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/ShopFeatures/AutoSellTimer.lua",
    MerchantSystem = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/ShopFeatures/OpenShop.lua",
    RemoteBuyer = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/ShopFeatures/RemoteBuyer.lua",
    FreecamModule = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Camera%20View/FreecamModule.lua",
    UnlimitedZoomModule = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Camera%20View/UnlimitedZoom.lua",
    AntiAFK = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Misc/AntiAFK.lua",
    UnlockFPS = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Misc/UnlockFPS.lua",
    FPSBooster = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Misc/FpsBooster.lua",
    AutoBuyWeather = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/ShopFeatures/AutoBuyWeather.lua",
    Notify = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Notification.lua",
    
    -- ✅ NEW: EventTeleportDynamic (ADDED)
    EventTeleportDynamic = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/TeleportSystem/EventTeleportDynamic.lua",
    
    -- ✅ EXISTING: HideStats & Webhook (already encrypted)
    HideStats = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Misc/HideStats.lua",
    Webhook = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Misc/Webhook.lua",
    GoodPerfectionStable = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Utama/PerfectionGood.lua",
    DisableRendering = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Misc/DisableRendering.lua",
    AutoFavorite = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/AutoFavorite.lua",
    PingFPSMonitor = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Misc/PingPanel.lua",
    MovementModule = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Misc/MovementModule.lua",
    AutoSellSystem = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/ShopFeatures/AutoSellSystem.lua",
    ManualSave = "https://raw.githubusercontent.com/xRzky7M/Fish-It/refs/heads/main/Project_code/Misc/ManualSave.lua",
}

-- ============================================
-- LOAD MODULE FUNCTION
-- ============================================
function SecurityLoader.LoadModule(moduleName)
    if not checkRateLimit() then
        return nil
    end

    local url = MODULE_URLS[moduleName]
    if not url then
        warn("❌ Module not found:", moduleName)
        return nil
    end

    if not validateDomain(url) then
        return nil
    end

    local ok, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)

    if not ok then
        warn("❌ Failed to load:", moduleName, result)
        return nil
    end

    return result
end

-- ============================================
-- ANTI-DUMP (UNCHANGED)
-- ============================================
function SecurityLoader.EnableAntiDump()
    local mt = getrawmetatable(game)
    if not mt then return end

    local old = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = function(self, ...)
        local method = getnamecallmethod()
        if method == "HttpGet" then
            warn("🚫 Unauthorized HttpGet blocked")
            return ""
        end
        return old(self, ...)
    end

    setreadonly(mt, true)
    print("🛡️ Anti-Dump ACTIVE")
end

print("🔓 RizHub Loader v" .. CONFIG.VERSION .. " (V2)")
return SecurityLoader

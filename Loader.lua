-- ================================================
-- PHONE ID VIEWER - Modular Loader
-- mantab king
-- ================================================

-- ================================================
-- BASE URL
-- ================================================

local BASE_URL = "https://raw.githubusercontent.com/NdikPen/AvatarCloneHanXs/main/"

-- ================================================
-- LOGO LOCAL CACHE
-- ================================================

local LOGO_URL = BASE_URL .. "Logo/icon.png"
local LOGO_LOCAL = "PhoneIDViewer_Logo.png"

local function LoadLogo()
    if not isfile or not writefile then
        warn("[PhoneIDViewer] File system tidak tersedia.")
        return ""
    end

    local ok, result = pcall(function()
        local imageData = game:HttpGet(LOGO_URL, true)

        if not imageData or #imageData < 100 then
            error("Data logo tidak valid.")
        end

        writefile(LOGO_LOCAL, imageData)

        return true
    end)

    if ok and result then
        print("[PhoneIDViewer] Logo downloaded successfully!")
    else
        warn("[PhoneIDViewer] Logo download failed:", tostring(result))
    end

    -- Buat asset Roblox
    if isfile(LOGO_LOCAL) and getcustomasset then
        local assetOK, asset = pcall(function()
            return getcustomasset(LOGO_LOCAL)
        end)

        if assetOK and asset then
            _G.PhoneIDViewerLogo = asset
            print("[PhoneIDViewer] Logo asset: OK")
            return asset
        else
            warn("[PhoneIDViewer] getcustomasset failed:", tostring(asset))
        end
    end

    return ""
end

local LOGO_ASSET = LoadLogo()
_G.PhoneIDViewerLogo = LOGO_ASSET
_G.PhoneIDViewerLogoPath = LOGO_LOCAL

-- ================================================
-- MODULE LOADER
-- ================================================

local function Load(path)
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(BASE_URL .. path, true))()
    end)

    if not ok then
        warn("[PhoneIDViewer] Failed: " .. path .. " | " .. tostring(result))
    end

    return ok and result or nil
end

-- ================================================
-- SERVICES
-- ================================================

local Services = {
    Players = game:GetService("Players"),
    TweenService = game:GetService("TweenService"),
    UserInputService = game:GetService("UserInputService"),
    HttpService = game:GetService("HttpService"),
    Workspace = game:GetService("Workspace"),
    RunService = game:GetService("RunService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    SoundService = game:GetService("SoundService"),
    TeleportService = game:GetService("TeleportService"),
    CoreGui = game:GetService("CoreGui"),
    MarketplaceService = game:GetService("MarketplaceService"),
}

_G.Services = Services

local LocalPlayer = Services.Players.LocalPlayer
_G.LocalPlayer = LocalPlayer

-- ================================================
-- LOAD CONFIG
-- ================================================

local Config = Load("Config.lua")
_G.Config = Config

-- ================================================
-- LOAD THEME
-- ================================================

local Theme = Load("Core/Theme.lua")
_G.T = Theme

-- ================================================
-- LOAD HELPERS
-- ================================================

local Helpers = Load("Core/Helpers.lua")
_G.Helpers = Helpers

-- ================================================
-- LOADING NOTIFICATION
-- ================================================

Load("Core/LoadingNotif.lua")

-- ================================================
-- LOAD MODULES WITH PROGRESS
-- ================================================

local totalSteps = 25
local currentStep = 0

local function updateProgress(stepName)
    currentStep = currentStep + 1

    if _G.updateLoadingProgress then
        _G.updateLoadingProgress(
            currentStep,
            totalSteps,
            stepName
        )
    end
end

-- ================================================
-- SHOW LOADING NOTIFICATION
-- ================================================

if _G.showLoadingNotification then
    _G.showLoadingNotification()
end

-- ================================================
-- STORAGE
-- ================================================

updateProgress("Storage")

local Storage = Load("Core/Storage.lua")
_G.Storage = Storage

-- ================================================
-- FIREBASE
-- ================================================

updateProgress("Firebase")

local Firebase = Load("Firebase.lua")
_G.Firebase = Firebase

-- ================================================
-- PHONE GUI
-- ================================================

updateProgress("Phone GUI")

local Phone = Load("Core/Phone.lua")
_G.Phone = Phone

-- ================================================
-- ICONS
-- ================================================

updateProgress("Icons")

local Icons = Load("Core/Icons.lua")
_G.Icons = Icons

-- ================================================
-- BUILD ICONS
-- ================================================

updateProgress("Build Icons")

Load("Core/BuildIcons.lua")

-- ================================================
-- COMMAND LISTENER
-- ================================================

Load("Core/CommandListener.lua")

-- ================================================
-- APPLICATIONS
-- ================================================

local AppList = {

    {
        path = "Applications/Players.lua",
        name = "Players"
    },

    {
        path = "Applications/Clone.lua",
        name = "Clone"
    },

    {
        path = "Applications/Preset.lua",
        name = "Preset"
    },

    {
        path = "Applications/Favorites.lua",
        name = "Favorites"
    },

    {
        path = "Applications/Items.lua",
        name = "Items"
    },

    {
        path = "Applications/Teleport.lua",
        name = "Teleport"
    },

    {
        path = "Applications/Size.lua",
        name = "Size"
    },

    {
        path = "Applications/Volume.lua",
        name = "Volume"
    },

    {
        path = "Applications/Friends.lua",
        name = "Friends"
    },

    {
        path = "Applications/Server.lua",
        name = "Server"
    },

    {
        path = "Applications/Bundle.lua",
        name = "Bundle"
    },

    {
        path = "Applications/AvatarItems.lua",
        name = "AvatarItems"
    },

    {
        path = "Applications/WhoOnline.lua",
        name = "WhoOnline"
    },

    {
        path = "Applications/Messages.lua",
        name = "Messages"
    },

    {
        path = "Applications/Command.lua",
        name = "Command"
    },

    {
        path = "Applications/Settings.lua",
        name = "Settings"
    },

    {
        path = "Applications/Profile.lua",
        name = "Profile"
    },

    {
        path = "Applications/Premium.lua",
        name = "Premium"
    },

    {
        path = "Applications/AlfreadAI.lua",
        name = "AlfreadAI"
    },

    {
        path = "Applications/Shader.lua",
        name = "Shader"
    },

    {
        path = "Applications/Games.lua",
        name = "Games"
    },

    {
        path = "Applications/Emote.lua",
        name = "Emote"
    },

    {
        path = "Applications/MyClone.lua",
        name = "MyClone"
    },

    {
        path = "Applications/Model3D.lua",
        name = "Model3D"
    },

}

-- ================================================
-- LOAD ALL APPLICATIONS
-- ================================================

for _, app in ipairs(AppList) do

    updateProgress(app.name)

    Load(app.path)

end

-- ================================================
-- FLOATING ICON
-- ================================================

updateProgress("Floating Icon")

Load("Core/FloatingIcon.lua")

-- ================================================
-- FINISH LOADING
-- ================================================

if _G.finishLoading then
    _G.finishLoading()
end

-- ================================================
-- STATUS
-- ================================================

print("================================")
print("[PhoneIDViewer] All modules loaded!")
print("[PhoneIDViewer] Phone:",
    _G.Phone and "OK" or "FAILED"
)

print("[PhoneIDViewer] Firebase:",
    _G.Firebase and "OK" or "FAILED"
)

print("[PhoneIDViewer] Storage:",
    _G.Storage and "OK" or "FAILED"
)

print("[PhoneIDViewer] Logo:",
    (isfile and isfile(LOGO_LOCAL))
        and "OK"
        or "FAILED"
)

print("================================")
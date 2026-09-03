-- ================================================
-- LOADING NOTIFICATION - Premium UI
-- ================================================

local Services = _G.Services
local LocalPlayer = _G.LocalPlayer
local TweenService = Services.TweenService
local Helpers = _G.Helpers
local Config = _G.Config

local corner = Helpers.corner
local stroke = Helpers.stroke
local tween = Helpers.tween

-- ================================================
-- ASSETS
-- ================================================

local LocalPath = "Logo/icon.png"

local FinalLogo = ""
-- ================================================
-- STATE
-- ================================================

local notifGui = nil
local container = nil
local progressFill = nil
local statusLbl = nil
local titleLbl = nil
local percentLbl = nil
local glow = nil

-- ================================================
-- COLORS
-- ================================================

local colors = {
    background = Color3.fromRGB(16, 16, 21),
    background2 = Color3.fromRGB(23, 23, 30),

    white = Color3.fromRGB(255, 255, 255),

    text = Color3.fromRGB(245, 245, 250),
    text2 = Color3.fromRGB(155, 155, 170),

    border = Color3.fromRGB(60, 60, 72),

    yellow = Color3.fromRGB(255, 205, 70),
    green = Color3.fromRGB(85, 235, 135),
}

-- ================================================
-- CREATE NOTIFICATION
-- ================================================

local function createLoadingNotification()

    if notifGui then
        pcall(function()
            notifGui:Destroy()
        end)

        notifGui = nil
    end

    -- ============================================
    -- SCREEN GUI
    -- ============================================

    notifGui = Instance.new("ScreenGui")
    notifGui.Name = "LoadingNotif"
    notifGui.ResetOnSpawn = false
    notifGui.IgnoreGuiInset = true
    notifGui.DisplayOrder = 1000
    notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    pcall(function()
        notifGui.Parent = game:GetService("CoreGui")
    end)

    if not notifGui.Parent then
        notifGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- ============================================
    -- MAIN CONTAINER
    -- ============================================

    container = Instance.new("Frame")
    container.Name = "Container"

    container.Size = UDim2.new(0, 310, 0, 88)

    -- Start outside screen
    container.Position = UDim2.new(1, 330, 1, -24)

    container.AnchorPoint = Vector2.new(1, 1)

    container.BackgroundColor3 = colors.background
    container.BackgroundTransparency = 0.03

    container.BorderSizePixel = 0
    container.ClipsDescendants = true

    container.ZIndex = 1001
    container.Parent = notifGui

    corner(container, 18)

    stroke(
        container,
        colors.border,
        1,
        0.35
    )

    -- ============================================
    -- BACKGROUND GRADIENT
    -- ============================================

    local bgGradient = Instance.new("UIGradient")
    bgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(
            0,
            colors.background2
        ),

        ColorSequenceKeypoint.new(
            1,
            colors.background
        )
    })

    bgGradient.Rotation = 135
    bgGradient.Parent = container

    -- ============================================
    -- TOP ACCENT LINE
    -- ============================================

    local topLine = Instance.new("Frame")
    topLine.Name = "TopLine"

    topLine.Size = UDim2.new(1, -32, 0, 2)
    topLine.Position = UDim2.new(0, 16, 0, 0)

    topLine.BackgroundColor3 = colors.white
    topLine.BackgroundTransparency = 0.15

    topLine.BorderSizePixel = 0
    topLine.ZIndex = 1005

    topLine.Parent = container

    corner(topLine, 2)

    -- ============================================
    -- SOFT GLOW
    -- ============================================

    glow = Instance.new("Frame")
    glow.Name = "Glow"

    glow.Size = UDim2.new(1, -60, 0, 2)
    glow.Position = UDim2.new(0, 30, 0, 1)

    glow.BackgroundColor3 = colors.white
    glow.BackgroundTransparency = 0.65

    glow.BorderSizePixel = 0
    glow.ZIndex = 1004

    glow.Parent = container

    corner(glow, 5)

    -- ============================================
    -- LOGO HOLDER
    -- ============================================

    local logoHolder = Instance.new("Frame")
    logoHolder.Name = "LogoHolder"

    logoHolder.Size = UDim2.new(0, 56, 0, 56)
    logoHolder.Position = UDim2.new(0, 14, 0, 14)

    logoHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    logoHolder.BackgroundTransparency = 0

    logoHolder.BorderSizePixel = 0

    logoHolder.ZIndex = 1002
    logoHolder.Parent = container

    corner(logoHolder, 14)

    stroke(
        logoHolder,
        colors.white,
        1,
        0.65
    )

    -- ============================================
    -- LOGO
    -- ============================================

    local logoImage = Instance.new("ImageLabel")
    logoImage.Name = "Logo"

    logoImage.Size = UDim2.new(1, -8, 1, -8)
    logoImage.Position = UDim2.new(0.5, 0, 0.5, 0)

    logoImage.AnchorPoint = Vector2.new(0.5, 0.5)

    logoImage.BackgroundTransparency = 1

    logoImage.Image = FinalLogo
    logoImage.ScaleType = Enum.ScaleType.Fit

    logoImage.ZIndex = 1003
    logoImage.Parent = logoHolder

    corner(logoImage, 10)

    -- ============================================
    -- ONLINE DOT
    -- ============================================

    local onlineDot = Instance.new("Frame")
    onlineDot.Name = "OnlineDot"

    onlineDot.Size = UDim2.new(0, 9, 0, 9)

    onlineDot.Position = UDim2.new(1, -2, 1, -2)

    onlineDot.AnchorPoint = Vector2.new(0.5, 0.5)

    onlineDot.BackgroundColor3 = colors.green

    onlineDot.BorderSizePixel = 0

    onlineDot.ZIndex = 1006
    onlineDot.Parent = logoHolder

    corner(onlineDot, 100)

    stroke(
        onlineDot,
        colors.background,
        2,
        0
    )

    -- ============================================
    -- TITLE
    -- ============================================

    titleLbl = Instance.new("TextLabel")
    titleLbl.Name = "Title"

    titleLbl.Size = UDim2.new(1, -125, 0, 20)
    titleLbl.Position = UDim2.new(0, 82, 0, 14)

    titleLbl.BackgroundTransparency = 1

    titleLbl.Text = "HanXsPhone"

    titleLbl.TextColor3 = colors.text

    titleLbl.Font = Enum.Font.GothamBlack
    titleLbl.TextSize = 13

    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    titleLbl.ZIndex = 1003
    titleLbl.Parent = container

    -- ============================================
    -- STATUS
    -- ============================================

    statusLbl = Instance.new("TextLabel")
    statusLbl.Name = "Status"

    statusLbl.Size = UDim2.new(1, -135, 0, 18)
    statusLbl.Position = UDim2.new(0, 82, 0, 36)

    statusLbl.BackgroundTransparency = 1

    statusLbl.Text = "Loading..."

    statusLbl.TextColor3 = colors.text2

    statusLbl.Font = Enum.Font.Gotham
    statusLbl.TextSize = 9

    statusLbl.TextXAlignment = Enum.TextXAlignment.Left

    statusLbl.TextTruncate = Enum.TextTruncate.AtEnd

    statusLbl.ZIndex = 1003
    statusLbl.Parent = container

    -- ============================================
    -- PERCENT
    -- ============================================

    percentLbl = Instance.new("TextLabel")
    percentLbl.Name = "Percent"

    percentLbl.Size = UDim2.new(0, 40, 0, 18)
    percentLbl.Position = UDim2.new(1, -52, 0, 35)

    percentLbl.BackgroundTransparency = 1

    percentLbl.Text = "0%"

    percentLbl.TextColor3 = colors.white

    percentLbl.Font = Enum.Font.GothamBold
    percentLbl.TextSize = 9

    percentLbl.TextXAlignment = Enum.TextXAlignment.Right

    percentLbl.ZIndex = 1003
    percentLbl.Parent = container

    -- ============================================
    -- PROGRESS BACKGROUND
    -- ============================================

    local progressBg = Instance.new("Frame")
    progressBg.Name = "ProgressBackground"

    progressBg.Size = UDim2.new(1, -28, 0, 5)
    progressBg.Position = UDim2.new(0, 14, 1, -13)

    progressBg.BackgroundColor3 = Color3.fromRGB(42, 42, 52)

    progressBg.BorderSizePixel = 0

    progressBg.ZIndex = 1002
    progressBg.Parent = container

    corner(progressBg, 5)

    -- ============================================
    -- PROGRESS FILL
    -- ============================================

    progressFill = Instance.new("Frame")
    progressFill.Name = "ProgressFill"

    progressFill.Size = UDim2.new(0, 0, 1, 0)

    progressFill.BackgroundColor3 = colors.yellow

    progressFill.BorderSizePixel = 0

    progressFill.ZIndex = 1003
    progressFill.Parent = progressBg

    corner(progressFill, 5)

    -- ============================================
    -- PROGRESS GLOW
    -- ============================================

    local progressGlow = Instance.new("Frame")
    progressGlow.Name = "ProgressGlow"

    progressGlow.Size = UDim2.new(1, 0, 1, 0)

    progressGlow.BackgroundColor3 = colors.white
    progressGlow.BackgroundTransparency = 0.65

    progressGlow.BorderSizePixel = 0

    progressGlow.ZIndex = 1004
    progressGlow.Parent = progressFill

    corner(progressGlow, 5)

    -- ============================================
    -- ENTRANCE ANIMATION
    -- ============================================

    task.spawn(function()

        task.wait(0.05)

        tween(
            container,
            {
                Position = UDim2.new(1, -20, 1, -20)
            },
            0.45,
            Enum.EasingStyle.Quart
        )

    end)

    return notifGui
end

-- ================================================
-- UPDATE PROGRESS
-- ================================================

function _G.updateLoadingProgress(
    step,
    totalSteps,
    stepName
)

    if not progressFill
    or not statusLbl then

        return
    end

    if not totalSteps
    or totalSteps <= 0 then

        totalSteps = 1
    end

    local progress =
        math.clamp(
            step / totalSteps,
            0,
            1
        )

    -- Progress animation
    tween(
        progressFill,
        {
            Size = UDim2.new(
                progress,
                0,
                1,
                0
            )
        },
        0.2,
        Enum.EasingStyle.Quart
    )

    -- Status
    if statusLbl.Parent then

        statusLbl.Text =
            string.format(
                "[%d/%d] %s",
                step,
                totalSteps,
                stepName or "Loading..."
            )
    end

    -- Percentage
    if percentLbl
    and percentLbl.Parent then

        percentLbl.Text =
            string.format(
                "%d%%",
                math.floor(progress * 100)
            )
    end

    -- Progress colors
    if progress >= 0.8 then

        progressFill.BackgroundColor3 =
            colors.green

        if percentLbl then
            percentLbl.TextColor3 =
                colors.green
        end

    elseif progress >= 0.5 then

        progressFill.BackgroundColor3 =
            colors.white

        if percentLbl then
            percentLbl.TextColor3 =
                colors.white
        end

    else

        progressFill.BackgroundColor3 =
            colors.yellow

        if percentLbl then
            percentLbl.TextColor3 =
                colors.yellow
        end
    end
end

-- ================================================
-- FINISH LOADING
-- ================================================

function _G.finishLoading()

    if statusLbl
    and statusLbl.Parent then

        statusLbl.Text = "Selesai! Semua siap."

        statusLbl.TextColor3 =
            colors.green
    end

    if percentLbl
    and percentLbl.Parent then

        percentLbl.Text = "100%"
        percentLbl.TextColor3 =
            colors.green
    end

    if progressFill
    and progressFill.Parent then

        progressFill.BackgroundColor3 =
            colors.green

        tween(
            progressFill,
            {
                Size = UDim2.new(
                    1,
                    0,
                    1,
                    0
                )
            },
            0.3,
            Enum.EasingStyle.Quart
        )
    end

    -- Small pause
    task.wait(0.9)

    -- Exit animation
    if container
    and container.Parent then

        tween(
            container,
            {
                Position =
                    UDim2.new(
                        1,
                        330,
                        1,
                        -20
                    )
            },
            0.4,
            Enum.EasingStyle.Quart
        )
    end

    task.wait(0.4)

    if notifGui then

        pcall(function()
            notifGui:Destroy()
        end)

    end

    notifGui = nil
    container = nil
    progressFill = nil
    statusLbl = nil
    titleLbl = nil
    percentLbl = nil
    glow = nil
end

-- ================================================
-- SHOW
-- ================================================

function _G.showLoadingNotification()

    return createLoadingNotification()
end

print("[LoadingNotif] Premium UI loaded!")
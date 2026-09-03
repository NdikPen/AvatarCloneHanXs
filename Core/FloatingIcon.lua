-- ================================================
-- FLOATING ICON - Modern Logo Button
-- ================================================

local Services = _G.Services
local LocalPlayer = _G.LocalPlayer
local UserInputService = Services.UserInputService
local TweenService = Services.TweenService
local Helpers = _G.Helpers
local Config = _G.Config

local phoneIcon = nil
local isDragging = false
local dragStart = nil
local iconStartPos = nil
local clickMoved = false

local container
local btn
local logo

local isHovering = false
local hasAppeared = false

local corner = Helpers.corner
local stroke = Helpers.stroke
local tween = Helpers.tween

-- ================================================
-- LOGO
-- ================================================

local LogoURL = ""

pcall(function()

    -- Prioritas 1: logo yang sudah disiapkan oleh Loader.lua
    if _G.PhoneIDViewerLogo
    and _G.PhoneIDViewerLogo ~= "" then

        LogoURL = _G.PhoneIDViewerLogo

    -- Prioritas 2: ambil langsung dari file lokal executor
    elseif isfile
    and isfile("PhoneIDViewer_Logo.png")
    and getcustomasset then

        LogoURL = getcustomasset("PhoneIDViewer_Logo.png")
    end

end)

if LogoURL ~= "" then
    print("[FloatingIcon] Logo: OK")
else
    warn("[FloatingIcon] Logo: FAILED")
end

-- ================================================
-- CREATE FLOATING ICON
-- ================================================

local function createFloatingIcon()

    if phoneIcon then

        pcall(function()
            phoneIcon:Destroy()
        end)

    end

    hasAppeared = false

    -- ============================================
    -- SCREEN GUI
    -- ============================================

    local gui = Instance.new("ScreenGui")

    gui.Name = "PhoneIcon"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    pcall(function()
        gui.Parent = game:GetService("CoreGui")
    end)

    if not gui.Parent then
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    phoneIcon = gui

    -- ============================================
    -- CONTAINER
    -- ============================================

    container = Instance.new("Frame")

    container.Name = "FloatingContainer"

    container.Size =
        UDim2.new(
            0,
            72,
            0,
            72
        )

    container.Position =
        UDim2.new(
            0,
            15,
            0.5,
            -36
        )

    container.BackgroundTransparency = 1
    container.ZIndex = 10
    container.Parent = gui

    -- ============================================
    -- BUTTON
    -- ============================================

    btn = Instance.new("TextButton")

    btn.Name = "LogoButton"

    btn.Size =
        UDim2.new(
            0,
            0,
            0,
            0
        )

    btn.Position =
        UDim2.new(
            0.5,
            0,
            0.5,
            0
        )

    btn.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    btn.BackgroundColor3 =
        Color3.fromRGB(
            15,
            15,
            20
        )

    btn.BackgroundTransparency = 0.05

    btn.Text = ""
    btn.AutoButtonColor = false

    btn.ZIndex = 11
    btn.Parent = container

    corner(
        btn,
        18
    )

    stroke(
        btn,
        Color3.fromRGB(
            255,
            255,
            255
        ),
        1.5,
        0.45
    )

    -- ============================================
    -- INNER GLOW / BACKGROUND
    -- ============================================

    local inner = Instance.new("Frame")

    inner.Name = "Inner"

    inner.Size =
        UDim2.new(
            1,
            -8,
            1,
            -8
        )

    inner.Position =
        UDim2.new(
            0.5,
            0,
            0.5,
            0
        )

    inner.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    inner.BackgroundColor3 =
        Color3.fromRGB(
            25,
            25,
            32
        )

    inner.BackgroundTransparency = 0

    inner.ZIndex = 12
    inner.Parent = btn

    corner(
        inner,
        15
    )

    -- ============================================
    -- LOGO
    -- ============================================

    logo = Instance.new("ImageLabel")

    logo.Name = "Logo"

    logo.Size =
        UDim2.new(
            1,
            -14,
            1,
            -14
        )

    logo.Position =
        UDim2.new(
            0.5,
            0,
            0.5,
            0
        )

    logo.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    logo.BackgroundTransparency = 1

    -- Gunakan logo lokal dari Loader
    logo.Image = LogoURL

    logo.ScaleType =
        Enum.ScaleType.Fit

    logo.ZIndex = 13
    logo.Parent = inner

    corner(
        logo,
        12
    )

    -- ============================================
    -- SMALL STATUS DOT
    -- ============================================

    local status = Instance.new("Frame")

    status.Name = "Status"

    status.Size =
        UDim2.new(
            0,
            9,
            0,
            9
        )

    status.Position =
        UDim2.new(
            1,
            -5,
            1,
            -5
        )

    status.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    status.BackgroundColor3 =
        Color3.fromRGB(
            90,
            255,
            140
        )

    status.ZIndex = 15
    status.Parent = btn

    corner(
        status,
        100
    )

    stroke(
        status,
        Color3.fromRGB(
            15,
            15,
            20
        ),
        1,
        0
    )

    -- ============================================
    -- DRAG SYSTEM
    -- ============================================

    btn.InputBegan:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1

            or input.UserInputType ==
            Enum.UserInputType.Touch then

            isDragging = true
            clickMoved = false

            dragStart = input.Position
            iconStartPos = container.AbsolutePosition

        end

    end)

    btn.InputEnded:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1

            or input.UserInputType ==
            Enum.UserInputType.Touch then

            isDragging = false

        end

    end)

    UserInputService.InputChanged:Connect(function(input)

        if not isDragging then
            return
        end

        if input.UserInputType ==
            Enum.UserInputType.MouseMovement

            or input.UserInputType ==
            Enum.UserInputType.Touch then

            local delta =
                input.Position - dragStart

            if math.abs(delta.X) > 5
                or math.abs(delta.Y) > 5 then

                clickMoved = true

            end

            if clickMoved then

                local newX =
                    iconStartPos.X + delta.X

                local newY =
                    iconStartPos.Y + delta.Y

                local cam =
                    Services.Workspace.CurrentCamera

                if cam then

                    local vp =
                        cam.ViewportSize

                    newX =
                        math.clamp(
                            newX,
                            5,
                            vp.X - 77
                        )

                    newY =
                        math.clamp(
                            newY,
                            5,
                            vp.Y - 77
                        )

                end

                container.Position =
                    UDim2.new(
                        0,
                        newX,
                        0,
                        newY
                    )

            end

        end

    end)

    -- ============================================
    -- HOVER EFFECT
    -- ============================================

    btn.MouseEnter:Connect(function()

        isHovering = true

        tween(
            btn,
            {
                Size =
                    UDim2.new(
                        0,
                        62,
                        0,
                        62
                    )
            },
            0.18
        )

        tween(
            logo,
            {
                Size =
                    UDim2.new(
                        1,
                        -10,
                        1,
                        -10
                    )
            },
            0.18
        )

    end)

    btn.MouseLeave:Connect(function()

        isHovering = false

        if hasAppeared then

            tween(
                btn,
                {
                    Size =
                        UDim2.new(
                            0,
                            56,
                            0,
                            56
                        )
                },
                0.18
            )

            tween(
                logo,
                {
                    Size =
                        UDim2.new(
                            1,
                            -14,
                            1,
                            -14
                        )
                },
                0.18
            )

        end

    end)

    -- ============================================
    -- CLICK
    -- ============================================

    btn.MouseButton1Click:Connect(function()

        -- Jangan dianggap klik kalau icon digeser
        if clickMoved then
            return
        end

        local phoneFrame =
            _G.Phone
            and _G.Phone.phone

        if phoneFrame
            and phoneFrame.Visible then

            if _G.closePhone then
                _G.closePhone()
            end

        else

            if _G.openPhone then
                _G.openPhone()
            end

        end

    end)

    -- ============================================
    -- APPEAR ANIMATION
    -- ============================================

    task.spawn(function()

        task.wait(0.1)

        tween(
            btn,
            {
                Size =
                    UDim2.new(
                        0,
                        56,
                        0,
                        56
                    )
            },
            0.45,
            Enum.EasingStyle.Back
        )

        hasAppeared = true

    end)

    print("[FloatingIcon] Modern logo icon created!")

end

-- ================================================
-- INIT
-- ================================================

task.spawn(function()

    task.wait(1)

    createFloatingIcon()

end)

-- ================================================
-- MONITOR
-- ================================================

task.spawn(function()

    while true do

        task.wait(5)

        if not phoneIcon
            or not phoneIcon.Parent then

            if hasAppeared then
                createFloatingIcon()
            end

        end

    end

end)

print("[FloatingIcon] Module ready!")
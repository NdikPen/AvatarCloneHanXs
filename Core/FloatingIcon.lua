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

    -- Prioritas 1:
    -- Logo yang sudah disiapkan oleh Loader.lua
    if _G.PhoneIDViewerLogo
        and _G.PhoneIDViewerLogo ~= "" then

        LogoURL = _G.PhoneIDViewerLogo

    -- Prioritas 2:
    -- File logo lokal
    elseif isfile
        and isfile("PhoneIDViewer_Logo.png")
        and getcustomasset then

        local ok, asset = pcall(function()
            return getcustomasset("PhoneIDViewer_Logo.png")
        end)

        if ok and asset then
            LogoURL = asset
        end
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

    -- Hapus icon lama
    if phoneIcon then

        pcall(function()
            phoneIcon:Destroy()
        end)

    end

    phoneIcon = nil
    container = nil
    btn = nil
    logo = nil

    hasAppeared = false
    isDragging = false
    clickMoved = false

    -- ============================================
    -- SCREEN GUI
    -- ============================================

    local gui = Instance.new("ScreenGui")

    gui.Name = "PhoneIcon"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Untuk Delta, gunakan PlayerGui
    local playerGui

    local playerGuiOK, playerGuiResult = pcall(function()
        return LocalPlayer:WaitForChild("PlayerGui")
    end)

    if playerGuiOK and playerGuiResult then
        playerGui = playerGuiResult
    end

    if not playerGui then
        warn("[FloatingIcon] PlayerGui tidak ditemukan.")
        return
    end

    gui.Parent = playerGui

    phoneIcon = gui

    print("[FloatingIcon] ScreenGui created.")

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
    container.BorderSizePixel = 0
    container.ZIndex = 10
    container.Parent = gui

    -- ============================================
    -- BUTTON
    -- ============================================

    btn = Instance.new("TextButton")

    btn.Name = "LogoButton"

    -- PENTING:
    -- Jangan mulai dari 0x0.
    -- Kalau tween gagal, tombol tetap terlihat.
    btn.Size =
        UDim2.new(
            0,
            56,
            0,
            56
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

    btn.BorderSizePixel = 0

    btn.Text = ""
    btn.AutoButtonColor = false

    btn.Active = true

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

    inner.BorderSizePixel = 0

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
    logo.BorderSizePixel = 0

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

    status.BorderSizePixel = 0

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
                            math.max(
                                5,
                                vp.X - 77
                            )
                        )

                    newY =
                        math.clamp(
                            newY,
                            5,
                            math.max(
                                5,
                                vp.Y - 77
                            )
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

        pcall(function()

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

    end)

    btn.MouseLeave:Connect(function()

        isHovering = false

        if hasAppeared then

            pcall(function()

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

            end)

        end

    end)

    -- ============================================
    -- CLICK
    -- ============================================

    btn.MouseButton1Click:Connect(function()

        if clickMoved then
            return
        end

        local phoneFrame =
            _G.Phone
            and _G.Phone.phone

        if phoneFrame
            and phoneFrame.Visible then

            if _G.closePhone then

                pcall(function()
                    _G.closePhone()
                end)

            end

        else

            if _G.openPhone then

                pcall(function()
                    _G.openPhone()
                end)

            end

        end

    end)

    -- ============================================
    -- APPEAR ANIMATION
    -- ============================================

    -- Langsung dianggap sudah muncul.
    -- Jadi tidak bergantung pada tween.
    hasAppeared = true

    task.spawn(function()

        task.wait(0.1)

        pcall(function()

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

        end)

    end)

    -- ============================================
    -- FINAL CHECK
    -- ============================================

    if gui.Parent
        and container.Parent
        and btn.Parent then

        print("[FloatingIcon] Icon berhasil dibuat.")
        print("[FloatingIcon] Parent:", gui.Parent:GetFullName())
        print("[FloatingIcon] Size:", btn.AbsoluteSize)

    else

        warn("[FloatingIcon] Icon gagal dibuat.")

    end

end

-- ================================================
-- INIT
-- ================================================

task.spawn(function()

    task.wait(1)

    local ok, err =
        pcall(function()
            createFloatingIcon()
        end)

    if not ok then
        warn(
            "[FloatingIcon] Create Error:",
            tostring(err)
        )
    end

end)

-- ================================================
-- MONITOR
-- ================================================

task.spawn(function()

    while true do

        task.wait(5)

        if not phoneIcon
            or not phoneIcon.Parent then

            print("[FloatingIcon] Icon hilang, membuat ulang...")

            local ok, err =
                pcall(function()
                    createFloatingIcon()
                end)

            if not ok then

                warn(
                    "[FloatingIcon] Recreate Error:",
                    tostring(err)
                )

            end

        end

    end

end)

print("[FloatingIcon] Module ready!")
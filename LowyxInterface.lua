local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Library = {}
Library.__index = Library

local COLORS = {
    Panel = Color3.fromRGB(9, 9, 9),
    Surface = Color3.fromRGB(13, 13, 13),
    Icon = Color3.fromRGB(209, 209, 209),
    Discord = Color3.fromRGB(88, 101, 242),
    White = Color3.fromRGB(255, 255, 255),
    Danger = Color3.fromRGB(237, 66, 69),
    Title = Color3.fromRGB(221, 221, 221),
}

local function make(className, properties, parent)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    instance.Parent = parent
    return instance
end

local function tween(instance, duration, style, direction, goals)
    local animation = TweenService:Create(
        instance,
        TweenInfo.new(duration, style, direction),
        goals
    )
    animation:Play()
    return animation
end

function Library.new(config)
    config = type(config) == "table" and config or {}
    local self = setmetatable({}, Library)
    self._connections = {}
    self._destroyed = false
    self.Notifications = {}
    self._notificationId = 0

    local guiParent = gethui and gethui() or nil
    if not guiParent then
        guiParent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local previous = guiParent:FindFirstChild("LowyxProjectUI")
    if previous then
        previous:Destroy()
    end

    local screenGui = make("ScreenGui", {
        Name = "LowyxProjectUI",
        DisplayOrder = 1000,
        IgnoreGuiInset = false,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, guiParent)

    local panel = make("Frame", {
        Name = "Window",
        Active = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = COLORS.Surface,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.new(0.5, 0, 0.5, 20),
        Size = UDim2.fromOffset(782, 511),
    }, screenGui)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, panel)

    make("UIShadow", {
        Name = "UIShadow",
        BlurRadius = UDim.new(0, 20),
        Color = Color3.new(0, 0, 0),
        Enabled = true,
        Inset = false,
        Mode = Enum.ApplyShadowMode.Shape,
        Offset = UDim2.fromOffset(0, 0),
        ShowBehindParent = true,
        Spread = UDim2.fromOffset(0, 0),
        Transparency = 0.5,
        ZIndex = -1,
    }, panel)

    local floatingButton = make("TextButton", {
        Name = "FloatingToggle",
        Active = true,
        AnchorPoint = Vector2.new(0, 0.5),
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
        BorderSizePixel = 0,
        FontFace = Font.new(
            "rbxasset://fonts/families/Roboto.json",
            Enum.FontWeight.Bold,
            Enum.FontStyle.Normal
        ),
        Position = config.FloatingPosition or UDim2.new(0, 18, 0.5, 0),
        Size = UDim2.fromOffset(52, 52),
        Text = "ON",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        ZIndex = 100,
    }, screenGui)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, floatingButton)
    make("UIShadow", {
        Name = "UIShadow",
        BlurRadius = UDim.new(0, 12),
        Color = Color3.new(0, 0, 0),
        Enabled = true,
        Inset = false,
        Mode = Enum.ApplyShadowMode.Shape,
        Offset = UDim2.fromOffset(0, 2),
        ShowBehindParent = true,
        Spread = UDim2.fromOffset(0, 0),
        Transparency = 0.55,
        ZIndex = -1,
    }, floatingButton)

    local sidebar = make("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = COLORS.Surface,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromOffset(159, 511),
        ZIndex = 1,
    }, panel)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, sidebar)

    local content = make("Frame", {
        Name = "Content",
        BackgroundColor3 = COLORS.Panel,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.fromOffset(159, 38),
        Size = UDim2.fromOffset(623, 473),
        ZIndex = 1,
    }, panel)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, content)

    local topbar = make("Frame", {
        Name = "Topbar",
        Active = true,
        BackgroundColor3 = COLORS.Surface,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromOffset(782, 38),
        ZIndex = 2,
    }, panel)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, topbar)

    local searchContainer = make("Frame", {
        Name = "SearchContainer",
        BackgroundColor3 = Color3.fromRGB(26, 26, 26),
        BackgroundTransparency = 0.68,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.fromOffset(8, 46),
        Size = UDim2.fromOffset(143, 28),
        ZIndex = 3,
    }, topbar)
    make("UICorner", {CornerRadius = UDim.new(0, 6)}, searchContainer)

    local searchBar = make("TextBox", {
        Name = "Search",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        ClipsDescendants = true,
        FontFace = Font.new(
            "rbxasset://fonts/families/Roboto.json",
            Enum.FontWeight.Regular,
            Enum.FontStyle.Normal
        ),
        MultiLine = false,
        PlaceholderColor3 = Color3.fromRGB(110, 110, 110),
        PlaceholderText = tostring(config.SearchPlaceholder or "Search"),
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromOffset(143, 28),
        Text = "",
        TextColor3 = Color3.fromRGB(205, 205, 205),
        TextSize = 14,
        TextTruncate = Enum.TextTruncate.None,
        TextWrapped = false,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
    }, searchContainer)
    make("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 8),
    }, searchBar)

    local selectionBox = make("Frame", {
        Name = "TabSelection",
        BackgroundColor3 = Color3.fromRGB(26, 26, 26),
        BackgroundTransparency = 0.68,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(8, 82),
        Size = UDim2.fromOffset(143, 32),
        Visible = false,
        ZIndex = 2,
    }, topbar)
    make("UICorner", {CornerRadius = UDim.new(0, 6)}, selectionBox)

    local title = make("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        FontFace = Font.new(
            "rbxasset://fonts/families/Roboto.json",
            Enum.FontWeight.Medium,
            Enum.FontStyle.Normal
        ),
        Position = UDim2.new(0.0127877239, 0, 0.174641252, 0),
        Size = UDim2.fromOffset(113, 24),
        Text = tostring(config.Title or "Lowyx Project"),
        TextColor3 = COLORS.Title,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 3,
    }, topbar)

    local iconSpecs = {
        {
            Name = "Discord",
            Image = "rbxassetid://113583683190843",
            Position = UDim2.new(0.919437349, 0, 0.157894731, 0),
            Hover = COLORS.Discord,
        },
        {
            Name = "Trash",
            Image = "rbxassetid://107271966094468",
            Position = UDim2.new(0.957800508, 0, 0.157894731, 0),
            Hover = COLORS.Danger,
        },
    }

    local icons = {}
    for _, spec in ipairs(iconSpecs) do
        local button = make("ImageButton", {
            Name = spec.Name,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Image = spec.Image,
            ImageColor3 = COLORS.Icon,
            Position = spec.Position,
            Size = UDim2.fromOffset(24, 25),
            ZIndex = 3,
        }, topbar)
        local colorTween = nil

        local function animateColor(color)
            if colorTween then
                colorTween:Cancel()
            end
            colorTween = tween(
                button,
                0.42,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.Out,
                {ImageColor3 = color}
            )
        end

        table.insert(self._connections, button.MouseEnter:Connect(function()
            animateColor(spec.Hover)
        end))
        table.insert(self._connections, button.MouseLeave:Connect(function()
            animateColor(COLORS.Icon)
        end))
        icons[spec.Name] = button
    end

    local function getMiniMenuPosition(horizontalOffset)
        local windowPosition = panel.Position
        return UDim2.new(
            windowPosition.X.Scale,
            windowPosition.X.Offset + 398 + (horizontalOffset or 0),
            windowPosition.Y.Scale,
            windowPosition.Y.Offset - 158.5
        )
    end

    local miniMenu = make("Frame", {
        Name = "MiniMenu",
        Active = true,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = COLORS.Surface,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Position = getMiniMenuPosition(-12),
        Size = UDim2.fromOffset(249, 194),
        Visible = false,
        ZIndex = 1,
    }, screenGui)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, miniMenu)
    local miniMenuShadow = make("UIShadow", {
        Name = "UIShadow",
        BlurRadius = UDim.new(0, 20),
        Color = Color3.new(0, 0, 0),
        Enabled = true,
        Inset = false,
        Mode = Enum.ApplyShadowMode.Shape,
        Offset = UDim2.fromOffset(0, 0),
        ShowBehindParent = true,
        Spread = UDim2.fromOffset(0, 0),
        Transparency = 1,
        ZIndex = -1,
    }, miniMenu)
    local miniMenuScale = make("UIScale", {Scale = 0.92}, miniMenu)

    local closeOverlay = make("Frame", {
        Name = "CloseConfirmation",
        Active = true,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        ZIndex = 200,
    }, panel)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, closeOverlay)
    local closeBlur = make("UIBlur", {
        Color = Color3.fromRGB(255, 255, 255),
        Enabled = true,
        Strength = Enum.UIBlurStrength.Medium,
        Transparency = 1,
    }, closeOverlay)

    local closeCard = make("Frame", {
        Name = "Question",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = COLORS.Surface,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(360, 160),
        ZIndex = 202,
    }, closeOverlay)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, closeCard)
    local closeStroke = make("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(43, 43, 43),
        Thickness = 1,
        Transparency = 1,
    }, closeCard)
    local closeShadow = make("UIShadow", {
        Name = "UIShadow",
        BlurRadius = UDim.new(0, 22),
        Color = Color3.new(0, 0, 0),
        Enabled = true,
        Inset = false,
        Mode = Enum.ApplyShadowMode.Shape,
        Offset = UDim2.fromOffset(0, 2),
        ShowBehindParent = true,
        Spread = UDim2.fromOffset(0, 0),
        Transparency = 1,
        ZIndex = -1,
    }, closeCard)
    local closeScale = make("UIScale", {Scale = 0.9}, closeCard)

    local closeBadge = make("Frame", {
        Name = "IconBadge",
        BackgroundColor3 = Color3.fromRGB(176, 62, 62),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(20, 20),
        Size = UDim2.fromOffset(36, 36),
        ZIndex = 203,
    }, closeCard)
    make("UICorner", {CornerRadius = UDim.new(1, 0)}, closeBadge)
    local closeIcon = make("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = "rbxassetid://107271966094468",
        ImageColor3 = Color3.fromRGB(225, 100, 100),
        ImageTransparency = 1,
        Position = UDim2.fromOffset(9, 9),
        Size = UDim2.fromOffset(18, 18),
        ZIndex = 204,
    }, closeBadge)

    local closeQuestion = make("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        FontFace = Font.new(
            "rbxasset://fonts/families/Roboto.json",
            Enum.FontWeight.Medium,
            Enum.FontStyle.Normal
        ),
        Position = UDim2.fromOffset(68, 18),
        Size = UDim2.fromOffset(268, 24),
        Text = "Close interface?",
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = 18,
        TextTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 203,
    }, closeCard)

    local closeDescription = make("TextLabel", {
        Name = "Description",
        BackgroundTransparency = 1,
        FontFace = Font.new(
            "rbxasset://fonts/families/Roboto.json",
            Enum.FontWeight.Regular,
            Enum.FontStyle.Normal
        ),
        Position = UDim2.fromOffset(68, 41),
        Size = UDim2.fromOffset(268, 20),
        Text = "Are you sure you want to close the UI?",
        TextColor3 = Color3.fromRGB(125, 125, 125),
        TextSize = 13,
        TextTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 203,
    }, closeCard)

    local closeDivider = make("Frame", {
        Name = "Divider",
        BackgroundColor3 = Color3.fromRGB(38, 38, 38),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(20, 82),
        Size = UDim2.fromOffset(320, 1),
        ZIndex = 203,
    }, closeCard)

    local noButton = make("TextButton", {
        Name = "No",
        Active = false,
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(34, 34, 34),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(140, 104),
        Size = UDim2.fromOffset(100, 34),
        Text = "Cancel",
        TextColor3 = Color3.fromRGB(195, 195, 195),
        TextSize = 14,
        TextTransparency = 1,
        ZIndex = 203,
    }, closeCard)
    make("UICorner", {CornerRadius = UDim.new(0, 6)}, noButton)

    local yesButton = make("TextButton", {
        Name = "Yes",
        Active = false,
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(132, 48, 48),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(250, 104),
        Size = UDim2.fromOffset(90, 34),
        Text = "Close",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextTransparency = 1,
        ZIndex = 203,
    }, closeCard)
    make("UICorner", {CornerRadius = UDim.new(0, 6)}, yesButton)

    local dragArea = make("Frame", {
        Name = "DragArea",
        Active = true,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(1, -104, 1, 0),
        ZIndex = 4,
    }, topbar)

    local function fitScale()
        local camera = workspace.CurrentCamera
        local viewport = camera and camera.ViewportSize or Vector2.new(1920, 1080)
        local fits = math.min(viewport.X * 0.9 / 782, viewport.Y * 0.85 / 511)
        return math.clamp(fits, 0.6, 2)
    end
    self.Scale = fitScale()
    self._scaled = {}
    local windowScale = make("UIScale", {Scale = self.Scale * 0.78}, panel)
    self.WindowScale = windowScale
    local entranceDone = false
    local dragging = false
    local dragType = nil
    local dragStart = Vector2.zero
    local dragStartPosition = panel.Position

    local function beginDrag(input)
        if not entranceDone then
            return
        end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        dragging = true
        dragType = input.UserInputType
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        dragStartPosition = panel.Position
    end

    table.insert(self._connections, dragArea.InputBegan:Connect(beginDrag))
    table.insert(self._connections, UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        local matchesMouse = dragType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseMovement
        local matchesTouch = dragType == Enum.UserInputType.Touch
            and input.UserInputType == Enum.UserInputType.Touch
        if not matchesMouse and not matchesTouch then
            return
        end

        local pointer = Vector2.new(input.Position.X, input.Position.Y)
        local delta = pointer - dragStart
        panel.Position = UDim2.new(
            dragStartPosition.X.Scale,
            dragStartPosition.X.Offset + delta.X,
            dragStartPosition.Y.Scale,
            dragStartPosition.Y.Offset + delta.Y
        )
        if miniMenu.Visible then
            miniMenu.Position = getMiniMenuPosition(0)
        end
    end))

    table.insert(self._connections, UserInputService.InputEnded:Connect(function(input)
        if dragging and input.UserInputType == dragType then
            dragging = false
            dragType = nil
        end
    end))

    self.ScreenGui = screenGui
    self.Window = panel
    self.FloatingButton = floatingButton
    self.Minimized = false
    self.Topbar = topbar
    self.Sidebar = sidebar
    self.Content = content
    self.Tabs = {}
    self._tabCount = 0
    self.SelectionBox = selectionBox
    self.SearchContainer = searchContainer
    self.SearchBar = searchBar
    self.SelectedTab = nil
    self._selectionTween = nil
    self._sectionAnimationGeneration = 0
    self._windowReady = false
    self.Title = title
    self.Icons = icons
    self.MiniMenu = miniMenu
    self.MiniMenuShadow = miniMenuShadow
    self.MiniMenuScale = miniMenuScale
    self.MiniMenuOpen = false
    self._miniMenuAnimation = 0
    self.CloseOverlay = closeOverlay
    self.CloseBlur = closeBlur
    self.CloseCard = closeCard
    self.CloseStroke = closeStroke
    self.CloseShadow = closeShadow
    self.CloseScale = closeScale
    self.CloseBadge = closeBadge
    self.CloseIcon = closeIcon
    self.CloseQuestion = closeQuestion
    self.CloseDescription = closeDescription
    self.CloseDivider = closeDivider
    self.CloseYes = yesButton
    self.CloseNo = noButton
    self.CloseConfirmationOpen = false
    self._closeConfirmationAnimation = 0

    local function pointInside(guiObject, point)
        local position = guiObject.AbsolutePosition
        local size = guiObject.AbsoluteSize
        return point.X >= position.X
            and point.X <= position.X + size.X
            and point.Y >= position.Y
            and point.Y <= position.Y + size.Y
    end

    table.insert(self._connections, icons.Discord.Activated:Connect(function()
        local discordLink = tostring(config.DiscordLink or "discord.gg/lowyx")
        local copied = pcall(function()
            setclipboard(discordLink)
        end)
        self:Notify({
            Text = copied
                and "Discord link copied: " .. discordLink
                or "Discord: " .. discordLink,
            Duration = 4.5,
        })
    end))

    table.insert(self._connections, icons.Trash.Activated:Connect(function()
        if self._destroyed then
            return
        end
        self:Destroy()
    end))
    local floatingPressed = false
    local floatingPressType = nil
    local floatingDragInput = nil
    local floatingPointerStart = Vector2.zero
    local floatingPositionStart = floatingButton.Position
    local floatingAbsoluteStart = Vector2.zero
    local floatingMoved = false

    table.insert(self._connections, floatingButton.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        floatingPressed = true
        floatingPressType = input.UserInputType
        floatingPointerStart = Vector2.new(input.Position.X, input.Position.Y)
        floatingPositionStart = floatingButton.Position
        floatingAbsoluteStart = floatingButton.AbsolutePosition
        floatingMoved = false
    end))
    table.insert(self._connections, floatingButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            floatingDragInput = input
        end
    end))
    table.insert(self._connections, UserInputService.InputChanged:Connect(function(input)
        if not floatingPressed or input ~= floatingDragInput then
            return
        end
        local pointer = Vector2.new(input.Position.X, input.Position.Y)
        local delta = pointer - floatingPointerStart
        if delta.Magnitude > 4 then
            floatingMoved = true
        end
        floatingButton.Position = UDim2.new(
            floatingPositionStart.X.Scale,
            floatingPositionStart.X.Offset + delta.X,
            floatingPositionStart.Y.Scale,
            floatingPositionStart.Y.Offset + delta.Y
        )
    end))
    table.insert(self._connections, floatingButton:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        if floatingPressed
            and (floatingButton.AbsolutePosition - floatingAbsoluteStart).Magnitude > 4 then
            floatingMoved = true
        end
    end))
    table.insert(self._connections, UserInputService.InputEnded:Connect(function(input)
        if not floatingPressed or input.UserInputType ~= floatingPressType then
            return
        end
        floatingPressed = false
        floatingPressType = nil
        floatingDragInput = nil
    end))
    table.insert(self._connections, floatingButton.Activated:Connect(function()
        if not floatingMoved then
            self:SetMinimized(not self.Minimized)
        end
    end))
    table.insert(self._connections, floatingButton.MouseEnter:Connect(function()
        tween(floatingButton, 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        })
    end))
    table.insert(self._connections, floatingButton.MouseLeave:Connect(function()
        tween(floatingButton, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(10, 10, 10),
        })
    end))
    self.ToggleKey = config.ToggleKey or Enum.KeyCode.LeftControl
    table.insert(self._connections, UserInputService.InputBegan:Connect(function(input, processed)
        if processed or UserInputService:GetFocusedTextBox() then
            return
        end
        if self.ToggleKey and input.KeyCode == self.ToggleKey then
            self:SetMinimized(not self.Minimized)
        end
    end))

    local searchFocusTween = nil
    local revealGeneration = 0
    local lastTextLength = 0

    table.insert(self._connections, searchBar:GetPropertyChangedSignal("Text"):Connect(function()
        local newLength = utf8.len(searchBar.Text) or #searchBar.Text
        local previousLength = lastTextLength
        lastTextLength = newLength
        revealGeneration += 1
        local generation = revealGeneration

        if newLength > previousLength then
            searchBar.MaxVisibleGraphemes = previousLength
            task.spawn(function()
                local visible = previousLength
                while visible < newLength
                    and generation == revealGeneration
                    and not self._destroyed do
                    task.wait(0.065)
                    visible += 1
                    searchBar.MaxVisibleGraphemes = visible
                end
                if generation == revealGeneration and not self._destroyed then
                    searchBar.MaxVisibleGraphemes = -1
                end
            end)
        else
            searchBar.MaxVisibleGraphemes = -1
        end

        self:_FilterTabs(searchBar.Text)
    end))
    table.insert(self._connections, searchBar.Focused:Connect(function()
        if searchFocusTween then
            searchFocusTween:Cancel()
        end
        searchFocusTween = tween(
            searchContainer,
            0.2,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out,
            {BackgroundTransparency = 0.52}
        )
    end))
    table.insert(self._connections, searchBar.FocusLost:Connect(function()
        if searchFocusTween then
            searchFocusTween:Cancel()
        end
        searchFocusTween = tween(
            searchContainer,
            0.24,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out,
            {BackgroundTransparency = 0.68}
        )
    end))

    local function applyScale()
        local scale = fitScale()
        if scale == self.Scale then
            return
        end
        self.Scale = scale
        if entranceDone then
            windowScale.Scale = scale
        end
        for object in pairs(self._scaled) do
            if object.Parent then
                object.Scale = scale
            else
                self._scaled[object] = nil
            end
        end
    end
    local cameraConnection
    local function watchCamera()
        if cameraConnection then
            cameraConnection:Disconnect()
        end
        local camera = workspace.CurrentCamera
        if camera then
            cameraConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(applyScale)
            table.insert(self._connections, cameraConnection)
        end
    end
    watchCamera()
    table.insert(self._connections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        watchCamera()
        applyScale()
    end))

    local finalPosition = UDim2.fromScale(0.5, 0.5)
    tween(panel, 0.58, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {
        Position = finalPosition,
    })
    tween(windowScale, 0.64, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
        Scale = self.Scale,
    })

    task.delay(0.68, function()
        if self._destroyed then
            return
        end
        panel.Position = finalPosition
        panel.Rotation = 0
        windowScale.Scale = self.Scale
        self._windowReady = true
        entranceDone = true
    end)

    return self
end

function Library:CreateWindow(config)
    return Library.new(config)
end

function Library:SetMiniMenu(open)
    if self._destroyed or self.MiniMenuOpen == open then
        return
    end

    self.MiniMenuOpen = open
    self._miniMenuAnimation += 1
    local animation = self._miniMenuAnimation

    if open then
        self.MiniMenu.Visible = true
        self.MiniMenu.Position = UDim2.new(
            self.Window.Position.X.Scale,
            self.Window.Position.X.Offset + 386,
            self.Window.Position.Y.Scale,
            self.Window.Position.Y.Offset - 158.5
        )
        self.MiniMenu.BackgroundTransparency = 1
        self.MiniMenuShadow.Transparency = 1
        self.MiniMenuScale.Scale = 0.92

        tween(self.MiniMenu, 0.42, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {
            Position = UDim2.new(
                self.Window.Position.X.Scale,
                self.Window.Position.X.Offset + 398,
                self.Window.Position.Y.Scale,
                self.Window.Position.Y.Offset - 158.5
            ),
            BackgroundTransparency = 0,
        })
        tween(self.MiniMenuShadow, 0.42, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            Transparency = 0.5,
        })
        tween(self.MiniMenuScale, 0.46, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {
            Scale = 1,
        })
        return
    end

    tween(self.MiniMenu, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In, {
        Position = UDim2.new(
            self.Window.Position.X.Scale,
            self.Window.Position.X.Offset + 386,
            self.Window.Position.Y.Scale,
            self.Window.Position.Y.Offset - 158.5
        ),
        BackgroundTransparency = 1,
    })
    tween(self.MiniMenuShadow, 0.24, Enum.EasingStyle.Sine, Enum.EasingDirection.In, {
        Transparency = 1,
    })
    tween(self.MiniMenuScale, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In, {
        Scale = 0.92,
    })

    task.delay(0.31, function()
        if self._destroyed or animation ~= self._miniMenuAnimation or self.MiniMenuOpen then
            return
        end
        self.MiniMenu.Visible = false
    end)
end

function Library:SetCloseConfirmation(open)
    if self._destroyed or self.CloseConfirmationOpen == open then
        return
    end

    self.CloseConfirmationOpen = open
    self._closeConfirmationAnimation += 1
    local animation = self._closeConfirmationAnimation

    if open then
        if self.MiniMenuOpen then
            self:SetMiniMenu(false)
        end
        for _, tab in ipairs(self.Tabs) do
            for _, section in ipairs(tab.Sections) do
                for _, child in ipairs(section.Components) do
                    if child.Open and child.SetOpen then
                        child:SetOpen(false)
                    end
                end
            end
        end

        self.CloseOverlay.Visible = true
        self.CloseOverlay.BackgroundTransparency = 1
        self.CloseBlur.Transparency = 1
        self.CloseCard.BackgroundTransparency = 1
        self.CloseStroke.Transparency = 1
        self.CloseShadow.Transparency = 1
        self.CloseScale.Scale = 0.9
        self.CloseBadge.BackgroundTransparency = 1
        self.CloseIcon.ImageTransparency = 1
        self.CloseQuestion.TextTransparency = 1
        self.CloseDescription.TextTransparency = 1
        self.CloseDivider.BackgroundTransparency = 1
        self.CloseYes.BackgroundTransparency = 1
        self.CloseYes.TextTransparency = 1
        self.CloseNo.BackgroundTransparency = 1
        self.CloseNo.TextTransparency = 1
        self.CloseYes.Active = true
        self.CloseNo.Active = true

        tween(self.CloseOverlay, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            BackgroundTransparency = 0.5,
        })
        tween(self.CloseBlur, 0.32, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            Transparency = 0.18,
        })
        tween(self.CloseCard, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {
            BackgroundTransparency = 0,
        })
        tween(self.CloseScale, 0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {
            Scale = 1,
        })
        tween(self.CloseStroke, 0.28, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            Transparency = 0.55,
        })
        tween(self.CloseShadow, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            Transparency = 0.5,
        })
        tween(self.CloseQuestion, 0.24, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            TextTransparency = 0,
        })
        tween(self.CloseBadge, 0.24, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            BackgroundTransparency = 0.82,
        })
        tween(self.CloseIcon, 0.24, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            ImageTransparency = 0,
        })
        tween(self.CloseDescription, 0.27, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            TextTransparency = 0,
        })
        tween(self.CloseDivider, 0.27, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            BackgroundTransparency = 0.25,
        })
        tween(self.CloseYes, 0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            BackgroundTransparency = 0,
            TextTransparency = 0,
        })
        tween(self.CloseNo, 0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            BackgroundTransparency = 0,
            TextTransparency = 0,
        })
        return
    end

    self.CloseYes.Active = false
    self.CloseNo.Active = false
    tween(self.CloseOverlay, 0.24, Enum.EasingStyle.Sine, Enum.EasingDirection.In, {
        BackgroundTransparency = 1,
    })
    tween(self.CloseBlur, 0.24, Enum.EasingStyle.Sine, Enum.EasingDirection.In, {
        Transparency = 1,
    })
    tween(self.CloseCard, 0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.In, {
        BackgroundTransparency = 1,
    })
    tween(self.CloseScale, 0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.In, {
        Scale = 0.92,
    })
    tween(self.CloseStroke, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In, {
        Transparency = 1,
    })
    tween(self.CloseShadow, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In, {
        Transparency = 1,
    })
    tween(self.CloseQuestion, 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.In, {
        TextTransparency = 1,
    })
    tween(self.CloseBadge, 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.In, {
        BackgroundTransparency = 1,
    })
    tween(self.CloseIcon, 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.In, {
        ImageTransparency = 1,
    })
    tween(self.CloseDescription, 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.In, {
        TextTransparency = 1,
    })
    tween(self.CloseDivider, 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.In, {
        BackgroundTransparency = 1,
    })
    tween(self.CloseYes, 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.In, {
        BackgroundTransparency = 1,
        TextTransparency = 1,
    })
    tween(self.CloseNo, 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.In, {
        BackgroundTransparency = 1,
        TextTransparency = 1,
    })

    task.delay(0.26, function()
        if self._destroyed
            or animation ~= self._closeConfirmationAnimation
            or self.CloseConfirmationOpen then
            return
        end
        self.CloseOverlay.Visible = false
    end)
end

function Library:_ReflowNotifications()
    local bottomOffset = 14

    for index = #self.Notifications, 1, -1 do
        local notification = self.Notifications[index]
        if notification.Frame.Parent then
            local target = UDim2.new(1, -14, 1, -(bottomOffset + notification.Height))
            notification.TargetPosition = target

            if notification.PositionTween then
                notification.PositionTween:Cancel()
            end
            notification.PositionTween = tween(
                notification.Frame,
                0.48,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out,
                {Position = target}
            )
            bottomOffset += notification.Height + 8
        end
    end
end

function Library:_DismissNotification(notification)
    if notification.Closing or self._destroyed or not notification.Frame.Parent then
        return
    end
    notification.Closing = true

    if notification.PositionTween then
        notification.PositionTween:Cancel()
    end
    tween(notification.Frame, 0.38, Enum.EasingStyle.Quint, Enum.EasingDirection.In, {
        Position = UDim2.new(1, 270, notification.Frame.Position.Y.Scale, notification.Frame.Position.Y.Offset),
        BackgroundTransparency = 1,
    })
    tween(notification.TextLabel, 0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.In, {
        TextTransparency = 1,
    })
    tween(notification.Shadow, 0.28, Enum.EasingStyle.Sine, Enum.EasingDirection.In, {
        Transparency = 1,
    })

    task.delay(0.4, function()
        if self._destroyed then
            return
        end
        local position = table.find(self.Notifications, notification)
        if position then
            table.remove(self.Notifications, position)
        end
        if notification.Frame.Parent then
            notification.Frame:Destroy()
        end
        self:_ReflowNotifications()
    end)
end

function Library:Notify(config)
    assert(not self._destroyed, "Cannot create a notification after the UI is destroyed")

    if type(config) == "string" then
        config = {Text = config}
    end
    config = config or {}

    local message = tostring(config.Text or config.Description or "Notification")
    local duration = math.max(1.5, tonumber(config.Duration) or 4.5)
    local textWidth = 233
    local bounds = TextService:GetTextSize(
        message,
        16,
        Enum.Font.Roboto,
        Vector2.new(textWidth, 10000)
    )
    local height = math.max(35, math.ceil(bounds.Y) + 12)

    self._notificationId += 1
    local frame = make("Frame", {
        Name = "Notification_" .. tostring(self._notificationId),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Position = UDim2.new(1, 270, 1, -(14 + height)),
        Size = UDim2.fromOffset(249, height),
        ZIndex = 50,
    }, self.ScreenGui)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, frame)
    local shadow = make("UIShadow", {
        Name = "UIShadow",
        Color = Color3.new(0, 0, 0),
        Offset = UDim2.fromOffset(0, 0),
        Transparency = 1,
        ZIndex = -1,
    }, frame)
    local textLabel = make("TextLabel", {
        Name = "TextLabel",
        BackgroundTransparency = 1,
        FontFace = Font.new(
            "rbxasset://fonts/families/Roboto.json",
            Enum.FontWeight.Medium,
            Enum.FontStyle.Normal
        ),
        MaxVisibleGraphemes = 0,
        Position = UDim2.fromOffset(8, 6),
        Size = UDim2.new(1, -16, 1, -12),
        Text = message,
        TextColor3 = Color3.fromRGB(176, 176, 176),
        TextSize = 16,
        TextTransparency = 1,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 51,
    }, frame)

    local notification = {
        Frame = frame,
        Height = height,
        Shadow = shadow,
        TextLabel = textLabel,
        Closing = false,
    }
    table.insert(self.Notifications, notification)
    self:_ReflowNotifications()

    tween(frame, 0.46, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {
        BackgroundTransparency = 0,
    })
    tween(shadow, 0.48, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
        Transparency = 0.5,
    })
    tween(textLabel, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
        TextTransparency = 0,
    })

    task.spawn(function()
        task.wait(0.13)
        local graphemes = utf8.len(message) or #message
        local delayPerLetter = math.clamp(1.15 / math.max(graphemes, 1), 0.012, 0.045)
        for visible = 1, graphemes do
            if self._destroyed or notification.Closing or not frame.Parent then
                return
            end
            textLabel.MaxVisibleGraphemes = visible
            task.wait(delayPerLetter)
        end
        if frame.Parent then
            textLabel.MaxVisibleGraphemes = -1
        end
    end)

    task.delay(duration, function()
        self:_DismissNotification(notification)
    end)

    return notification
end

function Library:CreateTab(config)
    assert(type(config) == "table", "CreateTab expects a configuration table")
    assert(not self._destroyed, "Cannot create a tab after the UI is destroyed")

    self._tabCount += 1

    local rowOffset = (self._tabCount - 1) * 38
    local finalIconPosition = UDim2.fromOffset(17, 86 + rowOffset)
    local finalLabelPosition = UDim2.fromOffset(47, 87 + rowOffset)

    local icon = make("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = tostring(config.Icon or ""),
        ImageColor3 = COLORS.Icon,
        ImageTransparency = 1,
        Position = UDim2.fromOffset(9, 86 + rowOffset),
        Size = UDim2.fromOffset(23, 24),
        ZIndex = 3,
    }, self.Topbar)

    local labelText = tostring(config.Title or "")
    local descriptionText = tostring(config.Description or "")
    if descriptionText ~= "" then
        labelText ..= " " .. descriptionText
    end

    local label = make("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        FontFace = Font.new(
            "rbxasset://fonts/families/Roboto.json",
            Enum.FontWeight.Medium,
            Enum.FontStyle.Normal
        ),
        Position = UDim2.fromOffset(39, 87 + rowOffset),
        Size = UDim2.fromOffset(104, 24),
        Text = labelText,
        TextColor3 = Color3.fromRGB(176, 176, 176),
        TextSize = 15,
        TextTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
    }, self.Topbar)

    local button = make("TextButton", {
        Name = "Button",
        Active = false,
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(8, 82 + rowOffset),
        Size = UDim2.fromOffset(143, 32),
        Text = "",
        ZIndex = 4,
    }, self.Topbar)

    local page = make("ScrollingFrame", {
        Name = descriptionText .. "Page",
        Active = true,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.fromOffset(0, 0),
        ClipsDescendants = true,
        ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
        Position = UDim2.fromOffset(0, 0),
        ScrollBarImageColor3 = Color3.fromRGB(95, 95, 95),
        ScrollBarImageTransparency = 1,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Size = UDim2.fromScale(1, 1),
        VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
        Visible = false,
        ZIndex = 2,
    }, self.Content)
    make("UIPadding", {
        PaddingBottom = UDim.new(0, 16),
    }, page)

    local leftColumn = make("Frame", {
        Name = "Left",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 12),
        Size = UDim2.fromOffset(292, 0),
        ZIndex = 2,
    }, page)
    make("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, leftColumn)

    local rightColumn = make("Frame", {
        Name = "Right",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(316, 12),
        Size = UDim2.fromOffset(292, 0),
        ZIndex = 2,
    }, page)
    make("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, rightColumn)

    local component = {
        Icon = icon,
        Label = label,
        Button = button,
        Index = self._tabCount,
        RowOffset = rowOffset,
        Page = page,
        Left = leftColumn,
        Right = rightColumn,
        Sections = {},
        LeftCount = 0,
        RightCount = 0,
        Title = tostring(config.Title or ""),
        Description = descriptionText,
    }
    table.insert(self._connections, button.Activated:Connect(function()
        self:SelectTab(component)
    end))
    table.insert(self.Tabs, component)

    local window = self
    function component:CreateSection(sectionConfig)
        return window:CreateSection(self, sectionConfig)
    end
    if #self.Tabs == 1 then
        task.defer(function()
            if not window._destroyed and not window.SelectedTab then
                window:SelectTab(component, true)
            end
        end)
    end

    local entranceDelay = 0.72 + (self._tabCount - 1) * 0.085
    task.delay(entranceDelay, function()
        if self._destroyed or not icon.Parent or not label.Parent then
            return
        end
        finalIconPosition = UDim2.fromOffset(17, 86 + component.RowOffset)
        finalLabelPosition = UDim2.fromOffset(47, 87 + component.RowOffset)

        tween(
            icon,
            0.38,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out,
            {
                ImageTransparency = 0,
                Position = finalIconPosition,
            }
        )
        tween(
            label,
            0.42,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out,
            {
                Position = finalLabelPosition,
                TextTransparency = 0,
            }
        )

        task.delay(0.3, function()
            if not self._destroyed and button.Parent then
                button.Active = true
            end
        end)
    end)

    return component
end

function Library:CreateSection(tab, config)
    assert(type(tab) == "table", "CreateSection expects a tab component")
    assert(type(config) == "table", "CreateSection expects a configuration table")
    assert(not self._destroyed, "Cannot create a section after the UI is destroyed")

    local side = string.lower(tostring(config.Side or "Left"))
    local column
    local layoutOrder
    if side == "right" then
        tab.RightCount += 1
        column = tab.Right
        layoutOrder = tab.RightCount * 100
    else
        tab.LeftCount += 1
        column = tab.Left
        layoutOrder = tab.LeftCount * 100
    end

    local section = make("Frame", {
        Name = "Section",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        LayoutOrder = layoutOrder,
        Size = UDim2.fromOffset(292, 30),
        ZIndex = 2,
    }, column)

    local icon = make("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = tostring(config.Icon or ""),
        ImageColor3 = COLORS.Icon,
        Position = UDim2.fromOffset(2, 5),
        Size = UDim2.fromOffset(16, 16),
        ZIndex = 3,
    }, section)

    local title = make("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        FontFace = Font.new(
            "rbxasset://fonts/families/Roboto.json",
            Enum.FontWeight.Medium,
            Enum.FontStyle.Normal
        ),
        Position = UDim2.fromOffset(26, 1),
        Size = UDim2.fromOffset(265, 24),
        Text = tostring(config.Title or "Section"),
        TextColor3 = Color3.fromRGB(176, 176, 176),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
    }, section)

    local container = make("Frame", {
        Name = "Components",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 30),
        Size = UDim2.fromOffset(292, 0),
        ZIndex = 3,
    }, section)
    make("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, container)

    local component = {
        Frame = section,
        Icon = icon,
        Title = title,
        Container = container,
        Side = side,
        Tab = tab,
        Height = 30,
        ComponentsHeight = 0,
        Components = {},
    }
    table.insert(tab.Sections, component)

    local window = self
    for _, kind in ipairs({"Toggle", "Slider", "Input", "Button", "Comment", "LargeText", "Dropdown",
        "MultiDropdown", "Paragraph", "Keybind", "ColorPicker"}) do
        component["Create" .. kind] = function(sectionSelf, componentConfig)
            return window["Create" .. kind](window, sectionSelf, componentConfig)
        end
    end
    return component
end

function Library:_CreateComponentBox(section, height, name)
    height = math.clamp(tonumber(height) or 36, 34, 140)
    local count = #section.Components + 1
    local card = make("Frame", {
        Name = name or "Component",
        Active = true,
        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
        BorderSizePixel = 0,
        LayoutOrder = count,
        Size = UDim2.fromOffset(292, height),
        ZIndex = 4,
    }, section.Container)
    make("UICorner", {CornerRadius = UDim.new(0, 7)}, card)
    local stroke = make("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(38, 38, 38),
        Thickness = 1,
        Transparency = 0.72,
    }, card)

    section.ComponentsHeight += height
    local spacing = math.max(0, count - 1) * 8
    section.Container.Size = UDim2.fromOffset(292, section.ComponentsHeight + spacing)
    section.Height = 30 + section.ComponentsHeight + spacing
    section.Frame.Size = UDim2.fromOffset(292, section.Height)

    return card, stroke
end

function Library:CreateToggle(section, config)
    assert(type(section) == "table" and section.Container, "CreateToggle expects a section component")
    assert(type(config) == "table", "CreateToggle expects a configuration table")
    assert(not self._destroyed, "Cannot create a toggle after the UI is destroyed")

    local card, stroke = self:_CreateComponentBox(section, 36, "Toggle")

    local title = make("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        FontFace = Font.new(
            "rbxasset://fonts/families/Roboto.json",
            Enum.FontWeight.Medium,
            Enum.FontStyle.Normal
        ),
        Position = UDim2.fromOffset(12, 8),
        Size = UDim2.new(1, -70, 0, 20),
        Text = tostring(config.Title or config.Text or "Toggle"),
        TextColor3 = Color3.fromRGB(190, 190, 190),
        TextSize = 14,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
    }, card)

    local offColor = Color3.fromRGB(82, 82, 82)
    local onColor = Color3.fromRGB(72, 168, 98)
    local track = make("Frame", {
        Name = "Track",
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = offColor,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(38, 20),
        ZIndex = 6,
    }, card)
    make("UICorner", {CornerRadius = UDim.new(1, 0)}, track)

    local knob = make("Frame", {
        Name = "Knob",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(3, 4),
        Size = UDim2.fromOffset(17, 12),
        Visible = false,
        ZIndex = 7,
    }, track)
    make("UICorner", {CornerRadius = UDim.new(1, 0)}, knob)
    local knobShadow = make("UIShadow", {
        Name = "UIShadow",
        BlurRadius = UDim.new(0, 6),
        Color = Color3.new(0, 0, 0),
        Enabled = true,
        Inset = false,
        Mode = Enum.ApplyShadowMode.Shape,
        Offset = UDim2.fromOffset(1, 1),
        ShowBehindParent = true,
        Spread = UDim2.fromOffset(0, 0),
        Transparency = 0.72,
        ZIndex = -1,
    }, knob)

    local knobCenter = make("Frame", {
        Name = "Center",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(6, 6),
        ZIndex = 8,
    }, knob)
    make("UICorner", {CornerRadius = UDim.new(0, 2)}, knobCenter)

    local button = make("TextButton", {
        Name = "Button",
        Active = true,
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        Text = "",
        ZIndex = 8,
    }, card)

    local component = {
        Card = card,
        Stroke = stroke,
        Title = title,
        Track = track,
        Knob = knob,
        KnobCenter = knobCenter,
        KnobShadow = knobShadow,
        Button = button,
        Section = section,
        Value = false,
        Callback = config.Callback,
        _tweens = {},
    }

    function component:SetValue(value, silent)
        value = value == true
        if self.Value == value and self._initialized then
            return
        end
        self.Value = value
        self._initialized = true

        for _, activeTween in ipairs(self._tweens) do
            activeTween:Cancel()
        end
        table.clear(self._tweens)

        table.insert(self._tweens, tween(track, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
            BackgroundColor3 = value and onColor or offColor,
        }))
        table.insert(self._tweens, tween(knob, 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {
            Position = value and UDim2.fromOffset(18, 4) or UDim2.fromOffset(3, 4),
        }))
        table.insert(self._tweens, tween(knobCenter, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        }))

        if not silent and type(self.Callback) == "function" then
            task.spawn(self.Callback, value)
        end
    end

    function component:GetValue()
        return self.Value
    end

    table.insert(self._connections, button.Activated:Connect(function()
        component:SetValue(not component.Value)
    end))
    table.insert(self._connections, button.MouseEnter:Connect(function()
        tween(card, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(17, 17, 17),
        })
        tween(stroke, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            Transparency = 0.48,
        })
    end))
    table.insert(self._connections, button.MouseLeave:Connect(function()
        tween(card, 0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(13, 13, 13),
        })
        tween(stroke, 0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            Transparency = 0.72,
        })
    end))

    table.insert(section.Components, component)
    component:SetValue(config.Default == true, true)
    return component
end

function Library:CreateSlider(section, config)
    assert(type(section) == "table" and section.Container, "CreateSlider expects a section component")
    assert(type(config) == "table", "CreateSlider expects a configuration table")
    assert(not self._destroyed, "Cannot create a slider after the UI is destroyed")

    local minimum = tonumber(config.Min) or 0
    local maximum = tonumber(config.Max) or 100
    if maximum <= minimum then
        maximum = minimum + 1
    end
    local increment = math.max(tonumber(config.Increment) or 1, 0.0001)
    local card, stroke = self:_CreateComponentBox(section, 36, "Slider")
    card.BackgroundTransparency = 0
    stroke.Enabled = true

    local title = make("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        FontFace = Font.new(
            "rbxasset://fonts/families/Roboto.json",
            Enum.FontWeight.Medium,
            Enum.FontStyle.Normal
        ),
        Position = UDim2.fromOffset(12, 8),
        Size = UDim2.fromOffset(126, 20),
        Text = tostring(config.Title or config.Text or "Slider"),
        TextColor3 = Color3.fromRGB(190, 190, 190),
        TextSize = 14,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
    }, card)

    local track = make("Frame", {
        Name = "Track",
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(43, 43, 43),
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Position = UDim2.new(0, 166, 0.5, 0),
        Size = UDim2.fromOffset(82, 10),
        ZIndex = 6,
    }, card)
    make("UICorner", {CornerRadius = UDim.new(1, 0)}, track)

    local fill = make("Frame", {
        Name = "Fill",
        BackgroundColor3 = Color3.fromRGB(123, 123, 123),
        BorderSizePixel = 0,
        Size = UDim2.fromScale(0, 1),
        ZIndex = 7,
    }, track)
    make("UICorner", {CornerRadius = UDim.new(1, 0)}, fill)

    local valueBox = make("TextBox", {
        Name = "Value",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        FontFace = Font.new(
            "rbxasset://fonts/families/Roboto.json",
            Enum.FontWeight.Medium,
            Enum.FontStyle.Normal
        ),
        Position = UDim2.fromOffset(246, 7),
        Size = UDim2.fromOffset(34, 22),
        Text = "0",
        TextColor3 = Color3.fromRGB(166, 166, 166),
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.None,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 10,
    }, card)

    local handle = make("Frame", {
        Name = "Handle",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(235, 235, 235),
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0, 0.5),
        Size = UDim2.fromOffset(5, 18),
        Visible = false,
        ZIndex = 8,
    }, track)
    make("UICorner", {CornerRadius = UDim.new(0, 2)}, handle)
    local handleShadow = make("UIShadow", {
        Name = "UIShadow",
        BlurRadius = UDim.new(0, 5),
        Color = Color3.new(0, 0, 0),
        Enabled = true,
        Inset = false,
        Mode = Enum.ApplyShadowMode.Shape,
        Offset = UDim2.fromOffset(1, 1),
        ShowBehindParent = true,
        Spread = UDim2.fromOffset(0, 0),
        Transparency = 0.68,
        ZIndex = -1,
    }, handle)

    local hitbox = make("TextButton", {
        Name = "Hitbox",
        Active = true,
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(158, 0),
        Size = UDim2.fromOffset(96, 36),
        Text = "",
        ZIndex = 9,
    }, card)

    local component = {
        Card = card,
        Stroke = stroke,
        Title = title,
        Track = track,
        Knob = handle,
        KnobCenter = fill,
        KnobShadow = handleShadow,
        Hitbox = hitbox,
        ValueBox = valueBox,
        Section = section,
        NoBox = false,
        Min = minimum,
        Max = maximum,
        Increment = increment,
        Value = minimum,
        Callback = config.Callback,
        _valueTweens = {},
    }

    local function valueToAlpha(value)
        return math.clamp((value - minimum) / (maximum - minimum), 0, 1)
    end

    local decimals = 0
    local decimalTest = increment
    while decimals < 4 and math.abs(decimalTest - math.floor(decimalTest + 0.5)) > 0.000001 do
        decimalTest *= 10
        decimals += 1
    end
    local function formatValue(value)
        return string.format("%." .. tostring(decimals) .. "f", value)
    end

    function component:SetValue(value, silent, instant)
        value = math.clamp(tonumber(value) or minimum, minimum, maximum)
        value = minimum + math.floor(((value - minimum) / increment) + 0.5) * increment
        value = math.clamp(value, minimum, maximum)
        if self._initialized and self.Value == value then
            return
        end
        self._initialized = true
        self.Value = value
        valueBox.Text = formatValue(value)

        for _, activeTween in ipairs(self._valueTweens) do
            activeTween:Cancel()
        end
        table.clear(self._valueTweens)

        local alpha = valueToAlpha(value)
        local fillSize = UDim2.fromScale(alpha, 1)
        local handlePosition = UDim2.fromScale(alpha, 0.5)
        if instant then
            fill.Size = fillSize
            handle.Position = handlePosition
        else
            table.insert(self._valueTweens, tween(fill, 0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {
                Size = fillSize,
            }))
            table.insert(self._valueTweens, tween(handle, 0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {
                Position = handlePosition,
            }))
        end

        if not silent and type(self.Callback) == "function" then
            task.spawn(self.Callback, value)
        end
    end

    function component:GetValue()
        return self.Value
    end

    function component:SetRange(newMinimum, newMaximum, silent)
        newMinimum = tonumber(newMinimum) or minimum
        newMaximum = tonumber(newMaximum) or maximum
        if newMaximum <= newMinimum then
            newMaximum = newMinimum + increment
        end
        minimum = newMinimum
        maximum = newMaximum
        self.Min = minimum
        self.Max = maximum
        self._initialized = false
        self:SetValue(self.Value, silent == true, false)
    end

    function component:SetMin(newMinimum, silent)
        self:SetRange(newMinimum, maximum, silent)
    end

    function component:SetMax(newMaximum, silent)
        self:SetRange(minimum, newMaximum, silent)
    end

    local dragging = false
    local dragType = nil
    local fillColorTween = nil
    local function setInteracting(interacting)
        if fillColorTween then
            fillColorTween:Cancel()
        end
        fillColorTween = tween(fill, 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            BackgroundColor3 = interacting
                and Color3.fromRGB(205, 205, 205)
                or Color3.fromRGB(123, 123, 123),
        })
    end
    local function updateFromX(x, instant)
        if track.AbsoluteSize.X <= 0 then
            return
        end
        local alpha = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        component:SetValue(minimum + (maximum - minimum) * alpha, false, instant)
    end

    table.insert(self._connections, hitbox.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        dragging = true
        dragType = input.UserInputType
        setInteracting(true)
        updateFromX(input.Position.X, false)
    end))
    table.insert(self._connections, UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end
        local mouseMove = dragType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseMovement
        local touchMove = dragType == Enum.UserInputType.Touch
            and input.UserInputType == Enum.UserInputType.Touch
        if mouseMove or touchMove then
            updateFromX(input.Position.X, true)
        end
    end))
    table.insert(self._connections, UserInputService.InputEnded:Connect(function(input)
        if dragging and input.UserInputType == dragType then
            dragging = false
            dragType = nil
            setInteracting(false)
        end
    end))
    table.insert(self._connections, hitbox.MouseEnter:Connect(function()
        tween(track, 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(51, 51, 51),
        })
    end))
    table.insert(self._connections, hitbox.MouseLeave:Connect(function()
        tween(track, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(43, 43, 43),
        })
    end))
    table.insert(self._connections, valueBox.Focused:Connect(function()
        setInteracting(true)
        tween(valueBox, 0.16, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            TextColor3 = Color3.fromRGB(235, 235, 235),
        })
    end))
    table.insert(self._connections, valueBox.FocusLost:Connect(function()
        setInteracting(false)
        local typed = tonumber((string.gsub(valueBox.Text, ",", ".")))
        if typed then
            component:SetValue(typed, false, false)
            valueBox.Text = formatValue(component.Value)
        else
            valueBox.Text = formatValue(component.Value)
        end
        tween(valueBox, 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            TextColor3 = Color3.fromRGB(166, 166, 166),
        })
    end))

    table.insert(section.Components, component)
    component:SetValue(tonumber(config.Default) or minimum, true, true)
    return component
end

function Library:CreateInput(section, config)
    assert(type(section) == "table" and section.Container, "CreateInput expects a section component")
    assert(type(config) == "table", "CreateInput expects a configuration table")
    assert(not self._destroyed, "Cannot create an input after the UI is destroyed")

    local card, stroke = self:_CreateComponentBox(section, 36, "Input")
    card.ClipsDescendants = true
    local title = make("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        FontFace = Font.new(
            "rbxasset://fonts/families/Roboto.json",
            Enum.FontWeight.Medium,
            Enum.FontStyle.Normal
        ),
        Position = UDim2.fromOffset(12, 8),
        Size = UDim2.fromOffset(94, 20),
        Text = tostring(config.Title or config.Name or "Input"),
        TextColor3 = Color3.fromRGB(190, 190, 190),
        TextSize = 14,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
    }, card)

    local inputFrame = make("Frame", {
        Name = "InputArea",
        BackgroundColor3 = Color3.fromRGB(18, 18, 18),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.fromOffset(116, 5),
        Size = UDim2.fromOffset(164, 26),
        ZIndex = 7,
    }, card)
    make("UICorner", {CornerRadius = UDim.new(0, 6)}, inputFrame)

    local textBox = make("TextBox", {
        Name = "TextBox",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        FontFace = Font.new(
            "rbxasset://fonts/families/Roboto.json",
            Enum.FontWeight.Regular,
            Enum.FontStyle.Normal
        ),
        PlaceholderColor3 = Color3.fromRGB(91, 91, 91),
        PlaceholderText = tostring(config.Placeholder or "Type here..."),
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromScale(1, 1),
        Text = tostring(config.Default or ""),
        TextColor3 = Color3.fromRGB(190, 190, 190),
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.None,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8,
    }, inputFrame)
    make("UIPadding", {
        PaddingLeft = UDim.new(0, 9),
        PaddingRight = UDim.new(0, 9),
    }, textBox)
    local inputStroke = make("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(45, 45, 45),
        Thickness = 1,
        Transparency = 0.75,
    }, inputFrame)

    local component = {
        Card = card,
        Stroke = stroke,
        Title = title,
        InputArea = inputFrame,
        TextBox = textBox,
        Section = section,
        Value = textBox.Text,
        Callback = config.Callback,
    }

    function component:SetValue(value, silent)
        value = tostring(value or "")
        self.Value = value
        textBox.Text = value
        if not silent and type(self.Callback) == "function" then
            task.spawn(self.Callback, value)
        end
    end

    function component:GetValue()
        return self.Value
    end

    table.insert(self._connections, textBox.Focused:Connect(function()
        tween(card, 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(17, 17, 17),
        })
        tween(inputStroke, 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            Color = Color3.fromRGB(82, 82, 82),
            Transparency = 0.35,
        })
    end))
    table.insert(self._connections, textBox.FocusLost:Connect(function()
        component:SetValue(textBox.Text)
        tween(card, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(13, 13, 13),
        })
        tween(inputStroke, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            Color = Color3.fromRGB(45, 45, 45),
            Transparency = 0.75,
        })
    end))

    table.insert(section.Components, component)
    return component
end

function Library:CreateButton(section, config)
    assert(type(section) == "table" and section.Container, "CreateButton expects a section component")
    assert(type(config) == "table", "CreateButton expects a configuration table")
    assert(not self._destroyed, "Cannot create a button after the UI is destroyed")

    local card, stroke = self:_CreateComponentBox(section, 36, "Button")
    local button = make("TextButton", {
        Name = "Button",
        Active = true,
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        FontFace = Font.new(
            "rbxasset://fonts/families/Roboto.json",
            Enum.FontWeight.Medium,
            Enum.FontStyle.Normal
        ),
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -24, 1, 0),
        Text = tostring(config.Name or config.Title or "Button"),
        TextColor3 = Color3.fromRGB(190, 190, 190),
        TextSize = 14,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 7,
    }, card)

    local component = {
        Card = card,
        Stroke = stroke,
        Title = button,
        Button = button,
        Section = section,
        Callback = config.Callback,
    }

    function component:SetName(name)
        button.Text = tostring(name or "Button")
    end

    table.insert(self._connections, button.Activated:Connect(function()
        tween(card, 0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(26, 26, 26),
        })
        task.delay(0.09, function()
            if not self._destroyed and card.Parent then
                tween(card, 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
                    BackgroundColor3 = Color3.fromRGB(17, 17, 17),
                })
            end
        end)
        if type(component.Callback) == "function" then
            task.spawn(component.Callback)
        end
    end))
    table.insert(self._connections, button.MouseEnter:Connect(function()
        tween(card, 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(17, 17, 17),
        })
        tween(stroke, 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            Transparency = 0.46,
        })
    end))
    table.insert(self._connections, button.MouseLeave:Connect(function()
        tween(card, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(13, 13, 13),
        })
        tween(stroke, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            Transparency = 0.72,
        })
    end))

    table.insert(section.Components, component)
    return component
end

function Library:CreateComment(section, config)
    assert(type(section) == "table" and section.Container, "CreateComment expects a section component")
    assert(type(config) == "table", "CreateComment expects a configuration table")
    assert(not self._destroyed, "Cannot create a comment after the UI is destroyed")

    local card, stroke = self:_CreateComponentBox(section, 34, "Comment")

    local textLabel = make("TextLabel", {
        Name = "Text",
        BackgroundTransparency = 1,
        FontFace = Font.new(
            "rbxasset://fonts/families/Roboto.json",
            Enum.FontWeight.Regular,
            Enum.FontStyle.Normal
        ),
        Position = UDim2.fromOffset(12, 7),
        Size = UDim2.new(1, -24, 0, 20),
        Text = tostring(config.Text or config.Name or "Comment"),
        TextColor3 = Color3.fromRGB(130, 130, 130),
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
    }, card)

    local component = {
        Card = card,
        Stroke = stroke,
        Title = textLabel,
        Text = textLabel,
        Section = section,
        NoBox = false,
    }

    function component:SetText(text)
        textLabel.Text = tostring(text or "")
    end

    table.insert(section.Components, component)
    return component
end

function Library:CreateLargeText(section, config)
    assert(type(section) == "table" and section.Container, "CreateLargeText expects a section component")
    assert(type(config) == "table", "CreateLargeText expects a configuration table")
    assert(not self._destroyed, "Cannot create large text after the UI is destroyed")

    local currentHeight = 36
    local card, stroke = self:_CreateComponentBox(section, currentHeight, "LargeText")
    local textLabel = make("TextLabel", {
        Name = "Text",
        BackgroundTransparency = 1,
        FontFace = Font.new(
            "rbxasset://fonts/families/Roboto.json",
            Enum.FontWeight.Regular,
            Enum.FontStyle.Normal
        ),
        Position = UDim2.fromOffset(12, 9),
        Size = UDim2.fromOffset(268, 18),
        Text = tostring(config.Text or "Large text"),
        TextColor3 = Color3.fromRGB(145, 145, 145),
        TextSize = 13,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 6,
    }, card)

    local component = {
        Card = card,
        Stroke = stroke,
        Title = textLabel,
        Text = textLabel,
        Section = section,
        NoBox = false,
        Height = currentHeight,
    }

    local function resizeToText()
        local bounds = TextService:GetTextSize(
            textLabel.Text,
            textLabel.TextSize,
            Enum.Font.Roboto,
            Vector2.new(268, 10000)
        )
        local newHeight = math.max(36, math.ceil(bounds.Y) + 18)
        if newHeight == currentHeight then
            textLabel.Size = UDim2.fromOffset(268, newHeight - 18)
            return
        end

        local difference = newHeight - currentHeight
        currentHeight = newHeight
        component.Height = newHeight
        card.Size = UDim2.fromOffset(292, newHeight)
        textLabel.Size = UDim2.fromOffset(268, newHeight - 18)

        section.ComponentsHeight += difference
        local spacing = math.max(0, #section.Components - 1) * 8
        section.Container.Size = UDim2.fromOffset(292, section.ComponentsHeight + spacing)
        section.Height = 30 + section.ComponentsHeight + spacing
        section.Frame.Size = UDim2.fromOffset(292, section.Height)
    end

    function component:SetText(text)
        textLabel.Text = tostring(text or "")
        resizeToText()
    end

    table.insert(section.Components, component)
    resizeToText()
    return component
end

function Library:_ResizeComponent(section, card, newHeight)
    local oldHeight = card.AbsoluteSize.Y > 0 and card.Size.Y.Offset or card.Size.Y.Offset
    if newHeight == oldHeight then
        return
    end
    card.Size = UDim2.fromOffset(292, newHeight)
    section.ComponentsHeight += newHeight - oldHeight
    local spacing = math.max(0, #section.Components - 1) * 8
    section.Container.Size = UDim2.fromOffset(292, section.ComponentsHeight + spacing)
    section.Height = 30 + section.ComponentsHeight + spacing
    section.Frame.Size = UDim2.fromOffset(292, section.Height)
end

local function regularFont(weight)
    return Font.new("rbxasset://fonts/families/Roboto.json", weight or Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end

function Library:CreateDropdown(section, config)
    assert(type(section) == "table" and section.Container, "CreateDropdown expects a section component")
    assert(type(config) == "table", "CreateDropdown expects a configuration table")
    assert(not self._destroyed, "Cannot create a dropdown after the UI is destroyed")

    local window = self
    local multi = config.Multi == true
    local ROW, MAX_LIST = 29, 232
    local card, stroke = self:_CreateComponentBox(section, 36, "Dropdown")

    local title = make("TextLabel", {
        Name = "Title", BackgroundTransparency = 1, FontFace = regularFont(Enum.FontWeight.Medium),
        Position = UDim2.fromOffset(12, 8), Size = UDim2.fromOffset(112, 20),
        Text = tostring(config.Title or config.Text or "Dropdown"),
        TextColor3 = Color3.fromRGB(190, 190, 190), TextSize = 14,
        TextTruncate = Enum.TextTruncate.AtEnd, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7,
    }, card)
    local summary = make("TextLabel", {
        Name = "Summary", BackgroundTransparency = 1, FontFace = regularFont(),
        Position = UDim2.fromOffset(126, 8), Size = UDim2.fromOffset(132, 20),
        Text = "None", TextColor3 = Color3.fromRGB(122, 122, 122), TextSize = 12,
        TextTruncate = Enum.TextTruncate.AtEnd, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 7,
    }, card)
    local arrow = make("Frame", {
        Name = "Arrow", BackgroundTransparency = 1,
        Position = UDim2.fromOffset(264, 11), Size = UDim2.fromOffset(14, 14), ZIndex = 7,
    }, card)
    for _, spec in ipairs({{0.35, 45}, {0.65, -45}}) do
        local bar = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(155, 155, 155),
            BorderSizePixel = 0, Position = UDim2.fromScale(spec[1], 0.5), Rotation = spec[2],
            Size = UDim2.fromOffset(7, 2), ZIndex = 8,
        }, arrow)
        make("UICorner", {CornerRadius = UDim.new(1, 0)}, bar)
    end
    local headerButton = make("TextButton", {
        Name = "HeaderButton", Active = true, AutoButtonColor = false, BackgroundTransparency = 1,
        BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), Text = "", ZIndex = 9,
    }, card)

    local popup = make("Frame", {
        Name = "DropdownPopup", Active = true, BackgroundColor3 = Color3.fromRGB(13, 13, 13),
        BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true,
        Size = UDim2.fromOffset(292, 0), Visible = false, ZIndex = 100,
    }, self.ScreenGui)
    make("UICorner", {CornerRadius = UDim.new(0, 7)}, popup)
    self._scaled[make("UIScale", {Scale = self.Scale}, popup)] = true
    local popupStroke = make("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = Color3.fromRGB(38, 38, 38),
        Thickness = 1, Transparency = 1,
    }, popup)
    local popupShadow = make("UIShadow", {
        Name = "UIShadow", BlurRadius = UDim.new(0, 18), Color = Color3.new(0, 0, 0), Enabled = true,
        Inset = false, Mode = Enum.ApplyShadowMode.Shape, Offset = UDim2.fromOffset(0, 2),
        ShowBehindParent = true, Spread = UDim2.fromOffset(0, 0), Transparency = 1, ZIndex = -1,
    }, popup)

    local search = make("TextBox", {
        Name = "Search", BackgroundColor3 = Color3.fromRGB(20, 20, 20), BackgroundTransparency = 0,
        BorderSizePixel = 0, ClearTextOnFocus = false, FontFace = regularFont(),
        PlaceholderColor3 = Color3.fromRGB(95, 95, 95), PlaceholderText = "Search...",
        Position = UDim2.fromOffset(6, 6), Size = UDim2.fromOffset(280, 26), Text = "",
        TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left, Visible = false, ZIndex = 102,
    }, popup)
    make("UICorner", {CornerRadius = UDim.new(0, 6)}, search)
    make("UIPadding", {PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 9)}, search)

    local list = make("ScrollingFrame", {
        Name = "Options", Active = true, AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.fromOffset(0, 0),
        Position = UDim2.fromOffset(0, 0), Size = UDim2.new(1, 0, 1, 0),
        ScrollBarImageColor3 = Color3.fromRGB(70, 70, 70), ScrollBarThickness = 3,
        ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 101,
    }, popup)
    make("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}, list)
    make("UIPadding", {
        PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6),
    }, list)

    local component = {
        Card = card, Stroke = stroke, Title = title, ValueBox = summary, Arrow = arrow,
        HeaderButton = headerButton, Popup = popup, PopupStroke = popupStroke, PopupShadow = popupShadow,
        Section = section, Options = {}, Multi = multi, Entries = {}, Open = false,
        Callback = config.Callback, Placeholder = config.Placeholder, _popupGeneration = 0,
    }
    local selected = {}
    local lookup = {}
    local popupHeight = 0

    local function isSelected(name)
        return table.find(selected, name) ~= nil
    end

    local function paintRow(name)
        local entry = component.Entries[name]
        if not entry then return end
        local chosen = isSelected(name)
        tween(entry.Row, 0.16, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            BackgroundTransparency = chosen and 0.68 or 1,
        })
        tween(entry.Label, 0.16, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
            TextColor3 = chosen and Color3.fromRGB(215, 215, 215) or Color3.fromRGB(160, 160, 160),
        })
        if entry.Check then
            entry.Check.BackgroundTransparency = chosen and 0 or 1
        end
    end

    local function updateSummary()
        if #selected == 0 then
            summary.Text = tostring(component.Placeholder or "None")
        else
            summary.Text = table.concat(selected, ", ")
        end
    end

    local function currentValue()
        if multi then return table.clone(selected) end
        return selected[1]
    end

    local function fire(silent)
        updateSummary()
        if not silent and type(component.Callback) == "function" then
            task.spawn(component.Callback, currentValue())
        end
    end

    local function applyFilter()
        local query = string.lower(search.Text)
        for name, entry in pairs(component.Entries) do
            entry.Row.Visible = query == "" or string.find(string.lower(name), query, 1, true) ~= nil
        end
        list.CanvasPosition = Vector2.zero
    end

    local function layoutPopup()
        local useSearch = #component.Options > 6
        search.Visible = useSearch
        local top = useSearch and 36 or 0
        list.Position = UDim2.fromOffset(0, top)
        list.Size = UDim2.new(1, 0, 1, -top)
        popupHeight = math.min(#component.Options * (ROW) + 8, MAX_LIST) + top
        if #component.Options == 0 then popupHeight = 34 end
    end

    local function rebuild(options)
        for _, entry in pairs(component.Entries) do
            entry.Row:Destroy()
        end
        table.clear(component.Entries)
        table.clear(lookup)
        component.Options = {}
        for _, option in ipairs(type(options) == "table" and options or {}) do
            local name = tostring(option)
            if not lookup[name] then
                lookup[name] = true
                table.insert(component.Options, name)
            end
        end
        for index, name in ipairs(component.Options) do
            local row = make("TextButton", {
                Name = "Option", Active = true, AutoButtonColor = false,
                BackgroundColor3 = Color3.fromRGB(26, 26, 26), BackgroundTransparency = 1,
                BorderSizePixel = 0, LayoutOrder = index, Size = UDim2.new(1, -2, 0, 27),
                Text = "", ZIndex = 102,
            }, list)
            make("UICorner", {CornerRadius = UDim.new(0, 6)}, row)
            local label = make("TextLabel", {
                Name = "Label", BackgroundTransparency = 1, FontFace = regularFont(),
                Position = UDim2.fromOffset(multi and 28 or 10, 3), Size = UDim2.new(1, multi and -38 or -20, 1, -6),
                Text = name, TextColor3 = Color3.fromRGB(160, 160, 160), TextSize = 13,
                TextTruncate = Enum.TextTruncate.AtEnd, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 103,
            }, row)
            local check
            if multi then
                local box = make("Frame", {
                    BackgroundTransparency = 1, Position = UDim2.fromOffset(9, 7),
                    Size = UDim2.fromOffset(13, 13), ZIndex = 103,
                }, row)
                make("UICorner", {CornerRadius = UDim.new(0, 3)}, box)
                make("UIStroke", {Color = Color3.fromRGB(90, 90, 90), Thickness = 1}, box)
                check = make("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(210, 210, 210),
                    BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromOffset(7, 7), ZIndex = 104,
                }, box)
                make("UICorner", {CornerRadius = UDim.new(0, 2)}, check)
            end
            local entry = {Row = row, Label = label, Check = check}
            component.Entries[name] = entry
            table.insert(window._connections, row.Activated:Connect(function()
                if multi then
                    local position = table.find(selected, name)
                    if position then table.remove(selected, position) else table.insert(selected, name) end
                    paintRow(name)
                    fire(false)
                else
                    if selected[1] == name then
                        component:SetOpen(false)
                        return
                    end
                    local previous = selected[1]
                    selected[1] = name
                    if previous then paintRow(previous) end
                    paintRow(name)
                    fire(false)
                    component:SetOpen(false)
                end
            end))
            table.insert(window._connections, row.MouseEnter:Connect(function()
                if not isSelected(name) then
                    tween(row, 0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {BackgroundTransparency = 0.86})
                end
            end))
            table.insert(window._connections, row.MouseLeave:Connect(function()
                tween(row, 0.14, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
                    BackgroundTransparency = isSelected(name) and 0.68 or 1,
                })
            end))
            paintRow(name)
        end
        layoutPopup()
        applyFilter()
    end

    function component:GetValue()
        return currentValue()
    end
    function component:GetValues()
        return table.clone(selected)
    end

    function component:SetValue(value, silent)
        local previous = table.clone(selected)
        table.clear(selected)
        if multi then
            if type(value) == "table" then
                for key, item in pairs(value) do
                    local name = type(key) == "number" and tostring(item) or (item == true and tostring(key) or nil)
                    if name and not table.find(selected, name) then table.insert(selected, name) end
                end
            elseif value ~= nil then
                table.insert(selected, tostring(value))
            end
        elseif type(value) == "table" then
            if value[1] ~= nil then selected[1] = tostring(value[1]) end
        elseif value ~= nil then
            selected[1] = tostring(value)
        end
        for _, name in ipairs(previous) do paintRow(name) end
        for _, name in ipairs(selected) do paintRow(name) end
        fire(silent)
    end
    component.SetValues = component.SetValue

    function component:SetOptions(options)
        rebuild(options)
        for index = #selected, 1, -1 do
            if not lookup[selected[index]] then table.remove(selected, index) end
        end
        for _, name in ipairs(selected) do paintRow(name) end
        updateSummary()
        if self.Open then
            popup.Size = UDim2.fromOffset(292, popupHeight)
        end
    end
    component.Refresh = component.SetOptions

    local function popupPosition(gap)
        local absolute = card.AbsolutePosition
        local y = absolute.Y + card.AbsoluteSize.Y + (gap or 6)
        local camera = workspace.CurrentCamera
        local viewportHeight = camera and camera.ViewportSize.Y or 10000
        local scaledHeight = popupHeight * window.Scale
        if y + scaledHeight > viewportHeight then y = absolute.Y - scaledHeight - (gap or 6) end
        return UDim2.fromOffset(absolute.X, y)
    end

    function component:SetOpen(open)
        open = open == true
        if self.Open == open then return end
        self.Open = open
        self._popupGeneration += 1
        local generation = self._popupGeneration
        if open then
            search.Text = ""
            applyFilter()
            popup.Visible = true
            popup.Position = popupPosition(2)
            popup.Size = UDim2.fromOffset(292, 0)
            popup.BackgroundTransparency = 1
            tween(popup, 0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {
                Position = popupPosition(6), Size = UDim2.fromOffset(292, popupHeight), BackgroundTransparency = 0,
            })
            tween(popupStroke, 0.24, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {Transparency = 0.55})
            tween(popupShadow, 0.28, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {Transparency = 0.5})
            tween(arrow, 0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {Rotation = 180})
            return
        end
        search:ReleaseFocus()
        tween(popup, 0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In, {
            Position = popupPosition(2), Size = UDim2.fromOffset(292, 0), BackgroundTransparency = 1,
        })
        tween(popupStroke, 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.In, {Transparency = 1})
        tween(popupShadow, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In, {Transparency = 1})
        tween(arrow, 0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {Rotation = 0})
        task.delay(0.24, function()
            if not window._destroyed and component._popupGeneration == generation and not component.Open then
                popup.Visible = false
            end
        end)
    end

    local function pointInside(guiObject, point)
        local position, size = guiObject.AbsolutePosition, guiObject.AbsoluteSize
        return point.X >= position.X and point.X <= position.X + size.X
            and point.Y >= position.Y and point.Y <= position.Y + size.Y
    end

    table.insert(self._connections, search:GetPropertyChangedSignal("Text"):Connect(applyFilter))
    table.insert(self._connections, headerButton.Activated:Connect(function()
        component:SetOpen(not component.Open)
    end))
    table.insert(self._connections, headerButton.MouseEnter:Connect(function()
        tween(card, 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {BackgroundColor3 = Color3.fromRGB(17, 17, 17)})
    end))
    table.insert(self._connections, headerButton.MouseLeave:Connect(function()
        tween(card, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {BackgroundColor3 = Color3.fromRGB(13, 13, 13)})
    end))
    table.insert(self._connections, UserInputService.InputBegan:Connect(function(input)
        if not component.Open then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local point = Vector2.new(input.Position.X, input.Position.Y)
        if not pointInside(card, point) and not pointInside(popup, point) then component:SetOpen(false) end
    end))
    table.insert(self._connections, card:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        if component.Open then popup.Position = popupPosition(6) end
    end))

    table.insert(section.Components, component)
    rebuild(config.Options)
    component:SetValue(config.Default, true)
    return component
end

function Library:CreateMultiDropdown(section, config)
    config = table.clone(config or {})
    config.Multi = true
    return self:CreateDropdown(section, config)
end

function Library:CreateParagraph(section, config)
    assert(type(section) == "table" and section.Container, "CreateParagraph expects a section component")
    config = config or {}
    local card, stroke = self:_CreateComponentBox(section, 36, "Paragraph")
    local titleText = tostring(config.Title or config.Name or "")
    local title = make("TextLabel", {
        Name = "Title", BackgroundTransparency = 1, FontFace = regularFont(Enum.FontWeight.Medium),
        Position = UDim2.fromOffset(12, 8), Size = UDim2.fromOffset(268, 18), Text = titleText,
        TextColor3 = Color3.fromRGB(190, 190, 190), TextSize = 14,
        TextTruncate = Enum.TextTruncate.AtEnd, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6,
    }, card)
    local body = make("TextLabel", {
        Name = "Description", BackgroundTransparency = 1, FontFace = regularFont(),
        Position = UDim2.fromOffset(12, 28), Size = UDim2.fromOffset(268, 16),
        Text = tostring(config.Description or config.Content or config.Text or ""),
        TextColor3 = Color3.fromRGB(135, 135, 135), TextSize = 13, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 6,
    }, card)
    local component = {Card = card, Stroke = stroke, Title = title, ValueBox = body, Section = section, NoBox = false}
    local window = self

    local function resize()
        local hasTitle = title.Text ~= ""
        title.Visible = hasTitle
        local top = hasTitle and 28 or 9
        body.Position = UDim2.fromOffset(12, top)
        local bounds = TextService:GetTextSize(body.Text, 13, Enum.Font.Roboto, Vector2.new(262, 10000))
        local textHeight = body.Text == "" and 0 or math.ceil(bounds.Y) + 2
        body.Size = UDim2.fromOffset(268, textHeight)
        window:_ResizeComponent(section, card, math.max(36, top + textHeight + 9))
    end

    function component:SetDescription(text)
        body.Text = tostring(text or "")
        resize()
    end
    function component:SetTitle(text)
        title.Text = tostring(text or "")
        resize()
    end
    function component:GetValue()
        return body.Text
    end
    component.SetValue = component.SetDescription

    table.insert(section.Components, component)
    resize()
    return component
end

function Library:CreateKeybind(section, config)
    assert(type(section) == "table" and section.Container, "CreateKeybind expects a section component")
    config = config or {}
    local card, stroke = self:_CreateComponentBox(section, 36, "Keybind")
    local title = make("TextLabel", {
        Name = "Title", BackgroundTransparency = 1, FontFace = regularFont(Enum.FontWeight.Medium),
        Position = UDim2.fromOffset(12, 8), Size = UDim2.fromOffset(170, 20),
        Text = tostring(config.Title or config.Name or "Keybind"),
        TextColor3 = Color3.fromRGB(190, 190, 190), TextSize = 14,
        TextTruncate = Enum.TextTruncate.AtEnd, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6,
    }, card)
    local keyButton = make("TextButton", {
        Name = "Key", AnchorPoint = Vector2.new(1, 0.5), AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(22, 22, 22), BorderSizePixel = 0, FontFace = regularFont(Enum.FontWeight.Medium),
        Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(92, 24), Text = "None",
        TextColor3 = Color3.fromRGB(170, 170, 170), TextSize = 12, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 8,
    }, card)
    make("UICorner", {CornerRadius = UDim.new(0, 6)}, keyButton)

    local component = {Card = card, Stroke = stroke, Title = title, ValueBox = keyButton, Section = section,
        Value = nil, Callback = config.Callback, OnPressed = config.OnPressed}
    local capturing = false

    function component:SetValue(value, silent)
        local name = typeof(value) == "EnumItem" and value.Name or (value ~= nil and tostring(value) or nil)
        if name then
            local ok, key = pcall(function() return Enum.KeyCode[name] end)
            if not ok or not key then return end
        end
        self.Value = name
        keyButton.Text = name or "None"
        if not silent and type(self.Callback) == "function" then task.spawn(self.Callback, name) end
    end
    function component:GetValue()
        return self.Value
    end

    table.insert(self._connections, keyButton.Activated:Connect(function()
        capturing = not capturing
        keyButton.Text = capturing and "..." or (component.Value or "None")
    end))
    table.insert(self._connections, UserInputService.InputBegan:Connect(function(input, processed)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if capturing then
            capturing = false
            if input.KeyCode == Enum.KeyCode.Escape then
                keyButton.Text = component.Value or "None"
            else
                component:SetValue(input.KeyCode)
            end
            return
        end
        if processed or UserInputService:GetFocusedTextBox() then return end
        if component.Value and input.KeyCode.Name == component.Value and type(component.OnPressed) == "function" then
            task.spawn(component.OnPressed)
        end
    end))

    table.insert(section.Components, component)
    component:SetValue(config.Default, true)
    return component
end

function Library:CreateColorPicker(section, config)
    assert(type(section) == "table" and section.Container, "CreateColorPicker expects a section component")
    config = config or {}
    local palette = {
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(237, 66, 69), Color3.fromRGB(250, 166, 26),
        Color3.fromRGB(254, 231, 92), Color3.fromRGB(87, 242, 135), Color3.fromRGB(88, 101, 242),
        Color3.fromRGB(235, 69, 158), Color3.fromRGB(0, 0, 0),
    }
    local card, stroke = self:_CreateComponentBox(section, 36, "ColorPicker")
    local title = make("TextLabel", {
        Name = "Title", BackgroundTransparency = 1, FontFace = regularFont(Enum.FontWeight.Medium),
        Position = UDim2.fromOffset(12, 8), Size = UDim2.fromOffset(200, 20),
        Text = tostring(config.Title or config.Name or "Color"),
        TextColor3 = Color3.fromRGB(190, 190, 190), TextSize = 14,
        TextTruncate = Enum.TextTruncate.AtEnd, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6,
    }, card)
    local swatch = make("TextButton", {
        Name = "Swatch", AnchorPoint = Vector2.new(1, 0.5), AutoButtonColor = false, BorderSizePixel = 0,
        Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(38, 20), Text = "", ZIndex = 8,
    }, card)
    make("UICorner", {CornerRadius = UDim.new(0, 5)}, swatch)
    make("UIStroke", {Color = Color3.fromRGB(60, 60, 60), Thickness = 1}, swatch)
    local component = {Card = card, Stroke = stroke, Title = title, Section = section, Callback = config.Callback}
    local index = 1

    function component:SetValue(color, silent)
        if typeof(color) ~= "Color3" then return end
        self.Value = color
        swatch.BackgroundColor3 = color
        if not silent and type(self.Callback) == "function" then task.spawn(self.Callback, color) end
    end
    function component:GetValue()
        return self.Value
    end
    table.insert(self._connections, swatch.Activated:Connect(function()
        index = index % #palette + 1
        component:SetValue(palette[index])
    end))

    table.insert(section.Components, component)
    component:SetValue(typeof(config.Default) == "Color3" and config.Default or palette[1], true)
    return component
end

function Library:_AnimateSections(tab)
    self._sectionAnimationGeneration += 1
    local generation = self._sectionAnimationGeneration
    local startDelay = self._windowReady and 0.03 or 0.72

    tab.Page.CanvasPosition = Vector2.zero

    for _, section in ipairs(tab.Sections) do
        section.Frame.Size = UDim2.fromOffset(292, 0)
        section.Icon.ImageTransparency = 1
        section.Title.TextTransparency = 1
        for _, component in ipairs(section.Components) do
            component.Card.BackgroundTransparency = 1
            component.Stroke.Transparency = 1
            component.Title.TextTransparency = 1
            if component.Track then
                component.Track.BackgroundTransparency = 1
            end
            if component.Knob then
                component.Knob.BackgroundTransparency = 1
            end
            if component.KnobCenter then
                component.KnobCenter.BackgroundTransparency = 1
            end
            if component.KnobShadow then
                component.KnobShadow.Transparency = 1
            end
            if component.ValueBox then
                component.ValueBox.TextTransparency = 1
            end
        end
    end

    for index, section in ipairs(tab.Sections) do
        task.delay(startDelay + (index - 1) * 0.075, function()
            if self._destroyed
                or generation ~= self._sectionAnimationGeneration
                or self.SelectedTab ~= tab
                or not section.Frame.Parent then
                return
            end

            tween(
                section.Frame,
                0.38,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out,
                {
                    Size = UDim2.fromOffset(292, section.Height),
                }
            )
            tween(
                section.Icon,
                0.28,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out,
                {ImageTransparency = 0}
            )
            tween(
                section.Title,
                0.3,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out,
                {TextTransparency = 0}
            )
            for componentIndex, child in ipairs(section.Components) do
                task.delay((componentIndex - 1) * 0.045, function()
                    if self._destroyed or generation ~= self._sectionAnimationGeneration then
                        return
                    end
                    tween(child.Card, 0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                        BackgroundTransparency = child.NoBox and 1 or 0,
                    })
                    tween(child.Stroke, 0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                        Transparency = child.NoBox and 1 or 0.72,
                    })
                    tween(child.Title, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                        TextTransparency = 0,
                    })
                    if child.Track then
                        tween(child.Track, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                            BackgroundTransparency = 0,
                        })
                    end
                    if child.Knob then
                        tween(child.Knob, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                            BackgroundTransparency = 0,
                        })
                    end
                    if child.KnobCenter then
                        tween(child.KnobCenter, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                            BackgroundTransparency = 0,
                        })
                    end
                    if child.KnobShadow then
                        tween(child.KnobShadow, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                            Transparency = 0.72,
                        })
                    end
                    if child.ValueBox then
                        tween(child.ValueBox, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                            TextTransparency = 0,
                        })
                    end
                end)
            end
        end)
    end
end

function Library:SelectTab(component, instant)
    if self._destroyed or self.SelectedTab == component then
        return
    end

    if self.SelectedTab and self.SelectedTab.Page then
        for _, section in ipairs(self.SelectedTab.Sections) do
            for _, child in ipairs(section.Components) do
                if child.Open and child.SetOpen then
                    child:SetOpen(false)
                end
            end
        end
        self.SelectedTab.Page.Visible = false
    end
    component.Page.Visible = true
    self.SelectedTab = component
    self:_AnimateSections(component)

    local target = UDim2.fromOffset(8, 82 + component.RowOffset)
    if self._selectionTween then
        self._selectionTween:Cancel()
        self._selectionTween = nil
    end

    self.SelectionBox.Visible = true
    if instant then
        self.SelectionBox.Position = target
        self.SelectionBox.BackgroundTransparency = 0.68
    else
        self.SelectionBox.BackgroundTransparency = 0.46
        self._selectionTween = tween(
            self.SelectionBox,
            0.52,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.InOut,
            {
                Position = target,
                BackgroundTransparency = 0.68,
            }
        )
    end
end

function Library:_FilterTabs(query)
    local normalized = string.lower(tostring(query or ""))
    local visibleTabs = {}

    for _, component in ipairs(self.Tabs) do
        local matches = normalized == ""
            or string.find(string.lower(component.Label.Text), normalized, 1, true) ~= nil

        component.Icon.Visible = matches
        component.Label.Visible = matches
        component.Button.Visible = matches

        if matches then
            local rowOffset = #visibleTabs * 38
            component.RowOffset = rowOffset
            component.Icon.Position = UDim2.fromOffset(17, 86 + rowOffset)
            component.Label.Position = UDim2.fromOffset(47, 87 + rowOffset)
            component.Button.Position = UDim2.fromOffset(8, 82 + rowOffset)
            table.insert(visibleTabs, component)
        end
    end

    if self.SelectedTab and self.SelectedTab.Button.Visible then
        if self._selectionTween then
            self._selectionTween:Cancel()
            self._selectionTween = nil
        end
        self.SelectionBox.Visible = true
        self.SelectionBox.Position = UDim2.fromOffset(8, 82 + self.SelectedTab.RowOffset)
    else
        if self.SelectedTab and self.SelectedTab.Page then
            self.SelectedTab.Page.Visible = false
        end
        self.SelectedTab = nil
        if visibleTabs[1] then
            self:SelectTab(visibleTabs[1], true)
        else
            self.SelectionBox.Visible = false
        end
    end
end

function Library:Build(config)
    assert(type(config) == "table", "Build expects a configuration table")
    assert(not self._destroyed, "Cannot build after the UI is destroyed")

    local creators = {
        Toggle = "CreateToggle",
        Slider = "CreateSlider",
        Input = "CreateInput",
        Button = "CreateButton",
        Comment = "CreateComment",
        LargeText = "CreateLargeText",
        Dropdown = "CreateDropdown",
    }

    local function copyValue(value, index)
        if type(value) == "string" then
            return (string.gsub(value, "{i}", tostring(index)))
        end
        if type(value) ~= "table" then
            return value
        end
        local copied = {}
        for key, nestedValue in pairs(value) do
            copied[key] = copyValue(nestedValue, index)
        end
        return copied
    end

    local function createComponents(section, components, sectionIndex)
        for _, definition in ipairs(type(components) == "table" and components or {}) do
            local componentType = tostring(definition.Type or "")
            local methodName = creators[componentType]
            assert(methodName, "Unknown component type: " .. componentType)
            local amount = math.max(1, math.floor(tonumber(definition.Amount) or 1))
            for componentIndex = 1, amount do
                local componentConfig = {}
                for key, value in pairs(definition) do
                    if key ~= "Type" and key ~= "Amount" then
                        local replacementIndex = amount > 1 and componentIndex or sectionIndex
                        componentConfig[key] = copyValue(value, replacementIndex)
                    end
                end
                self[methodName](self, section, componentConfig)
            end
        end
    end

    for _, tabDefinition in ipairs(type(config.Tabs) == "table" and config.Tabs or {}) do
        local tab = self:CreateTab(tabDefinition)
        local explicitSections = tabDefinition.Sections
        if type(explicitSections) == "table" and #explicitSections > 0 then
            for sectionIndex, definition in ipairs(explicitSections) do
                local sectionConfig = copyValue(definition, sectionIndex)
                local section = self:CreateSection(tab, sectionConfig)
                createComponents(section, definition.Components, sectionIndex)
            end
        else
            local sectionCount = math.max(
                0,
                math.floor(tonumber(tabDefinition.SectionCount or config.SectionCount) or 0)
            )
            local template = tabDefinition.SectionTemplate or config.SectionTemplate or {}
            for sectionIndex = 1, sectionCount do
                local sectionConfig = copyValue(template, sectionIndex)
                if string.lower(tostring(sectionConfig.Side or "")) == "alternate" then
                    sectionConfig.Side = sectionIndex % 2 == 1 and "Left" or "Right"
                end
                if not sectionConfig.Icon or sectionConfig.Icon == "" then
                    sectionConfig.Icon = tabDefinition.Icon
                end
                local section = self:CreateSection(tab, sectionConfig)
                createComponents(section, template.Components, sectionIndex)
            end
        end
    end

    if self.Tabs[1] then
        self:SelectTab(self.Tabs[1], true)
    end
    return self
end

function Library:SetMinimized(minimized)
    if self._destroyed then
        return
    end

    minimized = minimized == true
    if self.Minimized == minimized then
        return
    end
    self.Minimized = minimized

    if minimized then
        if self.MiniMenuOpen then
            self:SetMiniMenu(false)
        end
        for _, tab in ipairs(self.Tabs) do
            for _, section in ipairs(tab.Sections) do
                for _, component in ipairs(section.Components) do
                    if component.Open and component.SetOpen then
                        component:SetOpen(false)
                    end
                end
            end
        end
    end

    self.Window.Visible = not minimized
    self.FloatingButton.Text = minimized and "OFF" or "ON"
    tween(self.FloatingButton, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {
        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
        TextColor3 = Color3.fromRGB(255, 255, 255),
    })
end

function Library:ToggleMinimized()
    self:SetMinimized(not self.Minimized)
end

function Library:SetVisible(visible)
    if not self._destroyed then
        self:SetMinimized(not visible)
    end
end

function Library:Destroy()
    if self._destroyed then
        return
    end
    self._destroyed = true
    for _, connection in ipairs(self._connections) do
        connection:Disconnect()
    end
    table.clear(self._connections)
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

getgenv().LowyxUILibrary = Library

local ICONS = {
    swords = "rbxassetid://115261723592673", inventory_2 = "rbxassetid://103242000057395",
    person = "rbxassetid://85395556694556", settings = "rbxassetid://128930190321067",
    target = "rbxassetid://73370190905782", smart_toy = "rbxassetid://125680982680567",
    dashboard = "rbxassetid://73140481876812", visibility = "rbxassetid://118778023445223",
    palette = "rbxassetid://128276310382500", travel_explore = "rbxassetid://88317151770145",
    skull = "rbxassetid://82073762701825", trophy = "rbxassetid://91128039959175",
    bolt = "rbxassetid://115510229149037", apparel = "rbxassetid://103754599886158",
    info = "rbxassetid://126009970699961", map = "rbxassetid://92469146308685",
    sailing = "rbxassetid://86887238587096", phishing = "rbxassetid://100508200656394",
    storefront = "rbxassetid://104852286401290", build = "rbxassetid://104847115168721",
    diamond = "rbxassetid://105103561540296", timer = "rbxassetid://107513319675112",
    speed = "rbxassetid://122593296716664", shield = "rbxassetid://112013913867836",
    flag = "rbxassetid://111224331956669", pets = "rbxassetid://121101341112942",
    star = "rbxassetid://129603974151631",
}
local ICON_RULES = {
    {"aim", "target"}, {"combat", "swords"}, {"kill", "skull"}, {"boss", "skull"}, {"mob", "skull"},
    {"esp", "visibility"}, {"performance", "speed"}, {"visual", "visibility"}, {"teleport", "travel_explore"},
    {"island", "map"}, {"sea", "sailing"}, {"fish", "phishing"}, {"quest", "inventory_2"}, {"story", "flag"},
    {"player", "person"}, {"movement", "person"}, {"farm", "swords"}, {"raid", "shield"}, {"chest", "diamond"},
    {"fruit", "inventory_2"}, {"item", "inventory_2"}, {"inventory", "inventory_2"}, {"material", "inventory_2"},
    {"craft", "build"}, {"equipment", "apparel"}, {"progress", "trophy"}, {"haki", "bolt"}, {"skill", "bolt"},
    {"kaitun", "smart_toy"}, {"automation", "smart_toy"}, {"session", "timer"}, {"collect", "star"},
    {"shop", "storefront"}, {"setting", "settings"}, {"config", "settings"},
}
local function legacyIcon(title, requested)
    if type(requested) == "string" then
        if ICONS[requested] then return ICONS[requested] end
        if requested:find("^rbxasset") then return requested end
    end
    local name = string.lower(tostring(title or ""))
    for _, rule in ipairs(ICON_RULES) do
        if name:find(rule[1], 1, true) then return ICONS[rule[2]] end
    end
    return ICONS.dashboard
end

local CREATORS = {
    Toggle = "CreateToggle", IconToggle = "CreateToggle", ColorToggle = "CreateToggle",
    Slider = "CreateSlider", Dropdown = "CreateDropdown", MultiDropdown = "CreateDropdown",
    Input = "CreateInput", Button = "CreateButton", Paragraph = "CreateParagraph",
    Keybind = "CreateKeybind", ColorPicker = "CreateColorPicker",
}

function Library.Legacy(initialOptions)
    local api = {Components = {}, Config = {Tabs = {}}, Version = "Lowyx-2", SingleFile = true}
    local changed = Instance.new("BindableEvent")
    changed.Name = "ComponentChanged"
    api.Changed = changed.Event
    local window
    local tabsById = {}
    local sequence = 0

    local function ensureWindow(options)
        if window and not window._destroyed then return window end
        options = options or {}
        local title = tostring(options.Title or "Lowyx Hub"):gsub("R1n Hub", "Lowyx Hub")
        window = Library.new({
            Title = title,
            SearchPlaceholder = "Search",
            DiscordLink = options.DiscordLink or "discord.gg/lowyx",
            ToggleKey = options.ToggleKey,
        })
        local description = options.Description or options.Subtitle
        window.Title.RichText = true
        window.Title.TextXAlignment = Enum.TextXAlignment.Left
        window.Title.Position = UDim2.fromOffset(14, 7)
        window.Title.Size = UDim2.fromOffset(520, 24)
        window.Title.Text = description and description ~= ""
            and (title .. '  <font color="#6a6a6a" size="14">' .. tostring(description) .. "</font>") or title
        changed.Parent = window.ScreenGui
        api.Window = window
        api.Gui = window.ScreenGui
        api.FloatingToggle = window.FloatingButton
        api.Destroyed = window.ScreenGui.Destroying
        return window
    end

    local function normalize(props, kind)
        props = props or {}
        props.Type = kind
        props.Title = props.Title or props.Name or props.Text or kind
        if props.Default == nil then props.Default = props.Value end
        props.Multi = props.Multi == true or kind == "MultiDropdown"
        return props
    end

    local function makeHandle(section, props, prefix)
        local kind = props.Type
        local userCallback = props.Callback
        local handle = {Config = props, Id = prefix, ColorId = prefix .. ".Color"}
        local function relay(value)
            changed:Fire(prefix, value)
            if type(userCallback) == "function" then userCallback(value) end
        end
        local native
        local spec = {Title = props.Title, Name = props.Title, Callback = relay}
        if kind == "Toggle" or kind == "IconToggle" or kind == "ColorToggle" then
            spec.Default = props.Default == true
        elseif kind == "Slider" then
            spec.Min, spec.Max = tonumber(props.Min) or 0, tonumber(props.Max) or 100
            spec.Increment = tonumber(props.Step or props.Increment or props.Rounding) or 1
            spec.Default = tonumber(props.Default) or spec.Min
        elseif kind == "Dropdown" or kind == "MultiDropdown" then
            spec.Options, spec.Multi, spec.Placeholder = props.Options or {}, props.Multi, props.Placeholder
            spec.Default = props.Default
        elseif kind == "Input" then
            spec.Placeholder, spec.Default = props.Placeholder, props.Default
        elseif kind == "Button" then
            spec.Callback = function() if type(userCallback) == "function" then userCallback() end end
        elseif kind == "Paragraph" then
            spec.Description = props.Description or props.Content or ""
            spec.Callback = nil
        elseif kind == "Keybind" then
            spec.Default, spec.OnPressed = props.Default, props.OnPressed
        elseif kind == "ColorPicker" then
            spec.Default = props.Default or props.Color
        end
        native = window[CREATORS[kind]](window, section, spec)
        handle.Native = native
        handle.Instance = native.Card
        native.Card:SetAttribute("ComponentId", prefix)
        native.Card:SetAttribute("LowyxComponent", true)

        function handle:Get()
            if kind == "Button" then return nil end
            if kind == "Paragraph" then return props.Description end
            if native.GetValue then return native:GetValue() end
            return nil
        end
        function handle:Set(value, silent)
            if kind == "Paragraph" then return self:SetDescription(value) end
            if native.SetValue then native:SetValue(value, silent == true) end
            return self
        end
        handle.GetValue, handle.SetValue, handle.Select = handle.Get, handle.Set, handle.Set
        function handle:SetCallback(callback)
            userCallback = callback
            props.Callback = callback
            return self
        end
        function handle:SetOptions(values)
            props.Options = values
            if native.SetOptions then native:SetOptions(values) end
            return self
        end
        handle.Refresh = handle.SetOptions
        function handle:SetDescription(text)
            props.Description = tostring(text or "")
            if native.SetDescription then native:SetDescription(props.Description) end
            return self
        end
        function handle:SetName(text)
            props.Name, props.Title = tostring(text), tostring(text)
            if native.SetTitle then native:SetTitle(props.Title)
            elseif native.SetName then native:SetName(props.Title)
            elseif native.Title then native.Title.Text = props.Title end
            return self
        end
        handle.SetTitle = handle.SetName
        function handle:GetColor() return kind == "ColorPicker" and native:GetValue() or props.Color end
        function handle:SetColor(color)
            if typeof(color) ~= "Color3" then return self end
            props.Color = color
            if kind == "ColorPicker" then native:SetValue(color) end
            changed:Fire(prefix .. ".Color", color)
            return self
        end
        function handle:Destroy()
            local position = table.find(section.Components, native)
            if position then table.remove(section.Components, position) end
            window:_ResizeComponent(section, native.Card, 0)
            native.Card:Destroy()
            if native.Popup then native.Popup:Destroy() end
            api.Components[prefix] = nil
        end
        api.Components[prefix] = handle
        return handle
    end

    local function wrapSection(section, sectionConfig, prefix)
        local wrapper = {Config = sectionConfig, Instance = section.Frame, Id = prefix, Native = section}
        function wrapper:AddComponent(props)
            local kind = props and props.Type or "Toggle"
            assert(CREATORS[kind], "Unsupported Lowyx component: " .. tostring(kind))
            sequence += 1
            props = normalize(props, kind)
            props.Id = props.Id or ("control" .. sequence)
            table.insert(sectionConfig.Components, props)
            return makeHandle(section, props, prefix .. "." .. props.Id)
        end
        for kind in pairs(CREATORS) do
            wrapper["Add" .. kind] = function(self, props)
                props = props or {}
                props.Type = kind
                return self:AddComponent(props)
            end
        end
        return wrapper
    end

    local function relayoutTabs()
        table.sort(window.Tabs, function(a, b)
            if a.Order == b.Order then return a.Index < b.Index end
            return a.Order < b.Order
        end)
        window:_FilterTabs(window.SearchBar.Text)
    end

    function api:CreateWindow(options)
        ensureWindow(options or initialOptions)
        return api
    end

    function api:AddTab(config)
        ensureWindow(initialOptions)
        config = config or {}
        config.Id = config.Id or ("tab" .. (#api.Config.Tabs + 1))
        config.Title = config.Title or config.Name or config.Id
        config.Sections = config.Sections or {}
        table.insert(api.Config.Tabs, config)
        local native = window:CreateTab({Title = config.Title, Icon = legacyIcon(config.Title, config.Icon)})
        native.Order = tonumber(config.Order) or (#api.Config.Tabs * 10)
        native.LegacyId = config.Id
        tabsById[config.Id] = native
        relayoutTabs()

        local tab = {Id = config.Id, Config = config, Instance = native.Page, Native = native}
        function tab:AddSection(sectionConfig)
            sectionConfig = sectionConfig or {}
            sectionConfig.Id = sectionConfig.Id or ("section" .. (#config.Sections + 1))
            sectionConfig.Name = sectionConfig.Name or sectionConfig.Title or sectionConfig.Id
            sectionConfig.Components = sectionConfig.Components or {}
            table.insert(config.Sections, sectionConfig)
            local side = sectionConfig.Column == 2 and "Right" or sectionConfig.Column == 1 and "Left"
                or (native.LeftCount <= native.RightCount and "Left" or "Right")
            local section = window:CreateSection(native, {
                Title = sectionConfig.Name, Side = side,
                Icon = legacyIcon(sectionConfig.Name, sectionConfig.Icon),
            })
            if sectionConfig.Order then
                section.Frame.LayoutOrder = tonumber(sectionConfig.Order) * 100 + #config.Sections
            end
            local wrapper = wrapSection(section, sectionConfig, config.Id .. "." .. sectionConfig.Id)
            local children = table.clone(sectionConfig.Components)
            table.clear(sectionConfig.Components)
            for _, props in ipairs(children) do wrapper:AddComponent(props) end
            if window.SelectedTab == native then window:_AnimateSections(native) end
            return wrapper
        end
        tab.AddTopic = tab.AddSection
        function tab:AddSeparator() return {Destroy = function() end, SetTitle = function() end} end
        return tab
    end
    api.CreateTab = api.AddTab
    function api:AddSeparator() return {Destroy = function() end, SetTitle = function() end} end

    function api.SelectTab(first, second)
        local id = second or first
        if type(id) == "table" then id = id.Id end
        local native = tabsById[id]
        if not native then
            for _, candidate in ipairs(window and window.Tabs or {}) do
                if candidate.Title == id then native = candidate break end
            end
        end
        if native then window:SelectTab(native) return true end
        return false
    end
    function api:GetComponent(id) return api.Components[id] end
    function api.GetValue(id) local h = api.Components[id] return h and h:Get() end
    function api.SetValue(id, value) local h = api.Components[id] return h and h:Set(value) end
    function api.GetColor(id) local h = api.Components[id] return h and h:GetColor() end
    function api.SetColor(id, value) local h = api.Components[id] return h and h:SetColor(value) end
    function api.Notify(first, second)
        local options = second or first
        if type(options) == "string" then options = {Text = options} end
        options = options or {}
        local text = options.Description or options.Content or options.Text or ""
        if options.Title and options.Title ~= "" then
            text = text ~= "" and (options.Title .. ": " .. text) or options.Title
        end
        return window and window:Notify({Text = text, Duration = options.Duration})
    end
    function api.SetStatus() end
    function api.ShowStatus() end
    function api.Apply() end
    function api.Show() if window then window:SetMinimized(false) end return api end
    function api.Hide() if window then window:SetMinimized(true) end return api end
    function api.Toggle() if window then window:ToggleMinimized() end return api end
    function api.Destroy() if window then window:Destroy() end end
    api.OnDestroy = function(_, callback)
        return window and window.ScreenGui.Destroying:Connect(callback)
    end

    local environment = getgenv()
    environment.LowyxUI = api
    environment.R1nUI = api
    return api
end

return Library.Legacy()

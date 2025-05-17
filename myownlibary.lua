local RobloxUI = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local executor = (syn and "Synapse") or 
                (getexecutorname and getexecutorname()) or 
                (KRNL_LOADED and "KRNL") or 
                (secure_load and "Sentinel") or 
                (SONA_LOADED and "Sona") or 
                (FLUXUS_LOADED and "Fluxus") or 
                (ScriptWare and "ScriptWare") or 
                "Unknown"

local function GenerateGUID()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

local function SafeInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    return instance
end

local function CreateTween(instance, properties, duration, easingStyle, easingDirection)
    local tInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tInfo, properties)
    return tween
end

function RobloxUI:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "RobloxUI"
    local windowColor = config.Color or Color3.fromRGB(32, 32, 32)
    local windowSize = config.Size or UDim2.new(0, 600, 0, 400)
    
    local ScreenGui = SafeInstance("ScreenGui", {
        Name = "RobloxUI_" .. GenerateGUID(),
        Parent = (syn and syn.protect_gui and syn.protect_gui(SafeInstance("ScreenGui")) and CoreGui) or 
                 (gethui and gethui()) or 
                 CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    local MainFrame = SafeInstance("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = windowColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2),
        Size = windowSize,
        ClipsDescendants = true
    })
    
    local Corner = SafeInstance("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 6)
    })
    
    local Shadow = SafeInstance("ImageLabel", {
        Name = "Shadow",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = 0,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277)
    })
    
    local TitleBar = SafeInstance("Frame", {
        Name = "TitleBar",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30)
    })
    
    local TitleCorner = SafeInstance("UICorner", {
        Parent = TitleBar,
        CornerRadius = UDim.new(0, 6)
    })
    
    local TitleFix = SafeInstance("Frame", {
        Name = "TitleFix",
        Parent = TitleBar,
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.5, 0)
    })
    
    local Title = SafeInstance("TextLabel", {
        Name = "Title",
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        Font = Enum.Font.GothamSemibold,
        Text = windowName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local CloseButton = SafeInstance("TextButton", {
        Name = "CloseButton",
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -25, 0, 5),
        Size = UDim2.new(0, 20, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    local MinimizeButton = SafeInstance("TextButton", {
        Name = "MinimizeButton",
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -50, 0, 5),
        Size = UDim2.new(0, 20, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = "-",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20
    })
    
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            CreateTween(MainFrame, {Size = UDim2.new(0, windowSize.X.Offset, 0, 30)}, 0.3):Play()
        else
            CreateTween(MainFrame, {Size = windowSize}, 0.3):Play()
        end
    end)
    
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    local ContentContainer = SafeInstance("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 1, -30),
        ClipsDescendants = true
    })
    
    local TabContainer = SafeInstance("Frame", {
        Name = "TabContainer",
        Parent = ContentContainer,
        BackgroundColor3 = Color3.fromRGB(26, 26, 26),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 120, 1, 0)
    })
    
    local TabList = SafeInstance("ScrollingFrame", {
        Name = "TabList",
        Parent = TabContainer,
        Active = true,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 1, -10),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    local TabListLayout = SafeInstance("UIListLayout", {
        Parent = TabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    local TabPadding = SafeInstance("UIPadding", {
        Parent = TabList,
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })
    
    local ContentFrame = SafeInstance("Frame", {
        Name = "ContentFrame",
        Parent = ContentContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 120, 0, 0),
        Size = UDim2.new(1, -120, 1, 0)
    })
    
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    
    function Window:CreateTab(tabName)
        local tabButton = SafeInstance("TextButton", {
            Name = tabName .. "Button",
            Parent = TabList,
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 30),
            Font = Enum.Font.Gotham,
            Text = tabName,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            AutoButtonColor = false
        })
        
        local tabButtonCorner = SafeInstance("UICorner", {
            Parent = tabButton,
            CornerRadius = UDim.new(0, 4)
        })
        
        local tabFrame = SafeInstance("ScrollingFrame", {
            Name = tabName .. "Frame",
            Parent = ContentFrame,
            Active = true,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            Visible = false,
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        })
        
        local tabElementsLayout = SafeInstance("UIListLayout", {
            Parent = tabFrame,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
        
        local tabElementsPadding = SafeInstance("UIPadding", {
            Parent = tabFrame,
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })
        
        local Tab = {}
        Tab.Name = tabName
        Tab.Button = tabButton
        Tab.Frame = tabFrame
        
        function Tab:Select()
            if Window.ActiveTab then
                Window.ActiveTab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                Window.ActiveTab.Frame.Visible = false
            end
            
            self.Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            self.Frame.Visible = true
            Window.ActiveTab = self
        end
        
        tabButton.MouseButton1Click:Connect(function()
            Tab:Select()
        end)
        
        function Tab:AddLabel(text)
            local label = SafeInstance("TextLabel", {
                Name = "Label",
                Parent = self.Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            return label
        end
        
        function Tab:AddButton(text, callback)
            local button = SafeInstance("TextButton", {
                Name = "Button",
                Parent = self.Frame,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 30),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14
            })
            
            local buttonCorner = SafeInstance("UICorner", {
                Parent = button,
                CornerRadius = UDim.new(0, 4)
            })
            
            button.MouseButton1Click:Connect(function()
                callback()
            end)
            
            button.MouseEnter:Connect(function()
                CreateTween(button, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            end)
            
            button.MouseLeave:Connect(function()
                CreateTween(button, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            end)
            
            return button
        end
        
        function Tab:AddToggle(text, default, callback)
            local toggleValue = default or false
            
            local toggleContainer = SafeInstance("Frame", {
                Name = "ToggleContainer",
                                Parent = self.Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30)
            })
            
            local toggleLabel = SafeInstance("TextLabel", {
                Name = "ToggleLabel",
                Parent = toggleContainer,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, -50, 1, 0),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local toggleButton = SafeInstance("Frame", {
                Name = "ToggleButton",
                Parent = toggleContainer,
                BackgroundColor3 = toggleValue and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60),
                BorderSizePixel = 0,
                Position = UDim2.new(1, -40, 0.5, -10),
                Size = UDim2.new(0, 40, 0, 20)
            })
            
            local toggleButtonCorner = SafeInstance("UICorner", {
                Parent = toggleButton,
                CornerRadius = UDim.new(1, 0)
            })
            
            local toggleCircle = SafeInstance("Frame", {
                Name = "ToggleCircle",
                Parent = toggleButton,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Position = toggleValue and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16)
            })
            
            local toggleCircleCorner = SafeInstance("UICorner", {
                Parent = toggleCircle,
                CornerRadius = UDim.new(1, 0)
            })
            
            local toggleButtonClick = SafeInstance("TextButton", {
                Name = "ToggleButtonClick",
                Parent = toggleContainer,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -40, 0.5, -10),
                Size = UDim2.new(0, 40, 0, 20),
                Text = "",
                ZIndex = 10
            })
            
            toggleButtonClick.MouseButton1Click:Connect(function()
                toggleValue = not toggleValue
                
                if toggleValue then
                    CreateTween(toggleButton, {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
                    CreateTween(toggleCircle, {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
                else
                    CreateTween(toggleButton, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                    CreateTween(toggleCircle, {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                end
                
                callback(toggleValue)
            end)
            
            local toggle = {
                Instance = toggleContainer,
                Value = toggleValue,
                Set = function(self, value)
                    toggleValue = value
                    if toggleValue then
                        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                        toggleCircle.Position = UDim2.new(1, -18, 0.5, -8)
                    else
                        toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                        toggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
                    end
                    callback(toggleValue)
                end
            }
            
            return toggle
        end
        
        function Tab:AddSlider(text, min, max, default, callback)
            min = min or 0
            max = max or 100
            default = default or min
            
            local sliderContainer = SafeInstance("Frame", {
                Name = "SliderContainer",
                Parent = self.Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 50)
            })
            
            local sliderLabel = SafeInstance("TextLabel", {
                Name = "SliderLabel",
                Parent = sliderContainer,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local sliderValue = SafeInstance("TextLabel", {
                Name = "SliderValue",
                Parent = sliderContainer,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -40, 0, 0),
                Size = UDim2.new(0, 40, 0, 20),
                Font = Enum.Font.Gotham,
                Text = tostring(default),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local sliderBackground = SafeInstance("Frame", {
                Name = "SliderBackground",
                Parent = sliderContainer,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 25),
                Size = UDim2.new(1, 0, 0, 10)
            })
            
            local sliderBackgroundCorner = SafeInstance("UICorner", {
                Parent = sliderBackground,
                CornerRadius = UDim.new(0, 4)
            })
            
            local sliderFill = SafeInstance("Frame", {
                Name = "SliderFill",
                Parent = sliderBackground,
                BackgroundColor3 = Color3.fromRGB(0, 170, 255),
                BorderSizePixel = 0,
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            })
            
            local sliderFillCorner = SafeInstance("UICorner", {
                Parent = sliderFill,
                CornerRadius = UDim.new(0, 4)
            })
            
            local sliderButton = SafeInstance("TextButton", {
                Name = "SliderButton",
                Parent = sliderBackground,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })
            
            local function updateSlider(input)
                local sizeX = math.clamp((input.Position.X - sliderBackground.AbsolutePosition.X) / sliderBackground.AbsoluteSize.X, 0, 1)
                sliderFill.Size = UDim2.new(sizeX, 0, 1, 0)
                
                local value = math.floor(min + ((max - min) * sizeX))
                sliderValue.Text = tostring(value)
                callback(value)
            end
            
            sliderButton.MouseButton1Down:Connect(function(input)
                updateSlider(input)
                local connection
                connection = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if connection then
                            connection:Disconnect()
                        end
                    end
                end)
            end)
            
            local slider = {
                Instance = sliderContainer,
                Value = default,
                Set = function(self, value)
                    value = math.clamp(value, min, max)
                    sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    sliderValue.Text = tostring(value)
                    self.Value = value
                    callback(value)
                end
            }
            
            return slider
        end
        
        function Tab:AddDropdown(text, options, default, callback)
            local dropdownContainer = SafeInstance("Frame", {
                Name = "DropdownContainer",
                Parent = self.Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 50),
                ClipsDescendants = true
            })
            
            local dropdownLabel = SafeInstance("TextLabel", {
                Name = "DropdownLabel",
                Parent = dropdownContainer,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local dropdownButton = SafeInstance("TextButton", {
                Name = "DropdownButton",
                Parent = dropdownContainer,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 25),
                Size = UDim2.new(1, 0, 0, 30),
                Font = Enum.Font.Gotham,
                Text = default or "Select...",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14
            })
            
            local dropdownButtonCorner = SafeInstance("UICorner", {
                Parent = dropdownButton,
                CornerRadius = UDim.new(0, 4)
            })
            
            local dropdownIcon = SafeInstance("ImageLabel", {
                Name = "DropdownIcon",
                Parent = dropdownButton,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -25, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                Image = "rbxassetid://3926305904",
                ImageRectOffset = Vector2.new(564, 284),
                ImageRectSize = Vector2.new(36, 36)
            })
            
            local dropdownContent = SafeInstance("Frame", {
                Name = "DropdownContent",
                Parent = dropdownContainer,
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 60),
                Size = UDim2.new(1, 0, 0, 0),
                Visible = false
            })
            
            local dropdownContentCorner = SafeInstance("UICorner", {
                Parent = dropdownContent,
                CornerRadius = UDim.new(0, 4)
            })
            
            local dropdownContentLayout = SafeInstance("UIListLayout", {
                Parent = dropdownContent,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5)
            })
            
            local dropdownContentPadding = SafeInstance("UIPadding", {
                Parent = dropdownContent,
                PaddingLeft = UDim.new(0, 5),
                PaddingRight = UDim.new(0, 5),
                PaddingTop = UDim.new(0, 5),
                PaddingBottom = UDim.new(0, 5)
            })
            
            local isOpen = false
            local optionButtons = {}
            
            for i, option in ipairs(options) do
                local optionButton = SafeInstance("TextButton", {
                    Name = "Option_" .. option,
                    Parent = dropdownContent,
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 25),
                    Font = Enum.Font.Gotham,
                    Text = option,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14
                })
                
                local optionButtonCorner = SafeInstance("UICorner", {
                    Parent = optionButton,
                    CornerRadius = UDim.new(0, 4)
                })
                
                optionButton.MouseButton1Click:Connect(function()
                    dropdownButton.Text = option
                    isOpen = false
                    dropdownContent.Visible = false
                    dropdownContainer.Size = UDim2.new(1, 0, 0, 60)
                    callback(option)
                end)
                
                optionButton.MouseEnter:Connect(function()
                    CreateTween(optionButton, {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
                end)
                
                optionButton.MouseLeave:Connect(function()
                    CreateTween(optionButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
                end)
                
                table.insert(optionButtons, optionButton)
            end
            
            dropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    dropdownContent.Visible = true
                    local contentHeight = dropdownContentLayout.AbsoluteContentSize.Y + 10
                    dropdownContainer.Size = UDim2.new(1, 0, 0, 60 + contentHeight)
                    dropdownContent.Size = UDim2.new(1, 0, 0, contentHeight)
                else
                    dropdownContent.Visible = false
                    dropdownContainer.Size = UDim2.new(1, 0, 0, 60)
                end
            end)
            
            local dropdown = {
                Instance = dropdownContainer,
                Value = default,
                Set = function(self, value)
                    if table.find(options, value) then
                        dropdownButton.Text = value
                        self.Value = value
                        callback(value)
                    end
                end,
                AddOption = function(self, option)
                    if not table.find(options, option) then
                        table.insert(options, option)
                        
                                                local optionButton = SafeInstance("TextButton", {
                            Name = "Option_" .. option,
                            Parent = dropdownContent,
                            BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, 0, 0, 25),
                            Font = Enum.Font.Gotham,
                            Text = option,
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextSize = 14
                        })
                        
                        local optionButtonCorner = SafeInstance("UICorner", {
                            Parent = optionButton,
                            CornerRadius = UDim.new(0, 4)
                        })
                        
                        optionButton.MouseButton1Click:Connect(function()
                            dropdownButton.Text = option
                            isOpen = false
                            dropdownContent.Visible = false
                            dropdownContainer.Size = UDim2.new(1, 0, 0, 60)
                            callback(option)
                        end)
                        
                        optionButton.MouseEnter:Connect(function()
                            CreateTween(optionButton, {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
                        end)
                        
                        optionButton.MouseLeave:Connect(function()
                            CreateTween(optionButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
                        end)
                        
                        table.insert(optionButtons, optionButton)
                    end
                end,
                RemoveOption = function(self, option)
                    local index = table.find(options, option)
                    if index then
                        table.remove(options, index)
                        optionButtons[index]:Destroy()
                        table.remove(optionButtons, index)
                    end
                end
            }
            
            return dropdown
        end
        
        function Tab:AddTextbox(text, placeholder, callback)
            local textboxContainer = SafeInstance("Frame", {
                Name = "TextboxContainer",
                Parent = self.Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 60)
            })
            
            local textboxLabel = SafeInstance("TextLabel", {
                Name = "TextboxLabel",
                Parent = textboxContainer,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local textboxFrame = SafeInstance("Frame", {
                Name = "TextboxFrame",
                Parent = textboxContainer,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 25),
                Size = UDim2.new(1, 0, 0, 30)
            })
            
            local textboxFrameCorner = SafeInstance("UICorner", {
                Parent = textboxFrame,
                CornerRadius = UDim.new(0, 4)
            })
            
            local textbox = SafeInstance("TextBox", {
                Name = "Textbox",
                Parent = textboxFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -20, 1, 0),
                Font = Enum.Font.Gotham,
                PlaceholderText = placeholder or "Type here...",
                Text = "",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false
            })
            
            textbox.FocusLost:Connect(function(enterPressed)
                callback(textbox.Text, enterPressed)
            end)
            
            local textboxObj = {
                Instance = textboxContainer,
                Value = "",
                Set = function(self, value)
                    textbox.Text = value
                    self.Value = value
                    callback(value, false)
                end,
                Get = function(self)
                    return textbox.Text
                end
            }
            
            return textboxObj
        end
        
        function Tab:AddColorPicker(text, default, callback)
            default = default or Color3.fromRGB(255, 255, 255)
            
            local colorPickerContainer = SafeInstance("Frame", {
                Name = "ColorPickerContainer",
                Parent = self.Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 50),
                ClipsDescendants = true
            })
            
            local colorPickerLabel = SafeInstance("TextLabel", {
                Name = "ColorPickerLabel",
                Parent = colorPickerContainer,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, -40, 0, 20),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local colorDisplay = SafeInstance("Frame", {
                Name = "ColorDisplay",
                Parent = colorPickerContainer,
                BackgroundColor3 = default,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -30, 0, 0),
                Size = UDim2.new(0, 30, 0, 20)
            })
            
            local colorDisplayCorner = SafeInstance("UICorner", {
                Parent = colorDisplay,
                CornerRadius = UDim.new(0, 4)
            })
            
            local colorPickerButton = SafeInstance("TextButton", {
                Name = "ColorPickerButton",
                Parent = colorPickerContainer,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 20),
                Text = "",
                ZIndex = 10
            })
            
            local colorPickerFrame = SafeInstance("Frame", {
                Name = "ColorPickerFrame",
                Parent = colorPickerContainer,
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 25),
                Size = UDim2.new(1, 0, 0, 150),
                Visible = false
            })
            
            local colorPickerFrameCorner = SafeInstance("UICorner", {
                Parent = colorPickerFrame,
                CornerRadius = UDim.new(0, 4)
            })
            
            local colorPickerHue = SafeInstance("ImageLabel", {
                Name = "ColorPickerHue",
                Parent = colorPickerFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(1, -20, 0, 20),
                Image = "rbxassetid://6523286724"
            })
            
            local colorPickerHueCorner = SafeInstance("UICorner", {
                Parent = colorPickerHue,
                CornerRadius = UDim.new(0, 4)
            })
            
            local hueSlider = SafeInstance("TextButton", {
                Name = "HueSlider",
                Parent = colorPickerHue,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0.5, -5),
                Size = UDim2.new(0, 10, 0, 10),
                Text = "",
                ZIndex = 10
            })
            
            local hueSliderCorner = SafeInstance("UICorner", {
                Parent = hueSlider,
                CornerRadius = UDim.new(1, 0)
            })
            
            local colorPickerSatVal = SafeInstance("ImageLabel", {
                Name = "ColorPickerSatVal",
                Parent = colorPickerFrame,
                BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 10, 0, 40),
                Size = UDim2.new(1, -20, 0, 100),
                Image = "rbxassetid://4155801252"
            })
            
            local colorPickerSatValCorner = SafeInstance("UICorner", {
                Parent = colorPickerSatVal,
                CornerRadius = UDim.new(0, 4)
            })
            
            local satValSlider = SafeInstance("TextButton", {
                Name = "SatValSlider",
                Parent = colorPickerSatVal,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Position = UDim2.new(1, -5, 0, 0),
                Size = UDim2.new(0, 10, 0, 10),
                Text = "",
                ZIndex = 10
            })
            
            local satValSliderCorner = SafeInstance("UICorner", {
                Parent = satValSlider,
                CornerRadius = UDim.new(1, 0)
            })
            
            local isOpen = false
            local hue, sat, val = 0, 0, 1
            
            local function updateColor()
                local color = Color3.fromHSV(hue, sat, val)
                colorDisplay.BackgroundColor3 = color
                colorPickerSatVal.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                callback(color)
            end
            
            colorPickerButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    colorPickerFrame.Visible = true
                    colorPickerContainer.Size = UDim2.new(1, 0, 0, 180)
                else
                    colorPickerFrame.Visible = false
                    colorPickerContainer.Size = UDim2.new(1, 0, 0, 25)
                end
            end)
            
            hueSlider.MouseButton1Down:Connect(function()
                local connection
                connection = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        local sizeX = math.clamp((input.Position.X - colorPickerHue.AbsolutePosition.X) / colorPickerHue.AbsoluteSize.X, 0, 1)
                        hueSlider.Position = UDim2.new(sizeX, 0, 0.5, -5)
                        hue = sizeX
                        updateColor()
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if connection then
                            connection:Disconnect()
                        end
                    end
                end)
            end)
            
            satValSlider.MouseButton1Down:Connect(function()
                local connection
                connection = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        local sizeX = math.clamp((input.Position.X - colorPickerSatVal.AbsolutePosition.X) / colorPickerSatVal.AbsoluteSize.X, 0, 1)
                        local sizeY = math.clamp((input.Position.Y - colorPickerSatVal.AbsolutePosition.Y) / colorPickerSatVal.AbsoluteSize.Y, 0, 1)
                        satValSlider.Position = UDim2.new(sizeX, 0, sizeY, 0)
                        sat = sizeX
                        val = 1 - sizeY
                        updateColor()
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if connection then
                            connection:Disconnect()
                        end
                    end
                end)
            end)
            
            local colorPicker = {
                Instance = colorPickerContainer,
                Color = default,
                Set = function(self, color)
                    local h, s, v = Color3.toHSV(color)
                    hue, sat, val = h, s, v
                    hueSlider.Position = UDim2.new(h, 0, 0.5, -5)
                    satValSlider.Position = UDim2.new(s, 0, 1 - v, 0)
                    colorDisplay.BackgroundColor3 = color
                    colorPickerSatVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    self.Color = color
                    callback(color)
                end
            }
            
            return colorPicker
        end
        
        function Tab:AddKeybind(text, default, callback)
            local keybindContainer = SafeInstance("Frame", {
                Name = "KeybindContainer",
                Parent = self.Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30)
            })
            
            local keybindLabel = SafeInstance("TextLabel", {
                Name = "KeybindLabel",
                Parent = keybindContainer,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, -80, 1, 0),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local keybindButton = SafeInstance("TextButton", {
                Name = "KeybindButton",
                Parent = keybindContainer,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                local RobloxUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/RobloxUI/main/RobloxUI.lua"))()

local Window = RobloxUI:CreateWindow({
    Name = "RobloxUI Example",
    Color = Color3.fromRGB(32, 32, 32),
    Size = UDim2.new(0, 600, 0, 400)
})

local MainTab = Window:CreateTab("Main")
local SettingsTab = Window:CreateTab("Settings")

MainTab:AddLabel("Welcome to RobloxUI")

MainTab:AddButton("Click Me", function()
    RobloxUI:Notify("Button Clicked", "You clicked the button!", 3)
end)

MainTab:AddToggle("Toggle Example", false, function(value)
    print("Toggle value:", value)
end)

MainTab:AddSlider("Walkspeed", 16, 100, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

SettingsTab:AddSection("User Interface")

SettingsTab:AddDropdown("Theme", {"Dark", "Light", "Blue"}, "Dark", function(value)
    print("Selected theme:", value)
end)

SettingsTab:AddColorPicker("UI Color", Color3.fromRGB(0, 170, 255), function(color)
    print("Selected color:", color)
end)

SettingsTab:AddKeybind("Toggle UI", Enum.KeyCode.RightShift, function(key)
    print("UI toggled with key:", key.Name)
end)

RobloxUI:SetWatermark("RobloxUI v1.0.0")

local InfoTab = Window:CreateTab("Info")

InfoTab:AddParagraph("About", "banger")

InfoTab:AddDivider()

InfoTab:AddTextbox("Username", "Enter your username", function(text, enterPressed)
    print("Username:", text, "Enter pressed:", enterPressed)
end)

InfoTab:AddImage("rbxassetid://6031280882", UDim2.new(0, 150, 0, 150))

local CreditsTab = Window:CreateTab("Credits")

CreditsTab:AddLabel("Created by: WickieHub")
CreditsTab:AddLabel("Version: 1.0.0")
CreditsTab:AddLabel("Executor: " .. executor)

CreditsTab:AddButton("Copy Discord", function()
    setclipboard("https://discord.gg/4njwEXzvRN")
    RobloxUI:Notify("Discord", "Discord tag copied to clipboard!", 3)
end)



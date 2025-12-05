--BYW SCRIPT
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local isMobile = UserInputService.TouchEnabled
local isPC = not isMobile and (UserInputService.MouseEnabled or UserInputService.KeyboardEnabled)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BYWMenu"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local btn = Instance.new("TextButton")
btn.Name = "BYWBtn"
btn.Size = UDim2.new(0, 40, 0, 40)
btn.Position = UDim2.new(0, 10, 0, 10)
btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Text = "B"
btn.TextSize = 28
btn.Font = Enum.Font.GothamBold
btn.BorderSizePixel = 0
btn.Active = true
btn.Draggable = true
btn.Parent = screenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = btn

local TextBox = Instance.new("TextBox")
TextBox.Name = "BYWTextBox"
TextBox.Parent = screenGui
TextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextBox.Size = UDim2.new(0, 180, 0, 40)
TextBox.Position = UDim2.new(0, 50, 0, 10)
TextBox.Font = Enum.Font.GothamBold
TextBox.PlaceholderText = "Введите ник"
TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 16
TextBox.TextXAlignment = Enum.TextXAlignment.Center
TextBox.Visible = false
TextBox.ZIndex = 2

local TextBoxCorner = Instance.new("UICorner")
TextBoxCorner.CornerRadius = UDim.new(0, 12)
TextBoxCorner.Parent = TextBox

local FlingBtn = Instance.new("TextButton")
FlingBtn.Name = "FlingBtn"
FlingBtn.Parent = screenGui
FlingBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FlingBtn.Size = UDim2.new(0, 180, 0, 40)
FlingBtn.Position = UDim2.new(0, 50, 0, 55)
FlingBtn.Font = Enum.Font.GothamBold
FlingBtn.Text = "FLING"
FlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingBtn.TextSize = 18
FlingBtn.Visible = false
FlingBtn.ZIndex = 2

local FlingBtnCorner = Instance.new("UICorner")
FlingBtnCorner.CornerRadius = UDim.new(0, 12)
FlingBtnCorner.Parent = FlingBtn

local menuOpen = false

local function GetPlayer(Name)
    if Name == nil or Name == "" then
        return nil
    end
    
    Name = Name:lower()
    for _, x in next, Players:GetPlayers() do
        if x ~= Player then
            if x.Name:lower():match("^" .. Name) or x.DisplayName:lower():match("^" .. Name) then
                return x
            end
        end
    end
    return nil
end

local function Message(_Title, _Text, Time)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
end

local function SkidFling(TargetPlayer)
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter and TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THumanoid and THumanoid.Sit then
            return Message("Error", "Target is sitting", 5)
        end
        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        else
            workspace.CurrentCamera.CameraSubject = THumanoid
        end
        if not TCharacter:FindFirstChildWhichIsA("BasePart") then
            return
        end
        
        local function FPos(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
        
        local function SFBasePart(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0

            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        
                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
        end
        
        workspace.FallenPartsDestroyHeight = 0/0
        
        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
        
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        
        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart and not THead then
            SFBasePart(TRootPart)
        elseif not TRootPart and THead then
            SFBasePart(THead)
        elseif not TRootPart and not THead and Accessory and Handle then
            SFBasePart(Handle)
        end
        
        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid
        
        repeat
            RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
            Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
            Humanoid:ChangeState("GettingUp")
            table.foreach(Character:GetChildren(), function(_, x)
                if x:IsA("BasePart") then
                    x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                end
            end)
            task.wait()
        until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
        workspace.FallenPartsDestroyHeight = getgenv().FPDH
    else
        return Message("Error", "Random error", 5)
    end
end

local function UpdateMenuPosition()
    if menuOpen then
        local btnPos = btn.Position
        TextBox.Position = UDim2.new(0, btnPos.X.Offset + 45, 0, btnPos.Y.Offset)
        FlingBtn.Position = UDim2.new(0, btnPos.X.Offset + 45, 0, btnPos.Y.Offset + 45)
    end
end

local function ToggleMenu()
    menuOpen = not menuOpen
    TextBox.Visible = menuOpen
    FlingBtn.Visible = menuOpen
    
    if menuOpen then
        UpdateMenuPosition()
        if isPC then
            TextBox:CaptureFocus()
        end
    else
        if isPC then
            TextBox:ReleaseFocus()
        end
    end
end

btn.MouseButton1Click:Connect(function()
    ToggleMenu()
    if menuOpen then
        TextBox:CaptureFocus()
    end
end)

local function ExecuteFling()
    local targetName = TextBox.Text
    
    if targetName == nil or targetName == "" or string.len(targetName:gsub("%s+", "")) == 0 then
        Message("Ошибка", "Введите ник игрока", 3)
        return false
    end
    
    local targetPlayer = GetPlayer(targetName)

    if targetPlayer then
        SkidFling(targetPlayer)
        return true
    else
        Message("Ошибка", "Игрок не найден", 3)
        return false
    end
end

FlingBtn.MouseButton1Click:Connect(function()
    ExecuteFling()
end)

TextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        ExecuteFling()
    end
end)

if isPC then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.RightAlt then
            ToggleMenu()
        end
    end)
end

btn.Draggable = true
local dragging = false
local dragInput, dragStart, startPos

btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = btn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

btn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        
        if menuOpen then
            UpdateMenuPosition()
        end
    end
print("BYW SCRIPT loaded!")
end)

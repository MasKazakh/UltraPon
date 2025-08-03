
if game.Players.LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("UltraPon") then
	warn("Скрипт выдачи инструментов уже запущен.")
	return
end
local toolsData = {
	["Classic Sword"] = 12795293, ["Gravity Coil"] = 15294977,
	["Speed Coil"] = 15294948, ["Fusion Coil"] = 15295009,
	["Bloxy Cola"] = 16922588, ["Magic Carpet"] = 16931538,
	["Skateboard"] = 13576757, ["Rocket Launcher"] = 13333337,
	["Paintball Gun"] = 13333338, ["Trowel"] = 12795328,
	["Pizza"] = 16931248, ["Superball"] = 13333339,
	["Slingshot"] = 13333340, ["Grapple Hook"] = 496924823,
	["Time Bomb"] = 13333341, ["Jet Boots"] = 15437827
}

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "VoidKryp_ToolGiver"
mainGui.ResetOnSpawn = false
mainGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local requestToolEvent = Instance.new("RemoteEvent")
requestToolEvent.Name = "VK_RequestToolEvent"
requestToolEvent.Parent = mainGui

local serverScript = Instance.new("Script")
serverScript.Name = "UltraPonServer"
serverScript.Parent = game.Players.LocalPlayer.Character

serverScript.Source = [[
	local InsertService = game:GetService("InsertService")
	local player = script.Parent.Parent
	local requestToolEvent = player:WaitForChild("PlayerGui"):WaitForChild("VoidKryp_ToolGiver"):WaitForChild("VK_RequestToolEvent")

	local function onToolRequest(requestingPlayer, toolId)
		if requestingPlayer ~= player then return end
		if type(toolId) ~= "number" then return end
		
		local success, model = pcall(function() return InsertService:LoadAsset(toolId) end)
		if not success or not model then return end
		
		local tool = model:FindFirstChildOfClass("Tool")
		if not tool then model:Destroy() return end
		
		tool.Parent = player.Backpack
		
		local character = player.Character
		if character and character:FindFirstChildOfClass("Humanoid") then
			character.Humanoid:EquipTool(tool)
		end
	end

	requestToolEvent.OnServerEvent:Connect(onToolRequest)
	
	script.Parent:WaitForChild("Humanoid").Died:Connect(function() script:Destroy() end)
]]

local mainFrame = Instance.new("Frame")
mainFrame.Name = "ToolGiverFrame"
mainFrame.Size = UDim2.new(0, 420, 0, 300)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Parent = mainGui

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "ToolList"
scrollingFrame.Size = UDim2.new(1, -10, 1, -10)
scrollingFrame.Position = UDim2.new(0, 5, 0, 5)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
scrollingFrame.BorderSizePixel = 0
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
scrollingFrame.Parent = mainFrame

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
gridLayout.CellSize = UDim2.new(0, 90, 0, 30)
gridLayout.Parent = scrollingFrame

for toolName, toolId in pairs(toolsData) do
	local button = Instance.new("TextButton")
	button.Name = toolName
	button.Text = toolName
	button.Font = Enum.Font.SourceSans
	button.TextSize = 14
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	button.BorderSizePixel = 0
	button.Parent = scrollingFrame
	
	button.MouseButton1Click:Connect(function() requestToolEvent:FireServer(toolId) end)
end

print("Скрипт выдачи инструментов успешно запущен.")

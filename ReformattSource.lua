local rft_cmds = {}

function rft_cmds:Find(instance: Instance, target: string)
	if target ~= "" or target ~= nil then
		return instance:FindFirstChild(target)
	end
end

function rft_cmds:FindPlayerByHumanoid(humanoid: Humanoid)
	if humanoid then
		if humanoid.Parent then
			return rft_cmds:Find(game.Players, humanoid.Parent.Name)
		end
	end
end

function rft_cmds:RandomPos(instance: BasePart, min: Vector3, max: Vector3, tween: boolean, seconds: number, delayTime: number, easingStyle: Enum.EasingStyle, easingDirection: Enum.EasingDirection)
	if not tween then
		local newPos = Vector3.new(math.random(min.X, max.X), math.random(min.Y, max.Y), math.random(min.Z, max.Z))
		instance.Position = newPos
	else
		local newPos = Vector3.new(math.random(min.X, max.X), math.random(min.Y, max.Y), math.random(min.Z, max.Z))
		rft_cmds:Tween(instance, seconds, delayTime, easingStyle, easingDirection, { Position = newPos }, 0, false)
	end
end

function rft_cmds:RandomSize(instance: BasePart, min: Vector3, max: Vector3, tween: boolean, seconds: number, delayTime: number, easingStyle: Enum.EasingStyle, easingDirection: Enum.EasingDirection)
	if not tween then
		local newSize = Vector3.new(math.random(min.X, max.X), math.random(min.Y, max.Y), math.random(min.Z, max.Z))
		instance.Size = newSize
	else
		local newSize = Vector3.new(math.random(min.X, max.X), math.random(min.Y, max.Y), math.random(min.Z, max.Z))
		rft_cmds:Tween(instance, seconds, delayTime, easingStyle, easingDirection, { Size = newSize }, 0, false)
	end
end

function rft_cmds:Tween(instance: Instance, seconds: number, delayTime: number, easingStyle: Enum.EasingStyle, easingDirection: Enum.EasingDirection, propertyTable: table, repeatCount: number, reverses: boolean)
	local tweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(seconds, easingStyle, easingDirection, repeatCount, reverses, delayTime)
	local tween = tweenService:Create(instance, tweenInfo, propertyTable)
	tween:Play()
end

function rft_cmds:TouchEvent(instance: BasePart, callback: (instance: Instance, otherPart: Instance, hasHumanoid: boolean, humanoid: Humanoid, isPlayer: boolean, player: Player) -> ())
	instance.Touched:Connect(function(otherPart)
		if rft_cmds:Find(otherPart.Parent, "Humanoid") then
			local hasHumanoid = true
			local humanoid = rft_cmds:Find(otherPart.Parent, "Humanoid")
			if rft_cmds:FindPlayerByHumanoid(humanoid) then
				local isPlayer = true
				local player = rft_cmds:FindPlayerByHumanoid(humanoid)
				callback(instance, otherPart, hasHumanoid, humanoid, isPlayer, player)
			end
		else
			local humanoid = rft_cmds:Find(otherPart.Parent, "Humanoid")
			local player = rft_cmds:FindPlayerByHumanoid(humanoid)
			callback(instance, otherPart, false, humanoid, false, player)
		end
	end)
end

function rft_cmds:KillBrick(instance: BasePart)
	rft_cmds:TouchEvent(instance, function(instance, otherPart, hasHumanoid, humanoid)
		if hasHumanoid then
			if humanoid then
				humanoid.Health = 0
			end
		end
	end)
end

function rft_cmds:SetPrecision(number: number, precision: number)
	local formatString = string.format("%." .. precision .. "f", number)
	return formatString
end

function rft_cmds:Abbreviate(number: number, abbreviations: dictionary)
	if abbreviations then
		local abbreviationIndex = math.floor(math.log(number, 1000))
		local abbreviation = abbreviations[abbreviationIndex]

		if abbreviation then
			local shortNum = number / (1000^abbreviationIndex)
			local intNum = math.floor(shortNum)
			local str = intNum .. abbreviation
			if intNum < shortNum then
				str = str .. "+"
			end
			return str
		else
			return tostring(number)
		end
	else
		local abbreviations = {"K","M","B","T","Qd","Qn","Sx","Sp","O","N"}
		
		local abbreviationIndex = math.floor(math.log(number, 1000))
		local abbreviation = abbreviations[abbreviationIndex]

		if abbreviation then
			local shortNum = number / (1000^abbreviationIndex)
			local intNum = math.floor(shortNum)
			local str = intNum .. abbreviation
			if intNum < shortNum then
				str = str .. "+"
			end
			return str
		else
			return tostring(number)
		end
	end
end

function rft_cmds:RandomColor(instance: BasePart, min: Color3, max: Color3)
	local newColor = Color3.new(math.random(min.R, max.R), math.random(min.G, max.G), math.random(min.B, max.B))
	instance.Color = newColor
end

function rft_cmds:Countdown(seconds: number, tick: (remaining: number, isOver: boolean) -> ())
	local seconds = seconds
	while seconds > 0 do
		seconds = seconds - 1
		if seconds > 0 then
			tick(seconds, false)
		else
			tick(0, true)
			break
		end
		wait(1)
	end
end

return rft_cmds

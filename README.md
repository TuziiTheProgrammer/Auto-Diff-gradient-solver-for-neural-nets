A module script for roblox neural network. 

exmaple of how it works.

---local script---

local DFDN = require(game:GetService("ReplicatedStorage").AutoDiff) [[[gets the module]]]

local textLable = script.Parent.Parent.TextLabel

local value = math.random(1, 5)
local rate = 0.1

script.Parent.Text = "click to find minimum"

---Recursize step---
script.Parent.InputBegan:Connect(function() [[[implementing it here]]]
	
	local grad = DFDN(function(x)
		return x^2 + 1
	end, value)	
	
	value -= grad[1]*rate
	
	local functionAtValue = function(x)
		return x^2 + 1
	end
	
	textLable.Text = value.." At value:"..functionAtValue(value)
end)

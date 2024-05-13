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




In mathematics and computer algebra, automatic differentiation (auto-differentiation, autodiff, or AD), also called algorithmic differentiation, computational differentiation,[1][2] is a set of techniques to evaluate the partial derivative of a function specified by a computer program.

Automatic differentiation exploits the fact that every computer calculation, no matter how complicated, executes a sequence of elementary arithmetic operations (addition, subtraction, multiplication, division, etc.) and elementary functions (exp, log, sin, cos, etc.). By applying the chain rule repeatedly to these operations, partial derivatives of arbitrary order can be computed automatically, accurately to working precision, and using at most a small constant factor of more arithmetic operations than the original program. (wiki)

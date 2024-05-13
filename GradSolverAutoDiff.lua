---This Auto-Differentiator works for simple functions with n paramater size---
local Dual = require(script.DualNumbers) 

local AutoDiff = {}
AutoDiff.__index = AutoDiff

setmetatable(AutoDiff,{
	
	__call = function(table_,...)
		local i: number = 0
		local j: number = 0
		local args = {...}
		local args_clone:{any} = {unpack(args)}
		local functionTable:{} = {}
		local valuesForFunction:{} = {}
		local valueTable = {}
		local df_dn:{} = {}
		local Gradiant:{} = {}
		local inputs = {}
		
		for _, thing in args_clone do
			
			if(type(thing) == "function")then
				i+=1
				functionTable[i] = thing				
			elseif(type(thing) == "number")then
				j+=1
				valueTable[j] = thing
			end
		end
				
		for _, thing in functionTable do
			
			local paramSize: number = debug.info(thing, "a") --- gets paramter size
						
			for t: number = 1, paramSize do
				valuesForFunction[t] = table.remove(valueTable, 1)
				df_dn[t] = valuesForFunction[t] + Dual.eps		
			end
			
			for k: number = 1, paramSize do
				local cloned:{} = table.clone(valuesForFunction)
				
				for p: number = 1, paramSize do
					
					if k == p then
						cloned[k] = df_dn[p]
					end	
				end
				inputs[k] = cloned
				
				if k == paramSize then	
					for h: number = 1, paramSize do
						
						Gradiant[h] = thing(unpack(inputs[h])):DualComponent()
						
					end
				end
			end	
		end	
		
		return Gradiant
	end,	
})

return AutoDiff

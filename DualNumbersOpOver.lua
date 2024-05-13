type DualComponent = {b: number, eps: string}


local DualNumber = {__type = "dualnumber"}
local dualtable = {__index = DualNumber}


---OPERATOR OVERLOADING---
function dualtable.__add(a, b)
	if(type(a) == "number")then
		local number, dualpart = a, b

		return DualNumber.new(dualpart.acomp + number, dualpart.bcomp)
	elseif(type(b) == "number")then
		local dualpart, number = a, b
		return DualNumber.new(dualpart.acomp + number, dualpart.bcomp)
	elseif(a.__type and a.__type == "dualnumber" and b.__type and b.__type == "dualnumber") then
		local d1, d2 = a, b
		return DualNumber.new(d1.acomp + d2.acomp, d1.bcomp + d2.bcomp)
	end
end

function dualtable.__sub(a, b)
	if(type(a) == "number")then
		local number, dualpart = a, b

		return DualNumber.new(dualpart.acomp - number, dualpart.bcomp)
	elseif(type(b) == "number")then
		local dualpart, number = a, b
		return DualNumber.new(dualpart.acomp - number, dualpart.bcomp)
	elseif(a.__type and a.__type == "dualnumber" and b.__type and b.__type == "dualnumber") then
		local d1, d2 = a, b
		return DualNumber.new(d1.acomp - d2.acomp, d1.bcomp - d2.bcomp)
	end
	
end

function dualtable.__unm(a)
	local dualnumber_ = a
	return DualNumber.new(-dualnumber_.acomp, -dualnumber_.bcomp)
end

function dualtable.__mod(a, b)
	
	if(type(a) == "number") then

		local dualpart, real = b, a

		return DualNumber.new(a%dualpart.acomp, a%dualpart.bcomp)

	elseif(type(b) == "number") then

		local dualpart, real = a, b

		return DualNumber.new(dualpart.acomp%b, dualpart.bcomp%b)

	elseif(a.__type and a.__type == "dualnumber" and b.__type and b.__type == "dualnumber") then
		
		local dualpart1, dualpart2 = a, b
		
		if(dualpart2.acomp ~= 0)then
			return DualNumber.new(dualpart1.acomp%dualpart2.acomp, (dualpart1.bcomp*dualpart2.acomp - dualpart1.acomp*dualpart2.bcomp)%(dualpart2.acomp*dualpart2.acomp))
		else
			error("cannot divide by a dual number with a non zero real part")
		end
		
	end
	
	
end

function dualtable.__mul(a, b)
	if(type(a) == "number") then
		
		local dualpart, real = b, a
		
		return DualNumber.new(a * dualpart.acomp, a * dualpart.bcomp)
		
	elseif(type(b) == "number") then
		
		local dualpart, real = a, b

		return DualNumber.new(b * dualpart.acomp, b * dualpart.bcomp)
		
	elseif(a.__type and a.__type == "dualnumber" and b.__type and b.__type == "dualnumber") then
		
		local dualpart1, dualpart2 = a, b
		dualpart1.trackmultiple += 1
		dualpart2.trackmultiple += 1
		
		return DualNumber.new((dualpart1.acomp * dualpart2.acomp), (dualpart1.acomp * dualpart2.bcomp) + (dualpart2.acomp * dualpart1.bcomp))
	end
end

function dualtable.__pow(a, exponent)
	local i = exponent
	
	if type(i) == "number" and (a.__type and a.__type == "dualnumber") then
		
		local dual = a
		
		if (i == 1) then
			return a
		elseif (exponent == 0) then
			return 1
		else
			local pp = dualtable.__pow(dual, i - 1)
			return pp * a
		end
		
	elseif(type(a) == "number" and exponent.__type and exponent.__type == "dualnumber")then
		
		local base, dualed = a, exponent
		
		return math.log(base^dualed:RealComponent()) + math.log(base^dualed:DualComponent())
		
	elseif(a.__type and a.__type == "dualnumber" and exponent.__type and exponent.__type == "dualnumber") then
		local dualBase, dualExpo = a, exponent
		
		return (dualBase:RealComponent()^dualExpo:RealComponent())*(1 + dualExpo:DualComponent()*math.log(dualBase:RealComponent()) + dualBase:DualComponent()*dualExpo:RealComponent()/dualBase:RealComponent())
		
	end
end

function dualtable.__div(a, b)
	
	if(type(a) == "number") then

		local dualpart, real = b, a

		return DualNumber.new(a / dualpart.acomp, a / dualpart.bcomp)

	elseif(type(b) == "number") then

		local dualpart, real = a, b

		return DualNumber.new(dualpart.acomp / b, dualpart.bcomp / b)

	elseif(a.__type and a.__type == "dualnumber" and b.__type and b.__type == "dualnumber") then

		local dualpart1, dualpart2 = a, b
		
		if(dualpart2.acomp ~= 0)then
			return DualNumber.new(dualpart1.acomp/dualpart2.acomp, (dualpart1.bcomp*dualpart2.acomp - dualpart1.acomp*dualpart2.bcomp)/(dualpart2.acomp*dualpart2.acomp))
		else
			error("cannot divide by a dual number with a non zero real part")
		end
		
	end
end

function dualtable.__eq(a, b)
	
	if(type(a) == "number") then
		
		local number, dualpart = a, b
		
		if(math.sqrt(math.pow(dualpart.acomp, 2)) == number)then
			return true
		else
			return false
		end
		
	elseif(type(b) == "number")then
		
		local number, dualpart = b, a

		if(math.sqrt(math.pow(dualpart.acomp, 2)) == number)then
			return true
		else
			return false
		end
		
		
	elseif(a.__type and a.__type == "dualnumber" and b.__type and b.__type == "dualnumber")then
		
		local d1, d2 = a, b
		
		if (d1.acomp == d2.acomp and d1.bcomp == d2.bcomp)then
			return true
		else
			return false
		end
		
	end
end

function dualtable.__lt(a, b)
	
	if(type(a) == "number") then

		local number, dualpart = a, b

		if(dualpart:Magnitude() < number)then
			return true
		else
			return false
		end

	elseif(type(b) == "number")then

		local number, dualpart = b, a

		if(dualpart:Magnitude() > number)then
			return true
		else
			return false
		end


	elseif(a.__type and a.__type == "dualnumber" and b.__type and b.__type == "dualnumber")then

		local d1, d2 = a, b
		local dualcomponentd1, dualcomponentd2 = d1:DualComponent().b, d2:DualComponent().b
		
		
		

		if((d1:Magnitude() and dualcomponentd1) > (d2:Magnitude() and dualcomponentd2)) then
			return true
		elseif(not((d1:Magnitude() and dualcomponentd1) > (d2:Magnitude() and dualcomponentd2)))then
			return false
		end
	end
		
end

function dualtable.__le()
	
end

-----NON Operater Overloading-----

function dualtable.__tostring(t)
	if(t.bcomp > 0)then
		return t.acomp.."+"..t.bcomp..t.dualcomp
	elseif(t.bcomp < 0)then
		return t.acomp..t.bcomp..t.dualcomp
	elseif(t.dualcomp == 0)then
		return t.acomp + t.bcomp
	end
end

----------------------------------

function DualNumber.new(a, b)
	local self = setmetatable({}, dualtable)	
	self.trackmultiple = 0
	self.acomp = a
	self.bcomp = b
	self.dualcomp =  "ε"
	
	if(self.bcomp == 0)then
		self.dualcomp = 0	
	end
	
	return self
end

DualNumber.eps = DualNumber.new(0, 1)

function DualNumber:Magnitude(): number
	local Size = math.sqrt(math.pow(self.acomp, 2))
	return Size	
end

function DualNumber:Conjugate()
	return DualNumber.new(self.acomp, -self.bcomp)
end

function DualNumber:multByConjugate()
	return self * self:Conjugate()
end

function DualNumber:RealComponent()
	return self.acomp
end

function DualNumber:DualComponent():DualComponent
	return self.bcomp
end

return DualNumber

PseudoRandom = {}
PseudoRandom.__index = PseudoRandom

function PseudoRandom:New(nChance) 
	local obj = { 
		counter = 0,
		chance = nChance,
		const = self:CalculateConstant(nChance)
	}
	setmetatable(obj,self)
	return obj
end

function PseudoRandom:Trigger()
	self.counter = self.counter + 1
	if RandomFloat(0,1) < self.counter*self.const then
		self.counter = 0
		return true
	end
	return false
end

function PseudoRandom:CalculateConstant(nChance)
    local Cupper = nChance
    local Clower = 0
    local Cmid
    local p1
    local p2 = 1
    
    while true do
        Cmid = ( Cupper + Clower ) / 2

        p1 = self:CalculateChance( Cmid )
        if math.abs( p1 - p2 ) <= 0 then
        	break
        end

        if p1 > nChance then
            Cupper = Cmid
        else
            Clower = Cmid
        end

        p2 = p1
    end

    return Cmid;
end

function PseudoRandom:CalculateChance(const)
    local pProcOnN = 0
    local pProcByN = 0
    local sumNpProcOnN = 0

    local maxFails = math.ceil( 1 / const )

    for N = 1,maxFails do
        pProcOnN = math.min( 1, N * const ) * (1 - pProcByN)
        pProcByN = pProcByN + pProcOnN
        sumNpProcOnN = sumNpProcOnN + N * pProcOnN
    end

    return 1/sumNpProcOnN
end
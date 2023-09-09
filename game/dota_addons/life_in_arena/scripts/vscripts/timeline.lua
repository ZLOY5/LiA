TimeLine = TimeLine or {}

TIMELINE_EVENT_ROUND_START = 0
TIMELINE_EVENT_ROUND_END = 1
TIMELINE_EVENT_HERO_DEATH = 2
TIMELINE_EVENT_GAME_END = 3

TimeLine.timeline = {}

function TimeLine:Event(data)
	data.time = GameRules:GetGameTime()
	table.insert(self.timeline, data)
end

function TimeLine:HeroDeath(hero)
	self:Event({
		type = TIMELINE_EVENT_HERO_DEATH,
		pID = hero:GetPlayerOwnerID()
	})
end

function TimeLine:RoundStart()
	self:Event({type = TIMELINE_EVENT_ROUND_START})
end

function TimeLine:RoundEnd()
	self:Event({type = TIMELINE_EVENT_ROUND_END})
end

function TimeLine:GameEnd()
	self:Event({type = TIMELINE_EVENT_GAME_END})
end
local Enemy = class("Enemy",function(str)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(str..".ExportJson")
	return ccs.Armature:create(str)
end)

local scheduler = require("framework.scheduler")

function Enemy:ctor()
	self:init()
	self:getAnimation():play("qiangbingzoulu")
	--self:getAnimation():setSpeedScale(0.5)
	self:addStateMachine()
	
end

function Enemy:init()
	EnemyData={}
	if #EnemyData==0 then
		local docpath = cc.FileUtils:getInstance():getWritablePath().."data.txt"
		if cc.FileUtils:getInstance():isFileExist(docpath)==false then
			local str = json.encode(Data.RoleData)
			ModifyData.writeToDoc(str)
			EnemyData=Data.RoleData
		else
			local str = ModifyData.readFromDoc()
			EnemyData=json.decode(str)
		end
	end

	self.hp=EnemyData["qiangbingdonghua"].HP
	self.attack=EnemyData["qiangbingdonghua"].ATTACK
end

function Enemy:addStateMachine()

	cc.GameObject.extend(self):addComponent("components.behavior.StateMachine"):exportMethods()
	self:setupState({
		initial="qiangbingzoulu",
		events={
			{name="idle",from={"qiangbinggongji","qiangbinggongji_2","qiangbingbeigongji"},to="qiangbingzoulu"},
			{name="attack",from={"qiangbingzoulu"},to="qiangbinggongji"},
			{name="attack1",from={"qiangbinggongji"},to="qiangbinggongji_2"},
			{name="Beattacked",from={"qiangbingzoulu","qiangbinggongji","qiangbinggongji_2","qiangbingbeigongji"},to="qiangbingbeigongji"},
			{name="death",from={"qiangbingzoulu","qiangbinggongji","qiangbinggongji_2","qiangbingbeigongji"},to="qiangbingsiwang"}
		},

		callbacks={
			onidle=function(event)
			print(event.to,event.name)
				self:getAnimation():play(event.to)
			end,
			onattack=function(event)
			print(event.to,event.name)
				self:performWithDelay(function()
                    self:getAnimation():play(event.to)
                end, 0.07)
			end,
			onBeattacked=function(event)
				self:getAnimation():play(event.to)
			end,
			ondeath=function(event)
				self:getAnimation():play(event.to,-1,0)
			end
		}

		})

	-- self:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
	-- 	self.movementType=movementType
	-- 	if movementType==2 then
			
	-- 		if self.longPress or self.timer<=40 then
	-- 			if self:canDoEvent("attack") then
	-- 				self:doEvent("attack")
	-- 			end
	-- 		else
	-- 			if self:canDoEvent("idle") then
	-- 				self:doEvent("idle")
	-- 			end
	-- 		end
			
	-- 	end
	-- end)
	-- self.longPress = false
	-- self.timer=0
	self._schedule=scheduler.scheduleUpdateGlobal(handler(self, self.update))
end

function Enemy:update()
	if self:getState() == "qiangbingzoulu" then
	   	self:setPosition(self:getPositionX()-1,self:getPositionY())
	 end
	   --self.timer=self.timer+1
end


return Enemy
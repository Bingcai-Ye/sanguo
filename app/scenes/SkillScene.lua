
local SkillScene = class("SkillScene", function()
    return display.newScene("SkillScene")
end)

function SkillScene:ctor()
	self:init()

end

isnull=true
arraytable={}
function SkillScene:init()
	local node = cc.uiloader:load("SkillScene.csb")
	self:addChild(node)

	--添加人物
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("zhaoyun.ExportJson")
	zhaoyun=ccs.Armature:create("zhaoyun")
	zhaoyun:setPosition(cc.p(130,410))
	zhaoyun:getAnimation():play("呼吸")   
	self:addChild(zhaoyun)
	

	--点击开启按钮
	local click = node:getChildByName("click")
	click:addClickEventListener(function()
		self:clickEvent()
	end)
	local scale1=cc.ScaleTo:create(0.1,1.1)
	local scale2=cc.ScaleTo:create(0.1,1)
	local seq=cc.Sequence:create(scale1,scale2,cc.DelayTime:create(2))
	click:runAction(cc.RepeatForever:create(seq))
	table.insert(arraytable,click)

	--LoadingBar伤害条
	local bg=node:getChildByName("UI_Bg_Property_33")
	local sp=bg:getChildByTag(87)
	local loadingBar=sp:getChildByName("LoadingBar")
	--升级按钮
	local upgrade=node:getChildByName("upgrade")
	upgrade:addClickEventListener(function()
		print("upgrade")
		local per = loadingBar:getPercent()
		if per<101 then
			loadingBar:setPercent(per+1);
			print(per)
		end
	end)
	table.insert(arraytable,upgrade)

	--返回按钮
    local back=node:getChildByName("back");
    back:addClickEventListener(function()
        print("back")
    end)
    table.insert(arraytable,back)

    --选择技能按钮
    scrollview=node:getChildByName("ScrollView_1")
    for  i = 0,5 do 
        local sprite=scrollview:getChildByTag(12+i)
        local button=sprite:getChildByTag(71+i)
        button:addClickEventListener(function()
			self:selectSkill(button)
        end)
        table.insert(arraytable,button)
    end 

    --技能按钮
    for i = 0,5 do
        local sprite=scrollview:getChildByTag(12+i)
        local button=sprite:getChildByTag(64+i)
        button:addClickEventListener(function()
        	self:Skill(button)
        end)
        table.insert(arraytable,button)
    end   

end

--选择技能
function SkillScene:selectSkill(sender)
	local tag=sender:getTag()
	if tag==71 then
		self:selectSkillEvent(sender,"game_ui_ability_SSYJ.png")
	elseif tag==72 then
		self:selectSkillEvent(sender,"game_ui_ability_Charge.png")
	elseif tag==73 then
		self:selectSkillEvent(sender,"game_ui_ability_BYZ.png")
	elseif tag==74 then
		self:selectSkillEvent(sender,"game_ui_ability_HellFire.png")
	elseif tag==75 then
		self:selectSkillEvent(sender,"game_ui_ability_Howl.png")
	elseif tag==76 then
		self:selectSkillEvent(sender,"game_ui_ability_StoneSpike.png")
	end

end
--技能演练
function SkillScene:Skill(sender)
	local tag=sender:getTag()
	if tag==64 then
		self:SkillEvent("攻击2_直线刺击")
	elseif tag==65 then
		self:SkillEvent("攻击2_直线刺击")
	elseif tag==66 then
		self:SkillEvent("攻击5_踢腿砍 总合_改")--"攻击1_斜方刺击","攻击2_直线刺击"
	elseif tag==67 then
		self:SkillEvent("攻击7_旋转砍")
	elseif tag==68 then
		self:SkillEvent("横劈")
	elseif tag==69 then
		self:SkillEvent("攻击4_跃起砍击")
	end

end



function SkillScene:SkillEvent(str)
local function removeSprite(sender)
        sender:removeFromParent()
end
local function animationEvent(armatureBack,movementType,movementID)
	local id = movementID
	if movementType==ccs.MovementEventType.loopComplete then
		if id=="呼吸" then
			armatureBack:stopAllActions()
			armatureBack:getAnimation():play(str)
			-- local sc=cc.SpriteFrameCache:getInstance()
			-- sc:addSpriteFrames("ciji.plist")
			-- local animation=cc.Animation:create()
			-- for i=1,4 do
			-- 	local frameName=string.format("ciji000%d.png",i)
			-- 	local spriteframe=sc:getSpriteFrame(frameName)
			-- 	animation:addSpriteFrame(spriteframe)
			-- end
			-- animation:setDelayPerUnit(0.1)
			-- --animation:setRestoreOriginalFrame(true) --动画执行后还原初始状态
			-- local animate=cc.Animate:create(animation)
			-- local seq=cc.Sequence:create(animate,cc.CallFunc:create(removeSprite))
			-- local sp = cc.Sprite:createWithSpriteFrameName("ciji0001.png")
			-- :setPosition(cc.p(400,380))
			-- :addTo(self)
			-- :runAction(seq)
		elseif id==str then
			armatureBack:stopAllActions()
			armatureBack:getAnimation():play("呼吸")
			zhaoyun:getAnimation():setMovementEventCallFunc(assert)
		end
	end
end

zhaoyun:getAnimation():setMovementEventCallFunc(animationEvent)

end

function SkillScene:selectSkillEvent(sender,str)
	
	if isnull then
	local texture =cc.Director:getInstance():getTextureCache():addImage("UI_AS_Bg_Selected.png")
	sender:getParent():setTexture(texture)
	local bgsp=cc.Sprite:create("UI_AS_Bg_Click.png")
	bgsp:setAnchorPoint(cc.p(0,0))
	bgsp:pos(-8, -10)
	sender:getParent():addChild(bgsp)

		
	local sprite=cc.Sprite:createWithSpriteFrameName(str)
	sprite:setPosition(cc.p(885,410))
	self:addChild(sprite)
	isnull=false
	sender:setEnabled(false)
	sender:setBright(false)
	local scale1 = cc.ScaleTo:create(0.2,1.1)
	local scale2 = cc.ScaleTo:create(0.2,1)
	local seq=cc.Sequence:create(scale1,scale2)
	sprite:runAction(seq)
	local deleteBt = cc.ui.UIPushButton.new({normal="UI_Ability_Delete.png"}) 
	deleteBt:pos(100,95)
	deleteBt:onButtonClicked(function ( )
		sender:setEnabled(true)
		sender:setBright(true)
		sprite:removeFromParent()
		isnull=true
		local texture2=cc.Director:getInstance():getTextureCache():addImage("UI_AS_Bg_Select.png")
		sender:getParent():setTexture(texture2)
		bgsp:removeFromParent()
	end)
	sprite:addChild(deleteBt)

	end
end

function SkillScene:clickEvent()
	scrollview:setTouchEnabled(false)
	for k,v in pairs(arraytable) do
		v:setEnabled(false)
	end
	local layer=display.newColorLayer(cc.c4b(50, 50, 50, 100))
	local parent=cc.Node:create()
	layer:addChild(parent)
	local scale1 = cc.ScaleTo:create(0.2,1.1)
	local scale2 = cc.ScaleTo:create(0.2,1)
	local seq=cc.Sequence:create(scale1,scale2) 
	parent:runAction(seq)
	--背景
	local bg1 = cc.Sprite:createWithSpriteFrameName("UI_Frame_Bg.png")
	bg1:setFlippedX(true)
	bg1:setAnchorPoint(cc.p(1,0.5))
	bg1:pos(530, 320)
	parent:addChild(bg1)
	local edge1=cc.Sprite:createWithSpriteFrameName("Ui_Common_Edge1.png")
	edge1:setAnchorPoint(cc.p(0,1))
	edge1:setFlippedX(true)
	edge1:setFlippedY(true)
	edge1:pos(5, 343)
	bg1:addChild(edge1)
	local bg2 = cc.Sprite:createWithSpriteFrameName("UI_Frame_Bg.png")
	bg2:setAnchorPoint(cc.p(0,0.5))
	bg2:pos(430, 320)
	parent:addChild(bg2)
	local edge2=cc.Sprite:createWithSpriteFrameName("Ui_Common_Edge1.png")
	edge2:setAnchorPoint(cc.p(1,0))
	edge2:pos(320, 5)
	bg2:addChild(edge2)
	self:addChild(layer)
	--关闭按钮
	local closeBt = cc.ui.UIPushButton.new({normal="UI_Ability_Delete.png"})
	closeBt:pos(755, 493)
	parent:addChild(closeBt)
	closeBt:onButtonClicked(function()
		layer:removeFromParent()
		scrollview:setTouchEnabled(true)
		for k,v in pairs(arraytable) do
			v:setEnabled(true)
		end
	end)
	closeBt:setTouchEnabled(true)
	--购买按钮
	local BuyBt = cc.ui.UIPushButton.new({normal="#Ui_Btn_Buy_WithoutMoney.png"})
	BuyBt:pos(480,200)
	BuyBt:onButtonClicked(function()
		layer:removeFromParent()
		scrollview:setTouchEnabled(true)
		for k,v in pairs(arraytable) do
			v:setEnabled(true)
		end
	end)
	parent:addChild(BuyBt)

	--标题
	local title=cc.ui.UILabel.new({text="－开通技能槽－",size=24,color=cc.c4b(162,60,0,255)})
	:align(display.CENTER, 480,450)
	:addTo(parent)

	--技能槽
	local bar=cc.Sprite:createWithSpriteFrameName("game_ui_btn_ability.png")
	:pos(420, 360)
	:setScale(0.8)
	:addTo(parent)
	local label=cc.ui.UILabel.new({text="+",size=40,color=cc.c4b(200,0,0,255)})
	:align(display.CENTER,480,360)
	:addTo(parent)
	local bar1=cc.Sprite:createWithSpriteFrameName("game_ui_btn_ability.png")
	:pos(540, 360)
	:setScale(0.8)
	:addTo(parent)
	
	--花费金额
	local title=cc.ui.UILabel.new({text="需消耗	1000",size=24,color=cc.c4b(162,60,0,255)})
	:align(display.CENTER, 450,280)
	:addTo(parent)
	local bar=cc.Sprite:createWithSpriteFrameName("Ui_Gold.png")
	:pos(550, 280)
	:addTo(parent)

	-- layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	-- 	if event.name=="ended" then 
	-- 		local p = cc.p(event.x,event.y)
	-- 		local size = BuyBt:getContentSize()
	-- 		local rect = cc.rect(-size.width/2, -size.height/2, size.width, size.height)
	-- 		if cc.rectContainsPoint(rect,p) then
	-- 			print("height")
	-- 			layer:removeFromParent()
	-- 		end
	-- 	end 
	-- end)
end

function SkillScene:onEnter()
end

function SkillScene:onExit()
end

return SkillScene

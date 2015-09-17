--333333
local GameLayer = class("GameLayer", function()
    return display.newScene("GameLayer")
end)
local scheduler = require("framework.scheduler")
local second
local third
local fourth
local gameUi
local sprite
local table
local coll=false
local attack = false
local men
function GameLayer:ctor()
    self:init()
end

function GameLayer:init()
--背景
    cc.uiloader:load("FirstLayer.csb"):addTo(self)
    second=cc.uiloader:load("SceondLayer.csb"):addTo(self)
    third=cc.uiloader:load("ThirdLayer.csb"):addTo(self)
    fourth=cc.uiloader:load("FouthLayer.csb"):addTo(self)
    gameUi=cc.uiloader:load("gamelayer.csb"):addTo(self)  
--前进按钮
      local m=gameUi:getChildByTag(101)
      m:addTouchEventListener(function(sender,eventType)
           if eventType == ccui.TouchEventType.began then
              self._scheduleGo = scheduler.scheduleGlobal(handler(self, self.updateGo),0.01)
                
                sprite:getAnimation():play("run")

            elseif eventType == ccui.TouchEventType.ended then 
                     
              scheduler.unscheduleGlobal(self._scheduleGo)
             
                 sprite:getAnimation():play("idle") 
                 
          end
     end)
--后退按钮
     local m=gameUi:getChildByTag(100)
      m:addTouchEventListener(function(sender,eventType)
           if eventType == ccui.TouchEventType.began then
              
                sprite:getAnimation():play("runback")
                self._scheduleBack = scheduler.scheduleGlobal(handler(self, self.updateBack),0.01)   
                   
            elseif eventType == ccui.TouchEventType.ended then
              
              scheduler.unscheduleGlobal(self._scheduleBack)
              sprite:getAnimation():play("idle")       
            end
     end)
--添加敌人
  men=fourth:getChildByTag(1122)
  enemy = require("app.Enemy").new("qiangbingdonghua")
  enemy:pos(2600, 300)
  enemy:setAnchorPoint(cc.p(0.5,0.5))
  fourth:addChild(enemy)
--将碰撞内容放到一个表里
  table={enemy}

--创建英雄
  sprite=require("app.BaseRole").new()
  sprite:setPosition(cc.p(350, 300))
  fourth:addChild(sprite)
  sprite.timer=0

  --self._schedule = scheduler.scheduleGlobal(handler(self, self.iscollision),0.6)
  --self._scheduleEnemy = scheduler.scheduleGlobal(handler(self, self.update),0.01)

--添加小兵
   local soldier1=gameUi:getChildByTag(102)
     soldier1:addTouchEventListener(function(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            self:addSoldier(soldier1)
          end
     end)
   local soldier2=gameUi:getChildByTag(103)
   soldier2:addTouchEventListener(function(sender,eventType)
      if eventType == ccui.TouchEventType.ended then
          self:addSoldier(soldier2)
        end
   end)

--放技能
  local skill = gameUi:getChildByTag(104)
  skill:addTouchEventListener(function(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            self:SkillWait(skill)
          end
     end)

end



--碰撞检测
--攻击范围朝右边
function GameLayer:newRect1(v,str)
    local size = v:getContentSize()
    local x = v:getPositionX()
    local y = v:getPositionY()
    local rect = cc.rect(x, y-size.height/2, Data.RoleData[str].WIDTH, Data.RoleData[str].HEIGHT)
    return rect
end
--攻击范围朝左边
function GameLayer:newRect2(v,str)
    local size = v:getContentSize()
    local x = v:getPositionX()
    local y = v:getPositionY()
    local rect = cc.rect(x-Data.RoleData[str].WIDTH, y-size.height/2, Data.RoleData[str].WIDTH, Data.RoleData[str].HEIGHT)
    return rect
end
function GameLayer:iscollision(dt)
    local rect1 = self:newRect1(sprite,"zhaoyun")
    if cc.rectContainsPoint(rect1,cc.p(enemy:getPositionX(),enemy:getPositionY()))==true then
        sprite.longPress=true
        sprite:doEvent("attack")
        
        local seq = cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function()
            sprite.longPress=false
            self._schedule = scheduler.scheduleGlobal(handler(self, self.iscollision),0.6)
        end))
        self:runAction(seq)
        scheduler.unscheduleGlobal(self._schedule)
    end
end
function GameLayer:update()
    local rect2 = self:newRect2(enemy,"qiangbingdonghua")
    if cc.rectContainsPoint(rect2,cc.p(sprite:getPositionX(),sprite:getPositionY()))==true then
        enemy:doEvent("attack")
    else
        enemy:doEvent("idle")
    end
    -- if enemy:getState() == "qiangbingzoulu" then
    --    enemy:setPosition(enemy:getPositionX()-1,enemy:getPositionY())
    -- end
end

--放小兵，小兵冷却
function GameLayer:addSoldier(sender)
    sender:setEnabled(false)
    local shadow = display.newSprite("#game_ui_btn_unit_shadow.png")
    shadow:pos(sender:getPosition())
    self:addChild(shadow)
    local Soldier = display.newSprite("#game_ui_pikeman.png")
    local progressto = cc.ProgressTo:create(10,100)
    local time = cc.ProgressTimer:create(Soldier)
    time:pos(sender:getPosition())
    self:addChild(time)
    local seq = cc.Sequence:create(progressto,cc.CallFunc:create(function()
      sender:setEnabled(true)
      time:removeFromParent()
      shadow:removeFromParent()
    end))
    time:runAction(seq)
end
--放技能，技能冷却
function GameLayer:SkillWait(sender)
    sender:setEnabled(false)
    local shadow = display.newSprite("#game_ui_btn_ability_shadow.png")
    shadow:pos(sender:getPositionX()-5,sender:getPositionY())
    self:addChild(shadow)
    local Skill = display.newSprite("#game_ui_ability_Charge.png")
    local progressto = cc.ProgressTo:create(10,100)
    local time = cc.ProgressTimer:create(Skill)
    time:pos(sender:getPosition())
    self:addChild(time)
    local seq = cc.Sequence:create(progressto,cc.CallFunc:create(function()
      sender:setEnabled(true)
      time:removeFromParent()
      shadow:removeFromParent()
    end))
    time:runAction(seq)

end

--赵云动作
function GameLayer:ZYDongZuo()
  if coll==false  then
      sprite:getAnimation():play("run")
    -- else
    --   sprite:getAnimation():play("attack_3")
 end
  
end

--前进后退按钮的事件调度
function GameLayer:updateGo(dt)
  if sprite:getState()=="attack_4" then
    scheduler.unscheduleGlobal(self._scheduleGo)
  end
    --self:Men()
    self:ZYGo()
    self:BGGo() 
end
--后退按钮的事件调度
function GameLayer:updateBack(dt)
  if sprite:getState()=="attack_4" then
    scheduler.unscheduleGlobal(self._scheduleBack)
  end
  self:ZYBack()
  self:BGBack()
end
--背景前进
function GameLayer:ZYGo()
    if sprite:getPositionX()<men:getPositionX()-200 then
   transition.moveTo(sprite, {x = sprite:getPositionX()+3.2, y = sprite:getPositionY(), time =0.1})  
    end
end
function GameLayer:ZYBack()
  if sprite:getPositionX()>300 then
    transition.moveTo(sprite, {x = sprite:getPositionX()-3.2, y = sprite:getPositionY(), time =0.1})
  end
  
end
function GameLayer:BGGo()
  if fourth:getPositionX()>-1628 then
        transition.moveTo(second, {x = second:getPositionX()-1, y = second:getPositionY(), time =0.1})
        transition.moveTo(third, {x = third:getPositionX()-1.5, y = third:getPositionY(), time =0.1})
        transition.moveTo(fourth, {x = fourth:getPositionX()-3, y = fourth:getPositionY(), time =0.1})
      end  
end
--背景后退
function GameLayer:BGBack()
  if fourth:getPositionX()<-20 then
        transition.moveTo(second, {x = second:getPositionX()+1, y = second:getPositionY(), time =0.1})
        transition.moveTo(third, {x = third:getPositionX()+1.5, y = third:getPositionY(), time =0.1})
        transition.moveTo(fourth, {x = fourth:getPositionX()+3, y = fourth:getPositionY(), time =0.1})
  end
end

 --检测门和人物的碰撞
function GameLayer:Men()
            if cc.rectContainsPoint(sprite:getBoundingBox(),cc.p(men:getPositionX()-200,men:getPositionY()))==true then
             coll=true
             self:ZYDongZuo()
      else
        coll=false
    end       
end 

return GameLayer

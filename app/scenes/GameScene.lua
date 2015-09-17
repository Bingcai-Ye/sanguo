local GameScene = class("GameScene", function()
    return display.newScene("GameScene")
end)
local scheduler = require("framework.scheduler")
function GameScene:ctor()
	self:init()

end

function GameScene:init()
    enemy = require("app.Enemy").new()
	enemy:pos(display.right-100, display.cy-100)
	self:addChild(enemy)

    
    
    zhaoyun=require("app.BaseRole").new()
    zhaoyun:setPosition(cc.p(300, 300))
    self:addChild(zhaoyun)

	local listener = function(event)
        if event.name == "began" then
        	enemy:doEvent("attack")
        
        enemy.longPress = true
        enemy.timer=0
        return true
        elseif event.name == "ended" then
            enemy.longPress = false
        end
    end

    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, listener)
    
    
    --enemy.longPress = true
    self._schedule = scheduler.scheduleUpdateGlobal(handler(self, self.iscollision))
    
    
    
end

function GameScene:newRect(v)
    local size = v:getContentSize()
    local x = v:getPositionX()
    local y = v:getPositionY()
    local rect = cc.rect(x-size.width/2, y-size.height/2, size.width, size.height)
    --print(x,y,size.width, size.height)
    return rect
end

function GameScene:iscollision(dt)
    local rect1 = self:newRect(enemy)
    local rect2 = self:newRect(zhaoyun)
    --print("------",cc.rectIntersectsRect(rect1,rect2))
    --return cc.rectIntersectsRect(rect1,rect2)
    if cc.rectIntersectsRect(rect1,rect2) then
        scheduler.unscheduleGlobal(self._schedule)
        enemy:doEvent("attack")
    else
        --enemy:doEvent("idle")
    end

end


function GameScene:onEnter()
end

function GameScene:onExit()
end

return GameScene
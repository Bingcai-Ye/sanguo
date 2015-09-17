
local SoldierScene = class("SoldierScene", function()
	return display.newScene("SoldierScene")
end)


function SoldierScene:ctor()

	self:init()
end


function SoldierScene:init()
	local node=cc.uiloader:load("soldierScene.csb")
	self:addChild(node)

	--点击开启按钮
	local click=node:getChildByName("click_s")
    click:addClickEventListener(function()
    	print("click")
    end)
        
    local bg=node:getChildByName("UI_Bg_Property_33")
    --LoadingBar伤害条
    local sp2=bg:getChildByTag(153)
    local loadingBar2=sp2:getChildByName("LoadingBar_2")
    --LoadingBar血量条
    local sp1=bg:getChildByTag(174)
    local loadingBar1=sp1:getChildByName("LoadingBar_1")
    --升级按钮
    local upgrade=node:getChildByName("upgrade_s")
    upgrade:addClickEventListener(function()
        print("upgrade")
        local per1=loadingBar1:getPercent()
        if per1<=100 then 
            loadingBar1:setPercent(per1+1)
            print(per1)
        end
        local per2=loadingBar2:getPercent()
        if per2<=100 then
            loadingBar2:setPercent(per2+1)
            print(per2)
        end
    end)

    --返回按钮
    local back=node:getChildByName("back_s")
    back:addClickEventListener(function()
        print("back")
    end)

    function onTouchBegan(touch, event)
    	
	return true
	end
	function onTouchEnded(touch, event)
		local p = touch:getLocation()
		print(p.y)
	end
	local listener=cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    local dispacther = cc.Director:getInstance():getEventDispatcher()
    dispacther:addEventListenerWithSceneGraphPriority(listener, self)

    --选择兵种按钮
    scrollview=node:getChildByName("ScrollView_1")
    for i = 0,5 do
        local sprite=scrollview:getChildByTag(191+i)
        local button=sprite:getChildByTag(201+i)
        button:addClickEventListener(function()
        	self:selectSoldier(button)
        end)
        
    end
    
    function onTouchBegan(touch, event)
    	
	return true
	end
	function onTouchEnded(touch, event)
		local sp = touch:getCurrentTarget()
		print(sp)
		if sp:getTag()==191 then
			print("ssss")
		end
		
	end
	local listener=cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    local dispacther = cc.Director:getInstance():getEventDispatcher()
    dispacther:addEventListenerWithSceneGraphPriority(listener, scrollview)


end

--选择兵种
function SoldierScene:selectSoldier(sender)
	local tag=sender:getTag()
	if tag==201 then
		-- local sprite=scrollview:getChildByTag(191)
		-- local scale1=cc.ScaleTo:create(0.1,1.5)
		-- local scale1=cc.ScaleTo:create(0.1,1)
		-- local seq=cc.Sequence:create(scale1,scale2)
		-- sprite:runAction(seq)
		print("selectSoldier1")
	elseif tag==202 then
		print("selectSoldier2")
	elseif tag==203 then
		print("selectSoldier3")
	elseif tag==204 then
		print("selectSoldier4")
	elseif tag==205 then
		print("selectSoldier5")
	elseif tag==206 then
		print("selectSoldier6")
	end

end




return SoldierScene
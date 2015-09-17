module("ModifyData",package.seeall)

HP=1000
LEVEL=1
ATTACK=100
ATTACKSPEED=1
MOVESPEED=1
CRITRATE=0
SWORD=100
ATTACKRANGE={0,0,100,100}

--设置角色血量
function setHp(hp)
	HP = hp
end
--获得角色血量
function getHp()
	return HP
end
--设置角色等级
function setLevel(level)
	LEVEL = level
end
--获得角色等级
function getLevel()
	return LEVEL
end
--设置角色攻击力
function setAttack(attack)
	ATTACK = attack
end
--获得角色攻击力
function getAttack()
	return ATTACK
end
--设置攻击速度
function setAttackSpeed(attackSpeed)
	ATTACKSPEED = attackSpeed
end
--获得攻击速度
function getAttackSpeed()
	return ATTACKSPEED
end
--设置移动速度
function setMoveSpeed(moveSpeed)
	MOVESPEED = moveSpeed
end
--获得移动速度
function getMoveSpeed()
	return MOVESPEED
end
--设置暴击率
function setCritRate(critRate)
	CRITRATE = critRate
end
--获得爆击率
function getCritRate()
	return CRITRATE 
end
--设置战斗力
function setSword(sword)
	SWORD = sword
end
--获得战斗力
function getSword()
	return SWORD
end
--设置攻击距离
function setAttackFrame(rect)
	ATTACKRANGE=rect
end
--获得攻击距离
function getAttackframe()
	return ATTACKRANGE
end



--写入沙盒路径
function writeToDoc(str)
	local docpath = cc.FileUtils:getInstance():getWritablePath().."data.txt"
    local f = assert(io.open(docpath, 'w'))
    f:write(str)
    f:close()
end

--从沙盒路径下读出
function readFromDoc()
	local docpath = cc.FileUtils:getInstance():getWritablePath().."data.txt"
 	local str = cc.FileUtils:getInstance():getStringFromFile(docpath)
  	return str
end





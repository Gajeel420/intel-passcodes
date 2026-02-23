Bullet=BaseClass()

function Bullet:__init( t )
	self.transform=t
    self.gameObject=t.gameObject
    self.gameObject:SetActive(true)
    self.fishParent=GameController:GetInstance().view.m_tranParentFish
    self.m_bulletSpeed=850
    self.animator = self.gameObject:GetComponent(typeof(Animator))

    self._lb=self.gameObject:GetComponent(typeof(CS.Bullet3DLuaBehaviour))
    if not self._lb then
        self._lb=self.gameObject:AddComponent(typeof(CS.Bullet3DLuaBehaviour))
    end
    self._lb.onBulletCollderCallBack=function(other) self:OnTriggerEnter(other) end
end
function Bullet:ReBuild()
    self.isCanDestroy=false
    self._isRobot=false
    self._robotChairID=0
    self._targetFish=nil
    self._bulletID=0
    self.player=nil
    self.animator.enabled = true
    self._lb.enabled = true
    self.gameObject:SetActive(true)
end
function Bullet:SetEulerAngles( euler )
    self._lb:SetEulerAngles(euler.x,euler.y,euler.z)
   --[[ self.moveD=self.transform:TransformDirection(Vector3.up)
    self.moveD=Vector3.Normalize(self.moveD)--]]
end
function Bullet:SetSpawnPlayer(player)
	self.player=player
end
function Bullet:SetBulletID( id )
	self._bulletID=id
end
function Bullet:SetRobot(isRobot)
	self._isRobot=isRobot
end
function Bullet:SetRobotChairID(id)
	self._robotChairID=id
end
function Bullet:SetTarget( target )
    if(target==nil) then
        self._lb.m_targetTrans=nil
    else
        self._lb.m_targetTrans=target.transform
    end
    
    self._targetFish=target
end
function Bullet:SetSpAndSnap(spName)
    self.animator:Play(spName)
end

-- function Bullet:Update()
--     -- if self._targetFish == nil or not self._targetFish:IsCanBeHit() or self._targetFish:IsDie() or self._targetFish.isCanDestroy or not self._targetFish:CheckBoundValid() then
--     --     self._lb.m_targetTrans = nil
--     -- end
-- end

function Bullet:OnTriggerEnter( other )
    local beHitFish=nil
    if other.gameObject:CompareTag("Fish") then

        if other.gameObject.name == "01" or other.gameObject.name == "02" then
            other = other.gameObject.transform.parent.parent;
        end
       
        local fish=other.gameObject:GetComponent(typeof(LuaBehaviour)).m_luaTable
        if  self._targetFish and self._targetFish:IsCanBeHit() and not self._targetFish:IsDie() and not self._targetFish.isCanDestroy and self._targetFish:CheckBoundValid() then
       
            if self._targetFish==fish then
                beHitFish=fish
            end
        else
            if  fish and fish:IsCanBeHit() and not fish:IsDie() and not fish.isCanDestroy and fish:CheckBoundValid() then
                beHitFish=fish
            end
        end

        if not beHitFish then
            beHitFish = nil
            return;
        end

        if beHitFish then
            local localPosition = beHitFish:GetLocalPosition();
            local xScreenPoint = localPosition.x;
            local yScreenPoint = localPosition.y;
            xScreenPoint,yScreenPoint=GameController:GetInstance():RealPointToScreenPoint(xScreenPoint, yScreenPoint);
            if self.player.isMe and not self._isRobot then
                local send={}--CMD_C_HitFish
                send.dwBulletID=self._bulletID
                send.dwFishID=beHitFish.vo.uid
                send.nCaptureNetX=math.floor(xScreenPoint)
                send.nCaptureNetY=math.floor(yScreenPoint)
                GameController:GetInstance():SendHitFish(send)
                self.player:ShowFishTips(beHitFish)
            elseif self._isRobot and GameModel:GetInstance().m_myClientDesk==GameController:GetInstance():GetFishPlayerDirection(self.player.HelRobot_ID) then
                --机器人打中鱼
                local send={}--CMD_C_RobotHitFishFromUser
                send.btRobotChairID=self._robotChairID
                send.dwBulletID=self._bulletID
                send.dwFishID=beHitFish.vo.uid
                send.nCaptureNetX=math.floor(xScreenPoint)
                send.nCaptureNetY=math.floor(yScreenPoint)
                GameController:GetInstance():SendRobotHitFish(send)
            end
            self.isCanDestroy=true
            self._lb.isMoving = false
            if self.player.isMe then 
                beHitFish:BeHit(0.2)
            else
                beHitFish:BeHit(0.2)
            end
        end
    end
end

function Bullet:BeHit()
	local beHitFish=nil
	if	self._targetFish and self._targetFish:IsCanBeHit() and not self._targetFish:IsDie() and not self._targetFish.isCanDestroy and self._targetFish:CheckBoundValid() then
		local p=self.fishParent:InverseTransformPoint(self.transform.position)
		local dis=Vector3.Distance(Vector3(self._targetFish.transform.localPosition.x,self._targetFish.transform.localPosition.y,0),Vector3(p.x,p.y,0))
		if dis<=self._targetFish.vo.fishConfig.hitDistance then
			beHitFish=self._targetFish
		end
	else
		-- for k,fish in pairs(GameController:GetInstance():GetEntityModule().fishList) do
		-- 	if	fish and fish:IsCanBeHit() and not fish:IsDie() and not fish.isCanDestroy and fish:CheckBoundValid() then
		-- 		local p=self.fishParent:InverseTransformPoint(self.transform.position)
		-- 		local dis=Vector3.Distance(Vector3(fish.transform.localPosition.x,fish.transform.localPosition.y,0),Vector3(p.x,p.y,0))
		-- 		if dis<=fish.vo.fishConfig.hitDistance then
		-- 			beHitFish=fish
		-- 			break
		-- 		end
		-- 	end
		-- end
        -- local p=self.fishParent:InverseTransformPoint(self.transform.position)
        -- beHitFish=QuadTree.CheckCollision(p)
    end
 

	if beHitFish then
		local localPosition = beHitFish:GetLocalPosition();
        local xScreenPoint = localPosition.x;
        local yScreenPoint = localPosition.y;
        xScreenPoint,yScreenPoint=GameController:GetInstance():RealPointToScreenPoint(xScreenPoint, yScreenPoint);
        if self.player.isMe and not self._isRobot then
        	local send={}--CMD_C_HitFish
    		send.dwBulletID=self._bulletID
    		send.dwFishID=beHitFish.vo.uid
    		send.nCaptureNetX=math.floor(xScreenPoint)
    		send.nCaptureNetY=math.floor(yScreenPoint)
        	GameController:GetInstance():SendHitFish(send)
    	elseif self._isRobot and GameModel:GetInstance().m_myClientDesk==GameController:GetInstance():GetFishPlayerDirection(self.player.HelRobot_ID) then
    		--机器人打中鱼
    		local send={}--CMD_C_RobotHitFishFromUser
    		send.btRobotChairID=self._robotChairID
    		send.dwBulletID=self._bulletID
    		send.dwFishID=beHitFish.vo.uid
    		send.nCaptureNetX=math.floor(xScreenPoint)
    		send.nCaptureNetY=math.floor(yScreenPoint)
    		GameController:GetInstance():SendRobotHitFish(send)
    	end
    	self.isCanDestroy=true
    	beHitFish:BeHit()
	end
end

function Bullet:Move()
    if self._targetFish and not self._targetFish:IsDie() and not self._targetFish.isCanDestroy and self._targetFish:CheckBoundValid() then
        local targetPos = self._targetFish.transform.position;
        self._lb:SetBulletTarget(targetPos.x,targetPos.y,targetPos.z)
    else
        
    end
    self._lb:BulletMove(GameModel:GetInstance().ResolutionWidthHalf,GameModel:GetInstance().ResolutionHeightHalf,GameModel:GetInstance().bulletSpeed)
end

function Bullet:AngleAroundAxis(dirA,dirB,axis)
    local angle = Vector3.Angle(dirA, dirB);
    angle = angle * (Vector3.Dot(axis, Vector3.Cross(dirA, dirB)) < 0 and -1 or 1);
    return angle;
end
function Bullet:__delete( ... )
    -- GameController:GetInstance().view.m_poolBullets:Despawn(self.transform)
    self:SetTarget(nil)
    self.transform.localPosition=Vector3(50000,50000,0)
    self.animator.enabled = false
    self._lb.enabled = false
    self.gameObject:SetActive(false)
end
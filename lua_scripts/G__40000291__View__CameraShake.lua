CameraShake=BaseClass()

function CameraShake:__init(t)
	self.transform=t
	self.shakeTime=0
	self.shake=0
	self.shakeRate=0

	self.animator = t:GetComponent(typeof(Animator))

end
function CameraShake:Update( ... )
	if self.shakeTime>0 then
		self.shakeTime=self.shakeTime-Time.deltaTime
		self.shake=self.shake-self.shakeRate*Time.deltaTime
		self.transform.localPosition=Vector3(math.random()*10,math.random()*10,self.transform.position.z)
		if self.shakeTime<=0 then
			self.transform.localPosition=Vector3.zero
		end
	end
end
function CameraShake:Shake()
	self.shakeTime=1.5
	self.shake=10
	self.shakeRate=self.shake/self.shakeTime
end

function CameraShake :ShakeAnimator(index)
	self.animator.enabled = true
	self.animator:Play("Ani_ShockCam0"..index)
end

function CameraShake:__delete()
	-- body
end
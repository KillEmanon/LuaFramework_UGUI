-- 游戏的ui基类(不知道哪里偷来的)

local uiconfig = require "EscapeRoom.Config.UiConfig"
BaseSample = class("BaseSample")

function BaseSample:Ctor(id, onFinish)
	assert(uiconfig[id] ~= nil,
        "BaseSample:Ctor() - invalid id"..id)
	self._config = 	uiconfig[id]
	self._view = nil
	self._show = false
	self._event = {}
	self._onFinish = onFinish
	self._ctrl = ctrl

	print("BaseSample:Ctor_"..id)
end	

function BaseSample:Init( )
	
end	

function BaseSample:PreLoad(onFinish)
	if(self._view == nil)then
	 self:Load(onFinish)
	end
end	
 
function BaseSample:IsLoaded()
	return	self._view ~= nil
end

function BaseSample:Load(onFinish)
	print(self._view)
	if( self:IsLoaded() )then if(onFinish) then onFinish() end  return end
    panelMgr:CreatePanel(self._config.abName, self._config.name,
	function(go)
		if(not go)then  print(string.format("BaseSample:Load %s load false.",self._config.path)) return end
		self._view = go
		self.gameObject = self._view
		self.transform = self._view.transform
		self.LuaBehaviour = self.gameObject:GetComponent("LuaBehaviour")
		self.LuaBehaviour:SetScriptName(self._config.name.."Ctrl")
		self:Awake()
		self:OnCreate()
		if(onFinish) then onFinish() end
	end
	 )

end

function BaseSample:Awake()
	log("Awake")
end


function BaseSample:OnDisable()
	log("OnDisable")
end


function BaseSample:OnEnable()
	log("OnEnable")
end

function BaseSample:OnCreate()
	log("OnCreate")
	self:_onFinish()
end

function BaseSample:Ondestroy()
	log(self._config.name.." Ondestroy")
end

function BaseSample:UnLoad()
	if( not self:IsLoaded() ) then  return end
	GameObject.Destroy(self._view)
	self:Ondestroy()
	self._view = nil
	self._loaded = false
	self._show = false
	self._onFinish = nil
	self.gameObject = nil
	self.transform = nil
end

function BaseSample:AddEvent(name,handler )
	if(name == nil)then
		logDebug("BaseSample:AddEvent null name.")
	end
    self._event[name] = {name,handler}
end

function BaseSample:GetEvent()
	return self._event
end

function BaseSample:RegiserEvent()
	
end

function BaseSample:onEvent(eventName,...)
    if(nil == self._event[eventName]) then
        logDebug( string.format("layout:onEvent event.name %s not find",eventName))
	end
    local event = self._event[eventName]
    if(event and event[2]) then
        event[2](self,eventName,...)
    end
end
function BaseSample:IsShow()
	return self._show
end	

function BaseSample:Show()
	if( self:IsShow() ) then  return end
	
	self:Load( function () 
		self._view:SetActive(true) 
		self._show = true 
		self:OnEnable()
	end )

	print("Show End")
end

function BaseSample:Hide()
 
	if(  (not self:IsShow())  or  (not self:IsLoaded()) ) then  return end
	 
	self._view:SetActive(false)
	self._show = false
	self:OnDisable()
end

function BaseSample:AddClick(go, handler)
	self.LuaBehaviour:AddClick(go, handler);
end

function BaseSample:Child(name)
	if(self._view == nil )then  return  nil end	
	return self.transform:Find(name) 
end	

function BaseSample:ChildComponent(name,componentType)
	local obj = self:Child(name) 
	if(not obj)then
		return nil
	end
	return obj:GetComponent(componentType) 
end	

return BaseSample
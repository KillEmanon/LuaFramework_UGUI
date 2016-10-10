-- 游戏的ui基类(不知道哪里偷来的)

local uiconfig = require "EscapeRoom.Config.UiConfig"
BaseView = class("BaseView")

function BaseView:Ctor(id, onFinish)
	assert(uiconfig[id] ~= nil,
        "BaseView:Ctor() - invalid id"..id)
	self._config = 	uiconfig[id]
	self._view = nil
	self._show = false
	self._event = {}
	self._onFinish = onFinish
	self._onEnable = nil;
	self._onDisable = nil;

	-- if(self._config.preload) then
	-- 	self:Show()
	-- end

	print("BaseView:Ctor_"..id)
end	

function BaseView:Init( )
	
end	

function BaseView:PreLoad(onFinish)
	if(self._view == nil)then
	 self:Load(onFinish)
	end
end	
 
function BaseView:IsLoaded()
	return	self._view ~= nil
end

function BaseView:Load(onFinish)
	if( self:IsLoaded() )then if(onFinish) then onFinish() end  return end

	if (self._config.isPopup) then
    	panelMgr:CreatePopup(self._config.abName, self._config.name,
		function(go)
			if(not go)then  print(string.format("BaseView:Load %s load false.",self._config.path)) return end
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
	else
    	panelMgr:CreatePanel(self._config.abName, self._config.name,
		function(go)
			if(not go)then  print(string.format("BaseView:Load %s load false.",self._config.path)) return end
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
end

function BaseView:Awake()
	log("Awake")
end


function BaseView:OnDisable()
	if (self._onDisable ~= nil) then
		self:_onDisable();
	end
end


function BaseView:OnEnable()
	if (self._onEnable ~= nil) then
		self:_onEnable();
	end
end

function BaseView:OnCreate()
	log("OnCreate")
	self:_onFinish()
end

function BaseView:Ondestroy()
	log(self._config.name.." Ondestroy")
end

function BaseView:UnLoad()
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

function BaseView:AddEvent(name,handler )
	if(name == nil)then
		logDebug("BaseView:AddEvent null name.")
	end
    self._event[name] = {name,handler}
end

function BaseView:GetEvent()
	return self._event
end

function BaseView:RegiserEvent()
	
end

function BaseView:onEvent(eventName,...)
    if(nil == self._event[eventName]) then
        logDebug( string.format("layout:onEvent event.name %s not find",eventName))
	end
    local event = self._event[eventName]
    if(event and event[2]) then
        event[2](self,eventName,...)
    end
end
function BaseView:IsShow()
	return self._show
end	

function BaseView:Show()
	if( self:IsShow() ) then  return end
	
	self:Load( function () 
		self._view:SetActive(true) 
		self._show = true 
		self:OnEnable()
	end )

	print("Show End")
end

function BaseView:Hide()
	if(  (not self:IsShow())  or  (not self:IsLoaded()) ) then  return end
	self._view:SetActive(false)
	self._show = false
	self:OnDisable()
end

function BaseView:AddClick(go, handler)
	self.LuaBehaviour:AddClick(go, handler);
end

function BaseView:Child(name)
	if(self._view == nil )then  return  nil end	
	return self.transform:Find(name) 
end	

function BaseView:ChildComponent(name,componentType)
	local obj = self:Child(name) 
	if(not obj)then
		return nil
	end
	return obj:GetComponent(componentType) 
end	

return BaseView
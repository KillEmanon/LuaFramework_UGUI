-- 游戏的lua事件管理器

local M = {}

function M:CreateManager(o)
		 local t = o or {}
		 setmetatable(t,self)
		 self.__index = self
		 return t:Init()
end

function M:Init()
	self.debug = false
	self.listeners = {}
	return self
end

function M:AddEventListener(eventName, listener,instance)
      assert( eventName ~= nil,
        "EventManager:AddEventListener() - invalid eventName")    
        
    local eventName = string.upper(eventName)
    if self.listeners[eventName] == nil then
        self.listeners[eventName] = {}
    end         
     
    local handle = table.nums(self.listeners[eventName])
    self.listeners[eventName][handle] = { listener,instance }
    
    self:Log("EventManager:AddEventListener() - add listener [%s] %s for event %s", handle, tostring(listener), eventName)        
         
    return handle
end 

function M:TriggerEvent(eventName,...)
  assert(eventName ~= nil,
         "EventManager:TriggerEvent() - invalid eventKey"..eventName)       

    local eventname = string.upper(eventName)
    self:Log("EventManager:TriggerEvent() - event: %s", eventname)
    
    if self.listeners[eventName] == nil then 
         self:Log("EventManager:TriggerEvent() - event: %s no listener", eventname)
        return      
    end
	local func = nil
    for handle, listener in pairs(self.listeners[eventname]) do
        self:Log("EventManager:TriggerEvent() - event: %s to listener [%s] ", eventname, handle)
		func = listener[1]
		if(func)then
			if listener[2] then
				ret = func(listener[2],eventname,...)
			else
				ret = func(eventname,...)
			end
		end
    end
end

-- 特定事件的特定监听
function M:RemoveEventListener(eventName, key)
    
    assert(eventName ~= nil,
        "EventManager:RemoveEventListener() - invalid event "..eventName)   
    local eventName = string.upper(eventName)   
    if self.listeners[eventName] == nil then return end
    for handle, listener in pairs(self.listeners[eventName]) do
        if key == handle or (key == listener[1]) then
            self.listeners[eventName][handle] = nil
            self:Log("EventManager:RemoveEventListener() - remove listener [%s] for event %s", handle, eventName)
            return handle
        end
    end
end

-- 特定事件的全部监听
function M:RemoveEventAllListener(eventName)
    assert(eventName  ~= nil,
        "EventManager:RemoveEventAllListener() - invalid event "..eventName) 
    
    local eventName = string.upper(eventName)
    self.listeners[string.upper(eventName)] = nil
    self:Log("EventManager:RemoveEventAllListener() - remove all listeners for event %s", eventName)
end
-- 全部的监听
function M:RemoveAll()
    self.listeners = {}
	self:Log("EventManager:RemoveAll() - remove all listeners")
end


function M:SetDebugEnabled(enabled)
    self.debug = enabled
end
function M:Log(fmt,...)
	 if self.debug then
        echo(fmt,...)
    end
end	

function M:Dump()
    print("*** EventManager:Dump() ***")
    for name, listeners in pairs(self.listeners) do
        self:Log("-- Event Name : %s", name)
        for handle, listener in pairs(listeners) do
            printf("---- handle : %s, %s", tostring(handle), tostring(listener))
        end
    end
end	

function M:Release()
     self:RemoveAll()
end

M.Default = M:CreateManager()

return M
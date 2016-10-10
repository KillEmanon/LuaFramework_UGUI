
local uiconfig = require "EscapeRoom.Config.UiConfig"

BaseCtrl = class("BaseCtrl")

function BaseCtrl:Ctor(id)
	assert(uiconfig[id] ~= nil,
        "BaseCtrl:Ctor() - invalid id"..id)
	self._name = uiconfig[id].name
	self._View = require ("EscapeRoom.UI."..self._name.."."..self._name.."View")
	self.lastCtrl = nil
	print(self._name.."BaseCtrl:ctor")
end	

function BaseCtrl:OnCreate()
	print("BaseCtrl.OnCreate")
end

return BaseCtrl
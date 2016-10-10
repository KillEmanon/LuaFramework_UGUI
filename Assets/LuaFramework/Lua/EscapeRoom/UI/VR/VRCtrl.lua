
local C = class("VRCtrl", BaseCtrl)

function C:Ctor(obj, id)
	C.super.Ctor(self, id);
	self.View = self._View:New(id, handler(self, self.OnCreate));
	self.View:Start();
end

function C:OnCreate()
	self.View:Init();
end

return C
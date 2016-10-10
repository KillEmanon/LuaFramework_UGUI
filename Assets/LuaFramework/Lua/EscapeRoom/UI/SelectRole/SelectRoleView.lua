
local V = class("SelectRoleView" ,BaseView)

function V:Ctor(obj, id, onFinish)
	V.super.Ctor(self, id, onFinish);
end

function V:Init()
	self.Button_Role_SPY = self:ChildComponent("Button_Role_SPY", "Button");
	self.Button_Role_Sheriff = self:ChildComponent("Button_Role_Sheriff", "Button");
end

return V

local V = class("MenuView" ,BaseView)

function V:Ctor(obj, id, onFinish)
	V.super.Ctor(self, id, onFinish);
end

--初始化面板--
function V:Init()
	self.Button_Chat = self:ChildComponent("Option_Chat", "Button");
	self.Button_Bag = self:ChildComponent("Option_Bag", "Button");
	self.Button_Wheel = self:ChildComponent("Option_Wheel", "Button");
	self.Button_VRGame = self:ChildComponent("Option_VRGame", "Button");
end

return V;
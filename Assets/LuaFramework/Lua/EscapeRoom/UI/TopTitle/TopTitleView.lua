
local V = class("TopTitleView" ,BaseView)

function V:Ctor(obj, id, onFinish)
	V.super.Ctor(self, id, onFinish);
end

--初始化面板--
function V:Init()
	self.Button_Return = self:ChildComponent("Button_Return", "Button");
end

return V;
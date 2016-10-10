
local C = class("TopTitleCtrl", BaseCtrl)

function C:Ctor(obj, id)
	C.super.Ctor(self, id);
	self.View = self._View:New(id, handler(self, self.OnCreate));
	self.View:Show();
end

function C:OnCreate()
	self.View:Init();

	--注册事件
	self.View:AddClick(self.View.Button_Return, handler(self, self.OnClick_Return));
end

--返回
function C:OnClick_Return()
	Game.ShowModelManager:Deactivate();
	Game.CtrlManager.Return();
end

return C
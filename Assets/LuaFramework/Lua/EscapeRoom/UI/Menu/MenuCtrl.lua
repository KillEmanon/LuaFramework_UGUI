
local C = class("MenuCtrl", BaseCtrl)
local View;

function C:Ctor(obj, id)
	C.super.Ctor(self, id);
	self.View = self._View:New(id, handler(self, self.OnCreate));
	self.View:Show();
end

function C:OnCreate()
	print("MenuCtrl.OnCreate");
	self.View:Init();

	--注册事件
	self.View:AddClick(self.View.Button_Chat, handler(self, self.OnClick_Chat));
	self.View:AddClick(self.View.Button_Bag, handler(self, self.OnClick_Bag));
	self.View:AddClick(self.View.Button_Wheel, handler(self, self.OnClick_Wheel));
	self.View:AddClick(self.View.Button_VRGame, handler(self, self.OnClick_VRGame));
end

--逃脱游戏
function C:OnClick_Chat(obj)
	self.View:Hide();
	Game.CtrlManager.Open("SelectRole");
end

--背包
function C:OnClick_Bag()
	self.View:Hide();
	Game.CtrlManager.Open("Bag");
end

--密码轮
function C:OnClick_Wheel()
	Game.CtrlManager.Open("Prompt");
end

--VRGAME
function C:OnClick_VRGame()
	self.View:Hide();
	Game.CtrlManager.Open("VR");
end

return C
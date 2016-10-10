
local C = class("SelectRoleCtrl", BaseCtrl)
local View;

local roleType = 0;

function C:Ctor(obj, id)
	C.super.Ctor(self, id);
	self.View = self._View:New(id, self.OnCreate);
	View = self.View;
	return this;
end

function C.OnCreate(obj)
	View:Init();

	--注册事件
	View:AddClick(View.Button_Role_SPY, C.OnClick_SPY);
	View:AddClick(View.Button_Role_Sheriff, C.OnClick_Sheriff);
end

--选择警长
function C.OnClick_Sheriff()
	View:Hide();
	Game.EventManager:TriggerEvent("ON_CHAT_ACTIVE", 1);
	Game.CtrlManager.Open("Chat");
end

--选择侦探
function C.OnClick_SPY()
	View:Hide();
	Game.EventManager:TriggerEvent("ON_CHAT_ACTIVE", 2);
	Game.CtrlManager.Open("Chat");
end

return C
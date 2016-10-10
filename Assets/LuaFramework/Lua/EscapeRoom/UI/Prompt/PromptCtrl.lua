local C = class("PromptCtrl", BaseCtrl)

function C:Ctor(obj, id)
	C.super.Ctor(self, id);
	self.View = self._View:New(id, handler(self, self.OnCreate));
	Game.EventManager:AddEventListener("ON_COMMON_PROMPT", self.ShowText, self);
	print(self._name..":ctor");
end

function C:OnCreate()
	self.View:Init();
end

--设置和展示提示面板
function C:ShowText(event, text)
	self.View:ShowText(text);
end

return C

local V = class("VRView" ,BaseView)

function V:Ctor(obj, id, onFinish)
	V.super.Ctor(self, id, onFinish);
end

function V:Start()
	self._onEnable = handler(self, self.OnEnable);
	self._onDisable = handler(self, self.OnDisable);
end

function V:Init()

end

function V:OnEnable()
	Game.ARManager:SetActive(true);
end

function V:OnDisable()
	Game.ARManager:SetActive(false);
end

return V
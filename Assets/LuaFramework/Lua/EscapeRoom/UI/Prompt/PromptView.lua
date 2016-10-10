
local V = class("PromptView" ,BaseView)

function V:Ctor(obj, id, onFinish)
	V.super.Ctor(self, id, onFinish);
end

--标准初始方法，由对应Ctrl执行
function V:Init()
	self.Text_Text = self:ChildComponent("DynamicPanel/Text", "Text");
	self.Image_BG = self:ChildComponent("DynamicPanel/BG", "Image");
	print(self._config.name.."InitComplete")

	self._onEnable = handler(self, self.OnEnable);
end

--激活时触发
function V:OnEnable()
	self.Text_Text:CrossFadeAlpha(1, 0, true);
	self.Image_BG:CrossFadeAlpha(1, 0, true);

	self.Text_Text:CrossFadeAlpha(0, 2, true);
	self.Image_BG:CrossFadeAlpha(0, 2, true);
	Game.TimeManager:StartCountDown(2, handler(self, self.Hide));
end

function V:ShowText(text)
	self:Show();

	if text ~= nil then
		self.Text_Text.text = text;
	end
end

return V
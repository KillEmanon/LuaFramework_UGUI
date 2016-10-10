
local ChatView = class("ChatView" ,BaseView)

--启动事件--
function ChatView:Ctor(obj, id, onFinish)
	ChatView.super.Ctor(self, id, onFinish);
end

--初始化面板--
function ChatView:InitPanel()
	self.Rect_Content = self:ChildComponent("Top/ScrollRect/Content", "RectTransform");
	self.InputField_Message = self:ChildComponent("Bottom/TextField", "InputField");
	self.Text_CountDown = self:ChildComponent("Top/CountDown", "Text");
	self.GO_SendMessage = self:Child("Bottom/Button").gameObject;
	self.Button_Return = self:ChildComponent("Top/Button_Return", "Button");
	print(self)
end

--刷新Content的size
function ChatView:RefreshContent(chatModel)
	print(self)
	self.Rect_Content.sizeDelta = Vector2.New(chatModel.panelWidth, chatModel.panelHeight + UIConfig.BubbleExtraHeight * 2);
end

--更新倒计时
function ChatView:RefreshCountDown(key, time)
	self.Text_CountDown.text = time;
end

return ChatView;
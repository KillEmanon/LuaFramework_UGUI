require "EscapeRoom.Common.functions"
require "EscapeRoom.Common.time"
require "EscapeRoom.UI.Chat.ChatModel"
require "EscapeRoom.UI.Common.BubbleSample"

-- module (..., package.seeall);

local ChatView = require "EscapeRoom.UI.Chat.ChatView"

local ChatCtrl = class("ChatCtrl", BaseCtrl)
local this = ChatCtrl;

this.message = "";				    --当前Input中的内容
this.chatModel = nil;			    --Model的部分
this.chatView = nil;				--View的部分

local countDown;					--倒计时协程

local bubbleList = {};

function ChatCtrl:Ctor(obj, id)
	this.chatModel = ChatModel:New();
	ChatCtrl.super.Ctor(self, id, this.OnCreate);
	self.View = self._View:New(id, self.OnCreate);
	this.chatView = self.View;
	Game.EventManager:AddEventListener("ON_PROCESS_INFO", this.OnProcessInfoAction);
	Game.EventManager:AddEventListener("ON_PROCESS_PIC", this.OnProcessPicAction);
	Game.EventManager:AddEventListener("ON_PROCESS_PROMPT", this.OnProcessPromptAction);
	Game.EventManager:AddEventListener("ON_CHAT_COUNT_DOWN", this.chatView.RefreshCountDown, this.chatView);
	Game.EventManager:AddEventListener("ON_CHAT_PROMPT", this.Prompt);
	Game.EventManager:AddEventListener("ON_CHAT_ACTIVE", this.Active);
	logWarn("ChatCtrl.New--->>");
	return this;
end

--创建完成后执行
function ChatCtrl.OnCreate(obj)
	print("开始挂事件")
	--初始化VIEW
	this.chatView:InitPanel();

	--注册UI事件
	this.chatView:AddClick(this.chatView.GO_SendMessage, this.OnClick_SendMessage);
	this.chatView:AddClick(this.chatView.Button_Return, this.OnClick_ReturnMainActivity);

	Game.DataInit();
	countDown = coroutine.start(this.CountDown);
end

--返回主界面
function ChatCtrl.OnClick_ReturnMainActivity(obj)
	lbsMgr:ReturnMainActivity();
end

--发送消息按钮
function ChatCtrl.OnClick_SendMessage(obj)
	print("触发点击");
	if this.chatView.InputField_Message.text == nil then
		return;
	end

	this.AddBubble(obj,this.chatView.InputField_Message.text, false);
	Game.EventManager:TriggerEvent("ON_PROCESS_CHECK", this.chatView.InputField_Message.text);
end

--初始化激活
--@param roleType 角色身份
function ChatCtrl.Active(obj, roleType)
	this.chatModel.roleType = roleType;
end

--新增气泡--字符串
--@param obj 用于接受对象,注册事件回调时的固定对象
--@param str 气泡内容
--@param isLeft 是否左对齐
function ChatCtrl.AddBubble(obj, str, isLeft)
	this.message = str;
	local go = resMgr:LoadGO('UI', 'BubbleSample', nil);
	go = UnityEngine.Object.Instantiate(go);
	go.transform:SetParent(this.chatView.Rect_Content, false);

	--初始化
	local bubble = Bubble:New(go);
	height = bubble:InitInfo(this.message, this.chatModel.panelWidth, this.chatModel.currentDeep, isLeft, go);

	--刷新Model数据
	this.chatModel:AddBubbleRefresh(height);
	--刷新Content
	this.chatView:RefreshContent(this.chatModel);
	--加入管制
	table.insert(bubbleList, bubble);
end

--Info事件处理
function ChatCtrl.OnProcessInfoAction(event, model)
	this.AddBubble(event, model.message, true);
end

--Prompt事件处理
function ChatCtrl.OnProcessPromptAction(event, prompt)
	this.AddBubble(event, prompt, true);
end

--新增气泡--图片
--@param event 用于接受对象,注册事件回调时的固定对象
--@param model sectionModle,数据model
function ChatCtrl.OnProcessPicAction(event, model)
	local go = resMgr:LoadGO('UI', 'BubbleSample', nil);
	go = UnityEngine.Object.Instantiate(go);
	go.transform:SetParent(this.chatView.Rect_Content, false);
	
	--加载图片相关信息
	local arr = this.ParseString(model.message);
	local image = go:GetComponent(typeof(UnityEngine.UI.Image));
	local sprite = resMgr:LoadSprite(arr[1], arr[2], nil);
	image.sprite = sprite;

	local bubble = Bubble:New(go);
	height = bubble:InitPic(this.chatModel.currentDeep, true);

    --刷新Model数据
	this.chatModel:AddBubbleRefresh(height);
	--刷新容器
	this.chatView:RefreshContent(this.chatModel);
	--加入管制
	table.insert(bubbleList, bubble);

	Game.EventManager:TriggerEvent("ON_PROCESS_NEXT");
end

--提示功能
function ChatCtrl.Prompt(event)
	local message = "您获得了新的提示，输入【提示】即可查看";
	this.AddBubble(event, message, true);
end

--倒计时
function ChatCtrl.CountDown()
	while true do
		coroutine.wait(0.1);
		this.chatModel:CountDown();
	end
end

function ChatCtrl.ParseString(str)
	local arr = string.split(str, "|");
	return arr;
end

return this
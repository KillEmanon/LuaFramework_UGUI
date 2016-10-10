
ChatModel = {};
this = ChatModel;

function ChatModel:New()
	local v = v or {};
	setmetatable(v, {__index = self});
	self.__index = self;
	v:Init();
	return v;
end

function ChatModel:Init()
	self.panelWidth = UnityEngine.Screen.width;            --聊天框宽度
	self.panelHeight = 0;                     			   --聊天框高度
	self.isMy = false;                       			   --是否自身发言
	self.bubbleCount = 0;                      	   		   --气泡数量统计
	self.currentDeep = 0;                    		   	   --当前气泡的深度
	self.roleType = 0;									   --角色身份
	self.startTime = time.GetTime();				       --开始时间
	self.lastTime = 0;								       --最近的一秒
	self.lastPromptTime = self.startTime;				   --最后提示的开始时间
	self.PROMPT_TIME = 10;							   	   --提示等待时间
	self.promptCount = 1;								   --提示的进度
	self.activePromptStep = 0;							   --目前激活的最后提示
end	


--新增泡泡的数据变化
function ChatModel:AddBubbleRefresh(bubbleFinalHeight)
   	self.bubbleCount = self.bubbleCount + 1;
   	self.isMy = not self.isMy;
   	self.currentDeep = self.currentDeep - bubbleFinalHeight - UIConfig.BubbleSpacing;
   	self.panelHeight = -self.currentDeep;
end

--重置提示进度
function ChatModel:ReSetPrompt()
	self.lastPromptTime = time.GetTime();
	self.activePromptStep = 0;
	self.promptCount = 1;
end

--倒计时和提示
function ChatModel:CountDown()
	local currentTime = time.GetTime();
	--是否超过1秒
	if(currentTime - self.lastTime >= 1) then
		self.lastTime = currentTime;
		local str = tostring(time.Format(currentTime - self.startTime + 57600));
		--倒计时触发
		Game.EventManager:TriggerEvent("ON_CHAT_COUNT_DOWN", str);

		--是否满足提示时间
		if((currentTime - self.lastPromptTime) >= self.PROMPT_TIME) then
			local model = Process.GetCurrentModel();
			
			--没有提示
			if (model.prompt == nil) then return end

			--是否还有剩余提示次数
			if(self.promptCount <= #model.prompt) then
				--提示触发
				Game.EventManager:TriggerEvent("ON_CHAT_PROMPT");
				self.lastPromptTime = currentTime;
				self.promptCount = self.promptCount + 1;
				self.activePromptStep = self.activePromptStep + 1;
			end
		end
	end
end

local SectionModel = {};

function SectionModel:New(data)
	local v = v or {};
    setmetatable(v, {__index = self});
    self.__index = self;
    v:Init(data);
    return v;
end

function SectionModel:New(step, stepType, event, message, answer, prompt, roleType)
	local v = v or {};
    setmetatable(v, {__index = self});
    self.__index = self;
    v:Init(step, stepType, event, message, answer, prompt, roleType);
    return v;
end

--初始化
function SectionModel:Init(step, stepType, event, message, answer, prompt, roleType)
	self.step = step;									--步骤，顺序执行
	self.section = 0;									--关卡，当前所处的关卡位置
	self.stepType = stepType;							--类型，0为文字，1为问答，2为图片，3为过关
	self.event = event;									--事件名
	self.message = message;								--信息，内含的文字,0和1都含有该内容
	self.answer = answer;								--答案，回答正确了才能前往下一步骤
	self.prompt = string.split(prompt, '|');         	--提示信息,用'|'分割
	self.roleType = 1;									--玩家扮演的角色

	print(self);
	print(message);
end

--从数据文件初始化
function SectionModel:Init(data)
	self.step = data.step;
	self.section = data.section;
	self.stepType = data.stepType;
	self.event = data.event;
	self.message = data.message;
	self.answer = data.answer;
	self.roleType = data.roleType;

	if (data.prompt ~= nil and data.prompt ~= '') then
		self.prompt = string.split(data.prompt, '|');
	end
	
	print_r(self.prompt)
	
end

return SectionModel;
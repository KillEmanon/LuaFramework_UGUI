----游戏内的时间管理

local M = {}

function M:CreateManager(o)
	local t = o or {}
	setmetatable(t,self)
	self.__index = self
	return t:Init()
end

function M:Init()
	self.startTime = os.time()
	return self
end

--开启一个计时器
--@Param time 倒计时的时间
--@Param onFinish 计时结束触发的回调
function M:StartCountDown(time, onFinish)
	coroutine.start(handler(self, self.CountDown, time, onFinish));
end

--倒计时
function M:CountDown(data)
	local time = data[1];
	local timer = 0;
	local onFinish = data[2];

	while timer < time do
		coroutine.wait(0.1);
		timer = timer + 0.1;
	end
	if (onFinish ~= nil) then
		onFinish();
	end
end

M.Default = M:CreateManager()

return M
--require ("EscapeRoom.Model.SectionModel")

----主逻辑-----
Process = {}
local this = Process;

local sectionList;
local answer = "";
local step = 0;
local keyList = { "<color>" };

local chatCtrl = nil;
local promptStep = 1;			--提示进度

function Process.Init(data)
	sectionList = data;
	Game.EventManager:AddEventListener("ON_PROCESS_CHECK", this.ActionCheckMessage);
	Game.EventManager:AddEventListener("ON_PROCESS_NEXT", this.Next);
	lastPromptTime = time.GetTime();
	chatCtrl = Game.CtrlManager.GetCtrl("Chat");
	print(chatCtrl.chatModel.roleType);
	this.Next();
end

--执行过程
function Process.Excute()
	
	local model = sectionList[step];
	answer = model.answer;
	-- print("index "..step);
	-- print("Now Step "..model.step);
	-- print("eventName "..model.event);

	--分发事件处理
	Game.EventManager:TriggerEvent(model.event, model);
end

--进入下一流程
function Process.Next()
	--步骤自增，提示进度重置
	step = step + 1;
	promptStep = 1;
	chatCtrl.chatModel:ReSetPrompt();

	if step > #sectionList then
		return;
	elseif sectionList[step].roleType == 0 or sectionList[step].roleType == chatCtrl.chatModel.roleType then
		return this.Excute();
	else
		return this.Next();
	end
end


--检测回复
function Process.ActionCheckMessage(obj, message)
	--验证回答
	if answer == message then
		print("correct answer");
		return this.Next();
	--获取提示
	elseif message == "提示" then
		local model = sectionList[step];
		if (promptStep <= chatCtrl.chatModel.activePromptStep) then
			Game.EventManager:TriggerEvent("ON_PROCESS_PROMPT", model.prompt[promptStep], true);
			promptStep = promptStep + 1;
		end
	else
		print("correct is "..answer);
	end
end

local keyHandle =
{
["<color>"] = function(strList)
	for i,v in ipairs(strList) do
		print(i,v)
	end
end
}

--获取当前提示编号
function Process.GetPromptStep()
	return promptStep;
end

--获取当前数据
function Process.GetCurrentModel()
	return sectionList[step];
end

--解析字符串
function ParseString(message)
	for i,v in ipairs(keyList) do
		local strArray = string.split(message, v);
		--判个空
		if strArray == nil then print("ParseString爆炸了") return end
		
		local f;
		if #strArray > 1 then
			f = keyHandle[v];
			if f ~= nil then
				f(strArray);
			end
		else
			print("下一步");
		end
	end
end
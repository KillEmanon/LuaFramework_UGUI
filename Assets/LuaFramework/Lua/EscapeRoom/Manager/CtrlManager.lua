require "EscapeRoom/Common/define"
require "EscapeRoom/UI/Chat/ChatCtrl"

local UIConfig = require ("EscapeRoom.Config.UIConfig")

local CtrlManager = {};
local this = CtrlManager;
local ctrlList = {};
local currentCtrl = nil;

function CtrlManager.Init()
	logWarn("CtrlManager.Init----->>>");
	this.views = {};				--控制器列表
	
	for i=1,#UIConfig do
		local name = UIConfig[i].name;
		local ctrl = require ("EscapeRoom.UI."..name.."."..name.."Ctrl")
		ctrlList[name] = ctrl:New(i);
		print(name);
		print(ctrlList[name]);
	end
	
	currentCtrl = ctrlList["Menu"];
	print(tostring(currentCtrl))
	return this;
end

--添加控制器--
function CtrlManager.AddCtrl(ctrlName, ctrlObj)
	ctrlList[ctrlName] = ctrlObj;
end

--获取控制器--
function CtrlManager.GetCtrl(ctrlName)
	return ctrlList[ctrlName];
end

--移除控制器--
function CtrlManager.RemoveCtrl(ctrlName)
	ctrlList[ctrlName] = nil;
end

--关闭控制器--
function CtrlManager.Close()
	logWarn('CtrlManager.Close---->>>');
end

--激活对应CTRL的VIEW
--@Parm name Ctrl的名字
function CtrlManager.Open(name)
	local Ctrl = this.GetCtrl(name);

	if (Ctrl == nil) then
		print("找不到"..name.."这个Ctrl");
		return;
	end

	Ctrl.View:Show();

	if not Ctrl.View._config.isPopup then
		Ctrl.lastCtrl = currentCtrl;
		currentCtrl = Ctrl;
	end
end

--返回上一个VIEW
function CtrlManager.Return()
	if (currentCtrl == nil or currentCtrl.lastCtrl == nil) then
		print("返回失败");
		return ;
	end

	currentCtrl.View:Hide();
	currentCtrl.lastCtrl.View:Show();
	currentCtrl = currentCtrl.lastCtrl;
end

return CtrlManager
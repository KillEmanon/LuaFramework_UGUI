

--管理器--
local Game = {}
local Csharp = {}
_G.Game = Game

local chatCtrl;
local sectionList = {};
local InitOver = false;

local SectionModel = require ("EscapeRoom.Model.SectionModel")
--------------------------------------------------------------------------------------------------------------------------------------

--加载一堆
function Game.Require(path)

	require "EscapeRoom.Common.functions"
	require "EscapeRoom.Common.time"
	require "EscapeRoom.Common.define"
	require "EscapeRoom.Common.List"
	
	require "EscapeRoom.Model.SectionModel"
	require "EscapeRoom.Process"
	require "EscapeRoom.Log"

	-- require "EscapeRoom.Class.class"
	require "EscapeRoom.Class.BaseView"
	require "EscapeRoom.Class.BaseCtrl"

	require "EscapeRoom.Manager.CtrlManager"

	Game.SectionData = require ("EscapeRoom.Config.SectionData")
	Game.ItemConfig = require("EscapeRoom.Config.ItemConfig")

	Game.EventManager = require ("EscapeRoom.Manager.EventManager").Default
	Game.TimeManager = require ("EscapeRoom.Manager.TimeManager").Default
	Game.LBSManager = require ("EscapeRoom.Manager.LBSManager").Default
	Game.ARManager = require ("EscapeRoom.Manager.ARManager").Default
	Game.ShowModelManager = require ("EscapeRoom.Manager.ShowModelManager").Default
	Game.CtrlManager = require ("EscapeRoom.Manager.CtrlManager")

	Game.EventManager:SetDebugEnabled(false);
	Game.CtrlManager.Init();
end

function Game.Init()
	chatCtrl = Game.CtrlManager.GetCtrl("Chat");
end

--LUA方面的起点,由C#调用
function Game.OnInitOK(path)

	Game.Require(path);
	Game.Init();
	
    -- Game.DataInit();
end

--假装数据初始化
function Game.DataInit()

	for i=1,#Game.SectionData do
		sectionList[i] = SectionModel:New(Game.SectionData[i]);
	end

	InitOver = true;
	Game.Start();
end

--游戏启动
function Game.Start()
	Process.Init(sectionList);
end

--接受定位数据
function Game.OnGetLocationData(data)
	-- print("收到定位数据\n"..data);
	-- if InitOver == false then return end
	-- strArray = string.split(data, "|");
	-- print(lastTime);
	-- print(strArray[1]);
	-- print(lastTime == strArray[1]);
	-- if(lastTime ~= strArray[1]) then
	-- 	lastTime = strArray[1]
	-- 	chatCtrl:AddBubble(data, false);
	-- end
end
local Input = UnityEngine.Input;

local SampleConfig = require ("EscapeRoom.Config.SampleConfig")
local Item = {}

function Item:New(gameObject)
	local v = {}
	setmetatable(v, self);
    self.__index = self;
    v:Start(gameObject);
    return v;
end

function Item:Start(gameObject)
	self.isInit = false;
	self.isDrag = false;
	self.DragStartScreendPos = nil;
	self.DragStartPos = nil;

	self.gameObject = gameObject;
	self.transform = gameObject.transform;
	self.Rect_ItemRoot = self.transform:FindChild("Root"):GetComponent("RectTransform");
	self.Image_Icon = self.transform:FindChild("Root/Icon"):GetComponent("Image");
	self.Text_Name = self.transform:FindChild("Root/Name/Text"):GetComponent("Text");

	self.eventListener = self.gameObject:AddComponent(typeof(EventListener));
	self.eventListener.OnClick = handler(self, Item.OnClick);
	self.eventListener.OnBegin = handler(self, Item.OnDragBegin);
	self.eventListener.OnEnd = handler(self, Item.OnDragEnd);
	self.eventListener.OnStandDrag = handler(self, Item.OnDrag);
end

--初始化
--@Param data 	ItemConfig的一个数据
--@Param index 	物品的编号
function Item:Init(data, bagCtrl, index)
	self.config = data;
	self.Text_Name.text = data.name;
	self.bagCtrl = bagCtrl;
	self.index = index;
	self.isInit = false;
end

--激活同时关闭上一个模型
function Item:Activate()
	if (not self.isInit) then
		Game.ShowModelManager:LoadModel(self.config.modelName);
		self.isInit = true;
	end

	Game.ShowModelManager:Deactivate();
	Game.ShowModelManager:Activate(self.config.modelName);
end

--拖拽事件
function Item:OnDrag()
	if (self.isDrag) then
		self.Rect_ItemRoot.localPosition = InputHandler.Position - self.DragStartPos;
	end
end

--点击事件
function Item:OnClick()
	self.bagCtrl:ActiveItem(self.index);
end

--按下,开启拖拽
function Item:OnDragBegin()
	local tempPos = self.Rect_ItemRoot.position;
	self.Rect_ItemRoot:SetParent(self.bagCtrl.View.transform, false);
	self.Rect_ItemRoot.position = tempPos;
	self.DragStartPos = InputHandler.Position - self.Rect_ItemRoot.localPosition;
	self.isDrag = true;
end

--弹起，关闭拖拽
function Item:OnDragEnd()
	self.Rect_ItemRoot:SetParent(self.transform, true)

	--可以合成的物品进行合成检测
	if(self.config.combineTarget ~= nil) then
		self.bagCtrl:CheckCombine(self);
	end

	self.Rect_ItemRoot.localPosition = Vector3.zero;
	self.isDrag = false;
end

return Item
local BagItemModel = require ("EscapeRoom.Model.BagItemModel")
local ItemSample = require ("EscapeRoom.UI.Common.ItemSample")

local C = class("BagCtrl", BaseCtrl)
local View;

function C:Ctor(obj, id)
	C.super.Ctor(self, id);
	self.View = self._View:New(id, handler(self, self.OnCreate));
	View = self.View;
	print("BagCtrl:ctor")
end

function C:OnCreate()
	View:Init();
	self:Init();
end

function C:Init()
	--测试内容
	self.currentItem = nil;			--现在激活的Item
	self.currentItemNum = 0;		--现在的物品数量
	self.MaxItemNum = 8;			--最大物品数
	self.CellSize = 150;			--物品格大小
	self.IsDrag = false;			--是否处于拖拽状态中
	self.DragItem = nil;			--处于拖拽中的Item

	self.ItemList = List:New();

	--初始化背包物品
	local go = nil;
	local Item = nil;
	for i=0, self.MaxItemNum-1 do
		go = self.View.Transform_Content:GetChild(i).gameObject;
		Item = ItemSample:New(go, self.View.Transform_DragItem);
		self.ItemList:Add(Item);
		self:InsertItem(i + 1, i);
	end

	self.currentItem = self.ItemList:Get(1);
	self:ActiveItem(1);

	View:AddClick(View.Button_Add, handler(self, self.OnClick_Add));
	View:AddClick(View.Button_Remove, handler(self, self.OnClick_Remove));
	View:AddClick(View.Button_Test, handler(self, self.OnClick_Display));
end

--获取了新物品,默认按照顺序添加,有空位插入空位
function C:AddItem(id)
	if (self.currentItemNum >= self.MaxItemNum) then return end

	local tempItem,newIndex = 0;
	for i=1,self.currentItemNum do
		tempItem = self.ItemList:Get(i);
		if (tempItem.config.id == 0) then
			newIndex = i;

			break;
		end
	end

	self.currentItemNum = self.currentItemNum + 1;
	if (newIndex == 0) then newIndex = self.currentItemNum end
	self:LoadItem(newIndex, id);
	print(newIndex)
end

--插入新的道具
function C:InsertItem(index, id)
	if (index < 1 or index > self.MaxItemNum) then return end
	self:LoadItem(index, id);
	self.currentItemNum = self.currentItemNum + 1;
end

--移除原有道具
function C:RemoveItem(index)
	self:LoadItem(index, 0);
	self.currentItemNum = self.currentItemNum - 1;
end

--载入新的Item属性
--@Param index 格子编号
--@Param id 物品配置表id
function C:LoadItem(index, id)
	local item = self.ItemList:Get(index);
	local config = Game.ItemConfig[id];
	
	item:Init(config, self, index);
end

function C:LoadItemByItem(item, id)
	local config = Game.ItemConfig[id];
	item:Init(config);
end

--激活一个Item
--@Param index 激活物品的位置
function C:ActiveItem(index)
	print(tostring(index))
	local item = self.ItemList:Get(index);

	item:Activate(true);

	self.View.Text_Description.text = item.config.text;
	self.currentItem = item;
end

--检测合并物品
function C:CheckCombine(dragItem)

	local distance;
	local tempItem;
	--遍历物品，检测碰撞
	for i=1,self.ItemList.length do
		tempItem = self.ItemList:Get(i);
		--非自身时进行碰撞可能计算
		if (i ~= dragItem.index) then
			distance = dragItem.Rect_ItemRoot.localPosition + dragItem.transform.localPosition - tempItem.transform.localPosition;
			--碰撞发生
			if math.abs(distance.x) < self.CellSize / 2 and math.abs(distance.y) < self.CellSize / 2 then
				--能够合成
				if (tempItem.config.id == dragItem.config.combineTarget) then
					Game.EventManager:TriggerEvent("ON_COMMON_PROMPT", "合成成功!!!");
					self:CombineItem(dragItem, tempItem);
					print("合成成功")
				--不能合成
				else
					Game.EventManager:TriggerEvent("ON_COMMON_PROMPT", "无法合成的物品");
					print("无法合成")
				end
			end
		end
	end
end

--合成物品
function C:CombineItem(dragItem, targetItem)
	local newIndex = dragItem.config.combineResult;
	self:RemoveItem(dragItem.index);
	self:RemoveItem(targetItem.index);
	self:AddItem(newIndex);
end


--------------测试用按钮------------------


function C:OnClick_Add()
	self:AddItem(self.currentItemNum);
	print(self.currentItemNum)
end

function C:OnClick_Remove()
	if(self.currentItemNum <= 0) then
		return
	end

	print(self.currentItemNum)
	self:RemoveItem(self.currentItemNum);
end

function C:OnClick_Display()
	self.ItemList:Display();
end


return C
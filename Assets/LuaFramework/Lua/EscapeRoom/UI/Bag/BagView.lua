
local V = class("BagView" ,BaseView)

function V:Ctor(obj, id, onFinish)
	V.super.Ctor(self, id, onFinish);
end

function V:Init()
	self.Button_Add = self:ChildComponent("Options/Button_Add", "Button");
	self.Button_Remove = self:ChildComponent("Options/Button_Remove", "Button");
	self.Button_Test = self:ChildComponent("Options/Button", "Button");
	self.Transform_Content = self:ChildComponent("Bag/Content", "Transform");
	self.Text_Description = self:ChildComponent("Bag/Info/Description/Text", "Text");
	self.RawImage_ShowPic = self:ChildComponent("Bag/Info/ShowPic/Image", "RawImage");
	self.Transform_DragItem = self:ChildComponent("DragItem", "Transform");
	print("ViewInitComplete")
end

return V
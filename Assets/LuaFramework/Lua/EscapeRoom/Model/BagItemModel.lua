
local BagItemModel = {}

function BagItemModel:New(data)
	local v = {};
    setmetatable(v, {__index = self});
    self.__index = self;
    v:Init(data);
    return v;
end

--从数据文件初始化
function BagItemModel:Init(data, gameObject)
	self.id = data.id;
	self.type = data.type;
	self.name = data.name;
	self.text = data.text;
	self.gameObject = gameObject;
end

return BagItemModel;
-------展示用实体模型控制类

local M = {}

function M:CreateManager(o)
	local t = o or {}
	setmetatable(t,self)
	self.__index = self
	return t:Init()
end

function M:Init()
	self.Root = GameObject.Find("3DCamera/3DRoot").transform;
	self.currentActiveModel = nil;
	self.ModelArray = {};
	return self
end

--载入模型,已经存在的直接返回gameObject
function M:LoadModel(name)
	if (name == "nil") then return nil end

	local go = nil;
	if (self.ModelArray[name] == nil) then
		go = resMgr:LoadGO("Model", name, nil);
		if (go == nil) then return nil end
		go = GameObject.Instantiate(go);
		go.transform:SetParent(self.Root, false);
		self.ModelArray[name] = go;
	else
		go = self.ModelArray[name];
	end

	return go;
end

--设置模型的展示状态
function M:Activate(name)
	local model = self.ModelArray[name];
	if (model ~= nil) then
		model:SetActive(true);
		self.currentActiveModel = model;
	end
end

--关闭模型展示
function M:Deactivate(name)
	if(name ~= nil) then
		if (self.ModelArray[name] ~= nil) then
			self.ModelArray[name]:SetActive(false);
		end
	else
		if (self.currentActiveModel ~= nil and self.currentActiveModel.activeSelf) then
			self.currentActiveModel:SetActive(false);
		end
	end
end

M.Default = M:CreateManager()

return M
--------异步载入资源的控制器

local M = {}

function M:CreateManager(o)
	local v = o or {}
	setmetatable(v,self)
	self.__index = self
	return v:Init()
end

function M:Init()
	self.loadList = {}
	return self
end

--开启一个加载
function M:StartLoad(key, count)
	local num = count or 1;
	if table.find(loadList, key) then
		loadList[key] = loadList[key] + num;
	else
		loadList[key] = num;
	end
end

--一个资源加载完成
function M:LoadOver(key)
	
	if table.find(loadList, key) then
		loadList[key] = loadList[key] - 1;
				
	else
		print("loadList中不存在"..key);
end

M.Default = M:CreateManager()

return M;
local ARConfig = require ("EscapeRoom.Config.ARConfig")

local M = {}

function M:CreateManager()
	local t = o or {}
	setmetatable(t,self)
	self.__index = self
	return t:Init()
end

function M:Init()
	Game.EventManager:AddEventListener("ON_PROCESS_AR", M.OnProcessARAction, self);

	--AR组件载入
	local go = resMgr:LoadGO("UI", "ARRoot", nil);
	go = GameObject.Instantiate(go);
	go.name = "ARRoot";

	--初始化
	self.IsActive = false;
	self.UIRoot = GameObject.Find("Canvas/UIPanel");
	self.Root = GameObject.Find("ARRoot");
	self.Transform_Target = self.Root.transform:FindChild("ImageTarget");
	self.ImageTargetBehaviour = self.Transform_Target:GetComponent("EasyImageTargetBehaviour");
	self.CameraDeviceBehaviour = self.Root.transform:FindChild("EasyAR_Startup/CameraDevice"):GetComponent("CameraDeviceBehaviour");

	self.ImageTargetBehaviour.OnFound = handler(self, self.OnTargetFound);
	self.ImageTargetBehaviour.OnLost = handler(self, self.OnTargetLost);

	self.CameraDeviceBehaviour:StopCapture();
	self:SetActive(false);

	return self;
end

--事件处理
function M:OnProcessARAction(event, data)
	local id = tonumber(data.message);
	print(id)
	self:LoadData(id);
end

--载入数据
function M:LoadData(index)
	local data = ARConfig[index];
	
    self.ImageTargetBehaviour.name = data.name;
    self.ImageTargetBehaviour.Name = data.name;
    self.ImageTargetBehaviour.Path = UnityEngine.Application.persistentDataPath..'/escape/ARTexture/'..data.path;
    self.ImageTargetBehaviour.Storage = EasyAR.StorageType.Absolute;
    self.ImageTargetBehaviour:Init();
    
    print(self.ImageTargetBehaviour.Path);
	-- if (not self.IsActive) then
	-- 	self:SetActive(true);
	-- end
end

--更改当前状态，激活或者反激活
function M:SetActive(bool)
	self.IsActive = bool;
	self.Root:SetActive(bool);
	self.UIRoot:SetActive(not bool);

	if bool then 
		self.CameraDeviceBehaviour:StartCapture();
	else
		self.CameraDeviceBehaviour:StopCapture();
	end
end

--捕捉到target
function M:OnTargetFound()
	Game.EventManager:TriggerEvent("ON_PROCESS_NEXT");
end

--丢失target
function M:OnTargetLost()

end

M.Default = M:CreateManager()

return M
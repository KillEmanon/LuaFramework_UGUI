----定位导航Lua管理器

local M = {};

function M:CreateManager(o)
		 local t = o or {}
		 setmetatable(t,self)
		 self.__index = self
		 return t:Init()
end

function M:Init()
	self.currentLBSData = {}
	self.AverageX = 0
	self.AverageY = 0
	self.AccX = 0
	self.AccY = 0
	self.Count = 0;
end

--接收数据并拆分
function M:OnGetLocationData(data)
	strArray = string.split(data, "|")
	self.time = strArray[1]								--时间，定位坐标未变化则时间也无变化
	self.locType = strArray[2]							--定位类型
	self.latitude = strArray[3]							--纬度
	self.lontitude = strArray[4]						--经度
	self.radius = strArray[5]							--精确度范围
	self.CountryCode = strArray[6]						--国家码
	self.Country = strArray[7]							--国家
	self.CityCode = strArray[8]							--城市码
	self.City = strArray[9]								--城市
	self.District = strArray[10]						--区
	self.Street = strArray[11]							--街道
	self.Addr = strArray[12]							--详细地址
	self.UserIndoorState = strArray[13]					--是否室内环境  是：1  否：？
	self.Direction = strArray[14]						--方向 ？
	self.locationDescribe = strArray[15]				--位置描述
end

--计算平均值
function CalAverage()
	Count = Count + 1
	self.AverageX = (self.AccX + tonumber(self.latitude)) / Count
	self.AverageY = (self.AccY + tonumber(self.lontitude)) / Count
end


--测试用返回安卓主界面
function M:ReturnMainActivity()
	lbsMgr:ReturnMainActivity()
end



M.Default = M:CreateManager()

return M

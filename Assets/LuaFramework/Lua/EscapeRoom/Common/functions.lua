
--输出日志--
function log(str)
    Util.Log(str);
end

--错误日志--
function logError(str) 
	Util.LogError(str);
end

--警告日志--
function logWarn(str) 
	Util.LogWarning(str);
end

--查找对象--
function find(str)
	return GameObject.Find(str);
end

function destroy(obj)
	GameObject.Destroy(obj);
end

function newObject(prefab)
	return GameObject.Instantiate(prefab);
end

--创建面板--
function createPanel(name)
	PanelManager:CreatePanel(name);
end

function child(str)
	return transform:FindChild(str);
end

function subGet(childNode, typeName)		
	return child(childNode):GetComponent(typeName);
end

function findPanel(str) 
	local obj = find(str);
	if obj == nil then
		error(str.." is null");
		return nil;
	end
	return obj:GetComponent("BaseLua");
end



----------------------------------------------下面是不知道从哪里黏贴过来的东西--2016-8-19-Emanon-----------------------------------------------

-- 整理的一些lua函数 参考了部分quick
function handler(target, method, ...)
    local t = {...}
    return function(...)
        return method(target, t, ...)
    end
end

--树形打印一个table
function print_r(sth)
    if type(sth) ~= "table" then
        print(sth)
        return
    end

    local space, deep = string.rep(' ', 4), 0
    local function _dump(t)
        local temp = {}
        for k,v in pairs(t) do
            local key = tostring(k)

            if type(v) == "table" then
                deep = deep + 2
                print(string.format("%s[%s] => Table\n%s(",
                string.rep(space, deep - 1),
                key,
                string.rep(space, deep)
                )) --print.
                _dump(v)
            
                print(string.format("%s)",string.rep(space, deep)))
                deep = deep - 2
            else
                print(string.format("%s[%s] => %s",
                string.rep(space, deep + 1),
                key,
                v
                )) --print.
            end 
        end 
    end

    print(string.format("Table\n("))
    _dump(sth)
    print(string.format(")"))
end


function pairsByKeys(t)  
    local a = {}  
    for n in pairs(t) do  
        a[#a+1] = n  
    end  
    table.sort(a)  
    local i = 0   
    return function()  
        i = i + 1  
        return a[i], t[a[i]]  
    end  
end 

-- 转化为bool
function tobool(v)
    return (v ~= nil and v ~= false)
end

-- 字符串到bool
function stringtobool(v)	
	local v = string.lower(v)
	if(v == "false")then
		return  false
	elseif(v == "true")then
		return true
	end
	return nil
end

--转化为数字。如果无法转化返回0。 
--tonumber()是lua内置函数，但无法转化时返回nil。
--base(2~36)指出参数e当前使用的进制，默认为10进制
function tonum(e, base)
    return tonumber(e, base) or 0
end

--转化为int
--math.round 将值舍入至最接近的整数
function toint(v)
    return math.round(tonum(v))
end

-- 4舍5入
function math.round(num)
    return math.floor(num + 0.5)
end

-- 返回范围内的随机数
function math.randomfloat(min, max)
	math.randomseed(os.time())
	local range = max - min
	local result = min + math.random() * range
	return result
end

--转化为table
--如果不是table类型，返回空表
function totable(v)
    if type(v) ~= "table" then v = {} end
    return v
end

--检查arr是否存在key
function isset(arr, key)
    local t = type(arr)
    return (t == "table" or t == "userdata") and arr[key] ~= nil
end

--分割字符串
function string.split(str, delimiter)
    if (delimiter == nil or delimiter == '') then return false end
    local pos,arr = 0, {}
    for st,sp in function() return string.find(str, delimiter, pos, true) end do
        table.insert(arr, string.sub(str, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(str, pos))
    return arr
end

-- 删除字符串前面的空白字符。 包括：空格、制表符“\t”、换行符“\n”和“\r”
function string.ltrim(str)
    return string.gsub(str, "^[ \t\n\r]+", "")
end
-- 删除字符串尾部的空白字符
function string.rtrim(str)
    return string.gsub(str, "[ \t\n\r]+$", "")
end

--删除字符两端的空白
function string.trim(str)
    str = string.gsub(str, "^[ \t\n\r]+", "")
    return string.gsub(str, "[ \t\n\r]+$", "")
end
-- 首字母大写
function string.ucfirst(str)
    return string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2)
end
--计算一个 UTF8 字符串包含的字符数量
function string.utf8len(str)
    local len  = #str
    local left = len
    local cnt  = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left ~= 0 do
        local tmp = string.byte(str, -left)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return cnt
end

-- 返回target 的index，from为开始查询的位置 useMaxN 为最大查询索引
function table.indexOf(list, target, from, useMaxN)
    local len = (useMaxN and #list) or table.maxn(list)
    if from == nil then
        from = 1
    end
    for i = from, len do
        if list[i] == target then
            return i
        end
    end
    return -1
end
-- 返回表格中 子项中对应key为value的index
function table.indexOfKey(list, key, value, from, useMaxN)
    local len = (useMaxN and #list) or table.maxn(list)
    if from == nil then
        from = 1
    end
    local item = nil
    for i = from, len do
        item = list[i]
        if item ~= nil and item[key] == value then
            return i
        end
    end
    return -1
end
-- 删除table值为item的项
function table.removeItem(list, item, removeAll)
    local rmCount = 0
    for i = 1, #list do
        if list[i - rmCount] == item then
            table.remove(list, i - rmCount)
            if removeAll then
                rmCount = rmCount + 1
            else
                break
            end
        end
    end
end
-- table的元素调用函数fun  v为第一个参数，k为第二个参数 返回值返回到表格    
function table.map(t, fun)
    for k,v in pairs(t) do
        t[k] = fun(v, k)
    end
end


-- table的元素调用函数fun
function table.walk(t, fun)
    for k,v in pairs(t) do
        fun(v, k)
    end
end

function table.filter(t, fun)
    for k,v in pairs(t) do
        if not fun(v, k) then
            t[k] = nil
        end
    end
end

-- 表格是否存在值为item的元素
function table.find(t, item)
    return table.keyOfItem(t, item) ~= nil
end

--返回 表格value == item的key
function table.keyOfItem(t, item)
    for k,v in pairs(t) do
        if v == item then return k end
    end
    return nil
end

function table.removeWithValue(t, value)
    for k,v in pairs(t) do
        if v == value then 
			return table.remove(t, k) 
		end
    end		
end
-- 插入 仅限于下标1开始的连续表格
function table.insertTo(dest, src, begin)
    begin = tonumber(begin)
    if begin == nil then
        begin = #dest + 1
    end

    local len = #src
    for i = 0, len - 1 do
        dest[i + begin] = src[i + 1]
    end
end

-- 返回表格的字段数量 #虽然可以，但是仅限于从1开始连续数字为索引的表格
function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end
-- 返回表格所有的key
function table.keys(t)
    local keys = {}
    for k, v in pairs(t) do
        keys[#keys + 1] = k
    end
    return keys
end
-- 返回表格所有的value
function table.values(t)
    local values = {}
    for k, v in pairs(t) do
        values[#values + 1] = v
    end
    return values
end

-- 合并表格
function table.merge(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end

-- 判定obj是否是 className类的后代
function iskindof(obj, className)
    local t = type(obj)

    if t == "table" then
        local mt = getmetatable(obj)
        while mt and mt.__index do
            if mt.__index.__cname == className then
                return true
            end
            mt = mt.super
        end
        return false

    elseif t == "userdata" then

    else
        return false
    end
end	

function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function class(classname, super)
    local superType = type(super)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
        end

        cls.Ctor    = function() end
        cls.__cname = classname
        cls.__ctype = 1

        function cls.New(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:Ctor(...)
            return instance
        end

    else
        -- inherited from Lua Object
        if super then
            cls = clone(super)
            cls.super = super
        else
            cls = {Ctor = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2 -- lua
        cls.__index = cls
	 
        function cls.New(...)
            local instance = setmetatable({}, cls)
            instance.class = cls
            instance:Ctor(...)
            return instance
        end
    end

    return cls
end

--[[
function BaseClass:New(...)
	local o = {}
	setmetatable(o,self)
	self.__index = self
	o.super = self 
	o:Ctor(...)
	return o
end

local SubClass = Base:New(...)

function SubClass:New(...)
	return Base.New(self,...)
end
]]--



CNode = {}
function CNode:New()
    local o = {}
    o.data = nil
    o.next = nil

    setmetatable(o, self)
    self.__index = self
    return o
end

--------------遵循Lua习惯，所有下标和Index都从1开始---------------------

List = {}
function List:New()
    local o = {}
    o.head = nil
    o.rear = nil
    o.type = "CList"
    o.length = 0

    setmetatable(o, self)
    self.__index = self
    return o
end

function List:Add(data)
    local node = CNode:New()
    node.data = data

    if (self.head == nil) then
        self.rear = node
        self.head = self.rear
        self.length = self.length + 1
        return
    end

    self.rear.next = node
    self.rear = self.rear.next
    self.length = self.length + 1
end

function List:Get(index)
    if (index > self.length or index < 1) then
        print("out of range")
        return nil
    else
        return self:GetElement(index).data
    end
end

--获取指定元素
function List:GetElement(index)
    if (index > self.length or index < 1) then
        print("out of range")
        return nil
    else
        local temp = self.head

        for i=1,index-1 do
            temp = temp.next
        end

        return temp
    end
end

--插入
function List:Insert(index, data)
    if (index > self.length or index < 1) then
        print("插入失败，你所插入的位置不存在|"..index.."|"..self.length)
    else
        local node = CNode:New()
        node.data = data
        node.next = nil

        if (self.head == nil) then
            self.rear = node
            self.head = self.rear
            self.length = self.length + 1
            return
        end

        if (1 == index) then
            node.next = self.head
            self.head = node
            self.length = self.length + 1
        elseif (self.length == index) then
            self.rear.next = node
            self.rear = node
            self.length = self.length + 1
        else
            local temp = self:GetElement(index)
            node.next = temp.next
            temp.next = node
            self.length = self.length + 1
        end
    end    
end

--移除
function List:Remove(index)
    if (index > self.length or index < 1) then
        print("移除失败，你所移除的位置不存在|"..index.."|"..self.length)
    else
        if (1 == index) then
            local temp = self:GetElement(index)
            local r_node = temp.next
            self.head = r_node
            temp.data = nil
            temp = nil
            self.length = self.length - 1
        elseif (self.length == index) then
            local temp = self:GetElement(index - 1)
            local r_node = temp.next
            temp.next = nil
            self.rear = temp
            r_node.data = nil
            r_node = nil
            self.length = self.length - 1
        else
            local temp = self:GetElement(index - 1)
            local r_node = temp.next
            temp.next = temp.next.next
            r_node.data = nil
            r_node = nil
            self.length = self.length - 1
        end
    end
end

function List:Clear()
    local temp = self.head
    while temp do
        local clear = temp
        temp = temp.next
        clear.data = nil
        clear = nil
    end
end

function List:Display()
    local temp = self.head
    while temp do
        print_r(temp.data)
        temp = temp.next
    end
    print('-- display ok --')
end
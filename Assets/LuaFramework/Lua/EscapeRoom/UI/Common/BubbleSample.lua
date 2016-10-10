require "EscapeRoom/Common/define"

local Tran_Text;
local Rect_Item,Rect_Text;
local Text_Text;
local CSF_SizeFitter;
local f_bubbleFinalHeight;

Bubble = {};
this = Bubble;

function Bubble:New(obj)
    local v = v or {};    -- 如果用户没有提供table，则创建一个
    setmetatable(v, self);
    self.__index = self;
    v:Start(obj);
    return v;
end

--初始化一堆组件
function Bubble:Start(obj)
    Rect_Item = obj:GetComponent(typeof(UnityEngine.RectTransform));
    Img_Item = obj:GetComponent(typeof(UnityEngine.UI.Image));
    Tran_Text = obj.transform:FindChild("Text");
    Rect_Text = Tran_Text:GetComponent(typeof(UnityEngine.RectTransform));
    Text_Text = Tran_Text:GetComponent(typeof(UnityEngine.UI.Text));
    CSF_SizeFitter = Tran_Text:GetComponent(typeof(UnityEngine.UI.ContentSizeFitter));
end

-----对话泡泡的初始化
function Bubble:InitInfo(str ,width, deep, isLeft, obj)

    print(str);
    Text_Text.text = str;

    local textMaxWidth = width - UIConfig.BubbleExtraWidth * 2;

    --设置Bubble和Text的坐标,大小
    --内容超过一行
    if Text_Text.preferredWidth > textMaxWidth then
        self:ChangeSize(width, textMaxWidth, deep, true);

    --内容小于一行
    else
        
        self:ChangeSize(width, textMaxWidth, deep, false);
        self:ChangeAlignment(deep, isLeft);
    end

    return Rect_Item.sizeDelta.y;
end

-----图片泡泡的初始化
function Bubble:InitPic(deep, isLeft)

    --图片的格式处理
    Tran_Text.gameObject:SetActive(false);
    local CSF_Image = Rect_Item.gameObject:AddComponent(typeof(UnityEngine.UI.ContentSizeFitter));

    LuaTool.SetImageType(Img_Item, 0);
    LuaTool.SetVerticalFitMod(CSF_Image, 2);
    LuaTool.SetHorizontalFitMod(CSF_Image, 2);
    UnityEngine.Canvas.ForceUpdateCanvases();

    self:ChangeAlignment(deep, isLeft);

    return Rect_Item.sizeDelta.y;
end

function Bubble:ChangeSize(width, textMaxWidth, deep, isWarp)
    --设置Bubble和Text的坐标,大小
    --text
    if(isWarp) then
        LuaTool.SetHorizontalFitMod(CSF_SizeFitter, 0);
        LuaTool.SetVerticalFitMod(CSF_SizeFitter, 2);
        UnityEngine.Canvas.ForceUpdateCanvases();
        Rect_Text.sizeDelta = Vector2.New(textMaxWidth, Rect_Text.sizeDelta.y);

        --image
        Rect_Item.anchoredPosition = Vector2.New(UIConfig.BubblePanelSpacing.x, deep - UIConfig.BubbleExtraHeight);
        Rect_Item.sizeDelta = Vector2.New(width - UIConfig.BubblePanelSpacing.x * 2, Text_Text.preferredHeight + UIConfig.BubbleTextSpacing.y * 2);
    else
        LuaTool.SetHorizontalFitMod(CSF_SizeFitter, 2);
        LuaTool.SetVerticalFitMod(CSF_SizeFitter, 2);
        UnityEngine.Canvas.ForceUpdateCanvases();
        Rect_Item.sizeDelta = Vector2.New(Text_Text.preferredWidth, Rect_Text.sizeDelta.y)
             + UIConfig.BubbleTextSpacing * 2;
    end

    
end

function Bubble:ChangeAlignment(f_deep, b_isLeft)

    --左对齐,默认为左对齐
    if b_isLeft then
        Rect_Item.anchoredPosition = Vector2.New(UIConfig.BubblePanelSpacing.x, f_deep - UIConfig.BubbleExtraHeight);
    --右对齐
    else
        Rect_Item.anchorMax = Vector2.one;
        Rect_Item.anchorMin = Vector2.one;
        Rect_Item.anchoredPosition =
            Vector2.New(-Rect_Item.sizeDelta.x - UIConfig.BubblePanelSpacing.x, f_deep - UIConfig.BubbleExtraHeight);
    end
end

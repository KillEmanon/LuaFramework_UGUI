-- id_default                       int                              保留编号
-- id                               int                              编号
-- type                             int                              物品类型
-- name                             string                           物品名
-- text                             string                           物品描述
-- modelName                        string                           模型名称
-- combineTarget                    int                              合成对象
-- combineResult                    int                              合成结果

return {
	[0] = {
		['id'] = 0,
		['type'] = 0,
		['name'] = "",
		['text'] = "空的",
		['modelName'] = "nil",
		['combineTarget'] = nil,
		['combineResult'] = nil,
	},
	[1] = {
		['id'] = 1,
		['type'] = 1,
		['name'] = "纸条",
		['text'] = "今天天气不错",
		['modelName'] = "nil",
		['combineTarget'] = nil,
		['combineResult'] = nil,
	},
	[2] = {
		['id'] = 2,
		['type'] = 1,
		['name'] = "纸条",
		['text'] = "今天天气很差",
		['modelName'] = "nil",
		['combineTarget'] = nil,
		['combineResult'] = nil,
	},
	[3] = {
		['id'] = 3,
		['type'] = 1,
		['name'] = "纸条",
		['text'] = "你的运气不太好啊",
		['modelName'] = "nil",
		['combineTarget'] = nil,
		['combineResult'] = nil,
	},
	[4] = {
		['id'] = 4,
		['type'] = 1,
		['name'] = "字母密码盘",
		['text'] = "转来转去挺有意思的，但是好像没啥用",
		['modelName'] = "Passwordlock",
		['combineTarget'] = nil,
		['combineResult'] = nil,
	},
	[5] = {
		['id'] = 5,
		['type'] = 1,
		['name'] = "古铜色钥匙",
		['text'] = "看起来有年头的钥匙，不知道能用来干嘛",
		['modelName'] = "GoldKey",
		['combineTarget'] = 7,
		['combineResult'] = 4,
	},
	[6] = {
		['id'] = 6,
		['type'] = 1,
		['name'] = "银白色钥匙",
		['text'] = "从地上捡来的，但是没有沾染灰尘",
		['modelName'] = "nil",
		['combineTarget'] = nil,
		['combineResult'] = nil,
	},
	[7] = {
		['id'] = 7,
		['type'] = 1,
		['name'] = "宝箱",
		['text'] = "哇！这里有一个宝箱，开了会有史诗装备吗",
		['modelName'] = "Chest",
		['combineTarget'] = 5,
		['combineResult'] = 4,
	},
	[8] = {
		['id'] = 8,
		['type'] = 1,
		['name'] = "凑数的",
		['text'] = "为了证明我是8号",
		['modelName'] = "nil",
		['combineTarget'] = nil,
		['combineResult'] = nil,
	},
}

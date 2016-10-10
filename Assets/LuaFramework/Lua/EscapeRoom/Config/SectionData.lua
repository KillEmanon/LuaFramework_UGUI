-- id_default                       int                              保留编号
-- step                             int                              步骤编号
-- stepType                         int                              类型
-- event                            string                           事件名
-- message                          string                           信息
-- answer                           string                           答案
-- prompt                           string                           提示
-- roleType                         int                              角色类型

return {
	[1] = {
		['step'] = 1,
		['stepType'] = 2,
		['event'] = "ON_PROCESS_PIC",
		['message'] = "UI|Square",
		['answer'] = "",
		['prompt'] = "",
		['roleType'] = 1,
	},
	[2] = {
		['step'] = 2,
		['stepType'] = 1,
		['event'] = "ON_PROCESS_INFO",
		['message'] = "【地点】太古汇\n【破案人员】我（侦探）和警长\n【规则】侦查现场，搜集线索，破解谜团，目之所及均可能是重要线索，男女厕所，商城办公场所不纳入侦查范围\n（输入【开始】继续游戏)",
		['answer'] = "开始",
		['prompt'] = "太古汇|天气不错|可以可以",
		['roleType'] = 2,
	},
	[3] = {
		['step'] = 3,
		['stepType'] = 1,
		['event'] = "ON_PROCESS_INFO",
		['message'] = "（叫【警长】输入指令【调查】）\n【盒子图片（4位数密码锁）】\n调查场所：MU\n盒子锁住了，密码会是什么呢",
		['answer'] = "调查",
		['prompt'] = "调查提示1|调查提示2|调查提示3",
		['roleType'] = 2,
	},
	[4] = {
		['step'] = 4,
		['stepType'] = 1,
		['event'] = "ON_PROCESS_INFO",
		['message'] = "（叫【警长】输入指令【破解】）\n【加密文档图】\n调查场所：MU07\n盒子里面是一个手机，在手机桌面发现了一个加密文档，密码会是什么？",
		['answer'] = "破解",
		['prompt'] = "",
		['roleType'] = 2,
	},
	[5] = {
		['step'] = 5,
		['stepType'] = 1,
		['event'] = "ON_PROCESS_INFO",
		['message'] = "看到这个说明热更已经成功",
		['answer'] = "",
		['prompt'] = "",
		['roleType'] = 1,
	},
	[6] = {
		['step'] = 6,
		['stepType'] = 3,
		['event'] = "ON_PROCESS_AR",
		['message'] = "1",
		['answer'] = "",
		['prompt'] = "身份证背面",
		['roleType'] = 1,
	},
	[7] = {
		['step'] = 7,
		['stepType'] = 1,
		['event'] = "ON_PROCESS_INFO",
		['message'] = "通过第一步骤，现在去扫描第二张图片",
		['answer'] = "",
		['prompt'] = "",
		['roleType'] = 1,
	},
	[8] = {
		['step'] = 8,
		['stepType'] = 3,
		['event'] = "ON_PROCESS_AR",
		['message'] = "2",
		['answer'] = "",
		['prompt'] = "俄罗斯方块",
		['roleType'] = 1,
	},
	[9] = {
		['step'] = 9,
		['stepType'] = 1,
		['event'] = "ON_PROCESS_INFO",
		['message'] = "恭喜你已经通过考核",
		['answer'] = "",
		['prompt'] = "",
		['roleType'] = 0,
	},
}

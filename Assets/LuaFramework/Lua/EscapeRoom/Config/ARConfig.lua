-- id_default                       int                              保留编号
-- id                               int                              编号
-- abName                           string                           资源包名
-- name                             string                           文件名
-- path                             string                           路径
-- resType                          string                           资源类型
-- size_x                           float                            图片宽(比例)
-- size_y                           float                            图片高(比例)

return {
	[1] = {
		['id'] = 1,
		['abName'] = "AR",
		['name'] = "idback",
		['path'] = "idback.jpg",
		['resType'] = "UnityEngine.Texture",
		['size_x'] = 8,
		['size_y'] = 5,
	},
	[2] = {
		['id'] = 2,
		['abName'] = "AR",
		['name'] = "smallPic",
		['path'] = "smallPic.jpg",
		['resType'] = "UnityEngine.Texture",
		['size_x'] = 5,
		['size_y'] = 5,
	},
	[3] = {
		['id'] = 3,
		['abName'] = "AR",
		['name'] = "bigPic",
		['path'] = "bigPic.jpg",
		['resType'] = "UnityEngine.Texture",
		['size_x'] = 8,
		['size_y'] = 8,
	},
}

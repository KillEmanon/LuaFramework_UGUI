
time = {}

--获取从某时刻到现在经过的时间
function time.CalGap(time)
	return (os.time() - time);
end

--获取当前时间
function time.GetTime()
	return os.time();
end


--返回标准时间格式  HH-MM-SS
function time.Format(time)
	return os.date("%X", time)
end	
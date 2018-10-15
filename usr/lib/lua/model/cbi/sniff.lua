-- Copyright 2018 Louis Varley <louisvarley@googlemail.com>
-- Licensed to the public under the Apache License 2.0.

local fs  = require "nixio.fs"
local sniffs = { }

local i = 0;
local sys = require "luci.sys"

JSON = (loadfile "/root/JSON.lua")() -- one-time load of the routines

for file in fs.dir[[/usr/sniff]] do


	local index   = i
	local mac = file
	local nickname = "nickname"
	local lastseen = "lastseen"
	local file = "/usr/sniff/" .. mac
	i=i+1
	fileJson = fs.readfile(file)

	local f = io.popen("stat -c %Y " .. fileJson)
	local last_modified = f:read()

	
	local devices = JSON:decode(fileJson) -- decode example

		local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)%.(%d+)"
		local xyear, xmonth, xday, xhour, xminute, xseconds, xmillies, xoffset = devices[1]['lastseen']:match(pattern)
		local last_seen = string.format('%s-%s-%s %s:%s:%s',xyear, xmonth, xday, xhour, xminute, xseconds)	
		local last_seen_epoch = os.time{year=xyear, month=xmonth,day=xday,hour=xhour,minute=xminute,second=xseconds}		
		local epoch_now = os.time()
		local diff = os.difftime(last_seen_epoch,epoch_now)
		
		sniffs["%02i.%s" % { last_seen_epoch, mac }] = {
			name    = devices[1]['mac'],
			company    = devices[1]['company'],			
			index   = tostring(index),
			lastseen = last_seen,	
			lastseen_raw = devices[1]['lastseen'],
			nickname = devices[1]['nickname'],
			file = file
		}
		
		table.sort(sniffs, function (left, right)
			return left[2] > right[2]
		end)
		
end
	
m = SimpleForm("sniff", translate("Request Probe Sniffs"), translate("Devices sending probe requests"))
m.reset = false
m.submit = "Save"

s = m:section(Table, sniffs)

n = s:option(DummyValue, "name", translate("Mac"))
i = s:option(DummyValue, "company", translate("Company"))
l = s:option(DummyValue, "lastseen", translate("Last Seen"))
e = s:option(Value, "nickname", translate("Nickname"))

-- save = s:option(Button, "save", translate("Save"))

e.write = function(self, section, value)
	file = sniffs[section]['file'] 
	local new_json  = JSON:encode({
			["mac"] = sniffs[section]['name'], 
			["company"] = sniffs[section]['company'], 
			["lastseen"] = sniffs[section]['lastseen_raw'], 
			["nickname"] = value}) 
			
	fs.writefile(file, "[" .. new_json .. "]")
end

function parseDateTime(str)

end

return m

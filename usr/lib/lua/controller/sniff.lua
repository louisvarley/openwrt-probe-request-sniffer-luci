-- Copyright 2018 Louis Varley <louisvarley@googlemail.com>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.sniff", package.seeall)

function index()
	if not nixio.fs.access("/usr/sniff/") then
		return
	end

	local page

	page = entry({"admin", "services", "sniff"}, form("sniff"), _("Probe Request Sniffer"), 45)
	page.dependant = false
	page.sysauth = "root"
	page.sysauth_authenticator = "htmlauth"

end

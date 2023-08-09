--Pasted by draki_offiziell
--stand.dll aka Lena helped me with my paste, thx to her
--pasted from addict and themilkman and some french guy



if async_http.have_access() then
	local SCRIPT_VERSION = '0.8'
	local resp = false
	async_http.init(
		'raw.githubusercontent.com/DrakiOffiziell/Pasted-shit/main/version',
		nil,
		function(body, headers, status_code)
			if soup.version_compare(SCRIPT_VERSION, body) == -1 then
				menu.my_root():action(
					'Update Script',
					{},
					$"\"{body}\" is available, you are currently on \"{SCRIPT_VERSION}\".",
					function()
						async_http.init(
						'raw.githubusercontent.com/DrakiOffiziell/Pasted-shit/main/Best Money Lua pasted by draki_offiziell.lua',
						nil,
						function(body_)
							local f = assert(io.open($'{filesystem.scripts_dir()}{SCRIPT_RELPATH}', 'wb'))
							assert(f:write(body_))
							f:close()
							util.restart_script()
						end)
						async_http.dispatch()
					end
				)
				menu.my_root():divider('')
			end
			resp = true
		end,
		function()
			resp = true
		end
	)
	async_http.dispatch()
	repeat
		util.yield()
	until resp
end




util.keep_running()
util.require_natives(1672190175)
local root = menu.my_root()
menu.divider(root, "its detected....")

menu.action(menu.my_root(), "one thing left..", {"ye"}, "its the only function left. all good things must come to an end, it was only a matter of time GG", function()
    MISC.QUIT_GAME() -- os.exit() not working?
end)
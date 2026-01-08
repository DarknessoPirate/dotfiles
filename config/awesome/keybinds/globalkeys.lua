local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")

local _M = {}
local modkey = RC.vars.modkey
local terminal = RC.vars.terminal

function _M.get()
	local globalkeys = gears.table.join(
		-- screenshot
		awful.key({}, "Print", function()
			awful.spawn("scrot -s -e 'xclip -selection clipboard -t image/png < $f && rm $f'")
		end, { description = "take screenshot (select area)", group = "screenshots" }),
		-- rofi
		awful.key({ modkey, "Shift" }, "f", function()
			awful.spawn("rofi -show drun")
		end, { description = "Open rofi", group = "launcher" }),
		-- show help
		awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
		-- previous screen
		awful.key({ modkey }, "h", awful.tag.viewprev, { description = "view previous", group = "tag" }),
		-- next screen
		awful.key({ modkey }, "l", awful.tag.viewnext, { description = "view next", group = "tag" }),
		-- previus screen by history
		awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
		-- focus next window
		awful.key({ modkey }, "j", function()
			awful.client.focus.byidx(1)
		end, { description = "focus next by index", group = "client" }),
		-- focus previous window
		awful.key({ modkey }, "k", function()
			awful.client.focus.byidx(-1)
		end, { description = "focus previous by index", group = "client" }),
		-- open main menu
		awful.key({ modkey }, "w", function()
			RC.mainmenu:show()
		end, { description = "show main menu", group = "awesome" }),

		-- LAYOUT MANIPULATION --
		awful.key({ modkey, "Shift" }, "j", function()
			awful.client.swap.byidx(1)
		end, { description = "swap with next client by index", group = "client" }),
		awful.key({ modkey, "Shift" }, "k", function()
			awful.client.swap.byidx(-1)
		end, { description = "swap with previous client by index", group = "client" }),
		-- focus previous screen
		awful.key({ modkey, "Control" }, "j", function()
			awful.screen.focus_relative(1)
		end, { description = "focus the next screen", group = "screen" }),
		-- focus next screen
		awful.key({ modkey, "Control" }, "k", function()
			awful.screen.focus_relative(-1)
		end, { description = "focus the previous screen", group = "screen" }),
		-- select next layout
		awful.key({ modkey }, "space", function()
			awful.layout.inc(1)
		end, { description = "next layout", group = "layout" }),
		-- select previous layout
		awful.key({ modkey, "Shift" }, "space", function()
			awful.layout.inc(-1)
		end, { description = "previous layout", group = "layout" }),
		-- un-minimize
		awful.key({ modkey, "Control" }, "n", function()
			local c = awful.client.restore()
			if c then
				c:emit_signal("request::activate", "key.unminimize", { raise = true })
			end
		end, { description = "restore minimized", group = "client" }),

		-- jump to urgent client
		awful.key(
			{ modkey },
			"u",
			awful.client.urgent.jumpto,
			{ description = "jump to urgent client", group = "client" }
		),
		awful.key({ modkey }, "Tab", function()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end, { description = "go back", group = "client" }),
		-- Open terminal
		awful.key({ modkey }, "Return", function()
			awful.spawn(terminal)
		end, { description = "open a terminal", group = "launcher" }),
		-- restart WM
		awful.key({ modkey, "Shift" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
		-- quit WM
		awful.key({ modkey, "Control" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

		-- OTHER --
		-- Prompt
		awful.key({ modkey }, "r", function()
			awful.screen.focused().mypromptbox:run()
		end, { description = "run prompt", group = "launcher" }),

		awful.key({ modkey }, "x", function()
			awful.prompt.run({
				prompt = "Run Lua code: ",
				textbox = awful.screen.focused().mypromptbox.widget,
				exe_callback = awful.util.eval,
				history_path = awful.util.get_cache_dir() .. "/history_eval",
			})
		end, { description = "lua execute prompt", group = "awesome" }),

		-- Menubar
		awful.key({ modkey }, "p", function()
			menubar.show()
		end, { description = "show the menubar", group = "launcher" })
	)

	return globalkeys
end

return setmetatable({}, {
	__call = function(_, ...)
		return _M.get(...)
	end,
})

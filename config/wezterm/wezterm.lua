local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Window appearance
config.window_background_opacity = 0.88
config.window_decorations = "RESIZE" -- WezTerm equivalent of Alacritty's "full"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Font configuration
config.font = wezterm.font_with_fallback({
	{
		family = "FantasqueSansM Nerd Font",
		weight = "Regular",
	},
})

config.font_size = 16

-- Font offset (WezTerm uses cell_width and line_height for similar effect)
config.cell_width = 1.0
config.line_height = 1.0

-- Bold and italic fonts (WezTerm handles these automatically with the same family)
config.font_rules = {
	{
		intensity = "Bold",
		font = wezterm.font({
			family = "FantasqueSansM Nerd Font",
			weight = "Bold",
		}),
	},
	{
		italic = true,
		font = wezterm.font({
			family = "FantasqueSansM Nerd Font",
			style = "Italic",
		}),
	},
}

-- Shell configuration (for zsh)
config.default_prog = { "/bin/zsh", "-l" }

-- Key bindings
config.keys = {
	-- Font size controls
	{
		key = "=", -- Plus key without shift
		mods = "CTRL",
		action = wezterm.action.IncreaseFontSize,
	},
	{
		key = "+", -- Plus key with shift
		mods = "CTRL",
		action = wezterm.action.IncreaseFontSize,
	},
	{
		key = "-",
		mods = "CTRL",
		action = wezterm.action.DecreaseFontSize,
	},

	-- Interrupt (Ctrl+Shift+C)
	{
		key = "c",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SendString("\x03"),
	},

	-- Copy and Paste
	{
		key = "c",
		mods = "CTRL",
		action = wezterm.action.CopyTo("Clipboard"),
	},
	{
		key = "v",
		mods = "CTRL",
		action = wezterm.action.PasteFrom("Clipboard"),
	},

	-- Clear screen and scrollback (useful for image artifacts)
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = wezterm.action.Multiple({
			wezterm.action.ClearScrollback("ScrollbackAndViewport"),
			wezterm.action.SendKey({ key = "l", mods = "CTRL" }),
		}),
	},
}

-- Additional useful settings
config.enable_wayland = false -- If  on Wayland
config.check_for_updates = false

-- Performance optimizations for telescope/file finders
config.max_fps = 180
config.animation_fps = 60
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- GPU and rendering optimizations
config.front_end = "OpenGL"

-- Image handling and graphics protocol support
config.enable_kitty_graphics = true
config.enable_kitty_keyboard = true

-- Terminal optimizations
config.alternate_buffer_wheel_scroll_speed = 3
config.bypass_mouse_reporting_modifiers = "SHIFT"

-- Scrollback optimization
config.scrollback_lines = 10000

-- Scrollback
config.scrollback_lines = 10000

-- Tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

-- Cursor
config.default_cursor_style = "SteadyBar"
config.cursor_blink_rate = 0

-- Terminal bell
config.audible_bell = "Disabled"
config.visual_bell = {
	fade_in_duration_ms = 0,
	fade_out_duration_ms = 0,
}
return config

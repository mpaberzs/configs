-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Mocha" -- or Macchiato, Frappe, Latte
config.enable_scroll_bar = true
-- Setting scrollback to huge number can prevent Wezterm from starting
config.scrollback_lines = 9999
config.font_size = 20
config.font = wezterm.font("Roboto Mono")
-- no ligatures
config.harfbuzz_features = { 'calt=0' }
config.enable_scroll_bar = false
-- TODO: maybe need keybinding to hide
config.enable_tab_bar = true
--hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.tab_max_width = 25
config.show_tab_index_in_tab_bar = true
config.switch_to_last_active_tab_when_closing_tab = true
config.show_new_tab_button_in_tab_bar = false

config.window_frame = {
  -- active_titlebar_bg = color.danger.danger_500,
  -- font = font(font_primary, { bold = true }),
  font_size = 18
}

-- TODO: what does it do?
-- config.window_decorations = "RESIZE"
-- config.inactive_pane_hsb = {
--   saturation = 0.9,
--   brightness = 0.8,
-- }
  -- TODO; try regex
config.quick_select_patterns = {
  '[a-zA-Z0-9+_/=]+' -- base64
}

local act = wezterm.action
config.leader = { key = 'Space', mods = 'CTRL|SHIFT' }
config.keys = {
  -- FIXME: loop
  -- tabs start
  {
    key = '1',
    mods = 'ALT',
    action = act.ActivateTab(0)
  },
  {
    key = '2',
    mods = 'ALT',
    action = act.ActivateTab(1)
  },
  {
    key = '3',
    mods = 'ALT',
    action = act.ActivateTab(2)
  },
  {
    key = '4',
    mods = 'ALT',
    action = act.ActivateTab(3)
  },
  {
    key = '5',
    mods = 'ALT',
    action = act.ActivateTab(4)
  },
  {
    key = '6',
    mods = 'ALT',
    action = act.ActivateTab(5)
  },
  {
    key = '7',
    mods = 'ALT',
    action = act.ActivateTab(6)
  },
  {
    key = '8',
    mods = 'ALT',
    action = act.ActivateTab(7)
  },
  {
    key = '9',
    mods = 'ALT',
    action = act.ActivateTab(8)
  },
  -- tabs end
  {
    key = 'c',
    mods = 'CTRL|SHIFT',
    action = act.ActivateCopyMode
  },
  {
    key = 'x',
    mods = 'CTRL|SHIFT',
    action = act.QuickSelect
  },
  -- TODO: make it open url
  {
    -- label = 'open url',
    -- patterns = {
    --   'https?://\\S+',
    -- },
    -- skip_action_on_paste = true,
    -- action = wezterm.action_callback(function(window, pane)
    --   local url = window:get_selection_text_for_pane(pane)
    --   wezterm.log_info('opening: ' .. url)
    --   wezterm.open_with(url)
    -- end),
    key = 'y',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.QuickSelectArgs {
      patterns = {
        'https?://\\S+',
      },
    },
  },
  { key = 'h', mods='CTRL|SHIFT', action = act.ActivatePaneDirection 'Left' },

  { key = 'l',mods='CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },

  { key = 'k',mods='CTRL|SHIFT', action = act.ActivatePaneDirection 'Up' },

  { key = 'j',mods='CTRL|SHIFT', action = act.ActivatePaneDirection 'Down' },

  {
    key = 'r',
    mods = 'LEADER',
    action = act.ActivateKeyTable {
      name = 'resize_pane',
      one_shot = false,
    },
  },

  -- pane maximization
  { key = 'Enter', mods='CTRL|SHIFT', action = act.TogglePaneZoomState },

  -- splits
  { key = 'v',mods='CTRL|SHIFT|ALT', action = act.SplitVertical { domain='CurrentPaneDomain'} },
  { key = 'h',mods='CTRL|SHIFT|ALT', action = act.SplitHorizontal { domain='CurrentPaneDomain'} },
  --
  -- resize
  -- { key = 'leftarrow',mods='ctrl|shift', action = act.ActivatePaneDirection 'left' },
  -- { key = 'h', mods='ctrl|shift', action = act.ActivatePaneDirection 'left' },
  --
  -- { key = 'rightarrow',mods='ctrl|shift', action = act.ActivatePaneDirection 'right' },
  -- { key = 'l',mods='ctrl|shift', action = act.ActivatePaneDirection 'right' },
  --
  -- { key = 'uparrow',mods='ctrl|shift', action = act.ActivatePaneDirection 'up' },
  -- { key = 'k',mods='ctrl|shift', action = act.ActivatePaneDirection 'up' },
  --
  -- { key = 'downarrow',mods='ctrl|shift', action = act.ActivatePaneDirection 'down' },
  -- { key = 'j',mods='ctrl|shift', action = act.ActivatePaneDirection 'down' },


}

config.key_tables = {
  resize_pane = {
    { key = 'h', action = act.AdjustPaneSize { 'Left', 1 } },

    { key = 'l', action = act.AdjustPaneSize { 'Right', 1 } },

    { key = 'k', action = act.AdjustPaneSize { 'Up', 1 } },

    { key = 'j', action = act.AdjustPaneSize { 'Down', 1 } },

    -- Cancel the mode by pressing escape
    { key = 'Escape', action = 'PopKeyTable' },

    -- Cancel the mode by pressing <C-c>
    { key = 'c', mods = 'CTRL', action = 'PopKeyTable' },
  },
  quick_select = {
    -- not possible currently: https://github.com/wezterm/wezterm/discussions/5118#discussioncomment-8694921
    -- {
    --   key = 'c',
    --   mods = 'CTRL',
    --   action = act.QuickSelectExit
    -- },
  },
  -- copy_mode = {
  --   -- {
  --   --   key = 'x',
  --   --   mods = 'LEADER',
  --   --   action = act.Multiple {
  --   --     { CopyMode = 'ScrollToBottom' },
  --   --     { CopyMode = 'Close' },
  --   --   },
  --   -- },
  --   { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
  --   {
  --     key = 'Tab',
  --     mods = 'SHIFT',
  --     action = act.CopyMode 'MoveBackwardWord',
  --   },
  --   {
  --     key = 'Enter',
  --     mods = 'NONE',
  --     action = act.CopyMode 'MoveToStartOfNextLine',
  --   },
  --   -- {
  --   --   key = 'Escape',
  --   --   mods = 'NONE',
  --   --   action = act.Multiple {
  --   --     { CopyMode = 'ScrollToBottom' },
  --   --     { CopyMode = 'Close' },
  --   --   },
  --   -- },
  --   {
  --     key = 'Space',
  --     mods = 'NONE',
  --     action = act.CopyMode { SetSelectionMode = 'Cell' },
  --   },
  --   {
  --     key = '$',
  --     mods = 'NONE',
  --     action = act.CopyMode 'MoveToEndOfLineContent',
  --   },
  --   {
  --     key = '$',
  --     mods = 'SHIFT',
  --     action = act.CopyMode 'MoveToEndOfLineContent',
  --   },
  --   { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
  --   { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
  --   { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
  --   {
  --     key = 'F',
  --     mods = 'NONE',
  --     action = act.CopyMode { JumpBackward = { prev_char = false } },
  --   },
  --   {
  --     key = 'F',
  --     mods = 'SHIFT',
  --     action = act.CopyMode { JumpBackward = { prev_char = false } },
  --   },
  --   {
  --     key = 'G',
  --     mods = 'NONE',
  --     action = act.CopyMode 'MoveToScrollbackBottom',
  --   },
  --   {
  --     key = 'G',
  --     mods = 'SHIFT',
  --     action = act.CopyMode 'MoveToScrollbackBottom',
  --   },
  --   { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
  --   {
  --     key = 'H',
  --     mods = 'SHIFT',
  --     action = act.CopyMode 'MoveToViewportTop',
  --   },
  --   {
  --     key = 'L',
  --     mods = 'NONE',
  --     action = act.CopyMode 'MoveToViewportBottom',
  --   },
  --   {
  --     key = 'L',
  --     mods = 'SHIFT',
  --     action = act.CopyMode 'MoveToViewportBottom',
  --   },
  --   {
  --     key = 'M',
  --     mods = 'NONE',
  --     action = act.CopyMode 'MoveToViewportMiddle',
  --   },
  --   {
  --     key = 'M',
  --     mods = 'SHIFT',
  --     action = act.CopyMode 'MoveToViewportMiddle',
  --   },
  --   {
  --     key = 'O',
  --     mods = 'NONE',
  --     action = act.CopyMode 'MoveToSelectionOtherEndHoriz',
  --   },
  --   {
  --     key = 'O',
  --     mods = 'SHIFT',
  --     action = act.CopyMode 'MoveToSelectionOtherEndHoriz',
  --   },
  --   {
  --     key = 'T',
  --     mods = 'NONE',
  --     action = act.CopyMode { JumpBackward = { prev_char = true } },
  --   },
  --   {
  --     key = 'T',
  --     mods = 'SHIFT',
  --     action = act.CopyMode { JumpBackward = { prev_char = true } },
  --   },
  --   {
  --     key = 'V',
  --     mods = 'NONE',
  --     action = act.CopyMode { SetSelectionMode = 'Line' },
  --   },
  --   {
  --     key = 'V',
  --     mods = 'SHIFT',
  --     action = act.CopyMode { SetSelectionMode = 'Line' },
  --   },
  --   {
  --     key = '^',
  --     mods = 'NONE',
  --     action = act.CopyMode 'MoveToStartOfLineContent',
  --   },
  --   {
  --     key = '^',
  --     mods = 'SHIFT',
  --     action = act.CopyMode 'MoveToStartOfLineContent',
  --   },
  --   { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
  --   { key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
  --   { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
  --   -- {
  --   --   key = 'c',
  --   --   mods = 'CTRL',
  --   --   action = act.Multiple {
  --   --     { CopyMode = 'ScrollToBottom' },
  --   --     { CopyMode = 'Close' },
  --   --   },
  --   -- },
  --   {
  --     key = 'd',
  --     mods = 'CTRL',
  --     action = act.CopyMode { MoveByPage = 0.5 },
  --   },
  --   {
  --     key = 'e',
  --     mods = 'NONE',
  --     action = act.CopyMode 'MoveForwardWordEnd',
  --   },
  --   {
  --     key = 'f',
  --     mods = 'NONE',
  --     action = act.CopyMode { JumpForward = { prev_char = false } },
  --   },
  --   { key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
  --   { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
  --   {
  --     key = 'g',
  --     mods = 'NONE',
  --     action = act.CopyMode 'MoveToScrollbackTop',
  --   },
  --   -- {
  --   --   key = 'g',
  --   --   mods = 'CTRL',
  --   --   action = act.Multiple {
  --   --     { CopyMode = 'ScrollToBottom' },
  --   --     { CopyMode = 'Close' },
  --   --   },
  --   -- },
  --   { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
  --   { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
  --   { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
  --   { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
  --   {
  --     key = 'm',
  --     mods = 'ALT',
  --     action = act.CopyMode 'MoveToStartOfLineContent',
  --   },
  --   {
  --     key = 'o',
  --     mods = 'NONE',
  --     action = act.CopyMode 'MoveToSelectionOtherEnd',
  --   },
  --   -- {
  --   --   key = 'q',
  --   --   mods = 'NONE',
  --   --   action = act.Multiple {
  --   --     { CopyMode = 'ScrollToBottom' },
  --   --     { CopyMode = 'Close' },
  --   --   },
  --   -- },
  --   {
  --     key = 't',
  --     mods = 'NONE',
  --     action = act.CopyMode { JumpForward = { prev_char = true } },
  --   },
  --   {
  --     key = 'u',
  --     mods = 'CTRL',
  --     action = act.CopyMode { MoveByPage = -0.5 },
  --   },
  --   {
  --     key = 'v',
  --     mods = 'NONE',
  --     action = act.CopyMode { SetSelectionMode = 'Cell' },
  --   },
  --   {
  --     key = 'v',
  --     mods = 'CTRL',
  --     action = act.CopyMode { SetSelectionMode = 'Block' },
  --   },
  --   { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
  --   {
  --     key = 'y',
  --     mods = 'NONE',
  --     action = act.Multiple {
  --       { CopyTo = 'ClipboardAndPrimarySelection' },
  --       { CopyMode = 'ScrollToBottom' },
  --       { CopyMode = 'Close' },
  --     },
  --   },
  --   { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
  --   { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
  --   {
  --     key = 'End',
  --     mods = 'NONE',
  --     action = act.CopyMode 'MoveToEndOfLineContent',
  --   },
  --   {
  --     key = 'Home',
  --     mods = 'NONE',
  --     action = act.CopyMode 'MoveToStartOfLine',
  --   },
  --   { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
  --   {
  --     key = 'LeftArrow',
  --     mods = 'ALT',
  --     action = act.CopyMode 'MoveBackwardWord',
  --   },
  --   {
  --     key = 'RightArrow',
  --     mods = 'NONE',
  --     action = act.CopyMode 'MoveRight',
  --   },
  --   {
  --     key = 'RightArrow',
  --     mods = 'ALT',
  --     action = act.CopyMode 'MoveForwardWord',
  --   },
  --   { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
  --   { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
  -- },
}

-- TODO: this is from https://github.com/wezterm/wezterm/issues/3800; looks like could be useful
-- local wezterm = require("wezterm")
-- local color = require("style.color")
-- local split = require("util.split")
-- local icon = require("asset.icon")
--
-- local function set_title_icon(title)
-- 	local title_with_icon = title
--
-- 	if string.find(title, "cmd") then
-- 		title_with_icon = icon.evil .. " " .. title
-- 	elseif string.find(title, "wsl") or string.find(title, "wslhost") then
-- 		title_with_icon = icon.wsl_icon .. " wsl"
-- 	elseif string.find(title, "nvim") then
-- 		title_with_icon = icon.vim_icon .. " neovim"
-- 	elseif string.find(title, "python") or title == string.find(title, "hiss") then
-- 		title_with_icon = icon.python_icon .. " " .. title
-- 	elseif string.find(title, "node") then
-- 		title_with_icon = icon.node_icon .. " " .. title
-- 	end
--
-- 	return title_with_icon
-- end
--
-- local function tab_title(tab_info)
-- 	local title = tab_info.tab_title
--
-- 	if title and #title > 0 then
-- 		return title
-- 	end
--
-- 	return tab_info.active_pane.title
-- end
--
-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
-- 	local background = color.primary.primary_900
-- 	local foreground = color.background.background_900
-- 	local title = tab_title(tab)
-- 	title = wezterm.truncate_right(title, max_width - 2)
-- 	local title_icon = set_title_icon(title)
--
-- 	if tab.is_active then
-- 		background = color.primary.primary_600
-- 		foreground = color.background.background_900
-- 	elseif hover then
-- 		background = color.primary.primary_700
-- 		foreground = color.background.background_900
-- 	end
--
-- 	return {
-- 		{ Attribute = { Intensity = "Bold" } },
-- 		{ Background = { Color = color.background.background_900 } },
-- 		{ Text = " " },
-- 		{ Background = { Color = color.background.background_900 } },
-- 		{ Foreground = { Color = background } },
-- 		{ Text = icon.semi_circle_left },
-- 		{ Background = { Color = background } },
-- 		{ Foreground = { Color = foreground } },
-- 		{ Text = title_icon },
-- 		{ Background = { Color = color.background.background_900 } },
-- 		{ Foreground = { Color = background } },
-- 		{ Text = icon.semi_circle_right },
-- 	}
-- end)


return config

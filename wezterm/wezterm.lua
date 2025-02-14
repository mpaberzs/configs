-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Mocha" -- or Macchiato, Frappe, Latte
config.enable_scroll_bar = true
config.scrollback_lines = 9999
config.font_size = 20
-- no ligatures
config.harfbuzz_features = { 'calt=0' }
config.enable_scroll_bar = false
-- TODO: maybe hide sometimes
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

-- local act = wezterm.action
-- config.key_tables = {
--     copy_mode = {
--       { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
--       {
--         key = 'Tab',
--         mods = 'SHIFT',
--         action = act.CopyMode 'MoveBackwardWord',
--       },
--       {
--         key = 'Enter',
--         mods = 'NONE',
--         action = act.CopyMode 'MoveToStartOfNextLine',
--       },
--       {
--         key = 'Escape',
--         mods = 'NONE',
--         action = act.Multiple {
--           { CopyMode = 'ScrollToBottom' },
--           { CopyMode = 'Close' },
--         },
--       },
--       {
--         key = 'Space',
--         mods = 'NONE',
--         action = act.CopyMode { SetSelectionMode = 'Cell' },
--       },
--       {
--         key = '$',
--         mods = 'NONE',
--         action = act.CopyMode 'MoveToEndOfLineContent',
--       },
--       {
--         key = '$',
--         mods = 'SHIFT',
--         action = act.CopyMode 'MoveToEndOfLineContent',
--       },
--       { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
--       { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
--       { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
--       {
--         key = 'F',
--         mods = 'NONE',
--         action = act.CopyMode { JumpBackward = { prev_char = false } },
--       },
--       {
--         key = 'F',
--         mods = 'SHIFT',
--         action = act.CopyMode { JumpBackward = { prev_char = false } },
--       },
--       {
--         key = 'G',
--         mods = 'NONE',
--         action = act.CopyMode 'MoveToScrollbackBottom',
--       },
--       {
--         key = 'G',
--         mods = 'SHIFT',
--         action = act.CopyMode 'MoveToScrollbackBottom',
--       },
--       { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
--       {
--         key = 'H',
--         mods = 'SHIFT',
--         action = act.CopyMode 'MoveToViewportTop',
--       },
--       {
--         key = 'L',
--         mods = 'NONE',
--         action = act.CopyMode 'MoveToViewportBottom',
--       },
--       {
--         key = 'L',
--         mods = 'SHIFT',
--         action = act.CopyMode 'MoveToViewportBottom',
--       },
--       {
--         key = 'M',
--         mods = 'NONE',
--         action = act.CopyMode 'MoveToViewportMiddle',
--       },
--       {
--         key = 'M',
--         mods = 'SHIFT',
--         action = act.CopyMode 'MoveToViewportMiddle',
--       },
--       {
--         key = 'O',
--         mods = 'NONE',
--         action = act.CopyMode 'MoveToSelectionOtherEndHoriz',
--       },
--       {
--         key = 'O',
--         mods = 'SHIFT',
--         action = act.CopyMode 'MoveToSelectionOtherEndHoriz',
--       },
--       {
--         key = 'T',
--         mods = 'NONE',
--         action = act.CopyMode { JumpBackward = { prev_char = true } },
--       },
--       {
--         key = 'T',
--         mods = 'SHIFT',
--         action = act.CopyMode { JumpBackward = { prev_char = true } },
--       },
--       {
--         key = 'V',
--         mods = 'NONE',
--         action = act.CopyMode { SetSelectionMode = 'Line' },
--       },
--       {
--         key = 'V',
--         mods = 'SHIFT',
--         action = act.CopyMode { SetSelectionMode = 'Line' },
--       },
--       {
--         key = '^',
--         mods = 'NONE',
--         action = act.CopyMode 'MoveToStartOfLineContent',
--       },
--       {
--         key = '^',
--         mods = 'SHIFT',
--         action = act.CopyMode 'MoveToStartOfLineContent',
--       },
--       { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
--       { key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
--       { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
--       {
--         key = 'c',
--         mods = 'CTRL',
--         action = act.Multiple {
--           { CopyMode = 'ScrollToBottom' },
--           { CopyMode = 'Close' },
--         },
--       },
--       {
--         key = 'd',
--         mods = 'CTRL',
--         action = act.CopyMode { MoveByPage = 0.5 },
--       },
--       {
--         key = 'e',
--         mods = 'NONE',
--         action = act.CopyMode 'MoveForwardWordEnd',
--       },
--       {
--         key = 'f',
--         mods = 'NONE',
--         action = act.CopyMode { JumpForward = { prev_char = false } },
--       },
--       { key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
--       { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
--       {
--         key = 'g',
--         mods = 'NONE',
--         action = act.CopyMode 'MoveToScrollbackTop',
--       },
--       {
--         key = 'g',
--         mods = 'CTRL',
--         action = act.Multiple {
--           { CopyMode = 'ScrollToBottom' },
--           { CopyMode = 'Close' },
--         },
--       },
--       { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
--       { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
--       { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
--       { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
--       {
--         key = 'm',
--         mods = 'ALT',
--         action = act.CopyMode 'MoveToStartOfLineContent',
--       },
--       {
--         key = 'o',
--         mods = 'NONE',
--         action = act.CopyMode 'MoveToSelectionOtherEnd',
--       },
--       {
--         key = 'q',
--         mods = 'NONE',
--         action = act.Multiple {
--           { CopyMode = 'ScrollToBottom' },
--           { CopyMode = 'Close' },
--         },
--       },
--       {
--         key = 't',
--         mods = 'NONE',
--         action = act.CopyMode { JumpForward = { prev_char = true } },
--       },
--       {
--         key = 'u',
--         mods = 'CTRL',
--         action = act.CopyMode { MoveByPage = -0.5 },
--       },
--       {
--         key = 'v',
--         mods = 'NONE',
--         action = act.CopyMode { SetSelectionMode = 'Cell' },
--       },
--       {
--         key = 'v',
--         mods = 'CTRL',
--         action = act.CopyMode { SetSelectionMode = 'Block' },
--       },
--       { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
--       {
--         key = 'y',
--         mods = 'NONE',
--         action = act.Multiple {
--           { CopyTo = 'ClipboardAndPrimarySelection' },
--           { CopyMode = 'ScrollToBottom' },
--           { CopyMode = 'Close' },
--         },
--       },
--       { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
--       { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
--       {
--         key = 'End',
--         mods = 'NONE',
--         action = act.CopyMode 'MoveToEndOfLineContent',
--       },
--       {
--         key = 'Home',
--         mods = 'NONE',
--         action = act.CopyMode 'MoveToStartOfLine',
--       },
--       { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
--       {
--         key = 'LeftArrow',
--         mods = 'ALT',
--         action = act.CopyMode 'MoveBackwardWord',
--       },
--       {
--         key = 'RightArrow',
--         mods = 'NONE',
--         action = act.CopyMode 'MoveRight',
--       },
--       {
--         key = 'RightArrow',
--         mods = 'ALT',
--         action = act.CopyMode 'MoveForwardWord',
--       },
--       { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
--       { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
--     },
--   },
-- }

-- and finally, return the configuration to wezterm
return config

function ColorMyPencils(color)
		color = color or "catppuccin"
		-- color = color or "rose-pine"
		vim.cmd.colorscheme(color)
end

ColorMyPencils()

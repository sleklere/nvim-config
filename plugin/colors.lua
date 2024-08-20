function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "Comment", { bg = "none" })
	vim.api.nvim_set_hl(0, "Special", { bg = "none" })
	vim.api.nvim_set_hl(0, "Constant", { bg = "none" })
	vim.api.nvim_set_hl(0, "PreProc", { bg = "none" })
	vim.api.nvim_set_hl(0, "Todo", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
end

ColorMyPencils()

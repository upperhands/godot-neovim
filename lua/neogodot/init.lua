local M = {}

---@param opts? NeogodotOptions
function M.setup(opts)
	require("neogodot.config").setup(opts)
	vim.print("setup neogodot")
end

return M

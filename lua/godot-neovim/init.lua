local M = {}

local file_exists = function(file_path)
	return vim.fn.filereadable(file_path) ~= 0
end

---@param opts? GdNvimOptions
function M.setup(opts)
	local is_godot_project = file_exists(vim.fn.getcwd() .. "/project.godot")
	if is_godot_project then
		require("godot-neovim.config").setup(opts)
	end
end

return M

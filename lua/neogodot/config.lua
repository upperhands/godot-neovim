--# selene: allow(mixed_table)
local M = {}

---@class NeogodotOptions
---@field lang table<string, string|string[]|table<string,string>>
M.options = {
	lang = {
		astro = "<!-- %s -->",
		xml = "<!-- %s -->",
	},
}

---@param opts? NeogodotOptions
function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M

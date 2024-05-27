local M = {}

local lsp = require("godot-neovim.lsp")
local scene = require("godot-neovim.scene")

---@class GdNvimOptions
---@field lang table<string, string|string[]|table<string,string>>
M.options = {
	godot_executable = "godot", -- path to godot executable, can be an alias in user shell
	use_default_keymaps = true, -- set to false to disable keymaps below
	keymaps = {
		GdRunMainScene = "<leader>xm", -- run main scene
		GdRunLastScene = "<leader>xl", -- run the most recently executed scene
		GdRunSelectScene = "<leader>xs", -- show all scenes, and run selected
		GdShowDocumentation = "g<C-d>",  -- open the documentation for the symbol under cursor in the editor
	},
}

local create_user_commands = function()
	local new_command = vim.api.nvim_create_user_command
	new_command(
		"GdShowDocumentation",
		lsp.gd_show_native_symbol_in_editor,
		{ desc = "Godot Show Native Symbol in Editor" }
	)

	new_command("GdRunMainScene", function()
		scene.run_main_scene(M.options.godot_executable)
	end, { desc = "Godot Run Main Scene" })

	new_command("GdRunLastScene", function()
		scene.run_last_scene(M.options.godot_executable)
	end, { desc = "Godot Run Last Scene" })

	new_command("GdRunSelectScene", function()
		scene.run_select_scene(M.options.godot_executable)
	end, { desc = "Godot Run Select Scene" })
end

local function set_keymaps()
	for k, v in pairs(M.options.keymaps) do
		vim.keymap.set("n", v, function()
			vim.cmd(k)
		end)
	end
end

---@param opts? GdNvimOptions
function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})
	create_user_commands()
	if M.options.use_default_keymaps then
		set_keymaps()
	end
end

return M

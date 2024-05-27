local M = {}

local utils = require("godot-neovim.utils")

local scene_picker = function(message)
	local scenes = utils.find_scene_files_in_current_dir()
	local options = {}
	table.insert(options, message)
	for i, v in ipairs(scenes) do
		table.insert(options, tostring(i) .. ". " .. v)
	end

	local choice = vim.fn.inputlist(options)
	if choice < 1 or choice >= #options then
		return nil
	end
	return scenes[choice]
end

M.last_run_scene = nil
function M.run_last_scene(godot_exec)
	if not M.last_run_scene then
		vim.print("\nCould not determine last executed scene")
		return
	end
	utils.new_terminal("term:run-scene")
	local ucmd = godot_exec .. " --path . " .. M.last_run_scene
	local run = '"' .. ucmd .. ' \\<CR>\\<C-\\>\\<C-N>G"'
	vim.api.nvim_feedkeys(vim.api.nvim_eval(run), "m", true)
end

function M.run_select_scene(godot_exec)
	local selected_scene = scene_picker("Select scene to run")
	if not selected_scene then
		vim.print("\nInvalid selection")
		return
	end
	M.last_run_scene = selected_scene
	M.run_last_scene(godot_exec)
end

function M.run_main_scene(godot_exec)
	M.last_run_scene = ""
	M.run_last_scene(godot_exec)
end

return M

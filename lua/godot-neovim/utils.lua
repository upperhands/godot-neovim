local M = {}

M.string = {}

M.string.split_by_whitespace = function(input)
	local result = {}
	for word in string.gmatch(input, "%S+") do
		table.insert(result, word)
	end
	return result
end

M.string.get_substring_until_character = function(input, character)
	local position = string.find(input, "%" .. character)
	if position then
		return string.sub(input, 1, position - 1)
	else
		return input
	end
end

M.string.replace_dot_with_colon = function(input)
	return string.gsub(input, "%.", ":")
end

local terminal_counter = 0
M.new_terminal = function(name)
	name = name .. tostring(terminal_counter)
	terminal_counter = terminal_counter + 1
	vim.cmd.split()
	vim.cmd.terminal()
	vim.cmd.startinsert()
	vim.api.nvim_buf_set_name(0, name)
end

-- Replace the CWD with `.` in each path
local function replace_cwd_with_dot(cwd, full_path)
	return full_path:gsub("^" .. cwd, ".")
end

M.find_scene_files_in_current_dir = function()
	local uv = vim.loop
	local function is_scene_file(name)
		return name:sub(-5) == ".tscn"
	end
	local current_dir = uv.cwd()
	local function search_dir(path, results)
		local handle = uv.fs_scandir(path)
		while handle do
			local name, type = uv.fs_scandir_next(handle)
			if not name then
				break
			end
			local full_path = path .. "/" .. name
			if type == "directory" then
				search_dir(full_path, results)
			elseif type == "file" and is_scene_file(name) then
				local relative, _ = replace_cwd_with_dot(current_dir, full_path)
				table.insert(results, relative)
			end
		end
	end
	local results = {}
	search_dir(current_dir, results)
	return results
end

return M

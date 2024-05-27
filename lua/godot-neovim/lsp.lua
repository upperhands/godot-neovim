local M = {}
local lsp_util = require("vim.lsp.util")
local utils = require("godot-neovim.utils")

--- Sends an async request to all active clients attached to the current
--- buffer.
---
---@param method (string) LSP method name
---@param params (table|nil) Parameters to send to the server
---@param handler lsp.Handler? See |lsp-handler|. Follows |lsp-handler-resolution|
---
---@return table<integer, integer> client_request_ids Map of client-id:request-id pairs
---for all successful requests.
---@return function _cancel_all_requests Function which can be used to
---cancel all the requests. You could instead
---iterate all clients and call their `cancel_request()` methods.
local function request(method, params, handler)
	vim.validate({
		method = { method, "s" },
		handler = { handler, "f", true },
	})
	return vim.lsp.buf_request(0, method, params, handler)
end

-- Gets the parameter expected by show_native_symbol_in_editor lsp method
-- by extracting the relevant information from hover results
--
-- Param formats expected by corresponding LSP method:
-- methods: "class_method:MeshInstance3D:create_convex_collision"
-- classes: "class_name:Camera2D"
-- properties: "class_property:AnimationPlayer:current_animation"
-- this can be found by observing what is being passed to goto_help function when help is used in editor
local get_param_from_hover_result = function(hover_output)
	local words = utils.string.split_by_whitespace(hover_output)
	local word_count = #words
	if words[word_count - 1] == "in" and words[word_count - 2] == "Defined" then
		return "local"
	end

	local max_check = 3
	for i = 1, max_check do
		if words[i] == "func" then
			local func_str = words[i + 1]
			func_str = utils.string.get_substring_until_character(func_str, "(")
			func_str = utils.string.replace_dot_with_colon(func_str)
			return "class_method:" .. func_str
		end
		if words[i] == "class" then
			return "class_name:" .. words[i + 1]
		end
		if words[i] == "var" then
			local var_str = words[i + 1]
			var_str = utils.string.get_substring_until_character(var_str, ":")
			var_str = utils.string.replace_dot_with_colon(var_str)
			return "class_property:" .. var_str
		end
	end
end

M.gd_show_native_symbol_in_editor = function()
	local params = lsp_util.make_position_params()
	request("textDocument/hover", params, function(err, result)
		if err then
			vim.notify("Error: " .. err.message)
			return
		end
		if result and result.contents then
			local symbol_info = result.contents.value
			if not symbol_info and #result.contents == 1 then
				symbol_info = result.contents[1]
			end
			if not symbol_info then
				return
			end
			local native_param = get_param_from_hover_result(symbol_info)
			if native_param == "local" then
				vim.notify("Symbol defined locally, use Go Definition")
			else
				request("textDocument/show_native_symbol_in_editor", { native_param }, function() end)
			end
		end
	end)
end

return M

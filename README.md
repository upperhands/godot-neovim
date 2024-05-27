# godot-neovim

Neovim plugin for godot development, extending default language server capabilities.

## Default configuration

```lua
{
	godot_executable = "godot",  -- path to godot executable, can be an alias in user shell
	use_default_keymaps = true,  -- set to false to disable keymaps below
	keymaps = {
		GdRunMainScene = "<leader>xm",  -- run main scene
		GdRunLastScene = "<leader>xl",  -- run the most recently executed scene
		GdRunSelectScene = "<leader>xs",  -- show all scenes, and run selected
		GdShowDocumentation = "g<C-d>",  -- open the documentation for the symbol under cursor in the editor
	},
}
```

- For all other LSP features, use the builtin lsp client to attach gdscript language server.
- `GdShowDocumentation` command will not work due to a bug in the engine, until [this PR](https://github.com/godotengine/godot/pull/92386) is merged.
    + If you want this now, you need to build the engine from source with the change in the PR above.

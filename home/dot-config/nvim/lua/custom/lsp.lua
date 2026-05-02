---@type table<string, vim.lsp.Config>
return {
	-- clangd = {},
	-- gopls = {},
	pyright = {},
	rust_analyzer = {},
	--
	-- Some languages (like typescript) have entire language plugins that can be useful:
	--    https://github.com/pmizio/typescript-tools.nvim
	--
	-- But for many setups, the LSP (`ts_ls`) will work just fine
	ts_ls = {},

	stylua = {}, -- Used to format Lua code
}

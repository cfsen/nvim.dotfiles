local M = {}

local maps = {
	{ '¤', '$' },
	{ 'å', '{' },
	{ 'æ', '}' },
	{ 'Å', '[' },
	{ 'Æ', ']' },
	{ 'ø', ':' },
	{ 'Ø', ';' },
}

local modes = { 'i', 'n', 'v', 'c' }

function M.apply()
	if vim.g.custom_key_remaps_enabled then
		for _, mode in ipairs(modes) do
			for _, map in ipairs(maps) do
				vim.keymap.set(mode, map[1], map[2], { noremap = true })
			end
		end
		vim.keymap.set('n', '+', '/', { noremap = true })
	else
		for _, mode in ipairs(modes) do
			for _, map in ipairs(maps) do
				pcall(vim.keymap.del, mode, map[1])
			end
		end
		pcall(vim.keymap.del, 'n', '+')
	end
end

function M.setup()
	vim.g.custom_key_remaps_enabled = true
	M.apply()
	vim.api.nvim_create_user_command('ToggleCustomKeymaps', function()
		vim.g.custom_key_remaps_enabled = not vim.g.custom_key_remaps_enabled
		M.apply()
		print('Custom key mappings ' .. (vim.g.custom_key_remaps_enabled and 'enabled' or 'disabled'))
	end, {})
end

return M

local M = {}

function M.autoindent_file()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	vim.cmd('normal! gg=G')
	vim.api.nvim_win_set_cursor(0, cursor_pos)
	vim.cmd('normal! zz')
end

return M

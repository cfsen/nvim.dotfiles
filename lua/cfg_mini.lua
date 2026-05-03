require('mini.basics').setup()
require('mini.ai').setup({ n_lines = 500 })
require('mini.icons').setup()
require('mini.files').setup({})
require('mini.statusline').setup({ use_icons = true })
require('mini.statusline').section_location = function()
    return '%2l:%-2v'
end

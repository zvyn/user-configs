local short_filename = {
    'filename',
    path = 0,
    shorting_target = 40,
}

local long_filename = {
    'filename',
    path = 3,
    shorting_target = 52,
}

require('lualine').setup {
    options = {
        theme = "onedark",
        component_separators = '',
        globalstatus = false,
    },
    tabline = {
        lualine_a = {"mode"},
        lualine_b = {'branch'},
        lualine_c = {{"buffers", show_filename_only = false}},
        lualine_x = {'tabs'},
        lualine_y = {'encoding', 'fileformat', 'filetype', 'diff', 'diagnostics'},
        lualine_z = {short_filename}
    },
    sections = {
        lualine_a = {long_filename},
        lualine_b = {'diagnostics', 'diff'},
        lualine_c = {},
        lualine_x = {'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections ={
        lualine_a = {long_filename},
        lualine_b = {'diff'},
        lualine_c = {},
        lualine_x = {'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    }
}

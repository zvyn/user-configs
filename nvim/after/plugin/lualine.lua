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
        section_separators = '',
        component_separators = '',
        globalstatus = false,
    },
    tabline = {
        lualine_a = {short_filename},
        lualine_b = {'encoding', 'fileformat', 'filetype'},
        lualine_c = {{"buffers", show_filename_only = false}},
        lualine_x = {},
        lualine_y = {'tabs'},
        lualine_z = {'branch'}
    },
    sections = {
        lualine_a = {"mode"},
        lualine_b = {'diff', 'diagnostics'},
        lualine_c = {short_filename},
        lualine_x = {},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections ={
        lualine_a = {},
        lualine_b = {'diff', 'diagnostics'},
        lualine_c = {long_filename},
        lualine_x = {},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    }
}

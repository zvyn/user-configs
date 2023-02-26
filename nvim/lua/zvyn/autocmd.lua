-- Resize buffers when window was resized:
vim.api.nvim_create_autocmd({"VimResized"}, {pattern = "*", command = "wincmd ="})

-- Show absolute numbers without focus and in INSERT mode:
vim.api.nvim_create_augroup("numbertoggle", {
    clear = true
})
vim.api.nvim_create_autocmd(
    {"BufEnter", "FocusGained" ,"InsertLeave"},
    {
        group = "numbertoggle",
        pattern = "*",
        callback = function (_)
            vim.opt.relativenumber = true
        end
    }
)
vim.api.nvim_create_autocmd(
    {"BufLeave", "FocusLost" ,"InsertEnter"},
    {
        group = "numbertoggle",
        pattern = "*",
        callback = function (_)
            vim.opt.relativenumber = false
        end
    }
)


-- Jump to last position when re-opening a file
vim.api.nvim_create_autocmd({"BufReadPost"}, {
    pattern = "*",
    -- TODO: re-write this in Lua:
    command = "if line(\"'\\\"\") > 1 && line(\"'\\\"\") <= line(\"$\") | exe \"normal! g'\\\"\" | endif"
})

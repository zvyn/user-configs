vim.g.mapleader = ","
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set(
    "n",
    "<Space>",
    ":nohlsearch<Return>",
    { silent = true }
)
-- Make shortcut to exit terminal more accessible:
vim.keymap.set("t", "<C-space>", "<C-\\><C-n>")

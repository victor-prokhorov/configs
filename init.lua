vim.diagnostic.config({
    float = {
        header = "",
        severity_sort = true
    },
    severity_sort = true,
    underline = false,
})
vim.g.fzf_preview_window = ""
vim.g.mapleader = " "
vim.g.netrw_banner = 0
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.keymap.set('n', '<leader>b', '<cmd>Buffers<cr>')
vim.keymap.set('n', '<leader>f', '<cmd>Files<cr>')
vim.keymap.set('n', '<leader>g', '<cmd>Rg<cr>')
vim.opt.expandtab = true
vim.opt.guicursor = ""
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.shiftwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.swapfile = false
vim.opt.wrap = false

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        {
            "junegunn/fzf.vim",
            dependencies = {
                {
                    "junegunn/fzf",
                    dir = "~/fzf",
                    build = "./install --all"
                }
            }
        },
        {
            "neovim/nvim-lspconfig",
            config = function()
                vim.lsp.enable("rust_analyzer")
                vim.lsp.enable("ts_ls")
                vim.api.nvim_create_autocmd("LspAttach", {
                    group = vim.api.nvim_create_augroup("LspConfig", {}),
                    callback = function(args)
                        local opts = { buffer = args.buf }
                        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
                        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                        vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)
                        local client = vim.lsp.get_client_by_id(args.data.client_id)
                        if client then
                            client.server_capabilities.semanticTokensProvider = nil
                        end
                    end
                })
            end
        }
    }
})

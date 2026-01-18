--------------------------------------------------
-- Leader
--------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--------------------------------------------------
-- Options
--------------------------------------------------
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.colorcolumn = "80"
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"
opt.backup = false
opt.swapfile = false
opt.completeopt = "menu,menuone,noselect"
opt.updatetime = 250
opt.timeoutlen = 300
opt.wildmode = "list:longest"
opt.wildignore = ".hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site"
opt.list = false
opt.listchars = "tab:^ ,nbsp:+,extends:>,precedes:<,trail:-"
opt.errorbells = false
opt.visualbell = true
opt.diffopt:append("iwhite")
opt.diffopt:append("algorithm:histogram")
opt.diffopt:append("indent-heuristic")

--------------------------------------------------
-- Keymaps
--------------------------------------------------
local map = vim.keymap.set

map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
map("n", ";", ":", { desc = "Command mode" })
map({ "n", "v", "o" }, "H", "^", { desc = "Line start" })
map({ "n", "v", "o" }, "L", "$", { desc = "Line end" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader><leader>", "<c-^>", { desc = "Toggle last buffer" })
map("n", "n", "nzz", { silent = true, desc = "Next search result" })
map("n", "N", "Nzz", { silent = true, desc = "Prev search result" })
map("n", "*", "*zz", { silent = true, desc = "Search word forward" })
map("n", "#", "#zz", { silent = true, desc = "Search word backward" })
map("n", "g*", "g*zz", { silent = true, desc = "Search word forward (partial)" })
map("n", "j", "gj", { silent = true, desc = "Down (visual line)" })
map("n", "k", "gk", { silent = true, desc = "Up (visual line)" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<leader>,", "<cmd>set invlist<cr>", { desc = "Toggle hidden chars" })
map("n", "<leader>?", "<cmd>e ~/.config/keybinds-cheatsheet.md<cr>", { desc = "Keybind cheatsheet" })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })
map("v", "J", ":m '>+1<cr>gv=gv", { silent = true, desc = "Move lines down" })
map("v", "K", ":m '<-2<cr>gv=gv", { silent = true, desc = "Move lines up" })
map("v", "p", '"_dP', { desc = "Paste (no yank)" })
map("n", "J", "mzJ`z", { desc = "Join lines" })
map("n", "<C-M-j>", "<C-e>", { desc = "Scroll down" })
map("n", "<C-M-k>", "<C-y>", { desc = "Scroll up" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("t", "jk", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

--------------------------------------------------
-- Autocmds
--------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
    group = augroup("highlight_yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

autocmd("BufReadPost", {
    group = augroup("last_position", { clear = true }),
    callback = function(ev)
        local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(ev.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            local ft = vim.bo[ev.buf].filetype
            if ft ~= "gitcommit" and ft ~= "gitrebase" then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
        end
    end,
})

autocmd("FileType", {
    group = augroup("rust_colorcolumn", { clear = true }),
    pattern = "rust",
    command = "setlocal colorcolumn=100",
})

autocmd("FileType", {
    group = augroup("text_settings", { clear = true }),
    pattern = { "text", "markdown", "gitcommit" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.wrap = true
        vim.opt_local.textwidth = 80
    end,
})

autocmd("VimResized", {
    group = augroup("resize_splits", { clear = true }),
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

autocmd("FileType", {
    group = augroup("close_with_q", { clear = true }),
    pattern = { "help", "man", "qf", "lspinfo", "checkhealth" },
    callback = function(ev)
        vim.bo[ev.buf].buflisted = false
        map("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
    end,
})

autocmd("BufRead", {
    group = augroup("cheatsheet_close", { clear = true }),
    pattern = "*keybinds-cheatsheet.md",
    callback = function(ev)
        vim.bo[ev.buf].buflisted = false
        map("n", "q", "<cmd>bdelete<cr>", { buffer = ev.buf, silent = true })
    end,
})

autocmd("BufRead", {
    group = augroup("readonly_files", { clear = true }),
    pattern = { "*.orig", "*.pacnew" },
    command = "set readonly",
})

autocmd("InsertLeave", {
    group = augroup("leave_paste", { clear = true }),
    pattern = "*",
    command = "set nopaste",
})

--------------------------------------------------
-- Lazy.nvim Bootstrap
--------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------
-- Plugins
--------------------------------------------------
require("lazy").setup({

    -- Theme
    {
        "loctvl842/monokai-pro.nvim",
        lazy = false,
        priority = 1000,
        keys = {
            { "<leader>cs", "<cmd>MonokaiProSelect<cr>", desc = "Select Monokai filter" },
        },
        config = function()
            require("monokai-pro").setup({ filter = "spectrum" })
            vim.cmd.colorscheme("monokai-pro")
        end,
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = {
            options = {
                icons_enabled = false,
                theme = "monokai-pro",
                component_separators = { left = "|", right = "|" },
                section_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch" },
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "diagnostics" },
                lualine_y = { "filetype" },
                lualine_z = { "location" },
            },
        },
    },

    -- Which-key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = { delay = 300 },
    },

    -- Tmux navigation
    { "christoomey/vim-tmux-navigator", lazy = false },

    -- Terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = {
            { "<C-`>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
            { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float terminal" },
            { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal terminal" },
            { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Vertical terminal" },
        },
        opts = {
            size = function(term)
                if term.direction == "horizontal" then return 15
                elseif term.direction == "vertical" then return vim.o.columns * 0.4 end
            end,
            open_mapping = [[<C-`>]],
            direction = "float",
            float_opts = { border = "curved" },
            on_open = function(term)
                vim.keymap.set("t", "jk", [[<C-\><C-n>]], { buffer = term.bufnr, desc = "Exit terminal mode" })
            end,
        },
    },

    -- Session
    {
        "rmagatti/auto-session",
        lazy = false,
        opts = {
            log_level = "error",
            auto_save_enabled = true,
            auto_restore_enabled = true,
            auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
        },
    },

    -- File explorer
    {
        "stevearc/oil.nvim",
        lazy = false,
        keys = {
            { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
            { "<leader>e", "<cmd>Oil<cr>", desc = "File explorer" },
        },
        opts = {
            default_file_explorer = true,
            delete_to_trash = true,
            skip_confirm_for_simple_edits = true,
            view_options = { show_hidden = true },
            keymaps = {
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-v>"] = "actions.select_vsplit",
                ["<C-s>"] = "actions.select_split",
                ["<C-h>"] = false,  -- Let vim-tmux-navigator handle this
                ["<C-l>"] = false,  -- Let vim-tmux-navigator handle this
                ["<C-t>"] = "actions.select_tab",
                ["<C-p>"] = "actions.preview",
                ["<C-c>"] = "actions.close",
                ["<C-r>"] = "actions.refresh",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["`"] = "actions.cd",
                ["~"] = "actions.tcd",
                ["gs"] = "actions.change_sort",
                ["gx"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden",
            },
        },
    },

    -- Harpoon
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon add" },
            { "<leader>h", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon menu" },
            { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon 1" },
            { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon 2" },
            { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon 3" },
            { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon 4" },
            { "<leader>5", function() require("harpoon"):list():select(5) end, desc = "Harpoon 5" },
        },
        config = function() require("harpoon"):setup() end,
    },

    -- Flash
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        keys = {
            { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash jump" },
            { "S", function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Flash treesitter" },
        },
        opts = {
            modes = { search = { enabled = false }, char = { enabled = false } },
        },
    },

    -- Mini (surround, pairs, comment)
    {
        "echasnovski/mini.nvim",
        version = false,
        event = "VeryLazy",
        config = function()
            require("mini.surround").setup({
                mappings = {
                    add = "sa", delete = "sd", find = "sf", find_left = "sF",
                    highlight = "sh", replace = "sr", update_n_lines = "sn",
                },
            })
            require("mini.pairs").setup()
            require("mini.comment").setup()
            require("mini.indentscope").setup({
                symbol = "│",
                draw = { delay = 0, animation = require("mini.indentscope").gen_animation.none() },
            })
        end,
    },

    -- FZF
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
            { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
            { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
            { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help tags" },
            { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
            { "<leader>fc", "<cmd>FzfLua git_commits<cr>", desc = "Git commits" },
            { "<leader>fs", "<cmd>FzfLua git_status<cr>", desc = "Git status" },
            { "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Diagnostics" },
            { "<leader>fo", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document symbols (outline)" },
            { "<leader>fO", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
            { "<leader>/", "<cmd>FzfLua blines<cr>", desc = "Search in buffer" },
            { "<C-p>", "<cmd>FzfLua files<cr>", desc = "Find files" },
        },
        config = function()
            require("fzf-lua").setup({
                winopts = { preview = { default = "bat" } },
                files = {
                    fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude node_modules --exclude target",
                },
                keymap = {
                    fzf = {
                        ["ctrl-q"] = "select-all+accept",
                    },
                    builtin = {
                        ["<C-j>"] = "preview-page-down",
                        ["<C-k>"] = "preview-page-up",
                    },
                },
            })
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local ok, configs = pcall(require, "nvim-treesitter.configs")
            if ok then
                configs.setup({
                    ensure_installed = {
                        "bash", "c", "cpp", "css", "html", "javascript", "json", "lua", "luadoc",
                        "markdown", "markdown_inline", "python", "query", "rust", "scss", "sql",
                        "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
                    },
                    auto_install = true,
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            end
        end,
    },

    -- LSP progress indicator
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {
            notification = {
                window = { winblend = 0 },
            },
        },
    },

    -- Mason
    { "mason-org/mason.nvim", opts = {} },

    -- Mason-lspconfig
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
        opts = {
            ensure_installed = {
                "rust_analyzer", "pyright", "ruff", "clangd", "lua_ls",
                "ts_ls", "html", "cssls", "emmet_ls", "bashls", "sqlls",
            },
            automatic_enable = true,
        },
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            vim.lsp.config("*", { capabilities = capabilities })
            vim.lsp.config("rust_analyzer", {
                settings = {
                    ["rust-analyzer"] = {
                        cargo = { allFeatures = true },
                        check = { command = "clippy" },
                        completion = {
                            addCallArgumentSnippets = true,
                            addCallParenthesis = true,
                        },
                        inlayHints = {
                            bindingModeHints = { enable = true },
                            chainingHints = { enable = true },
                            parameterHints = { enable = true },
                            typeHints = { enable = true },
                            closingBraceHints = { enable = true, minLines = 20 },
                        },
                    },
                },
            })
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = { diagnostics = { globals = { "vim" } } },
                },
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    if client and client:supports_method("textDocument/completion") then
                        vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
                    end
                    if client and client:supports_method("textDocument/inlayHint") then
                        vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
                    end

                    local function m(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
                    end
                    m("n", "K", vim.lsp.buf.hover, "Hover docs")
                    m("n", "gd", vim.lsp.buf.definition, "Go to definition")
                    m("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                    m("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
                    m("n", "gr", vim.lsp.buf.references, "Find references")
                    m("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
                    m("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
                    m("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
                    m("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
                    m("n", "<leader>d", vim.diagnostic.open_float, "Diagnostic float")
                    m("n", "gy", vim.lsp.buf.type_definition, "Type definition")
                    m("n", "<leader>th", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    end, "Toggle inlay hints")
                end,
            })

            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })
        end,
    },

    -- LSP Signature (auto show function signatures)
    {
        "ray-x/lsp_signature.nvim",
        event = "LspAttach",
        opts = {
            hint_enable = false,
            handler_opts = { border = "rounded" },
            floating_window = true,
            floating_window_above_cur_line = true,
        },
    },

    -- Conform (formatters)
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            { "<leader>cf", function() require("conform").format({ async = true }) end, desc = "Format buffer" },
        },
        opts = {
            formatters_by_ft = {
                javascript = { "prettier" }, typescript = { "prettier" },
                javascriptreact = { "prettier" }, typescriptreact = { "prettier" },
                css = { "prettier" }, scss = { "prettier" }, html = { "prettier" },
                json = { "prettier" }, yaml = { "prettier" }, markdown = { "prettier" },
                python = { "ruff_format" }, rust = { "rustfmt" },
                c = { "clang-format" }, cpp = { "clang-format" },
                lua = { "stylua" }, sh = { "shfmt" }, bash = { "shfmt" }, sql = { "sql_formatter" },
            },
            format_on_save = { timeout_ms = 500, lsp_fallback = true },
        },
    },

    -- Completion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp-signature-help",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "path" },
                }),
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            nvim_lsp_signature_help = "[Sig]",
                            path = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                experimental = { ghost_text = true },
            })
        end,
    },

    -- Gitsigns
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "+" }, change = { text = "~" }, delete = { text = "_" },
                topdelete = { text = "-" }, changedelete = { text = "~" },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local function m(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end
                m("n", "]c", function() if vim.wo.diff then return "]c" end vim.schedule(function() gs.next_hunk() end) return "<Ignore>" end, "Next hunk")
                m("n", "[c", function() if vim.wo.diff then return "[c" end vim.schedule(function() gs.prev_hunk() end) return "<Ignore>" end, "Prev hunk")
                m("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
                m("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
                m("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
                m("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")
                m("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
                m("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
                m("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
                m("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
                m("n", "<leader>gd", gs.diffthis, "Diff this")
            end,
        },
    },

    -- Lazygit
    {
        "kdheepak/lazygit.nvim",
        cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },

}, {
    install = { colorscheme = { "monokai-pro" } },
    checker = { enabled = false },
    change_detection = { notify = false },
})

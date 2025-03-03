return {
  "ibhagwan/fzf-lua",
  -- for mini.icons
  dependencies = { "echasnovski/mini.nvim" },
  config = function()
    local fzf = require("fzf-lua")
    fzf.setup({
      -- generate a fzf colorscheme based off of current neovim colorscheme
      fzf_colors = true,
      keymap = {
        builtin = {
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
        },
        fzf = {
          ["ctrl-q"] = "select-all+accept",
          ["ctrl-d"] = "preview-page-down",
          ["ctrl-u"] = "preview-page-up",
        },
      },
      oldfiles = {
        -- allows me to go back to buffers I've visited recently in the same
        -- session.
        include_current_session = true,
      },
    })

    local function fuzzy_find_motion(motion)
      return function()
        local dummy_register = "a"
        local old_content = vim.fn.getreginfo(dummy_register)
        -- yank text described by the motion to the dummy register
        vim.cmd('norm! "' .. dummy_register .. "y" .. motion)
        local selection = vim.fn.getreg(dummy_register)
        -- if I use this technique to restore registers more often, maybe it should
        -- be a decorator?
        vim.fn.setreg(dummy_register, old_content)
        fzf.live_grep_glob({ search = selection })
      end
    end

    -- seems like magic, but it works because you don't need to supply a motion if
    -- you've already selected the text that you want to search.
    local fuzzy_find_selection = fuzzy_find_motion("")

    vim.keymap.set("n", "<leader>hh", fzf.oldfiles, { desc = "[hh] Find recently opened files" })
    vim.keymap.set("n", "<leader>/", fzf.blines, { desc = "[/] Fuzzily search in current buffer" })
    vim.keymap.set("n", "<C-f>", "<leader>/", { remap = true })
    vim.keymap.set("n", "<leader>fh", fzf.helptags, { desc = "[F]ind [H]elp" })
    vim.keymap.set("n", "<leader>fw", fuzzy_find_motion("iw"), { desc = "[F]ind current [W]ord" })
    vim.keymap.set("n", "<leader>fW", fuzzy_find_motion("iW"), { desc = "[F]ind current [W]ORD" })
    vim.keymap.set("n", "<leader>fE", fuzzy_find_motion("E"), { desc = "[F]ind to [E]nd of word" })
    vim.keymap.set("x", "<leader>ff", fuzzy_find_selection, { desc = "[F]ind selection" })
    vim.keymap.set("n", "<leader>p", fzf.files, { desc = "Find [P]roject Files" })
    vim.keymap.set("n", "<leader><space>", "<leader>p", { remap = true })
    vim.keymap.set("n", "<leader>ff", fzf.live_grep_glob, { desc = "[F]ind in [f]iles (live_grep)" })
    vim.keymap.set("n", "<leader>fd", fzf.diagnostics_workspace, { desc = "[F]ind [D]iagnostics" })
    vim.keymap.set("n", "<leader>fr", fzf.resume, { desc = "[F]ind [R]resume" })
    vim.keymap.set("n", "<leader>fk", fzf.keymaps, { desc = "[F]ind [k]eymaps" })
    vim.keymap.set("n", "<leader>f/", fzf.search_history, { desc = "[F]ind in search [/] history" })
    vim.keymap.set("n", "<leader>f:", fzf.command_history, { desc = "[F]ind in command [:] history" })
    vim.keymap.set("n", '<leader>f"', fzf.registers, { desc = '[F]ind in registers ["]' })
    vim.keymap.set("n", "<leader>f`", fzf.marks, { desc = "[F]ind in marks [`]" })
    vim.keymap.set("n", "<leader>f'", "<leader>f`", { desc = "[F]ind in marks [']", remap = true })
    vim.keymap.set("n", "<leader>fc", fzf.commands, { desc = "[F]ind [C]ommands" })
    vim.keymap.set("n", "<leader>fz", fzf.builtin, { desc = "[FZ]f-lua Builtins" })
    vim.keymap.set("n", "<leader>b", fzf.buffers, { desc = "[F]ind [B]uffers" })
    vim.keymap.set("n", "<leader>fq", fzf.quickfix, { desc = "[F]ind in [Q]uickfix List" })

    -- Git
    vim.keymap.set("n", "<leader>fl", fzf.git_commits, { desc = "[F]ind in Git [l]og" })
    vim.keymap.set("n", "<leader>fL", fzf.git_bcommits, { desc = "[F]ind this buffer in Git [L]og" })
    vim.keymap.set("n", "<leader>fb", fzf.git_branches, { desc = "[F]ind [B]ranches" })
    vim.keymap.set("n", "<leader>fm", fzf.git_status, { desc = "[F]ind [m]odified files (using Git Status)" })

    vim.keymap.set("n", "z=", fzf.spell_suggest, { desc = "Spelling suggestions" })
  end,
}

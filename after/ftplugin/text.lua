-- Softwrapping .txt files just makes sense to me for writing emails and other
-- text where I want to paste it elsewhere.
vim.opt.formatoptions:remove("t")
vim.opt.linebreak = true

vim.opt.spell = true

-- for some reason the autocmd is required, calling the lua function puts my
-- cursor in the wrong place.
vim.cmd("autocmd VimEnter *.txt ZenMode")

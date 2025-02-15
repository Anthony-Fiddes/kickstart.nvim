return {
  keyword_pattern = {
    -- the newly added second group matches job names like `.cnf:example:` as
    -- `.cnf:example`
    yaml = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%([\-.\:]\w*\)*\ze\:\|\h\w*\%([\-.]\w*\)*\)]],
  },
  sources = {
    buffer = {
      name = "buffer",
      option = {
        -- use all visible buffers
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
  },
}

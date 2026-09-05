return {
  cmd = { "elixir-ls" },
  filetypes = { "elixir", "eelixir", "heex", "surface" },
  root_dir = function(bufnr, on_dir)
    local path = vim.api.nvim_buf_get_name(bufnr)
    local matches = vim.fs.find("mix.exs", { upward = true, limit = 2, path = path })
    local project, umbrella = unpack(matches)
    on_dir(vim.fs.dirname(umbrella or project))
  end,
}

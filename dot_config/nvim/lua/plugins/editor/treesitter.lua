return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    -- BufReadPre (not VeryLazy) so the FileType autocmd below is registered
    -- before the first buffer's FileType event fires.
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    config = function()
      require("nvim-treesitter").setup()

      -- Install parsers
      require("nvim-treesitter").install({
        "bash",
        "c",
        "cpp",
        "css",
        "diff",
        "go",
        "html",
        "javascript",
        "jsx",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
        "zig",
      })

      local function start(bufnr)
        if _G.is_bigfile(bufnr, "max_ts") then
          return
        end
        if pcall(vim.treesitter.start, bufnr) then
          vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end
      local group = vim.api.nvim_create_augroup("treesitter-setup", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(ev)
          start(ev.buf)
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "BigfileChanged",
        callback = function(ev)
          start(ev.data.buf)
        end,
      })

      -- The main-branch API requires explicit mappings (setup no longer creates them).
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })
      for key, query in pairs({
        af = "@function.outer",
        ["if"] = "@function.inner",
        ac = "@class.outer",
        ic = "@class.inner",
        aa = "@parameter.outer",
        ia = "@parameter.inner",
      }) do
        vim.keymap.set({ "x", "o" }, key, function()
          if not _G.is_bigfile(0, "max_ts") then
            require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
          end
        end, { desc = "Select " .. query })
      end
      for method, mappings in pairs({
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
      }) do
        for key, query in pairs(mappings) do
          vim.keymap.set({ "n", "x", "o" }, key, function()
            if not _G.is_bigfile(0, "max_ts") then
              require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
            end
          end, { desc = method .. " " .. query })
        end
      end
    end,
  },
}

return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = {
    "css",
    "eelixir",
    "elixir",
    "heex",
    "html",
    "javascript",
    "javascriptreact",
    "svelte",
    "typescript",
    "typescriptreact",
    "vue",
  },
  root_markers = {
    "tailwind.config.js",
    "tailwind.config.ts",
    "tailwind.config.cjs",
    "tailwind.config.mjs",
    "package.json",
    "mix.exs",
  },
  settings = {
    tailwindCSS = {
      includeLanguages = {
        eelixir = "html-eex",
        elixir = "phoenix-heex",
        heex = "phoenix-heex",
      },
    },
  },
}

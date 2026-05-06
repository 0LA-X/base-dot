return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local none_ls = require "none-ls"

      none_ls.setup {
        sources = {
          -- Formatters
          none_ls.builtins.formatting.stylua,
          none_ls.builtins.formatting.prettier,
          none_ls.builtins.formatting.black,
          none_ls.builtins.formatting.shfmt,
          none_ls.builtins.formatting.rustfmt,

          -- Linters (uncomment if needed)
          none_ls.builtins.diagnostics.eslint,
          none_ls.builtins.diagnostics.pylint
          -- none_ls.builtins.diagnostics.flake8,
        },
        on_attach = function(client, bufnr)
          if client.supports_method "textDocument/formatting" then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format { bufnr = bufnr }
              end,
            })
          end
        end,
      }
    end,
  },
}

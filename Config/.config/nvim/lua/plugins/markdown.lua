return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "quarto" },
  config = function()
    local ok, render = pcall(require, "render-markdown")
    if not ok then
      vim.notify("render-markdown.nvim not found!", vim.log.levels.ERROR)
      return
    end

    render.setup({
      -- 📝 Core behaviour
      enabled = true,
      preset = "none",               -- minimal defaults; clean slate
      file_types = { "markdown", "quarto" },
      render_modes = { "n", "c", "t" },
      debounce = 100,
      max_file_size = 10.0,

      -- ✨ Conceal and visibility behaviour
      anti_conceal = {
        enabled = true,
        disabled_modes = false,
        above = 0,
        below = 0,
        ignore = {
          code_background = true,
          indent = true,
          sign = true,
          virtual_lines = true,
        },
      },

      -- 🎨 Window options for rendered/unrendered states
      win_options = {
        conceallevel = { default = vim.o.conceallevel, rendered = 3 },
        concealcursor = { default = vim.o.concealcursor, rendered = "" },
      },

      -- ⚙️ Overrides for specific buftypes or filetypes
      overrides = {
        buftype = {
          nofile = {
            render_modes = true,
            padding = { highlight = "NormalFloat" },
            sign = { enabled = false },
          },
        },
      },

      -- 🌱 Treesitter injections (markdown inside other filetypes)
      injections = {
        gitcommit = {
          enabled = true,
          query = [[
            ((message) @injection.content
              (#set! injection.combined)
              (#set! injection.include-children)
              (#set! injection.language "markdown"))
          ]],
        },
      },

      -- 🔧 Logging
      log_level = "error",
      log_runtime = false,
    })

    -- 🔄 Commands for toggling rendering
    vim.api.nvim_create_user_command("RenderMarkdownToggle", function()
      vim.cmd("RenderMarkdownDisable")
      vim.defer_fn(function()
        vim.cmd("RenderMarkdownEnable")
      end, 100)
    end, { desc = "Toggle markdown rendering" })

    -- 🧭 Optional keybinding
    vim.keymap.set("n", "<leader>rm", "<cmd>RenderMarkdownToggle<CR>", {
      desc = "Toggle Markdown Rendering",
      silent = true,
    })

    -- ✅ Optional statusline integration (lightweight indicator)
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = { "*.md", "*.markdown", "*.quarto" },
      callback = function()
        vim.b.render_markdown_status = true
      end,
    })
  end,
}

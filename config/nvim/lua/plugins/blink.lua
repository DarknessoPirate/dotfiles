return {
  "saghen/blink.cmp",
  opts = {

    snippets = {
      expand = function(snippet) require("luasnip").lsp_expand(snippet) end,
    },

    completion = {
      accept = { auto_brackets = { enabled = true } },
    },

    keymap = {
      preset = "default",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<C-y>"] = { "accept", "fallback" },
    },
  },
}

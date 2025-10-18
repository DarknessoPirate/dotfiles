return {
  "saghen/blink.cmp",
  opts = {
    snippets = {
      expand = function(snippet) require("luasnip").lsp_expand(snippet) end,
    },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      menu = {
        draw = {
          components = {
            label = {
              text = function(ctx)
                -- Fix glsl_analyzer concatenated labels like "lightDirectionvec3"
                if ctx.client_name == "glsl_analyzer" then
                  local match = (ctx.label or ""):match "([%l_][%w_]*)[%u]"
                  return match or ctx.label
                end
                return ctx.label
              end,
            },
          },
        },
      },
    },
    keymap = {
      preset = "default",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<C-y>"] = { "accept", "fallback" },
    },
  },
}

if true then return {} end
return {
  {
    "nvim-java/nvim-java",
    dependencies = {
      "nvim-java/lua-async-await",
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "nvim-java/nvim-java-dap",
      "MunifTanjim/nui.nvim",
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
    },
    config = function() require("java").setup() end,
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "nvim-java/nvim-java" },
  },
  {
    "JavaHello/spring-boot.nvim",
    ft = "java",
    dependencies = { "nvim-java/nvim-java" },
    config = function() require("spring_boot").setup() end,
  },
}

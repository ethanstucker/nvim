return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			cpp = { "clang_format" },
			c = { "clang_format" },
			java = { "clang_format" },
		},
		formatters = {
			clang_format = {
				-- Point directly to the config file in your nvim directory
				prepend_args = {
					"--style=file:" .. vim.fn.stdpath("config") .. "/.clang-format",
				},
			},
			stylua = {
				prepend_args = { "--indent-type", "Tabs", "--indent-width", "4" },
			},
		},
	},
}

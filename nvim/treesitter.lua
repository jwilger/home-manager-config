require('nvim-treesitter.configs').setup({
	highlight = {
		enable = true
	},
	context = {
		enable = true,
		multiwindow = true,
		line_numbers = true,
		mode = "topline"
	},
	pairs = {
		enable = true
	},
	endwise = {
		enable = true
	},
	pyfold = {
		enable = true,
		custom_foldtext = true
	},
	textobjexts = {
		enable = true,
		lookahead = true
	},
	textsubjects = {
		enable = true
	}
})




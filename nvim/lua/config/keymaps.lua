local opt = vim.opt
local map = vim.keymap.set
local silent = { noremap = true, silent = true }

map("n", "<F2>", ToggleLineNumbers, silent)
map("n", "<F3>", ToggleRelativeLineNumbers, silent)

-- system clipboard
map("n", "<leader>Y", '"+Y', opts)
map("v", "<leader>y", '"+y', opts)

map("n", "<leader>p", '"+p', opts)
map("v", "<leader>p", '"+p', opts)

-- jump half-page up/down with cursor in middle-of-page
map("n", "<C-d>", "<C-d>zz", silent)
map("n", "<C-u>", "<C-u>zz", silent)

-- edit vimrc in a new tab
map("n", "evi", ":tabedit $MYVIMRC<CR>", silent)
-- reload vimrc
map("n", "rvi", ":source $MYVIMRC<CR>", silent)

-- tabs
map("n", "tn", ":tabnew<CR>", silent)
map("n", "te", ":tabedit ", { noremap = true })
map("n", "tc", ":tabclose<CR>", silent)
map("n", "t0", ":tabfirst<CR>", silent)
map("n", "th", ":tabprev<CR>", silent)
map("n", "tl", ":tabnext<CR>", silent)
map("n", "t$", ":tablast<CR>", silent)
map("n", "tm", ":tabmove ", { noremap = true })

-- go to tab by index
map("n", "<leader>1", "1gt", silent)
map("n", "<leader>2", "2gt", silent)
map("n", "<leader>3", "3gt", silent)
map("n", "<leader>4", "4gt", silent)
map("n", "<leader>5", "5gt", silent)

-- windows
map("n", "<leader>|", ":vsplit<CR>", silent)
map("n", "<leader>-", ":split<CR>", silent)
map("n", "<leader>h", "<C-w>h", silent)
map("n", "<leader>j", "<C-w>j", silent)
map("n", "<leader>k", "<C-w>k", silent)
map("n", "<leader>l", "<C-w>l", silent)
map("n", "<leader>c", "<C-w>c", silent)
map("n", "<leader>o", "<C-w>o", silent)

-- buffers
map("n", "n<Left>", ":topleft vnew<CR>", silent)
map("n", "n<Up>", ":topleft new<CR>", silent)
map("n", "n<Right>", ":botright vnew<CR>", silent)
map("n", "n<Down>", ":botright new<CR>", silent)
map("n", "bh", ":bprevious<CR>", silent)
map("n", "bl", ":bnext<CR>", silent)
map("n", "bc", ":bdelete<CR>", silent)

Snacks = require("snacks")
map("n", "<leader>ff", function()
	Snacks.picker.smart()
end, { desc = "Smart Find Files" })
map("n", "<leader>fb", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>fg", function()
	Snacks.picker.grep()
end, { desc = "Grep" })
map("n", "<leader>fe", function()
	Snacks.explorer()
end, { desc = "File Explorer" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }
		map("n", "gR", function()
			Snacks.picker.lsp_references()
		end, { desc = "LSP references" })
		map("n", "gd", function()
			Snacks.picker.lsp_definitions()
		end, { desc = "Goto definition" })
		map("n", "gy", function()
			Snacks.picker.lsp_type_definitions()
		end, { desc = "Goto T[y]pe definition" })
		map("n", "gi", vim.lsp.buf.implementation, { desc = "Goto implementation" })
		map("n", "<leader>m", vim.lsp.buf.rename, { desc = "Smart rename" })
		map("n", "<leader>K", vim.lsp.buf.hover, { desc = "Show documentation" })
		map("n", "<leader>D", vim.diagnostic.open_float, { desc = "Show [D]iagnoster error messages" })
	end,
})

conform = require("conform")
map({ "n", "v" }, "<leader>fw", function()
	conform.format({})
end, { desc = "Format file or range (in visual mode)" })

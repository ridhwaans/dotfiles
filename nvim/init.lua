vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options"); -- loads global functions
require("config.lazy");
require("config.keymaps");


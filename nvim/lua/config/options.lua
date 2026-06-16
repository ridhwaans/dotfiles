local opt = vim.opt

opt.compatible = false
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.cursorline = true
opt.incsearch = true
opt.hlsearch = true
opt.lazyredraw = true
opt.showmatch = true
opt.number = true
opt.relativenumber = true
opt.laststatus = 2

function _G.ToggleLineNumbers()
  vim.opt.number = not vim.opt.number:get()
end

function _G.ToggleRelativeLineNumbers()
  if vim.opt.relativenumber:get() then
    vim.opt.relativenumber = false
    vim.opt.number = true
  else
    vim.opt.relativenumber = true
    vim.opt.number = true
  end
end
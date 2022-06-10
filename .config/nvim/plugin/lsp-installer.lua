local status, lsp_installer = pcall(require, "nvim-lsp-installer")
if (not status) then return end

-- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- or if the server is already installed).
lsp_installer.setup {
  automatic_installation = true
}

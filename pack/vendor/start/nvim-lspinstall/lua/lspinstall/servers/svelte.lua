local config = require"lspinstall/util".extract_config("svelte")
config.default_config.cmd[1] = "./node_modules/.bin/svelteserver"

return vim.tbl_extend('error', config, {
  install_script = [[
  ! test -f package.json && npm init -y --scope=lspinstall || true
  npm install svelte-language-server@latest
  ]]
})

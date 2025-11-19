local function create_postgres_connection(name, env_conf)
  return {
    name = name,
    url = env_conf['db_url']
  }
end

local function create_mongodb_connection(name, env_conf)
  return {
    name = name,
    url = env_conf['db_url']
  }
end

vim.keymap.set('n', "<leader>DD", function()
  local db_list = {}
    db_list = {}

  vim.g.dbs = db_list
  vim.cmd.DBUIToggle()
end)

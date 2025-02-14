local op = require('op')
local json = require('cjson')

-- FIXME: move to common location
MyUtils = {}

function MyUtils:read_json_file(path)
  local file = io.open(path, "r")
  local json_string = file:read '*a'
  file:close()

  return json.decode(json_string)
end

function MyUtils:get_current_env_config()
  -- return read_json_file('./env.json')
  dofile(vim.fn.stdpath('config') .. '/env.lua')
  return get_config()
end
local current_env_config = MyUtils:get_current_env_config()

function get_environments()
  local envs_data = {}
  if current_env_config['client_environments_file'] then
    envs_data = MyUtils:read_json_file(current_env_config['client_environments_file'])
  end

  return envs_data
end


function create_mysql_connection(env, env_conf)
  local secret_name = string.format(current_env_config['env_secret_string_format'], env)
  return {
    name = env .. '-mysql',
    url = function()
      -- FIXME: dynamic triggering of proxies?
      local host = env_conf['mysql_host']

      local user = op.get_secret(secret_name, current_env_config['secret_mysql_user_field'])
      local password = op.get_secret(secret_name, current_env_config['secret_mysql_pass_field'])
      local db_name = env_conf['mysql_db_name'] or (current_env_config['mysql_db_prefix'] .. env)

      return "mysql://" .. user .. ":" .. password .. "@" .. host .. "/" .. db_name .. "?ssl=false"
    end
  }
end

function create_mongodb_connection(env, env_conf)
  local secret_name = 'CI:' .. env .. '_eeedo-secrets'
  return {
    name = env .. '-mongo',
    url = function()
      local host = current_env_config['mongo_host']
      local password = op.get_secret(secret_name, current_env_config['secret_mongo_pass_field'])
      --
      local db_name = env_conf['mongo_db_name'] or (current_env_config['mongo_db_prefix'] .. env)
      local auth_db_name = env_conf['mongo_auth_db_name'] or (current_env_config['mongo_db_prefix'] .. env)

      return "mongodb+srv://" .. auth_db_name .. ":" .. password .. "@" .. host .. "/" .. db_name .. "?retryWrites=true&w=majority"
    end
  }
end

vim.keymap.set("n", "<leader>DD", function()
  local db_list = {}
  if current_env_config['load_databases'] then
    db_list = {
      create_mysql_connection('martins', {
        mysql_host='host.docker.internal:3306',
        mysql_db_name='martins',
      })
    }
    for env,env_conf in pairs(get_environments())
      do
        table.insert(db_list, create_mysql_connection(env, env_conf))
        table.insert(db_list, create_mongodb_connection(env, env_conf))
        -- TODO: redis
        -- table.insert(all_dbs, create_redis_connection(env_conf))
      end
  end

  -- local db_list = {}
  -- -- FIXME: temporary approach since for now loading all takes too long time; takes first 10 records
  -- for i=1,10,1 do table.insert(db_list, all_dbs[i]) end

  vim.g.dbs = db_list
  vim.cmd.DBUIToggle()
end)

vim.keymap.set("n", "<leader>DM", function()
  local envs = get_environments()
  -- TODO: autocomplete
  local env_name = vim.fn.input('MySQL connection for: ')
  if envs[env_name] then
    vim.g.dbs = { create_mysql_connection(env_name, envs[env_name]) }
    vim.cmd.DBUIToggle()
  else
    print('"' .. env_name .. '"' .. ' environment not found')
  end
end)


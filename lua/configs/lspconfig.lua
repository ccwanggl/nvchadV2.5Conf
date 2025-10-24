require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "clangd",
  "ty",
  "neocmake",
  "rust_analyzer",
  "opencl_ls"
}
vim.lsp.enable(servers)

-- 在你的 init.lua 或配置文件中
vim.lsp.config.clangd = {
  cmd = {
    "clangd",
    "--compile-commands-dir=build", -- 假设 compile_commands.json 在项目根目录下的 build/ 文件夹内
    -- 其他 clangd 参数，例如：
    "--background-index",
    "--clang-tidy",
    "--all-scopes-completion",
    "--cross-file-rename",
    "--completion-style=detailed",
  },
  -- ... 其他配置 (on_attach, capabilities 等)
}

vim.lsp.config.neocmake = {
        default_config = {
            cmd = { "neocmakelsp", "--stdio" },
            filetypes = { "cmake" },
            root_dir = function(fname)
                return nvim_lsp.util.find_git_ancestor(fname)
            end,
            single_file_support = true,-- suggested
            on_attach = on_attach, -- on_attach is the on_attach function you defined
            init_options = {
                format = {
                    enable = true
                },
                lint = {
                    enable = true
                },
                scan_cmake_in_package = true -- default is true
            }
        }
}

vim.lsp.config.rust_analyzer = {
  -- 命令配置（默认自动检测，如需指定路径可手动设置）
  cmd = { 'rust-analyzer' },
  
  -- 文件类型关联
  filetypes = { 'rust' },
  
  -- 根目录检测（按优先级排序）
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    -- 检查是否为库文件
    local user_home = vim.fs.normalize(vim.env.HOME)
    local cargo_home = os.getenv 'CARGO_HOME' or user_home .. '/.cargo'
    local registry = cargo_home .. '/registry/src'
    
    if vim.fs.relpath(registry, fname) then
      -- 对于库文件，使用工作区根目录
      on_dir(vim.fs.root(fname, { 'Cargo.toml', '.git' }))
      return
    end
    
    -- 常规项目使用cargo metadata检测工作区
    local cargo_crate_dir = vim.fs.root(fname, { 'Cargo.toml' })
    if not cargo_crate_dir then
      on_dir(vim.fs.root(fname, { '.git' }))
      return
    end
    
    -- 调用cargo metadata获取工作区信息
    local cmd = {
      'cargo', 'metadata', '--no-deps', '--format-version', '1',
      '--manifest-path', cargo_crate_dir .. '/Cargo.toml'
    }
    
    vim.system(cmd, { text = true }, function(output)
      if output.code == 0 and output.stdout then
        local result = vim.json.decode(output.stdout)
        on_dir(result.workspace_root and vim.fs.normalize(result.workspace_root) or cargo_crate_dir)
      else
        on_dir(cargo_crate_dir)
      end
    end)
  end,
  
  -- 能力配置
  capabilities = {
    experimental = {
      serverStatusNotification = true,
    },
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
          resolveSupport = {
            properties = { 'documentation', 'detail', 'additionalTextEdits' }
          }
        }
      }
    }
  },
  
  -- rust-analyzer特定设置
  settings = {
    ['rust-analyzer'] = {
      -- 辅助功能
      assist = {
        importEnforceGranularity = true,
        importPrefix = 'by_self'
      },
      
      -- 完成设置
      completion = {
        autoimport = { enable = true },
        postfix = { enable = true }
      },
      
      -- 诊断设置
      diagnostics = {
        enable = true,
        experimental = { enable = true }
      },
      
      -- 代码操作
      cargo = {
        allFeatures = true,
        buildScripts = { enable = true }
      },
      
      -- 检查设置
      checkOnSave = {
        enable = true,
        command = 'clippy',  -- 使用clippy进行更严格的检查
        extraArgs = { '--all', '--', '-W', 'clippy::all' }
      },
      
      -- 导入设置
      imports = {
        granularity = { group = 'module' },
        prefix = 'self'
      },
      
      -- 内存使用优化
      memoryManagement = {
        threshold = 1024  -- 1GB阈值
      }
    }
  },
  
  -- 附加到缓冲区时的回调
  on_attach = function(client, bufnr)
    -- 禁用内置格式化（使用rustfmt或自定义格式化工具）
    client.server_capabilities.documentFormattingProvider = false
    
    -- 映射常用LSP命令
    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    
    -- 自定义命令：重新加载Cargo工作区
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCargoReload', function()
      local clients = vim.lsp.get_clients { bufnr = bufnr, name = 'rust_analyzer' }
      for _, c in ipairs(clients) do
        vim.notify '重新加载Cargo工作区...'
        c:request('rust-analyzer/reloadWorkspace', nil, function(err)
          if err then
            vim.notify('加载失败: ' .. tostring(err), vim.log.levels.ERROR)
          else
            vim.notify('Cargo工作区已重新加载')
          end
        end, 0)
      end
    end, { desc = '重新加载Cargo工作区' })
  end
}

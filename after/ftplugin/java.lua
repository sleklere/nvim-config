local mason = vim.fn.stdpath("data") .. "/mason"
local jdtls_bin = mason .. "/bin/jdtls"
local config_dir = mason .. "/packages/jdtls/config_linux"
local lombok = mason .. "/packages/jdtls/lombok.jar"

local util = require("lspconfig.util")
local root = util.root_pattern("gradlew", "mvnw", "pom.xml", ".git")(vim.fn.expand("%:p"))
            or vim.loop.cwd()
local ws = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. vim.fn.fnamemodify(root, ":p:h:t")

-- Mata cualquier jdtls previo para este root
for _, c in ipairs(vim.lsp.get_active_clients({ name = "jdtls" })) do
  if c.config.root_dir == root then c.stop(true) end
end

local cmd = {
  jdtls_bin,
  "-configuration", config_dir,
  "-data", ws,
  "--jvm-arg=-javaagent:" .. lombok,
  "--jvm-arg=-Xms1g",
  "--jvm-arg=-Xmx2g",
}

-- Si necesitas un JDK concreto, descomenta:
-- vim.env.JAVA_HOME = "/usr/lib/jvm/java-21-openjdk"

require("jdtls").start_or_attach({
  cmd = cmd,
  root_dir = root,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  settings = { java = {} },
})

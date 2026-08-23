local mason = vim.fn.stdpath("data") .. "/mason"
local jdtls_bin = mason .. "/bin/jdtls"
local config_dir = mason .. "/packages/jdtls/config_linux"
local lombok = mason .. "/packages/jdtls/lombok.jar"

local util = require("lspconfig.util")
local root = util.root_pattern("gradlew", "mvnw", "pom.xml", ".git")(vim.fn.expand("%:p"))
            or vim.loop.cwd()
local ws = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. vim.fn.fnamemodify(root, ":p:h:t")

local cmd = {
  jdtls_bin,
  "-configuration", config_dir,
  "-data", ws,
  "--jvm-arg=-javaagent:" .. lombok,
  "--jvm-arg=-Xms1g",
  "--jvm-arg=-Xmx2g",
}

-- jdtls exige Java 21+ para correr; el JAVA_HOME del shell puede ser menor.
-- Solo afecta al proceso del server: los proyectos siguen compilando con el
-- runtime que elijan en `settings.java.configuration.runtimes`.
local jdtls_java_home = "/usr/lib/jvm/java-21-openjdk"

require("jdtls").start_or_attach({
  cmd = cmd,
  cmd_env = { JAVA_HOME = jdtls_java_home },
  root_dir = root,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  settings = {
    java = {
      configuration = {
        runtimes = {
          { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk" },
          { name = "JavaSE-21", path = jdtls_java_home },
        },
      },
    },
  },
})

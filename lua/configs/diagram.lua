local diagram = require("diagram")

  diagram.integrations = {
    require("diagram.integrations.markdown"),
    require("diagram.integrations.neorg"),
  }

  diagram.renderer_options = {
    mermaid = {
      theme = "forest",
    },
    plantuml = {
      charset = "utf-8",
    },
    d2 = {
      theme_id = 1,
    },
    gnuplot = {
      theme = "dark",
      size = "800,600",
    },
  }

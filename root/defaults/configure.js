const fs = require('fs')

let config = JSON.parse(fs.readFileSync('/config/config.js'))
config.storage = {
  path: "/data",
  type: "file",
}
config.documents.about = "/config/about.md"

fs.writeFileSync("/config/config.js", JSON.stringify(config))

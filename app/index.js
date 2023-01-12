const express = require("express");
const path = require("path");
const app = express();

app.set("view engine", "ejs");
app.use(express.static(path.join(__dirname, "public")));

app.get("/", (req, res) => {
  res.render("index", Object.fromEntries(
    ['NODE_ENV', 'ENVIRONMENT_NAME', 'AUTHOR'].map((field) => [field, process.env[field]]),
  ));
});

app.listen(3000, () => {
  console.log("server started on port 3000");
});

process.on('SIGINT', () => process.exit());

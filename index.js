const app = require('./app.js');
const PORT = parseInt(parseInt(process.env.PORT)) || 8080;

app.listen(PORT, () =>
  console.log(`gather-town-service listening on port ${PORT}`)
);

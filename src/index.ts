import app from './app';
const PORT = (process.env.PORT && parseInt(process.env.PORT)) || 8080;

app.listen(PORT, () =>
  console.log(`gather-town-service listening on port ${PORT}`)
);

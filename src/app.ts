import 'dotenv/config'
import { Game } from '@gathertown/gather-game-client';
import express from 'express';
export const app = express();

app.use(express.json());

var game : Game;

app.post('/', async (req, res, next) => {
  try {
    game ??= new Game(process.env.SPACE_ID, () => Promise.resolve({ apiKey: process.env.API_KEY ?? 'null' }));

    if (!req.body) {
      const msg = 'no Pub/Sub message received';
      console.error(`error: ${msg}`);
      res.status(400).send(`Bad Request: ${msg}`);
      return;
    }
    if (!req.body.message) {
      const msg = 'invalid Pub/Sub message format';
      console.error(`error: ${msg}`);
      res.status(400).send(`Bad Request: ${msg}`);
      return;
    }
  
    // this is the line that actually connects to the server and starts initializing stuff
    if(!game.connected) await game.connect();
  
    // optional but helpful callback to track when the connection status changes
    game.subscribeToConnection((connected) => console.log("connected?", connected));
  
    const pubSubMessage = req.body.message;
    const name = pubSubMessage.data
      ? Buffer.from(pubSubMessage.data, 'base64').toString().trim()
      : 'World';
  
    console.log(`Hello ${name}!`);
    res.status(204).send();
  } catch (error) {
    // Passes errors into the error handler
    return next(error)
  }
  
});

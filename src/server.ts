global.WebSocket = require("isomorphic-ws");
import 'dotenv/config'
import ExpressApp from './express-app';
import { Game } from '@gathertown/gather-game-client';

const PORT = (process.env.PORT && parseInt(process.env.PORT)) || 8080;
const game = new Game(process.env.SPACE_ID, () => Promise.resolve({ apiKey: process.env.API_KEY ?? 'null' }));

const express = new ExpressApp(game, PORT);
express.listen();
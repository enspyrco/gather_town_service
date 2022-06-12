import express from 'express';
import { router as githubRoutes } from './routes/github.routes';
import { router as pubsubRoutes } from './routes/pubsub.routes';

export const app = express();

app.use(express.json());

app.use('/pubsub', pubsubRoutes);
app.use('/github', githubRoutes);

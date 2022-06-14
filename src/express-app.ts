import express from 'express';
import { Game } from '@gathertown/gather-game-client';
import PubSubRoutes from './routes/pubsub.routes';
import GitHubRoutes from './routes/github.routes';
 
class ExpressApp {
  public app: express.Application = express();
  public port: number;

  private game: Game;

  // routes
  private pubsub: PubSubRoutes;
  private github: GitHubRoutes;
 
  constructor(game: Game, port: number) {
    this.game = game;
    this.port = port;

    // create the routes
    this.pubsub = new PubSubRoutes(game);
    this.github = new GitHubRoutes(game)
 
    this.addMiddlewares();

    this.addRoutes();
  }
 
  private addMiddlewares() {
    this.app.use(express.json());
  }
 
  private addRoutes() {
    this.app.use('/', this.pubsub.router);
    this.app.use('/', this.github.router);
  }
 
  public listen() {
    this.app.listen(this.port, () => {
      console.log(`gather-town-service listening on the port ${this.port}`);
    });
  }
}
 
export default ExpressApp;
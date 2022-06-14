import { Game } from "@gathertown/gather-game-client";
import { Router, Request, Response, NextFunction } from "express";
 
class PubSubRoutes {
  public path = '/pubsub';
  public router = Router();
  private game: Game;
 
  constructor(game: Game) {
    this.game = game;
    this.intializeRoutes();
  }
 
  public intializeRoutes() {
    this.router.post(this.path, this.handlePubSubMessage);
  }

  handlePubSubMessage = async (req: Request, res: Response, next: NextFunction) => {
    try {
      
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
      if(!this.game.connected) await this.game.connect();
    
      // optional but helpful callback to track when the connection status changes
      this.game.subscribeToConnection((connected) => console.log('connected?', connected));
    
      const pubSubMessage = req.body.message;
      const name = pubSubMessage.data
        ? Buffer.from(pubSubMessage.data, 'base64').toString().trim()
        : 'World';
    
      console.log(`Hello ${name}!`);
      res.status(204).send();
    } catch (error) {
      // Passes errors into the error handler
      return next(error);
    }
  }
}
 
export default PubSubRoutes;
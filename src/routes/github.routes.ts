import { Game } from "@gathertown/gather-game-client";
import { Router, Request, Response, NextFunction } from "express";
 
class GitHubRoutes {
  public path = '/github';
  public router: Router;
  private game: Game;
 
  constructor(game: Game) {
    this.game = game;
    this.router = Router();
    this.intializeRoutes();
  }
 
  public intializeRoutes() {
    this.router.post(this.path, this.handleGitHubMessage);
  }

  handleGitHubMessage = async (req: Request, res: Response, next: NextFunction) => {
    try {
      console.log(`Body:\n ${req.body}`);
      res.status(204).send();
    } catch (error) {
      // Passes errors into the error handler
      return next(error)
    }
  }
}
 
export default GitHubRoutes;
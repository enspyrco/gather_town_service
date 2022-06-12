import { Router, Request, Response } from "express";
// import { GameLocator } from '../utils/game-locator';

const router = Router();

router.post('/', async (req: Request, res: Response, next) => {
  try {
    // const game = GameLocator.getGame();
    console.log(`Body:\n ${req.body}`);
    res.status(204).send();
  } catch (error) {
    // Passes errors into the error handler
    return next(error)
  }
});

export { router };
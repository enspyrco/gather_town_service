import { Game } from "@gathertown/gather-game-client";
import 'dotenv/config'

// The GameLocator is setup for a specific purpose - there is a single chance to set 
// the game object before the locator is used (ie. to setup the GameLocator to return
// a mock during tests).  If the GameLocator is used before the game object has been
// set, the default Game is created, et and returned.
export class GameLocator {
    private static game: Game;

    public static set(instance: Game) {
        GameLocator.game = instance;
    }

    public static getGame(): Game {
        if(GameLocator.game == null) {
            GameLocator.game = new Game(process.env.SPACE_ID, () => Promise.resolve({ apiKey: process.env.API_KEY ?? 'null' }));
        }
        return GameLocator.game;
    }
}

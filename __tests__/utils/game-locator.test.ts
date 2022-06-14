import { Game } from "@gathertown/gather-game-client";
import { instance, mock } from "ts-mockito";
import { GameLocator } from "../../src/utils/game-locator";

describe("Test game-locator.ts", () => {
  test("GameLocator sets the game", () => {
    let mockedGame:Game = mock(Game);
    let game:Game = instance(mockedGame);
    GameLocator.set(game);
    const gotGame = GameLocator.getGame();
    
    expect(gotGame).toEqual(game);
  });
});
import { Game } from "@gathertown/gather-game-client";
import request from "supertest";

import { app } from "../src/app";
import { GameLocator } from "../src/utils/game-locator";
import { mock, instance, verify, when, anything } from 'ts-mockito';

describe("Test app.ts", () => {

  test("pubsub route", async () => {
    let mockedGame:Game = mock(Game);
    let game:Game = instance(mockedGame);
    when(mockedGame.connected).thenReturn(false);
    when(mockedGame.connect()).thenResolve();
    when(mockedGame.subscribeToConnection(anything)).thenReturn(() => {});
    GameLocator.set(game);
    
    const res =  await request(app).post("/pubsub").send({message: 'message'});
    
    expect(res.body).toEqual({});
    
    verify(mockedGame.connected).called();
    verify(mockedGame.connect()).called();
    // TODO: figure out why this doesn't work - there is a task
    // verify(mockedGame.subscribeToConnection(anything)).called();
    
  });
});
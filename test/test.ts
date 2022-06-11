import { Game } from "@gathertown/gather-game-client";
import { expect } from "chai";
import 'dotenv/config'

describe('gather-client tests', () => {
  // before(function () {
    
  // });

  it('successfully connects', async () => {
      
    const game = new Game(process.env.SPACE_ID, () => Promise.resolve({ apiKey: process.env.API_KEY ?? 'null' }));

    // this is the line that actually connects to the server and starts initializing stuff
    if(!game.connected) await game.connect();
  
    // optional but helpful callback to track when the connection status changes
    game.subscribeToConnection((connected) => console.log("connected?", connected));

      //         /* detect retina */
      // expect(options.detectRetina).to.be.false; // Do I need to explain anything? It's like writing in English!

      // /* fps limit */
      // expect(options.fpsLimit).to.equal(30); // As I said 3 lines above

      // expect(options.interactivity.modes.emitters).to.be.empty; // emitters property is an array and for this test must be empty, this syntax works with strings too
      // expect(options.particles.color).to.be.an("object").to.have.property("value").to.equal("#fff"); // this is a little more complex, but still really clear
  });
});
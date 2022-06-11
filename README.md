# gather_town_service

*A node.js server on Cloud Run providing multiple ways to interact with Gather’s WebSocket API.*

## Missing files

The app & some tests use a `.env` file at the top level of the project folder, with contents:
```yml
SPACE_ID: "<random_letters>\<name_you_chose>"
API_KEY: "<its_a_secret>"
```

## Run tests

### Typescript tests

`npm run ts-test`

### Javascript tests

`npm test`

## Run & debug locally

- Set a breakpoint, eg. in `app.ts`
- Use the "run & debug server" launch config
- Open or Create a `.rest` file in the `rest-client` folder
- Hit "Send Request"
- Debugger will break at breakpoint

## Dependencies

- **express**: Web server framework.
- **mocha**: [development] Test running framework.
- **supertest**: [development] HTTP assertion test client.

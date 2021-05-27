# gather_town_service

A Dart cloud function for updating a gather.town map.

[Notes](https://docs.google.com/document/d/11kBEvSW73-Z9s5SWbjs7DQcH6-Dp6-0n595yqJf-aNs/edit?usp=sharing)


## Running locally 

<details>
  <summary>One time setup</summary>
  
  You'll need to add a file called `credentials.json` at the top level of the project, of the form: 
  ```json
  {
    "apiKey": "...",
    "spaceId": "123blahblah\\space_name",
    "mapId": "study"
  }
  ```
</details>

Run the `functions_framework_builder` in watch mode:

```sh
dart pub run build_runner watch
```

Use the `gather_town_service` *launch configuration* to run `bin/server.dart`.
- You must hit restart for changes in code to be served.

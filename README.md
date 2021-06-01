# gather_town_service

A Dart cloud function for updating a gather.town map.

[Notes](https://docs.google.com/document/d/11kBEvSW73-Z9s5SWbjs7DQcH6-Dp6-0n595yqJf-aNs/edit?usp=sharing)


## Running locally 

<details>
  <summary>One time setup</summary>
  
  You'll need to [add a secret](https://cloud.google.com/secret-manager/docs/creating-and-accessing-secrets) to the GCP SecretManager, of the form: 
  ```json
  {
    "apiKey": "...",
    "spaceId": "123blahblah\\space_name",
    "mapId": "study"
  }
  ```

  - You can get an API key [here](https://gather.town/apiKeys).  
  - The spaceId is the second half of the URL of your space, eg. 
    - For gather.town/app/1234ABCD/MySpecialSpace 
    - Use 1234ABCD\\\\MySpecialSpace (note the double back slash) 
    - the mapId can be found in the MapMaker under the "Rooms" tab (bottom right of the screen)

</details>

Run the `functions_framework_builder` in watch mode:

```sh
dart pub run build_runner watch
```

Use the `gather_town_service` *launch configuration* to run `bin/server.dart`.
- You must hit restart for changes in code to be served.

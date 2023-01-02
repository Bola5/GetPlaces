# GetPlaces

## Onboarding
## Requirements
1. Please use the last version from Xcode 13 or bigger
2. Please get the location permission to the app to get your current location, if you use the simulator please add the current location from Xcode for example "Landon".

## API Document
https://developer.tomtom.com

## Acceptance Criteria
• Shows the the places on map.
• Search for city and present the places on map.

## Description "PR description"
1. Remove the storyboard.
2. Build the core part of the app. "Network, Loading, Codable, Error".
3. Add the EndPoints.
4. Builing the map to present the places on the map with user current location, and allow the user to search for a city and present the places on the map.
5. Adding the unit tests

## Project Structure (MVVM)
The project with MVVM structure
- Models - for parsing the response on it
- DataSources(Remote and Local) - for fetch the data from network or database
- LayoutViewModels - for the map from models to be ready to use for the UI
- ViewModels - for handle the business logic
- ViewContoller - for the present the data into the UI controllers
- Unit tests

## Project Diagram
[Diagram](https://lucid.app/lucidchart/2f79dd1b-cd4c-4f80-b303-ab64ef619f95/edit?viewport_loc=-11%2C-11%2C2048%2C1203%2C0_0&invitationId=inv_81b6f980-83f1-41b3-903a-1530b7335265#)

## Video record for the app in run time
[Video](https://www.mediafire.com/file/dtlzd9c9s9bnv2z/Simulator+Screen+Recording+-+iPhone+14+Pro+-+2023-01-02+at+15.18.35.mp4/file)

## Version
1.0

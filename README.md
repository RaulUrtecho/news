# news

An Assessment project requested

## Getting Started

This project is a Flutter application.

- Unzip the project and then run the "flutter pub get" command to get the project dependencies.

## How to use
- The initial UI of the application shows a screen with a search bar at the top and a list in the rest of the body which may or may not be empty if you have saved favorite articles.

- Enter a word to search for articles about it, the application has a debounce to prevent overwhelming the api with unnecessary search requests, and a min query length of 3 characters the UI will show a loading indicator and when completing the request, show the articles.

- The search results list is automatically refreshed every 20 seconds using a timer requesting the same search.

- Select the icon on each article to save it, it will change to selected (red icon), when you delete the search query the UI will change an maintain listed all the selected favorites with local persistence.

- By deselect one favorite they will be removed from the UI and local storage.

- There is a navigation to more detailed view for an article.

## Testing 

This project is using mockito library to generate mock files (this is already included).

- At a terminal, we can run all tests contained within the test folder by entering the "flutter test" command, and see that our tests pass.
- There is an integration test with Widget testing to run it use: flutter test integration_test/app_test.dart
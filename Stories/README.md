# Stories
## Summary
This is a simple iOS application which shows lists and details of stories provided by the Wattpad API. It is a reference app to showcase how one could create a testable MVVM architecture codebase.

### Build and Run Instructions
Please open the file [Stories.xcworkspace](Stories/Stories.xcworkspace) in the Xcode app and then build and run the application.

## Architecture
The architecture for this application is MVVM (model–view–viewmodel).

### Model
The Model is what fetches, sorts, and handles all the data for this application. We use two contracts for the model;  [APIContract](Stories/Stories/Model/API/Contracts/APIContract.swift) and [StoreContract](Stories/Stories/Model/Store/Contracts/StoreContract.swift). These two contracts are protocols, which define what methods and members are needed to conform to within the model code for the application to recieve data correctly. Utilizing contracts or protocols for the model layer allows for easier refactoring and testing. We can easily switch out how our API or Store code operates, as long as it conforms to the defined contracts. We can also test easier because using a model defined from protocols makes it injectable, and therefore mockable.

### View
Views are represented by the view controllers. The view controller's responsibility is to manipulate the screen displayed on the application, and send any signals of user interaction to the view model when we need to interact with the model layer.
We also use a design system singleton, [StoriesDesign](Stories/Stories/View/DesignSystem/StoriesDesign.swift) to retrieve any UI attributes we want use for our application (colors, fonts, etc.). The singleton retrieves the attributes from a created theme, which is based from the contract [ThemeContract](Stories/Stories/View/DesignSystem/Contracts/Theme.swift). We can create new themes that conform to this contract, to easily create new designs for the application.

### ViewModel
View models are mostly defined and stored along with the view controllers themselves. Whenever a UI signal is made, we call the view model to handle any logic that must be called (populate or manipulate data, configure views, etc.). How the view model sends signals back to the view (view controller) is through the [view controller delegate contract](https://github.com/danielsinclairtill/StoriesApp/blob/d9428907bbadeddfa292546900ba837c49397086/Stories/Stories/Timeline/TimelineCollectionViewController.swift#L13). This delegate conforms to the view controllers contract protocol, which is a list of functions needed to manipulate the view from the view model.

## Testing
The tests ensure that each view controller's view model logic and interaction between the view and model layers executes as intended. Because we utilize the protocols / contracts between the view model to the model, and view model to the view, we are able to easily mock view manipulations, and mock model data during the tests.

## Third Party Sources
- [Alamofire](https://github.com/Alamofire/Alamofire): for API requests in the model layer
- [PINRemoteImage](https://github.com/pinterest/PINRemoteImage): for prefetching and downloading images
- [ViewAnimator](https://github.com/marcosgriselli/ViewAnimator): for custom animations on collection views
- [TagListView](https://github.com/ElaWorkshop/TagListView): for using a custom tags list in the story details view
- [lottie-ios](https://github.com/airbnb/lottie-ios): for json based animations

- All images were taken from https://icons8.com/animated-icons.
- All lottie animations were taken from https://lottiefiles.com/

## Tradeoffs
- With the assumptions made, the store contract is not as verbose as the API contract. If we wish to add more request types to the store (for different data types), then we need to refactor the store contract to behave similarly to the api contract instead.
- I decided to prefetch all images received once the stories timeline response is received, so the timeline has all images ready to display once the user scrolls through. This increases the amount of initial requests during the timeline refresh.
- I used placeholders and fade animations to display the stories timeline and fill images in the collection view cells. It gives a more smooth appearance to the application in my opinion, but this will also slightly delay the time it takes for the data to be shown to the user.
- It is my personal preference to manually set the views of view controllers through code, including in the app delegate.

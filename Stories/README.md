# Stories

### Versions
Below are the different implementations of the Stories app, using different technologies and coding practices to bind the architecture layers together:

[RxSwift MVVM](https://github.com/danielsinclairtill/StoriesApp/tree/master/Stories)
```
[View] <---RxSwift Observables--> [ViewModel] <-----> [Model]
```
[Delegate MVVM](https://github.com/danielsinclairtill/StoriesApp/tree/Delegate/Stories) (in progress...)
```
[View] <---delegate methods-----> [ViewModel] <-----> [Model]
```

## Summary
This is a simple iOS application which shows lists and details of stories provided by the Wattpad API. It is a reference app to showcase how one could create a testable MVVM architecture codebase.

### Build and Run Instructions
Please open the file [Stories.xcworkspace](Stories.xcworkspace) in the Xcode app and then build and run the application.

## Architecture
The architecture for this application is MVVM (model–view–viewmodel).

### Model
The Model is what fetches, sorts, and handles all the data for this application. We use two contracts for the model;  [APIContract](Stories/Model/API/Contracts/APIContract.swift) and [StoreContract](Stories/Model/Store/Contracts/StoreContract.swift). These two contracts are protocols, which define what methods and members are needed to conform to within the model code for the application to receive data correctly. Utilizing contracts or protocols for the model layer allows for easier refactoring and testing. We can easily switch out how our API or Store code operates, as long as it conforms to the defined contracts. We can also test easier because using a model defined from protocols makes it injectable, and therefore mockable.

### View
Views are represented by the view controllers. The view controller's responsibility is to manipulate the screen displayed on the application, and send any signals of user interaction to the view model when we need to interact with the model layer.
We also use a design system singleton, [StoriesDesign](Stories/View/DesignSystem/StoriesDesign.swift) to retrieve any UI attributes we want use for our application (colors, fonts, etc.). The singleton retrieves the attributes from a created theme, which is based from the contract [ThemeContract](Stories/View/DesignSystem/Contracts/Theme.swift). We can create new themes that conform to this contract, to easily create new designs for the application. We can easily switch between themes and update any design attributes in any given view by subscribing to the `StoriesDesign.shared.output.theme` observable.

### ViewModel
View models are defined and injected into the view controllers. Whenever UI signals from the view are made, we send those signals to the view model to handle any logic that must be called (populate or manipulate data, configure views, etc.). How the view model communicates with the view (view controller) is through RxSwift Observable Input and Output protocols ([example](https://github.com/danielsinclairtill/StoriesApp/blob/0e71b2a708876a23a6e5f049641a26b2653b6d50/Stories/Stories/StoryDetail/StoryDetailViewModel.swift#L30)).

## Testing
**Please run tests on simulator type: iPhone 14, OS 16.2.** 
<br>This is to avoid discrepancies made between the simulator type and the reference snapshot test images.

### View
Since the views communicate between the view models through protocols / contracts, we can easily create mock view models to populate any data and logic that we want to confirm how a specific view will display in specific states. When the mock state is set, we can utilize [snapshot testing](https://github.com/pointfreeco/swift-snapshot-testing) to ensure the view displays correctly and consistently in our tests.

### ViewModel
Because we utilize the protocols / contracts between the view model to the model, and view model to the view, we are able to easily mock view manipulations through RxSwift Observable mock events, and mock model data during the tests.

## Third Party Sources
- [RxSwift](https://github.com/ReactiveX/RxSwift): for communicating between the architectural layers of this code by Observable signals
- [Alamofire](https://github.com/Alamofire/Alamofire): for API requests in the model layer
- [SDWebImage](https://github.com/SDWebImage/SDWebImage): for prefetching and downloading images
- [ViewAnimator](https://github.com/marcosgriselli/ViewAnimator): for custom animations on collection views
- [TagListView](https://github.com/ElaWorkshop/TagListView): for using a custom tags list in the story details view
- [lottie-ios](https://github.com/airbnb/lottie-ios): for json based animations
- [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing): for snapshot testing on the views

- All images were taken from https://icons8.com/animated-icons.
- All lottie animations were taken from https://lottiefiles.com/

## Tradeoffs
- The connection made between the view and the viewmodel layer is with Observables through RxSwift, however we could improve on this in the future by using a more modern framework like Combine.
- With the assumptions made, the store contract is not as verbose as the API contract. If we wish to add more request types to the store (for different data types), then we need to refactor the store contract to behave similarly to the api contract instead.
- I decided to prefetch all images received once the stories timeline response is received, so the timeline has all images ready to display once the user scrolls through. This increases the amount of initial requests during the timeline refresh.
- I used placeholders and fade animations to display the stories timeline and fill images in the collection view cells. It gives a more smooth appearance to the application in my opinion, but this will also slightly delay the time it takes for the data to be shown to the user.
- It is my personal preference to manually set the views of view controllers through code, including in the app delegate.

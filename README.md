# Food Safety Inspector

An iOS app that helps users stay informed about food safety by browsing FDA food recalls and enforcement actions.

## Features

- **Recent Recalls List**: Display up to 60 recent food recalls with product name, recall reason, and date
- **Visual Classification Indicators**: Color-coded indicators for Class I, II, and III recalls
- **Search Functionality**: Search through recalls by product name, reason, company, or location
- **Filter by Classification**: Filter recalls by their safety classification
- **Detailed Recall Information**: Comprehensive view of each recall with distribution patterns
- **Loading States & Error Handling**: Proper user feedback for all states
- **Share Functionality**: Share recall information with others

## Architecture

This app follows **MVVM (Model-View-ViewModel)** architecture with **Combine** for reactive programming:

### Project Structure

```
Food safety inspector test/
├── Models/
│   ├── FoodRecall.swift              # Core data models and enums
│   └── FoodRecallUIModel.swift       # UI-optimized models
├── Services/
│   ├── APIService.swift              # FDA API service and error handling
│   └── SimpleResolver.swift          # Dependency injection container
├── Repositories/
│   └── FoodRecallRepository.swift    # Repository pattern implementation
├── Configuration/
│   └── APIConfiguration.swift        # API configuration constants
├── FoodRecalList/
│   ├── FoodRecallListView.swift      # Main list view
│   ├── FoodRecallListViewModel.swift # Main list view model
│   ├── RecallListView.swift          # Recall list components
│   └── SupportingViews.swift         # Loading, error, empty states
├── ContentView.swift                 # Root view
└── Food_safety_inspector_testApp.swift # App entry point
```

### Key Components

1. **Models**: 
   - `FoodRecall`: Core data model with custom JSON decoding
   - `FoodRecallUIModel`: UI-optimized model with display properties
   - `RecallClassification`: Enum for recall severity levels
   - `FDAEnforcementResponse`: API response wrapper

2. **Services**:
   - `FDAApiService`: Handles FDA API communication with proper error handling
   - `SimpleResolver`: Dependency injection container for clean architecture
   - `APIError`: Comprehensive error handling with localized descriptions

3. **Repositories**:
   - `FoodRecallRepository`: Data access layer with caching and error handling
   - `MockFoodRecallRepository`: For testing and development

4. **ViewModels**:
   - Reactive data binding with `@Published` properties
   - Combine publishers for async operations
   - Search and filter functionality
   - Loading and error state management

5. **Views**:
   - SwiftUI with modern design patterns
   - Reusable components with proper accessibility
   - Classification indicators with color coding
   - Loading states and error handling

## Technical Requirements Met

- ✅ **SwiftUI**: Modern declarative UI framework
- ✅ **MVVM Architecture**: Clean separation of concerns
- ✅ **Combine**: Reactive programming for data flow
- ✅ **iOS Human Interface Guidelines**: Native iOS design patterns
- ✅ **Error Handling**: Comprehensive error states and user feedback
- ✅ **Loading States**: Proper loading indicators
- ✅ **Clean Code**: Readable, maintainable, and well-documented

## API Integration

The app integrates with the **OpenFDA Food Enforcement API**:
- **Base URL**: `https://api.fda.gov/food/enforcement.json`
- **Rate Limits**: 240 requests/minute, 120,000/day
- **No API Key Required**: Free to use
- **Caching**: Implemented for better performance

### API Response Fields Used

- `product_description`: Description of recalled product
- `reason_for_recall`: Why the product was recalled
- `recall_initiation_date`: When recall started (format: YYYYMMDD)
- `state`: State where recall occurred
- `city`: City where recall occurred
- `recalling_firm`: Company that issued recall
- `distribution_pattern`: Geographic distribution (optional)
- `classification`: Recall classification (Class I, II, III) (optional)

### JSON Decoding

The app uses custom `CodingKeys` for proper JSON decoding without automatic snake_case conversion, ensuring reliable data mapping from the FDA API response.

## Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd "Food safety inspector test"
   ```

2. **Open in Xcode**:
   ```bash
   open "Food safety inspector test.xcodeproj"
   ```

3. **Build and Run**:
   - Select your target device or simulator
   - Press `Cmd + R` to build and run
   - The app will automatically fetch recent recalls

## Requirements

- **iOS 15.0+**
- **Xcode 14.0+**
- **Swift 5.7+**
- **Internet connection** for API calls

## Architecture Decisions

### Why MVVM?
- **Separation of Concerns**: Clear separation between UI and business logic
- **Testability**: ViewModels can be easily unit tested
- **Reusability**: ViewModels can be reused across different views
- **Maintainability**: Changes to UI don't affect business logic

### Why Combine?
- **Reactive Programming**: Automatic UI updates when data changes
- **Async Operations**: Clean handling of network requests
- **Data Flow**: Clear data flow from API → Repository → ViewModel → View
- **Error Handling**: Centralized error handling with publishers

### Why Repository Pattern?
- **Data Abstraction**: ViewModels don't need to know about API details
- **Caching**: Built-in caching for better performance
- **Testing**: Easy to mock for unit tests
- **Future Flexibility**: Easy to add local storage or other data sources

## Recent Fixes

- ✅ **JSON Decoding Issue**: Fixed key decoding strategy conflict that was preventing proper data loading
- ✅ **Optional Fields**: Properly handle optional API fields (`distribution_pattern`, `classification`)
- ✅ **Custom Decoders**: Implemented custom `init(from decoder:)` for reliable JSON parsing
- ✅ **Dependency Injection**: Added SimpleResolver for clean architecture and testability

## Known Limitations

1. **API Rate Limits**: Limited to 240 requests/minute
2. **No Offline Support**: Requires internet connection
3. **No Data Persistence**: Recalls are not stored locally
4. **Limited Search**: Search is case-insensitive but not fuzzy
5. **No Push Notifications**: Users must manually check for new recalls

## Future Enhancements

- [ ] Offline support with Core Data
- [ ] Push notifications for new recalls
- [ ] Favorites/bookmarking system
- [ ] Advanced filtering options
- [ ] Map view for geographic distribution
- [ ] Dark mode optimization
- [ ] Accessibility improvements
- [ ] Unit tests
- [ ] UI tests

## Assumptions Made

1. **API Availability**: Assumes FDA API is always available
2. **Data Format**: Assumes consistent API response format
3. **User Experience**: Prioritizes simplicity over advanced features
4. **Performance**: Assumes moderate data volume (60 recalls max)
5. **Network**: Assumes stable internet connection

## Testing

The app includes comprehensive testing support:
- `MockFoodRecallRepository` provides sample data for UI testing
- Dependency injection allows easy mocking of services
- Custom JSON decoding ensures reliable data parsing
- Error handling covers network failures and decoding errors

### Switching to Mock Data

To use mock data for testing, modify the repository registration in `SimpleResolver.swift`:

```swift
// Replace this line:
resolver.register(FoodRecallRepositoryProtocol.self) {
    FoodRecallRepository(
        apiService: resolver.resolve(APIServiceProtocol.self),
        decoder: resolver.resolve(JSONDecoder.self)
    )
}

// With this:
resolver.register(FoodRecallRepositoryProtocol.self) {
    MockFoodRecallRepository()
}
```

## Contact

For questions or issues, please contact the development team.

---

**Built with ❤️ using SwiftUI and Combine**

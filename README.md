# News App

## What?

A modern iOS news application that provides:
- Real-time news updates from reliable sources
- Offline reading capability
- User-friendly interface with modern design patterns
- Dark/Light mode support for better readability

## Why?

- **Stay Informed**: Provides quick access to latest news
- **Offline Access**: Save articles for reading without internet
- **User Experience**: Clean interface with modern iOS design patterns
- **Performance**: Efficient data handling with SwiftData
- **Reliability**: Built with error handling and offline support

## Where?

### Project Structure
- **App/**: Application entry point and main navigation
  - `MainTabView.swift`: Main tab-based navigation
  - `newsappApp.swift`: App lifecycle management

- **Core/**: Essential components and services
  - `Components/`: Reusable UI elements
  - `Models/`: Data structures and business logic
  - `Services/`: API communication and data persistence

- **Features/**: Main application features
  - `NewsFeed/`: News feed implementation
    - `View/`: UI components
    - `ViewModels/`: Business logic and state management
    - `Components/`: Feature-specific UI components
  - `SavedArticles/`: Offline reading feature
    - `View/`: Saved articles interface
    - `ViewModels/`: Saved articles management

## Features

- 📰 Real-time news feed
- 💾 Save articles for offline reading
- 🌓 Dark/Light mode support
- 📱 Responsive grid layout
- 🔄 Pull-to-refresh functionality
- ⚡️ Offline support
- 🎨 Modern UI with loading shimmer effects

## Architecture

The app follows MVVM architecture for:
- Clear separation of concerns
- Better testability
- Maintainable codebase
- Scalable feature development

## Technical Stack

- SwiftUI for modern UI development
- SwiftData for efficient data persistence
- Async/await for clean asynchronous operations
- Combine for reactive programming
- Network monitoring for offline support

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Implementation Details

### Key Components

1. **NewsService**
   - Handles API communication
   - Manages data persistence
   - Error handling

2. **NewsFeedViewModel**
   - State management
   - Business logic
   - Data transformation

3. **NetworkMonitor**
   - Internet connectivity tracking
   - Offline mode management

4. **UI Components**
   - Shimmer loading effects
   - Grid-based news feed
   - Adaptive layout


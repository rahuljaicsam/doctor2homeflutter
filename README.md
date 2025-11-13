# Doctor2Home App

A comprehensive doctor delivery app with OpenStreetMap integration, active bookings with live tracking, and complete booking history.

## Features

✅ **Home Screen** - Doctor listings, quick actions, and navigation
✅ **Map Integration** - OpenStreetMap with live doctor locations
✅ **Active Bookings** - Real-time tracking, call buttons, ETA, cancellation
✅ **Booking History** - Complete consultation records with photos and reviews
✅ **Profile Management** - User profile and settings

## Fixed Issues

### FontManifest.json 404 Error ✅
- ✅ Added proper assets configuration in `pubspec.yaml`
- ✅ Created assets directories (`assets/images/`, `assets/icons/`)
- ✅ Added `FontManifest.json` in `web/assets/` directory
- ✅ Removed custom font dependencies to prevent loading errors

### Navigation Issues ✅
- ✅ All bottom navigation tabs are functional
- ✅ Proper route configuration for all screens
- ✅ Provider integration working correctly
- ✅ **Single App Bar** - No duplicate titles across screens

### Performance Optimizations ✅
- ✅ Added `flutter_map_cancellable_tile_provider` for better web performance
- ✅ Updated all map TileLayers to use cancellable tile provider
- ✅ Eliminated flutter_map performance warnings
- ✅ **Persistent Bottom Navigation** - Navigation bar stays visible across all screens

## Technical Implementation

### Persistent Navigation Architecture
- **Main Shell**: `HomeScreen` contains persistent bottom navigation
- **Tab Content**: Each tab shows different screen content without navigation
- **State Management**: Single state manages active tab across entire app
- **No Screen Stacking**: Content switches instead of pushing new screens

### App Bar Management
- **Centralized App Bar**: Main container handles all app bar titles
- **Dynamic Titles**: App bar updates based on selected tab
- **Clean UI**: No duplicate or conflicting app bars

### Screen Structure
1. **HomeScreen** (Main Container)
   - Contains persistent `BottomNavigationBar`
   - Switches between 5 different content areas
   - Manages global app state

2. **Individual Tab Screens**
   - **_HomeTab**: Dashboard with quick actions and doctor listings
   - **MapScreen**: Full-screen map with doctor locations
   - **ActiveBookingsScreen**: Live booking tracking and management
   - **BookingHistoryScreen**: Complete consultation history
   - **ProfileScreen**: User settings and account management

## Running the App

```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Run on web
flutter run -d chrome --web-port 8081

# Or build for web
flutter build web --web-port 8081
```

## App URL
**`http://localhost:8081`**

## Navigation

1. **Home** (🏠) - Main dashboard with doctor listings
2. **Map** (🗺️) - Live map with doctor locations  
3. **Bookings** (📅) - Active appointments with tracking
4. **History** (📚) - Past consultations with full details
5. **Profile** (👤) - ✅ **User profile, settings, and account management**

## Sample Data

The app includes comprehensive mock data for demonstration:
- **3 Completed Consultations** with photos and reviews
- **1 Cancelled Appointment** showing cancellation details
- **1 Active Booking** for live tracking demonstration
- **Multiple Available Doctors** on the map

## Technical Stack

- **Flutter** 3.0+ with Provider state management
- **OpenStreetMap** integration via flutter_map
- **Mock Data** for complete functionality demonstration
- **Responsive Design** optimized for web and mobile

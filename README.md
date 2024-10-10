# Wallpaper Favorites Flutter and Node 
### (DP Education Project 14)

A Flutter app to save, view, and set wallpapers as favorites. The app interacts with a Node.js backend that handles wallpaper storage and management.
![APP](https://github.com/HGSChandeepa/WallFit/blob/main/app(1).png)


## Features

### Flutter App
- Display a list of favorite wallpapers.
- Set wallpapers as home or lock screen using `async_wallpaper`.
- Remove wallpapers from favorites.

### Node.js Server
- REST API for managing favorite wallpapers.
- MongoDB for storage.

## Getting Started

### Flutter App

#### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android/iOS emulator or physical device.

#### Setup

1. Clone the repo:
    ```bash
    git clone https://github.com/your-username/wallpaper-favorites-app.git
    cd wallpaper-favorites-app
    flutter pub get
    flutter run
    ```

### Node.js Server

#### Setup

1. Install dependencies:
    ```bash
    npm install
    ```

2. Start the server:
    ```bash
    npm start
    ```

API Endpoints:
- **GET** `/api/favorites`: Fetch all favorite wallpapers.
- **POST** `/api/favorites`: Add a favorite wallpaper.
- **DELETE** `/api/favorites/:id`: Remove a favorite wallpaper.

## License

MIT License

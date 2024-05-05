<div align="center">
    <img src="https://lh3.googleusercontent.com/u/0/drive-viewer/AKGpihbvl-h8Si4l41ept7S-_DRZ297DXYPHCJwtQhVVQn6Q27RuktAV1wCmzBfKFin4namUSndJqOOhVVM7T7TgQXdlF-qFTB1R3w=w2864-h1586-rw-v1" alt="alt text" width="150" height="150" title="Optional title">
</div>

# 🛍️ Getir Lite App

## Overview
Welcome to the Getir Lite Shopping App, a simple and efficient application designed to enhance your online shopping experience 🚀. Inspired by the user-friendly interface of the Getir app, this project demonstrates a custom mobile shopping application using modern development techniques and architectural approaches in iOS development.

## Setup
### Prerequisites
- Xcode 15.x 🛠️
- Swift 5.x 🐦
- iOS 13.x or ⬆️

### Installation
1. Clone the repository to your local machine:
```bash
git clone https://github.com/erkutter/GetirLiteApp.git
```
2. Open the `.xcodeproj` file in Xcode.
3. Build and run the application on your simulator or real device 📱.

## Architecture - VIPER
<img src="https://github.com/erkutter/GetirLiteApp/assets/92941500/3a843f18-3b98-4cb3-86e4-f1c7bc840799" alt="Screenshot 2" width="600">

This application employs the VIPER architecture to ensure clean separation of concerns and enhance maintainability. VIPER modules are used to encapsulate functionality related to different aspects of the app, such as Product Listing, Product Details, and Shopping Cart.

## Key Features
- **Product Listing**: Users can discover, add, remove products.
- **Product Details**: User can see detailed information about each product can be accessed, including image, name, price, and description.
- **Shopping Cart**: Users can add or remove products, view their cart, and proceed to checkout with a success message displaying the total amount.
- **Quick Overview**<div align="left">
    <img src="https://github.com/erkutter/GetirLiteApp/assets/92941500/d50fd4cf-0c53-4983-8694-779f1ff9986e" alt="App Demo" width="250" height="450">
</div>


## Technical Details
- **Compositional Layout**: Used to create flexible and complex layouts for the product lists 🌐.
- **No Storyboards or Xibs**: All UI components are built programmatically to enhance control over the UI and reduce merge conflicts ⛔️🖌️.
- **Asynchronous Data Fetching**: Ensures a smooth and responsive user experience ⚡.

## Packages Used
- **Alamofire** `5.9.1`: For network requests.
- **Kingfisher** `7.11.0`: For image downloading and caching.
- **RealmSwift** `14.5.2`: For local database management.
- **SkeletonView** `1.31.0`: For elegant loading animations.
- **SnapKit** `5.71`: For declarative Swift autolayout.

## Project Structure
- `/Modules`: Contains all the VIPER modules.
- `/Services`: For network services and data managers.
- `/Resources`: Includes utilities, extensions, and shared components.

## Design
Follow the Figma designs provided by the Getir. 🎨.

<div align="center">
        <img src="https://github.com/erkutter/GetirLiteApp/assets/92941500/9fb4c59a-96a4-4d9a-bdf8-1fcadce1af3b" alt="Screenshot 2" width="300">
    <img src="https://github.com/erkutter/GetirLiteApp/assets/92941500/17ec8850-ea28-49a2-bf08-bdf72820a6f4" alt="Screenshot 1" width="300">
    <img src="https://github.com/erkutter/GetirLiteApp/assets/92941500/d4f02372-8c9d-471a-bd07-92f57cf1810e" alt="Screenshot 3" width="300">
</div>
    <div align="center">
             <img src="https://github.com/erkutter/GetirLiteApp/assets/92941500/8ef98d77-a5f3-40f9-a7ba-df6a55a49264" alt="Screenshot 2" width="300">
            <img src="https://github.com/erkutter/GetirLiteApp/assets/92941500/8140c09b-bc77-4356-8735-ae69d2caa5cd" alt="Screenshot 6" width="300">
    <img src="https://github.com/erkutter/GetirLiteApp/assets/92941500/7586d89f-ed94-4071-b684-aaef58d114ab" alt="Screenshot 2" width="300">
</div>



## Running Tests
Tests are included to demonstrate testing strategies. 🧪.

## Contribution
This project is intended as a demonstration of professional iOS development practices. Contributions are welcome via pull requests to the main branch 💬.

## Authors
- Erkut Ter 📝

## License
This project is licensed by Getir and Patika

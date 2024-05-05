<div align="center">
    <img src="https://lh3.googleusercontent.com/u/0/drive-viewer/AKGpihbvl-h8Si4l41ept7S-_DRZ297DXYPHCJwtQhVVQn6Q27RuktAV1wCmzBfKFin4namUSndJqOOhVVM7T7TgQXdlF-qFTB1R3w=w2864-h1586-rw-v1" alt="alt text" width="150" height="150" title="Optional title">
</div>



# 🛍️ Getir Lite App

<div align="center">
    <img src="https://github.com/erkutter/finalcase-getirbootcamp/assets/92941500/beb04add-370b-446d-ab24-09daaa4a7685" alt="Screenshot 6" width="170">
    <img src="https://github.com/erkutter/finalcase-getirbootcamp/assets/92941500/ac650cd2-d976-4d1b-b0b4-d0a13296d241" alt="Screenshot 1" width="170">
      <img src="https://github.com/erkutter/finalcase-getirbootcamp/assets/92941500/2e8ca3d5-3fef-4b6e-b6e2-3a8f3ec00665" alt="Screenshot 3" width="170">
    <img src="https://github.com/erkutter/finalcase-getirbootcamp/assets/92941500/4f0bce49-fafc-4747-adfe-4eeece4e732b" alt="Screenshot 2" width="170">
</div>

## Overview
Welcome to the Getir Lite Shopping App, a simple and efficient application designed to enhance your online shopping experience 🚀. Inspired by the user-friendly interface of the Getir app, this project demonstrates a custom mobile shopping application using modern development techniques and architectural approaches in iOS development.

## Setup
### Prerequisites
- Xcode 15.x 🛠️
- Swift 5.x 🐦

### Installation
1. Clone the repository to your local machine:
2. Open the `.xcodeproj` file in Xcode.
3. Build and run the application on your simulator or real device 📱.

## Architecture
This application employs the VIPER architecture 🏛️ to ensure clean separation of concerns and enhance maintainability. VIPER modules are used to encapsulate functionality related to different aspects of the app, such as Product Listing, Product Details, and Shopping Cart.

## Key Features
- **Product Listing**: Products are fetched from a mock API and displayed in both horizontal and vertical scrollable lists.
- **Product Details**: Detailed information about each product can be accessed, including image, name, price, and description.
- **Shopping Cart**: Users can add or remove products, view their cart, and proceed to checkout with a success message displaying the total amount.

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
- `/Common`: Includes utilities, extensions, and shared components.

## Design
Follow the Figma designs provided by the Getir. 🎨.
<div align="left">
    <img src="https://github.com/erkutter/finalcase-getirbootcamp/assets/92941500/8c80d44f-17a5-40dd-b5cb-440f06972d1a" alt="App Demo" width="250" height="450">
</div>

## Running Tests
Unit tests are included to demonstrate testing strategies. Execute the tests via the Xcode Test navigator 🧪.

## Contribution
This project is intended as a demonstration of professional iOS development practices. Contributions are welcome via pull requests to the main branch 💬.

## Authors
- Erkut Ter 📝

## License
This project is licensed by Getir and Patika

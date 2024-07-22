# chats

#### Video Demo: <https://youtu.be/9PBRM2RmRGk>

#### Description

The Chats Project is a comprehensive mobile chat application solution developed as part of the CS50x final project. This project leverages the power of Flutter for the frontend, integrating with Firebase for backend services, and implements the BLoC (Business Logic Component) pattern to manage state efficiently.

### Features

- **Authentication**: User registration, login, and account management.
- **Chat Functionality**: Real-time messaging, chat rooms, and contacts management.
- **User Profiles**: View and edit user profiles.
- **Theming**: Support for both dark and light themes.

### Project Structure

#### Data Layer

- **Models**: Define the data structures for users, chats, and messages. These models ensure a structured format for handling data throughout the application.
  - `auth_user_model.dart`: Represents user authentication details.
  - `chat_message_model.dart`: Represents individual chat messages.
  - `chat_model.dart`: Represents a chat conversation.
  - `user_model.dart`: Represents user profile information.

- **Providers**: Manage the interactions with data sources, including authentication, chat, and user data. Providers act as an intermediary between the app and the backend services.
  - `auth_provider.dart`: Handles authentication-related operations such as login, signup, and logout.
  - `chat_provider.dart`: Manages chat-related data transactions.
  - `user_provider.dart`: Deals with user profile data interactions.

- **Repositories**: Abstract data handling and provide a clean API for the rest of the app. Repositories encapsulate the logic for accessing data sources, ensuring a clean separation of concerns.
  - `auth_repository.dart`: Implements authentication logic.
  - `chat_repository.dart`: Manages chat data.
  - `user_repository.dart`: Handles user profile data.

#### Logic Layer

- **BLoC/Cubit**: Handle the business logic for authentication, chat, and user-related operations. The BLoC (Business Logic Component) pattern and Cubit are used to manage state and business logic.
  - `auth_bloc.dart`, `signin_cubit.dart`, `signup_cubit.dart`: Manage the authentication processes.
  - `chat_bloc.dart`: Oversees the state and events related to chat functionality.
  - `profile_cubit.dart`, `user_cubit.dart`, `users_cubit.dart`: Manage user profile state and operations.

- **Utilities**: Provide helper functions and consistent ID generation, facilitating various operations across the application.
  - `consistent_id_generator.dart`: Generates unique identifiers for entities.
  - `utils.dart`: General utility functions used throughout the app.

#### Presentation Layer

- **Components**: Reusable UI elements like buttons, text fields, and tiles, ensuring a consistent and modular design.
  - `app_button.dart`: Custom button widget.
  - `app_drawer.dart`: Custom drawer widget.
  - `app_textfield.dart`: Custom text field widget.
  - `message_tile.dart`, `user_tile.dart`: Widgets for displaying messages and user information in lists.

- **Pages**: Individual screens for different parts of the application, such as login, registration, chat, and profile pages.
  - **Authentication Pages**:
    - `login_page.dart`: Screen for user login.
    - `register_page.dart`: Screen for user registration.
    - `account_page.dart`: Screen for managing account settings.
  - **Chat Pages**:
    - `chat_page.dart`: Screen displaying individual chat conversations.
    - `contacts_page.dart`: Screen for managing contacts.
    - `home_page.dart`: Main screen displaying recent chats and contacts.
  - **User Pages**:
    - `profile_page.dart`: Screen displaying user profile information.
    - `user_profile_pages.dart`: Screen for viewing and editing user profiles.
  - **App Pages**:
    - `splash_screen.dart`: Initial loading screen.
    - `settings_page.dart`: Screen for application settings.
    - `app_pages.dart`: Aggregator for the main application pages.

- **Router**: Manages the navigation within the app.
  - `router.dart`: Defines the routing logic, ensuring smooth navigation between different screens.

- **Themes**: Configurations for dark and light mode themes.
  - `dark_mode.dart`: Definitions for dark theme styling.
  - `light_mode.dart`: Definitions for light theme styling.
  - `themes.dart`: Central theme management.

### Dependencies

The project utilizes several dependencies to enhance functionality:

- **flutter**: The SDK for building Flutter applications.
- **cupertino_icons**: Provides Cupertino styled icons.
- **firebase_core**: Connects the app to Firebase, enabling backend services.
- **firebase_auth**: Handles authentication using Firebase, supporting login, registration, and user management.
- **cloud_firestore**: Enables access to Firestore, Firebase's NoSQL database, for storing and retrieving chat data.
- **equatable**: Simplifies equality comparisons in Dart objects, crucial for state management.
- **bloc**: Implements the BLoC pattern for state management, ensuring a clear separation between UI and business logic.
- **flutter_bloc**: Integrates BLoC with Flutter, making it easier to manage state within the Flutter app.
- **firebase_storage**: Manages file storage using Firebase, allowing users to upload and download files.
- **crypto**: Provides cryptographic functions, ensuring data security.
- **intl**: Supports internationalization and localization, making the app accessible to a wider audience.
- **image_picker**: Allows image selection from the device library or camera, used in profile and chat functionalities.
- **uuid**: Generates unique identifiers, used for creating unique user IDs, message IDs, etc.
- **mime**: Handles MIME type definitions, useful for file handling.
- **path**: Provides utilities for manipulating file paths, ensuring correct file handling across different platforms.

### Getting Started

To get started with the Flutter Chat Application, follow these steps:

1. **Clone the repository**:

    ```bash
    git clone <repository-url>
    cd <repository-directory>
    ```

2. **Install dependencies**:

    ```bash
    flutter pub get
    ```

3. **Set up Firebase**:
    - Follow the Firebase setup guide for Flutter and configure the `firebase_options.dart` file with your Firebase project details.

4. **Run the application**:

    ```bash
    flutter run
    ```

### Configuration

The `pubspec.yaml` file manages the project's dependencies and assets. Ensure all required plugins and packages are correctly listed and updated.

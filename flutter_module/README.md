## [Getting Started](https://docs.flutter.dev/get-started/install)
- Flutter (Channel stable, 3.24.1)
- Dart 3.5.1
- Cocoapods 1.15.2
- Xcode 15

### Usage
#### Archive
```
flutter build ios-framework --output=archive/ --cocoapods [--no-profile] [--no-debug]
## AND ##
flutter build aar --output PATH_TO_NATIVE_ANDOIRD_PROJECT/your_project_name/module/android
```

#### Re-create Module
```
flutter create -t module .
```

#### Dependency Installation
```
Make sure `flutter pub get` before you run the app.
```
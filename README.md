# Grandview School mobile app

Flutter student application with MVC separation and GetX state management.

## Project structure

```text
lib/
  main.dart                    Application entry point
  app.dart                     GetMaterialApp composition
  controllers/                 GetX application state and async actions
  models/                      Domain data (StudentAccount)
  services/                    HTTP/session access and notification storage
  core/theme/                  AppColors palette and AppTheme configuration
  routes/                      Named route mapping and transitions
  views/                       Auth, dashboard, settings, student, notifications
    workflows/                 Attendance, payments, grades, classes, reports
  widgets/
    public/                    Independently importable reusable widgets
    private/                   Feature implementation widgets and painters
test/                          Screen regressions and controller tests
```

Controllers own login, dashboard loading, notification read state, theme
persistence, attendance submission, and payment requests. Services handle API
transport and storage. Views render controller state with `Obx` and retain local
presentation state such as form fields, animation controllers, and selected tabs.
Controllers are disposed with their owning screen; the theme controller is
registered in GetX at app startup. Async controllers ignore state updates after
disposal.

Feature views and private widgets use Dart `part` libraries to preserve existing
private helper access while splitting the former large files. A private directory
alone does not enforce Dart privacy: underscore-prefixed declarations and their
owning library do. Public widgets are normal Dart libraries and can be imported
directly. Workflow data/language scopes remain read-only presentation adapters.

## Customize app colors

Edit `lib/core/theme/app_colors.dart`. The primary palette is `primaryDark`,
`primary`, `primaryLight`, and `primaryAccent`; `defaultGradient` uses these values.
`scaffoldBackground`, `inputBorder`, `inputFocusBorder`, `buttonStart`, and
`buttonEnd` configure shared surfaces and controls. Additional existing colors
remain centralized as `color...` constants to preserve screen appearance.

The five user-selectable palettes are defined by `AppColors.gradient`.
`ThemeController` persists the choice under `app.theme`, including migration of
older theme names. `AppTheme.build` defines Material typography and input styles.

## Run and validate

Use Flutter 3.47.2 / Dart 3.13.2 or a compatible SDK satisfying `pubspec.yaml`.

```sh
flutter pub get
flutter run --dart-define=API_BASE_URL=https://your-school.example/api.php
flutter analyze
flutter test
flutter build web
flutter pub outdated
```

Without `API_BASE_URL`, the API uses localhost on web and the Android emulator's
host address on mobile. Camera, biometric authentication, and receipt selection
also need validation on real Android/iOS devices with a running school backend.

Dependencies are locked in `pubspec.lock`. Direct constraints reflect the tested
stable versions; avoid overriding Flutter's constrained transitive packages.

## Cleanup

Removed the unused prototype/reference UI, alternate demo app, unreachable
widgets, old notification mock screen, browser test profiles, and test screenshots.
Independent `.reference*` source archives are retained because they contain
pre-existing local changes; they are excluded from application analysis. Native
platform folders remain for supported Flutter build targets.

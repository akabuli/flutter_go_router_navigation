<!-- .github/copilot-instructions.md: Project-specific guidance for AI coding assistants -->

# Copilot instructions (concise)

This repo is a standard Flutter multi-platform app (mobile, web, desktop) scaffolded from the Flutter template. The guidance below focuses on what an AI assistant needs to be immediately productive and avoid common mistakes.

- Entry point: `lib/main.dart` — small default counter app. Modify here for UI/logic changes. Example: adding a new screen should add a Widget under `lib/` and update `MaterialApp.home` or routes.
- Dependencies: `pubspec.yaml` (SDK: ^3.8.1). After editing dependencies run `flutter pub get`.
- Lints: `analysis_options.yaml` is enabled; follow `flutter_lints` rules used in the project.

Important project boundaries and generated files

- Do NOT modify files under `build/` or platform-generated registrants (e.g. `android/`, `ios/Runner/GeneratedPluginRegistrant.*`, `linux/flutter/generated_plugin_registrant.*`). Those are generated during build or plugin registration.
- Platform code lives under `android/`, `ios/`, `linux/`, `macos/`, `windows/`, and `web/` — only change when implementing native platform integrations.

Developer workflows (commands and examples)

- Fetch deps: `flutter pub get`
- Run app (device): `flutter run` or `flutter run -d <device-id>`
- Hot reload while developing: save files (or press `r` in terminal started by `flutter run`). Use hot restart (`R`) to reset state.
- Build release artifacts: `flutter build apk` (Android), `flutter build ios`, `flutter build web`, `flutter build windows` etc.
- Tests: `flutter test` runs unit/widget tests (see `test/widget_test.dart`).

Patterns & conventions observed in this repo

- Small single-screen app in `lib/main.dart`. Prefer adding new Widgets under `lib/` in feature folders (e.g. `lib/screens/`, `lib/widgets/`) rather than editing many platform files.
- Keep UI logic in Widgets; stateful UI uses `State` objects (see `_MyHomePageState` in `lib/main.dart`). Follow the existing simple separation.

Safety and style notes for automated edits

- Always run `dart format` (or `flutter format .`) after edits.
- Preserve package versions and the `publish_to: 'none'` setting unless the user explicitly wants to publish.
- If adding native platform code, add clear TODO comments and document why the platform change is required.

Where to look for examples

- Default app entry: `lib/main.dart` (UI/state pattern)
- Dependency manifest: `pubspec.yaml` (add packages here)
- Tests: `test/widget_test.dart`

If a proposed change affects any platform folder or `pubspec.yaml`, include these in the PR description:

1. Which platform(s) are affected
2. Brief reason for platform changes
3. Commands to validate locally (example: `flutter run -d windows`, `flutter build apk`)

When unsure, ask the maintainer which platform(s) to target. Keep changes minimal and focused: small hand-editable diffs are preferred.

— End of instructions —

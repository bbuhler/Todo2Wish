# Generate arb file for localization

```sh
flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n --output-file=intl_en.arb lib/Localizations.dart
```

# Before run / build

```sh
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/Localizations.dart lib/l10n/intl_*.arb
```

# Build
```sh
flutter build apk --release
```
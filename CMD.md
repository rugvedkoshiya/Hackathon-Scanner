# Clean project

```bash
flutter clean
```

# Install packages

```bash
flutter pub get
```

# Upgrade packages

```bash
flutter pub upgrade --major-versions
```

# Check outdated packages

```bash
flutter pub outdated
```

# Generate language

```bash
flutter gen-l10n
```

# Generate assets and fonts

```bash
dart run build_runner build # Preferred
flutter packages pub run build_runner build # Depricated
```

# Build android appbundle

```bash
flutter build appbundle
```

# Build ios appbundle

```bash
flutter build ios
flutter build ipa # For archive
```

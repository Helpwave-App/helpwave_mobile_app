# Project Context

## Localization

This project uses the `easy_localization` package for internationalization and localization.

The translation files are located in `lib/localization` and are in JSON format.

To update the localization files after adding or modifying translations, run the following command:

```shell
flutter pub run easy_localization:generate -S lib/localization -O lib/localization -o locale_keys.g.dart -f keys
```

If you encounter a dependency conflict with the `intl` package, you may need to update it first:

```shell
flutter pub add intl:^0.19.0
```

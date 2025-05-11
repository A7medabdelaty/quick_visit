import 'package:flutter/material.dart';

class ThemeHelper {
  static ColorScheme colorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  static TextTheme textTheme(BuildContext context) {
    return Theme.of(context).textTheme;
  }

  // Colors shortcuts
  static Color primary(BuildContext context) => colorScheme(context).primary;
  static Color onPrimary(BuildContext context) =>
      colorScheme(context).onPrimary;
  static Color secondary(BuildContext context) =>
      colorScheme(context).secondary;
  static Color onSecondary(BuildContext context) =>
      colorScheme(context).onSecondary;
  static Color background(BuildContext context) => colorScheme(context).surface;
  static Color onBackground(BuildContext context) =>
      colorScheme(context).onSurface;
  static Color surface(BuildContext context) => colorScheme(context).surface;
  static Color onSurface(BuildContext context) =>
      colorScheme(context).onSurface;
  static Color error(BuildContext context) => colorScheme(context).error;
  static Color onError(BuildContext context) => colorScheme(context).onError;

  // Text styles shortcuts
  static TextStyle? titleLarge(BuildContext context) =>
      textTheme(context).titleLarge;
  static TextStyle? titleMedium(BuildContext context) =>
      textTheme(context).titleMedium;
  static TextStyle? titleSmall(BuildContext context) =>
      textTheme(context).titleSmall;
  static TextStyle? bodyLarge(BuildContext context) =>
      textTheme(context).bodyLarge;
  static TextStyle? bodyMedium(BuildContext context) =>
      textTheme(context).bodyMedium;
  static TextStyle? bodySmall(BuildContext context) =>
      textTheme(context).bodySmall;
}

import 'dart:ui';

/// [AuropayTheme]
/// A theme class
/// user can set custom theme
class AuropayTheme {
  final Color primaryColor;
  final Color colorOnPrimary;
  final Color secondaryColor;
  final Color colorOnSecondary;

  AuropayTheme({
    required this.primaryColor,
    required this.colorOnPrimary,
    required this.colorOnSecondary,
    required this.secondaryColor,
  });

  Map<String, String> toJson() {
    return {
      'primaryColor': getColor(primaryColor),
      'colorOnPrimary': getColor(colorOnPrimary),
      'secondaryColor': getColor(secondaryColor),
      'colorOnSecondary': getColor(colorOnSecondary),
    };
  }

  @override
  bool operator ==(Object other) {
    return (other as AuropayTheme).primaryColor == primaryColor &&
        other.colorOnPrimary == colorOnPrimary &&
        other.secondaryColor == secondaryColor &&
        other.colorOnSecondary == colorOnSecondary;
  }

  String getColor(Color color) {
    String l1 = color.toString().split('0x')[1];
    l1 = l1.replaceAll(')', '');
    l1 = l1.substring(2);
    return l1;
  }

  @override
  int get hashCode => primaryColor.hashCode + secondaryColor.hashCode;
}

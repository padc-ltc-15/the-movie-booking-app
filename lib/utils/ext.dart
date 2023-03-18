import 'package:flutter/material.dart';
import 'package:moviebooking/resource/dimens.dart';

/// Context Extension
extension PageNavigator on BuildContext {
  void next(T) {
    Navigator.push(this, MaterialPageRoute(builder: (_) => T));
  }

  void nextRemove(T) {
    Navigator.pushAndRemoveUntil(
        this,
        MaterialPageRoute(
          builder: (context) => T,
        ),
        (route) => false);
  }

  void popBack() {
    Navigator.pop(this);
  }

  double getScreenHeightBy(double times) {
    return MediaQuery.of(this).size.height / times;
  }

  double getScreenWidthBy(double times) {
    return MediaQuery.of(this).size.width / times;
  }

  /// loading dialog
  showLoaderDialog() {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(
                left: MARGIN_LARGE,
              ),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: this,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

/// String Extension
extension StringFormat on String? {
  String toAssetImage() => "assets/images/$this";

  String toAssetIcon() => "assets/icons/$this";

  String orEmpty() => this ?? "";
}

extension NullIntExtension on int? {
  int orZero() => this ?? 0;
}

extension NullDoubleExtension on double? {
  double orZero() => this ?? 0;
}

extension NullBoolExtension on bool? {
  bool orTrue() => this ?? true;

  bool orFalse() => this ?? false;
}

extension ListNullSafetyExtension<T> on List<T?>? {
  List<T?> orEmpty() => this ?? [];

  List<T> orEmptyBoth() =>
      this?.where((element) => element != null).toList().cast() ?? [];
}

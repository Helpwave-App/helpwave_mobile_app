class DialogManager {
  static bool _isDialogShown = false;

  static bool get isDialogShown => _isDialogShown;

  static void setDialogShown(bool value) {
    _isDialogShown = value;
  }
}

class DialogManager {
  static bool _isDialogShown = false;

  static bool get isDialogShown => _isDialogShown;

  static void setDialogShown(bool value) {
    _isDialogShown = value;
    print('DialogManager: Dialog shown state changed to: $value');
  }

  static void reset() {
    _isDialogShown = false;
  }
}

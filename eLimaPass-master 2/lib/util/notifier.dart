class AppNotifier {
  static final AppNotifier _instance = AppNotifier._internal();

  bool? notified;

  factory AppNotifier() {
    return _instance;
  }

  AppNotifier._internal();
}

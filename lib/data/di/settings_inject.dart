import 'package:subscriptions/data/repositories/settings_repository.dart';

class SettingsInject {
  static SettingsRepository buildSettingsRepository() {
    return SettingsRepository();
  }
}

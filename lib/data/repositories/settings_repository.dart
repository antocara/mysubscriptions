import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const WIZARD_KEY = "wizard.mysubscriptions.es";

  void initialWizardDisplayed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(WIZARD_KEY, true);
  }

  Future<bool> isInitialWizardDisplayed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getBool(WIZARD_KEY) ?? false);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:subscriptions/data/di/payment_inject.dart';
import 'package:subscriptions/data/di/settings_inject.dart';
import 'package:subscriptions/domain/services/admob_service.dart';
import 'package:subscriptions/domain/services/analytics_service.dart';
import 'package:subscriptions/domain/services/background_jobs_service.dart';
import 'package:subscriptions/presentations/home_tab_menu/home_tab_bar_screen.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/wizard/initial_wizard_screen.dart';

import 'app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {
    _initializeServices();
    AdmobService.initializeAdmob();
  }

  final _repository = SettingsInject.buildSettingsRepository();

  @override
  Widget build(BuildContext context) {
    return _initializeMaterialApp(context);
  }

  Widget _initializeMaterialApp(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapData) {
        if (snapData.hasData && snapData.data != null) {
          return MaterialApp(
            theme: _initializeTheme(),
            // List all of the app's supported locales here
            supportedLocales: _locales,
            // These delegates make sure that the localization data for the proper language is loaded
            localizationsDelegates: _localesDelegates,
            // Returns a locale which will be used by the app
            localeResolutionCallback: (locale, supportedLocales) {
              return _initializeLocations(locale!, supportedLocales);
            },
            navigatorObservers: [AnalyticsService.fetchObserver()],
            home: snapData.data as Widget,
            onGenerateTitle: (context) {
              return AppLocalizations.of(context).translate("app_title");
            },
          );
        } else {
          return Container();
        }
      },
      future: _fetchHomeScreen(),
    );
  }

  ThemeData _initializeTheme() {
    return ThemeData(
      primaryColor: AppColors.kPrimaryColor,
      primaryColorDark: AppColors.kPrimaryColorDark,
    );
  }

  void _initializeServices() {
    PaymentInject.buildPaymentServices().updatePaymentData();
    final jobs = BackgroundJobsServices();
    jobs.registerPeriodicJobs();
  }

  Future<Widget> _fetchHomeScreen() async {
    final isWizardDisplayed = await _repository.isInitialWizardDisplayed();

    switch (isWizardDisplayed) {
      case true:
        return HomeTabMenuScreen();
      case false:
        return InitialWizardScreen();
    }
    return InitialWizardScreen();
  }

  /// Localize app

  final _locales = [Locale('en', 'US'), Locale('es', 'ES')];
  final _localesDelegates = [
    // A class which loads the translations from JSON files
    AppLocalizations.delegate,
    // Built-in localization of basic text for Material widgets
    GlobalMaterialLocalizations.delegate,
    // Built-in localization for text direction LTR/RTL
    GlobalWidgetsLocalizations.delegate,
  ];

  Locale _initializeLocations(Locale locale, Iterable<Locale> supportedLocales) {
    // Check if the current device locale is supported
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode &&
          supportedLocale.countryCode == locale.countryCode) {
        return supportedLocale;
      }
    }
    // If the locale of the device is not supported, use the first one
    // from the list (English, in this case).
    return supportedLocales.first;
  }
}

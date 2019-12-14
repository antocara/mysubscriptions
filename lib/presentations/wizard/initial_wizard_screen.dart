import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:subscriptions/app_localizations.dart';
import 'package:subscriptions/data/di/settings_inject.dart';
import 'package:subscriptions/presentations/navigation_manager.dart';
import 'package:subscriptions/presentations/styles/text_styles.dart';

class InitialWizardScreen extends StatelessWidget {
  final _repository = SettingsInject.buildSettingsRepository();

  @override
  Widget build(BuildContext context) {
    return _buildWizard(context);
  }

  Widget _buildWizard(BuildContext context) {
    return Builder(
      builder: (context) => IntroViewsFlutter(
        _buildPages(context),
        showNextButton: true,
        showBackButton: true,
        onTapDoneButton: () {
          _openMainScreen(context);
        },
        doneText: Text(AppLocalizations.of(context).translate("done")),
        backText: Text(AppLocalizations.of(context).translate("back")),
        nextText: Text(AppLocalizations.of(context).translate("next")),
        skipText: Text(AppLocalizations.of(context).translate("skip")),
        onTapSkipButton: () {
          _openMainScreen(context);
        },
        pageButtonTextStyles: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ), //IntroViewsFlutter
    );
  }

  void _openMainScreen(BuildContext context) {
    _repository.initialWizardDisplayed();
    NavigationManager.navigateToHomeScreen(context);
  }

  List<PageViewModel> _buildPages(BuildContext context) {
    return [
      PageViewModel(
          pageColor: const Color(0xFF9B59B6),
          body: Text(
            AppLocalizations.of(context).translate("wizard_add_legend"),
          ),
          title: Text(
            AppLocalizations.of(context).translate("wizard_add"),
          ),
          titleTextStyle: kTitleWizard,
          bodyTextStyle: kLegendWizard,
          mainImage: _buildImage('images/airplane.png')),
      PageViewModel(
        pageColor: const Color(0xFFC0392B),
        body: Text(
          AppLocalizations.of(context).translate("wizard_renewal_list_legend"),
        ),
        title: Text(AppLocalizations.of(context).translate("wizard_renewal_list")),
        mainImage: _buildImage('images/hotel.png'),
        titleTextStyle: kTitleWizard,
        bodyTextStyle: kLegendWizard,
      ),
      PageViewModel(
        pageColor: const Color(0xFFE67E22),
        body: Text(
          AppLocalizations.of(context).translate("wizard_finance_legend"),
        ),
        title: Text(AppLocalizations.of(context).translate("wizard_finance")),
        mainImage: _buildImage('images/taxi.png'),
        titleTextStyle: kTitleWizard,
        bodyTextStyle: kLegendWizard,
      ),
      PageViewModel(
        pageColor: const Color(0xFF27AE60),
        body: Text(
          AppLocalizations.of(context).translate("wizard_reminders_legend"),
        ),
        title: Text(AppLocalizations.of(context).translate("wizard_reminders")),
        mainImage: _buildImage('images/taxi.png'),
        titleTextStyle: kTitleWizard,
        bodyTextStyle: kLegendWizard,
      ),
    ];
  }

  Image _buildImage(String path) {
    return Image.asset(
      path,
      height: 250.0,
      width: 250.0,
      alignment: Alignment.center,
    );
  }
}

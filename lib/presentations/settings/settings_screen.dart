import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:subscriptions/app_localizations.dart';
import 'package:subscriptions/presentations/components/app_bar_default.dart';
import 'package:subscriptions/presentations/styles/components.dart';
import 'package:subscriptions/presentations/styles/text_styles.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _versionApp = "0.00";

  @override
  void initState() {
    _fetchVersionApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBarDefault(
          title: AppLocalizations.of(context).translate("settings"),
        ),
        Expanded(
          child: _buildBody(),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return _factoryRows(context, index);
        },
        separatorBuilder: (context, index) {
          return kListDividerWidget;
        },
        itemCount: 3);
  }

  Widget _factoryRows(BuildContext context, int index) {
    switch (index) {
      case 0:
        return _buildAuthorRow(context);
      case 1:
        return _buildVersionRow(context);
      default:
        return _buildDevelopLoveRow(context);
    }
  }

  Widget _buildVersionRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Container(
        height: 40,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(AppLocalizations.of(context).translate("app_version"),
                  style: kTitleSettings),
            ),
            Text("$_versionApp", style: kTitleSettings),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorRow(BuildContext context) {
    return InkWell(
      onTap: _openTwitter,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                    AppLocalizations.of(context).translate("develop_by"),
                    style: kTitleSettings),
              ),
              Text(
                AppLocalizations.of(context).translate("antocara"),
                style: kTitleSettings,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDevelopLoveRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Container(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(AppLocalizations.of(context).translate("develop_with"),
                style: kTitleSettings),
            Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            Text(AppLocalizations.of(context).translate("in_coin"),
                style: kTitleSettings),
          ],
        ),
      ),
    );
  }

  Future _fetchVersionApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _versionApp = packageInfo.version;
    });
  }

  void _openTwitter() {
    Share.share(AppLocalizations.of(context).translate("twitter"));
  }
}

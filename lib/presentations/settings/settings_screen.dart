import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:subscriptions/presentations/components/default_app_bar.dart';

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
        DefaultAppBar(
          title: "Settings",
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
          return _factoryRows(index);
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: 3);
  }

  Widget _factoryRows(int index) {
    switch (index) {
      case 0:
        return _buildAuthorRow();
      case 1:
        return _buildVersionRow();
      default:
        return _buildDevelopLoveRow();
    }
  }

  Widget _buildVersionRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Container(
        height: 40,
        child: Row(
          children: <Widget>[
            Expanded(child: Text("Version")),
            Text("$_versionApp"),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorRow() {
    return InkWell(
      onTap: _openTwitter,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(child: Text("Develop by ")),
              Text("@antocara"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDevelopLoveRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Container(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Develop with "),
            Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            Text(" in Coin"),
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
    Share.share('https://twitter.com/antocara');
  }
}

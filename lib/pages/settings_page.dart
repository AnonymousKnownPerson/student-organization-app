import 'package:flutter/material.dart';

import '../widgets/appbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = false;
  void _toggleSwitch(bool val) {
    setState(() {
      isSwitched = !isSwitched;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const AppBarWidget(title: 'Settings'),
      body: Container(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Dark mode'),
                Switch(
                    value: isSwitched,
                    onChanged: _toggleSwitch,
                    activeColor: Theme.of(context).colorScheme.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

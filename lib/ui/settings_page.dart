import 'dart:io';

import 'package:dicoding_news/provider/scheduling_provider.dart';
import 'package:dicoding_news/widgets/custom_dialog.dart';
import 'package:dicoding_news/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  static const String settingsTitle = 'Settings';

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView(
      children: [
        Material(
          child: ListTile(
            title: const Text('Dark Theme'),
            trailing: Switch.adaptive(
              value: false,
              onChanged: (value) {
                customDialog(context);
                // defaultTargetPlatform == TargetPlatform.iOS
                //     ? showCupertinoDialog(
                //         context: context,
                //         builder: (context) {
                //           return CupertinoAlertDialog(
                //             title: const Text('Coming Soon!'),
                //             content:
                //                 const Text('This feature will be coming soon!'),
                //             actions: [
                //               CupertinoDialogAction(
                //                 child: const Text('Ok'),
                //                 onPressed: () {
                //                   Navigator.pop(context);
                //                 },
                //               ),
                //             ],
                //           );
                //         },
                //       )
                //     : showDialog(
                //         context: context,
                //         builder: (context) {
                //           return AlertDialog(
                //             title: const Text('Coming Soon!'),
                //             content:
                //                 const Text('This feature will be coming soon!'),
                //             actions: [
                //               TextButton(
                //                 onPressed: () {
                //                   Navigator.pop(context);
                //                 },
                //                 child: const Text('Ok'),
                //               ),
                //             ],
                //           );
                //         },
                //       );
              },
            ),
          ),
        ),
        Material(
          child: ListTile(
            title: const Text("Scheduling News"),
            trailing: Consumer<SchedulingProvider>(
              builder: (context, SchedulingProvider scheduled, _) {
                return Switch.adaptive(
                  value: scheduled.isScheduled,
                  onChanged: (value) async {
                    if (Platform.isIOS) {
                      customDialog(context);
                    } else {
                      scheduled.scheduledNews(value);
                    }
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }
}

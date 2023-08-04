// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a CC BY-NC-ND 4.0 license that can be
// found in the LICENSE file.

import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';
import 'package:app_finance/_classes/data/transaction_log.dart';
import 'package:app_finance/custom_text_theme.dart';
import 'package:app_finance/helpers/theme_helper.dart';
import 'package:app_finance/widgets/_forms/simple_input.dart';
import 'package:app_finance/widgets/_wrappers/required_widget.dart';
import 'package:app_finance/widgets/init/loading_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:webdav_client/webdav_client.dart';

class RecoverTab extends StatefulWidget {
  const RecoverTab({super.key});

  @override
  SyncTabState createState() => SyncTabState();
}

class SyncTabState extends State<RecoverTab> {
  String? username;
  String? password;
  String? link;
  String path = 'tmp.log';
  String message = '';
  bool inProgress = false;

  Client? _connect(BuildContext context) {
    if (username == null || link == null || password == null) {
      setState(() => message = AppLocalizations.of(context)!.isRequired);
      return null;
    }
    setState(() => inProgress = true);
    return newClient(link!, user: username!, password: password!);
  }

  Future<void> save2WebDav(BuildContext context) async {
    final client = _connect(context);
    if (client == null) {
      return;
    }
    List<int> codeUnits = [];
    await for (String line in TransactionLog.read()) {
      codeUnits.addAll(line.codeUnits);
      codeUnits.addAll('\n'.codeUnits);
    }
    final Uint8List unit8List = Uint8List.fromList(codeUnits);
    await client.write(path, unit8List).catchError((err) {
      setState(() {
        message = AppLocalizations.of(context)!.error(err.toString());
        inProgress = false;
      });
    });
    setState(() {
      inProgress = false;
      message = AppLocalizations.of(context)!.success;
    });
  }

  Future<void> recover4WebDav(BuildContext context) async {
    final client = _connect(context);
    if (client == null) {
      return;
    }
    List<int> uint8list = await client.read(path);
    List<String> lines = String.fromCharCodes(uint8list).split('\n');
    for (String line in lines) {
      await TransactionLog.save(line, true);
    }
    setState(() {
      inProgress = false;
      message = AppLocalizations.of(context)!.success;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    double indent = ThemeHelper(windowType: getWindowType(context)).getIndent() * 2;

    return Padding(
      padding: EdgeInsets.all(indent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (inProgress) ...[
            SizedBox(height: indent * 6),
            LoadingWidget(isLoading: inProgress),
          ] else ...[
            SizedBox(height: indent),
            Text(
              AppLocalizations.of(context)!.webDav,
              style: textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.inversePrimary),
            ),
            SizedBox(height: indent),
            RequiredWidget(
              title: AppLocalizations.of(context)!.link,
              showError: message != '' && link == null,
            ),
            SimpleInput(
              value: link,
              type: TextInputType.url,
              style: textTheme.numberMedium.copyWith(color: textTheme.headlineSmall?.color),
              setState: (value) => setState(() => link = value),
            ),
            SizedBox(height: indent),
            RequiredWidget(
              title: AppLocalizations.of(context)!.username,
              showError: message != '' && username == null,
            ),
            SimpleInput(
              value: username,
              style: textTheme.numberMedium.copyWith(color: textTheme.headlineSmall?.color),
              setState: (value) => setState(() => username = value),
            ),
            SizedBox(height: indent),
            RequiredWidget(
              title: AppLocalizations.of(context)!.password,
              showError: message != '' && password == null,
            ),
            SimpleInput(
              value: password,
              type: TextInputType.visiblePassword,
              style: textTheme.numberMedium.copyWith(color: textTheme.headlineSmall?.color),
              setState: (value) => setState(() => password = value),
            ),
            SizedBox(height: indent),
            RequiredWidget(
              title: AppLocalizations.of(context)!.path,
              showError: message != '' && path == '',
            ),
            SimpleInput(
              value: path,
              style: textTheme.numberMedium.copyWith(color: textTheme.headlineSmall?.color),
              setState: (value) => setState(() => path = value),
            ),
            SizedBox(height: indent * 2),
            SizedBox(
              width: double.infinity,
              child: FloatingActionButton(
                onPressed: () => save2WebDav(context),
                tooltip: AppLocalizations.of(context)!.saveTooltip,
                child: Text(AppLocalizations.of(context)!.saveTooltip),
              ),
            ),
            SizedBox(height: indent * 4),
            SizedBox(
              width: double.infinity,
              child: FloatingActionButton(
                onPressed: () => recover4WebDav(context),
                tooltip: AppLocalizations.of(context)!.recoveryTooltip,
                child: Text(AppLocalizations.of(context)!.recoveryTooltip),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

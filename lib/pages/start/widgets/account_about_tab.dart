// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a CC BY-NC-ND 4.0 license that can be found in the LICENSE file.

import 'package:app_finance/_classes/herald/app_locale.dart';
import 'package:app_finance/_mixins/launcher_mixin.dart';
import 'package:app_finance/design/wrapper/markdown_builder_wrapper.dart';
import 'package:app_finance/pages/start/widgets/abstract_tab.dart';
import 'package:flutter/material.dart';

class AccountAboutTab extends AbstractTab {
  const AccountAboutTab({
    super.key,
    required super.setState,
    required super.setButton,
    super.isFirstBoot = true,
  });

  @override
  AccountAboutTabState createState() => AccountAboutTabState();
}

class AccountAboutTabState<T extends AccountAboutTab> extends AbstractTabState<T> with LauncherMixin {
  @override
  String getButtonTitle() => '';

  @override
  Widget buildContent(BuildContext context, BoxConstraints constraints) {
    final locale = AppLocale.labels.localeName;
    return MarkdownBuilderWrapper(url: './assets/l10n/about_account_$locale.md');
  }
}

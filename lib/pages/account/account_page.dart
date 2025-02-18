// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a CC BY-NC-ND 4.0 license that can be found in the LICENSE file.

import 'package:app_finance/_classes/herald/app_design.dart';
import 'package:app_finance/_classes/storage/app_data.dart';
import 'package:app_finance/_classes/herald/app_locale.dart';
import 'package:app_finance/_classes/structure/account_app_data.dart';
import 'package:app_finance/_classes/structure/currency/exchange.dart';
import 'package:app_finance/_configs/design_type.dart';
import 'package:app_finance/_configs/theme_helper.dart';
import 'package:app_finance/_classes/structure/navigation/app_route.dart';
import 'package:app_finance/design/wrapper/background_wrapper.dart';
import 'package:app_finance/pages/_interfaces/abstract_page_state.dart';
import 'package:app_finance/pages/account/widgets/account_line_widget.dart';
import 'package:app_finance/design/generic/base_header_widget.dart';
import 'package:app_finance/design/generic/base_swipe_widget.dart';
import 'package:app_finance/design/wrapper/tap_widget.dart';
import 'package:app_finance/pages/account/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  final String? search;

  const AccountPage({
    super.key,
    this.search,
  });

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends AbstractPageState<AccountPage> {
  AppDataGetter _getItems() {
    if (widget.search != null) {
      final scope = state.getList(AppDataType.accounts).where((e) => e.title.toString().startsWith(widget.search!));
      final ex = Exchange(store: super.state);
      return (
        total: scope.fold(0.0, (v, e) => v + ex.reform(e.details, e.currency, ex.getDefaultCurrency())),
        list: scope.toList(),
        stream: state.getStream(AppDataType.accounts, filter: (e) => !e.title.toString().startsWith(widget.search!))
      );
    }
    return state.get(AppDataType.accounts);
  }

  @override
  String getTitle() {
    if (widget.search != null) {
      return AppLocale.labels.search(widget.search!);
    }
    return AppLocale.labels.accountHeadline;
  }

  @override
  String getButtonName() => AppLocale.labels.addAccountTooltip;

  @override
  Widget buildButton(BuildContext context, BoxConstraints constraints) {
    NavigatorState nav = Navigator.of(context);
    return FloatingActionButton(
      heroTag: 'account_page',
      onPressed: () => nav.pushNamed(AppRoute.accountAddRoute),
      tooltip: getButtonName(),
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget buildContent(BuildContext context, BoxConstraints constraints) {
    final items = _getItems();
    final design = Provider.of<AppDesign>(context, listen: false);
    if (design.value == AppDesignType.germany) {
      items.list.sort((a, b) => a.title.compareTo(b.title));
    }
    final width = ThemeHelper.getWidth(context, 4, constraints);
    final indent = ThemeHelper.getIndent();
    final widthCount = ThemeHelper.getWidthCount(constraints, context);
    return Padding(
      padding: EdgeInsets.all(indent),
      child: Column(
        children: [
          BaseHeaderWidget(
            route: AppRoute.homeRoute,
            tooltip: AppLocale.labels.homeTooltip,
            width: width,
            total: items.total,
            title: '${AppLocale.labels.accountHeadline}, ${AppLocale.labels.total}',
          ),
          ThemeHelper.hIndent,
          if (widthCount > 2) HeaderWidget(count: widthCount, width: width),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: items.list.length + 1,
              separatorBuilder: (_, index) => Divider(height: indent),
              itemBuilder: (BuildContext context, index) {
                if (index >= items.list.length) {
                  return ThemeHelper.formEndBox;
                }
                AccountAppData item = items.list[index];
                return BackgroundWrapper(
                  index: index,
                  child: BaseSwipeWidget(
                    routePath: AppRoute.accountEditRoute,
                    uuid: item.uuid!,
                    child: TapWidget(
                      tooltip: '',
                      route:
                          RouteSettings(name: AppRoute.accountViewRoute, arguments: {routeArguments.uuid: item.uuid}),
                      child: AccountLineWidget(
                        item: item,
                        width: width,
                        count: widthCount,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

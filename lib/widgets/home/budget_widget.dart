// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a CC BY-NC-ND 4.0 license that can be
// found in the LICENSE file.

import 'package:app_finance/_classes/app_route.dart';
import 'package:app_finance/_classes/data/budget_app_data.dart';
import 'package:app_finance/widgets/home/account_widget.dart';
import 'package:app_finance/widgets/home/base_line_widget.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';

class BudgetWidget extends AccountWidget {
  BudgetWidget({
    super.key,
    required super.title,
    required super.offset,
    required super.margin,
    required super.state,
    super.tooltip,
    super.limit,
    super.route,
    String routeList = AppRoute.budgetViewRoute,
    super.hasExpand,
    super.toExpand,
    super.callback,
  }) : super(
          routeList: routeList,
        );

  @override
  dynamic wrapBySingleEntity(List<dynamic> items) {
    Currency? def = CurrencyService().findByCode(getPreference(prefCurrency));
    double amount = items.fold(0.0, (value, e) => value + exchange.reform(e.amountLimit, e.currency, def));
    double amountSpent =
        items.fold(0.0, (value, e) => value + exchange.reform(e.amountLimit * e.progress, e.currency, def));
    double progress = amount > 0 ? 1 - (amount - amountSpent) / amount : 0.0;
    return BudgetAppData(
      title: getName(items.first),
      currency: def,
      amountLimit: amount,
      progress: progress,
    );
  }

  @override
  Widget buildSingleListWidget(item, BuildContext context, double offset) {
    item = item.first;
    item.updateContext(context);
    return BaseLineWidget(
      uuid: item.uuid,
      title: item.title,
      description: item.description ?? '',
      details: item.detailsFormatted,
      progress: (item.progress < 1 ? 1 - item.progress : 0.0).toDouble(),
      color: item.color ?? Colors.transparent,
      hidden: item.hidden,
      offset: offset,
      route: routeList,
    );
  }
}

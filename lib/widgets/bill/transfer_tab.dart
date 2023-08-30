// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a CC BY-NC-ND 4.0 license that can be found in the LICENSE file.

import 'package:app_finance/_classes/herald/app_locale.dart';
import 'package:app_finance/_classes/structure/navigation/app_route.dart';
import 'package:app_finance/_classes/structure/account_app_data.dart';
import 'package:app_finance/_classes/structure/currency/exchange.dart';
import 'package:app_finance/_classes/controller/focus_controller.dart';
import 'package:app_finance/_classes/storage/app_data.dart';
import 'package:app_finance/_configs/theme_helper.dart';
import 'package:app_finance/widgets/_forms/currency_exchange_input.dart';
import 'package:app_finance/widgets/_wrappers/full_sized_button_widget.dart';
import 'package:app_finance/widgets/_wrappers/required_widget.dart';
import 'package:app_finance/widgets/_wrappers/row_widget.dart';
import 'package:app_finance/widgets/_forms/currency_selector.dart';
import 'package:app_finance/widgets/_forms/list_account_selector.dart';
import 'package:app_finance/widgets/_forms/simple_input.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransferTab extends StatefulWidget {
  final String? accountFrom;
  final String? accountTo;
  final double? amount;
  final Currency? currency;

  const TransferTab({
    super.key,
    this.accountFrom,
    this.accountTo,
    this.amount,
    this.currency,
  });

  @override
  TransferTabState createState() => TransferTabState();
}

class TransferTabState extends State<TransferTab> {
  late AppData state;
  String? accountFrom;
  String? accountTo;
  late TextEditingController amount;
  double? amountValue;
  Currency? currency;
  bool hasErrors = false;

  @override
  void initState() {
    accountFrom = widget.accountFrom;
    accountTo = widget.accountTo;
    amount = TextEditingController(text: widget.amount != null ? widget.amount.toString() : '');
    amountValue = widget.amount;
    currency = widget.currency;
    super.initState();
  }

  bool hasFormErrors() {
    setState(() => hasErrors = accountFrom == null || accountTo == null);
    return hasErrors;
  }

  void updateStorage() {
    String uuidFrom = accountFrom ?? '';
    final course = Exchange(store: state);
    AccountAppData from = state.getByUuid(uuidFrom);
    from.details -= course.reform(double.tryParse(amount.text), from.currency, currency);
    state.update(uuidFrom, from);
    String uuidTo = accountTo ?? '';
    AccountAppData to = state.getByUuid(uuidTo);
    to.details += course.reform(double.tryParse(amount.text), currency, to.currency);
    state.update(uuidTo, to);
  }

  Widget buildButton(BuildContext context, BoxConstraints constraints) {
    NavigatorState nav = Navigator.of(context);
    return FullSizedButtonWidget(
      constraints: constraints,
      setState: () => {
        setState(() {
          if (hasFormErrors()) {
            return;
          }
          updateStorage();
          nav.popAndPushNamed(AppRoute.homeRoute);
        })
      },
      title: AppLocale.labels.createTransferTooltip,
      icon: Icons.save,
    );
  }

  @override
  Widget build(BuildContext context) {
    // FocusController.dispose();
    final TextTheme textTheme = Theme.of(context).textTheme;
    double indent = ThemeHelper.getIndent(2);
    double width = ThemeHelper.getWidth(context, 6);
    FocusController.init();

    return LayoutBuilder(builder: (context, constraints) {
      return Consumer<AppData>(builder: (context, appState, _) {
        state = appState;
        return Scaffold(
          body: SingleChildScrollView(
            controller: FocusController.getController(runtimeType),
            child: Container(
              margin: EdgeInsets.fromLTRB(indent, indent, indent, 240),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RequiredWidget(
                    title: AppLocale.labels.accountFrom,
                    showError: hasErrors && accountFrom == null,
                  ),
                  ListAccountSelector(
                    value: accountFrom,
                    hintText: AppLocale.labels.accountFrom,
                    state: state,
                    setState: (value) => setState(() => accountFrom = value),
                    indent: indent,
                    width: width,
                  ),
                  ThemeHelper.hIndent2x,
                  RequiredWidget(
                    title: AppLocale.labels.accountTo,
                    showError: hasErrors && accountTo == null,
                  ),
                  ListAccountSelector(
                    value: accountTo,
                    hintText: AppLocale.labels.accountTo,
                    state: state,
                    setState: (value) => setState(() {
                      accountTo = value;
                      currency ??= state.getByUuid(value).currency;
                    }),
                    indent: indent,
                    width: width,
                  ),
                  ThemeHelper.hIndent2x,
                  RowWidget(
                    indent: indent,
                    maxWidth: width + indent,
                    chunk: const [120, null],
                    children: [
                      [
                        Text(
                          AppLocale.labels.currency,
                          style: textTheme.bodyLarge,
                        ),
                        CurrencySelector(
                          value: currency?.code,
                          hintText: AppLocale.labels.currencyTooltip,
                          setView: (Currency currency) => currency.code,
                          setState: (value) => setState(() => currency = value),
                        ),
                      ],
                      [
                        Text(
                          AppLocale.labels.expenseTransfer,
                          style: textTheme.bodyLarge,
                        ),
                        SimpleInput(
                          controller: amount,
                          type: const TextInputType.numberWithOptions(decimal: true),
                          tooltip: AppLocale.labels.billSetTooltip,
                          setState: (v) => setState(() => amountValue = double.tryParse(v)),
                          formatter: [
                            SimpleInput.filterDouble,
                          ],
                        ),
                      ],
                    ],
                  ),
                  ThemeHelper.hIndent2x,
                  CurrencyExchangeInput(
                    width: width,
                    indent: indent,
                    target: currency,
                    state: state,
                    targetAmount: amountValue,
                    source: <Currency?>[
                      accountFrom != null ? state.getByUuid(accountFrom!).currency : null,
                      accountTo != null ? state.getByUuid(accountTo!).currency : null,
                    ],
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: buildButton(context, constraints),
        );
      });
    });
  }
}

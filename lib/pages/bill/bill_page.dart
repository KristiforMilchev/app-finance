// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a CC BY-NC-ND 4.0 license that can be found in the LICENSE file.

import 'dart:collection';

import 'package:app_finance/_classes/controller/iterator_controller.dart';
import 'package:app_finance/_classes/storage/app_data.dart';
import 'package:app_finance/_classes/herald/app_locale.dart';
import 'package:app_finance/_classes/structure/bill_app_data.dart';
import 'package:app_finance/_configs/theme_helper.dart';
import 'package:app_finance/_classes/structure/navigation/app_route.dart';
import 'package:app_finance/_ext/date_time_ext.dart';
import 'package:app_finance/pages/_interface/abstract_page_state.dart';
import 'package:app_finance/pages/bill/widgets/bill_line_widget.dart';
import 'package:app_finance/pages/bill/widgets/header_delegate.dart';
import 'package:app_finance/widgets/generic/base_swipe_widget.dart';
import 'package:flutter/material.dart';

class BillPage extends StatefulWidget {
  const BillPage({super.key});

  @override
  BillPageState createState() => BillPageState();
}

class BillPageState extends AbstractPageState<BillPage> {
  InterfaceIterator? stream;
  List<Widget> itemsShown = [];
  DateTime timer = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  Queue<String> title = Queue();
  final _scrollController = ScrollController();
  bool isLoading = false;
  final batch = 25;
  bool isTop = true;
  late double width;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < 10) {
        _update(null);
        setState(() => isTop = true);
      } else if (isTop) {
        setState(() => isTop = false);
      }
      if (_scrollController.position.extentAfter < 200 && !isLoading && !stream!.isFinished) {
        setState(() => _addItems());
      }
    });
  }

  void _addItems() {
    if (stream!.isFinished) {
      return;
    }
    String marker = '';
    List<BillAppData> items = [];
    do {
      marker = timer.yMEd();
      items = stream!.getTill(0.0 + timer.millisecondsSinceEpoch) as List<BillAppData>;
      timer = timer.add(const Duration(days: -1));
    } while (items.isEmpty && !stream!.isFinished);

    itemsShown.add(
      SliverMainAxisGroup(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: HeaderDelegate(marker),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: ThemeHelper.getIndent(0.5)),
            sliver: SliverList.builder(
              itemCount: items.length,
              itemBuilder: (_, int index) {
                final item = items[index];
                final account = state.getByUuid(item.account);
                final budget = state.getByUuid(item.category);
                return BaseSwipeWidget(
                  routePath: AppRoute.billEditRoute,
                  uuid: item.uuid!,
                  child: BillLineWidget(
                    uuid: item.uuid!,
                    title: item.title,
                    description: account != null ? '${account.title} (${account.description})' : '',
                    descriptionColor: account?.color ?? Colors.transparent,
                    details: item.detailsFormatted,
                    progress: item.progress,
                    color: budget?.color ?? Colors.transparent,
                    icon: budget?.icon ?? Icons.radio_button_unchecked_sharp,
                    iconTooltip: budget?.title ?? '?',
                    hidden: item.hidden,
                    width: width,
                    route: AppRoute.billViewRoute,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.position.maxScrollExtent == 0) {
        setState(() => _addItems());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _update(String? value) => WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
        if (value == null) {
          title.clear();
        } else if (title.isNotEmpty && title.last == value) {
          title.removeLast();
        } else {
          title.addLast(value);
        }
      }));

  @override
  String getTitle() {
    return AppLocale.labels.billHeadline;
  }

  @override
  String getButtonName() => AppLocale.labels.addMainTooltip;

  @override
  Widget buildButton(BuildContext context, BoxConstraints constraints) {
    NavigatorState nav = Navigator.of(context);
    return FloatingActionButton(
      heroTag: 'bill_page',
      onPressed: () => nav.pushNamed(AppRoute.billAddRoute),
      tooltip: getButtonName(),
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget buildContent(BuildContext context, BoxConstraints constraints) {
    width = ThemeHelper.getWidth(context, 2, constraints);
    if (stream == null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => setState(() {
          stream = state.getStream<BillAppData>(AppDataType.bills);
          _addItems();
        }),
      );
    }
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        ...itemsShown,
      ],
    );
  }
}

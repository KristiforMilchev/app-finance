// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a CC BY-NC-ND 4.0 license that can be found in the LICENSE file.

import 'package:app_finance/_classes/gen/generate_with_method_setters.dart';
import 'package:app_finance/_classes/storage/data_handler.dart';
import 'package:app_finance/_classes/structure/currency/exchange.dart';
import 'package:app_finance/_classes/structure/transaction_log_data.dart';
import 'package:app_finance/charts/interface/ohlc_data.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<Exchange>()])
import 'data_handler_test.mocks.dart';
@GenerateWithMethodSetters([MockExchange])
import 'data_handler_test.wrapper.dart';

void main() {
  group('DataHandler', () {
    late WrapperMockExchange exchange;

    setUp(() {
      exchange = WrapperMockExchange();
      exchange.mockReform = (double? v, Currency? from, Currency? to) => v ?? 0.0;
    });

    test('generateOhlcSummary (empty)', () {
      expect(DataHandler.generateOhlcSummary([], exchange: exchange), []);
    });

    test('generateOhlcSummary', () {
      final data = [
        [
          TransactionLogData<double>(changedFrom: 0.0, changedTo: 5.0, name: '', timestamp: DateTime(2023, 01, 01, 1)),
          TransactionLogData<double>(changedFrom: 0.0, changedTo: -2.0, name: '', timestamp: DateTime(2023, 01, 01, 2)),
          TransactionLogData<double>(changedFrom: 0.0, changedTo: 10.0, name: '', timestamp: DateTime(2023, 01, 02)),
          TransactionLogData<double>(changedFrom: 0.0, changedTo: 15.0, name: '', timestamp: DateTime(2023, 01, 03, 1)),
        ],
        [
          TransactionLogData<double>(changedFrom: 0.0, changedTo: 4.0, name: '', timestamp: DateTime(2023, 01, 01, 12)),
          TransactionLogData<double>(changedFrom: 0.0, changedTo: 10.0, name: '', timestamp: DateTime(2023, 01, 03, 1)),
          TransactionLogData<double>(changedFrom: 0.0, changedTo: -1.0, name: '', timestamp: DateTime(2023, 01, 03, 2)),
        ]
      ];
      final result = DataHandler.generateOhlcSummary(data, exchange: exchange);
      expect(result, [
        OhlcData(date: DateTime(2023, 01, 01), close: 41.0, high: 42.0, low: 3.0, open: 5.0),
      ]);
    });
  });
}

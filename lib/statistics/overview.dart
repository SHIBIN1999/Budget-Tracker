import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_1/calculation/sort.dart';
import 'package:money_1/db/transaction/transactiondb.dart';
import 'package:money_1/models/transcation_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

ValueNotifier<List<TransactionModel>> overviewChartList =
    ValueNotifier(TransactionDb.instance.transactionNotifier.value);

class MyOverview extends StatefulWidget {
  const MyOverview({super.key});

  @override
  State<MyOverview> createState() => _MyOverviewState();
}

class _MyOverviewState extends State<MyOverview> {
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ValueListenableBuilder(
        valueListenable: overviewChartList,
        builder:
            (BuildContext context, List<TransactionModel> newList, Widget? _) {
          Map incomeMap = {"name": "Income", "amount": incomeTotal.value};
          Map expenseMap = {"name": "Expense", "amount": expenseTotal.value};
          List<Map> chartList = [incomeMap, expenseMap];

          return overviewChartList.value.isEmpty
              ? Center(
                  child: Text('No data',
                      style:
                          GoogleFonts.quicksand(//color: ThemeColor.themeColors
                              )),
                )
              : Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: SfCircularChart(
                    backgroundColor: Colors.white,
                    legend: const Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.scroll),
                    tooltipBehavior: _tooltipBehavior,
                    series: <CircularSeries>[
                      PieSeries<Map, String>(
                        dataSource: chartList,
                        xValueMapper: (Map data, _) => data['name'],
                        yValueMapper: (Map data, _) => data['amount'],
                        enableTooltip: true,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}

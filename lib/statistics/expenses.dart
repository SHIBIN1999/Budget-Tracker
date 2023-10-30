import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_1/models/categorymodel.dart';
import 'package:money_1/models/transcation_model.dart';
import 'package:money_1/statistics/overview.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyExpense extends StatefulWidget {
  const MyExpense({super.key});

  @override
  State<MyExpense> createState() => _MyExpenseState();
}

class _MyExpenseState extends State<MyExpense> {
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
        builder: (context, chartData, child) {
          var expenseData = chartData
              .where((element) => element.category.type == CategoryType.expense)
              .toList();
          return expenseData.isEmpty
              ? Center(
                  child: Text(
                    'No  ',
                    style: GoogleFonts.quicksand(//color: ThemeColor.themeColors
                        ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: SfCircularChart(
                    backgroundColor: Colors.white,
                    legend: const Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.scroll,
                        alignment: ChartAlignment.center),
                    tooltipBehavior: _tooltipBehavior,
                    series: <CircularSeries>[
                      PieSeries<TransactionModel, String>(
                          dataSource: expenseData,
                          xValueMapper: (TransactionModel data, _) =>
                              data.category.name,
                          yValueMapper: (TransactionModel data, _) =>
                              data.amount,
                          enableTooltip: true,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true))
                    ],
                  ),
                );
        },
      ),
    );
  }
}

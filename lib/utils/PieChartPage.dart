import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'indicator.dart';
import 'dart:async';
import 'package:mpango/models/Project.dart';
import 'dart:math';

class PieChartPage extends StatefulWidget {
  var projectObj;

  PieChartPage({this.projectObj});

  @override
  //State<StatefulWidget> createState() => _PieChartPage();
  _PieChartPage createState() => new _PieChartPage();
}

//class _PieChartPage extends State {
class _PieChartPage extends State<PieChartPage> {
  Project myProject = new Project();

  List<PieChartSectionData> pieChartRawSections;
  List<PieChartSectionData> showingSections;

  StreamController<PieTouchResponse> pieTouchedResultStreamController;

  int touchedIndex;

  double dp(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  @override
  void initState() {
    super.initState();
    myProject = widget.projectObj;

    double expenses = dp(
        (myProject.totalExpenses /
            (myProject.totalExpenses + myProject.totalIncomes) *
            100),
        1);
    double income = dp(
        (myProject.totalIncomes /
            (myProject.totalExpenses + myProject.totalIncomes) *
            100),
        1);

    final section1 = PieChartSectionData(
      color: Colors.red,
      value: expenses,
      title: '${expenses}%',
      radius: 50,
      titleStyle: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
    );

    final section2 = PieChartSectionData(
      color: Colors.green,
      value: income,
      title: '${income}%',
      radius: 50,
      titleStyle: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
    );

    final items = [
      section1,
      section2,
    ];

    pieChartRawSections = items;

    showingSections = pieChartRawSections;

    pieTouchedResultStreamController = StreamController();
    pieTouchedResultStreamController.stream.distinct().listen((details) {
      if (details == null) {
        return;
      }

      touchedIndex = -1;
      if (details.sectionData != null) {
        touchedIndex = showingSections.indexOf(details.sectionData);
      }

      setState(() {
        if (details.touchInput is FlLongPressEnd) {
          touchedIndex = -1;
          showingSections = List.of(pieChartRawSections);
        } else {
          showingSections = List.of(pieChartRawSections);

          if (touchedIndex != -1) {
            final TextStyle style = showingSections[touchedIndex].titleStyle;
            showingSections[touchedIndex] =
                showingSections[touchedIndex].copyWith(
              titleStyle: style.copyWith(
                fontSize: 24,
              ),
              radius: 60,
            );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
          color: Colors.white,
          child: Column(children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Text(
              myProject.ProjectName,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0),
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.6,
                child: FlChart(
                  chart: PieChart(
                    PieChartData(
                        pieTouchData: PieTouchData(
                            touchResponseStreamSink:
                                pieTouchedResultStreamController.sink),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSections),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Indicator(
                  color: Color(0xfff44336),
                  text: "Expenses [${myProject.totalExpenses}]",
                  isSquare: false,
                  size: touchedIndex == 0 ? 18 : 16,
                  textColor: touchedIndex == 0 ? Colors.black : Colors.grey,
                ),
                Indicator(
                  color: Color(0xff4caf50),
                  text: "Income [${myProject.totalIncomes}]",
                  isSquare: false,
                  size: touchedIndex == 1 ? 18 : 16,
                  textColor: touchedIndex == 1 ? Colors.black : Colors.grey,
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ])),
    );
  }
}

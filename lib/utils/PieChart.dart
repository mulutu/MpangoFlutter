import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PieChart();
}
class _PieChart extends State {

  bool toggle = false;
  Map<String, double> dataMap = new Map();
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];

  @override
  void initState() {
    super.initState();
    dataMap.putIfAbsent("Flutter", () => 5);
    dataMap.putIfAbsent("React", () => 3);
    dataMap.putIfAbsent("Xamarin", () => 2);
    dataMap.putIfAbsent("Ionic", () => 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pie Chart"),
      ),
      body: Container(
        child: Center(
          child: PieChart(
            //dataMap: dataMap, //Required parameter
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: togglePieChart,
        child: Icon(Icons.insert_chart),
      ),
    );
  }

  void togglePieChart() {
    setState(() {
      toggle = !toggle;
    });
  }

}
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:mpango/models/Project.dart';
import 'package:mpango/models/ProjectService.dart';
import 'package:mpango/models/Transaction.dart';
import 'package:mpango/CreateTransactionPage.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

class SelectDate extends StatefulWidget {
  var newTrxObj;
  SelectDate({ this.newTrxObj  });
  @override
  _SelectDateState createState() => new _SelectDateState();
}



class _SelectDateState extends State<SelectDate>{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Transaction newTransaction =  new Transaction();

  DateTime _currentDate = DateTime(2019, 2, 3);
  DateTime _currentDate2 = new DateTime.now(); //DateTime(2019, 2, 3);
  String _currentMonth = '';

  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );




  @override
  void initState() {
    super.initState();
    newTransaction = widget.newTrxObj;
    //_getProjectsRecords();
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Date"),
      ),
      //key: _scaffoldKey,
      body: widget_(),
    );
    //
  }


  Widget widget_() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: CalendarCarousel(
        onDayPressed: (DateTime date, List<Event> events) {
          this.setState(() => _currentDate = date);
          print('THIS DAY: ${_currentDate}');
          //events.forEach((event) => print(event.title));
          newTransaction.transactionDate = _currentDate;

          print('TRX DATE SELCTED: ${newTransaction.transactionDate}');

          Navigator.pop(context, newTransaction);

        },
        weekendTextStyle: TextStyle(
          color: Colors.red,
        ),
        thisMonthDayBorderColor: Colors.grey,
        //weekDays: null, /// for pass null when you do not want to render weekDays
        //headerText: Container( /// Example for rendering custom header
        //  child: Text('Custom Header'),
        //),
        //markedDates: _markedDate,
        weekFormat: false,
        //markedDatesMap: _markedDateMap,
        height: 420.0,
        selectedDateTime: _currentDate2,
        //daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
        customGridViewPhysics: NeverScrollableScrollPhysics(),
        markedDateShowIcon: true,
        markedDateIconMaxShown: 2,
        todayTextStyle: TextStyle(
          color: Colors.blue,
        ),
        markedDateIconBuilder: (event) {
          return event.icon;
        },
        todayBorderColor: Colors.green,
        markedDateMoreShowTotal:
        false, // null for not showing hidden events indicator
//          markedDateIconMargin: 9,
//          markedDateIconOffset: 3,
      ),
    );
  }

}
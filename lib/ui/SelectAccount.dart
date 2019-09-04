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

class SelectAccount extends StatefulWidget {
  var newTrxObj;
  SelectAccount({ this.newTrxObj  });
  @override
  _SelectAccountState createState() => new _SelectAccountState();
}



class _SelectAccountState extends State<SelectAccount>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Date"),
      ),
      //key: _scaffoldKey,
      //body: widget_(),
    );
    //
  }

}
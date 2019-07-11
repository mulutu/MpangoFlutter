import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'models/Record.dart';
import 'models/RecordList.dart';
import 'models/RecordService.dart';
import 'DetailsPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  Widget _appBarTitle = new Text(appTitle);
  RecordList _records = new RecordList();
  static RecordList _filteredRecords = new RecordList();

 BuildContext context;

  @override
  void initState() {
    super.initState();
    _records.records = new List();
    _filteredRecords.records = new List();
    _getProjectSummaryRecords();
  }

  void _getProjectSummaryRecords() async {
    RecordList records = await RecordService().loadRecords();
    setState(() {
      for (Record record in records.records) {
        this._records.records.add(record);
        _filteredRecords.records.add(record);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      backgroundColor:
          Colors.white, //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: _buildBody(context), //_buildList(context),
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: _makeBottom(context),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      elevation: 0.1,
      backgroundColor: Colors.teal, //primarySwatch: Colors.teal,
      centerTitle: true,
      title: _appBarTitle,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[_topSection, listSection],
    );
  }

  static final PageController pageController = PageController(initialPage: 0);

  static final _topSection = new SizedBox(
    height: 300.0,
    //width: 300.0,
    child: Card(
      child: PageView(
        reverse: false,
        controller: pageController,
        scrollDirection: true ? Axis.horizontal : Axis.vertical,
        pageSnapping: true,
        children: _filteredRecords.records.map((data) => _buildPageItem(data)).toList(),
        /*children: <Widget>[
          getPageWidget("Page 1", Colors.amber),
          getPageWidget("Page 2", Colors.lightBlue),
          getPageWidget("Page 3", Colors.lime),
        ],*/
      ),
    ),
  );

  static Widget _buildPageItem(Record record) {
    return Container(
      key: ValueKey(record.name),
      //color: Colors.
      child: Center(
          child: Text(
            record.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          )),
    );
  }

  static Widget getPageWidget(String text, MaterialColor backgroundColor) {
    return Container(
      color: backgroundColor,
      child: Center(
          child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      )),
    );
  }

  // -------------------------------
  final topSection = new SizedBox(
    height: 210,
    child: Card(
      child: Column(
        children: [
          ListTile(
            title: Text('1625 Main Street', style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('My City, CA 99984'),
            leading: Icon(
              Icons.restaurant_menu,
              color: Colors.blue[500],
            ),
          ),
          Divider(),
          ListTile(
            title: Text('(408) 555-1212',
                style: TextStyle(fontWeight: FontWeight.w500)),
            leading: Icon(
              Icons.contact_phone,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text('costa@example.com'),
            leading: Icon(
              Icons.contact_mail,
              color: Colors.blue[500],
            ),
          ),
        ],
      ),
    ),
  );

  final topSection__ = new Container(
    child: new Container(
      color: Colors.orange,
      child: FlutterLogo(
        size: 60.0,
      ),
    ),
  );

  static final titles = [
    'bike',
    'boat',
    'bus',
    'car',
    'railway',
    'run',
    'subway',
    'transit',
    'walk'
  ];
  static final icons = [
    Icons.directions_bike,
    Icons.directions_boat,
    Icons.directions_bus,
    Icons.directions_car,
    Icons.directions_railway,
    Icons.directions_run,
    Icons.directions_subway,
    Icons.directions_transit,
    Icons.directions_walk
  ];

  final listSection = new Expanded(
      child: ListView.builder(
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    itemCount: titles.length,
    itemBuilder: (context, index) {
      return Card(
        child: ListTile(
          leading: Icon(icons[index]),
          title: Text(titles[index]),
        ),
      );
    },
  ));

  Widget _buildBody_(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.orange,
          child: FlutterLogo(
            size: 60.0,
          ),
        ),
        Container(
          color: Colors.blue,
          child: FlutterLogo(
            size: 60.0,
          ),
        ),
        Container(
          color: Colors.purple,
          child: FlutterLogo(
            size: 60.0,
          ),
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    final titles = [
      'bike',
      'boat',
      'bus',
      'car',
      'railway',
      'run',
      'subway',
      'transit',
      'walk'
    ];

    final icons = [
      Icons.directions_bike,
      Icons.directions_boat,
      Icons.directions_bus,
      Icons.directions_car,
      Icons.directions_railway,
      Icons.directions_run,
      Icons.directions_subway,
      Icons.directions_transit,
      Icons.directions_walk
    ];

    return ListView.builder(
      itemCount: titles.length,
      itemBuilder: (context, index) {
        return Card(
          //                           <-- Card widget
          child: ListTile(
            leading: Icon(icons[index]),
            title: Text(titles[index]),
          ),
        );
      },
    );
  }

  Widget _makeBottom(BuildContext context) {
    return Container(
      height: 55.0,
      child: BottomAppBar(
        color: Colors.teal, //Color.fromRGBO(58, 66, 86, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.blur_on, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.hotel, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.account_box, color: Colors.white),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

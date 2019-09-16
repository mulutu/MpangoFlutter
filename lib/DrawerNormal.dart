import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'helpers/Constants.dart';

class DrawerNormal extends StatelessWidget {
  DrawerNormal();

  @override
  Widget build(BuildContext context) {

      return Drawer(
        child: ListView(
          dragStartBehavior: DragStartBehavior.down,
          children: <Widget>[
            const DrawerHeader(child: Center(child: Text('FarmMgt'))),
            const ListTile(
              leading: Icon(Icons.assessment),
              title: Text('Stock List'),
              selected: true,
            ),
            const ListTile(
              leading: Icon(Icons.account_balance),
              title: Text('Account Balance'),
              enabled: false,
            ),
            ListTile(
              leading: const Icon(Icons.dvr),
              title: const Text('Dump App to Console'),
              onTap: () {
                try {
                  debugDumpApp();
                  debugDumpRenderTree();
                  debugDumpLayerTree();
                  //debugDumpSemanticsTree(DebugSemanticsDumpOrder.traversalOrder);
                } catch (e, stack) {
                  debugPrint('Exception while dumping app:\n$e\n$stack');
                }
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.thumb_up),
              title: const Text('Tasks'),
              //trailing: Radio<StockMode>(
              //value: StockMode.optimistic,
              //groupValue: widget.configuration.stockMode,
              //onChanged: _handleStockModeChange,
              //),
              onTap: () {
                Navigator.of(context).pushNamed(userTasksPageTag);
              },
            ),
            ListTile(
              leading: const Icon(Icons.thumb_down),
              title: const Text('Pessimistic'),
              //trailing: Radio<String>(
              //value: StockMode.pessimistic,
              //groupValue: Widget.configuration.stockMode,
              //onChanged: _handleStockModeChange,
              //),
              onTap: () {
                //_handleStockModeChange(StockMode.pessimistic);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              //onTap: _handleShowSettings,
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('About'),
              //onTap: _handleShowAbout,
            ),
          ],
        ),
      );
    }

}
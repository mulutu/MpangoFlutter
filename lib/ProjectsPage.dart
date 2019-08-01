import 'package:flutter/material.dart';
import 'models/Project.dart';
import 'models/ProjectService.dart';
import 'FloatingButtonsProjects.dart';

class ProjectsPage extends StatelessWidget {

  ProjectsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Project>>(
        future: ProjectService.fetchProjects_static(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return snapshot.hasData
            ? ListViewProjects_(projects: snapshot.data)
            : Center(child: CircularProgressIndicator());
        }
      ),
      floatingActionButton: FloatingButtonsProjects(),
    );
  }

  Widget ListViewProjects_({List<Project> projects}) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, position) {
          return GestureDetector(
            onTap: () => _onTapItem(context, projects[position]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(height: 1.0),
                ListTile(
                  title: Text('${projects[position].ProjectName}', ),
                  subtitle: Text('${projects[position].Description}', ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ],
            )
          );
        }
      ),
    );
  }

  void _onTapItem(BuildContext context, Project project) {
    //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(transaction.amount.toString() + ' - ' + transaction.amount.toString())));
    //Navigator.push( context, new MaterialPageRoute( builder: (context) => DetailsPage(newTrxObject:project))  );
  }

}
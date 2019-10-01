import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mpango/AppState.dart';
import 'package:mpango/views/login/LoginInputForm.dart';
import 'package:mpango/models/login/LoginViewModel.dart';
import 'package:mpango/views/error/ErrorDialog.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title, this.viewModel}) : super(key: key);

  final String title;
  LoginViewModel viewModel;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  loginUser(String username, String password) {
    widget.viewModel.login(username, password);
  }

  Widget getLoadingIndicator(LoginViewModel viewModel) {
    if (viewModel.isLoading) {
      return new CircularProgressIndicator();
    }

    return new Container();
  }

  showLoginError() {
    showDialog(
        context: context, builder: (BuildContext context) => ErrorDialog());
  }

  Widget buildContent(LoginViewModel viewModel) {
    widget.viewModel = viewModel;
    return new Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 150.0),
            //child: Image.asset("assets/images/logo.png", width: 300, height: 150, ),
            child: new Image(
                width: 250.0,
                height: 180.0,
                fit: BoxFit.fill,
                image: new AssetImage('assets/images/logo.png')),

          ),
          getLoadingIndicator(viewModel),
          LoginInputForm(onLoginValidationSuccess: loginUser),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: new StoreConnector<AppState, LoginViewModel>(
            converter: (store) => LoginViewModel.fromStore(store),
            builder: (_, viewModel) => buildContent(viewModel),
            onDidChange: (viewModel) {
              if (viewModel.loginError) {
                showLoginError();
              }
            },
          )),
    );
  }
}
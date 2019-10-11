import 'package:flutter/material.dart';
import 'dart:io';

// Colors
Color appDarkGreyColor = Color.fromRGBO(58, 66, 86, 1.0);
Color appGreyColor = Color.fromRGBO(64, 75, 96, .9);

// Strings
const appTitle = "Mpango";
const pinCodeHintText = "Pin Code";
const loginButtonText = "Login";

// Images
Image appLogo = Image.asset('assets/images/flutter-logo-round.png');

// Sizes
const bigRadius = 66.0;
const buttonHeight = 24.0;

// Pages
const loginPageTag = 'Login Page';
const homePageTag = 'Home Page';
const createTransactionPageTag = 'Create Transaction Page';
const userTasksPageTag = 'User Tasks Page';

const _API_KEY = "somerandomkey";
const HEADERS = {HttpHeaders.contentTypeHeader: 'application/json'}; //{'Content-Type': 'application/json'};
const BASE_URL = "http://45.56.73.81:8084/Mpango/api/v1/";

const LOGIN_URL = BASE_URL + "/login";
import 'AccountList.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'ChartOfAccounts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/foundation.dart';

class ChartOfAccountsService {
  static const _serviceUrlGetUserChartOfAccounts = "http://45.56.73.81:8084/Mpango/api/v1/users/1/coa";
  static final _headers = {'Content-Type': 'application/json'};

  /////////// FETCH PROJECTS /////////////////
  Future<List<ChartOfAccounts>> fetchChartOfAccounts() async {
    final response = await http.get(
      _serviceUrlGetUserChartOfAccounts, headers: _headers,);
    print('response.body-accounts : ${response.body}');
    return compute(parseChartOfAccounts, response.body);
  }

  static List<ChartOfAccounts> parseChartOfAccounts(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ChartOfAccounts>((json) => ChartOfAccounts.fromJson(json)).toList();
  }
}

/*
* [
    {
        "listOfAccounts": [
            {
                "id": 2,
                "description": "Cash at Bank",
                "userId": 1,
                "accountTypeCode": "1000",
                "accountTypeName": "Cash and Bank",
                "accountGroupTypeCode": "1000",
                "accountGroupTypeId": 1,
                "accountGroupTypeName": "Assets",
                "accountName": "Cash at Bank",
                "accountCode": "163459",
                "accountTypeId": 1
            },
            {
                "id": 3,
                "description": "M-Pesa",
                "userId": 1,
                "accountTypeCode": "1000",
                "accountTypeName": "Cash and Bank",
                "accountGroupTypeCode": "1000",
                "accountGroupTypeId": 1,
                "accountGroupTypeName": "Assets",
                "accountName": "M-Pesa",
                "accountCode": "163458",
                "accountTypeId": 1
            }
        ],
        "accountGroupTypeCode": "1000",
        "accountGroupTypeId": 1,
        "accountGroupTypeName": "Assets"
    },
    {
        "listOfAccounts": [],
        "accountGroupTypeCode": "2000",
        "accountGroupTypeId": 2,
        "accountGroupTypeName": "Liabilities"
    },
    {
        "listOfAccounts": [],
        "accountGroupTypeCode": "3000",
        "accountGroupTypeId": 3,
        "accountGroupTypeName": "Equity"
    },
    {
        "listOfAccounts": [
            {
                "id": 1,
                "description": "Sales",
                "userId": 1,
                "accountTypeCode": "4000",
                "accountTypeName": "Income Accounts",
                "accountGroupTypeCode": "4000",
                "accountGroupTypeId": 4,
                "accountGroupTypeName": "Revenue",
                "accountName": "Sales",
                "accountCode": "163859",
                "accountTypeId": 17
            }
        ],
        "accountGroupTypeCode": "4000",
        "accountGroupTypeId": 4,
        "accountGroupTypeName": "Revenue"
    },
    {
        "listOfAccounts": [
            {
                "id": 4,
                "description": "Wages",
                "userId": 1,
                "accountTypeCode": "5090",
                "accountTypeName": "Wages",
                "accountGroupTypeCode": "5000",
                "accountGroupTypeId": 5,
                "accountGroupTypeName": "Expenses",
                "accountName": "Wages",
                "accountCode": "123458",
                "accountTypeId": 21
            }
        ],
        "accountGroupTypeCode": "5000",
        "accountGroupTypeId": 5,
        "accountGroupTypeName": "Expenses"
    }
]
* */
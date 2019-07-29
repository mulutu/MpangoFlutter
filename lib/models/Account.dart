class Account {
  int id;
  String accountName;
  String accountCode;
  int accountTypeId;
  String description;
  //int userId;
  //String accountTypeCode;
  //String accountTypeName;
  //String accountGroupTypeCode;
  //int accountGroupTypeId;
  //String accountGroupTypeName;

  Account({
    this.id,
    this.accountName,
    this.accountCode,
    this.accountTypeId,
    this.description
  });

  factory Account.fromJson(Map<String, dynamic> json){
    return new Account(
        id: json['id'],
        accountName: json['accountName'],
        accountCode: json ['accountCode'],
        accountTypeId: json['accountTypeId'],
        description: json['description']
    );
  }
}
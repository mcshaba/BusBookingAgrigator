// To parse this JSON data, do
//
//     final postTransaction = postTransactionFromJson(jsonString);

import 'dart:convert';

PostTransaction postTransactionFromJson(String str) => PostTransaction.fromJson(json.decode(str));

String postTransactionToJson(PostTransaction data) => json.encode(data.toJson());

class PostTransaction {
  String currency;
  String merchantRef;
  int amount;
  String description;
  String customerId;
  String customerName;
  String customerEmail;
  String customerMobile;
  String returnUrl;
  String integrationkey;

  PostTransaction({
    this.currency,
    this.merchantRef,
    this.amount,
    this.description,
    this.customerId,
    this.customerName,
    this.customerEmail,
    this.customerMobile,
    this.returnUrl,
    this.integrationkey,
  });

  factory PostTransaction.fromJson(Map<String, dynamic> json) => new PostTransaction(
    currency: json["currency"] == null ? null : json["currency"],
    merchantRef: json["merchantRef"] == null ? null : json["merchantRef"],
    amount: json["amount"] == null ? null : json["amount"],
    description: json["description"] == null ? null : json["description"],
    customerId: json["customerId"] == null ? null : json["customerId"],
    customerName: json["customerName"] == null ? null : json["customerName"],
    customerEmail: json["customerEmail"] == null ? null : json["customerEmail"],
    customerMobile: json["customerMobile"] == null ? null : json["customerMobile"],
    returnUrl: json["returnUrl"] == null ? null : json["returnUrl"],
    integrationkey: json["integrationkey"] == null ? null : json["integrationkey"],
  );

  Map<String, dynamic> toJson() => {
    "currency": currency == null ? null : currency,
    "merchantRef": merchantRef == null ? null : merchantRef,
    "amount": amount == null ? null : amount,
    "description": description == null ? null : description,
    "customerId": customerId == null ? null : customerId,
    "customerName": customerName == null ? null : customerName,
    "customerEmail": customerEmail == null ? null : customerEmail,
    "customerMobile": customerMobile == null ? null : customerMobile,
    "returnUrl": returnUrl == null ? null : returnUrl,
    "integrationkey": integrationkey == null ? null : integrationkey,
  };
}

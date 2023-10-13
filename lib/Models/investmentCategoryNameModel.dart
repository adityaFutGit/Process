
import 'dart:convert';

// InvestmentListDeduction listFromMap(String str) =>
//     InvestmentListDeduction.fromJson(json.decode(str));

// String listToMap(InvestmentListDeduction data) => json.encode(data.toJson());

class InvestmentListDeduction {
  int? id;
  String? name;
  String? description;
  int? amount;
  int? categoryId;
  String? financialYear;
  String? status;
  String? documentUrl;
  int? employeeSalaryId;

  InvestmentListDeduction(
    this.id,
    this.name,
    this.description,
    this.amount,
    this.categoryId,
    this.financialYear,
    this.status,
    this.documentUrl,
    this.employeeSalaryId,
  );
  @override
  String toString() {
    return '{${this.id},${this.name},${this.description},${this.amount},${this.categoryId},${this.financialYear},${this.status},${this.documentUrl},${this.employeeSalaryId}}';
  }
  // InvestmentListDeduction.fromJson(Map<String, dynamic> json)
  //     : id = json['id'] as int?,
  //       name = json['name'] as String?,
  //       description = json['description'] as String?,
  //       amount = json['amount'] as int?,
  //       categoryId = json['categoryId'] as int?,
  //       financialYear = json['financialYear'] as String?,
  //       status = json['status'] as String?,
  //       documentUrl = json['documentUrl'] as String?,
  //       employeeSalaryId = json['employeeSalaryId'] as int?,
  //       createdAt = json['createdAt'] as String?,
  //       updatedAt = json['updatedAt'] as String?;

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'name': name,
  //       'description': description,
  //       'amount': amount,
  //       'categoryId': categoryId,
  //       'financialYear': financialYear,
  //       'status': status,
  //       'documentUrl': documentUrl,
  //       'employeeSalaryId': employeeSalaryId,
  //       'createdAt': createdAt,
  //       'updatedAt': updatedAt
  //     };
}

class CategoryName {
  String name;
  int id;

  CategoryName(this.name, this.id);

  @override
  String toString() {
    return '{ ${this.name}, ${this.id} }';
  }
}

class InvestmentName {
  String name;
  int id;
  String description;

  InvestmentName(this.name, this.id, this.description);

  @override
  String toString() {
    return '{ ${this.name}, ${this.id}, ${this.description} }';
  }
}

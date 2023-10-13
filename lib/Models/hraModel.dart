import 'dart:convert';

// InvestmentListDeduction listFromMap(String str) =>
//     InvestmentListDeduction.fromJson(json.decode(str));

// String listToMap(InvestmentListDeduction data) => json.encode(data.toJson());

class HraListDeduction {
  int? id;
  int? amount;
  String? address;
  String? dateStart;
  String? dateEnd;
  String? financialYear;
  String? description;
  String? landloardPAN;
  int? categoryId;
  int? stateId;
  int? cityId;
  String? status;
  String? documentUrl;
  int? employeeSalaryId;

  HraListDeduction(
    this.id,
    this.amount,
    this.address,
    this.dateStart,
    this.dateEnd,
    this.financialYear,
    this.description,
    this.landloardPAN,
    this.categoryId,
    this.stateId,
    this.cityId,
    this.status,
    this.documentUrl,
    this.employeeSalaryId,
  );
  @override
  String toString() {
    return '{${this.id},${this.amount},${this.address},${this.dateStart},${this.dateEnd},${this.financialYear},${this.description},${this.landloardPAN},${this.categoryId},${this.stateId},${this.cityId},${this.status},${this.documentUrl},${this.employeeSalaryId}}';
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

class CategoryNameHRA {
  String name;
  int id;

  CategoryNameHRA(this.name, this.id);

  @override
  String toString() {
    return '{ ${this.name}, ${this.id} }';
  }
}

class HraName {
  String name;
  int id;
  String description;

  HraName(this.name, this.id, this.description);

  @override
  String toString() {
    return '{ ${this.name}, ${this.id}, ${this.description} }';
  }
}

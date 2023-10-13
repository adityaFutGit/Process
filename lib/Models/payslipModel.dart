// ignore_for_file: file_names

import 'dart:convert';

PayslipModel payModelFromMap(dynamic str) =>
    PayslipModel.fromJson(json.decode(str));

dynamic payModelToMap(PayslipModel data) => json.encode(data.toJson());

class PayslipModel {
  int? id;
  String? totalSalaryRelease;
  String? salaryMonth;
  String? salaryYear;
  String? releaseDate;
  String? presentDays;
  String? payableDays;
  String? absentDays;
  String? tDS;
  String? status;
  int? employeeSalaryId;
  List<EarningComponent>? earningComponent;
  EmployeeInfo? employeeInfo;

  PayslipModel({
    this.id,
    this.totalSalaryRelease,
    this.salaryMonth,
    this.salaryYear,
    this.releaseDate,
    this.presentDays,
    this.payableDays,
    this.absentDays,
    this.tDS,
    this.status,
    this.employeeSalaryId,
    this.earningComponent,
    this.employeeInfo,
  });

  PayslipModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    totalSalaryRelease = json['totalSalaryRelease'] as String?;
    salaryMonth = json['salaryMonth'] as String?;
    salaryYear = json['salaryYear'] as String?;
    releaseDate = json['releaseDate'] as String?;
    presentDays = json['presentDays'] as String?;
    payableDays = json['payableDays'] as String?;
    absentDays = json['absentDays'] as String?;
    tDS = json['TDS'] as String?;
    status = json['status'] as String?;
    employeeSalaryId = json['employeeSalaryId'] as int?;
    earningComponent = (json['earningComponent'] as List?)
        ?.map(
            (dynamic e) => EarningComponent.fromJson(e as Map<String, dynamic>))
        .toList();
    employeeInfo = (json['EmployeeInfo'] as Map<String, dynamic>?) != null
        ? EmployeeInfo.fromJson(json['EmployeeInfo'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['totalSalaryRelease'] = totalSalaryRelease;
    json['salaryMonth'] = salaryMonth;
    json['salaryYear'] = salaryYear;
    json['releaseDate'] = releaseDate;
    json['presentDays'] = presentDays;
    json['payableDays'] = payableDays;
    json['absentDays'] = absentDays;
    json['TDS'] = tDS;
    json['status'] = status;
    json['employeeSalaryId'] = employeeSalaryId;
    json['earningComponent'] =
        earningComponent?.map((e) => e.toJson()).toList();
    json['EmployeeInfo'] = employeeInfo?.toJson();
    return json;
  }
}

class EarningComponent {
  int? id;
  String? value;
  String? name;
  dynamic employeeSalaryComponentId;
  int? statuaryComplainceId;

  EarningComponent({
    this.id,
    this.value,
    this.name,
    this.employeeSalaryComponentId,
    this.statuaryComplainceId,
  });

  EarningComponent.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    value = json['value'] as String?;
    name = json['name'] as String?;
    employeeSalaryComponentId = json['employeeSalaryComponentId'];
    statuaryComplainceId = json['statuaryComplainceId'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['value'] = value;
    json['name'] = name;
    json['employeeSalaryComponentId'] = employeeSalaryComponentId;
    json['statuaryComplainceId'] = statuaryComplainceId;
    return json;
  }
}

class EmployeeInfo {
  String? employmentType;
  String? ctcValue;
  bool? isActive;
  EmployeeInfoo? employeeInfo;

  EmployeeInfo({
    this.employmentType,
    this.ctcValue,
    this.isActive,
    this.employeeInfo,
  });

  EmployeeInfo.fromJson(Map<String, dynamic> json) {
    employmentType = json['employmentType'] as String?;
    ctcValue = json['ctcValue'] as String?;
    isActive = json['isActive'] as bool?;
    employeeInfo = (json['employeeInfo'] as Map<String, dynamic>?) != null
        ? EmployeeInfoo.fromJson(json['employeeInfo'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['employmentType'] = employmentType;
    json['ctcValue'] = ctcValue;
    json['isActive'] = isActive;
    json['employeeInfo'] = employeeInfo?.toJson();
    return json;
  }
}

class EmployeeInfoo {
  String? employeeCode;
  String? gender;
  String? fatherName;
  String? dateOfBirth;
  dynamic onRollEmployeeCode;
  String? offRollEmployeeCode;
  OffRollCompany? offRollCompany;
  OnRollCompany? onRollCompany;
  Employee? employee;
  dynamic employeeOnrollment;
  EmployeeOffrollment? employeeOffrollment;
  List<Addresses>? addresses;
  Finance? finance;
  List<Documents>? documents;

  EmployeeInfoo({
    this.employeeCode,
    this.gender,
    this.fatherName,
    this.dateOfBirth,
    this.onRollEmployeeCode,
    this.offRollEmployeeCode,
    this.offRollCompany,
    this.onRollCompany,
    this.employee,
    this.employeeOnrollment,
    this.employeeOffrollment,
    this.addresses,
    this.finance,
    this.documents,
  });

  EmployeeInfoo.fromJson(Map<String, dynamic> json) {
    employeeCode = json['employeeCode'] as String?;
    gender = json['gender'] as String?;
    fatherName = json['fatherName'] as String?;
    dateOfBirth = json['dateOfBirth'] as String?;
    onRollEmployeeCode = json['onRollEmployeeCode'];
    offRollEmployeeCode = json['offRollEmployeeCode'] as String?;
    offRollCompany = (json['offRollCompany'] as Map<String, dynamic>?) != null
        ? OffRollCompany.fromJson(
            json['offRollCompany'] as Map<String, dynamic>)
        : null;
    onRollCompany = (json['onRollCompany'] as Map<String, dynamic>?) != null
        ? OnRollCompany.fromJson(json['onRollCompany'] as Map<String, dynamic>)
        : null;
    employee = (json['employee'] as Map<String, dynamic>?) != null
        ? Employee.fromJson(json['employee'] as Map<String, dynamic>)
        : null;
    employeeOnrollment = json['employeeOnrollment'];
    employeeOffrollment =
        (json['employeeOffrollment'] as Map<String, dynamic>?) != null
            ? EmployeeOffrollment.fromJson(
                json['employeeOffrollment'] as Map<String, dynamic>)
            : null;
    addresses = (json['addresses'] as List?)
        ?.map((dynamic e) => Addresses.fromJson(e as Map<String, dynamic>))
        .toList();
    finance = (json['finance'] as Map<String, dynamic>?) != null
        ? Finance.fromJson(json['finance'] as Map<String, dynamic>)
        : null;
    documents = (json['documents'] as List?)
        ?.map((dynamic e) => Documents.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['employeeCode'] = employeeCode;
    json['gender'] = gender;
    json['fatherName'] = fatherName;
    json['dateOfBirth'] = dateOfBirth;
    json['onRollEmployeeCode'] = onRollEmployeeCode;
    json['offRollEmployeeCode'] = offRollEmployeeCode;
    json['offRollCompany'] = offRollCompany?.toJson();
    json['onRollCompany'] = onRollCompany?.toJson();
    json['employee'] = employee?.toJson();
    json['employeeOnrollment'] = employeeOnrollment;
    json['employeeOffrollment'] = employeeOffrollment?.toJson();
    json['addresses'] = addresses?.map((e) => e.toJson()).toList();
    json['finance'] = finance?.toJson();
    json['documents'] = documents?.map((e) => e.toJson()).toList();
    return json;
  }
}

class OffRollCompany {
  String? companyName;
  String? companyEmail;
  String? cinNum;
  String? legalStatus;

  OffRollCompany({
    this.companyName,
    this.companyEmail,
    this.cinNum,
    this.legalStatus,
  });

  OffRollCompany.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'] as String?;
    companyEmail = json['companyEmail'] as String?;
    cinNum = json['cinNum'] as String?;
    legalStatus = json['legalStatus'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['companyName'] = companyName;
    json['companyEmail'] = companyEmail;
    json['cinNum'] = cinNum;
    json['legalStatus'] = legalStatus;
    return json;
  }
}

class OnRollCompany {
  String? companyName;
  String? companyEmail;
  String? cinNum;
  String? legalStatus;

  OnRollCompany({
    this.companyName,
    this.companyEmail,
    this.cinNum,
    this.legalStatus,
  });

  OnRollCompany.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'] as String?;
    companyEmail = json['companyEmail'] as String?;
    cinNum = json['cinNum'] as String?;
    legalStatus = json['legalStatus'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['companyName'] = companyName;
    json['companyEmail'] = companyEmail;
    json['cinNum'] = cinNum;
    json['legalStatus'] = legalStatus;
    return json;
  }
}

class Employee {
  String? fullName;
  String? firstName;
  dynamic lastName;
  String? mobile;
  String? email;

  Employee({
    this.fullName,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
  });

  Employee.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'] as String?;
    firstName = json['firstName'] as String?;
    lastName = json['lastName'];
    mobile = json['mobile'] as String?;
    email = json['email'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['fullName'] = fullName;
    json['firstName'] = firstName;
    json['lastName'] = lastName;
    json['mobile'] = mobile;
    json['email'] = email;
    return json;
  }
}

class EmployeeOffrollment {
  dynamic userRoles;
  dynamic designation;
  dynamic department;
  dynamic joiningDate;
  dynamic thisRoleStartDate;
  dynamic lastWorkingDate;
  dynamic isActive;
  dynamic employeeCode;
  int? onRollEntityId;
  int? offRollEntityId;
  dynamic employeeSalaryId;
  int? employeeDetailId;

  EmployeeOffrollment({
    this.userRoles,
    this.designation,
    this.department,
    this.joiningDate,
    this.thisRoleStartDate,
    this.lastWorkingDate,
    this.isActive,
    this.employeeCode,
    this.onRollEntityId,
    this.offRollEntityId,
    this.employeeSalaryId,
    this.employeeDetailId,
  });

  EmployeeOffrollment.fromJson(Map<String, dynamic> json) {
    userRoles = json['userRoles'];
    designation = json['designation'];
    department = json['department'];
    joiningDate = json['joiningDate'];
    thisRoleStartDate = json['thisRoleStartDate'];
    lastWorkingDate = json['lastWorkingDate'];
    isActive = json['isActive'];
    employeeCode = json['employeeCode'];
    onRollEntityId = json['onRollEntityId'] as int?;
    offRollEntityId = json['offRollEntityId'] as int?;
    employeeSalaryId = json['employeeSalaryId'];
    employeeDetailId = json['employeeDetailId'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['userRoles'] = userRoles;
    json['designation'] = designation;
    json['department'] = department;
    json['joiningDate'] = joiningDate;
    json['thisRoleStartDate'] = thisRoleStartDate;
    json['lastWorkingDate'] = lastWorkingDate;
    json['isActive'] = isActive;
    json['employeeCode'] = employeeCode;
    json['onRollEntityId'] = onRollEntityId;
    json['offRollEntityId'] = offRollEntityId;
    json['employeeSalaryId'] = employeeSalaryId;
    json['employeeDetailId'] = employeeDetailId;
    return json;
  }
}

class Addresses {
  String? addressLine1;
  dynamic addressLine2;
  dynamic countryId;
  int? stateId;
  int? cityId;
  String? pincode;
  dynamic landmark;
  String? addressType;
  int? employeeId;
  Statee? state;
  City? city;

  Addresses({
    this.addressLine1,
    this.addressLine2,
    this.countryId,
    this.stateId,
    this.cityId,
    this.pincode,
    this.landmark,
    this.addressType,
    this.employeeId,
    this.state,
    this.city,
  });

  Addresses.fromJson(Map<String, dynamic> json) {
    addressLine1 = json['addressLine1'] as String?;
    addressLine2 = json['addressLine2'];
    countryId = json['countryId'];
    stateId = json['stateId'] as int?;
    cityId = json['cityId'] as int?;
    pincode = json['pincode'] as String?;
    landmark = json['landmark'];
    addressType = json['addressType'] as String?;
    employeeId = json['employeeId'] as int?;
    state = (json['state'] as Map<String, dynamic>?) != null
        ? Statee.fromJson(json['state'] as Map<String, dynamic>)
        : null;
    city = (json['city'] as Map<String, dynamic>?) != null
        ? City.fromJson(json['city'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['addressLine1'] = addressLine1;
    json['addressLine2'] = addressLine2;
    json['countryId'] = countryId;
    json['stateId'] = stateId;
    json['cityId'] = cityId;
    json['pincode'] = pincode;
    json['landmark'] = landmark;
    json['addressType'] = addressType;
    json['employeeId'] = employeeId;
    json['state'] = state?.toJson();
    json['city'] = city?.toJson();
    return json;
  }
}

class Statee {
  String? name;
  int? countryId;

  Statee({
    this.name,
    this.countryId,
  });

  Statee.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    countryId = json['countryId'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['name'] = name;
    json['countryId'] = countryId;
    return json;
  }
}

class City {
  String? name;
  String? cityCode;
  int? stateId;

  City({
    this.name,
    this.cityCode,
    this.stateId,
  });

  City.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    cityCode = json['cityCode'] as String?;
    stateId = json['stateId'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['name'] = name;
    json['cityCode'] = cityCode;
    json['stateId'] = stateId;
    return json;
  }
}

class Finance {
  dynamic accountHolderName;
  String? accountNumber;
  String? ifscCode;
  dynamic bankName;
  dynamic accountType;
  dynamic branchName;
  dynamic cancelledChequePath;
  dynamic swiftCode;
  dynamic entityId;
  int? employeeId;

  Finance({
    this.accountHolderName,
    this.accountNumber,
    this.ifscCode,
    this.bankName,
    this.accountType,
    this.branchName,
    this.cancelledChequePath,
    this.swiftCode,
    this.entityId,
    this.employeeId,
  });

  Finance.fromJson(Map<String, dynamic> json) {
    accountHolderName = json['accountHolderName'];
    accountNumber = json['accountNumber'] as String?;
    ifscCode = json['ifscCode'] as String?;
    bankName = json['bankName'];
    accountType = json['accountType'];
    branchName = json['branchName'];
    cancelledChequePath = json['cancelledChequePath'];
    swiftCode = json['swiftCode'];
    entityId = json['entityId'];
    employeeId = json['employeeId'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['accountHolderName'] = accountHolderName;
    json['accountNumber'] = accountNumber;
    json['ifscCode'] = ifscCode;
    json['bankName'] = bankName;
    json['accountType'] = accountType;
    json['branchName'] = branchName;
    json['cancelledChequePath'] = cancelledChequePath;
    json['swiftCode'] = swiftCode;
    json['entityId'] = entityId;
    json['employeeId'] = employeeId;
    return json;
  }
}

class Documents {
  dynamic isMandatory;
  dynamic isVerified;
  String? documentName;
  String? documentValue;

  Documents({
    this.isMandatory,
    this.isVerified,
    this.documentName,
    this.documentValue,
  });

  Documents.fromJson(Map<String, dynamic> json) {
    isMandatory = json['isMandatory'];
    isVerified = json['isVerified'];
    documentName = json['documentName'] as String?;
    documentValue = json['documentValue'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['isMandatory'] = isMandatory;
    json['isVerified'] = isVerified;
    json['documentName'] = documentName;
    json['documentValue'] = documentValue;
    return json;
  }
}

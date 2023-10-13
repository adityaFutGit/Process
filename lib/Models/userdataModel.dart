// ignore_for_file: file_names

import 'dart:convert';

UserModel userModelFromMap(dynamic str) => UserModel.fromJson(json.decode(str));

dynamic userModelToMap(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserData? userData;
  String? token;
  String? refreshToken;

  UserModel({this.userData, this.token, this.refreshToken});

  UserModel.fromJson(Map<String, dynamic> json) {
    userData = (json['userData'] as Map<String, dynamic>?) != null
        ? UserData.fromJson(json['userData'] as Map<String, dynamic>)
        : null;
    token = json['token'] as String?;
    refreshToken = json['refreshToken'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['userData'] = userData?.toJson();
    json['token'] = token;
    json['refreshToken'] = refreshToken;
    return json;
  }
}

class UserData {
  String? fullName;
  int? id;
  String? email;
  String? mobile;
  String? password;
  String? firstName;
  String? lastName;
  String? token;
  String? userType;
  dynamic createdBy;
  dynamic updatedBy;
  List<dynamic>? contact;
  Employee? employee;
  dynamic company;

  UserData({
    this.fullName,
    this.id,
    this.email,
    this.mobile,
    this.password,
    this.firstName,
    this.lastName,
    this.token,
    this.userType,
    this.createdBy,
    this.updatedBy,
    this.contact,
    this.employee,
    this.company,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'] as String?;
    id = json['id'] as int?;
    email = json['email'] as String?;
    mobile = json['mobile'] as String?;
    password = json['password'] as String?;
    firstName = json['firstName'] as String?;
    lastName = json['lastName'] as String?;
    token = json['token'] as String?;
    userType = json['userType'] as String?;
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    contact = json['contact'] as List?;
    employee = (json['employee'] as Map<String, dynamic>?) != null
        ? Employee.fromJson(json['employee'] as Map<String, dynamic>)
        : null;
    company = json['company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['fullName'] = fullName;
    json['id'] = id;
    json['email'] = email;
    json['mobile'] = mobile;
    json['password'] = password;
    json['firstName'] = firstName;
    json['lastName'] = lastName;
    json['token'] = token;
    json['userType'] = userType;
    json['createdBy'] = createdBy;
    json['updatedBy'] = updatedBy;
    json['contact'] = contact;
    json['employee'] = employee?.toJson();
    json['company'] = company;
    return json;
  }
}

class Employee {
  String? employeeCode;
  int? id;
  String? education;
  dynamic fatherName;
  dynamic motherName;
  dynamic dateOfBirth;
  String? gender;
  String? employmentType;
  String? bloodGroup;
  String? nomineeName;
  String? nomineeRelation;
  String? emergencyContact;
  String? onRollEmployeeCode;
  String? offRollEmployeeCode;
  bool? attendanceWithMobile;
  bool? attendanceLocationLock;
  int? onRollEntityId;
  int? offRollEntityId;
  int? userId;
  EmployeeOnrollment? employeeOnrollment;
  EmployeeOffrollment? employeeOffrollment;
  List<Addresses>? addresses;
  List<Documents>? documents;
  Finance? finance;
  EmployeeSalary? employeeSalary;

  Employee({
    this.employeeCode,
    this.id,
    this.education,
    this.fatherName,
    this.motherName,
    this.dateOfBirth,
    this.gender,
    this.employmentType,
    this.bloodGroup,
    this.nomineeName,
    this.nomineeRelation,
    this.emergencyContact,
    this.onRollEmployeeCode,
    this.offRollEmployeeCode,
    this.attendanceWithMobile,
    this.attendanceLocationLock,
    this.onRollEntityId,
    this.offRollEntityId,
    this.userId,
    this.employeeOnrollment,
    this.employeeOffrollment,
    this.addresses,
    this.documents,
    this.finance,
    this.employeeSalary,
  });

  Employee.fromJson(Map<String, dynamic> json) {
    employeeCode = json['employeeCode'] as String?;
    id = json['id'] as int?;
    education = json['education'] as String?;
    fatherName = json['fatherName'];
    motherName = json['motherName'];
    dateOfBirth = json['dateOfBirth'];
    gender = json['gender'] as String?;
    employmentType = json['employmentType'] as String?;
    bloodGroup = json['bloodGroup'] as String?;
    nomineeName = json['nomineeName'] as String?;
    nomineeRelation = json['nomineeRelation'] as String?;
    emergencyContact = json['emergencyContact'] as String?;
    onRollEmployeeCode = json['onRollEmployeeCode'] as String?;
    offRollEmployeeCode = json['offRollEmployeeCode'] as String?;
    attendanceWithMobile = json['attendanceWithMobile'] as bool?;
    attendanceLocationLock = json['attendanceLocationLock'] as bool?;
    onRollEntityId = json['onRollEntityId'] as int?;
    offRollEntityId = json['offRollEntityId'] as int?;
    userId = json['userId'] as int?;
    employeeOnrollment =
        (json['employeeOnrollment'] as Map<String, dynamic>?) != null
            ? EmployeeOnrollment.fromJson(
                json['employeeOnrollment'] as Map<String, dynamic>)
            : null;
    employeeOffrollment =
        (json['employeeOffrollment'] as Map<String, dynamic>?) != null
            ? EmployeeOffrollment.fromJson(
                json['employeeOffrollment'] as Map<String, dynamic>)
            : null;
    addresses = (json['addresses'] as List?)
        ?.map((dynamic e) => Addresses.fromJson(e as Map<String, dynamic>))
        .toList();
    documents = (json['documents'] as List?)
        ?.map((dynamic e) => Documents.fromJson(e as Map<String, dynamic>))
        .toList();
    finance = (json['finance'] as Map<String, dynamic>?) != null
        ? Finance.fromJson(json['finance'] as Map<String, dynamic>)
        : null;
    employeeSalary = (json['employeeSalary'] as Map<String, dynamic>?) != null
        ? EmployeeSalary.fromJson(
            json['employeeSalary'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['employeeCode'] = employeeCode;
    json['id'] = id;
    json['education'] = education;
    json['fatherName'] = fatherName;
    json['motherName'] = motherName;
    json['dateOfBirth'] = dateOfBirth;
    json['gender'] = gender;
    json['employmentType'] = employmentType;
    json['bloodGroup'] = bloodGroup;
    json['nomineeName'] = nomineeName;
    json['nomineeRelation'] = nomineeRelation;
    json['emergencyContact'] = emergencyContact;
    json['onRollEmployeeCode'] = onRollEmployeeCode;
    json['offRollEmployeeCode'] = offRollEmployeeCode;
    json['attendanceWithMobile'] = attendanceWithMobile;
    json['attendanceLocationLock'] = attendanceLocationLock;
    json['onRollEntityId'] = onRollEntityId;
    json['offRollEntityId'] = offRollEntityId;
    json['userId'] = userId;
    json['employeeOnrollment'] = employeeOnrollment;
    json['employeeOffrollment'] = employeeOffrollment?.toJson();
    json['addresses'] = addresses?.map((e) => e.toJson()).toList();
    json['documents'] = documents?.map((e) => e.toJson()).toList();
    json['finance'] = finance?.toJson();
    json['employeeSalary'] = employeeSalary?.toJson();
    return json;
  }
}

class EmployeeOffrollment {
  int? id;
  dynamic userRoles;
  String? designation;
  String? department;
  String? joiningDate;
  dynamic thisRoleStartDate;
  dynamic lastWorkingDate;
  dynamic isActive;
  int? assignedLocationId;
  dynamic employeeCode;
  int? onRollEntityId;
  int? offRollEntityId;
  dynamic employeeSalaryId;
  int? employeeDetailId;
  OffRollCompany? offRollCompany;
  Location? location;
  int? reportingManagerId;

  EmployeeOffrollment(
      {this.id,
      this.userRoles,
      this.designation,
      this.department,
      this.joiningDate,
      this.thisRoleStartDate,
      this.lastWorkingDate,
      this.isActive,
      this.assignedLocationId,
      this.employeeCode,
      this.onRollEntityId,
      this.offRollEntityId,
      this.employeeSalaryId,
      this.employeeDetailId,
      this.offRollCompany,
      this.location,
      this.reportingManagerId});

  EmployeeOffrollment.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    userRoles = json['userRoles'];
    designation = json['designation'] as String?;
    department = json['department'] as String?;
    joiningDate = json['joiningDate'] as String?;
    thisRoleStartDate = json['thisRoleStartDate'];
    lastWorkingDate = json['lastWorkingDate'];
    isActive = json['isActive'];
    assignedLocationId = json['assignedLocationId'] as int?;
    employeeCode = json['employeeCode'];
    onRollEntityId = json['onRollEntityId'] as int?;
    offRollEntityId = json['offRollEntityId'] as int?;
    employeeSalaryId = json['employeeSalaryId'];
    employeeDetailId = json['employeeDetailId'] as int?;
    offRollCompany = (json['offRollCompany'] as Map<String, dynamic>?) != null
        ? OffRollCompany.fromJson(
            json['offRollCompany'] as Map<String, dynamic>)
        : null;
    location = (json['location'] as Map<String, dynamic>?) != null
        ? Location.fromJson(json['location'] as Map<String, dynamic>)
        : null;
    reportingManagerId = json['reportingManagerId'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['userRoles'] = userRoles;
    json['designation'] = designation;
    json['department'] = department;
    json['joiningDate'] = joiningDate;
    json['thisRoleStartDate'] = thisRoleStartDate;
    json['lastWorkingDate'] = lastWorkingDate;
    json['isActive'] = isActive;
    json['assignedLocationId'] = assignedLocationId;
    json['employeeCode'] = employeeCode;
    json['onRollEntityId'] = onRollEntityId;
    json['offRollEntityId'] = offRollEntityId;
    json['employeeSalaryId'] = employeeSalaryId;
    json['employeeDetailId'] = employeeDetailId;
    json['offRollCompany'] = offRollCompany?.toJson();
    json['location'] = location?.toJson();
    json['reportingManagerId'] = reportingManagerId;
    return json;
  }
}

class EmployeeOnrollment {
  int? id;
  dynamic userRoles;
  dynamic designation;
  dynamic department;
  dynamic joiningDate;
  dynamic thisRoleStartDate;
  dynamic companyJoiningDate;
  dynamic lastWorkingDate;
  String? empanelmentStatus;
  dynamic assignedOffroll;
  dynamic hasResigned;
  dynamic resignationDate;
  String? employeeCode;
  dynamic assignedLocationId;
  dynamic employeeSalaryId;
  int? onRollEntityId;
  int? employeeDetailId;
  OnRollCompany? onRollCompany;
  Location? location;
  int? reportingManagerId;

  EmployeeOnrollment(
      {this.id,
      this.userRoles,
      this.designation,
      this.department,
      this.joiningDate,
      this.thisRoleStartDate,
      this.companyJoiningDate,
      this.lastWorkingDate,
      this.empanelmentStatus,
      this.assignedOffroll,
      this.hasResigned,
      this.resignationDate,
      this.employeeCode,
      this.assignedLocationId,
      this.employeeSalaryId,
      this.onRollEntityId,
      this.employeeDetailId,
      this.onRollCompany,
      this.location,
      this.reportingManagerId});

  EmployeeOnrollment.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    userRoles = json['userRoles'];
    designation = json['designation'];
    department = json['department'];
    joiningDate = json['joiningDate'];
    thisRoleStartDate = json['thisRoleStartDate'];
    companyJoiningDate = json['companyJoiningDate'];
    lastWorkingDate = json['lastWorkingDate'];
    empanelmentStatus = json['empanelmentStatus'] as String?;
    assignedOffroll = json['assignedOffroll'];
    hasResigned = json['hasResigned'];
    resignationDate = json['resignationDate'];
    employeeCode = json['employeeCode'] as String?;
    assignedLocationId = json['assignedLocationId'];
    employeeSalaryId = json['employeeSalaryId'];
    onRollEntityId = json['onRollEntityId'] as int?;
    employeeDetailId = json['employeeDetailId'] as int?;
    onRollCompany = (json['onRollCompany'] as Map<String, dynamic>?) != null
        ? OnRollCompany.fromJson(json['onRollCompany'] as Map<String, dynamic>)
        : null;
    location = (json['location'] as Map<String, dynamic>?) != null
        ? Location.fromJson(json['location'] as Map<String, dynamic>)
        : null;
    reportingManagerId = json['reportingManagerId'] as int?;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['userRoles'] = userRoles;
    json['designation'] = designation;
    json['department'] = department;
    json['joiningDate'] = joiningDate;
    json['thisRoleStartDate'] = thisRoleStartDate;
    json['companyJoiningDate'] = companyJoiningDate;
    json['lastWorkingDate'] = lastWorkingDate;
    json['empanelmentStatus'] = empanelmentStatus;
    json['assignedOffroll'] = assignedOffroll;
    json['hasResigned'] = hasResigned;
    json['resignationDate'] = resignationDate;
    json['employeeCode'] = employeeCode;
    json['assignedLocationId'] = assignedLocationId;
    json['employeeSalaryId'] = employeeSalaryId;
    json['onRollEntityId'] = onRollEntityId;
    json['employeeDetailId'] = employeeDetailId;
    json['assigned_location_id'] = assignedLocationId;
    json['onRollCompany'] = onRollCompany?.toJson();
    json['location'] = location?.toJson();
    json['reportingManagerId'] = reportingManagerId;
    return json;
  }
}

class OnRollCompany {
  int? id;
  String? name;
  String? cinNum;
  String? legalStatus;
  String? natureOfBusiness;
  String? email;
  String? panNum;
  dynamic linNum;
  int? primaryUserId;
  bool? isVendor;
  bool? isClient;
  bool? isGroupEntity;
  dynamic parentEntityId;

  OnRollCompany({
    this.id,
    this.name,
    this.cinNum,
    this.legalStatus,
    this.natureOfBusiness,
    this.email,
    this.panNum,
    this.linNum,
    this.primaryUserId,
    this.isVendor,
    this.isClient,
    this.isGroupEntity,
    this.parentEntityId,
  });

  OnRollCompany.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        cinNum = json['cinNum'] as String?,
        legalStatus = json['legalStatus'] as String?,
        natureOfBusiness = json['natureOfBusiness'] as String?,
        email = json['email'] as String?,
        panNum = json['panNum'] as String?,
        linNum = json['linNum'],
        primaryUserId = json['primaryUserId'] as int?,
        isVendor = json['isVendor'] as bool?,
        isClient = json['isClient'] as bool?,
        isGroupEntity = json['isGroupEntity'] as bool?,
        parentEntityId = json['parentEntityId'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['cinNum'] = cinNum;
    json['legalStatus'] = legalStatus;
    json['natureOfBusiness'] = natureOfBusiness;
    json['email'] = email;
    json['panNum'] = panNum;
    json['linNum'] = linNum;
    json['primaryUserId'] = primaryUserId;
    json['isVendor'] = isVendor;
    json['isClient'] = isClient;
    json['isGroupEntity'] = isGroupEntity;
    json['parentEntityId'] = parentEntityId;
    json['primary_user_id'] = primaryUserId;
    return json;
  }
}

class Location {
  String? name;
  String? pincode;
  String? addressLine1;
  String? addressLine2;
  dynamic isHQ;
  dynamic locationCode;
  String? geoTag;
  int? id;
  Statee? state;
  Cityy? city;
  dynamic contacts;

  Location({
    this.name,
    this.pincode,
    this.addressLine1,
    this.addressLine2,
    this.isHQ,
    this.locationCode,
    this.geoTag,
    this.id,
    this.state,
    this.city,
    this.contacts,
  });

  Location.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    pincode = json['pincode'] as String?;
    addressLine1 = json['addressLine1'] as String?;
    addressLine2 = json['addressLine2'] as String?;
    isHQ = json['isHQ'];
    locationCode = json['locationCode'];
    geoTag = json['geoTag'] as String?;
    id = json['id'] as int?;
    state = (json['state'] as Map<String, dynamic>?) != null
        ? Statee.fromJson(json['state'] as Map<String, dynamic>)
        : null;
    city = (json['city'] as Map<String, dynamic>?) != null
        ? Cityy.fromJson(json['city'] as Map<String, dynamic>)
        : null;
    contacts = json['contacts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['name'] = name;
    json['pincode'] = pincode;
    json['addressLine1'] = addressLine1;
    json['addressLine2'] = addressLine2;
    json['isHQ'] = isHQ;
    json['locationCode'] = locationCode;
    json['geoTag'] = geoTag;
    json['id'] = id;
    json['state'] = state?.toJson();
    json['city'] = city?.toJson();
    json['contacts'] = contacts;
    return json;
  }
}

class Statee {
  int? id;
  String? name;
  int? countryId;

  Statee({
    this.id,
    this.name,
    this.countryId,
  });

  Statee.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    countryId = json['countryId'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['countryId'] = countryId;
    return json;
  }
}

class Cityy {
  int? id;
  String? name;
  String? cityCode;
  int? stateId;

  Cityy({
    this.id,
    this.name,
    this.cityCode,
    this.stateId,
  });

  Cityy.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    cityCode = json['cityCode'] as String?;
    stateId = json['stateId'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['cityCode'] = cityCode;
    json['stateId'] = stateId;
    return json;
  }
}

class OffRollCompany {
  int? id;
  String? name;
  String? cinNum;
  String? legalStatus;
  String? natureOfBusiness;
  String? email;
  dynamic tanNum;
  dynamic linNum;
  int? primaryUserId;
  bool? isVendor;
  bool? isClient;
  bool? isGroupEntity;
  dynamic parentEntityId;

  OffRollCompany({
    this.id,
    this.name,
    this.cinNum,
    this.legalStatus,
    this.natureOfBusiness,
    this.email,
    this.tanNum,
    this.linNum,
    this.primaryUserId,
    this.isVendor,
    this.isClient,
    this.isGroupEntity,
    this.parentEntityId,
  });

  OffRollCompany.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    cinNum = json['cinNum'] as String?;
    legalStatus = json['legalStatus'] as String?;
    natureOfBusiness = json['natureOfBusiness'] as String?;
    email = json['email'] as String?;
    tanNum = json['tanNum'];
    linNum = json['linNum'];
    primaryUserId = json['primaryUserId'] as int?;
    isVendor = json['isVendor'] as bool?;
    isClient = json['isClient'] as bool?;
    isGroupEntity = json['isGroupEntity'] as bool?;
    parentEntityId = json['parentEntityId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['cinNum'] = cinNum;
    json['legalStatus'] = legalStatus;
    json['natureOfBusiness'] = natureOfBusiness;
    json['email'] = email;
    json['tanNum'] = tanNum;
    json['linNum'] = linNum;
    json['primaryUserId'] = primaryUserId;
    json['isVendor'] = isVendor;
    json['isClient'] = isClient;
    json['isGroupEntity'] = isGroupEntity;
    json['parentEntityId'] = parentEntityId;
    return json;
  }
}

class Addresses {
  int? id;
  String? addressLine1;
  String? addressLine2;
  dynamic countryId;
  int? stateId;
  int? cityId;
  String? pincode;
  String? landmark;
  String? addressType;
  int? employeeId;
  UserState? state;
  City? city;

  Addresses({
    this.id,
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
    id = json['id'] as int?;
    addressLine1 = json['addressLine1'] as String?;
    addressLine2 = json['addressLine2'] as String?;
    countryId = json['countryId'];
    stateId = json['stateId'] as int?;
    cityId = json['cityId'] as int?;
    pincode = json['pincode'] as String?;
    landmark = json['landmark'] as String?;
    addressType = json['addressType'] as String?;
    employeeId = json['employeeId'] as int?;
    state = (json['state'] as Map<String, dynamic>?) != null
        ? UserState.fromJson(json['state'] as Map<String, dynamic>)
        : null;
    city = (json['city'] as Map<String, dynamic>?) != null
        ? City.fromJson(json['city'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
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

class UserState {
  int? id;
  String? name;
  int? countryId;

  UserState({
    this.id,
    this.name,
    this.countryId,
  });

  UserState.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    countryId = json['countryId'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['countryId'] = countryId;
    return json;
  }
}

class City {
  int? id;
  String? name;
  String? cityCode;
  int? stateId;

  City({
    this.id,
    this.name,
    this.cityCode,
    this.stateId,
  });

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    cityCode = json['cityCode'] as String?;
    stateId = json['stateId'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['cityCode'] = cityCode;
    json['stateId'] = stateId;
    return json;
  }
}

class Documents {
  int? id;
  String? documentName;
  String? documentValue;
  dynamic documentExpiry;
  String? documentFrontPath;
  dynamic documentBackPath;
  bool? isMandatory;
  bool? isVerified;
  dynamic vendorEntityId;
  int? documentTypeId;
  int? employeeId;
  DocumentType? documentType;

  Documents({
    this.id,
    this.documentName,
    this.documentValue,
    this.documentExpiry,
    this.documentFrontPath,
    this.documentBackPath,
    this.isMandatory,
    this.isVerified,
    this.vendorEntityId,
    this.documentTypeId,
    this.employeeId,
    this.documentType,
  });

  Documents.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    documentName = json['documentName'] as String?;
    documentValue = json['documentValue'] as String?;
    documentExpiry = json['documentExpiry'];
    documentFrontPath = json['documentFrontPath'] as String?;
    documentBackPath = json['documentBackPath'];
    isMandatory = json['isMandatory'] as bool?;
    isVerified = json['isVerified'] as bool?;
    vendorEntityId = json['vendorEntityId'];
    documentTypeId = json['documentTypeId'] as int?;
    employeeId = json['employeeId'] as int?;
    documentType = (json['DocumentType'] as Map<String, dynamic>?) != null
        ? DocumentType.fromJson(json['DocumentType'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['documentName'] = documentName;
    json['documentValue'] = documentValue;
    json['documentExpiry'] = documentExpiry;
    json['documentFrontPath'] = documentFrontPath;
    json['documentBackPath'] = documentBackPath;
    json['isMandatory'] = isMandatory;
    json['isVerified'] = isVerified;
    json['vendorEntityId'] = vendorEntityId;
    json['documentTypeId'] = documentTypeId;
    json['employeeId'] = employeeId;
    json['DocumentType'] = documentType?.toJson();
    return json;
  }
}

class DocumentType {
  int? id;
  String? documentName;
  String? documentKey;
  bool? documentHasExpiry;
  bool? documentHasBack;
  bool? validCountryId;
  bool? isVendor;
  bool? isCompany;
  bool? isEmployee;

  DocumentType({
    this.id,
    this.documentName,
    this.documentKey,
    this.documentHasExpiry,
    this.documentHasBack,
    this.validCountryId,
    this.isVendor,
    this.isCompany,
    this.isEmployee,
  });

  DocumentType.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    documentName = json['documentName'] as String?;
    documentKey = json['documentKey'] as String?;
    documentHasExpiry = json['documentHasExpiry'] as bool?;
    documentHasBack = json['documentHasBack'] as bool?;
    validCountryId = json['validCountryId'] as bool?;
    isVendor = json['isVendor'] as bool?;
    isCompany = json['isCompany'] as bool?;
    isEmployee = json['isEmployee'] as bool?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['documentName'] = documentName;
    json['documentKey'] = documentKey;
    json['documentHasExpiry'] = documentHasExpiry;
    json['documentHasBack'] = documentHasBack;
    json['validCountryId'] = validCountryId;
    json['isVendor'] = isVendor;
    json['isCompany'] = isCompany;
    json['isEmployee'] = isEmployee;
    return json;
  }
}

class Finance {
  int? id;
  String? accountHolderName;
  String? accountNumber;
  String? ifscCode;
  String? bankName;
  String? accountType;
  String? branchName;
  String? cancelledChequePath;
  String? swiftCode;
  dynamic entityId;
  int? employeeId;

  Finance({
    this.id,
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
    id = json['id'] as int?;
    accountHolderName = json['accountHolderName'] as String?;
    accountNumber = json['accountNumber'] as String?;
    ifscCode = json['ifscCode'] as String?;
    bankName = json['bankName'] as String?;
    accountType = json['accountType'] as String?;
    branchName = json['branchName'] as String?;
    cancelledChequePath = json['cancelledChequePath'] as String?;
    swiftCode = json['swiftCode'] as String?;
    entityId = json['entityId'];
    employeeId = json['employeeId'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
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

class EmployeeSalary {
  int? id;
  String? employmentType;
  String? ctcValue;
  bool? isActive;
  String? startDate;
  String? endDate;
  int? employeeId;
  int? salaryStructureCompanyId;
  int? employeeDetailsId;
  Structure? structure;
  MonthlyEarning? monthlyEarning;
  List<dynamic>? employeeSalaryComponent;

  EmployeeSalary({
    this.id,
    this.employmentType,
    this.ctcValue,
    this.isActive,
    this.startDate,
    this.endDate,
    this.employeeId,
    this.salaryStructureCompanyId,
    this.employeeDetailsId,
    this.structure,
    this.monthlyEarning,
    this.employeeSalaryComponent,
  });

  EmployeeSalary.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    employmentType = json['employmentType'] as String?;
    ctcValue = json['ctcValue'] as String?;
    isActive = json['isActive'] as bool?;
    startDate = json['startDate'] as String?;
    endDate = json['endDate'] as String?;
    employeeId = json['employeeId'] as int?;
    salaryStructureCompanyId = json['salaryStructureCompanyId'] as int?;
    employeeDetailsId = json['employee_details_id'] as int?;
    salaryStructureCompanyId = json['salary_structure_company_id'] as int?;
    structure = (json['structure'] as Map<String, dynamic>?) != null
        ? Structure.fromJson(json['structure'] as Map<String, dynamic>)
        : null;
    monthlyEarning = (json['monthlyEarning'] as Map<String, dynamic>?) != null
        ? MonthlyEarning.fromJson(
            json['monthlyEarning'] as Map<String, dynamic>)
        : null;
    employeeSalaryComponent = json['employeeSalaryComponent'] as List?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['employmentType'] = employmentType;
    json['ctcValue'] = ctcValue;
    json['isActive'] = isActive;
    json['startDate'] = startDate;
    json['endDate'] = endDate;
    json['employeeId'] = employeeId;
    json['salaryStructureCompanyId'] = salaryStructureCompanyId;
    json['employee_details_id'] = employeeDetailsId;
    json['salary_structure_company_id'] = salaryStructureCompanyId;
    json['structure'] = structure?.toJson();
    json['monthlyEarning'] = monthlyEarning?.toJson();
    json['employeeSalaryComponent'] = employeeSalaryComponent;
    return json;
  }
}

class Structure {
  int? id;
  String? structureName;
  String? ctcGross;
  bool? isPfApplicable;
  bool? isPfApplicableAbove15;
  bool? isPfCaelingApplicable;
  bool? isEsicApplicable;
  bool? isLwfApplicable;
  int? companyId;

  Structure({
    this.id,
    this.structureName,
    this.ctcGross,
    this.isPfApplicable,
    this.isPfApplicableAbove15,
    this.isPfCaelingApplicable,
    this.isEsicApplicable,
    this.isLwfApplicable,
    this.companyId,
  });

  Structure.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    structureName = json['structureName'] as String?;
    ctcGross = json['ctcGross'] as String?;
    isPfApplicable = json['isPfApplicable'] as bool?;
    isPfApplicableAbove15 = json['isPfApplicableAbove15'] as bool?;
    isPfCaelingApplicable = json['isPfCaelingApplicable'] as bool?;
    isEsicApplicable = json['isEsicApplicable'] as bool?;
    isLwfApplicable = json['isLwfApplicable'] as bool?;
    companyId = json['companyId'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['structureName'] = structureName;
    json['ctcGross'] = ctcGross;
    json['isPfApplicable'] = isPfApplicable;
    json['isPfApplicableAbove15'] = isPfApplicableAbove15;
    json['isPfCaelingApplicable'] = isPfCaelingApplicable;
    json['isEsicApplicable'] = isEsicApplicable;
    json['isLwfApplicable'] = isLwfApplicable;
    json['companyId'] = companyId;
    return json;
  }
}

class MonthlyEarning {
  int? id;
  dynamic totalSalaryRelease;
  String? salaryMonth;
  String? salaryYear;
  String? releaseDate;
  String? presentDays;
  String? payableDays;
  String? absentDays;
  String? tDS;
  String? status;
  int? employeeSalaryId;

  MonthlyEarning({
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
  });

  MonthlyEarning.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    totalSalaryRelease = json['totalSalaryRelease'];
    salaryMonth = json['salaryMonth'] as String?;
    salaryYear = json['salaryYear'] as String?;
    releaseDate = json['releaseDate'] as String?;
    presentDays = json['presentDays'] as String?;
    payableDays = json['payableDays'] as String?;
    absentDays = json['absentDays'] as String?;
    tDS = json['TDS'] as String?;
    status = json['status'] as String?;
    employeeSalaryId = json['employeeSalaryId'] as int?;
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
    return json;
  }
}

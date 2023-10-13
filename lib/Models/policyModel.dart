// ignore_for_file: file_names

import 'dart:convert';

PolicyModel policyFromMap(String str) => PolicyModel.fromJson(json.decode(str));

String policyToMap(PolicyModel data) => json.encode(data.toJson());

class PolicyModel {
  List<Policy>? policy;
  int? totalCount;

  PolicyModel({
    this.policy,
    this.totalCount,
  });

  PolicyModel.fromJson(Map<String, dynamic> json) {
    policy = (json['policy'] as List?)
        ?.map((dynamic e) => Policy.fromJson(e as Map<String, dynamic>))
        .toList();
    totalCount = json['totalCount'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['policy'] = policy?.map((e) => e.toJson()).toList();
    json['totalCount'] = totalCount;
    return json;
  }
}

class Policy {
  int? id;
  String? name;
  String? description;
  int? companyId;
  String? policyDocumentLink;
  String? createdAt;
  String? updatedAt;

  PolicyLocation? policyLocation;

  Policy({
    this.id,
    this.name,
    this.description,
    this.companyId,
    this.policyDocumentLink,
    this.createdAt,
    this.updatedAt,
    this.policyLocation,
  });

  Policy.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    description = json['description'] as String?;
    companyId = json['companyId'] as int?;
    policyDocumentLink = json['policyDocumentLink'] as String?;
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
    companyId = json['company_id'] as int?;
    policyLocation = (json['policyLocation'] as Map<String, dynamic>?) != null
        ? PolicyLocation.fromJson(
            json['policyLocation'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['description'] = description;
    json['companyId'] = companyId;
    json['policyDocumentLink'] = policyDocumentLink;
    json['createdAt'] = createdAt;
    json['updatedAt'] = updatedAt;
    json['company_id'] = companyId;
    json['policyLocation'] = policyLocation?.toJson();
    return json;
  }
}

class PolicyLocation {
  int? id;
  int? policyId;
  int? locationId;

  PolicyLocation({
    this.id,
    this.policyId,
    this.locationId,
  });

  PolicyLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    policyId = json['policyId'] as int?;
    locationId = json['locationId'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['policyId'] = policyId;
    json['locationId'] = locationId;
    return json;
  }
}

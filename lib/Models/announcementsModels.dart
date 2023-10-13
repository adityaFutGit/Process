// ignore_for_file: file_names

import 'dart:convert';

AnnouncementsModel announceModelFromMap(dynamic str) =>
    AnnouncementsModel.fromJson(json.decode(str));

dynamic announceModelToMap(AnnouncementsModel data) =>
    json.encode(data.toJson());

class AnnouncementsModel {
  int? count;
  List<Rows>? rows;

  AnnouncementsModel({
    this.count,
    this.rows,
  });

  AnnouncementsModel.fromJson(Map<String, dynamic> json) {
    count = json['count'] as int?;
    rows = (json['rows'] as List?)
        ?.map((dynamic e) => Rows.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['count'] = count;
    json['rows'] = rows?.map((e) => e.toJson()).toList();
    return json;
  }
}

class Rows {
  int? id;
  String? subject;
  String? description;
  int? locationId;
  String? attachementPath;
  String? publishDate;
  String? createdAt;
  String? updatedAt;
  int? companyId;

  Rows({
    this.id,
    this.subject,
    this.description,
    this.locationId,
    this.attachementPath,
    this.publishDate,
    this.createdAt,
    this.updatedAt,
    this.companyId,
  });

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    subject = json['subject'] as String?;
    description = json['description'] as String?;
    locationId = json['locationId'] as int?;
    attachementPath = json['attachementPath'] as String?;
    publishDate = json['publishDate'] as String?;
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
    companyId = json['companyId'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['subject'] = subject;
    json['description'] = description;
    json['locationId'] = locationId;
    json['attachementPath'] = attachementPath;
    json['publishDate'] = publishDate;
    json['createdAt'] = createdAt;
    json['updatedAt'] = updatedAt;
    json['companyId'] = companyId;
    return json;
  }
}

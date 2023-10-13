// ignore_for_file: file_names, unnecessary_this, annotate_overrides, unnecessary_question_mark, prefer_void_to_null

class ViewEmp {
  int? id;
  String? email;
  String? education;
  String? firstName;
  String? lastName;
  String? mobile;
  String? designation;
  String? addressLine1;
  String? addressLine2;
  Null? userRoles;
  String? department;
  String? joiningDate;
  Null? thisRoleStartDate;
  Null? companyJoiningDate;
  Null? lastWorkingDate;
  String? pincode;
  String? landmark;
  String? addressType;

  ViewEmp(
      {this.id,
      this.email,
      this.education,
      this.firstName,
      this.lastName,
      this.mobile,
      this.designation,
      this.addressLine1,
      this.addressLine2,
      this.userRoles,
      this.department,
      this.joiningDate,
      this.thisRoleStartDate,
      this.companyJoiningDate,
      this.lastWorkingDate,
      this.pincode,
      this.landmark,
      this.addressType});

  String toString() {
    return '{${this.id},${this.email},${this.education},${this.firstName},${this.lastName},${this.mobile},${this.designation},${this.addressLine1},${this.addressLine2},${this.userRoles},${this.department},${this.joiningDate},${this.thisRoleStartDate},${this.companyJoiningDate},${this.lastWorkingDate},${this.pincode},${this.landmark},${this.addressType}}';
  }
}

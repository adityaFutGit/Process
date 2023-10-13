// ignore_for_file: unnecessary_this, file_names, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_types_as_parameter_names

class AttendanceData {
  DateTime date;
  String status;
  dynamic timeIn;
  dynamic timeOut;
  dynamic workDuration;
  var breaks;
  dynamic breakTotalTime;
  var overTime;
  int employeeId;
  dynamic attendanceRegularisationId;
  dynamic totalNoOfBreaks;
  dynamic attendanceRegularisation;

  AttendanceData(
      this.date,
      this.status,
      this.timeIn,
      this.timeOut,
      this.workDuration,
      this.breaks,
      this.breakTotalTime,
      this.overTime,
      this.employeeId,
      this.attendanceRegularisationId,
      this.totalNoOfBreaks,
      this.attendanceRegularisation,
      t);

  @override
  String toString() {
    return '{${this.date},${this.status},${this.timeIn},${this.timeOut},${this.workDuration},${this.breaks},${this.breakTotalTime},${this.overTime},${this.employeeId},${this.attendanceRegularisationId},${this.totalNoOfBreaks},${this.attendanceRegularisation}}';
  }

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      DateTime.parse(json['date']),
      json['status'],
      json['timeIn'],
      json['timeOut'],
      json['workDuration'],
      json["breaks"],
      json['breakTotalTime'],
      json['overTime'],
      json['employeeId'],
      json['attendanceRegularisationId'],
      json['totalNoOfBreaks'],
      json['attendanceRegularisation'],
      json['attendanceRegularisationId'],
    );
  }

  bool Pstatus(String) {
    if (status == "P") {
      return true;
    } else {
      return false;
    }
  }

  bool Astatus(String) {
    if (status == "A") {
      return true;
    } else {
      return false;
    }
  }

  bool HDstatus(String) {
    if (status == "HD") {
      return true;
    } else {
      return false;
    }
  }

  bool Lstatus(String) {
    if (status == "HL" || status == "PL" || status == "UL" || status == "HDL") {
      return true;
    } else {
      return false;
    }
  }

  bool DOstatus(String) {
    if (status == "DO") {
      return true;
    } else {
      return false;
    }
  }
}

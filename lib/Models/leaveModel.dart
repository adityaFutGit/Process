// ignore_for_file: unnecessary_this, file_names
import 'dart:convert';

class LeaveTypee {
  int id;
  String name;

  LeaveTypee(this.id, this.name);

  @override
  String toString() {
    return '{${this.id},${this.name}}';
  }
}

class LeaveDetailsData {
  int id;
  String status;
  int totalLeavesToConsider;
  String reasonForLeave;
  int employeeId;
  int leaveTypeId;
  String startDateTime;
  String endDateTime;
  String name;
  dynamic leaveRemaining;
  String createdAt;

  LeaveDetailsData(
      this.id,
      this.status,
      this.totalLeavesToConsider,
      this.reasonForLeave,
      this.employeeId,
      this.leaveTypeId,
      this.startDateTime,
      this.endDateTime,
      this.name,
      this.leaveRemaining,
      this.createdAt);

  @override
  String toString() {
    return '{${this.id},${this.status},${this.totalLeavesToConsider},${this.reasonForLeave},${this.employeeId},${this.leaveTypeId},${this.startDateTime},${this.endDateTime},${this.name},${this.leaveRemaining},${this.createdAt}}';
  }
}

class AppliedLeaveData {
  int id;
  String status;
  String reasonForLeave;
  int employeeId;
  int leaveTypeId;
  String startDateTime;
  String endDateTime;
  String name;
  String createdAt;

  AppliedLeaveData(
      this.id,
      this.status,
      this.reasonForLeave,
      this.employeeId,
      this.leaveTypeId,
      this.startDateTime,
      this.endDateTime,
      this.name,
      this.createdAt);

  @override
  String toString() {
    return '{${this.id},${this.status},${this.reasonForLeave},${this.employeeId},${this.leaveTypeId},${this.startDateTime},${this.endDateTime},${this.name},${this.createdAt}}';
  }
}

//Leave Balance

class LeaveBalance {
  final int id;
  var leavesAccruedThisMonth;
  final int leavesTakenThisMonth;
  var leaveRemaining;
  final double leavesMonthOpeningBalance;
  final int month;
  final int year;
  final int leaveTypeId;
  final String name;

  LeaveBalance(
    this.id,
    this.leavesAccruedThisMonth,
    this.leavesTakenThisMonth,
    this.leaveRemaining,
    this.leavesMonthOpeningBalance,
    this.month,
    this.year,
    this.leaveTypeId,
    this.name,
  );

  @override
  String toString() {
    return '{${this.id},${this.leavesAccruedThisMonth},${this.leavesTakenThisMonth},${this.leaveRemaining},${this.leavesMonthOpeningBalance},${this.month},${this.year},${this.leaveTypeId},${this.name}}';
  }
}

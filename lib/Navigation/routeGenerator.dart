// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/annoucements.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/attendance.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/companyPolicies.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/companyProfile.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/dashboard.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/holidayList.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/leave.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/myProfile.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/payroll.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/workProfile.dart';
import 'package:hrcosmoemployee/Screens/fileUpload.dart';
import 'package:hrcosmoemployee/Screens/login/forgot_password_screen.dart';
import 'package:hrcosmoemployee/Screens/login/login_screen.dart';
import 'package:hrcosmoemployee/Screens/login/update_password_screen.dart';
import 'package:hrcosmoemployee/Screens/login/verify_otp_screen.dart';
import 'package:hrcosmoemployee/test.dart';

import '../Screens/medicalCard.dart';

class RouteGenerator {
  static Object generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/LoginScreen':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/ForgotPassword':
        return MaterialPageRoute(builder: (_) => const ForgotPassword());
      case '/VerifyOTP':
        return MaterialPageRoute(builder: (_) => const VerifyOTP());
      case '/UpdatePassword':
        return MaterialPageRoute(builder: (_) => const UpdatePassword());
      case '/DashboardScreen':
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case '/MyProfile':
        return MaterialPageRoute(builder: (_) => const MyProfile());
      case '/Attendance':
        return MaterialPageRoute(builder: (_) => const Attendance());
      case '/CompanyProfile':
        return MaterialPageRoute(builder: (_) => const CompanyProfile());
      // case '/Payroll':
      //   return MaterialPageRoute(builder: (_) => const Payroll());
      case '/HolidayList':
        return MaterialPageRoute(builder: (_) => const HolidayList());
      case '/Leaves':
        return MaterialPageRoute(builder: (_) => const Leaves());
      case '/ApplyLeaves':
        return MaterialPageRoute(builder: (_) => const ApplyLeaves());
      // case '/LeaveDetails':
      //   return MaterialPageRoute(builder: (_) => LeaveDetails());
      // case '/EditLeaveRequest':
      //   return MaterialPageRoute(builder: (_) =>  EditLeaveRequest());
      case '/CompanyPolicies':
        return MaterialPageRoute(builder: (_) => const CompanyPolicies());
      case '/Annoucements':
        return MaterialPageRoute(builder: (_) => const Annoucements());
      case '/WorkProfile':
        return MaterialPageRoute(builder: (_) => const WorkProfile());
      case '/FileUpload':
        return MaterialPageRoute(builder: (_) => const FileUpload());
      // case '/MedicalCard':
      //   return MaterialPageRoute(builder: (_) => const MedicalCard());
      case '/Test':
        return MaterialPageRoute(builder: (_) => const Test());
      default:
        return SystemNavigator.pop();
    }
  }
}

import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'kayitol1_widget.dart' show Kayitol1Widget;
import 'package:flutter/material.dart';

class Kayitol1Model extends FlutterFlowModel<Kayitol1Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode1;
  TextEditingController? emailAddressTextController1;
  String? Function(BuildContext, String?)? emailAddressTextController1Validator;
  // State field(s) for password widget.
  final passwordKey1 = GlobalKey();
  FocusNode? passwordFocusNode1;
  TextEditingController? passwordTextController1;
  String? passwordSelectedOption1;
  late bool passwordVisibility1;
  String? Function(BuildContext, String?)? passwordTextController1Validator;
  // State field(s) for passwordConfirm widget.
  FocusNode? passwordConfirmFocusNode1;
  TextEditingController? passwordConfirmTextController1;
  late bool passwordConfirmVisibility1;
  String? Function(BuildContext, String?)?
      passwordConfirmTextController1Validator;
  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode2;
  TextEditingController? emailAddressTextController2;
  String? Function(BuildContext, String?)? emailAddressTextController2Validator;
  // State field(s) for password widget.
  FocusNode? passwordFocusNode2;
  TextEditingController? passwordTextController2;
  late bool passwordVisibility2;
  String? Function(BuildContext, String?)? passwordTextController2Validator;
  // State field(s) for passwordConfirm widget.
  FocusNode? passwordConfirmFocusNode2;
  TextEditingController? passwordConfirmTextController2;
  late bool passwordConfirmVisibility2;
  String? Function(BuildContext, String?)?
      passwordConfirmTextController2Validator;

  @override
  void initState(BuildContext context) {
    passwordVisibility1 = false;
    passwordConfirmVisibility1 = false;
    passwordVisibility2 = false;
    passwordConfirmVisibility2 = false;
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    emailAddressFocusNode1?.dispose();
    emailAddressTextController1?.dispose();

    passwordFocusNode1?.dispose();

    passwordConfirmFocusNode1?.dispose();
    passwordConfirmTextController1?.dispose();

    emailAddressFocusNode2?.dispose();
    emailAddressTextController2?.dispose();

    passwordFocusNode2?.dispose();
    passwordTextController2?.dispose();

    passwordConfirmFocusNode2?.dispose();
    passwordConfirmTextController2?.dispose();
  }
}

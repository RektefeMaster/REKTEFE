import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'giris1_widget.dart' show Giris1Widget;
import 'package:flutter/material.dart';

class Giris1Model extends FlutterFlowModel<Giris1Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;
  // State field(s) for password widget.
  final passwordKey = GlobalKey();
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  String? passwordSelectedOption;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
  }

  @override
  void dispose() {
    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();

    passwordFocusNode?.dispose();
  }
}

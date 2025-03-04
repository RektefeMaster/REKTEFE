import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'profilolusturma_widget.dart' show ProfilolusturmaWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ProfilolusturmaModel extends FlutterFlowModel<ProfilolusturmaWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TamAd widget.
  FocusNode? tamAdFocusNode;
  TextEditingController? tamAdTextController;
  String? Function(BuildContext, String?)? tamAdTextControllerValidator;
  String? _tamAdTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter the patients full name.';
    }

    return null;
  }

  // State field(s) for aracsahipyas widget.
  FocusNode? aracsahipyasFocusNode;
  TextEditingController? aracsahipyasTextController;
  String? Function(BuildContext, String?)? aracsahipyasTextControllerValidator;
  String? _aracsahipyasTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter an age for the patient.';
    }

    return null;
  }

  // State field(s) for Aracsahiptelefon widget.
  FocusNode? aracsahiptelefonFocusNode;
  TextEditingController? aracsahiptelefonTextController;
  final aracsahiptelefonMask =
      MaskTextInputFormatter(mask: '+# (###) ###-##-##');
  String? Function(BuildContext, String?)?
      aracsahiptelefonTextControllerValidator;
  // State field(s) for aracsahipDogumgun widget.
  FocusNode? aracsahipDogumgunFocusNode;
  TextEditingController? aracsahipDogumgunTextController;
  final aracsahipDogumgunMask = MaskTextInputFormatter(mask: '##/##/####');
  String? Function(BuildContext, String?)?
      aracsahipDogumgunTextControllerValidator;
  String? _aracsahipDogumgunTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter the date of birth of the patient.';
    }

    return null;
  }

  // State field(s) for AracsahipTCKimlik widget.
  FocusNode? aracsahipTCKimlikFocusNode;
  TextEditingController? aracsahipTCKimlikTextController;
  String? Function(BuildContext, String?)?
      aracsahipTCKimlikTextControllerValidator;
  // State field(s) for AracPlaka widget.
  FocusNode? aracPlakaFocusNode;
  TextEditingController? aracPlakaTextController;
  String? Function(BuildContext, String?)? aracPlakaTextControllerValidator;
  // State field(s) for aracyakittip widget.
  String? aracyakittipValue;
  FormFieldController<String>? aracyakittipValueController;
  // State field(s) for aracmarka widget.
  String? aracmarkaValue;
  FormFieldController<String>? aracmarkaValueController;
  // State field(s) for farklmarka widget.
  FocusNode? farklmarkaFocusNode;
  TextEditingController? farklmarkaTextController;
  String? Function(BuildContext, String?)? farklmarkaTextControllerValidator;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {
    tamAdTextControllerValidator = _tamAdTextControllerValidator;
    aracsahipyasTextControllerValidator = _aracsahipyasTextControllerValidator;
    aracsahipDogumgunTextControllerValidator =
        _aracsahipDogumgunTextControllerValidator;
  }

  @override
  void dispose() {
    tamAdFocusNode?.dispose();
    tamAdTextController?.dispose();

    aracsahipyasFocusNode?.dispose();
    aracsahipyasTextController?.dispose();

    aracsahiptelefonFocusNode?.dispose();
    aracsahiptelefonTextController?.dispose();

    aracsahipDogumgunFocusNode?.dispose();
    aracsahipDogumgunTextController?.dispose();

    aracsahipTCKimlikFocusNode?.dispose();
    aracsahipTCKimlikTextController?.dispose();

    aracPlakaFocusNode?.dispose();
    aracPlakaTextController?.dispose();

    farklmarkaFocusNode?.dispose();
    farklmarkaTextController?.dispose();
  }
}

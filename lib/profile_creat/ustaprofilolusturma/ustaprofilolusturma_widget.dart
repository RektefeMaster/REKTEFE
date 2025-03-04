import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'ustaprofilolusturma_model.dart';
export 'ustaprofilolusturma_model.dart';

class UstaprofilolusturmaWidget extends StatefulWidget {
  const UstaprofilolusturmaWidget({super.key});

  static String routeName = 'Ustaprofilolusturma';
  static String routePath = '/ustaprofilolusturma';

  @override
  State<UstaprofilolusturmaWidget> createState() =>
      _UstaprofilolusturmaWidgetState();
}

class _UstaprofilolusturmaWidgetState extends State<UstaprofilolusturmaWidget> {
  late UstaprofilolusturmaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UstaprofilolusturmaModel());

    _model.fullNameTextController ??= TextEditingController();
    _model.fullNameFocusNode ??= FocusNode();
    _model.fullNameFocusNode!.addListener(() => safeSetState(() {}));
    _model.ageTextController ??= TextEditingController();
    _model.ageFocusNode ??= FocusNode();
    _model.ageFocusNode!.addListener(() => safeSetState(() {}));
    _model.phoneNumberTextController ??= TextEditingController();
    _model.phoneNumberFocusNode ??= FocusNode();
    _model.phoneNumberFocusNode!.addListener(() => safeSetState(() {}));
    _model.dateOfBirthTextController ??= TextEditingController();
    _model.dateOfBirthFocusNode ??= FocusNode();
    _model.dateOfBirthFocusNode!.addListener(() => safeSetState(() {}));
    _model.tCKimlikTextController ??= TextEditingController();
    _model.tCKimlikFocusNode ??= FocusNode();
    _model.tCKimlikFocusNode!.addListener(() => safeSetState(() {}));
    _model.dukkanisimTextController ??= TextEditingController();
    _model.dukkanisimFocusNode ??= FocusNode();
    _model.dukkanisimFocusNode!.addListener(() => safeSetState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Form(
            key: _model.formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1615906655593-ad0386982a0f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwzfHxjYXIlMjByZXBhaXJ8ZW58MHx8fHwxNzM3Njk4MTE1fDA&ixlib=rb-4.0.3&q=80&w=1080',
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 12.0, 16.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _model.fullNameTextController,
                                focusNode: _model.fullNameFocusNode,
                                autofocus: true,
                                textCapitalization: TextCapitalization.words,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Tam isim',
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Outfit',
                                        letterSpacing: 0.0,
                                      ),
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF606A85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  errorStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Figtree',
                                        color: Color(0xFFFF5963),
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFE5E7EB),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF6F61EF),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF5963),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF5963),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  filled: true,
                                  fillColor:
                                      (_model.fullNameFocusNode?.hasFocus ??
                                              false)
                                          ? Color(0x4D9489F5)
                                          : Colors.white,
                                  contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          16.0, 20.0, 16.0, 20.0),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Outfit',
                                      letterSpacing: 0.0,
                                    ),
                                cursorColor: Color(0xFF6F61EF),
                                validator: _model
                                    .fullNameTextControllerValidator
                                    .asValidator(context),
                              ),
                              TextFormField(
                                controller: _model.ageTextController,
                                focusNode: _model.ageFocusNode,
                                autofocus: true,
                                textCapitalization: TextCapitalization.words,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Kaç yaşındasın ?',
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Outfit',
                                        letterSpacing: 0.0,
                                      ),
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        letterSpacing: 0.0,
                                      ),
                                  errorStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Figtree',
                                        color: Color(0xFFFF5963),
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFE5E7EB),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF6F61EF),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF5963),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF5963),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  filled: true,
                                  fillColor:
                                      (_model.ageFocusNode?.hasFocus ?? false)
                                          ? Color(0x4D9489F5)
                                          : Colors.white,
                                  contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          16.0, 20.0, 16.0, 20.0),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Figtree',
                                      color: Color(0xFF15161E),
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                cursorColor: Color(0xFF6F61EF),
                                validator: _model.ageTextControllerValidator
                                    .asValidator(context),
                              ),
                              TextFormField(
                                controller: _model.phoneNumberTextController,
                                focusNode: _model.phoneNumberFocusNode,
                                autofocus: true,
                                textCapitalization:
                                    TextCapitalization.characters,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Telefon numarası',
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Outfit',
                                        letterSpacing: 0.0,
                                      ),
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF606A85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  errorStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Figtree',
                                        color: Color(0xFFFF5963),
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFE5E7EB),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF6F61EF),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF5963),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF5963),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  filled: true,
                                  fillColor:
                                      (_model.phoneNumberFocusNode?.hasFocus ??
                                              false)
                                          ? Color(0x4D9489F5)
                                          : Colors.white,
                                  contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          16.0, 20.0, 16.0, 20.0),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Figtree',
                                      color: Color(0xFF15161E),
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                cursorColor: Color(0xFF6F61EF),
                                validator: _model
                                    .phoneNumberTextControllerValidator
                                    .asValidator(context),
                                inputFormatters: [_model.phoneNumberMask],
                              ),
                              TextFormField(
                                controller: _model.dateOfBirthTextController,
                                focusNode: _model.dateOfBirthFocusNode,
                                autofocus: true,
                                textCapitalization: TextCapitalization.words,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Doğum günün',
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Outfit',
                                        letterSpacing: 0.0,
                                      ),
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF606A85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  errorStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Figtree',
                                        color: Color(0xFFFF5963),
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFE5E7EB),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF6F61EF),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF5963),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF5963),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  filled: true,
                                  fillColor:
                                      (_model.dateOfBirthFocusNode?.hasFocus ??
                                              false)
                                          ? Color(0x4D9489F5)
                                          : Colors.white,
                                  contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          16.0, 20.0, 16.0, 20.0),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      letterSpacing: 0.0,
                                    ),
                                cursorColor: Color(0xFF6F61EF),
                                validator: _model
                                    .dateOfBirthTextControllerValidator
                                    .asValidator(context),
                                inputFormatters: [_model.dateOfBirthMask],
                              ),
                              TextFormField(
                                controller: _model.tCKimlikTextController,
                                focusNode: _model.tCKimlikFocusNode,
                                autofocus: true,
                                textCapitalization: TextCapitalization.words,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'TC Kimlik',
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Outfit',
                                        letterSpacing: 0.0,
                                      ),
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF606A85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  errorStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Figtree',
                                        color: Color(0xFFFF5963),
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFE5E7EB),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF6F61EF),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF5963),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF5963),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  filled: true,
                                  fillColor:
                                      (_model.tCKimlikFocusNode?.hasFocus ??
                                              false)
                                          ? Color(0x4D9489F5)
                                          : Colors.white,
                                  contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          16.0, 20.0, 16.0, 20.0),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      letterSpacing: 0.0,
                                    ),
                                cursorColor: Color(0xFF6F61EF),
                                validator: _model
                                    .tCKimlikTextControllerValidator
                                    .asValidator(context),
                              ),
                              TextFormField(
                                controller: _model.dukkanisimTextController,
                                focusNode: _model.dukkanisimFocusNode,
                                autofocus: true,
                                textCapitalization: TextCapitalization.words,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Dükkanın/İşletmenin ismi',
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Outfit',
                                        letterSpacing: 0.0,
                                      ),
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF606A85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  errorStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Figtree',
                                        color: Color(0xFFFF5963),
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFE5E7EB),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF6F61EF),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF5963),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF5963),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  filled: true,
                                  fillColor:
                                      (_model.dukkanisimFocusNode?.hasFocus ??
                                              false)
                                          ? Color(0x4D9489F5)
                                          : Colors.white,
                                  contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          16.0, 20.0, 16.0, 20.0),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      letterSpacing: 0.0,
                                    ),
                                cursorColor: Color(0xFF6F61EF),
                                validator: _model
                                    .dukkanisimTextControllerValidator
                                    .asValidator(context),
                              ),
                              Text(
                                'Ustalık alanın nedir ?',
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF606A85),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              FlutterFlowDropDown<String>(
                                controller: _model.dropDownValueController1 ??=
                                    FormFieldController<String>(
                                  _model.dropDownValue1 ??= '',
                                ),
                                options: List<String>.from(
                                    ['Option 1', '1', '2', '3', '4']),
                                optionLabels: [
                                  'Araç motor ustası',
                                  'Elektirik ustası',
                                  'Kaporta ustası',
                                  'Rot-Balans ustası',
                                  'Araç lastik-teker ustası'
                                ],
                                onChanged: (val) => safeSetState(
                                    () => _model.dropDownValue1 = val),
                                width: double.infinity,
                                height: 52.0,
                                searchHintTextStyle:
                                    FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          fontFamily: 'Outfit',
                                          letterSpacing: 0.0,
                                        ),
                                searchTextStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Figtree',
                                      color: Color(0xFF6F61EF),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                hintText: 'Ustalık alanın ?',
                                searchHintText: 'Birini seçelim !',
                                searchCursorColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: FlutterFlowTheme.of(context).secondary,
                                  size: 24.0,
                                ),
                                fillColor:
                                    FlutterFlowTheme.of(context).alternate,
                                elevation: 2.0,
                                borderColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderWidth: 2.0,
                                borderRadius: 12.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 4.0, 8.0, 4.0),
                                hidesUnderline: true,
                                isOverButton: true,
                                isSearchable: true,
                                isMultiSelect: false,
                              ),
                              AuthUserStreamWidget(
                                builder: (context) =>
                                    FlutterFlowDropDown<String>(
                                  controller:
                                      _model.dropDownValueController2 ??=
                                          FormFieldController<String>(
                                    _model.dropDownValue2 ??= '',
                                  ),
                                  options: List<String>.from(
                                      ['Option 1', '1', '2', '3', '4']),
                                  optionLabels: [
                                    'Benzin',
                                    'Benzin-Tüp',
                                    'Dizel',
                                    'Elektirik',
                                    'Motorbisiklet yada Scotter'
                                  ],
                                  onChanged: (val) => safeSetState(
                                      () => _model.dropDownValue2 = val),
                                  width: double.infinity,
                                  height: 52.0,
                                  searchHintTextStyle:
                                      FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .override(
                                            fontFamily: 'Outfit',
                                            letterSpacing: 0.0,
                                          ),
                                  searchTextStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Figtree',
                                        color: Color(0xFF6F61EF),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  hintText: 'Hangi araçlardan anlarsın ?',
                                  searchHintText: 'Birini seçelim !',
                                  searchCursorColor:
                                      FlutterFlowTheme.of(context).primaryText,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    size: 24.0,
                                  ),
                                  fillColor:
                                      FlutterFlowTheme.of(context).alternate,
                                  elevation: 2.0,
                                  borderColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderWidth: 2.0,
                                  borderRadius: 12.0,
                                  margin: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 4.0, 8.0, 4.0),
                                  hidesUnderline: true,
                                  disabled: valueOrDefault(
                                              currentUserDocument?.title, '') !=
                                          '',
                                  isOverButton: true,
                                  isSearchable: true,
                                  isMultiSelect: false,
                                ),
                              ),
                              FlutterFlowDropDown<String>(
                                multiSelectController:
                                    _model.dropDownValueController3 ??=
                                        FormListFieldController<String>(null),
                                options: List<String>.from([
                                  'Option 1',
                                  'Option 2',
                                  'Option 3',
                                  '3',
                                  '4',
                                  '5',
                                  '6',
                                  '7',
                                  '8',
                                  '9',
                                  '10',
                                  '11',
                                  '12',
                                  '13',
                                  '14',
                                  '15',
                                  '16',
                                  '17',
                                  '18',
                                  '19',
                                  '20',
                                  '21',
                                  '22',
                                  '23',
                                  '24',
                                  '25',
                                  '26',
                                  '27',
                                  '28',
                                  '29',
                                  '30'
                                ]),
                                optionLabels: [
                                  'Alfa Romeo',
                                  'Audi',
                                  'BMW',
                                  'Chery',
                                  'Chevrolet',
                                  'Citroen',
                                  'Cupra',
                                  'Dacia',
                                  'Fiat',
                                  'Ford',
                                  'Honda',
                                  'Hyundai',
                                  'KİA',
                                  'Lada',
                                  'Mazda',
                                  'Mercedes BENZ',
                                  'Mini',
                                  'Mitsubishi',
                                  'Nissan',
                                  'Opel',
                                  'Peugeot',
                                  'Porche',
                                  'Renault',
                                  'Seat',
                                  'Skoda',
                                  'TATA',
                                  'Tesla',
                                  'Tofaş',
                                  'Toyota',
                                  'Wolkswagen',
                                  'Volvo'
                                ],
                                width: 400.0,
                                height: 52.0,
                                searchHintTextStyle:
                                    FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .override(
                                          fontFamily: 'Outfit',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          letterSpacing: 0.0,
                                        ),
                                searchTextStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      letterSpacing: 0.0,
                                    ),
                                textStyle: FlutterFlowTheme.of(context)
                                    .labelSmall
                                    .override(
                                      fontFamily: 'Outfit',
                                      letterSpacing: 0.0,
                                    ),
                                hintText:
                                    'Ustasıyım dediğin markalar ? (Birden fazla seçebilirsin)',
                                searchHintText: 'Ara',
                                searchCursorColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: FlutterFlowTheme.of(context).secondary,
                                  size: 24.0,
                                ),
                                fillColor:
                                    FlutterFlowTheme.of(context).alternate,
                                elevation: 2.0,
                                borderColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                borderWidth: 0.0,
                                borderRadius: 8.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 8.0, 12.0, 9.0),
                                hidesUnderline: true,
                                isOverButton: false,
                                isSearchable: true,
                                isMultiSelect: true,
                                onMultiSelectChanged: (val) => safeSetState(
                                    () => _model.dropDownValue3 = val),
                              ),
                              Text(
                                'Cinsiyetiniz',
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF606A85),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              FlutterFlowChoiceChips(
                                options: [ChipData('Erkek'), ChipData('Kadın')],
                                onChanged: (val) => safeSetState(() =>
                                    _model.choiceChipsValue = val?.firstOrNull),
                                selectedChipStyle: ChipStyle(
                                  backgroundColor: Color(0x4C39D2C0),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Figtree',
                                        color: Color(0xFF15161E),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  iconColor: Color(0xFF15161E),
                                  iconSize: 18.0,
                                  elevation: 0.0,
                                  borderColor: Color(0xFF39D2C0),
                                  borderWidth: 2.0,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                unselectedChipStyle: ChipStyle(
                                  backgroundColor: Color(0xFFF1F4F8),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Figtree',
                                        color: Color(0xFF606A85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  iconColor: Color(0xFF606A85),
                                  iconSize: 18.0,
                                  elevation: 0.0,
                                  borderColor: Color(0xFFE5E7EB),
                                  borderWidth: 2.0,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                chipSpacing: 12.0,
                                rowSpacing: 12.0,
                                multiselect: false,
                                alignment: WrapAlignment.start,
                                controller:
                                    _model.choiceChipsValueController ??=
                                        FormFieldController<List<String>>(
                                  [],
                                ),
                                wrapped: true,
                              ),
                            ]
                                .divide(SizedBox(height: 12.0))
                                .addToEnd(SizedBox(height: 32.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 770.0,
                  ),
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        await currentUserDocument!.author!
                            .update(createUsersRecordData(
                          phoneNumber: '',
                          displayName: '',
                          title: '',
                          uid: '',
                        ));
                      },
                      text: 'Kaydı tamamla !',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 48.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        iconAlignment: IconAlignment.start,
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: Color(0xFF6F61EF),
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Figtree',
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                        elevation: 3.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

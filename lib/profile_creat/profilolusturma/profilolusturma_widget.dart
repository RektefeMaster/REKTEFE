import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'profilolusturma_model.dart';
export 'profilolusturma_model.dart';

class ProfilolusturmaWidget extends StatefulWidget {
  const ProfilolusturmaWidget({
    super.key,
    required this.aracmarka,
    required this.markamodel,
  });

  final String? aracmarka;
  final String? markamodel;

  static String routeName = 'profilolusturma';
  static String routePath = '/profilolusturma';

  @override
  State<ProfilolusturmaWidget> createState() => _ProfilolusturmaWidgetState();
}

class _ProfilolusturmaWidgetState extends State<ProfilolusturmaWidget> {
  late ProfilolusturmaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfilolusturmaModel());

    _model.tamAdTextController ??= TextEditingController();
    _model.tamAdFocusNode ??= FocusNode();
    _model.tamAdFocusNode!.addListener(() => safeSetState(() {}));
    _model.aracsahipyasTextController ??= TextEditingController();
    _model.aracsahipyasFocusNode ??= FocusNode();
    _model.aracsahipyasFocusNode!.addListener(() => safeSetState(() {}));
    _model.aracsahiptelefonTextController ??= TextEditingController();
    _model.aracsahiptelefonFocusNode ??= FocusNode();
    _model.aracsahiptelefonFocusNode!.addListener(() => safeSetState(() {}));
    _model.aracsahipDogumgunTextController ??= TextEditingController();
    _model.aracsahipDogumgunFocusNode ??= FocusNode();
    _model.aracsahipDogumgunFocusNode!.addListener(() => safeSetState(() {}));
    _model.aracsahipTCKimlikTextController ??= TextEditingController();
    _model.aracsahipTCKimlikFocusNode ??= FocusNode();
    _model.aracsahipTCKimlikFocusNode!.addListener(() => safeSetState(() {}));
    _model.aracPlakaTextController ??= TextEditingController();
    _model.aracPlakaFocusNode ??= FocusNode();
    _model.aracPlakaFocusNode!.addListener(() => safeSetState(() {}));
    _model.farklmarkaTextController ??= TextEditingController();
    _model.farklmarkaFocusNode ??= FocusNode();
    _model.farklmarkaFocusNode!.addListener(() => safeSetState(() {}));
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
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 12.0, 16.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMXx8Y2FyJTIwZHJpdmVyfGVufDB8fHx8MTczNzM3OTgyM3ww&ixlib=rb-4.0.3&q=80&w=1080',
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _model.tamAdTextController,
                                focusNode: _model.tamAdFocusNode,
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
                                      (_model.tamAdFocusNode?.hasFocus ?? false)
                                          ? Color(0x4D9489F5)
                                          : Colors.white,
                                  contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          16.0, 20.0, 16.0, 20.0),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      letterSpacing: 0.0,
                                    ),
                                cursorColor: Color(0xFF6F61EF),
                                validator: _model.tamAdTextControllerValidator
                                    .asValidator(context),
                              ),
                              TextFormField(
                                controller: _model.aracsahipyasTextController,
                                focusNode: _model.aracsahipyasFocusNode,
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
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
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
                                      (_model.aracsahipyasFocusNode?.hasFocus ??
                                              false)
                                          ? Color(0x4D9489F5)
                                          : Colors.white,
                                  contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          16.0, 20.0, 16.0, 20.0),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      letterSpacing: 0.0,
                                    ),
                                cursorColor: Color(0xFF6F61EF),
                                validator: _model
                                    .aracsahipyasTextControllerValidator
                                    .asValidator(context),
                              ),
                              TextFormField(
                                controller:
                                    _model.aracsahiptelefonTextController,
                                focusNode: _model.aracsahiptelefonFocusNode,
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
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
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
                                  fillColor: (_model.aracsahiptelefonFocusNode
                                              ?.hasFocus ??
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
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                                cursorColor: Color(0xFF6F61EF),
                                validator: _model
                                    .aracsahiptelefonTextControllerValidator
                                    .asValidator(context),
                                inputFormatters: [_model.aracsahiptelefonMask],
                              ),
                              TextFormField(
                                controller:
                                    _model.aracsahipDogumgunTextController,
                                focusNode: _model.aracsahipDogumgunFocusNode,
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
                                      .bodyMedium
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
                                  fillColor: (_model.aracsahipDogumgunFocusNode
                                              ?.hasFocus ??
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
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                    ),
                                cursorColor: Color(0xFF6F61EF),
                                validator: _model
                                    .aracsahipDogumgunTextControllerValidator
                                    .asValidator(context),
                                inputFormatters: [_model.aracsahipDogumgunMask],
                              ),
                              TextFormField(
                                controller:
                                    _model.aracsahipTCKimlikTextController,
                                focusNode: _model.aracsahipTCKimlikFocusNode,
                                autofocus: true,
                                textCapitalization: TextCapitalization.words,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'TC Kimlik no',
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        fontFamily: 'Outfit',
                                        letterSpacing: 0.0,
                                      ),
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Outfit',
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
                                  fillColor: (_model.aracsahipTCKimlikFocusNode
                                              ?.hasFocus ??
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
                                      fontFamily: 'Plus Jakarta Sans',
                                      letterSpacing: 0.0,
                                    ),
                                cursorColor: Color(0xFF6F61EF),
                                validator: _model
                                    .aracsahipTCKimlikTextControllerValidator
                                    .asValidator(context),
                              ),
                              Text(
                                'Araç tipi / Yakıt',
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
                              TextFormField(
                                controller: _model.aracPlakaTextController,
                                focusNode: _model.aracPlakaFocusNode,
                                autofocus: true,
                                textCapitalization: TextCapitalization.words,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Araç Plaka',
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelLarge
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
                                      .bodySmall
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        letterSpacing: 0.0,
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
                                      (_model.aracPlakaFocusNode?.hasFocus ??
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
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                cursorColor: Color(0xFF6F61EF),
                                validator: _model
                                    .aracPlakaTextControllerValidator
                                    .asValidator(context),
                              ),
                              FlutterFlowDropDown<String>(
                                controller:
                                    _model.aracyakittipValueController ??=
                                        FormFieldController<String>(
                                  _model.aracyakittipValue ??= '',
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
                                    () => _model.aracyakittipValue = val),
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
                                hintText: 'Aracının yakıt tipini seçelim',
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
                              FlutterFlowDropDown<String>(
                                controller: _model.aracmarkaValueController ??=
                                    FormFieldController<String>(
                                  _model.aracmarkaValue ??= '',
                                ),
                                options: List<String>.from([
                                  'Fiat',
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
                                onChanged: (val) => safeSetState(
                                    () => _model.aracmarkaValue = val),
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
                                hintText: 'Araç markasını seçelim',
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
                                isMultiSelect: false,
                              ),
                              TextFormField(
                                controller: _model.farklmarkaTextController,
                                focusNode: _model.farklmarkaFocusNode,
                                autofocus: true,
                                textCapitalization: TextCapitalization.words,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText:
                                      'Eğer markan yok ise buraya yazabilirsin !',
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
                                      (_model.farklmarkaFocusNode?.hasFocus ??
                                              false)
                                          ? Color(0x4D9489F5)
                                          : Colors.white,
                                  contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          16.0, 20.0, 16.0, 20.0),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .labelSmall
                                    .override(
                                      fontFamily: 'Outfit',
                                      letterSpacing: 0.0,
                                    ),
                                cursorColor: Color(0xFF6F61EF),
                                validator: _model
                                    .farklmarkaTextControllerValidator
                                    .asValidator(context),
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
                          email: '',
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

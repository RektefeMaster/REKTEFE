// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UstabilgiStruct extends FFFirebaseStruct {
  UstabilgiStruct({
    String? ustaid,
    String? isim,
    List<String>? ustalikAlani,
    String? telefon,
    String? eposta,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _ustaid = ustaid,
        _isim = isim,
        _ustalikAlani = ustalikAlani,
        _telefon = telefon,
        _eposta = eposta,
        super(firestoreUtilData);

  // "ustaid" field.
  String? _ustaid;
  String get ustaid => _ustaid ?? '';
  set ustaid(String? val) => _ustaid = val;

  bool hasUstaid() => _ustaid != null;

  // "isim" field.
  String? _isim;
  String get isim => _isim ?? '';
  set isim(String? val) => _isim = val;

  bool hasIsim() => _isim != null;

  // "UstalikAlani" field.
  List<String>? _ustalikAlani;
  List<String> get ustalikAlani => _ustalikAlani ?? const [];
  set ustalikAlani(List<String>? val) => _ustalikAlani = val;

  void updateUstalikAlani(Function(List<String>) updateFn) {
    updateFn(_ustalikAlani ??= []);
  }

  bool hasUstalikAlani() => _ustalikAlani != null;

  // "Telefon" field.
  String? _telefon;
  String get telefon => _telefon ?? '';
  set telefon(String? val) => _telefon = val;

  bool hasTelefon() => _telefon != null;

  // "Eposta" field.
  String? _eposta;
  String get eposta => _eposta ?? '';
  set eposta(String? val) => _eposta = val;

  bool hasEposta() => _eposta != null;

  static UstabilgiStruct fromMap(Map<String, dynamic> data) => UstabilgiStruct(
        ustaid: data['ustaid'] as String?,
        isim: data['isim'] as String?,
        ustalikAlani: getDataList(data['UstalikAlani']),
        telefon: data['Telefon'] as String?,
        eposta: data['Eposta'] as String?,
      );

  static UstabilgiStruct? maybeFromMap(dynamic data) => data is Map
      ? UstabilgiStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'ustaid': _ustaid,
        'isim': _isim,
        'UstalikAlani': _ustalikAlani,
        'Telefon': _telefon,
        'Eposta': _eposta,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'ustaid': serializeParam(
          _ustaid,
          ParamType.String,
        ),
        'isim': serializeParam(
          _isim,
          ParamType.String,
        ),
        'UstalikAlani': serializeParam(
          _ustalikAlani,
          ParamType.String,
          isList: true,
        ),
        'Telefon': serializeParam(
          _telefon,
          ParamType.String,
        ),
        'Eposta': serializeParam(
          _eposta,
          ParamType.String,
        ),
      }.withoutNulls;

  static UstabilgiStruct fromSerializableMap(Map<String, dynamic> data) =>
      UstabilgiStruct(
        ustaid: deserializeParam(
          data['ustaid'],
          ParamType.String,
          false,
        ),
        isim: deserializeParam(
          data['isim'],
          ParamType.String,
          false,
        ),
        ustalikAlani: deserializeParam<String>(
          data['UstalikAlani'],
          ParamType.String,
          true,
        ),
        telefon: deserializeParam(
          data['Telefon'],
          ParamType.String,
          false,
        ),
        eposta: deserializeParam(
          data['Eposta'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'UstabilgiStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is UstabilgiStruct &&
        ustaid == other.ustaid &&
        isim == other.isim &&
        listEquality.equals(ustalikAlani, other.ustalikAlani) &&
        telefon == other.telefon &&
        eposta == other.eposta;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([ustaid, isim, ustalikAlani, telefon, eposta]);
}

UstabilgiStruct createUstabilgiStruct({
  String? ustaid,
  String? isim,
  String? telefon,
  String? eposta,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    UstabilgiStruct(
      ustaid: ustaid,
      isim: isim,
      telefon: telefon,
      eposta: eposta,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

UstabilgiStruct? updateUstabilgiStruct(
  UstabilgiStruct? ustabilgi, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    ustabilgi
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addUstabilgiStructData(
  Map<String, dynamic> firestoreData,
  UstabilgiStruct? ustabilgi,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (ustabilgi == null) {
    return;
  }
  if (ustabilgi.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && ustabilgi.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final ustabilgiData = getUstabilgiFirestoreData(ustabilgi, forFieldValue);
  final nestedData = ustabilgiData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = ustabilgi.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getUstabilgiFirestoreData(
  UstabilgiStruct? ustabilgi, [
  bool forFieldValue = false,
]) {
  if (ustabilgi == null) {
    return {};
  }
  final firestoreData = mapToFirestore(ustabilgi.toMap());

  // Add any Firestore field values
  ustabilgi.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getUstabilgiListFirestoreData(
  List<UstabilgiStruct>? ustabilgis,
) =>
    ustabilgis?.map((e) => getUstabilgiFirestoreData(e, true)).toList() ?? [];

// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AracsahipbilgiStruct extends FFFirebaseStruct {
  AracsahipbilgiStruct({
    String? name,
    String? tckimlik,
    List<String>? aracplaka,
    String? telefonnumarasi,
    int? toplamHarcama,
    List<String>? aracresim,
    List<AracKullanici>? aractipi,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _name = name,
        _tckimlik = tckimlik,
        _aracplaka = aracplaka,
        _telefonnumarasi = telefonnumarasi,
        _toplamHarcama = toplamHarcama,
        _aracresim = aracresim,
        _aractipi = aractipi,
        super(firestoreUtilData);

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "tckimlik" field.
  String? _tckimlik;
  String get tckimlik => _tckimlik ?? '';
  set tckimlik(String? val) => _tckimlik = val;

  bool hasTckimlik() => _tckimlik != null;

  // "aracplaka" field.
  List<String>? _aracplaka;
  List<String> get aracplaka => _aracplaka ?? const [];
  set aracplaka(List<String>? val) => _aracplaka = val;

  void updateAracplaka(Function(List<String>) updateFn) {
    updateFn(_aracplaka ??= []);
  }

  bool hasAracplaka() => _aracplaka != null;

  // "telefonnumarasi" field.
  String? _telefonnumarasi;
  String get telefonnumarasi => _telefonnumarasi ?? '';
  set telefonnumarasi(String? val) => _telefonnumarasi = val;

  bool hasTelefonnumarasi() => _telefonnumarasi != null;

  // "ToplamHarcama" field.
  int? _toplamHarcama;
  int get toplamHarcama => _toplamHarcama ?? 0;
  set toplamHarcama(int? val) => _toplamHarcama = val;

  void incrementToplamHarcama(int amount) =>
      toplamHarcama = toplamHarcama + amount;

  bool hasToplamHarcama() => _toplamHarcama != null;

  // "aracresim" field.
  List<String>? _aracresim;
  List<String> get aracresim => _aracresim ?? const [];
  set aracresim(List<String>? val) => _aracresim = val;

  void updateAracresim(Function(List<String>) updateFn) {
    updateFn(_aracresim ??= []);
  }

  bool hasAracresim() => _aracresim != null;

  // "aractipi" field.
  List<AracKullanici>? _aractipi;
  List<AracKullanici> get aractipi => _aractipi ?? const [];
  set aractipi(List<AracKullanici>? val) => _aractipi = val;

  void updateAractipi(Function(List<AracKullanici>) updateFn) {
    updateFn(_aractipi ??= []);
  }

  bool hasAractipi() => _aractipi != null;

  static AracsahipbilgiStruct fromMap(Map<String, dynamic> data) =>
      AracsahipbilgiStruct(
        name: data['name'] as String?,
        tckimlik: data['tckimlik'] as String?,
        aracplaka: getDataList(data['aracplaka']),
        telefonnumarasi: data['telefonnumarasi'] as String?,
        toplamHarcama: castToType<int>(data['ToplamHarcama']),
        aracresim: getDataList(data['aracresim']),
        aractipi: getEnumList<AracKullanici>(data['aractipi']),
      );

  static AracsahipbilgiStruct? maybeFromMap(dynamic data) => data is Map
      ? AracsahipbilgiStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'tckimlik': _tckimlik,
        'aracplaka': _aracplaka,
        'telefonnumarasi': _telefonnumarasi,
        'ToplamHarcama': _toplamHarcama,
        'aracresim': _aracresim,
        'aractipi': _aractipi?.map((e) => e.serialize()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'tckimlik': serializeParam(
          _tckimlik,
          ParamType.String,
        ),
        'aracplaka': serializeParam(
          _aracplaka,
          ParamType.String,
          isList: true,
        ),
        'telefonnumarasi': serializeParam(
          _telefonnumarasi,
          ParamType.String,
        ),
        'ToplamHarcama': serializeParam(
          _toplamHarcama,
          ParamType.int,
        ),
        'aracresim': serializeParam(
          _aracresim,
          ParamType.String,
          isList: true,
        ),
        'aractipi': serializeParam(
          _aractipi,
          ParamType.Enum,
          isList: true,
        ),
      }.withoutNulls;

  static AracsahipbilgiStruct fromSerializableMap(Map<String, dynamic> data) =>
      AracsahipbilgiStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        tckimlik: deserializeParam(
          data['tckimlik'],
          ParamType.String,
          false,
        ),
        aracplaka: deserializeParam<String>(
          data['aracplaka'],
          ParamType.String,
          true,
        ),
        telefonnumarasi: deserializeParam(
          data['telefonnumarasi'],
          ParamType.String,
          false,
        ),
        toplamHarcama: deserializeParam(
          data['ToplamHarcama'],
          ParamType.int,
          false,
        ),
        aracresim: deserializeParam<String>(
          data['aracresim'],
          ParamType.String,
          true,
        ),
        aractipi: deserializeParam<AracKullanici>(
          data['aractipi'],
          ParamType.Enum,
          true,
        ),
      );

  @override
  String toString() => 'AracsahipbilgiStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is AracsahipbilgiStruct &&
        name == other.name &&
        tckimlik == other.tckimlik &&
        listEquality.equals(aracplaka, other.aracplaka) &&
        telefonnumarasi == other.telefonnumarasi &&
        toplamHarcama == other.toplamHarcama &&
        listEquality.equals(aracresim, other.aracresim) &&
        listEquality.equals(aractipi, other.aractipi);
  }

  @override
  int get hashCode => const ListEquality().hash([
        name,
        tckimlik,
        aracplaka,
        telefonnumarasi,
        toplamHarcama,
        aracresim,
        aractipi
      ]);
}

AracsahipbilgiStruct createAracsahipbilgiStruct({
  String? name,
  String? tckimlik,
  String? telefonnumarasi,
  int? toplamHarcama,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AracsahipbilgiStruct(
      name: name,
      tckimlik: tckimlik,
      telefonnumarasi: telefonnumarasi,
      toplamHarcama: toplamHarcama,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AracsahipbilgiStruct? updateAracsahipbilgiStruct(
  AracsahipbilgiStruct? aracsahipbilgi, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    aracsahipbilgi
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAracsahipbilgiStructData(
  Map<String, dynamic> firestoreData,
  AracsahipbilgiStruct? aracsahipbilgi,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (aracsahipbilgi == null) {
    return;
  }
  if (aracsahipbilgi.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && aracsahipbilgi.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final aracsahipbilgiData =
      getAracsahipbilgiFirestoreData(aracsahipbilgi, forFieldValue);
  final nestedData =
      aracsahipbilgiData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = aracsahipbilgi.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAracsahipbilgiFirestoreData(
  AracsahipbilgiStruct? aracsahipbilgi, [
  bool forFieldValue = false,
]) {
  if (aracsahipbilgi == null) {
    return {};
  }
  final firestoreData = mapToFirestore(aracsahipbilgi.toMap());

  // Add any Firestore field values
  aracsahipbilgi.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAracsahipbilgiListFirestoreData(
  List<AracsahipbilgiStruct>? aracsahipbilgis,
) =>
    aracsahipbilgis
        ?.map((e) => getAracsahipbilgiFirestoreData(e, true))
        .toList() ??
    [];

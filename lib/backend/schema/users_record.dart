import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "shortDescription" field.
  String? _shortDescription;
  String get shortDescription => _shortDescription ?? '';
  bool hasShortDescription() => _shortDescription != null;

  // "last_active_time" field.
  DateTime? _lastActiveTime;
  DateTime? get lastActiveTime => _lastActiveTime;
  bool hasLastActiveTime() => _lastActiveTime != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  bool hasRole() => _role != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "tckimlik" field.
  String? _tckimlik;
  String get tckimlik => _tckimlik ?? '';
  bool hasTckimlik() => _tckimlik != null;

  // "fotograf" field.
  String? _fotograf;
  String get fotograf => _fotograf ?? '';
  bool hasFotograf() => _fotograf != null;

  // "aracbilgi" field.
  String? _aracbilgi;
  String get aracbilgi => _aracbilgi ?? '';
  bool hasAracbilgi() => _aracbilgi != null;

  // "ustabilgi" field.
  String? _ustabilgi;
  String get ustabilgi => _ustabilgi ?? '';
  bool hasUstabilgi() => _ustabilgi != null;

  // "plaka" field.
  String? _plaka;
  String get plaka => _plaka ?? '';
  bool hasPlaka() => _plaka != null;

  // "aracsahipyas" field.
  String? _aracsahipyas;
  String get aracsahipyas => _aracsahipyas ?? '';
  bool hasAracsahipyas() => _aracsahipyas != null;

  // "Aracsahiptelefon" field.
  String? _aracsahiptelefon;
  String get aracsahiptelefon => _aracsahiptelefon ?? '';
  bool hasAracsahiptelefon() => _aracsahiptelefon != null;

  // "AracPlaka" field.
  String? _aracPlaka;
  String get aracPlaka => _aracPlaka ?? '';
  bool hasAracPlaka() => _aracPlaka != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _shortDescription = snapshotData['shortDescription'] as String?;
    _lastActiveTime = snapshotData['last_active_time'] as DateTime?;
    _role = snapshotData['role'] as String?;
    _title = snapshotData['title'] as String?;
    _tckimlik = snapshotData['tckimlik'] as String?;
    _fotograf = snapshotData['fotograf'] as String?;
    _aracbilgi = snapshotData['aracbilgi'] as String?;
    _ustabilgi = snapshotData['ustabilgi'] as String?;
    _plaka = snapshotData['plaka'] as String?;
    _aracsahipyas = snapshotData['aracsahipyas'] as String?;
    _aracsahiptelefon = snapshotData['Aracsahiptelefon'] as String?;
    _aracPlaka = snapshotData['AracPlaka'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  String? shortDescription,
  DateTime? lastActiveTime,
  String? role,
  String? title,
  String? tckimlik,
  String? fotograf,
  String? aracbilgi,
  String? ustabilgi,
  String? plaka,
  String? aracsahipyas,
  String? aracsahiptelefon,
  String? aracPlaka,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'shortDescription': shortDescription,
      'last_active_time': lastActiveTime,
      'role': role,
      'title': title,
      'tckimlik': tckimlik,
      'fotograf': fotograf,
      'aracbilgi': aracbilgi,
      'ustabilgi': ustabilgi,
      'plaka': plaka,
      'aracsahipyas': aracsahipyas,
      'Aracsahiptelefon': aracsahiptelefon,
      'AracPlaka': aracPlaka,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.shortDescription == e2?.shortDescription &&
        e1?.lastActiveTime == e2?.lastActiveTime &&
        e1?.role == e2?.role &&
        e1?.title == e2?.title &&
        e1?.tckimlik == e2?.tckimlik &&
        e1?.fotograf == e2?.fotograf &&
        e1?.aracbilgi == e2?.aracbilgi &&
        e1?.ustabilgi == e2?.ustabilgi &&
        e1?.plaka == e2?.plaka &&
        e1?.aracsahipyas == e2?.aracsahipyas &&
        e1?.aracsahiptelefon == e2?.aracsahiptelefon &&
        e1?.aracPlaka == e2?.aracPlaka;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.shortDescription,
        e?.lastActiveTime,
        e?.role,
        e?.title,
        e?.tckimlik,
        e?.fotograf,
        e?.aracbilgi,
        e?.ustabilgi,
        e?.plaka,
        e?.aracsahipyas,
        e?.aracsahiptelefon,
        e?.aracPlaka
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}

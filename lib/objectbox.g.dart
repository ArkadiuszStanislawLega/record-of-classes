// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'models/account.dart';
import 'models/address.dart';
import 'models/attendance.dart';
import 'models/bill.dart';
import 'models/classes.dart';
import 'models/classes_type.dart';
import 'models/group.dart';
import 'models/log.dart';
import 'models/parent.dart';
import 'models/person.dart';
import 'models/phone.dart';
import 'models/student.dart';
import 'models/teacher.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 6677618309001946823),
      name: 'Person',
      lastPropertyId: const IdUid(8, 5176376838380402083),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8292685637820353261),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 1690149849629657025),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1532596481634738400),
            name: 'surname',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 456323340332387829),
            name: 'studentId',
            type: 11,
            flags: 520,
            indexId: const IdUid(14, 4895456357721923155),
            relationTarget: 'Student'),
        ModelProperty(
            id: const IdUid(5, 3413805852116716376),
            name: 'personType',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 8950949768443332787),
            name: 'dbPersonType',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 5826451391507035300),
            name: 'parentId',
            type: 11,
            flags: 520,
            indexId: const IdUid(16, 115344520173770922),
            relationTarget: 'Parent'),
        ModelProperty(
            id: const IdUid(8, 5176376838380402083),
            name: 'teacherId',
            type: 11,
            flags: 520,
            indexId: const IdUid(17, 3246867036266486352),
            relationTarget: 'Teacher')
      ],
      relations: <ModelRelation>[
        ModelRelation(
            id: const IdUid(18, 3962742370877392650),
            name: 'phones',
            targetId: const IdUid(10, 8141085108066277363))
      ],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 7867667170132954701),
      name: 'Account',
      lastPropertyId: const IdUid(3, 1047344440864601148),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8033253743708233996),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 948463750746831861),
            name: 'studentId',
            type: 11,
            flags: 520,
            indexId: const IdUid(1, 2683096897271273148),
            relationTarget: 'Student'),
        ModelProperty(
            id: const IdUid(3, 1047344440864601148),
            name: 'balance',
            type: 8,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[
        ModelBacklink(name: 'bills', srcEntity: 'Bill', srcField: '')
      ]),
  ModelEntity(
      id: const IdUid(3, 4237185987808461471),
      name: 'Address',
      lastPropertyId: const IdUid(5, 4776855031149751765),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 4653003567139885767),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 7446497639021315996),
            name: 'street',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 2518400389363416918),
            name: 'houseNumber',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 5971683185450028834),
            name: 'flatNumber',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 4776855031149751765),
            name: 'city',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[
        ModelBacklink(name: 'groups', srcEntity: 'Group', srcField: '')
      ]),
  ModelEntity(
      id: const IdUid(4, 8304019811953848799),
      name: 'Attendance',
      lastPropertyId: const IdUid(7, 8963886267189147825),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 1157837442318272034),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 1036554286567749103),
            name: 'isPresent',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 6357736263001832829),
            name: 'studentId',
            type: 11,
            flags: 520,
            indexId: const IdUid(3, 3876153227275489020),
            relationTarget: 'Student'),
        ModelProperty(
            id: const IdUid(6, 1803403615449377813),
            name: 'classesId',
            type: 11,
            flags: 520,
            indexId: const IdUid(20, 9194954344031976896),
            relationTarget: 'Classes'),
        ModelProperty(
            id: const IdUid(7, 8963886267189147825),
            name: 'billId',
            type: 11,
            flags: 520,
            indexId: const IdUid(21, 6802194698348453078),
            relationTarget: 'Bill')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(5, 2569973322208561741),
      name: 'Bill',
      lastPropertyId: const IdUid(7, 2337492479634072274),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8665943235444996184),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 4280196193635632373),
            name: 'isPaid',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7229044549022485811),
            name: 'price',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 8353523723444352271),
            name: 'attendanceId',
            type: 11,
            flags: 520,
            indexId: const IdUid(19, 431181199142401744),
            relationTarget: 'Attendance'),
        ModelProperty(
            id: const IdUid(7, 2337492479634072274),
            name: 'studentAccountId',
            type: 11,
            flags: 520,
            indexId: const IdUid(22, 6364611693031497144),
            relationTarget: 'Account')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(6, 8608907494681874391),
      name: 'Classes',
      lastPropertyId: const IdUid(3, 134950544908276607),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 471551346332002484),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 8961382260420971607),
            name: 'dateTime',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 134950544908276607),
            name: 'groupId',
            type: 11,
            flags: 520,
            indexId: const IdUid(6, 4477573794856855013),
            relationTarget: 'Group')
      ],
      relations: <ModelRelation>[
        ModelRelation(
            id: const IdUid(17, 1060870525215224344),
            name: 'attendances',
            targetId: const IdUid(4, 8304019811953848799))
      ],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(7, 397564380929104183),
      name: 'ClassesType',
      lastPropertyId: const IdUid(5, 4489896552013617294),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8750576041410662200),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 8235849955281182792),
            name: 'priceForEach',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3401004614813659179),
            name: 'priceForMonth',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 7513474898787404393),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 4489896552013617294),
            name: 'teacherId',
            type: 11,
            flags: 520,
            indexId: const IdUid(7, 114311808619017457),
            relationTarget: 'Teacher')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[
        ModelBacklink(name: 'groups', srcEntity: 'Group', srcField: '')
      ]),
  ModelEntity(
      id: const IdUid(8, 5555386999314552904),
      name: 'Group',
      lastPropertyId: const IdUid(4, 5753611441503209084),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7448942118823140109),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 2424131766743578433),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 7063087958367453988),
            name: 'classesTypeId',
            type: 11,
            flags: 520,
            indexId: const IdUid(8, 4135866921457884117),
            relationTarget: 'ClassesType'),
        ModelProperty(
            id: const IdUid(4, 5753611441503209084),
            name: 'addressId',
            type: 11,
            flags: 520,
            indexId: const IdUid(15, 1182126131564333134),
            relationTarget: 'Address')
      ],
      relations: <ModelRelation>[
        ModelRelation(
            id: const IdUid(11, 8516641969030352180),
            name: 'students',
            targetId: const IdUid(11, 8038409490704286009)),
        ModelRelation(
            id: const IdUid(16, 428761453294890279),
            name: 'classes',
            targetId: const IdUid(6, 8608907494681874391))
      ],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(9, 2140736623696140270),
      name: 'Parent',
      lastPropertyId: const IdUid(2, 3855328201260456972),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 416524062601399073),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 3855328201260456972),
            name: 'personId',
            type: 11,
            flags: 520,
            indexId: const IdUid(9, 620057998256937800),
            relationTarget: 'Person')
      ],
      relations: <ModelRelation>[
        ModelRelation(
            id: const IdUid(15, 7596719649020048181),
            name: 'children',
            targetId: const IdUid(11, 8038409490704286009))
      ],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(10, 8141085108066277363),
      name: 'Phone',
      lastPropertyId: const IdUid(4, 9032125497926527827),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 4543176168418814650),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 7104738794691701984),
            name: 'number',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 8981759010096708230),
            name: 'numberName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 9032125497926527827),
            name: 'ownerId',
            type: 11,
            flags: 520,
            indexId: const IdUid(10, 4280504408740964787),
            relationTarget: 'Person')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(11, 8038409490704286009),
      name: 'Student',
      lastPropertyId: const IdUid(4, 2683141962036944738),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5453510512246741945),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 5121766592776384372),
            name: 'age',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1496439598545710945),
            name: 'personId',
            type: 11,
            flags: 520,
            indexId: const IdUid(11, 1243801400274110003),
            relationTarget: 'Person'),
        ModelProperty(
            id: const IdUid(4, 2683141962036944738),
            name: 'accountId',
            type: 11,
            flags: 520,
            indexId: const IdUid(12, 7585845961853672244),
            relationTarget: 'Account')
      ],
      relations: <ModelRelation>[
        ModelRelation(
            id: const IdUid(8, 5393923549136057815),
            name: 'siblings',
            targetId: const IdUid(11, 8038409490704286009)),
        ModelRelation(
            id: const IdUid(10, 7322280606697731102),
            name: 'attendancesList',
            targetId: const IdUid(4, 8304019811953848799)),
        ModelRelation(
            id: const IdUid(12, 5848685589650165534),
            name: 'groups',
            targetId: const IdUid(8, 5555386999314552904)),
        ModelRelation(
            id: const IdUid(14, 5687460142891737685),
            name: 'parents',
            targetId: const IdUid(9, 2140736623696140270))
      ],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(12, 7751236531251891487),
      name: 'Teacher',
      lastPropertyId: const IdUid(2, 841561370609739264),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8579947909360137480),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 841561370609739264),
            name: 'personId',
            type: 11,
            flags: 520,
            indexId: const IdUid(13, 321765665195980038),
            relationTarget: 'Person')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(13, 8320701260738490398),
      name: 'Log',
      lastPropertyId: const IdUid(9, 2649204837924431534),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7347948342105445517),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 7130796705849388726),
            name: 'participatingClassId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 7116864523351254003),
            name: 'date',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 6904665903451738380),
            name: 'value',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 974790161641923063),
            name: 'actionType',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 3351071500763998102),
            name: 'modelType',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 2649204837924431534),
            name: 'valueBeforeChange',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(13, 8320701260738490398),
      lastIndexId: const IdUid(22, 6364611693031497144),
      lastRelationId: const IdUid(18, 3962742370877392650),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [
        6773675177352282519,
        4134753230374124452,
        842982707630914193,
        8005409257843509993
      ],
      retiredPropertyUids: const [
        3706186507634068022,
        4785750695672916933,
        7851124295830647492,
        3511719454620364937,
        7450540750696206815,
        4052771601871698768
      ],
      retiredRelationUids: const [
        1221970440210856162,
        7162615460766791909,
        539727955104591881,
        9215356480749689848,
        3217513060367901643,
        2098414998713666383,
        6231248647669863271,
        1239359132223714330,
        2990737891109516731
      ],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    Person: EntityDefinition<Person>(
        model: _entities[0],
        toOneRelations: (Person object) =>
            [object.student, object.parent, object.teacher],
        toManyRelations: (Person object) =>
            {RelInfo<Person>.toMany(18, object.id): object.phones},
        getId: (Person object) => object.id,
        setId: (Person object, int id) {
          object.id = id;
        },
        objectToFB: (Person object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final surnameOffset = fbb.writeString(object.surname);
          fbb.startTable(9);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, surnameOffset);
          fbb.addInt64(3, object.student.targetId);
          fbb.addInt64(4, object.personType);
          fbb.addInt64(5, object.dbPersonType);
          fbb.addInt64(6, object.parent.targetId);
          fbb.addInt64(7, object.teacher.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Person(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              surname:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              personType:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0))
            ..dbPersonType =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0);
          object.student.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0);
          object.student.attach(store);
          object.parent.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0);
          object.parent.attach(store);
          object.teacher.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 18, 0);
          object.teacher.attach(store);
          InternalToManyAccess.setRelInfo(object.phones, store,
              RelInfo<Person>.toMany(18, object.id), store.box<Person>());
          return object;
        }),
    Account: EntityDefinition<Account>(
        model: _entities[1],
        toOneRelations: (Account object) => [object.student],
        toManyRelations: (Account object) => {
              RelInfo<Bill>.toOneBacklink(7, object.id,
                  (Bill srcObject) => srcObject.studentAccount): object.bills
            },
        getId: (Account object) => object.id,
        setId: (Account object, int id) {
          object.id = id;
        },
        objectToFB: (Account object, fb.Builder fbb) {
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.student.targetId);
          fbb.addFloat64(2, object.balance);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Account(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              balance:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 8, 0));
          object.student.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0);
          object.student.attach(store);
          InternalToManyAccess.setRelInfo(
              object.bills,
              store,
              RelInfo<Bill>.toOneBacklink(
                  7, object.id, (Bill srcObject) => srcObject.studentAccount),
              store.box<Account>());
          return object;
        }),
    Address: EntityDefinition<Address>(
        model: _entities[2],
        toOneRelations: (Address object) => [],
        toManyRelations: (Address object) => {
              RelInfo<Group>.toOneBacklink(
                      4, object.id, (Group srcObject) => srcObject.address):
                  object.groups
            },
        getId: (Address object) => object.id,
        setId: (Address object, int id) {
          object.id = id;
        },
        objectToFB: (Address object, fb.Builder fbb) {
          final streetOffset = fbb.writeString(object.street);
          final houseNumberOffset = fbb.writeString(object.houseNumber);
          final flatNumberOffset = fbb.writeString(object.flatNumber);
          final cityOffset = fbb.writeString(object.city);
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, streetOffset);
          fbb.addOffset(2, houseNumberOffset);
          fbb.addOffset(3, flatNumberOffset);
          fbb.addOffset(4, cityOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Address(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              street:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              houseNumber:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              flatNumber:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 10, ''),
              city: const fb.StringReader()
                  .vTableGet(buffer, rootOffset, 12, ''));
          InternalToManyAccess.setRelInfo(
              object.groups,
              store,
              RelInfo<Group>.toOneBacklink(
                  4, object.id, (Group srcObject) => srcObject.address),
              store.box<Address>());
          return object;
        }),
    Attendance: EntityDefinition<Attendance>(
        model: _entities[3],
        toOneRelations: (Attendance object) =>
            [object.student, object.classes, object.bill],
        toManyRelations: (Attendance object) => {},
        getId: (Attendance object) => object.id,
        setId: (Attendance object, int id) {
          object.id = id;
        },
        objectToFB: (Attendance object, fb.Builder fbb) {
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addBool(1, object.isPresent);
          fbb.addInt64(3, object.student.targetId);
          fbb.addInt64(5, object.classes.targetId);
          fbb.addInt64(6, object.bill.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Attendance(
              isPresent:
                  const fb.BoolReader().vTableGet(buffer, rootOffset, 6, false))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          object.student.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0);
          object.student.attach(store);
          object.classes.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0);
          object.classes.attach(store);
          object.bill.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0);
          object.bill.attach(store);
          return object;
        }),
    Bill: EntityDefinition<Bill>(
        model: _entities[4],
        toOneRelations: (Bill object) =>
            [object.attendance, object.studentAccount],
        toManyRelations: (Bill object) => {},
        getId: (Bill object) => object.id,
        setId: (Bill object, int id) {
          object.id = id;
        },
        objectToFB: (Bill object, fb.Builder fbb) {
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addBool(1, object.isPaid);
          fbb.addFloat64(4, object.price);
          fbb.addInt64(5, object.attendance.targetId);
          fbb.addInt64(6, object.studentAccount.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Bill(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              isPaid:
                  const fb.BoolReader().vTableGet(buffer, rootOffset, 6, false),
              price: const fb.Float64Reader()
                  .vTableGet(buffer, rootOffset, 12, 0));
          object.attendance.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0);
          object.attendance.attach(store);
          object.studentAccount.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0);
          object.studentAccount.attach(store);
          return object;
        }),
    Classes: EntityDefinition<Classes>(
        model: _entities[5],
        toOneRelations: (Classes object) => [object.group],
        toManyRelations: (Classes object) =>
            {RelInfo<Classes>.toMany(17, object.id): object.attendances},
        getId: (Classes object) => object.id,
        setId: (Classes object, int id) {
          object.id = id;
        },
        objectToFB: (Classes object, fb.Builder fbb) {
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.dateTime.millisecondsSinceEpoch);
          fbb.addInt64(2, object.group.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Classes(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0))
            ..dateTime = DateTime.fromMillisecondsSinceEpoch(
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0));
          object.group.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0);
          object.group.attach(store);
          InternalToManyAccess.setRelInfo(object.attendances, store,
              RelInfo<Classes>.toMany(17, object.id), store.box<Classes>());
          return object;
        }),
    ClassesType: EntityDefinition<ClassesType>(
        model: _entities[6],
        toOneRelations: (ClassesType object) => [object.teacher],
        toManyRelations: (ClassesType object) => {
              RelInfo<Group>.toOneBacklink(
                      3, object.id, (Group srcObject) => srcObject.classesType):
                  object.groups
            },
        getId: (ClassesType object) => object.id,
        setId: (ClassesType object, int id) {
          object.id = id;
        },
        objectToFB: (ClassesType object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addFloat64(1, object.priceForEach);
          fbb.addFloat64(2, object.priceForMonth);
          fbb.addOffset(3, nameOffset);
          fbb.addInt64(4, object.teacher.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ClassesType(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              priceForEach:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 6, 0),
              priceForMonth:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 8, 0),
              name: const fb.StringReader()
                  .vTableGet(buffer, rootOffset, 10, ''));
          object.teacher.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0);
          object.teacher.attach(store);
          InternalToManyAccess.setRelInfo(
              object.groups,
              store,
              RelInfo<Group>.toOneBacklink(
                  3, object.id, (Group srcObject) => srcObject.classesType),
              store.box<ClassesType>());
          return object;
        }),
    Group: EntityDefinition<Group>(
        model: _entities[7],
        toOneRelations: (Group object) => [object.classesType, object.address],
        toManyRelations: (Group object) => {
              RelInfo<Group>.toMany(11, object.id): object.students,
              RelInfo<Group>.toMany(16, object.id): object.classes
            },
        getId: (Group object) => object.id,
        setId: (Group object, int id) {
          object.id = id;
        },
        objectToFB: (Group object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addInt64(2, object.classesType.targetId);
          fbb.addInt64(3, object.address.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Group(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''));
          object.classesType.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0);
          object.classesType.attach(store);
          object.address.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0);
          object.address.attach(store);
          InternalToManyAccess.setRelInfo(object.students, store,
              RelInfo<Group>.toMany(11, object.id), store.box<Group>());
          InternalToManyAccess.setRelInfo(object.classes, store,
              RelInfo<Group>.toMany(16, object.id), store.box<Group>());
          return object;
        }),
    Parent: EntityDefinition<Parent>(
        model: _entities[8],
        toOneRelations: (Parent object) => [object.person],
        toManyRelations: (Parent object) =>
            {RelInfo<Parent>.toMany(15, object.id): object.children},
        getId: (Parent object) => object.id,
        setId: (Parent object, int id) {
          object.id = id;
        },
        objectToFB: (Parent object, fb.Builder fbb) {
          fbb.startTable(3);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.person.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Parent(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0));
          object.person.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0);
          object.person.attach(store);
          InternalToManyAccess.setRelInfo(object.children, store,
              RelInfo<Parent>.toMany(15, object.id), store.box<Parent>());
          return object;
        }),
    Phone: EntityDefinition<Phone>(
        model: _entities[9],
        toOneRelations: (Phone object) => [object.owner],
        toManyRelations: (Phone object) => {},
        getId: (Phone object) => object.id,
        setId: (Phone object, int id) {
          object.id = id;
        },
        objectToFB: (Phone object, fb.Builder fbb) {
          final numberNameOffset = fbb.writeString(object.numberName);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.number);
          fbb.addOffset(2, numberNameOffset);
          fbb.addInt64(3, object.owner.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Phone(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              number:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              numberName:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''));
          object.owner.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0);
          object.owner.attach(store);
          return object;
        }),
    Student: EntityDefinition<Student>(
        model: _entities[10],
        toOneRelations: (Student object) => [object.person, object.account],
        toManyRelations: (Student object) => {
              RelInfo<Student>.toMany(8, object.id): object.siblings,
              RelInfo<Student>.toMany(10, object.id): object.attendancesList,
              RelInfo<Student>.toMany(12, object.id): object.groups,
              RelInfo<Student>.toMany(14, object.id): object.parents
            },
        getId: (Student object) => object.id,
        setId: (Student object, int id) {
          object.id = id;
        },
        objectToFB: (Student object, fb.Builder fbb) {
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.age);
          fbb.addInt64(2, object.person.targetId);
          fbb.addInt64(3, object.account.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Student(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              age: const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0));
          object.person.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0);
          object.person.attach(store);
          object.account.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0);
          object.account.attach(store);
          InternalToManyAccess.setRelInfo(object.siblings, store,
              RelInfo<Student>.toMany(8, object.id), store.box<Student>());
          InternalToManyAccess.setRelInfo(object.attendancesList, store,
              RelInfo<Student>.toMany(10, object.id), store.box<Student>());
          InternalToManyAccess.setRelInfo(object.groups, store,
              RelInfo<Student>.toMany(12, object.id), store.box<Student>());
          InternalToManyAccess.setRelInfo(object.parents, store,
              RelInfo<Student>.toMany(14, object.id), store.box<Student>());
          return object;
        }),
    Teacher: EntityDefinition<Teacher>(
        model: _entities[11],
        toOneRelations: (Teacher object) => [object.person],
        toManyRelations: (Teacher object) => {},
        getId: (Teacher object) => object.id,
        setId: (Teacher object, int id) {
          object.id = id;
        },
        objectToFB: (Teacher object, fb.Builder fbb) {
          fbb.startTable(3);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.person.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Teacher(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0));
          object.person.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0);
          object.person.attach(store);
          return object;
        }),
    Log: EntityDefinition<Log>(
        model: _entities[12],
        toOneRelations: (Log object) => [],
        toManyRelations: (Log object) => {},
        getId: (Log object) => object.id,
        setId: (Log object, int id) {
          object.id = id;
        },
        objectToFB: (Log object, fb.Builder fbb) {
          final valueOffset = fbb.writeString(object.value);
          final valueBeforeChangeOffset =
              fbb.writeString(object.valueBeforeChange);
          fbb.startTable(10);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.participatingClassId);
          fbb.addInt64(2, object.date.millisecondsSinceEpoch);
          fbb.addOffset(3, valueOffset);
          fbb.addInt64(4, object.actionType);
          fbb.addInt64(5, object.modelType);
          fbb.addOffset(8, valueBeforeChangeOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Log(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              participatingClassId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              actionType:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0),
              modelType:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0),
              valueBeforeChange:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 20, ''),
              value:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 10, ''))
            ..date = DateTime.fromMillisecondsSinceEpoch(
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [Person] entity fields to define ObjectBox queries.
class Person_ {
  /// see [Person.id]
  static final id = QueryIntegerProperty<Person>(_entities[0].properties[0]);

  /// see [Person.name]
  static final name = QueryStringProperty<Person>(_entities[0].properties[1]);

  /// see [Person.surname]
  static final surname =
      QueryStringProperty<Person>(_entities[0].properties[2]);

  /// see [Person.student]
  static final student =
      QueryRelationToOne<Person, Student>(_entities[0].properties[3]);

  /// see [Person.personType]
  static final personType =
      QueryIntegerProperty<Person>(_entities[0].properties[4]);

  /// see [Person.dbPersonType]
  static final dbPersonType =
      QueryIntegerProperty<Person>(_entities[0].properties[5]);

  /// see [Person.parent]
  static final parent =
      QueryRelationToOne<Person, Parent>(_entities[0].properties[6]);

  /// see [Person.teacher]
  static final teacher =
      QueryRelationToOne<Person, Teacher>(_entities[0].properties[7]);

  /// see [Person.phones]
  static final phones =
      QueryRelationToMany<Person, Phone>(_entities[0].relations[0]);
}

/// [Account] entity fields to define ObjectBox queries.
class Account_ {
  /// see [Account.id]
  static final id = QueryIntegerProperty<Account>(_entities[1].properties[0]);

  /// see [Account.student]
  static final student =
      QueryRelationToOne<Account, Student>(_entities[1].properties[1]);

  /// see [Account.balance]
  static final balance =
      QueryDoubleProperty<Account>(_entities[1].properties[2]);
}

/// [Address] entity fields to define ObjectBox queries.
class Address_ {
  /// see [Address.id]
  static final id = QueryIntegerProperty<Address>(_entities[2].properties[0]);

  /// see [Address.street]
  static final street =
      QueryStringProperty<Address>(_entities[2].properties[1]);

  /// see [Address.houseNumber]
  static final houseNumber =
      QueryStringProperty<Address>(_entities[2].properties[2]);

  /// see [Address.flatNumber]
  static final flatNumber =
      QueryStringProperty<Address>(_entities[2].properties[3]);

  /// see [Address.city]
  static final city = QueryStringProperty<Address>(_entities[2].properties[4]);
}

/// [Attendance] entity fields to define ObjectBox queries.
class Attendance_ {
  /// see [Attendance.id]
  static final id =
      QueryIntegerProperty<Attendance>(_entities[3].properties[0]);

  /// see [Attendance.isPresent]
  static final isPresent =
      QueryBooleanProperty<Attendance>(_entities[3].properties[1]);

  /// see [Attendance.student]
  static final student =
      QueryRelationToOne<Attendance, Student>(_entities[3].properties[2]);

  /// see [Attendance.classes]
  static final classes =
      QueryRelationToOne<Attendance, Classes>(_entities[3].properties[3]);

  /// see [Attendance.bill]
  static final bill =
      QueryRelationToOne<Attendance, Bill>(_entities[3].properties[4]);
}

/// [Bill] entity fields to define ObjectBox queries.
class Bill_ {
  /// see [Bill.id]
  static final id = QueryIntegerProperty<Bill>(_entities[4].properties[0]);

  /// see [Bill.isPaid]
  static final isPaid = QueryBooleanProperty<Bill>(_entities[4].properties[1]);

  /// see [Bill.price]
  static final price = QueryDoubleProperty<Bill>(_entities[4].properties[2]);

  /// see [Bill.attendance]
  static final attendance =
      QueryRelationToOne<Bill, Attendance>(_entities[4].properties[3]);

  /// see [Bill.studentAccount]
  static final studentAccount =
      QueryRelationToOne<Bill, Account>(_entities[4].properties[4]);
}

/// [Classes] entity fields to define ObjectBox queries.
class Classes_ {
  /// see [Classes.id]
  static final id = QueryIntegerProperty<Classes>(_entities[5].properties[0]);

  /// see [Classes.dateTime]
  static final dateTime =
      QueryIntegerProperty<Classes>(_entities[5].properties[1]);

  /// see [Classes.group]
  static final group =
      QueryRelationToOne<Classes, Group>(_entities[5].properties[2]);

  /// see [Classes.attendances]
  static final attendances =
      QueryRelationToMany<Classes, Attendance>(_entities[5].relations[0]);
}

/// [ClassesType] entity fields to define ObjectBox queries.
class ClassesType_ {
  /// see [ClassesType.id]
  static final id =
      QueryIntegerProperty<ClassesType>(_entities[6].properties[0]);

  /// see [ClassesType.priceForEach]
  static final priceForEach =
      QueryDoubleProperty<ClassesType>(_entities[6].properties[1]);

  /// see [ClassesType.priceForMonth]
  static final priceForMonth =
      QueryDoubleProperty<ClassesType>(_entities[6].properties[2]);

  /// see [ClassesType.name]
  static final name =
      QueryStringProperty<ClassesType>(_entities[6].properties[3]);

  /// see [ClassesType.teacher]
  static final teacher =
      QueryRelationToOne<ClassesType, Teacher>(_entities[6].properties[4]);
}

/// [Group] entity fields to define ObjectBox queries.
class Group_ {
  /// see [Group.id]
  static final id = QueryIntegerProperty<Group>(_entities[7].properties[0]);

  /// see [Group.name]
  static final name = QueryStringProperty<Group>(_entities[7].properties[1]);

  /// see [Group.classesType]
  static final classesType =
      QueryRelationToOne<Group, ClassesType>(_entities[7].properties[2]);

  /// see [Group.address]
  static final address =
      QueryRelationToOne<Group, Address>(_entities[7].properties[3]);

  /// see [Group.students]
  static final students =
      QueryRelationToMany<Group, Student>(_entities[7].relations[0]);

  /// see [Group.classes]
  static final classes =
      QueryRelationToMany<Group, Classes>(_entities[7].relations[1]);
}

/// [Parent] entity fields to define ObjectBox queries.
class Parent_ {
  /// see [Parent.id]
  static final id = QueryIntegerProperty<Parent>(_entities[8].properties[0]);

  /// see [Parent.person]
  static final person =
      QueryRelationToOne<Parent, Person>(_entities[8].properties[1]);

  /// see [Parent.children]
  static final children =
      QueryRelationToMany<Parent, Student>(_entities[8].relations[0]);
}

/// [Phone] entity fields to define ObjectBox queries.
class Phone_ {
  /// see [Phone.id]
  static final id = QueryIntegerProperty<Phone>(_entities[9].properties[0]);

  /// see [Phone.number]
  static final number = QueryIntegerProperty<Phone>(_entities[9].properties[1]);

  /// see [Phone.numberName]
  static final numberName =
      QueryStringProperty<Phone>(_entities[9].properties[2]);

  /// see [Phone.owner]
  static final owner =
      QueryRelationToOne<Phone, Person>(_entities[9].properties[3]);
}

/// [Student] entity fields to define ObjectBox queries.
class Student_ {
  /// see [Student.id]
  static final id = QueryIntegerProperty<Student>(_entities[10].properties[0]);

  /// see [Student.age]
  static final age = QueryIntegerProperty<Student>(_entities[10].properties[1]);

  /// see [Student.person]
  static final person =
      QueryRelationToOne<Student, Person>(_entities[10].properties[2]);

  /// see [Student.account]
  static final account =
      QueryRelationToOne<Student, Account>(_entities[10].properties[3]);

  /// see [Student.siblings]
  static final siblings =
      QueryRelationToMany<Student, Student>(_entities[10].relations[0]);

  /// see [Student.attendancesList]
  static final attendancesList =
      QueryRelationToMany<Student, Attendance>(_entities[10].relations[1]);

  /// see [Student.groups]
  static final groups =
      QueryRelationToMany<Student, Group>(_entities[10].relations[2]);

  /// see [Student.parents]
  static final parents =
      QueryRelationToMany<Student, Parent>(_entities[10].relations[3]);
}

/// [Teacher] entity fields to define ObjectBox queries.
class Teacher_ {
  /// see [Teacher.id]
  static final id = QueryIntegerProperty<Teacher>(_entities[11].properties[0]);

  /// see [Teacher.person]
  static final person =
      QueryRelationToOne<Teacher, Person>(_entities[11].properties[1]);
}

/// [Log] entity fields to define ObjectBox queries.
class Log_ {
  /// see [Log.id]
  static final id = QueryIntegerProperty<Log>(_entities[12].properties[0]);

  /// see [Log.participatingClassId]
  static final participatingClassId =
      QueryIntegerProperty<Log>(_entities[12].properties[1]);

  /// see [Log.date]
  static final date = QueryIntegerProperty<Log>(_entities[12].properties[2]);

  /// see [Log.value]
  static final value = QueryStringProperty<Log>(_entities[12].properties[3]);

  /// see [Log.actionType]
  static final actionType =
      QueryIntegerProperty<Log>(_entities[12].properties[4]);

  /// see [Log.modelType]
  static final modelType =
      QueryIntegerProperty<Log>(_entities[12].properties[5]);

  /// see [Log.valueBeforeChange]
  static final valueBeforeChange =
      QueryStringProperty<Log>(_entities[12].properties[6]);
}

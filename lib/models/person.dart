import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/enumerators/PersonType.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/db_model.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/models/teacher.dart';

@Entity()
class Person extends DbModel{
  late int id;
  late String name;
  late String surname;
  late PersonType type;
  late int personType;
  final student = ToOne<Student>();
  final parent = ToOne<Parent>();
  final teacher = ToOne<Teacher>();
  final phones = ToMany<Phone>();

  Person(
      {this.id = 0,
      this.name = '',
      this.surname = '',
      this.personType = 0,
      this.type = PersonType.none}){
    object = this;
    super.setId = id;
  }

  @override
  String toString() {
    return '$id. $name $surname $dbPersonType $type';
  }

  String introduceYourself() {
    return '$surname $name';
  }

  int get dbPersonType {
    _ensureStableEnumValues();
    return type.index;
  }

  void update(Person updatedPerson) {
    name = updatedPerson.name;
    surname = updatedPerson.surname;
    objectBox.store.box<Person>().put(this);
  }

  set dbPersonType(int value) {
    personType = value;
    _ensureStableEnumValues();
    if (value == 0) {
      type = PersonType.none;
    } else {
      type = PersonType.values[value]; // throws a RangeError if not found
    }
  }

  void _ensureStableEnumValues() {
    assert(PersonType.none.index == 0);
    assert(PersonType.teacher.index == 1);
    assert(PersonType.student.index == 2);
    assert(PersonType.parent.index == 3);
  }

  void addPhoneDb(Phone phone){
    phone.owner.target = this;
    phones.add(phone);
    objectBox.store.box<Phone>().put(phone);
    objectBox.store.box<Person>().put(this);
  }

  void removeAllPhonesDb() {
    var phoneBox = objectBox.store.box<Phone>();
    var personBox = objectBox.store.box<Person>();
    for (var element in phones) {
      phoneBox.remove(element.id);
    }
    phones.removeWhere((element) => element.owner.targetId == id);
    personBox.put(this);
  }

  @override
  void removeFromDb() {
    removeAllPhonesDb();
    objectBox.store.box<Person>().remove(id);
  }

  @override
  void addToDb() {
    // TODO: implement addToDb
  }

  @override
  getFromDb() => objectBox.store.box<Person>().get(id);

}

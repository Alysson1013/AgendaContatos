import 'dart:async';
import 'dart:async';
import 'dart:core';

import 'package:async/async.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";


class ContactHelper {

  //atributo unico e imutável que rescebe um construtor
  static final ContactHelper _instance = ContactHelper.internal();

  //chamada da classe, usando factory, para nem sempre concretizar um novo objeto
  factory ContactHelper() => _instance;

  //declaração de construtor
  ContactHelper.internal();

  Database _db;

  Future<Database> get db async{
    //verifica se o db está iniciado
    if(_db != null) return _db;
    else{
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    //pegar local do banco de dados
    final databasesPath = await getDatabasesPath();
    //local do banco de dados e o nome do arquivo
    final path = join(databasesPath, "contacts.db");
    
    //abrir banco de dados
    return openDatabase(path, version: 1, onCreate: (Database db, int neweVersion) async {
      await db.execute(
        "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn)"
      );
    });
  }

  Future<Contact> saveContact(Contact contact) async{
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(contactTable,
      columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
      where: "$idColumn = ?",
      whereArgs: [id]);
    if(maps.length > 0) return Contact.fromMap(maps.first);////
    else return null;
  }
}

class Contact {
  //Informações de Contato
  int id;
  String name;
  String email;
  String phone;
  String img;

  //Construtor a partir de um mapa
  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };

    //caso o id não seja atribuido pelo db
    if (id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'Contact{id: $id, name: $name, email: $email, phone: $phone, img: $img}';
  }
}
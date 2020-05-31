import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nomeColumn = "nomeColumn";
final String emailColumn = "emailColumn";
final String foneColumn = "foneColumn";
final String imagemColumn = "imagemColumn";

class ContactHelper {

  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if(_db != null){
      return _db;
    }else{
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async{
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contatos.db");

    return await  openDatabase(path,version: 1, onCreate:(Database db, newerVersion) async {
      await db.execute(
        "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nomeColumn TEXT, $emailColumn, TEXT, $foneColumn TEXT, $imagemColumn TEXT)"
      );
    });
  }

  Future<Contato>saveContact(Contato contato) async{
    Database dbContato = await db;
    contato.id = await dbContato.insert(contactTable, contato.toMap());
    return contato;
  }

  Future<Contato> getContato(int id) async{
    Database dbContato = await db;
    List<Map> maps = await dbContato.query(contactTable, columns: [idColumn, nomeColumn, emailColumn,foneColumn,imagemColumn],
    whereArgs: [id]);
    if(maps.length > 0){
      return Contato.fromMap(maps.first);
    }else{
      return null;
    }
  }

  deleteContact(int id) async{
    Database dbContato = await db;
    return await dbContato.delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  updateContact(Contato, contato) async{
    Database dbContato = await db;
    return await dbContato.update(contactTable, contato.toMap(), where: "$idColumn = ?", whereArgs: [contato.id]);
  }

  getAllContacts() async{
    Database dbContato = await db;
    List listMap = await dbContato.rawQuery("SELECT * FROM $contactTable");
    List<Contato> listContact = List();
    for(Map m in listMap){
      listContact.add(Contato.fromMap(m));
    }
    return listContact;
  }

  Future<int>getNumber() async{
    Database dbContato = await db;
    return Sqflite.firstIntValue(await dbContato.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Future close() async{
  Database dbContato = await db;
  dbContato.close();
  }

}


class Contato{

  int id;
  String nome;
  String email;
  String fone;
  String imagem;

  Contato();

  Contato.fromMap(Map map){
    id = map[idColumn];
    nome = map[nomeColumn];
    email = map[emailColumn];
    fone = map[foneColumn];
    imagem = map[imagemColumn];
  }
  Map toMap(){
    Map<String, dynamic> map = {
      nomeColumn: nome,
      emailColumn: email,
      foneColumn: fone,
      imagemColumn: imagem,
    };
    if(id!= null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString(){
    return "Contato(id: $id, nome: $nome, email: $email, fone: $fone, imagem: $imagem";
  }

}
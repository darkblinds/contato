import 'dart:io';
import 'package:contatos/helppers/contact_helper.dart';
import 'package:contatos/ui/contact_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contato> contatos = List();

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: contatos.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);

            }
          ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contatos[index].imagem != null
                          ? FileImage(File(contatos[index].imagem))
                          : AssetImage("images/person.png")
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  children: <Widget>[
                    Text(
                      contatos[index].nome ?? "",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contatos[index].fone ?? "",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contatos[index].email ?? "",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        _showContactPage(contact: contatos[index]);
      },
    );
  }
  void _showContactPage({Contato contact}) async{
    final recContato =  await Navigator.push(context,
      MaterialPageRoute(builder: (context) => ContactPage(contato: contact,))
    );
    if(recContato != null){
      if(contact != null){
        await helper.updateContact(recContato, contact);
        await _getAllContacts();
      }
      else{
        await helper.saveContact(recContato);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts(){
    helper.getAllContacts().then((list) {
      setState(() {
        contatos = list;
      });
    });
  }


}

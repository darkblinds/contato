
import 'dart:io';
import 'package:contatos/helppers/contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {

  final Contato contato;
  ContactPage({this.contato});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {


  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _foneController = TextEditingController();
  final _nameFocus = FocusNode();

  Contato _editContact;
  bool _userEdited = false;
  @override
  void initState(){
    super.initState();

    if(widget.contato == null){
      _editContact = Contato();
    }else{
      _editContact = Contato.fromMap(widget.contato.toMap());
      _nameController.text = _editContact.nome;
      _emailController.text = _editContact.email;
      _foneController.text = _editContact.fone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editContact.nome ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_editContact.nome != null && _editContact.nome.isNotEmpty){
              Navigator.pop(context,_editContact);
            }else{
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
      child: Icon(Icons.save),
      backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 140,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image:_editContact.imagem != null
                          ? FileImage(File(_editContact.imagem))
                          : AssetImage("images/person.png")
                  ),
                ),
              ),
            ),
            TextField(
              controller: _nameController,
              focusNode: _nameFocus,
              decoration: InputDecoration(labelText: "Nome"),
              onChanged: (text){
                _userEdited = true;
                setState(() {
                  _editContact.nome = text;
                });
              },
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
              onChanged: (text){
                _userEdited = true;
                  _editContact.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _foneController,
              decoration: InputDecoration(labelText: "Fone"),
              onChanged: (text){
                _userEdited = true;
                _editContact.fone = text;
              },
                keyboardType: TextInputType.phone,
            )
          ],
        ),
      ),
    );
  }
}

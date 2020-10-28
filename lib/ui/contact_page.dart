import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agendadecontatos/helpers/contact_helper.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();

  Contact _editContact;
  //indica alteração
  bool _userEdited = false;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null)  _editContact = new Contact();
    else{
      _editContact = new Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editContact.name;
      _emailController.text = _editContact.email;
      _phoneController.text = _editContact.phone;

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editContact.name ?? "Novo Contato"),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            //verifica sem o nome do objeto está vazio
            if (_editContact.name != null && _editContact.name.isNotEmpty){
              //retorna o objeto preenchido
              Navigator.pop(context, _editContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _editContact.img != null ? FileImage(File(_editContact.img)) : AssetImage("images/person.png"),
                            fit: BoxFit.cover
                        )
                    )
                ),
                onTap: (){
                  ImagePicker.pickImage(source: ImageSource.camera).then((file){
                    if(file == null) return;
                    setState(() {
                      _editContact.img = file.path;
                    });
                  });
                },
              ),
              TextField(
                focusNode: _nameFocus,
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _editContact.name = text;
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
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Telefone"),
                onChanged: (text){
                  _userEdited = true;
                  _editContact.phone = text;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<bool>_requestPop(){
    if (_userEdited){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas"),
              actions: [
                FlatButton(child: Text("Cancelar"),
                    onPressed: (){
                      Navigator.pop(context);
                    }),
                FlatButton(
                    child: Text("Sim"),
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }),
              ]
            );
          }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}

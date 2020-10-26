import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agendadecontatos/helpers/contact_helper.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(_editContact.name ?? "Novo Contato"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
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
                          image: _editContact.img != null ? FileImage(File(_editContact.img)) : AssetImage("images/person.png")
                      )
                  )
              ),
            ),
            TextField(
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
    );
  }
}

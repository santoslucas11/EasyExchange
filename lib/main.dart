import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:conversor_de_moeda/components/buildtext.dart';

import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=2db6d702";

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  final realController  = TextEditingController();
  final dolarController = TextEditingController();
  final pesoController  = TextEditingController();
  final euroController  = TextEditingController();

  double dolar, euro, pesoArgentino;

  void _realChanged(String text) {
    double real = double.parse(text);

    dolarController.text  = (real / dolar).toStringAsFixed(2);
    euroController.text   = (real / euro).toStringAsFixed(2);
    pesoController.text   = (real / pesoArgentino).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text);

    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    pesoController.text =
        (dolar * this.dolar / pesoArgentino).toStringAsFixed(2);
  }

  void _pesoChanged(String text) {
    double peso = double.parse(text);

    realController.text     = (peso * this.pesoArgentino).toStringAsFixed(2);
    dolarController.text    = (peso * this.pesoArgentino / dolar).toStringAsFixed(2);
    euroController.text     = (peso * this.pesoArgentino / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);

    realController.text   = (euro * this.euro).toStringAsFixed(2);
    dolarController.text  = (euro * this.euro / dolar).toStringAsFixed(2);
    pesoController.text   = (euro * this.euro / pesoArgentino).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[400],
        centerTitle: true,
        title: Text("Easy Exchange"),
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                  "Carregando...",
                  style: TextStyle(color: Colors.blueGrey[800], fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Ocorreu um erro inesperado XP",
                    style: TextStyle(color: Colors.redAccent, fontSize: 20),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  dolar         = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro          = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  pesoArgentino = snapshot.data["results"]["currencies"]["ARS"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.attach_money,
                            size: 80, color: Colors.blueGrey[400]),
                        Divider(),
                        buildTextField(
                            "Real", "R\$ ", realController, _realChanged),
                        Divider(),
                        buildTextField(
                            "Dólar", "U\$\$ ", dolarController, _dolarChanged),
                        Divider(),
                        buildTextField("Peso Argentino", "\$ ", pesoController,
                            _pesoChanged),
                        Divider(),
                        buildTextField(
                            "Euro", "€", euroController, _euroChanged),
                      ],
                    ),
                  );
                }
            }
          }),
          
    );
  }
}

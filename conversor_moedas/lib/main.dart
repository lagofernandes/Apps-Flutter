import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=b233dbf7";

//quer dizer que é uma função assincrona
void main() async {
  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.amber
      ),
  ));
}

Future<Map> getData() async {
  //vai esperar os dados chegarem
  http.Response response = await http.get(request);

  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);

  }

  void _dolarChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = ((dolar * this.dolar)/euro).toStringAsFixed(2);

  }

  void _euroChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = ((euro * this.euro)/dolar).toStringAsFixed(2);
  }

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    //permite colocar a barra em cima, la no app
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$ Conversor \$"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          // ignore: missing_return
          builder: (context,snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text("Carregando Dados...",
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0),
                  textAlign: TextAlign.center,)
                );
              default:
                if(snapshot.hasError){
                  return Center(
                      child: Text("Erro ao Carregar os Dados :(",
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 25.0),
                        textAlign: TextAlign.center,)
                  );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      //alinhar a imagem no centro
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                        //pode usar a função cirada para otimizar o codigo : buildTextField("Real", "R\$ ", realController, _realChanged),
                        TextField(
                          controller: realController,
                          decoration: InputDecoration(
                            labelText: "Real",
                            labelStyle: TextStyle(color: Colors.amber),
                            //borda no input
                            border: OutlineInputBorder(),
                            prefixText: "R\$ "
                          ),
                          style: TextStyle(
                            color: Colors.amber, fontSize: 25.0
                          ),
                          onChanged: _realChanged,
                          keyboardType: TextInputType.number,
                        ),
                        Divider(),
                        //pode usar a função cirada para otimizar o codigo : buildTextField("Dólar", "\$ ", dolarController, _dolarChanged),
                        TextField(
                          controller: dolarController,
                          decoration: InputDecoration(
                              labelText: "Dólar",
                              labelStyle: TextStyle(color: Colors.amber),
                              //borda no input
                              border: OutlineInputBorder(),
                              prefixText: "\$ "
                          ),
                          style: TextStyle(
                              color: Colors.amber, fontSize: 25.0
                          ),
                          onChanged: _dolarChanged,
                          keyboardType: TextInputType.number,
                        ),
                        Divider(),
                        //pode usar a função cirada para otimizar o codigo : buildTextField("Euro", "€ ", euroController, _euroChanged),
                        TextField(
                          controller: euroController,
                          decoration: InputDecoration(
                              labelText: "Euro",
                              labelStyle: TextStyle(color: Colors.amber),
                              //borda no input
                              border: OutlineInputBorder(),
                              prefixText: "€ "
                          ),
                          style: TextStyle(
                              color: Colors.amber, fontSize: 25.0
                          ),
                          onChanged: _euroChanged,
                          keyboardType: TextInputType.number,
                        )
                      ],
                    ),
                  );
                }
            }
          })
    );
  }
}

//função para otimizar campos que são praticamentes iguais
Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix
  ),
    style: TextStyle(
        color: Colors.amber, fontSize: 25.0
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}

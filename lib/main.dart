import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _recuperarBancoDados() async {
    final caminhoBD = getDatabasesPath();
    final localBD = await join(caminhoBD.toString(), "banco.db");

    var bd =
        await openDatabase(localBD, version: 1, onCreate: (db, novaVersao) {
      String sql =
          "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";

      db.execute(sql);
    });

    return bd;
  }

  _salvar() async {
    Database bd = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome": "Sergio",
      "idade": 55,
    };

    int id = await bd.insert("usuarios", dadosUsuario);
    print("Salvo $id");
  }

  _listarUsuarios() async {
    Database bd = await _recuperarBancoDados();
    String sql = "select * from usuarios";
    List usuarios = await bd.rawQuery(sql);

    for (var usuario in usuarios) {
      print("item id: " +
          usuario['id'].toString() +
          " nome: " +
          usuario['nome'] +
          "  idade: " +
          usuario['idade'].toString());
    }
  }

  _recuperarUsuarioPeloId(int id) async {
    Database bd = await _recuperarBancoDados();
    List usuarios = await bd.query(
      "usuarios",
      columns: ["id", "nome", "idade"],
      where: "id = ?",
      whereArgs: [id],
    );

    for (var usuario in usuarios) {
      print("item id: " +
          usuario['id'].toString() +
          " nome: " +
          usuario['nome'] +
          "  idade: " +
          usuario['idade'].toString());
    }
  }

  _excluirUsuario(int id) async {
    Database bd = await _recuperarBancoDados();

    int retorno = await bd.delete("usuarios", where: "id= ?", whereArgs: [id]);

    print("qtd itens removidos: " + retorno.toString());
  }

  _atualizarUsuario(int id) async {
    Database bd = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome": "Raphael Gomes",
      "idade": 34,
    };

    int retorno = await bd
        .update("usuarios", dadosUsuario, where: "id= ?", whereArgs: [id]);

    print("qtd itens alterados: " + retorno.toString());
  }

  @override
  Widget build(BuildContext context) {
    //_salvar();
    _listarUsuarios();
    //_recuperarUsuarioPeloId(11);
    //_excluirUsuario(3);
    _atualizarUsuario(1);

    return Container();
  }
}

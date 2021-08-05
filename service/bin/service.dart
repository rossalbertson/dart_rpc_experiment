// @dart=2.9

import 'package:global/model.dart';
import 'package:global/config.dart';
import 'package:rpc/rpc.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'dart:io';

final ApiServer _apiServer = ApiServer(prettyPrint: true);

void main(List<String> arguments) async {
  _apiServer.addApi(NameApi());
  _apiServer.enableDiscoveryApi();

  var server = await HttpServer.bind(SERVICE_HOST, SERVICE_PORT);
  server.listen(_apiServer.httpRequestHandler);
}

@ApiClass(version: 'v1', name: 'api')
class NameApi {
  List<Name> list = [];

  Future<void> _loadNames() async {
    //list.clear();
    var database = mongo.Db('mongodb://localhost:27017/obj1');
    var collection = database.collection('Person');
    await database.open();
    //list.clear();
    var raw = await collection.find().toList();
    print(raw);
    for (var rawName in raw) {
      list.add(Name.fromMap(rawName));
    }
    await database.close();
  }

  void _storeName(Name name) async {
    var db = mongo.Db('mongodb://localhost:27017/obj1');
    var collection = db.collection('Person');
    await db.open();
    await collection.insertOne(name.toMap());
    await db.close();
  }

  @ApiMethod(path: 'list')
  Future<List<Name>> getList() async {
    await _loadNames();
    return list;
  }

  @ApiMethod(path: 'save/{firstName}/x/{lastName}')
  Name saveName(String firstName, String lastName) {
    var name = Name(firstName, lastName);
    _storeName(name);
    return name;
  }
}

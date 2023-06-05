import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:super_project/models/storage_item.dart';

class StorageService {
  final _secureStorage = const FlutterSecureStorage();

  // Future<void> writeSecureData(StorageItem data) async {
  //   String enc = getEncoded(data);
  //   await _secureStorage.write(key: data.key, value: enc, aOptions: _getAndroidOptions());
  // }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<String?> readSecureData(String key) async {
    return await _secureStorage.read(key: key, aOptions: _getAndroidOptions());
  }

  Future<void> deleteSecureData(String item) async {
    await _secureStorage.delete(key: item, aOptions: _getAndroidOptions());
  }

  Future<List<StorageItem>> readAllSecureData() async {
    var allData = await _secureStorage.readAll(aOptions: _getAndroidOptions());
    List<StorageItem> list = [];
    allData.entries.forEach((e) {
      if (e.key.contains('pass')) {
        StorageItem pass = getDecoded(e);
        list.add(pass);
      }
    });
    // allData.entries.map((e){
    //   if (e.value is String) { getDecoded(e); }
    // }).toList();
    return list;
  }

  Future<bool> containsKeyInSecureData(String key) async {
    var containsKey = await _secureStorage.containsKey(
        key: key, aOptions: _getAndroidOptions());
    return containsKey;
  }

  Future<void> deleteAllSecureData() async {
    await _secureStorage.deleteAll(aOptions: _getAndroidOptions());
  }

  String getEncoded(data) {
    return jsonEncode(data);
  }

  StorageItem getDecoded(data) {
    Map<String, dynamic> d = jsonDecode(data.value);
    StorageItem passObj =
        StorageItem(d['username'], d['password'], d['website']);
    passObj.id = data.key;
    return passObj;
  }

  // password manager methods

  Future<void> writePass(StorageItem item) async {
    if (item.id.isEmpty) {
      generateId((id) async {
        String passId = 'pass-${id.toString()}';
        item.id = passId;
        String enc = getEncoded(item);
        await _secureStorage.write(
            key: passId, value: enc, aOptions: _getAndroidOptions());
      });
    } else {
      String enc = getEncoded(item);
      await _secureStorage.write(
          key: item.id, value: enc, aOptions: _getAndroidOptions());
    }
  }

  Future<List<StorageItem>> readAllPass() async {
    var allData = await _secureStorage.readAll(aOptions: _getAndroidOptions());
    List<StorageItem> list = [];
    allData.entries.forEach((e) {
      if (e.key.contains('pass-')) {
        StorageItem pass = decodePass(e);
        list.add(pass);
      }
    });
    return list;
  }

  void generateId(callback) {
    containsKeyInSecureData('primaryKey').then((value) {
      if (value) {
        _secureStorage
            .read(key: 'primaryKey', aOptions: _getAndroidOptions())
            .then((value1) {
          int gotId = int.parse(value1!);
          gotId += 1;
          _secureStorage.write(
              key: 'primaryKey',
              value: gotId.toString(),
              aOptions: _getAndroidOptions());
          callback(gotId.toString());
        });
      } else {
        _secureStorage.write(
            key: 'primaryKey', value: "1", aOptions: _getAndroidOptions());
        int val = 1;
        callback(val.toString());
      }
    });
  }

  StorageItem decodePass(data) {
    Map<String, dynamic> d = jsonDecode(data.value);
    StorageItem passObj =
        StorageItem(d['username'], d['password'], d['website']);
    passObj.id = data.key;
    return passObj;
  }

  void deleteAllPass() async {
    var allData = await _secureStorage.readAll(aOptions: _getAndroidOptions());
    allData.entries.forEach((e) {
      if (e.key.contains('pass-')) {
        deleteSecureData(e.key);
      }
    });
  }

  // password manager's passcode

  Future<int> validatePin(String pin) async {
    bool present = await containsKeyInSecureData('passwordPassCode');

    if (present) {
      String? passcode = await readSecureData('passwordPassCode');
      if (passcode!.contains(pin)) {
        return 1;
      } else {
        return 2;
      }
    } else {
      return 3;
    }
  }

  void createPassPin(String pin) async {
    _secureStorage.write(
        key: 'passwordPassCode', value: pin, aOptions: _getAndroidOptions());
  }
}

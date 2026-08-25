import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BrowserEncryptionService {

  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  
  static const String _keyAlias = 'browser_master_encryption_key_v1';
  
  async Future<SecretKey> _getOrCreateMasterKey() async {
    final existingKeyHex = await _secureStorage.read(key: _keyAlias);
    final algorithm = AesGcm.with256bits();
    
    if (existingKeyHex == null) {
      final newKey = await algorithm.newSecretKey();
      final keyBytes = await newKey.extractBytes();
      
      await _secureStorage.write(
        key: _keyAlias, 
        value: base64Encode(keyBytes),
      );
      return newKey;
    } else {
      final keyBytes = base64Decode(existingKeyHex);
      return SecretKey(keyBytes);
    }
  }

  Future<String> encryptData(String plainText) async {
    final algorithm = AesGcm.with256bits();
    final secretKey = await _getOrCreateMasterKey();
    final nonce = algorithm.newNonce();
    final secretBox = await algorithm.encrypt(
      utf8.encode(plainText),
      secretKey: secretKey,
      nonce: nonce,
    );
    
    final combined = [...secretBox.nonce, ...secretBox.cipherText, ...secretBox.mac.bytes];
    return base64Encode(combined);
  }

  Future<String> decryptData(String encryptedBase64) async {
    final algorithm = AesGcm.with256bits();
    final secretKey = await _getOrCreateMasterKey();
    final combined = base64Decode(encryptedBase64);
    final nonce = combined.sublist(0, 12);
    final cipherText = combined.sublist(12, combined.length - 16);
    final macBytes = combined.sublist(combined.length - 16);
    
    final secretBox = SecretBox(
      cipherText,
      nonce: nonce,
      mac: Mac(macBytes),
    );
    
    final decryptedBytes = await algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
    );
    
    return utf8.decode(decryptedBytes);
  }
}

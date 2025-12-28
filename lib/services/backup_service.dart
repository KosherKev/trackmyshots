import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';

class BackupService {
  /// Encrypts the JSON data with the given password and saves it to a temporary file.
  /// Returns the File object.
  static Future<File> createEncryptedBackup({
    required String jsonData,
    required String password,
  }) async {
    // Derive a 32-byte key from the password using SHA-256
    final keyBytes = sha256.convert(utf8.encode(password)).bytes;
    final key = encrypt.Key(Uint8List.fromList(keyBytes));
    
    // Generate a random IV
    final iv = encrypt.IV.fromLength(16);

    // Encrypt using AES
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(jsonData, iv: iv);

    // Format: IV (base64) : EncryptedData (base64)
    // This allows us to extract the IV for decryption
    final fileContent = '${iv.base64}:${encrypted.base64}';

    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/trackmyshots_backup_$timestamp.enc');
    await file.writeAsString(fileContent);
    return file;
  }

  /// Decrypts the content of a backup file using the given password.
  /// Returns the original JSON string.
  static String decryptBackup({
    required String fileContent,
    required String password,
  }) {
    try {
      final parts = fileContent.trim().split(':');
      if (parts.length != 2) {
        throw const FormatException('Invalid backup file format');
      }

      final iv = encrypt.IV.fromBase64(parts[0]);
      final encryptedData = encrypt.Encrypted.fromBase64(parts[1]);

      final keyBytes = sha256.convert(utf8.encode(password)).bytes;
      final key = encrypt.Key(Uint8List.fromList(keyBytes));

      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      
      final decrypted = encrypter.decrypt(encryptedData, iv: iv);
      return decrypted;
    } catch (e) {
      if (e is FormatException) rethrow;
      throw Exception('Decryption failed. Please check your password.');
    }
  }
}

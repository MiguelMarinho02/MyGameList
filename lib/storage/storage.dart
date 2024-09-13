import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseStorage download = FirebaseStorage.instance;

  Future uploadImage(String fileName, Uint8List file) async {
    Reference ref = storage.ref().child("/profile_pictures/$fileName");
    UploadTask uploadTask = ref.putData(file);
    await uploadTask;
  }

  Future downloadImage(String? fileName) async {
    try {
      Reference ref = download.ref().child("/profile_pictures/$fileName");

      final appDocDir = await getApplicationDocumentsDirectory();
      String filePath = "${appDocDir.absolute}/images";

      final imagesDir = Directory("${appDocDir.path}/images");

      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      filePath = "${imagesDir.path}/$fileName";
      final localFile = File(filePath);

      await ref.writeToFile(localFile);
      await evictImageCache(filePath); //clear previously cached profile image
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  Future<String> downloadGameImage(String id) async {
    try {
      Reference ref = download.ref().child("/game_avatar/$id.jpg");
      return await ref.getDownloadURL();
    } catch (e) {
      return "";
    }
  }

  Future<String> getUserImagePath(User? user) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    String filePath = "${appDocDir.path}/images/${user?.photoURL}";
    return filePath;
  }

  Future<void> evictImageCache(String path) async {
    final fileImage = FileImage(File(path));
    await fileImage.evict();
  }
}

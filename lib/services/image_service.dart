import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();
  final _storage = FirebaseStorage.instance;

  Future<File?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  Future<String> uploadImage(File image, String path,  String token) async {
    try {
      final ref = _storage.ref().child(path);
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
          'authToken': token,
        },
      );

      final task = ref.putFile(image, metadata);

      task.snapshotEvents.listen((snapshot) {
        print('Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
      });

      final snapshot = await task;
      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      log('Firebase Storage Error [${e.code}]: ${e.message}');
      rethrow;
    } catch (e) {
      log('Upload error: $e');
      rethrow;
    }
  }

}
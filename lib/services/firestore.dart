import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload an image to Firebase Storage
  Future<String> uploadImage(File image, String folderName) async {
    try {
      // Check if the folder exists, if not create it
      final Reference folderRef = _storage.ref().child(folderName);

      // Create image name based on upload time and folder name
      final DateTime now = DateTime.now();
      final String imageName = '${now.toIso8601String()}_$folderName.jpg';

      // Upload image
      final Reference imageRef = folderRef.child(imageName);
      await imageRef.putFile(image);

      // Get download URL
      final String downloadURL = await imageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Function to get the local path for the image (for demonstration purposes)
  Future<File> getLocalImageFile(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/$filename');
  }
}

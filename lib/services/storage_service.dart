import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = Uuid();

  /// Uploads a file to Firebase Storage
  /// Returns the download URL of the uploaded file
  Future<String> uploadFile(File file, String folder) async {
  try {
    // Create a unique filename using UUID
    final String fileName = '${_uuid.v4()}${path.extension(file.path)}';
    
    // Create reference to the file location
    final Reference reference = _storage.ref().child('$folder/$fileName');
    
    // Upload the file
    final UploadTask uploadTask = reference.putFile(file);
    
    // Wait for the upload to complete and get the download URL
    final TaskSnapshot taskSnapshot = await uploadTask;
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    
    return downloadUrl;
  } catch (e) {
    throw Exception('Failed to upload file: $e');
  }
}
  /// Uploads multiple files to Firebase Storage
  /// Returns a list of download URLs for the uploaded files
  Future<List<String>> uploadMultipleFiles(List<File> files, String folder) async {
    try {
      final List<String> downloadUrls = [];
      
      for (final File file in files) {
        final String url = await uploadFile(file, folder);
        downloadUrls.add(url);
      }
      
      return downloadUrls;
    } catch (e) {
      throw Exception('Failed to upload multiple files: $e');
    }
  }

  /// Deletes a file from Firebase Storage using its URL
  Future<void> deleteFile(String fileUrl) async {
    try {
      // Create a reference from the file URL
      final Reference reference = _storage.refFromURL(fileUrl);
      
      // Delete the file
      await reference.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  /// Deletes multiple files from Firebase Storage using their URLs
  Future<void> deleteMultipleFiles(List<String> fileUrls) async {
    try {
      for (final String url in fileUrls) {
        await deleteFile(url);
      }
    } catch (e) {
      throw Exception('Failed to delete multiple files: $e');
    }
  }

  /// Gets the download URL for a file from its path in storage
  Future<String> getDownloadURL(String storagePath) async {
    try {
      final Reference reference = _storage.ref().child(storagePath);
      return await reference.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }

  /// Lists all files in a specified folder
  Future<List<String>> listFiles(String folder) async {
    try {
      final ListResult result = await _storage.ref().child(folder).listAll();
      final List<String> fileUrls = [];
      
      for (final Reference ref in result.items) {
        final String url = await ref.getDownloadURL();
        fileUrls.add(url);
      }
      
      return fileUrls;
    } catch (e) {
      throw Exception('Failed to list files: $e');
    }
  }
}
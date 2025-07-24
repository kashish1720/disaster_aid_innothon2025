import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/request_model.dart';
import 'auth_service.dart';
import 'storage_service.dart';

class RequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storageService = StorageService();
  final AuthService _authService = AuthService();
  final String _collection = 'aidRequests';

  /// Get all aid requests
  Future<List<AidRequest>> getRequests() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection(_collection).get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return AidRequest(
          id: doc.id,
          name: data['name'] ?? '',
          phone: data['phone'] ?? '',
          email: data['email'] ?? '',
          address: data['address'] ?? '',
          requestType: data['requestType'] ?? '',
          description: data['description'] ?? '',
          timestamp: data['timestamp'] ?? DateTime.now().toIso8601String(),
          status: data['status'] ?? 'pending',
          imagePaths: List<String>.from(data['imagePaths'] ?? []),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get requests: $e');
    }
  }

  /// Get all aid requests for the current user
  Future<List<AidRequest>> getUserRequests() async {
    try {
      final user = _authService.currentUser;
      
      if (user == null) {
        return [];
      }
      
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: user.uid)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return AidRequest(
          id: doc.id,
          name: data['name'] ?? '',
          phone: data['phone'] ?? '',
          email: data['email'] ?? '',
          address: data['address'] ?? '',
          requestType: data['requestType'] ?? '',
          description: data['description'] ?? '',
          timestamp: data['timestamp'] ?? DateTime.now().toIso8601String(),
          status: data['status'] ?? 'pending',
          imagePaths: List<String>.from(data['imagePaths'] ?? []),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get user requests: $e');
    }
  }

  /// Get a single aid request by ID
  Future<AidRequest> getRequestById(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection(_collection).doc(id).get();
      
      if (!doc.exists) {
        throw Exception('Request not found');
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return AidRequest(
        id: doc.id,
        name: data['name'] ?? '',
        phone: data['phone'] ?? '',
        email: data['email'] ?? '',
        address: data['address'] ?? '',
        requestType: data['requestType'] ?? '',
        description: data['description'] ?? '',
        timestamp: data['timestamp'] ?? DateTime.now().toIso8601String(),
        status: data['status'] ?? 'pending',
        imagePaths: List<String>.from(data['imagePaths'] ?? []),
      );
    } catch (e) {
      throw Exception('Failed to get request: $e');
    }
  }

  /// Create a new aid request with images
  Future<String> createRequest(Map<String, dynamic> requestData, List<File> images) async {
    try {
      // Upload images first if any
      List<String> imagePaths = [];
      if (images.isNotEmpty) {
        imagePaths = await _storageService.uploadMultipleFiles(images, 'requests');
      }
      
      // Add image paths to request data
      requestData['imagePaths'] = imagePaths;
      
      // Add to Firestore
      final DocumentReference docRef = await _firestore.collection(_collection).add(requestData);
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }

  /// Update the status of an aid request
  Future<void> updateRequestStatus(String id, String status) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'status': status,
      });
    } catch (e) {
      throw Exception('Failed to update request status: $e');
    }
  }
}
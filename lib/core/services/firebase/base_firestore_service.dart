import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:service_reservation_system/core/services/firebase/query_filter.dart';

abstract class BaseFirestoreService {
  final FirebaseFirestore firestore;

  BaseFirestoreService(this.firestore);

  Future<void> create(String collection, String? id, Map<String, dynamic> data);
  Future<T?> read<T>(
    String collection,
    String id,
    T Function(Map<String, dynamic>) fromMap,
  );
  Future<void> update(String collection, String id, Map<String, dynamic> data);
  Future<void> delete(String collection, String id);
  Future<List<T>> query<T>(
    String collection,
    T Function(Map<String, dynamic>) fromMap, {
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  });
}

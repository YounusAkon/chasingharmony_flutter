import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  final Map<String, Uint8List> _memoryCache = {};

  Future<Uint8List?> fetchImage(String url) async {
    if (_memoryCache.containsKey(url)) return _memoryCache[url];

    try {
      final bytes = await compute(_fetchImageBytes, url);
      if (bytes != null) _memoryCache[url] = bytes;
      return bytes;
    } catch (_) {
      return null;
    }
  }

  /// Remove a single URL from the in-memory cache so the next fetch always
  /// goes to the network. Call this after uploading a new/updated image.
  void evict(String url) => _memoryCache.remove(url);

  /// Wipe the entire in-memory image cache.
  void clearAll() => _memoryCache.clear();

  // isolate-friendly method
  static Future<Uint8List?> _fetchImageBytes(String url) async {
    if (url.isEmpty) return null;
    try {
      final response = await Dio().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data!);
    } catch (_) {
      return null;
    }
  }
}

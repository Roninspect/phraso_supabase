import 'dart:io';
import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phraso/core/helper/failure.dart';
import 'package:phraso/core/helper/typedefs.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class ImageUpload {
  final supabase.SupabaseClient _client;

  ImageUpload({
    required supabase.SupabaseClient client,
  }) : _client = client;

  FutureEither<String?> storeTripImageUrl({
    Uint8List? image,
    required String tripName,
    required String startDate,
    required String imageExtensions,
    required String where,
  }) async {
    try {
// Pick an image.

      final userId = _client.auth.currentUser!.id;

      final String imagepath = '/$userId/${tripName + startDate + where}';

      await _client.storage.from("trip_backgrounds").uploadBinary(
          imagepath, image!,
          fileOptions: supabase.FileOptions(
              upsert: true, contentType: 'image/$imageExtensions'));

      final String imageUrl =
          _client.storage.from("trip_backgrounds").getPublicUrl(imagepath);
      print(imageUrl);
      return right(imageUrl);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

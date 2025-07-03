// import 'dart:io';
// import 'package:path/path.dart' as path;

// class StorageHelper {
//   static Future<String> _getFolderPath() async {
//     final Directory dir = Directory(
//       '/storage/emulated/0/DCIM/FlutterNativeCam',
//     );
//     if (!await dir.exists()) await dir.create(recursive: true);
//     return dir.path;
//   }

//   static Future<File> saveImage(File file, String prefix) async {
//     final String dirPath = await _getFolderPath();
//     final String fileName =
//         '${prefix}_${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
//     final String savedPath = path.join(dirPath, fileName);
//     return await file.copy(savedPath);
//   }
// }

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageHelper {
  /// Mendapatkan folder yang aman untuk menyimpan gambar
  static Future<String> _getFolderPath() async {
    // ✅ Cek dan minta permission
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      throw Exception("Izin penyimpanan tidak diberikan");
    }

    // ✅ Ambil direktori eksternal (bisa juga gunakan getApplicationDocumentsDirectory jika private)
    final Directory? extDir = await getExternalStorageDirectory();
    final Directory targetDir = Directory('${extDir?.path}/FlutterNativeCam');

    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    return targetDir.path;
  }

  /// Simpan file ke folder tersebut
  static Future<File> saveImage(File file, String folderName) async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/$folderName');

    if (!folder.existsSync()) folder.createSync(recursive: true);

    final targetPath = '${folder.path}/${path.basename(file.path)}';

    final XFile? compressedXFile =
        await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          targetPath,
          quality: 60,
        );

    if (compressedXFile == null) return file;

    return File(compressedXFile.path);
  }
}

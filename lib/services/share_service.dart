import 'dart:io';

import 'package:share_plus/share_plus.dart';

import '../core/error/app_exceptions.dart';

class ShareService {
  Future<void> shareFile(File file, {String text = 'Milk report'}) async {
    try {
      await Share.shareXFiles([XFile(file.path)], text: text);
    } catch (e) {
      throw ShareException('Sharing failed: $e');
    }
  }
}

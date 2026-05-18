import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../core/error/app_exceptions.dart';
import '../domain/entities/entities.dart';

class PdfService {
  Future<File> generateMonthlySummary({required String title, required List<MilkEntry> entries, required Map<String, Supplier> supplierMap}) async {
    try {
      final doc = pw.Document();
      doc.addPage(pw.MultiPage(build: (_) {
        return [
          pw.Text('દૂધ કલેકશન રિપોર્ટ / Milk Collection Report', style: pw.TextStyle(fontSize: 18)),
          pw.SizedBox(height: 8),
          pw.Text(title),
          pw.Table.fromTextArray(
            headers: ['Date', 'Supplier', 'Type', 'Liters', 'Fat', 'Rate', 'Amount'],
            data: entries.map((e) => [
                  e.date.toIso8601String().split('T').first,
                  supplierMap[e.supplierId]?.name ?? '-',
                  e.milkType.name,
                  e.liters.toStringAsFixed(2),
                  e.fat.toStringAsFixed(1),
                  e.rate.toStringAsFixed(2),
                  e.amount.toStringAsFixed(2),
                ]).toList(),
          )
        ];
      }));
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/milk_report.pdf');
      await file.writeAsBytes(await doc.save());
      return file;
    } catch (e) {
      throw PdfGenerationException('PDF generation failed: $e');
    }
  }
}

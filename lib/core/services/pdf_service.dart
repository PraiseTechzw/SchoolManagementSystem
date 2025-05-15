import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../config/app_config.dart';
import '../../features/fees/data/models/payment_model.dart';
import '../../features/grades/data/models/grade_model.dart';

/// Service for PDF generation and handling
class PdfService {
  /// Generate a payment receipt PDF
  static Future<Uint8List> generatePaymentReceipt(
    PaymentModel payment,
    String schoolName,
    String schoolAddress,
    String studentName,
    String studentClass,
  ) async {
    final pdf = pw.Document();
    
    // Load font
    final font = await PdfGoogleFonts.nunitoRegular();
    final fontBold = await PdfGoogleFonts.nunitoBold();
    
    // Format date
    final dateFormatter = DateFormat('dd MMMM yyyy');
    final formattedDate = dateFormatter.format(payment.paymentDate);
    
    // Format amount
    final currencyFormatter = NumberFormat.currency(
      symbol: payment.currency == 'USD' ? '\$' : 'ZWL\$',
      decimalDigits: 2,
    );
    
    final formattedAmount = currencyFormatter.format(payment.amount);
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          schoolName,
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 20,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          schoolAddress,
                          style: pw.TextStyle(font: font, fontSize: 10),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'RECEIPT',
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 24,
                            color: PdfColors.blue900,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Receipt No: ${payment.id.substring(0, 8).toUpperCase()}',
                          style: pw.TextStyle(font: font, fontSize: 10),
                        ),
                        pw.Text(
                          'Date: $formattedDate',
                          style: pw.TextStyle(font: font, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
                
                pw.SizedBox(height: 40),
                
                // Student info
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Received From:',
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                                color: PdfColors.grey700,
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              studentName,
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 12,
                              ),
                            ),
                            pw.Text(
                              'Class: $studentClass',
                              style: pw.TextStyle(font: font, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Payment Method:',
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                                color: PdfColors.grey700,
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              payment.paymentMethod,
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 12,
                              ),
                            ),
                            if (payment.reference.isNotEmpty)
                              pw.Text(
                                'Reference: ${payment.reference}',
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                pw.SizedBox(height: 20),
                
                // Payment details
                pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.grey300,
                    width: 0.5,
                  ),
                  children: [
                    // Header row
                    pw.TableRow(
                      decoration: pw.BoxDecoration(
                        color: PdfColors.blue50,
                      ),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Text(
                            'Description',
                            style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Text(
                            'Amount',
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Data row
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Text(
                            payment.description,
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Text(
                            formattedAmount,
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                pw.SizedBox(height: 5),
                
                // Total
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue900,
                    borderRadius: const pw.BorderRadius.only(
                      bottomLeft: pw.Radius.circular(5),
                      bottomRight: pw.Radius.circular(5),
                    ),
                  ),
                  child: pw.Text(
                    'Total: $formattedAmount',
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 14,
                      color: PdfColors.white,
                    ),
                  ),
                ),
                
                pw.SizedBox(height: 40),
                
                // Notes and signature
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Notes:',
                            style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 10,
                            ),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            payment.notes.isNotEmpty
                                ? payment.notes
                                : 'Thank you for your payment.',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      width: 150,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Container(
                            height: 1,
                            width: 150,
                            color: PdfColors.black,
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            'Authorized Signature',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                pw.Spacer(),
                
                // Footer
                pw.Center(
                  child: pw.Text(
                    'Generated by ${AppConfig.appName} - ${DateTime.now().year}',
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 8,
                      color: PdfColors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    
    return pdf.save();
  }
  
  /// Generate a report card PDF
  static Future<Uint8List> generateReportCard(
    List<GradeModel> grades,
    String schoolName,
    String schoolLogo,
    String studentName,
    String studentId,
    String studentClass,
    String term,
    int year,
    Map<String, double> averages,
    String teacherComment,
    String principalComment,
  ) async {
    final pdf = pw.Document();
    
    // Load fonts
    final font = await PdfGoogleFonts.nunitoRegular();
    final fontBold = await PdfGoogleFonts.nunitoBold();
    
    // Group grades by subject
    final Map<String, List<GradeModel>> gradesBySubject = {};
    for (final grade in grades) {
      if (!gradesBySubject.containsKey(grade.subject)) {
        gradesBySubject[grade.subject] = [];
      }
      gradesBySubject[grade.subject]!.add(grade);
    }
    
    // Function to determine grade letter
    String getGradeLetter(double score) {
      if (score >= 90) return 'A+';
      if (score >= 80) return 'A';
      if (score >= 70) return 'B';
      if (score >= 60) return 'C';
      if (score >= 50) return 'D';
      return 'F';
    }
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          schoolName,
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 20,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Academic Year: $year',
                          style: pw.TextStyle(font: font, fontSize: 12),
                        ),
                        pw.Text(
                          'Term: $term',
                          style: pw.TextStyle(font: font, fontSize: 12),
                        ),
                      ],
                    ),
                    pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        'REPORT CARD',
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 24,
                          color: PdfColors.blue900,
                        ),
                      ),
                    ),
                  ],
                ),
                
                pw.SizedBox(height: 20),
                
                // Student info
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Student Name:',
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                                color: PdfColors.grey700,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              studentName,
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Student ID:',
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                                color: PdfColors.grey700,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              studentId,
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Class:',
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                                color: PdfColors.grey700,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              studentClass,
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                pw.SizedBox(height: 20),
                
                // Grades table
                pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.grey300,
                    width: 0.5,
                  ),
                  children: [
                    // Header row
                    pw.TableRow(
                      decoration: pw.BoxDecoration(
                        color: PdfColors.blue50,
                      ),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'Subject',
                            style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'Quiz',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'Assignment',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'Midterm',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'Final',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'Average',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'Grade',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Subject rows
                    ...gradesBySubject.entries.map((entry) {
                      final subject = entry.key;
                      final subjectGrades = entry.value;
                      
                      // Get scores by type
                      double? quizScore;
                      double? assignmentScore;
                      double? midtermScore;
                      double? finalScore;
                      
                      for (final grade in subjectGrades) {
                        switch (grade.type) {
                          case 'Quiz':
                            quizScore = grade.score;
                            break;
                          case 'Assignment':
                            assignmentScore = grade.score;
                            break;
                          case 'Midterm':
                            midtermScore = grade.score;
                            break;
                          case 'Final':
                            finalScore = grade.score;
                            break;
                        }
                      }
                      
                      // Calculate average
                      final nonNullScores = [
                        if (quizScore != null) quizScore,
                        if (assignmentScore != null) assignmentScore,
                        if (midtermScore != null) midtermScore,
                        if (finalScore != null) finalScore,
                      ];
                      
                      final average = nonNullScores.isNotEmpty
                          ? nonNullScores.reduce((a, b) => a + b) / nonNullScores.length
                          : 0.0;
                      
                      final gradeLetter = getGradeLetter(average);
                      
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              subject,
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              quizScore?.toString() ?? '-',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              assignmentScore?.toString() ?? '-',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              midtermScore?.toString() ?? '-',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              finalScore?.toString() ?? '-',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              average.toStringAsFixed(1),
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              gradeLetter,
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 10,
                                color: gradeLetter == 'F'
                                    ? PdfColors.red
                                    : PdfColors.black,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
                
                pw.SizedBox(height: 15),
                
                // Overall average
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue900,
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Text(
                    'Overall Average: ${averages['overall']?.toStringAsFixed(1) ?? '0.0'} (${getGradeLetter(averages['overall'] ?? 0.0)})',
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 12,
                      color: PdfColors.white,
                    ),
                  ),
                ),
                
                pw.SizedBox(height: 20),
                
                // Comments
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(5),
                    border: pw.Border.all(
                      color: PdfColors.grey300,
                      width: 0.5,
                    ),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Teacher\'s Comment:',
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 10,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        teacherComment,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 10,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.SizedBox(height: 15),
                      pw.Text(
                        'Principal\'s Comment:',
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 10,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        principalComment,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 10,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ),
                
                pw.SizedBox(height: 30),
                
                // Signatures
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Container(
                          height: 1,
                          width: 120,
                          color: PdfColors.black,
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Class Teacher',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Container(
                          height: 1,
                          width: 120,
                          color: PdfColors.black,
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Principal',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Container(
                          height: 1,
                          width: 120,
                          color: PdfColors.black,
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Parent/Guardian',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                pw.Spacer(),
                
                // Footer
                pw.Center(
                  child: pw.Text(
                    'Generated by ${AppConfig.appName} - ${DateTime.now().year}',
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 8,
                      color: PdfColors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    
    return pdf.save();
  }
  
  /// Save PDF to file
  static Future<File> savePdf({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }
  
  /// Print PDF
  static Future<void> printPdf(Uint8List bytes) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => bytes,
    );
  }
  
  /// Share PDF
  static Future<void> sharePdf({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final file = await savePdf(fileName: fileName, bytes: bytes);
    await Share.shareFiles([file.path], text: 'Sharing $fileName');
  }
}

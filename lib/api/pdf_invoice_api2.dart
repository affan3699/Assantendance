import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import 'PDF_API.dart';

class PdfInvoiceApi2 {
  static Future<File> generate(List<String> month, List<String> dates,
      List<String> checkIn, List<String> checkOut) async {
    final pdf = Document();
    List<String> tempDates = <String>[];
    List<String> tempCheckIns = <String>[];
    List<String> tempCheckOuts = <String>[];

    for (int i = 0; i < month.length; i++) {
      tempDates.clear();
      tempCheckIns.clear();
      tempCheckOuts.clear();

      String getMonth = dates[i].toString().split(" ")[1];
      //print(getMonth);
      //print(month[i]);
      print('Hello');

      for (int j = 0; j < dates.length; j++) {
        if (month[i] == dates[j].toString().split(" ")[1]) {
          tempDates.add(dates[j]);
          tempCheckOuts.add(checkOut[j]);
          tempCheckIns.add(checkIn[j]);
        }
      }

      pdf.addPage(MultiPage(
        build: (context) => [
          buildTitle(month[i].toUpperCase()),
          buildAttendanceData(tempDates, tempCheckIns, tempCheckOuts),
          Divider(),
          //buildTotal(invoice),
        ],
      ));
    }

    return PdfApi.saveDocument(name: 'Attendance_Report_$month.pdf', pdf: pdf);
  }

  static Widget buildTitle(String month) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'ATTENDANCE REPORT: $month 2022',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          //Text("HEllO"),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildAttendanceData(
      List<String> dates, List<String> checkIn, List<String> checkOut) {
    final headers = [
      'Date',
      'Check In',
      'Check Out',
    ];

    var purchasesAsMap = <Map<String, String>>[
      for (int i = 0; i < dates.length; i++)
        {
          "Dates": "${dates[i]}",
          "Check In": "${checkIn[i]}",
          "Check Out": "${checkOut[i]}",
        },
    ];

    List<List<String>> listOfPurchases = [];
    for (int i = 0; i < purchasesAsMap.length; i++) {
      listOfPurchases.add(purchasesAsMap[i].values.toList());
    }

    return Table.fromTextArray(
      headers: headers,
      data: listOfPurchases,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.blue100),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.center,
        2: Alignment.center,
      },
    );
  }

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}

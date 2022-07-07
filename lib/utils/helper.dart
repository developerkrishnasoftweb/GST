import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gst/constants/app_constants.dart';
import 'package:gst/model/gst_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Fonts directory
final _kFontsDir =
    "assets${Platform.pathSeparator}fonts${Platform.pathSeparator}";

///
/// Method to create PDF
///

Future<Uint8List> createPDF(GstModel gst) async {
  final invoiceNumber = await _createInvoiceNumber();
  final billNumber = await _createBillNumber();

  DateTime now = DateTime.now();
  String date = DateFormat('dd/MM/yyyy').format(now);

  pw.ThemeData theme = pw.ThemeData.withFont(
    base: pw.Font.ttf(
      await rootBundle.load("${_kFontsDir}NotoSans-Regular.ttf"),
    ),
    bold: pw.Font.ttf(
      await rootBundle.load("${_kFontsDir}NotoSans-Bold.ttf"),
    ),
    italic: pw.Font.ttf(
      await rootBundle.load("${_kFontsDir}NotoSans-Italic.ttf"),
    ),
    boldItalic: pw.Font.ttf(
      await rootBundle.load("${_kFontsDir}NotoSans-BoldItalic.ttf"),
    ),
  );

  final pdfDocument = pw.Document(theme: theme);

  var assetImage1 = pw.MemoryImage(
    (await rootBundle.load('assets/images/gst_main.png'))
        .buffer
        .asUint8List(),
  );

  var assetImage2 = pw.MemoryImage(
    (await rootBundle.load('assets/images/ashok.png')).buffer.asUint8List(),
  );

  var assetImage3 = pw.MemoryImage(
    (await rootBundle.load('assets/images/sign.jpg')).buffer.asUint8List(),
  );

  var assetImage4 = pw.MemoryImage(
    (await rootBundle.load('assets/images/stamp.jpeg')).buffer.asUint8List(),
  );

  var assetImage5 = pw.MemoryImage(
    (await rootBundle.load('assets/images/qr_scan.png')).buffer.asUint8List(),
  );

  pdfDocument.addPage(
    pw.Page(
      orientation: pw.PageOrientation.portrait,
      build: (pw.Context _) {
        return pw.Container(
            height: 1200,
            width: 800,
            decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColor.fromHex("#000000"))),
            child: pw.Column(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                      vertical: 5, horizontal: 5),
                  child: pw.Container(
                      height: 100,
                      child: pw.Image(assetImage1, fit: pw.BoxFit.fill)),
                ),
                pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                    child: pw.Divider(height: 2)),
                pw.SizedBox(height: 10),
                pw.Stack(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 10.h),
                    child: pw.Center(
                      child: pw.Opacity(
                        opacity: 0.2,
                        child: pw.Container(
                          height: 700.h,
                          child: pw.Image(
                            assetImage2,
                            //fit: pw.BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  pw.Column(children: [
                    pw.Text(
                      "Goods & Service Tax",
                      style: pw.TextStyle(
                          fontSize: 14.sp,
                          color: PdfColor.fromHex("#000000"),
                          fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 10.h),
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.w),
                      child: pw.Row(
                          mainAxisAlignment:
                          pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Column(
                                crossAxisAlignment:
                                pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    "Bill To:",
                                    style: pw.TextStyle(
                                        fontSize: 12.sp,
                                        color: PdfColor.fromHex("#000000"),
                                        fontWeight: pw.FontWeight.bold),
                                  ),
                                  pw.Text(
                                    gst.billTo,
                                    style: pw.TextStyle(
                                        fontSize: 12.sp,
                                        color: PdfColor.fromHex("#000000"),
                                        fontWeight: pw.FontWeight.bold),
                                  ),
                                ]),
                            pw.Row(children: [
                              pw.BarcodeWidget(
                                color: PdfColor.fromHex("#000000"),
                                barcode: pw.Barcode.qrCode(),
                                width: 50,
                                height: 50,
                                data: "Bill To: ${gst.billTo} Loan Amount ${gst.loanAmount}.0 Total Amount ${gst.totalAmount}.00 GST Amount ${gst.gstAmount}.00 GST Percent ${gst.gstTax}% Texable amount ${gst.totalAmount}.00 Rate ${gst.gstTax}% Tax amount ${gst.gstAmount}.00 Total ${gst.amount}.00",
                              ),
                              pw.SizedBox(width: 10),
                              pw.Column(children: [
                                pw.Text(
                                  "Invoice No: 858624$invoiceNumber",
                                  style: pw.TextStyle(
                                      fontSize: 12.sp,
                                      color: PdfColor.fromHex("#63A7BC"),
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  "Date: $date",
                                  style: pw.TextStyle(
                                      fontSize: 12.sp,
                                      color: PdfColor.fromHex("#63A7BC"),
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  "E-way Bill no: 682709$billNumber",
                                  style: pw.TextStyle(
                                      fontSize: 12.sp,
                                      color: PdfColor.fromHex("#63A7BC"),
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ]),
                            ])
                          ]),
                    ),
                    pw.SizedBox(height: 10.h),
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.w),
                      child: pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 5,
                        ),
                        color: PdfColor.fromHex("#63A7BC"),
                        child: pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                "#",
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.white,
                                ),
                              ),
                            ),
                            pw.Expanded(
                              //flex: 2,
                              child: pw.Text(
                                "Item Name",
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.white,
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                "HSN/SAC",
                                textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.white,
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                "Loan/Amount",
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.white,
                                ),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                "Total Amount",
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.white,
                                ),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                "GST",
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.white,
                                ),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                "Amount",
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.white,
                                ),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.w),
                      child: pw.ListView.separated(
                        itemBuilder: (_, index) {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 5,
                            ),
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                  child: pw.Text("1"),
                                ),
                                pw.Expanded(
                                  //flex: 2,
                                  child: pw.Text("Goods and Service Tax"),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    "",
                                    textAlign: pw.TextAlign.right,
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    "",
                                    textAlign: pw.TextAlign.right,
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    "\u20b9 ${gst.totalAmount}",
                                    textAlign: pw.TextAlign.right,
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    "\u20b9 ${gst.gstAmount}\n${gst.gstTax}%",
                                    textAlign: pw.TextAlign.right,
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    "\u20b9 ${gst.amount}",
                                    textAlign: pw.TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: 1,
                        separatorBuilder: (_, __) {
                          return pw.Divider(
                            height: 0.5,
                            thickness: 0.5,
                          );
                        },
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.w),
                      child: pw.Divider(
                        height: 0.5,
                        thickness: 0.5,
                      ),
                    ),

// Total
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.w),
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 5,
                        ),
                        child: pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.SizedBox(),
                            ),
                            pw.Expanded(
                              //flex: 2,
                              child: pw.Text(
                                "Total",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.SizedBox(),
                            ),
                            pw.Expanded(
                              child: pw.Text("\u20b9 ${gst.loanAmount}",
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Expanded(
                              child: pw.SizedBox(),
                            ),
                            pw.Expanded(
                              child: pw.Text("\u20b9 ${gst.gstAmount}",
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                  "\u20b9 ${gst.amount}",
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.w),
                      child: pw.Divider(
                        height: 0.5,
                        thickness: 0.5,
                      ),
                    ),

                    pw.SizedBox(height: 20.h),
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.w),
                      child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                              child: pw.Column(children: [
                                pw.Align(
                                  alignment: pw.Alignment.topLeft,
                                  child: pw.Container(
                                    //width: 400,
                                    padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 5,
                                    ),
                                    color: PdfColor.fromHex("#63A7BC"),
                                    child: pw.Row(
                                      children: [
                                        pw.Expanded(
                                          child: pw.Text(
                                            "Tax Type",
                                            style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ),
                                        pw.Expanded(
                                          flex: 2,
                                          child: pw.Text(
                                            "Taxable Amount",
                                            style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ),
                                        pw.Expanded(
                                          child: pw.Text(
                                            "Rate",
                                            style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ),
                                        pw.Expanded(
                                          flex: 2,
                                          child: pw.Text(
                                            "Tax Amount",
                                            style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                pw.Align(
                                  alignment: pw.Alignment.topLeft,
                                  child: pw.Container(
                                    //width: 400,
                                    padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 5,
                                    ),
                                    child: pw.Row(
                                      children: [
                                        pw.Expanded(
                                          child: pw.Text(
                                            "SGST",
                                          ),
                                        ),
                                        pw.Expanded(
                                          flex: 2,
                                          child: pw.Text(
                                              "\u20b9 ${gst.totalAmount}",
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                  pw.FontWeight.bold)),
                                        ),
                                        pw.Expanded(
                                          child: pw.Text("${gst.gstTax}%",
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                  pw.FontWeight.bold)),
                                        ),
                                        pw.Expanded(
                                          flex: 2,
                                          child: pw.Text(
                                              "\u20b9 ${gst.gstAmount}",
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                  pw.FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                pw.Align(
                                  alignment: pw.Alignment.topLeft,
                                  child: pw.Container(
                                    //width: 400,
                                    padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 5,
                                    ),
                                    child: pw.Row(
                                      children: [
                                        pw.Expanded(
                                          child: pw.Text(
                                            "CGST",
                                          ),
                                        ),
                                        pw.Expanded(
                                          flex: 2,
                                          child: pw.Text(
                                              "\u20b9 ${gst.totalAmount}",
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                  pw.FontWeight.bold)),
                                        ),
                                        pw.Expanded(
                                          child: pw.Text("${gst.gstTax}%",
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                  pw.FontWeight.bold)),
                                        ),
                                        pw.Expanded(
                                          flex: 2,
                                          child: pw.Text(
                                              "\u20b9 ${gst.gstAmount}",
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                  pw.FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            pw.SizedBox(width: 5),
                            pw.Expanded(
                              child: pw.Column(children: [
                                pw.Align(
                                  alignment: pw.Alignment.topLeft,
                                  child: pw.Container(
                                    //width: 300,
                                    padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 5,
                                    ),
                                    color: PdfColor.fromHex("#63A7BC"),
                                    child: pw.Row(children: [
                                      pw.Expanded(
                                        child: pw.Text(
                                          "Amounts",
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            color: PdfColors.white,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                                pw.Align(
                                  alignment: pw.Alignment.topLeft,
                                  child: pw.Container(
                                    //width: 300,
                                    padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 5,
                                    ),
                                    child: pw.Row(
                                        mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text(
                                            "SubTotal",
                                          ),
                                          pw.Padding(
                                            padding:
                                            const pw.EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: pw.Text(
                                              "\u20b9 ${gst.amount}",
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                                pw.Divider(
                                  height: 0.5,
                                  thickness: 0.5,
                                ),
                                pw.Align(
                                  alignment: pw.Alignment.topLeft,
                                  child: pw.Container(
                                    //width: 300,
                                    padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 5,
                                    ),
                                    child: pw.Row(
                                        mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text("Total",
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                  pw.FontWeight.bold)),
                                          pw.Padding(
                                            padding:
                                            const pw.EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: pw.Text(
                                                "\u20b9 ${gst.amount}",
                                                style: pw.TextStyle(
                                                    fontWeight:
                                                    pw.FontWeight.bold)),
                                          ),
                                        ]),
                                  ),
                                ),
                                pw.Divider(
                                  height: 0.5,
                                  thickness: 0.5,
                                ),
                              ]),
                            ),
                          ]),
                    ),
                    pw.SizedBox(height: 20.h),

                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.w),
                      child: pw.Row(children: [
                        pw.Expanded(
                          child: pw.Column(children: [
                            pw.Align(
                              alignment: pw.Alignment.topLeft,
                              child: pw.Container(
                                // width: 400,
                                padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                color: PdfColor.fromHex("#63A7BC"),
                                child: pw.Row(children: [
                                  pw.Expanded(
                                    child: pw.Text(
                                      "Invoice Amount In Words:",
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            pw.SizedBox(height: 5.h),
                            pw.Align(
                              alignment: pw.Alignment.topLeft,
                              child: pw.Text(
                                gst.invoiceWordAmount,
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                          ]),
                        ),
                        pw.Expanded(child: pw.SizedBox()),
                      ]),
                    ),
                    pw.SizedBox(height: 20.h),
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.w),
                      child: pw.Row(children: [
                        pw.Expanded(
                          child: pw.Column(children: [
                            pw.Align(
                              alignment: pw.Alignment.topLeft,
                              child: pw.Container(
                                //width: 400,
                                padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                color: PdfColor.fromHex("#63A7BC"),
                                child: pw.Row(children: [
                                  pw.Text(
                                    "Description:",
                                    style: pw.TextStyle(
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            pw.SizedBox(height: 5.h),
                            pw.Align(
                              alignment: pw.Alignment.topLeft,
                              child: pw.Container(
                                width: 400,
                                child: pw.Text(
                                  "Just You Need To Pay Goods & Service Tax SGST(${gst.gstTax}%) INR ${gst.gstAmount}.00/- & CGST(${gst.gstTax}%) INR ${gst.gstAmount}.00/- Refundable Money Only 5 min Through NEFT/RTGS/Online Banking/UPI in Following Bank Accounts.",
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.black,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        pw.Expanded(
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                              horizontal: 60,
                            ),
                            child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Container(
                                    height: 80,
                                    child: pw.Image(
                                      assetImage4,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ]),
                    ),

                    pw.SizedBox(height: 20.h),
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.w),
                      child: pw.Row(children: [
                        pw.Expanded(
                          child: pw.Column(children: [
                            pw.Align(
                              alignment: pw.Alignment.topLeft,
                              child: pw.Container(
                                padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                color: PdfColor.fromHex("#63A7BC"),
                                child: pw.Row(children: [
                                  pw.Text(
                                    "Terms and conditions:",
                                    style: pw.TextStyle(
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            pw.SizedBox(height: 5.h),
                            pw.Align(
                              alignment: pw.Alignment.topLeft,
                              child: pw.Container(
                                child: pw.Text(
                                  "Thanks you pay goods and service tax.",
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.black,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        pw.Expanded(child: pw.SizedBox()),
                      ]),
                    ),
                    pw.SizedBox(height: 30.h),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 60),
                      child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Column(children: [
                              pw.Text(
                                "For Goods & Service Tax",
                                style: pw.TextStyle(
                                    fontSize: 16.sp,
                                    color: PdfColor.fromHex("#000000"),
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Container(
                                  height: 80,
                                  child: pw.Image(assetImage3,
                                      fit: pw.BoxFit.fill)),
                              pw.Text(
                                "Authorized Signatory",
                                style: pw.TextStyle(
                                    fontSize: 16.sp,
                                    color: PdfColor.fromHex("#000000"),
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ])
                          ]),
                    ),
                    pw.SizedBox(height: 60.h),
                    pw.Text(
                      "Goods and Services Tax",
                      style: pw.TextStyle(
                          fontSize: 44.sp,
                          color: PdfColor.fromHex("#63A7BC"),
                          fontWeight: pw.FontWeight.bold),
                    ),
                  ]),
                ]),
              ],
            ));
      },
      pageFormat: PdfPageFormat.a3,
    ),
  );

  return await pdfDocument.save();
}
Future<int> _createInvoiceNumber() async {
  int? invoiceNumber = kAppStorage.getInt("invoiceNumber");

  if (invoiceNumber == null) {
    invoiceNumber = 2053;
    await kAppStorage.setInt("invoiceNumber", invoiceNumber);
  } else {
    await kAppStorage.setInt("invoiceNumber", ++invoiceNumber);
  }
  return invoiceNumber;
}

Future<int> _createBillNumber() async {
  int? billNumber = kAppStorage.getInt("billNumber");

  if (billNumber == null) {
    billNumber = 9245;
    await kAppStorage.setInt("billNumber", billNumber);
  } else {
    await kAppStorage.setInt("billNumber", ++billNumber);
  }
  return billNumber;
}
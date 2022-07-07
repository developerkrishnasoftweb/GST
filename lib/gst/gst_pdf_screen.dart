import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// Downloads directory
const _kDownloadsDirectory = "/storage/emulated/0/Download/";

class GSTPdfScreen extends StatefulWidget {
  String billTo;
  String loanAmount;
  String totalAmount;
  String gstTaxAmount;
  String gstTax;
  String taxAmount;
  String invoiceInWord;

  GSTPdfScreen(
      {Key? key,
      required this.billTo,
      required this.loanAmount,
      required this.totalAmount,
      required this.gstTaxAmount,
      required this.gstTax,
      required this.taxAmount,
      required this.invoiceInWord})
      : super(key: key);

  @override
  State<GSTPdfScreen> createState() => _GSTPdfScreenState();
}

class _GSTPdfScreenState extends State<GSTPdfScreen> {
  // Pdf Document
  pw.Document pdf = pw.Document();
  Uint8List? bytes;

  final PdfPageFormat _pageFormat = PdfPageFormat.a4;

  // Fonts directory
  final String _fontsDir =
      "assets${Platform.pathSeparator}fonts${Platform.pathSeparator}";

  String? date, time;
  int? invoiceNo, billNo;

  @override
  void initState() {
    super.initState();
    pdfCreation();
    DateTime now = DateTime.now();
    date = DateFormat('dd/MM/yyyy').format(now);
    time = DateFormat.Hms().format(now);
    init();
  }

  init() async {
    final prefs = await SharedPreferences.getInstance();

    invoiceNo = prefs.getInt('invoice');

    if (invoiceNo == null) {
      await prefs.setInt("invoice", 2053);
      invoiceNo = prefs.getInt('invoice');
    } else {
      await prefs.setInt("invoice", invoiceNo! + 1);
    }

    billNo = prefs.getInt('billNo');

    if (billNo == null) {
      await prefs.setInt("billNo", 9245);
      billNo = prefs.getInt('billNo');
    } else {
      await prefs.setInt("billNo", billNo! + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("PDF"),
        backgroundColor: const Color.fromRGBO(237, 24, 70, 1),
        actions: [
          IconButton(
            onPressed: _downloadPDF,
            icon: const Icon(Icons.download),
          ),
          IconButton(
            onPressed: pdfCreation,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: bytes != null
          ? SfPdfViewer.memory(bytes!)
          : const Center(
              child: CircularProgressIndicator(
                  color: Color.fromRGBO(237, 24, 70, 1)),
            ),
    );
  }

  pdfCreation() async {
    pw.ThemeData theme = pw.ThemeData.withFont(
      base: pw.Font.ttf(
        await rootBundle.load(_fontsDir + "NotoSans-Regular.ttf"),
      ),
      bold: pw.Font.ttf(
        await rootBundle.load(_fontsDir + "NotoSans-Bold.ttf"),
      ),
      italic: pw.Font.ttf(
        await rootBundle.load(_fontsDir + "NotoSans-Italic.ttf"),
      ),
      boldItalic: pw.Font.ttf(
        await rootBundle.load(_fontsDir + "NotoSans-BoldItalic.ttf"),
      ),
    );

    pdf = pw.Document(theme: theme);

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

    pdf.addPage(
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
                                      widget.billTo,
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
                                  width: 70,
                                  height: 70,
                                  data: "Bill To: ${widget.billTo} Loan Amount ${widget.loanAmount}.0 Total Amount ${widget.totalAmount}.00 GST Amount ${widget.gstTaxAmount}.00 GST Percent ${widget.gstTax}% Texable amount ${widget.totalAmount}.00 Rate ${widget.gstTax}% Tax amount ${widget.gstTaxAmount}.00 Total ${int.parse(widget.totalAmount) + int.parse(widget.gstTaxAmount)}.00",
                                ),
                                pw.SizedBox(width: 10),
                                pw.Column(children: [
                                  pw.Text(
                                    "Invoice No: 858624$invoiceNo",
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
                                    "E-way Bill no: 682709$billNo",
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
                                      "\u20b9 ${widget.totalAmount}",
                                      textAlign: pw.TextAlign.right,
                                    ),
                                  ),
                                  pw.Expanded(
                                    child: pw.Text(
                                      "\u20b9 ${widget.gstTaxAmount}\n${widget.gstTax}%",
                                      textAlign: pw.TextAlign.right,
                                    ),
                                  ),
                                  pw.Expanded(
                                    child: pw.Text(
                                      "\u20b9 ${int.parse(widget.totalAmount) + int.parse(widget.gstTaxAmount)}",
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
                                child: pw.Text("\u20b9 ${widget.loanAmount}",
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ),
                              pw.Expanded(
                                child: pw.SizedBox(),
                              ),
                              pw.Expanded(
                                child: pw.Text("\u20b9 ${widget.gstTaxAmount}",
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                    "\u20b9 ${int.parse(widget.totalAmount) + int.parse(widget.gstTaxAmount)}",
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
                                                "\u20b9 ${widget.totalAmount}",
                                                style: pw.TextStyle(
                                                    fontWeight:
                                                        pw.FontWeight.bold)),
                                          ),
                                          pw.Expanded(
                                            child: pw.Text("${widget.gstTax}%",
                                                style: pw.TextStyle(
                                                    fontWeight:
                                                        pw.FontWeight.bold)),
                                          ),
                                          pw.Expanded(
                                            flex: 2,
                                            child: pw.Text(
                                                "\u20b9 ${widget.gstTaxAmount}",
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
                                                "\u20b9 ${widget.totalAmount}",
                                                style: pw.TextStyle(
                                                    fontWeight:
                                                        pw.FontWeight.bold)),
                                          ),
                                          pw.Expanded(
                                            child: pw.Text("${widget.gstTax}%",
                                                style: pw.TextStyle(
                                                    fontWeight:
                                                        pw.FontWeight.bold)),
                                          ),
                                          pw.Expanded(
                                            flex: 2,
                                            child: pw.Text(
                                                "\u20b9 ${widget.gstTaxAmount}",
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
                                                "\u20b9 ${int.parse(widget.totalAmount) + int.parse(widget.gstTaxAmount)}",
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
                                                  "\u20b9 ${int.parse(widget.totalAmount) + int.parse(widget.gstTaxAmount)}",
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
                                  widget.invoiceInWord,
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
                                    "Just You Need To Pay Goods & Service Tax SGST(${widget.gstTax}%) INR ${widget.gstTaxAmount}.00/- & CGST(${widget.gstTax}%) INR ${widget.gstTaxAmount}.00/- Refundable Money Only 5 min Through NEFT/RTGS/Online Banking/UPI in Following Bank Accounts.",
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

    bytes = await pdf.save();
    setState(() {});
  }

  /// Method to download PDF
  void _downloadPDF() async {
    const permission = Permission.storage;
    if (await permission.isDenied) {
      final status = await permission.request();
      if (status.isPermanentlyDenied || status.isRestricted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "Please allow storage permission to download.",
              ),
              action: SnackBarAction(
                label: "Open App Settings",
                onPressed: () => openAppSettings(),
              ),
            ),
          );
        }
        return;
      }
    }

    if (bytes != null) {
      const path =
          "$_kDownloadsDirectory GST.pdf";

      final file = File(path);

      await file.writeAsBytes(bytes!);

      showMsg("PDF saved to downloads directory");
    } else {
      showMsg("PDF is not generated yet.");
    }
  }

  void showMsg(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
        ),
      );
    }
  }
}

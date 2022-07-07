import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gst/constants/app_constants.dart';
import 'package:gst/gst/gst_pdf_screen.dart';
import 'package:gst/model/gst_model.dart';
import 'package:gst/utils/helper.dart';
import 'package:share_plus/share_plus.dart';

class GSTFormScreen extends StatefulWidget {
  const GSTFormScreen({Key? key}) : super(key: key);

  @override
  State<GSTFormScreen> createState() => _GSTFormScreenState();
}

class _GSTFormScreenState extends State<GSTFormScreen> {
  TextEditingController billToController = TextEditingController();
  TextEditingController loanAmountController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController gstTaxAmountController = TextEditingController();
  TextEditingController gstTaxController = TextEditingController();
  TextEditingController taxAmountController = TextEditingController();
  TextEditingController invoiceAmountInWordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(237, 24, 70, 1),
        title: const Text("GST Council Tax App"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              TextFormField(
                controller: billToController,
                cursorColor: const Color.fromRGBO(237, 24, 70, 1),
                style: const TextStyle(
                  color: Color.fromRGBO(237, 24, 70, 1),
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    width: 2.w,
                  )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    width: 1.w,
                  )),
                  hintText: 'Bill To',
                  labelText: 'Bill To',
                  labelStyle: TextStyle(
                    fontSize: 15.sp,
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    fontWeight: FontWeight.w400,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.sp,
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: const Icon(
                    Icons.person_sharp,
                    color: Color.fromRGBO(237, 24, 70, 1),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              TextFormField(
                controller: loanAmountController,
                cursorColor: const Color.fromRGBO(237, 24, 70, 1),
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Color.fromRGBO(237, 24, 70, 1),
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    width: 2.w,
                  )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    width: 1.w,
                  )),
                  hintText: 'Loan/Amount',
                  labelText: 'Loan/Amount',
                  labelStyle: TextStyle(
                    fontSize: 15.sp,
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    fontWeight: FontWeight.w400,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.sp,
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: const Icon(
                    Icons.currency_rupee_outlined,
                    color: Color.fromRGBO(237, 24, 70, 1),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              TextFormField(
                controller: totalAmountController,
                cursorColor: const Color.fromRGBO(237, 24, 70, 1),
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Color.fromRGBO(237, 24, 70, 1),
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    width: 2.w,
                  )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    width: 1.w,
                  )),
                  hintText: 'Total/Amount',
                  labelText: 'Total/Amount',
                  labelStyle: TextStyle(
                    fontSize: 15.sp,
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    fontWeight: FontWeight.w400,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.sp,
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: const Icon(
                    Icons.circle,
                    color: Color.fromRGBO(237, 24, 70, 1),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              TextFormField(
                controller: gstTaxAmountController,
                cursorColor: const Color.fromRGBO(237, 24, 70, 1),
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Color.fromRGBO(237, 24, 70, 1),
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    width: 2.w,
                  )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    width: 1.w,
                  )),
                  hintText: 'GST Tax Amount',
                  labelText: 'GST Tax Amount',
                  labelStyle: TextStyle(
                    fontSize: 15.sp,
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    fontWeight: FontWeight.w400,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.sp,
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: const Icon(
                    Icons.currency_rupee_outlined,
                    color: Color.fromRGBO(237, 24, 70, 1),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              TextFormField(
                controller: gstTaxController,
                cursorColor: const Color.fromRGBO(237, 24, 70, 1),
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Color.fromRGBO(237, 24, 70, 1),
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    width: 2.w,
                  )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    width: 1.w,
                  )),
                  hintText: 'GST Tax',
                  labelText: 'GST Tax',
                  labelStyle: TextStyle(
                    fontSize: 15.sp,
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    fontWeight: FontWeight.w400,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.sp,
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: const Icon(
                    Icons.percent_outlined,
                    color: Color.fromRGBO(237, 24, 70, 1),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              TextFormField(
                controller: taxAmountController,
                cursorColor: const Color.fromRGBO(237, 24, 70, 1),
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Color.fromRGBO(237, 24, 70, 1),
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    width: 2.w,
                  )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    width: 1.w,
                  )),
                  hintText: 'Tax Amount',
                  labelText: 'Tax Amount',
                  labelStyle: TextStyle(
                    fontSize: 15.sp,
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    fontWeight: FontWeight.w400,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.sp,
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: const Icon(
                    Icons.currency_rupee_outlined,
                    color: Color.fromRGBO(237, 24, 70, 1),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              TextFormField(
                controller: invoiceAmountInWordController,
                cursorColor: const Color.fromRGBO(237, 24, 70, 1),
                style: const TextStyle(
                  color: Color.fromRGBO(237, 24, 70, 1),
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    width: 2.w,
                  )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    width: 1.w,
                  )),
                  hintText: 'Invoice amount in words',
                  labelText: 'Invoice amount in words',
                  labelStyle: TextStyle(
                    fontSize: 15.sp,
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    fontWeight: FontWeight.w400,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.sp,
                    color: const Color.fromRGBO(237, 24, 70, 1),
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: const Icon(
                    Icons.ac_unit_outlined,
                    color: Color.fromRGBO(237, 24, 70, 1),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(237, 24, 70, 1),
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        if (billToController.text.isNotEmpty &&
                                loanAmountController.text.isNotEmpty &&
                                totalAmountController.text.isNotEmpty &&
                                gstTaxAmountController.text.isNotEmpty &&
                                taxAmountController.text.isNotEmpty &&
                                invoiceAmountInWordController.text.isNotEmpty
                            //gstTaxController.text.isNotEmpty
                            ) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GSTPdfScreen(
                                billTo: billToController.text,
                                invoiceInWord:
                                    invoiceAmountInWordController.text,
                                taxAmount: taxAmountController.text,
                                totalAmount: totalAmountController.text,
                                loanAmount: loanAmountController.text,
                                gstTax: gstTaxController.text,
                                gstTaxAmount: gstTaxAmountController.text,
                              ),
                            ),
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please fill all fields !",
                              backgroundColor:
                                  const Color.fromRGBO(237, 24, 70, 1),
                              textColor: Colors.white);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.h),
                  Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        if (billToController.text.isNotEmpty &&
                                loanAmountController.text.isNotEmpty &&
                                totalAmountController.text.isNotEmpty &&
                                gstTaxAmountController.text.isNotEmpty &&
                                taxAmountController.text.isNotEmpty &&
                                invoiceAmountInWordController.text.isNotEmpty
                            //gstTaxController.text.isNotEmpty
                            ) {
                          print("qqqq");
                          const path =
                              "$kDownloadsDirectory GST.pdf";

                          final file = File(path);

                          await file.writeAsBytes(
                            await createPDF(
                              GstModel(
                                  totalAmount: totalAmountController.text,
                                  gstAmount: gstTaxAmountController.text,
                                  billTo: billToController.text,
                                  taxAmount: taxAmountController.text,
                                  invoiceWordAmount:
                                      invoiceAmountInWordController.text,
                                  gstTax: gstTaxController.text,
                                  loanAmount: loanAmountController.text),
                            ),
                          );
                          file.createSync();
                          if (await file.exists()) {
                            Share.shareFiles(
                              [path],
                              text: "Goods & Service Tax",
                            );
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please fill all fields !",
                              backgroundColor:
                                  const Color.fromRGBO(237, 24, 70, 1),
                              textColor: Colors.white);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text(
                          "Share",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

class GstModel {
  final String billTo;
  final String loanAmount;
  final String totalAmount;
  final String gstAmount;
  final String gstTax;
  final String taxAmount;
  final String invoiceWordAmount;

  const GstModel({
    required this.billTo,
    required this.loanAmount,
    required this.totalAmount,
    required this.gstAmount,
    required this.gstTax,
    required this.taxAmount,
    required this.invoiceWordAmount,
  });

  double get total => double.parse(totalAmount);

  double get gstTotal => double.parse(gstAmount);

  double get amount => total + gstTotal;
}
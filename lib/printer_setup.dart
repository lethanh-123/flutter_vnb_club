import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrinterSetupPage extends StatefulWidget {
  @override
  _PrinterSetupPageState createState() => _PrinterSetupPageState();
}

class _PrinterSetupPageState extends State<PrinterSetupPage> {
  static const platform = MethodChannel('com.example/native');
  String? selectedPrinterName;

  @override
  void initState() {
    super.initState();
    _loadSavedPrinter();
  }

  Future<void> _loadSavedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedPrinterName = prefs.getString('selectedPrinterName');
    });
  }

  Future<void> _savePrinterName(String printerName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedPrinterName', printerName);
  }

  Future<void> _scanAndSavePrinter() async {
    try {
      final result = await platform.invokeMethod('scanAndSavePrinter');
      if (result != null) {
        setState(() {
          selectedPrinterName = result;
        });
        await _savePrinterName(result);
        _showDialog("Thành công", "Đã lưu máy in: $result");
      } else {
        _showDialog("Lỗi", "Không tìm thấy máy in. Vui lòng thử lại.");
      }
    } on PlatformException catch (e) {
      _showDialog("Lỗi", "Lỗi khi quét máy in: ${e.message}");
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Đóng"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thiết Lập Máy In'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedPrinterName != null
                  ? "Máy in đã chọn: $selectedPrinterName"
                  : "Chưa chọn máy in",
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scanAndSavePrinter,
              child: Text('Quét Máy In'),
            ),
          ],
        ),
      ),
    );
  }
}

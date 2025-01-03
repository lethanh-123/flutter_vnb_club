import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:image/image.dart' as image;
import 'api_service.dart';
import 'preferences.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class InvoiceDetailScreen extends StatefulWidget {
  final String maPhieu;

  const InvoiceDetailScreen({Key? key, required this.maPhieu})
      : super(key: key);

  @override
  _InvoiceDetailScreenState createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  late WebViewController _webViewController;
  String _contentHtml = "";
  final GlobalKey _repaintBoundaryKey = GlobalKey();
 static const platform = MethodChannel('com.example/native'); // Tên channel
  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _loadInvoiceDetails();
  }

  Future<void> _loadInvoiceDetails() async {
    try {
      String? keyChiNhanh = await Preferences.getKeyChiNhanh();
      String? userKeyApp = await Preferences.get_user_info("user_key_app");

      if (keyChiNhanh == null || userKeyApp == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể lấy thông tin người dùng')),
        );
        return;
      }

      final response = await ApiService.callApi('in_phieu_xuat', {
        'key_chi_nhanh': keyChiNhanh,
        'user_key_app': userKeyApp,
        'ma_phieu': widget.maPhieu,
      });

      if (response != null && response['content'] != null) {
        setState(() {
          _contentHtml = response['content'];
        });

        _webViewController.loadHtmlString(_contentHtml);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không lấy được chi tiết hóa đơn')),
        );
      }
    } catch (e) {
      debugPrint('Lỗi khi tải chi tiết hóa đơn: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  Future<Uint8List> _captureWebViewAsImage() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));

      RenderRepaintBoundary? boundary = _repaintBoundaryKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null) {
        ui.Image image = await boundary.toImage(pixelRatio: 1.6);
        ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          Uint8List imageBytes = byteData.buffer.asUint8List();
          return imageBytes;
        }
      }
    } catch (e) {
      debugPrint('Lỗi khi chụp hình ảnh từ WebView: $e');
    }
    return Uint8List(0);
  }

  Future<void> _printInvoice() async {
    try {
      String? connectedPrinter = await Preferences.getMayin();
      if (connectedPrinter == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không có máy in nào được kết nối')),
        );
        return;
      }

      final CapabilityProfile profile = await CapabilityProfile.load();
      final Generator generator = Generator(PaperSize.mm80, profile);
      List<int> bytes = [];

      Uint8List imageBytes = await _captureWebViewAsImage();
      if (imageBytes.isNotEmpty) {
        image.Image? img = image.decodeImage(imageBytes);
        if (img != null) {
          bytes.addAll(generator.image(img));
        } else {
          debugPrint("Không thể giải mã hình ảnh từ WebView");
        }
      } else {
        debugPrint("Không thể chụp hình ảnh từ WebView");
      }

      bytes.addAll(generator.cut());

      final bool isConnected = await PrintBluetoothThermal.connectionStatus;
      if (!isConnected) {
        final bool connected = await PrintBluetoothThermal.connect(macPrinterAddress: connectedPrinter);
        if (!connected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không kết nối được với máy in')),
          );
          return;
        }
      }
      debugPrint("Đang gửi dữ liệu tới máy in: ${bytes.length} bytes");
      final bool printSuccess = await PrintBluetoothThermal.writeBytes(bytes);
      if (printSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('In hóa đơn thành công!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi khi in hóa đơn')),
        );
      }
    } catch (e) {
      debugPrint('Lỗi khi in hóa đơn: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi in hóa đơn: $e')),
      );
    }
  }

  Future<void> _openNativeInvoiceScreen() async {
    try {
      // Gửi HTML của hóa đơn qua Native
      await platform.invokeMethod('openInvoiceScreen', {
        'maPhieu': widget.maPhieu,
        'htmlContent': _contentHtml, // Truyền nội dung HTML
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to open native screen: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết hóa đơn'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _openNativeInvoiceScreen, // Thay đổi từ `_printInvoice`
          ),
        ],
      ),
      body: RepaintBoundary(
        key: _repaintBoundaryKey,
        child: _contentHtml.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : WebViewWidget(controller: _webViewController),
      ),
    );
  }
}

import Flutter
import UIKit
import Printer
import CoreBluetooth

@main
@objc class AppDelegate: FlutterAppDelegate, CBCentralManagerDelegate {
    var printerManager: BluetoothPrinterManager?
    var selectedPrinter: String? // Lưu tên máy in được chọn
    var centralManager: CBCentralManager!
    var discoveredPeripherals: [CBPeripheral] = []
    var selectedPeripheral: CBPeripheral?
    let userDefaultsKey = ""
    private var isScanning = false
    private var loadingIndicator: UIActivityIndicatorView?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        centralManager = CBCentralManager(delegate: self, queue: nil)
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.example/native",
                                           binaryMessenger: controller.binaryMessenger)

        channel.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }
            switch call.method {
            case "openInvoiceScreen":
                guard let args = call.arguments as? [String: Any],
                      let maPhieu = args["maPhieu"] as? String,
                      let htmlContent = args["htmlContent"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing arguments", details: nil))
                    return
                }
                let invoiceVC = InvoiceViewController(maPhieu: maPhieu, htmlContent: htmlContent)
                controller.present(invoiceVC, animated: true, completion: nil)
                result("Opened InvoiceViewController")

            case "scanAndSavePrinter":
                self.scanPrinters(result: result)

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        // Khởi tạo đối tượng quản lý máy in Bluetooth
        printerManager = BluetoothPrinterManager()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - Quét Máy In
    private func scanPrinters(result: @escaping FlutterResult) {
        guard centralManager.state == .poweredOn else {
            result(FlutterError(code: "BLUETOOTH_OFF", message: "Bluetooth is not enabled", details: nil))
            return
        }

        guard !isScanning else {
            result(FlutterError(code: "ALREADY_SCANNING", message: "Already scanning for printers", details: nil))
            return
        }

        discoveredPeripherals.removeAll()
        isScanning = true

        showLoadingIndicator()

        centralManager.scanForPeripherals(withServices: nil, options: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.isScanning = false
            self.centralManager.stopScan()
            self.hideLoadingIndicator()

            if self.discoveredPeripherals.isEmpty {
                result(FlutterError(code: "NO_PRINTER_FOUND", message: "No printers found", details: nil))
            } else {
                self.showPrinterList(result: result)
            }
        }
    }

    // MARK: - Hiển Thị Danh Sách Máy In
    private func showPrinterList(result: @escaping FlutterResult) {
        guard let rootViewController = window?.rootViewController else {
            result(FlutterError(code: "UI_ERROR", message: "Cannot access root view controller", details: nil))
            return
        }

        let alert = UIAlertController(title: "Chọn Máy In", message: nil, preferredStyle: .actionSheet)
        for peripheral in discoveredPeripherals {
            alert.addAction(UIAlertAction(title: peripheral.name ?? "Unknown Printer", style: .default) { _ in
                self.selectedPeripheral = peripheral
                if let ten_may_in = peripheral.name {
                    UserDefaults.standard.set(ten_may_in, forKey: "selectedPrinter")
                }
                UserDefaults.standard.synchronize()
                result(peripheral.name ?? "Unknown Printer")
            })
        }
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel) { _ in
            result(FlutterError(code: "CANCELLED", message: "User cancelled printer selection", details: nil))
        })

        rootViewController.present(alert, animated: true, completion: nil)
    }

    // MARK: - Loading Indicator
    private func showLoadingIndicator() {
        guard let rootViewController = window?.rootViewController else { return }

        let loadingIndicator: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            loadingIndicator = UIActivityIndicatorView(style: .large)
        } else {
            loadingIndicator = UIActivityIndicatorView(style: .whiteLarge) // Sử dụng style tương thích với iOS cũ
        }

        let adjustedCenter = CGPoint(x: rootViewController.view.center.x,
                                         y: rootViewController.view.center.y - 50)
            loadingIndicator.center = adjustedCenter
        loadingIndicator.color = .gray
        loadingIndicator.startAnimating()

        rootViewController.view.addSubview(loadingIndicator)
        self.loadingIndicator = loadingIndicator
    }


    private func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator?.stopAnimating()
            self.loadingIndicator?.removeFromSuperview()
            self.loadingIndicator = nil
        }
    }

    // MARK: - CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            print("Bluetooth is not powered on.")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(where: { $0.identifier == peripheral.identifier }) {
            if let name = peripheral.name, !name.isEmpty {
                discoveredPeripherals.append(peripheral)
                print("Discovered peripheral: \(name)")
            } else {
                print("Discovered peripheral with no name")
            }
        }
    }
}

import UIKit
import WebKit
import CoreBluetooth
import Printer

class InvoiceViewController: UIViewController, WKNavigationDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {
    var maPhieu: String
        private var centralManager: CBCentralManager!
        private var discoveredPeripherals: [CBPeripheral] = []
        private var connectedPeripheral: CBPeripheral?
        private var writeCharacteristic: CBCharacteristic?
        var savedPrinterName: String?

        var webView: WKWebView!
        var htmlContent: String? // Thêm biến để lưu HTML từ Flutter

        init(maPhieu: String, htmlContent: String?) {
            self.maPhieu = maPhieu
            self.htmlContent = htmlContent
            super.init(nibName: nil, bundle: nil)
        }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        centralManager = CBCentralManager(delegate: self, queue: nil)
        // Lấy tên máy in đã lưu
        savedPrinterName = UserDefaults.standard.string(forKey: "selectedPrinter")
        setupUI()
        
        loadInvoiceDetails()
    }

    private func setupUI() {
        // WebView setup
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 300)) // Chiều cao trừ đi 120 để chừa không gian cho nút
        webView.navigationDelegate = self
        view.addSubview(webView)
       
        // Print Button
        let printButton = UIButton(type: .system)
        printButton.setTitle("In Hóa Đơn", for: .normal)
        printButton.setTitleColor(.white, for: .normal)
        printButton.backgroundColor = UIColor.systemBlue // Màu sắc nổi bật, có thể đổi thành UIColor.systemGreen hoặc UIColor.systemTeal
        printButton.layer.cornerRadius = 10 // Bo tròn góc nút
        printButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18) // Kiểu chữ đậm và lớn
        printButton.addTarget(self, action: #selector(printInvoice), for: .touchUpInside)

        // Căn giữa nút
        printButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(printButton)
        NSLayoutConstraint.activate([
            printButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Căn giữa theo chiều ngang
            printButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100), // Cách đáy màn hình 20 điểm
            printButton.widthAnchor.constraint(equalToConstant: 200), // Độ rộng của nút
            printButton.heightAnchor.constraint(equalToConstant: 50) // Chiều cao của nút
        ])
    }

    

    private func loadInvoiceDetails() {
            if let htmlContent = htmlContent {
                webView.loadHTMLString(htmlContent, baseURL: nil)
            } else {
                showAlert(title: "Lỗi", message: "Không có nội dung hóa đơn.")
            }
        }
    
    private func resizeImage(image: UIImage, targetWidth: Int, targetHeight: Int) -> UIImage? {
        let size = CGSize(width: targetWidth, height: targetHeight)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    private func createEscPosHeader(width: Int, height: Int) -> [UInt8] {
        return [
            0x1D, 0x76, 0x30, 0x00, // ESC v 0, Standard mode
            UInt8(width & 0xFF), UInt8((width >> 8) & 0xFF), // Chiều rộng (số byte)
            UInt8(height & 0xFF), UInt8((height >> 8) & 0xFF) // Chiều cao (số pixel)
        ]
    }
    private func convertImageToBytes_2(_ image: UIImage) -> [UInt8] {
        guard let cgImage = image.cgImage else { return [] }

        // Resize hình ảnh về chiều rộng tương ứng với khổ 80mm (576 pixels)
        let targetWidth = 576
        let scaleFactor = CGFloat(targetWidth) / CGFloat(cgImage.width)
        let targetHeight = Int(CGFloat(cgImage.height) * scaleFactor)

        guard let resizedImage = resizeImage(image: image, targetWidth: targetWidth, targetHeight: targetHeight),
              let resizedCgImage = resizedImage.cgImage else { return [] }

        let width = resizedCgImage.width
        let height = resizedCgImage.height
        let bytesPerRow = (width + 7) / 8
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

        // Mảng lưu pixel dạng grayscale
        var pixelData = [UInt8](repeating: 0, count: width * height)

        guard let context = CGContext(
            data: &pixelData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ) else { return [] }

        // Vẽ hình ảnh vào context
        context.draw(resizedCgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        // Dữ liệu bitmap cho các dòng pixel
        var escPosData = [UInt8]()

        // ESC * để bắt đầu in ảnh
        escPosData.append(contentsOf: [0x1B, 0x2A, 33]) // ESC * Mode: 24-dot double density
        escPosData.append(UInt8(width & 0xFF))  // Width low byte
        escPosData.append(UInt8((width >> 8) & 0xFF))  // Width high byte

        // Dữ liệu bitmap cho từng dòng pixel
        for y in 0..<height {
            var lineData = [UInt8](repeating: 0, count: bytesPerRow)

            // Xử lý từng pixel của một dòng
            for x in 0..<width {
                let index = y * width + x
                let pixel = pixelData[index]

                // Nếu pixel tối (giá trị grayscale < 127), set bit thành 1
                if pixel < 127 {
                    lineData[x / 8] |= (0x80 >> (x % 8))
                }
            }

            // Thêm dòng dữ liệu bitmap vào ESC/POS command
            escPosData.append(contentsOf: lineData)
        }

        return escPosData
    }
    private func convertImageToBytes(_ image: UIImage) -> [UInt8] {
        guard let cgImage = image.cgImage else { return [] }

        // Resize hình ảnh về chiều rộng tương ứng với khổ 80mm (576 pixels)
        let targetWidth = 576
        let scaleFactor = CGFloat(targetWidth) / CGFloat(cgImage.width)
        let targetHeight = Int(CGFloat(cgImage.height) * scaleFactor)

        guard let resizedImage = resizeImage(image: image, targetWidth: targetWidth, targetHeight: targetHeight),
              let resizedCgImage = resizedImage.cgImage else { return [] }

        let width = resizedCgImage.width
        let height = resizedCgImage.height
        let bytesPerRow = (width + 7) / 8 // Chia pixel theo từng byte (8 pixel = 1 byte)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

        var pixelData = [UInt8](repeating: 0, count: width * height)

        guard let context = CGContext(
            data: &pixelData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ) else { return [] }

        context.draw(resizedCgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        var escPosData = [UInt8]()

        // Header ESC/POS để bắt đầu in
        escPosData.append(contentsOf: createEscPosHeader(width: bytesPerRow, height: height))

        // Xử lý dữ liệu bitmap
        for y in 0..<height {
            var lineData = [UInt8](repeating: 0, count: bytesPerRow)

            for x in 0..<width {
                let index = y * width + x
                let pixel = pixelData[index]

                // Nếu pixel tối (giá trị grayscale < 127), set bit thành 1
                if pixel < 127 {
                    lineData[x / 8] |= (0x80 >> (x % 8))
                }
            }

            // Thêm dòng dữ liệu bitmap vào ESC/POS command
            escPosData.append(contentsOf: lineData)
        }

        return escPosData
    }


    
    @objc private func printInvoice() {
        guard let connectedPeripheral = connectedPeripheral, let writeCharacteristic = writeCharacteristic else {
            showAlert(title: "Thông báo", message: "Vui lòng chọn máy in trước khi in.")
            return
        }

        captureWebViewSnapshot { snapshot in
            guard let snapshot = snapshot else {
                self.showAlert(title: "Lỗi", message: "Không thể chụp ảnh hóa đơn.")
                return
            }
            
            let printData = self.convertImageToBytes(snapshot)
            let escCommand: [UInt8] = [
                0x1B, 0x40, // Header to start printing image
                // Image data (bitmap data for the image)
                // Bitmap pixels will be added here
            ]
            let escCommand_Cut: [UInt8] = [
                0x1D, 0x56,0x41,0 // Header to start printing image
                // Image data (bitmap data for the image)
                // Bitmap pixels will be added here
            ]
            connectedPeripheral.writeValue(Data(escCommand), for: writeCharacteristic, type: .withoutResponse)
            connectedPeripheral.writeValue(Data(printData), for: writeCharacteristic, type: .withoutResponse)
            connectedPeripheral.writeValue(Data(escCommand_Cut), for: writeCharacteristic, type: .withoutResponse)
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }


    private func captureWebViewSnapshot(completion: @escaping (UIImage?) -> Void) {
        let configuration = WKSnapshotConfiguration()
        configuration.rect = webView.bounds

        if #available(iOS 13.0, *) {
            configuration.afterScreenUpdates = true
        }

        webView.takeSnapshot(with: configuration) { image, error in
            if let error = error {
                print("Error capturing snapshot: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let image = image else {
                completion(nil)
                return
            }

            // Resize snapshot về 576px width (80mm)
            let resizedImage = self.resizeImage(
                image: image,
                targetWidth: 576,
                targetHeight: Int(image.size.height * (576 / image.size.width))
            )
            completion(resizedImage)
        }
    }

    // MARK: - CBCentralManagerDelegate

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            if let savedPrinterName = savedPrinterName {
                print("Bluetooth đã bật. Đang tìm máy in: \(savedPrinterName)")
                centralManager.scanForPeripherals(withServices: nil, options: nil)
            } else {
                print("Bluetooth đã bật, nhưng không có máy in nào được lưu.")
            }
        } else {
            showAlert(title: "Thông báo", message: "Bluetooth chưa được bật!")
        }
    }


    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name, name == savedPrinterName {
            // Lưu peripheral và kết nối
            connectedPeripheral = peripheral
            centralManager.stopScan()
            centralManager.connect(peripheral, options: nil)
            print("Đã tìm thấy và kết nối với máy in: \(name)")
        } else {
            print("Đã tìm thấy máy in khác: \(peripheral.name ?? "Unknown Printer")")
        }
    }



    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services ?? [] {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics ?? [] {
            if characteristic.properties.contains(.writeWithoutResponse) {
                writeCharacteristic = characteristic
            }
        }
    }
}

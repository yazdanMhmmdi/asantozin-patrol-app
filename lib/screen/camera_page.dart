import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../constants/i_colors.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String overlayText = "-1";
  bool disableCamera = false;
  Color overlayColor = IColors.mainColor;

  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    autoStart: true,
    detectionSpeed: DetectionSpeed.normal,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onBarcodeDetect(BarcodeCapture barcodeCapture) async {
    final barcode = barcodeCapture.barcodes.last;

    overlayText = barcodeCapture.barcodes.last.displayValue ?? barcode.rawValue ?? '-1';
    overlayColor = Colors.green;

    // disableCamera = true;
    setState(() {});

    Future.delayed(const Duration(seconds: 1)).then((value) {
      Navigator.pop(context, overlayText);
    });
    controller.stop();

    // _usersDataSource.updateDataGriDataSource();

    // List<UserModel> s = await getUsersCubit!.getUserPagination(q: userSearch);

    // controller.stop();
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: 250,
      height: 250,
    );

    return PopScope(
      canPop: false,
      onPopInvoked: (willPop) {
        if (willPop) {
          return;
        }
        Navigator.pop(context, '-1');
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: MobileScanner(
                      fit: BoxFit.cover,

                      onDetect: disableCamera ? (s) {} : onBarcodeDetect,
                      // overlay: Padding(
                      //   padding: const EdgeInsets.all(16.0),
                      //   child: Align(
                      //     alignment: Alignment.bottomCenter,
                      //     child: Opacity(
                      //       opacity: 0.7,
                      //       child: Text(
                      //         overlayText,
                      //         style: const TextStyle(
                      //           backgroundColor: Colors.black26,
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 24,
                      //           overflow: TextOverflow.ellipsis,
                      //         ),
                      //         maxLines: 1,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      controller: controller,
                      scanWindow: scanWindow,
                      errorBuilder: (context, error, child) {
                        return Text(error.toString());
                      },
                    ),
                  ),
                  CustomPaint(
                    painter: ScannerOverlay(scanWindow, color: overlayColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ValueListenableBuilder<TorchState>(
                            valueListenable: controller.torchState,
                            builder: (context, value, child) {
                              switch (value) {
                                case TorchState.off:
                                  return flashButton(color: IColors.mainColor, icon: Icons.flashlight_on_rounded);

                                case TorchState.on:
                                  return flashButton(color: Colors.grey, icon: Icons.flashlight_off_rounded);
                              }

                              //  IconButton(
                              //   onPressed: () => controller.toggleTorch(),
                              //   icon: Icon(
                              //     Icons.flashlight_on,
                              //     color: iconColor,
                              //   ),
                              // );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget flashButton({required Color color, required IconData icon}) {
    return FloatingActionButton(
      onPressed: () => controller.toggleTorch(),
      backgroundColor: color,
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow, {required this.color});

  final Rect scanWindow;
  final double borderRadius = 12.0;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    // Create a Paint object for the white border
    final borderPaint = Paint()
      ..color = color //IColors.mainColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0; // Adjust the border width as needed

    // Calculate the border rectangle with rounded corners
// Adjust the radius as needed
    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // Draw the white border
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

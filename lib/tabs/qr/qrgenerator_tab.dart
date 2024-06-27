import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test1/common/color_extension.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QRGeneratorPage extends StatefulWidget {
  final Map<String, dynamic>? user; // Store the user data

  QRGeneratorPage(this.user);
  @override
  _QRGeneratorPageState createState() => _QRGeneratorPageState();
}

class _QRGeneratorPageState extends State<QRGeneratorPage> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  final GlobalKey _qrkey = GlobalKey();
  bool dirExists = false;
  dynamic externalDir = '/storage/emulated/0/Download/Qr_code';
  //function retrieved from: https://github.com/FLDevelopers/Qr_Code_Generator/blob/main/lib/main_page.dart
  Future<void> _captureAndSavePng() async {
    try {
      RenderRepaintBoundary boundary =
          _qrkey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);

      //Drawing White Background because Qr Code is Black
      final whitePaint = Paint()..color = Colors.white;
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
      canvas.drawRect(
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          whitePaint);
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      //Check for duplicate file name to avoid Override
      String fileName = 'qr_code';
      int i = 1;
      while (await File('$externalDir/$fileName.png').exists()) {
        fileName = 'qr_code_$i';
        i++;
      }

      // Check if Directory Path exists or not
      dirExists = await File(externalDir).exists();
      //if not then create the path
      if (!dirExists) {
        await Directory(externalDir).create(recursive: true);
        dirExists = true;
      }

      final file = await File('$externalDir/$fileName.png').create();
      await file.writeAsBytes(pngBytes);

      if (!mounted) return;
      const snackBar = SnackBar(content: Text('QR code saved to gallery'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      if (!mounted) return;
      const snackBar = SnackBar(content: Text('Something went wrong!!!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('QR Code'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // QrImageView(
                  //     data: widget.user?["id"],
                  //     version: QrVersions.auto,
                  //     size: 250.0,
                  //     gapless: true,
                  //     errorStateBuilder: (ctx, err) {
                  //       return Center(
                  //           child: Text(
                  //         "Something went Wrong",
                  //         textAlign: TextAlign.center,
                  //       ));
                  //     }),
                  RepaintBoundary(
                    key: _qrkey,
                    child: PrettyQrView.data(
                      data: widget.user?["id"],
                      decoration: PrettyQrDecoration(
                        shape: PrettyQrSmoothSymbol(
                            roundFactor: 1, color: TColor.black),
                        image: PrettyQrDecorationImage(
                          image: AssetImage('assets/img/applogo.png'),
                          position: PrettyQrDecorationImagePosition.embedded,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      child: const Text('Save QR Code'),
                      onPressed: _captureAndSavePng
                      // Give a file name
                      ),
                ])));
  }
}

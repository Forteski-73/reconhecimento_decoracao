import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'image_recognition.dart';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  XFile? _image;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Inicializa a câmera
  void _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.high);
    await _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text("Captura de Decoração")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CameraPreview(_controller),
            ElevatedButton(
              onPressed: () async {
                final image = await _controller.takePicture();
                setState(() {
                  _image = image;
                });

                // Processa a imagem capturada
                if (_image != null) {
                  String codigoDeco = await processImageRecognition(_image!);
                  print("Código da Decoração: $codigoDeco");
                }
              },
              child: Text("Tirar Foto"),
            ),
            if (_image != null)
              Image.file(File(_image!.path))
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image_picker/image_picker.dart';

Future<String> processImageRecognition(XFile image) async {
  // Carrega a imagem e prepara para o modelo
  final img.Image originalImage = img.decodeImage(File(image.path).readAsBytesSync())!;
  final img.Image resizedImage = img.copyResize(originalImage, width: 224, height: 224);  // Ajuste de tamanho da imagem para o modelo poder fazer uma análise padronizada

  // Carrega o modelo TensorFlow
  final interpreter = await Interpreter.fromAsset('model.tflite');

  // Converte a imagem para o formato de entrada do modelo
  var input = preprocessImage(resizedImage);

  // Roda a inferência
  var output = List.filled(1 * 1000, 0);  // A saída pode variar conforme o modelo (1000 é um exemplo para um modelo com 1000 classes)
  interpreter.run(input, output);

  // Processa e retorna o código da decoração
  return processOutput(output);
}

// Função para pré-processar a imagem para o formato adequado
List<List<List<double>>> preprocessImage(img.Image image) {
  // Converter imagem para uma lista de listas de pixels normalizados entre 0 e 1
  List<List<List<double>>> imageList = [];

  for (int y = 0; y < image.height; y++) {
    List<List<double>> row = [];
    for (int x = 0; x < image.width; x++) {
      // Obtendo o valor do pixel (do tipo Pixel)
      img.Pixel pixel = image.getPixel(x, y); // Retorna um objeto Pixel

      // Extraindo os componentes de cor do pixel
      double red = pixel.r / 255.0;    // Componente vermelho
      double green = pixel.g / 255.0;  // Componente verde
      double blue = pixel.b / 255.0;   // Componente azul
      
      // Adicionando o pixel como uma lista de 3 elementos (RGB)
      row.add([red, green, blue]);
    }
    imageList.add(row);
  }

  // Retorna o formato esperado: [height, width, 3] (altura, largura, 3 canais RGB)
  return imageList;
}

// Função para processar o output da inferência
String processOutput(List<int> output) {
  // Aqui a saída pode ser um vetor de probabilidades de cada classe
  // A maior probabilidade indica a classe prevista
  int probabilityFound = output.indexOf(output.reduce((a, b) => a > b ? a : b));

  // Retorne a classe correspondente ao índice com maior probabilidade (por exemplo, um código ou nome)
  return 'Decoração: ${probabilityFound.toString()}';  // Substitua por nomes mais descritivos, se necessário
}

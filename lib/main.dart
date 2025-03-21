import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para usar FilteringTextInputFormatter
import 'dart:math'; // Para usar la función exp

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biomarcador-IRM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegressionScreen(),
    );
  }
}

class RegressionScreen extends StatefulWidget {
  @override
  _RegressionScreenState createState() => _RegressionScreenState();
}

class _RegressionScreenState extends State<RegressionScreen> {
  // Controladores para los campos de entrada
  final TextEditingController _input1Controller = TextEditingController();
  final TextEditingController _input2Controller = TextEditingController();
  final TextEditingController _input3Controller = TextEditingController();

  // Variable para almacenar el resultado
  String _resultado = "";

  // Función para evaluar la regresión multinomial
  void _evaluarRegresion() {
    // Obtener los valores de las entradas
    String input1 = _input1Controller.text;
    String input2 = _input2Controller.text;
    String input3 = _input3Controller.text;

    // Validar si alguno de los campos está vacío
    if (input1.isEmpty || input2.isEmpty || input3.isEmpty) {
      setState(() {
        _resultado = "Falta información. Por favor, complete todos los campos.";
      });
      return;
    }

    // Convertir los valores a double
    double edad = double.tryParse(input1) ?? 0;
    double dapmes = double.tryParse(input2) ?? 0;
    double dapp = double.tryParse(input3) ?? 0;

    // Aquí implementas la lógica de la regresión multinomial
    // Por ejemplo, una fórmula simple (esto es solo un ejemplo):
    // Calcular P{Enfermo}
    double pEnfermo = 1 / (1 + exp(-41.950 + 0.890 * dapmes + 1.211 * dapp));
    // Calcular P{Preclinico}
    double pPreclinico = 1 / (1 + exp(-34.565 + 0.107 * edad + 0.732 * dapmes + 0.833 * dapp));

    // Calcular P{Sano}
    double pSano = 1 - (pPreclinico);

    // Determinar la categoría con la probabilidad más alta
    String categoria;
    double probabilidad;

    if (pEnfermo < 0.5) {
      categoria = "Preclinico";
      probabilidad = pPreclinico;
      if (pPreclinico < 0.5) {
        categoria = "SANO";
        probabilidad = pSano;
      }
    } else {
      categoria = "Enfermo";
      probabilidad = pEnfermo;
    }

    // Formatear el resultado con la categoría y la probabilidad
    _resultado = "$categoria (Probabilidad: ${probabilidad.toStringAsFixed(2)})";

    // Actualizar el estado para mostrar el resultado
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biomarcador-IRM'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/splash.png'), // Ruta de la imagen de fondo
            fit: BoxFit.cover, // Ajusta la imagen para cubrir todo el fondo
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Campo de entrada 1
              TextField(
                controller: _input1Controller,
                keyboardType: TextInputType.numberWithOptions(decimal: true), // Teclado numérico con decimales
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Permite números y un punto decimal
                ],
                decoration: InputDecoration(
                  labelText: 'EDAD',
                  filled: true, // Rellenar el fondo del TextField
                  fillColor: Colors.white.withOpacity(0.8), // Fondo semi-transparente
                ),
              ),
              // Campo de entrada 2
              TextField(
                controller: _input2Controller,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: InputDecoration(
                  labelText: 'DAPMES',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                ),
              ),
              // Campo de entrada 3
              TextField(
                controller: _input3Controller,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: InputDecoration(
                  labelText: 'DAPP',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                ),
              ),
              // Botón para evaluar
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _evaluarRegresion,
                child: Text('Evaluar Regresion'),
              ),
              // Mostrar el resultado
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8), // Fondo semi-transparente
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Resultado: $_resultado',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class RecogniseImagePage extends StatefulWidget{
  final String? path;

  const RecogniseImagePage({Key? key, this.path}) : super(key: key);

  @override
  State<RecogniseImagePage> createState() => _RecogniseImagePageState();
}

class _RecogniseImagePageState extends State<RecogniseImagePage>{

  bool _isBusy = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState(){
    super.initState();

    final InputImage inputImage = InputImage.fromFilePath(widget.path!);

    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Recognise Image Page"),),

      body: _isBusy == true
      ? const Center(
        child: CircularProgressIndicator(),
      )
          : Container(
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          maxLines: MediaQuery.of(context).size.height.toInt(),
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Text goes here ..."
          ),
        )
      )
    );

  }

  void processImage(InputImage image) async {

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {
      _isBusy = true;
    });

    final RecognizedText recognizedText = await textRecognizer.processImage(image);

    controller.text = recognizedText.text;

    
    setState(() {
      _isBusy = false;
    });
  }
}
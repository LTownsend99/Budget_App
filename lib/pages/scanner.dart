import 'package:budget_app/Utils/image_picker_class.dart';
import 'package:budget_app/models/image_picker.dart';
import 'package:budget_app/pages/image_cropper_page.dart';
import 'package:budget_app/pages/recognise_image_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _MyScannerPageState();
}

class _MyScannerPageState extends State<ScannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      body: Stack(
        children: [
          Positioned(
            bottom: MediaQuery.of(context).size.height / 2 - 58, // Center vertically
            left: MediaQuery.of(context).size.width / 2 - 145, // Center horizontally
            child: Column(
              children: [
                Container(
                  width: 300,
                  height: 50,
                  child: FloatingActionButton(
                    onPressed: () {
                      imagePicker(context, onCameraTap: () {
                        pickImage(ImageSource.camera).then((value) {
                          if (value != '') {
                            imageCropperView(value, context).then((value) {
                              if (value != '') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            RecogniseImagePage(path: value)));
                              }
                            });
                          }
                        });
                      }, onGalleryTap: () {
                        pickImage(ImageSource.gallery).then((value) {
                          if (value != '') {
                            imageCropperView(value, context).then((value) {
                              if (value != '') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            RecogniseImagePage(path: value)));
                              }
                            });
                          }
                        });
                      });
                    },
                    child: const Icon(Icons.photo_camera),
                  ),
                ),
                const SizedBox(height: 8), // Space between FAB and hint text
                const Text('Tap to pick an image', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

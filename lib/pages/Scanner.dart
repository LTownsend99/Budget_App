import 'dart:developer';

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
      backgroundColor: Colors.white, // Set the background color to white

      body: const Center(
        child: Text('Scanner Page Content'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          imagePicker(context, onCameraTap: () {
            pickImage(ImageSource.camera).then((value) {
              if (value != '') {
                imageCropperView(value, context).then((value) {
                  if (value != '') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => RecogniseImagePage(path: value)));
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
                            builder: (_) => RecogniseImagePage(path: value)));
                  }
                });
              }
            });
          });
        },
        child: const Icon(Icons.photo_camera),
      ),
    );
  }
}

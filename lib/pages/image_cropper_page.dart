import 'dart:developer';

import 'package:budget_app/pages/recognise_image_page.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

Future<String> imageCropperView(String? path, BuildContext context) async{


  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: path!,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        lockAspectRatio: false,

      ),
      IOSUiSettings(
        title: 'Crop Image',
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
      ),
      WebUiSettings(
        context: context,
      ),
    ],
  );

  if(croppedFile !=null)
    {
      log("Image Cropped");
      return croppedFile.path;
    }else
      {
        log("Do Nothing");
        return '';
      }

}
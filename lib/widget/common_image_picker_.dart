import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class CommonPicker {
  final ImagePicker _picker = ImagePicker();
  final FilePicker _filePicker = FilePicker.platform;

  Future<FilePickerResult?> showPickFileDialog(
      {bool allowMultiple = false}) async {
    try {
      return await _filePicker.pickFiles(
        allowMultiple: allowMultiple,
        allowCompression: true,
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> onImageButtonPressed(
      {ImageSource? source, bool isMultiImage = false}) async {
    late List<XFile>? pickedFileList;
    if (isMultiImage) {
      try {
        pickedFileList = await _picker.pickMultiImage();
      } catch (e) {
        print(e);
      }

      return pickedFileList;
    } else {
      late XFile? pickedFile;
      try {
        pickedFile = await _picker.pickImage(source: source!, imageQuality: 50);
      } catch (e) {
        print(e);
      }
      return pickedFile;
    }
  }

  Future<dynamic> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      return response.file;
    } else if (response.files != null) {
      return response.files;
    } else {
      return response.exception!.code;
    }
  }
}

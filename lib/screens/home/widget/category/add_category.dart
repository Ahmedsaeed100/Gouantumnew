import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gouantum/controllers/global_functions.dart';
import 'package:image_picker/image_picker.dart';
import '../../home_controller.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);

      setState(() {
        avatar = imageTemporary;
      });
    } on PlatformException {
      //print("failed");
    }
  }

  File? avatar;
  final HomeController controller = Get.put(HomeController());
  String imageUrl = "";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter Category Name',
              border: OutlineInputBorder(),
            ),
            controller: _nameController,
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter Category Description',
              border: OutlineInputBorder(),
            ),
            controller: _descriptionController,
          ),
          Container(
            height: size.height * 0.15,
            width: size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: avatar == null
                ? Center(
                    child: IconButton(
                        onPressed: () => pickImage(),
                        icon: const Icon(
                          Icons.add_a_photo,
                          size: 50,
                        )))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Center(
                          child: Image.file(
                            avatar!,
                            fit: BoxFit.cover,
                            height: size.height * 0.14,
                            width: size.width * 0.6,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                avatar = null;
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 30,
                            )),
                      ],
                    ),
                  ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          ElevatedButton(
              onPressed: () async {
                UploadTask uploadTask = GlobalFunctionsController()
                    .uploadFile(avatar!, "${DateTime.now()}", "category");
                TaskSnapshot snapshot = await uploadTask;
                controller.addCategoryToFirebase(
                    image: await snapshot.ref.getDownloadURL(),
                    name: _nameController.text,
                    desc: _descriptionController.text);
              },
              child: const Text('Add Category'))
        ],
      ),
    );
  }
}

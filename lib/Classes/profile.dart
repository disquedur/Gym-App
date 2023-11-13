import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Interfaces/constants.dart';
import '../Services/map_service.dart';

class Profile extends StatefulWidget {
  final MapService mapService;

  const Profile({super.key, required this.mapService});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final quoteController = TextEditingController();
  bool isQuoteEdit = false;

  pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final size = await file.length();
      if (size <= 50000) {
        setState(() {
          widget.mapService.imageFile = File(pickedFile.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 3),
          content: Text("Image size too big"),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('User name')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                !isQuoteEdit
                    ? Expanded(
                        child: Center(
                          child: Container(
                            child: Text(
                              style: TextStyle(fontFamily: "Lobster-Regular"),
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.center,
                              quoteController.text.isEmpty
                                  ? "..."
                                  : quoteController.text,
                            ),
                          ),
                        ),
                      )
                    : Form(
                        key: formKey,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextFormField(
                            controller: quoteController,
                            maxLength: 50,
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: darkColorText,
                              border: OutlineInputBorder(),
                            ),
                            validator: (String? value) {
                              if (value!.length > 50) {
                                return "Quote too long";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (!isQuoteEdit) {
                          isQuoteEdit = !isQuoteEdit;
                        } else if (isQuoteEdit &&
                            formKey.currentState!.validate()) {
                          isQuoteEdit = !isQuoteEdit;
                        }
                      });
                    },
                    icon: Icon(!isQuoteEdit ? Icons.edit : Icons.check))
              ],
            ),
          ),
          SizedBox(height: 10),
          Center(
              child: widget.mapService.imageFile == null
                  ? CircleAvatar(
                      minRadius: MediaQuery.of(context).size.height * 0.10,
                      backgroundColor: Colors.amber,
                      child: Container(),
                    )
                  : Image.file(widget.mapService.imageFile!,
                      width: MediaQuery.of(context).size.height * 0.5)),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
        TextButton(
          onPressed: () {
            pickImage();
          },
          child: Text('Image'),
        ),
      ],
    );
  }
}

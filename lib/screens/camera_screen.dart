// 🔄 Ubah: tambahkan 'show File' biar gak error di web
import 'dart:io' show File;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // 🔄 Tambah: untuk deteksi platform
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  // 🔄 Ubah: pakai XFile, karena lebih fleksibel (bisa web & mobile)
  XFile? pickedFile;

  // Image picker
  final picker = ImagePicker();

  // Pick image method
  Future<void> pickImage(ImageSource source) async {
    // pilih dari kamera atau galeri
    final file = await picker.pickImage(source: source);

    // update selected image
    if (file != null) {
      setState(() {
        pickedFile = file; // 🔄 Ubah: simpan XFile, bukan File langsung
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO APP"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pop(context);
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            // Image display
            SizedBox(
              height: 300,
              width: 300,
              child: pickedFile != null
                  ? (kIsWeb
                      ? Image.network(
                          pickedFile!.path,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(pickedFile!.path),
                          fit: BoxFit.cover,
                        ))
                  : const Center(child: Text("No image selected")),
            ),


            const SizedBox(height: 20),

            // Tombol
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // camera button
                ElevatedButton(
                  onPressed: () => pickImage(ImageSource.camera),
                  child: const Text("Camera"),
                ),

                // file button
                ElevatedButton(
                  onPressed: () => pickImage(ImageSource.gallery),
                  child: const Text("Gallery"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

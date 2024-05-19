import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:labeling/extension/padding.dart';
import 'package:labeling/game/brick_breaker.dart';
import 'package:labeling/provider/cubit_heart/heart_cubit.dart';
import 'package:labeling/services/firestore.dart';
import 'package:labeling/services/image_picker.dart';
import 'package:labeling/services/translation.dart';

class LabelViewPage extends StatefulWidget {
  const LabelViewPage({super.key});

  @override
  State<LabelViewPage> createState() => _LabelViewPageState();
}

class _LabelViewPageState extends State<LabelViewPage> {
  late CameraService cameraService;
  late StorageService storageService;
  late TranslationService translationService;
  late File? image;
  late TextEditingController send;

  @override
  void initState() {
    super.initState();
    cameraService = CameraService();
    send = TextEditingController();
    storageService = StorageService();
    translationService = TranslationService(
      sourceLanguage: TranslateLanguage.turkish,
      targetLanguage: TranslateLanguage.english,
    );
    translationService.downloadSourceAndTargetModels();
    image = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/8.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Positioned(
                width: MediaQuery.of(context).size.width,
                top: MediaQuery.of(context).size.height * 0.085,
                height: MediaQuery.of(context).size.height * 0.4,
                child: InkWell(
                  onTap: () {
                    cameraService.pickImage().then((value) {
                      if (value != null) {
                        setState(() {
                          image = value;
                        });
                      }
                    });
                  },
                  child: image == null
                      ? SvgPicture.asset('assets/svg/image_upload.svg')
                      : Image.file(File(image!.path)).paddedVertical(10),
                )),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.26,
              top: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: TextField(
                  controller: send,
                  decoration: const InputDecoration(
                    labelText: 'Etiket',
                  ),
                ),
              ),
            ),
            Positioned(
                left: MediaQuery.of(context).size.width * 0.28,
                top: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.45,
                child: ElevatedButton(
                  onPressed: () async {
                    if (image != null) {
                      String eng_text =
                          await translationService.translateText(send.text);
                      await storageService
                          .uploadImage(image!, eng_text)
                          .then((value) {
                        context.read<HeartCubit>().refreshHearts();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BrickBreakerGame()),
                          (route) => false,
                        );
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      textStyle:
                          const TextStyle(color: Colors.white, fontSize: 20)),
                  child: const Text("Gönder",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                )),
          ],
        ),
      ),
    );
  }
}

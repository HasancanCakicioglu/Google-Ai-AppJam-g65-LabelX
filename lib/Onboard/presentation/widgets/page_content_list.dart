import 'package:flutter/material.dart';

/// The model representing onboarding content for the Idea Atlas application.
class OnBoardingContentModel {
  /// The title of the onboarding content.
  final String title;

  /// The description of the onboarding content.
  final String description;

  /// The image asset path for the onboarding content.
  final String image;

  /// The color of the onboarding content.
  final Color color;

  /// The color of the text in the onboarding content.
  final Color colorText;

  /// Creates an instance of [OnBoardingContentModel].
  ///
  /// The [title], [description], and [image] parameters are required.
  OnBoardingContentModel({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
    this.colorText = Colors.white,
  });
}

/// A list of predefined onboarding content for the Idea Atlas application.
List<OnBoardingContentModel> onBoardingContentsList = [
  OnBoardingContentModel(
    title: "Hoşgeldiniz",
    description: "",
    color:const Color.fromRGBO(0, 74, 173,1.0),
    colorText: Colors.white,
    image: "1",
  ),
  OnBoardingContentModel(
    title: "Bilginin Gücü Uygulamasına Hoş Geldiniz!",
    description: "Bu uygulama ile hem eğlenip hem de bilgi ve yeteneklerinizi geliştirebilirsiniz.",
    color:const Color.fromRGBO(53, 166, 82,1.0),
    colorText: const Color.fromRGBO(249, 189, 6,1),
    image: "3",
  ),
  OnBoardingContentModel(
    title: "Brick Breaker Oyunu Oynayarak Eğlenin",
    description: "Reklam izlemek yerine oyun oynayarak etiketleme yapma şansını yakalayın.",
    color:const Color.fromRGBO(253, 189, 70,1.0),
    colorText: const Color.fromRGBO(229, 108, 91,1),
    image: "4",
  ),
  OnBoardingContentModel(
    title: "Fotoğraf Yükleyerek Can Barınızı Doldurun",
    description: "Fotoğraf yükleyerek can barınızı doldurun ve oyuna devam edin.",
    color:const Color.fromRGBO(232, 68, 54,1.0),
    colorText: const Color.fromRGBO(246, 185, 13,1),
    image: "5",
  ),
  OnBoardingContentModel(
    title: "Etiketlemeyi Ücretsiz Yapın",
    description: "Ücretli olan etiketleme işlemini, Bilginin Gücü ile oyun oynayarak ücretsiz olarak yapın.",
    color:const Color.fromRGBO(66, 133, 243,1.0),
    colorText: const Color.fromRGBO(232, 68, 54,1),
    image: "6",
  ),
  OnBoardingContentModel(
    title: "Uluslararası Veri Ağına Katkıda Bulunun",
    description: "Çektiğiniz fotoğrafları etiketleyerek yükleyin; bu etiketler yapay zeka tarafından analiz edilerek uluslararası büyük veri ağımıza eklenecektir.",
    color:const Color.fromRGBO(174, 223, 247,1.0),
    colorText: const Color.fromRGBO(54, 168, 84,1),
    image: "7",
  ),

];

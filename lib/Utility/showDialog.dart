import 'package:flutter/material.dart';
import 'package:labeling/label/label_view.dart';

void showHeartDialog(BuildContext context){
  showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Kalbiniz Kalmadı",style: TextStyle(fontWeight: FontWeight.bold),),
                  content: const Text("Oynamak için kalbiniz kalmadı. Kalbinizin yenilenmesini bekleyebilirsiniz veya etiketleme yaparak kalplerinizi hemen yenileyebilirsiniz."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Dialog kapat
                      },
                      child: const Text("Bekle",style: TextStyle(color: Colors.red)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LabelViewPage(), // Etiketleme sayfasına git
                          ),
                        );
                      },
                      child: const Text("Etiketle",style: TextStyle(color: Colors.green)),
                    ),
                  ],
                );
              },
            );
}
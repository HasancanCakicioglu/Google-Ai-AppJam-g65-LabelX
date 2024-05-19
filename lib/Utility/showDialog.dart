import 'package:flutter/material.dart';
import 'package:labeling/label/label_view.dart';

void showHeartDialog(BuildContext context){
  showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Kalbiniz Kalmadı"),
                  content: Text("Oynamak için kalbiniz kalmadı. Kalbinizin yenilenmesini bekleyebilirsiniz veya etiketleme yaparak kalplerinizi hemen yenileyebilirsiniz."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Dialog kapat
                      },
                      child: Text("Bekle"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LabelViewPage(), // Etiketleme sayfasına git
                          ),
                        );
                      },
                      child: Text("Etiketle"),
                    ),
                  ],
                );
              },
            );
}
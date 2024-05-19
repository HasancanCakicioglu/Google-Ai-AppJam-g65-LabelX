import 'package:flutter/material.dart';

class LabelViewPage extends StatefulWidget {
  const LabelViewPage({super.key});

  @override
  State<LabelViewPage> createState() => _LabelViewPageState();
}

class _LabelViewPageState extends State<LabelViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Container(height: 100,width: 100,),
            TextField(),
            Spacer(),
            ElevatedButton(onPressed: (){}, child: Text("Gönder")),
          ],
        ),
      ),
    );
  }
}

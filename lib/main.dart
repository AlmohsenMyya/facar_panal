import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: FirebasePage(),
  ));
}

class FirebasePage extends StatefulWidget {
  @override
  _FirebasePageState createState() => _FirebasePageState();
}

class _FirebasePageState extends State<FirebasePage> {
  final db = FirebaseFirestore.instance.collection('data');
  TextEditingController my_web_link = TextEditingController();
  TextEditingController google_play_link = TextEditingController();
  TextEditingController app_store_link = TextEditingController();
  bool switchValue = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await db.doc("data1").get().then((event) {
      setState(() {
        switchValue = event['switch'];
        my_web_link.text = event['my_web_link'];
        google_play_link.text = event['google_play_link'];
        app_store_link.text = event['app_store_link'];
      });
    });
  }

  void addOrUpdateData() async {
    await db.doc('data1').set({
      'switch': switchValue,
      'my_web_link': my_web_link.text ,
      'google_play_link': google_play_link.text,
      'app_store_link': app_store_link.text,
    }).then((value) => showSnackBar('Data added/updated successfully!'))
        .catchError((error) => showSnackBar('Error: $error'));
    print('Data added/updated successfully!');
  }
  void showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'لوحة التحكم',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Text(
                  'تحديث التطبيق:',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8.0),
                Switch(
                  value: switchValue,
                  onChanged: (value) {
                    setState(() {
                      switchValue = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: my_web_link,
              decoration: const InputDecoration(
                  labelText: 'my web link',
                  helperText: 'https://Faqar.alamshane.com يجب ان يكون بالصيغة التالية   '

              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: google_play_link,
              decoration: const InputDecoration(
                labelText: 'google play link',
                helperText: '   https://play.google.com/store/apps/details?id=com.whatsapp يجب ان يكون بالصيغة التالية   '

              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: app_store_link,
              decoration: const InputDecoration(
                  labelText: 'app store link ',
                  helperText: '  https://apps.apple.com/us/app/whatsapp-messenger/id310633997 يجب ان يكون بالصيغة التالية   '

              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addOrUpdateData,
              child: const Text('Add/Update Data'),
            ),
          ],
        ),
      ),
    );
  }
}
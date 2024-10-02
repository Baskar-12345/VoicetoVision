import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech to Indian Sign Language',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpeechToSignLanguage(),
    );
  }
}

class SpeechToSignLanguage extends StatefulWidget {
  const SpeechToSignLanguage({super.key});

  @override
  _SpeechToSignLanguageState createState() => _SpeechToSignLanguageState();
}

class _SpeechToSignLanguageState extends State<SpeechToSignLanguage> {
  final TextEditingController _speechController = TextEditingController();
  bool _isProcessing = false;
  String _videoUrl = "";

  // Mock function to simulate video generation
  Future<void> _convertSpeechToSign() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulating a delay for the backend processing
    await Future.delayed(const Duration(seconds: 3));

    // Here, you would typically call the backend to convert speech to sign language
    // and get the video URL.
    // For this demo, I'm using a placeholder video URL
    setState(() {
      _videoUrl = "https://www.example.com/indian_sign_language_video.mp4";
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Indian Sign Language'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _speechController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter speech text',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isProcessing ? null : _convertSpeechToSign,
              child: _isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Convert to Sign Language'),
            ),
            const SizedBox(height: 16),
            _videoUrl.isNotEmpty
                ? Column(
                    children: [
                      const Text('Sign Language Video:'),
                      const SizedBox(height: 10),
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          color: Colors.black,
                          child: Center(
                            child: Text(
                              'Video URL: $_videoUrl',
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

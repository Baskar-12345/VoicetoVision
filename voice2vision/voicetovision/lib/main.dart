import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:video_player/video_player.dart';

void main() {
  runApp(Voice2VisionApp());
}

class Voice2VisionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice2Vision',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Voice2VisionScreen(),
    );
  }
}

class Voice2VisionScreen extends StatefulWidget {
  @override
  _Voice2VisionScreenState createState() => _Voice2VisionScreenState();
}

class _Voice2VisionScreenState extends State<Voice2VisionScreen> {
  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _spokenText = '';
  String _displayedText = 'Press the button and start speaking!';
  VideoPlayerController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speechToText.listen(onResult: (result) {
        setState(() {
          _spokenText = result.recognizedWords;
        });
      });
    }
  }

  void _stopListening() async {
    setState(() {
      _isListening = false;
    });
    _speechToText.stop();
    _fetchVideoForWords(_spokenText);
  }

  void _fetchVideoForWords(String words) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/translate'),  // Change this to your Flask server's IP if necessary
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'text': words}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final videoUrls = data['videos'];
      if (videoUrls.isNotEmpty) {
        _displayVideo(videoUrls.first); // Play the first video URL
      }
    } else {
      setState(() {
        _displayedText = "Error fetching video for the text.";
      });
    }
  }

  void _displayVideo(String url) {
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {});
        _controller?.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice2Vision'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: _controller != null && _controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : Text(_displayedText),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isListening ? _stopListening : _startListening,
            child: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
          ),
        ],
      ),
    );
  }
}

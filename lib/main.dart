import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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

class Voice2VisionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/logo.png'), // Your logo path
              radius: 20,
            ),
            SizedBox(width: 10),
            Text('Voice to Vision'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Button Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10), // Added padding
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.greenAccent, Colors.green],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SpeakScreen()),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.mic, size: 24),
                            SizedBox(width: 8),
                            Text('Speak', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10), // Added padding
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.blue],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LearnScreen()),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.book, size: 24),
                            SizedBox(width: 8),
                            Text('Learn', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpeakScreen extends StatefulWidget {
  @override
  _SpeakScreenState createState() => _SpeakScreenState();
}

class _SpeakScreenState extends State<SpeakScreen> {
  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _spokenText = '';
  String? _currentGifPath;
  String _currentGifName = ''; // New variable to hold the current GIF name

  // List of stop words
  final List<String> stopWords = [
    "am", "is", "are", "was", "were", "be", "been",
    "being", "have", "has", "had", "to", "a", "an", "the",
    "if", "as", "of", "by", "for", "with"
  ];

  // Predefined dictionary for mapping keywords to GIFs
  final Map<String, String> gifMapping = {
    "what": "assets/what.gif",
    "your": "assets/your.gif",
    "name": "assets/name.gif",
    "areat": "assets/area.gif",
    "come": "assets/come.gif",
    "dance": "assets/dance.gif",
    "do": "assets/do.gif",
    "fine": "assets/fine.gif",
    "front": "assets/front.gif",
    "go": "assets/go.gif",
    "here": "assets/here.gif",
    "I": "assets/I.gif",
    "like": "assets/like.gif",
    "love": "assets/love.gif",
    "when": "assets/when.gif",
    "we": "assets/we.gif",
    "which": "assets/which.gif",
    "will": "assets/will.gif",
    "you": "assets/you.gif",
  };

  // Hearing GIF path
  final String hearingGifPath = "assets/hear.gif"; // Add your hearing GIF path

  // Avatar GIF path (the blinking animation before listening starts)
  final String avatarGifPath = "assets/avatar.gif"; // Add your avatar GIF path here

  @override
  void dispose() {
    super.dispose();
  }

  void _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _isListening = true;
        _currentGifPath = hearingGifPath; // Show the hearing GIF while listening
      });
      _speechToText.listen(onResult: (result) {
        setState(() {
          _spokenText = result.recognizedWords;
        });
      });
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
    _processAndShowGifs(_spokenText);
  }

  void _processAndShowGifs(String spokenText) {
    // Split the spoken text into words and filter out stop words
    List<String> words = spokenText.split(' ').where((word) => !stopWords.contains(word)).toList();
    // Display GIFs for each word in sequence
    _showGifsSequentially(words);
  }

  Future<void> _showGifsSequentially(List<String> words) async {
    for (String word in words) {
      if (gifMapping.containsKey(word)) {
        String gifPath = gifMapping[word]!;
        setState(() {
          _currentGifPath = gifPath; // Display the respective GIF for each word
          _currentGifName = word; // Store the name of the current GIF
        });
        // Wait for 1.5 seconds before moving to the next GIF
        await Future.delayed(Duration(seconds: 2));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speak"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // Recognized Sentence Display
              Text(
                "Recognized Sentence: $_spokenText",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Start and Stop Listening Buttons in Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10), // Added padding
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orangeAccent, Colors.orange],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: _isListening ? null : _startListening,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.mic, size: 24),
                            SizedBox(width: 8),
                            Text("Start Listening", style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10), // Added padding
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.redAccent, Colors.red],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: _isListening ? _stopListening : null,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.stop, size: 24),
                            SizedBox(width: 8),
                            Text("Stop Listening", style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Displaying the current GIF with InteractiveViewer for zooming
              if (_currentGifPath != null)
                InteractiveViewer(
                  child: Image.asset(
                    _currentGifPath!,
                    width: 500, // Increased width for better visibility
                    height: 500, // Increased height for better visibility
                    fit: BoxFit.cover, // To cover the space while maintaining aspect ratio
                  ),
                ),
              SizedBox(height: 20),
              // Display the name of the current GIF
              Text(
                "Current GIF: $_currentGifName",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LearnScreen extends StatelessWidget {
  final List<String> gifNames = [
    "what",
    "your",
    "name",
    "areat",
    "come",
    "dance",
    "do",
    "fine",
    "front",
    "go",
    "here",
    "I",
    "like",
    "love",
    "when",
    "we",
    "which",
    "will",
    "you",
  ];

  void _playGif(BuildContext context, String gifName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GifPlayerScreen(gifName: gifName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Learn"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ListView.builder(
            itemCount: gifNames.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 8,
                child: ListTile(
                  title: Text(
                    gifNames[index],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () => _playGif(context, gifNames[index]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class GifPlayerScreen extends StatelessWidget {
  final String gifName;

  GifPlayerScreen({required this.gifName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gifName),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.asset(
            'assets/$gifName.gif', // Assuming your GIFs are named as per the gif names
            width: 500, // Increased width for better visibility
            height: 500, // Increased height for better visibility
            fit: BoxFit.cover, // To cover the space while maintaining aspect ratio
          ),
        ),
      ),
    );
  }
}

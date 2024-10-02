from flask import Flask, request, jsonify
import os

app = Flask(__name__)

# List of stop words
stop_words = set([
    "am", "is", "are", "was", "were", "be", "been",
    "being", "have", "has", "had", "to", "a", "an", "the",
    "if", "as", "of", "by", "for", "with"
])

# Mapping words to video files
word_to_video = {
    "area": "area.mp4",
    "come": "come.mp4",
    "dance": "dance.mp4",
    "fine": "fine.mp4",
    "go": "go.mp4",
    "how": "how.mp4",
    "i": "I.mp4",
    "love": "love.mp4",
    "name": "name.mp4",
    "we": "We.mp4",
    "you": "you.mp4"
}

# Function to remove stop words
def remove_stopwords(sentence):
    words = sentence.split()
    return [word for word in words if word.lower() not in stop_words]

@app.route('/')
def home():
    return "Flask server is running."

@app.route('/process_text', methods=['POST'])
def process_text():
    # Get the text from the Flutter app
    data = request.get_json()
    speech_text = data.get('text', '')
    
    if not speech_text:
        return jsonify({'error': 'No text provided'}), 400

    # Remove stop words
    filtered_words = remove_stopwords(speech_text)

    # Get corresponding video files
    video_files = []
    for word in filtered_words:
        video_path = word_to_video.get(word.lower())
        if video_path and os.path.exists(video_path):
            video_files.append(video_path)
    
    # Return the list of video files to the Flutter app
    return jsonify({'videos': video_files})

if __name__ == '__main__':
    app.run(debug=True)

from flask import Flask, request, jsonify
import os

app = Flask(__name__)

# Mock dictionary mapping words to video file paths
word_to_video = {
    "area": "SignLangVids/area.mp4",
    "come": "SignLangVids/come.mp4",
    "dance": "SignLangVids/dance.mp4",
    "do": "SignLangVids/do.mp4",
    "fine": "SignLangVids/fine.mp4",
    "go": "SignLangVids/go.mp4",
    "here": "SignLangVids/here.mp4",
    "how": "SignLangVids/how.mp4",
    "i": "SignLangVids/I.mp4",
    "like": "SignLangVids/like.mp4",
    "love": "SignLangVids/love.mp4",
    "name": "SignLangVids/name.mp4",
    "tomorrow": "SignLangVids/Tomorrow.mp4",
    "we": "SignLangVids/We.mp4",
    "what": "SignLangVids/what.mp4",
    "when": "SignLangVids/when.mp4",
    "which": "SignLangVids/which.mp4",
    "will": "SignLangVids/will.mp4",
    "you": "SignLangVids/you.mp4",
    "your": "SignLangVids/your.mp4"
}

def get_video_paths(text):
    """ Given a text, return the corresponding video file paths. """
    words = text.split()
    video_urls = []
    
    for word in words:
        video_path = word_to_video.get(word.lower())
        if video_path:
            video_urls.append(f"http://example.com/{video_path}")  # Replace with actual server URL
    
    return video_urls

@app.route('/translate', methods=['POST'])
def translate():
    data = request.json
    text = data.get('text')
    
    if not text:
        return jsonify({"error": "No text provided"}), 400
    
    video_urls = get_video_paths(text)
    
    if video_urls:
        return jsonify({"videos": video_urls}), 200
    else:
        return jsonify({"error": "No videos found for the given words"}), 404

if __name__ == '__main__':
    app.run(debug=True)

from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

todos = []
id_count = 1

@app.route('/todos', methods=['GET', 'POST'])
def handle_todos():
    global id_count
    if request.method == 'GET':
        return jsonify(todos)
    data = request.json
    todo = {'id': id_count, 'title': data['title'], 'done': False}
    todos.append(todo)
    id_count += 1
    return jsonify(todo), 201

@app.route('/todos/<int:id>', methods=['PUT', 'DELETE'])
def handle_todo(id):
    for t in todos:
        if t['id'] == id:
            if request.method == 'PUT':
                t['done'] = not t['done']
                return jsonify(t)
            todos.remove(t)
            return jsonify({'msg': 'deleted'})
    return jsonify({'error': 'not found'}), 404

if __name__ == '__main__':
    app.run(debug=True)

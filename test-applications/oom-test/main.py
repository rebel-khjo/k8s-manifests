from flask import Flask, jsonify

app = Flask(__name__)

# 메모리를 소비할 리스트
allocated_memory = []

@app.route('/test/oom', methods=['GET'])
def allocate_memory():
    global allocated_memory
    try:
        # 100MB 메모리 할당 (10^7개의 10바이트 문자열)
        allocated_memory.append(" " * (100 * 1024 * 1024))
        return jsonify({"status": "success", "message": "Allocated 100MB", "current_allocation": len(allocated_memory) * 100}), 200
    except MemoryError:
        return jsonify({"status": "failure", "message": "Out of memory"}), 500

@app.route('/test/reset', methods=['GET'])
def reset_memory():
    global allocated_memory
    allocated_memory = []
    return jsonify({"status": "success", "message": "Memory allocation reset"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
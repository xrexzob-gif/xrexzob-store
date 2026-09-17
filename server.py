from flask import Flask, request, jsonify
import subprocess
import os
import signal

app = Flask(__name__)

bot_process = None


@app.route("/")
def home():
    return "XREXZOB BOT HOST ONLINE"


@app.route("/run", methods=["POST"])
def run_bot():
    global bot_process

    data = request.get_json()

    if not data or "code" not in data:
        return jsonify({
            "success": False,
            "message": "Kode Python tidak ditemukan."
        }), 400

    code = data["code"]

    if not code.strip():
        return jsonify({
            "success": False,
            "message": "Kode Python kosong."
        }), 400

    # Simpan script sementara
    filename = "user_bot.py"

    with open(filename, "w", encoding="utf-8") as file:
        file.write(code)

    # Kalau bot lama masih berjalan, hentikan dulu
    if bot_process is not None and bot_process.poll() is None:
        try:
            os.killpg(
                os.getpgid(bot_process.pid),
                signal.SIGTERM
            )
        except Exception:
            bot_process.terminate()

    try:
        bot_process = subprocess.Popen(
            ["python3", filename],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            start_new_session=True
        )

        return jsonify({
            "success": True,
            "message": "Python bot berhasil dijalankan.",
            "pid": bot_process.pid
        })

    except Exception as error:

        return jsonify({
            "success": False,
            "message": str(error)
        }), 500


@app.route("/stop", methods=["POST"])
def stop_bot():
    global bot_process

    if bot_process is None:
        return jsonify({
            "success": False,
            "message": "Tidak ada bot yang berjalan."
        })

    if bot_process.poll() is None:

        try:
            os.killpg(
                os.getpgid(bot_process.pid),
                signal.SIGTERM
            )
        except Exception:
            bot_process.terminate()

        bot_process = None

        return jsonify({
            "success": True,
            "message": "Bot dihentikan."
        })

    bot_process = None

    return jsonify({
        "success": False,
        "message": "Bot sudah tidak berjalan."
    })


@app.route("/status")
def status():

    if bot_process is not None:
        if bot_process.poll() is None:
            return jsonify({
                "online": True,
                "message": "Bot sedang berjalan."
            })

    return jsonify({
        "online": False,
        "message": "Bot offline."
    })


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000
      )

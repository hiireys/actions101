from flask import Flask

app = Flask(__name__)

@app.route("/")
def root():
    return "This root path"


@app.route("/version")
def version():
    return "This is a flask application"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)   
##As will be run by gunicorn, so guniconr imports the file so anyway this block won't run

# gunicorn app:app

# Meaning:

# import module → app filename
# find variable → app
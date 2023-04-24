from flask import Flask, render_template, request

app = Flask(__name__)

# class

@app.route('/',methods = ['GET'])
def index():
    return render_template('index.html')

@app.route('/',methods = ['POST'])
def index_results():
    if request.method == 'POST':
        data = request.form
        return render_template("index.html", result=data)
    # return render_template('index.html')




if __name__ == '__main__':
   app.run()
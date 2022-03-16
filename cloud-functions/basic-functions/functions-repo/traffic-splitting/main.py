import os

color = os.environ.get('COLOR')

def hello_world(request):
    return f'<body style="background-color:{color}"><h1>Hello World!</h1></body>'
from requests import put, get

def create_todo(todo_id, todo_content):
    put(f'http://localhost:5000/{todo_id}', data={'data': todo_content}).json()


def read_todo(todo_id):
    result = get(f'http://localhost:5000/{todo_id}').json()
    print(result)

def hello():
    print("hello")

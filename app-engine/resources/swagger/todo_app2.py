import json
import os
import re
import time
from typing import Tuple

import flask.scaffold
import teradatasql
import werkzeug
from flask import Flask, request
from werkzeug.middleware.proxy_fix import ProxyFix


# workaround to fix an import error of flask_restplus
flask.helpers._endpoint_from_view_func = flask.scaffold._endpoint_from_view_func
werkzeug.cached_property = werkzeug.utils.cached_property  # type: ignore
from flask_restplus import Api, Resource, fields, marshal  # noqa: E402


app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app)
api = Api(app, validate=True, skip_none=True)


doto_model = api.model('Model', {
    'task': fields.String,
    'person': fields.String,
})

class TodoDao(object):
    def __init__(self, todo_id, task, person):
        self.todo_id = todo_id
        self.task = task
        self.person = person

        # This field will not be sent in the response
        self.status = 'active'

@api.route('/m_todo')
class MirisTodo(Resource):
    @api.marshal_with(doto_model)
    def get(self, **kwargs):
        return TodoDao(todo_id='todo1', person='m', task='cooking great!')


@api.route('/y_todo')
class YusTodo(Resource):
    @api.marshal_with(doto_model)
    def get(self, **kwargs):
        return TodoDao(todo_id='todo2', person='y',task='running great!')

if __name__ == '__manin__':
    app.run(host='127.0.0.1', port=5000)
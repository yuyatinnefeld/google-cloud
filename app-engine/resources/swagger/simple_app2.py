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


@api.route('/example/<id>/<param>')
@api.doc(params={'id': 'id of example','param':'param of example'})
class Example(Resource):
    def get(self, id, param):
        return {'id': id, 'param': param}


if __name__ == '__manin__':
    app.run(host='127.0.0.1', port=5000)
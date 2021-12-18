import os
import flask.scaffold
import werkzeug

from typing import Tuple, Optional
from flask import Flask, request
from werkzeug.middleware.proxy_fix import ProxyFix

# workaround to fix an import error of flask_restplus
flask.helpers._endpoint_from_view_func = flask.scaffold._endpoint_from_view_func
werkzeug.cached_property = werkzeug.utils.cached_property  # type: ignore
from flask_restplus import Api, Resource, fields, marshal  # noqa: E402

from apis import api

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app)
api.init_app(app)


if __name__ == '__manin__':   
    app.run(host='127.0.0.1', port=5000)

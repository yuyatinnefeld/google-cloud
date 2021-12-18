from typing import Tuple, Optional
import flask.scaffold
import werkzeug
from flask import Flask, request
from werkzeug.middleware.proxy_fix import ProxyFix

from apis.dataproc import cluster_ns, job_ns, wf_temp_ns

# workaround to fix an import error of flask_restplus
flask.helpers._endpoint_from_view_func = flask.scaffold._endpoint_from_view_func
werkzeug.cached_property = werkzeug.utils.cached_property  # type: ignore
from flask_restplus import Api, Namespace, Resource, fields, marshal  # noqa: E402


# API Model
# ============================================
api = Api(
    title='Dataproc API',
    version='1.0.0',
    description='Swagger Dataproc API'
)

api.add_namespace(cluster_ns)
api.add_namespace(wf_temp_ns)
api.add_namespace(job_ns)

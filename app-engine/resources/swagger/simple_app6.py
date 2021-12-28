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
api = Api(app, title='Dataproc API Docs', description='', version='1.0.0',
default = 'Dataproc API', validate=True, skip_none=True)


cluster_model = api.model('Cluster', {
    'cluster_name': fields.String(required=True, description='The cluster name'),
    'cluster_uuid': fields.String(readonly=True, required=False, description='The cluster unique identifier')
})

class ClusterOperator(object):
    def __init__(self):
        self.counter = 0
        self.clusters = []

    def get(self, cluster_name):
        for cluster in self.clusters:
            if cluster['cluster_name'] == cluster_name:
                return cluster
        api.abort(404, "cluster {} doesn't exist".format(cluster_name))

    def create(self, data):
        cluster = data
        self.clusters.append(cluster)
        cluster['cluster_uuid'] = 'hihihihi'
        return cluster


ClusterOperator = ClusterOperator()
ClusterOperator.create({'cluster_name': 'data-preparation-cluster-1'})
ClusterOperator.create({'cluster_name': 'data-preparation-cluster-2'})
ClusterOperator.create({'cluster_name': 'data-validation-cluster-1'})

@api.route('/clusters')
class ClusterList(Resource):
    '''Shows a list of all clusters, and lets you POST to add new clusters'''
    @api.doc('list_clusters')
    @api.marshal_list_with(cluster_model)
    def get(self):
        '''List all clusters'''
        return ClusterOperator.clusters

    @api.doc('create_cluster')
    @api.expect(cluster_model)
    @api.marshal_with(cluster_model, code=201)
    def post(self):
        '''Create a new cluster'''
        return ClusterOperator.create(api.payload), 201


if __name__ == '__manin__':
    app.run(host='127.0.0.1', port=5000)

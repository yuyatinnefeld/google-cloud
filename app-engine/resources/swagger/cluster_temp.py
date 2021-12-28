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


api = api.namespace('', description='Dataproc Cluster operations')

cluster = api.model('Cluster', {
    'id': fields.Integer(readonly=True, description='The cluster unique identifier'),
    'cluster': fields.String(required=True, description='The cluster details')
})

job = api.model('Job', {
    'id': fields.Integer(readonly=True, description='The job unique identifier'),
    'job': fields.String(required=True, description='The job details'),
    'cluster_id': fields.String(required=True, description='The cluster details')

})

class ClusterOperator(object):
    def __init__(self):
        self.counter = 0
        self.clusters = []

    def get(self, id):
        for cluster in self.clusters:
            if cluster['id'] == id:
                return cluster
        api.abort(404, "cluster {} doesn't exist".format(id))

    def create(self, data):
        cluster = data
        cluster['id'] = self.counter = self.counter + 1
        self.clusters.append(cluster)
        return cluster

    def delete(self, id):
        cluster = self.get(id)
        self.clusters.remove(cluster)

class JobOperator(object):
    def __init__(self):
        self.counter = 0
        self.jobs = []

    def get(self, id):
        for job in self.jobs:
            if job['id'] == id:
                return job
        api.abort(404, "job {} doesn't exist".format(id))

    def create(self, data):
        job = data
        job['id'] = self.counter = self.counter + 1
        self.jobs.append(job)
        return job


ClusterOperator = ClusterOperator()
ClusterOperator.create({'cluster': 'data-preparation-cluster-1'})
ClusterOperator.create({'cluster': 'data-preparation-cluster-2'})
ClusterOperator.create({'cluster': 'data-validation-cluster-1'})

@api.route('/cluster')
class ClusterList(Resource):
    '''Shows a list of all clusters, and lets you POST to add new clusters'''
    @api.doc('list_clusters')
    @api.marshal_list_with(cluster)
    def get(self):
        '''List all clusters'''
        return ClusterOperator.clusters

    @api.doc('create_cluster')
    @api.expect(cluster)
    @api.marshal_with(cluster, code=201)
    def post(self):
        '''Create a new cluster'''
        return ClusterOperator.create(api.payload), 201


@api.route('/cluster/<int:id>')
@api.response(404, 'cluster not found')
@api.param('id', 'The cluster identifier')
class Cluster(Resource):
    '''Show a single cluster item and lets you delete them'''
    @api.doc('get_cluster')
    @api.marshal_with(cluster)
    def get(self, id):
        '''Fetch a given resource'''
        return ClusterOperator.get(id)

    @api.doc('delete_cluster')
    @api.response(204, 'cluster deleted')
    def delete(self, id):
        '''Delete a cluster given its identifier'''
        ClusterOperator.delete(id)
        return '', 204

    @api.expect(cluster)
    @api.marshal_with(cluster)
    def put(self, id):
        '''Update a cluster with the job given its identifier'''
        return ClusterOperator.update(id, api.payload)


JobOperator = JobOperator()
JobOperator.create({'job': 'dataprep-job-1', 'cluster_id': 'data-preparation-cluster-1'})
JobOperator.create({'job': 'dataprep-job-2', 'cluster_id': 'data-preparation-cluster-1'})
JobOperator.create({'job': 'dataprep-job-3', 'cluster_id': 'data-validation-cluster-1'})

@api.route('/job')
class JobList(Resource):
    '''Shows a list of all jobs, and lets you POST to add new jobs'''
    @api.doc('list_jobs')
    @api.marshal_list_with(job)
    def get(self):
        '''List all jobs'''
        return JobOperator.jobs

    @api.doc('create_job')
    @api.expect(job)
    @api.marshal_with(job, code=201)
    def post(self):
        '''Create a new job'''
        return JobOperator.create(api.payload), 201

if __name__ == '__manin__':
    app.run(host='127.0.0.1', port=5000)

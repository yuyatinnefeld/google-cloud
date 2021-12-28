import json
import os
import re
import time
from typing import Tuple, Optional

import flask.scaffold
import teradatasql
import werkzeug
from flask import Flask, request
from gcp import create_cluster, delete_cluster
from werkzeug.middleware.proxy_fix import ProxyFix

# workaround to fix an import error of flask_restplus
flask.helpers._endpoint_from_view_func = flask.scaffold._endpoint_from_view_func
werkzeug.cached_property = werkzeug.utils.cached_property  # type: ignore
from flask_restplus import Api, Resource, fields, marshal  # noqa: E402

gcp_project_id = os.environ["PROJECT_ID"]
dataproc_staging_bucket = os.environ["DATAPROC_TEMP_BUCKET"]
dataproc_temp_bucket = os.environ["DATAPROC_STAGING_BUCKET"]
region = os.environ["REGION"]

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app)
api = Api(app, title='Dataproc API Docs', description='', version='1.0.0',
default = 'Dataproc API', validate=True, skip_none=True)


cluster_model = api.model('Cluster', {
    'cluster_name': fields.String(required=True, description='The cluster name which you can define'),
    'cluster_uuid': fields.String(readonly=True, required=False, description='The cluster uuid which will be generated automatically by GCP Dataproc'),
    'status': fields.String(readonly=True, required=False, description='The status of cluster')
})


class ClusterOperator(object):
    
    def __init__(self):
        self.clusters = []

    def get(self, cluster_name:str) -> Optional[dict]:
        '''Get an existing dataproc cluster object'''

        for cluster in self.clusters:
            if cluster['cluster_name'] == cluster_name:
                return cluster
        api.abort(404, "cluster {} doesn't exist".format(cluster_name))

    def create(self, input_data:str) -> Optional[dict]:
        '''Create a dataproc cluster object'''
        cluster = input_data
        cluster['cluster_uuid'] = '???'
        cluster['status'] = 'starting...'
        self.clusters.append(cluster)
        return cluster

    def delete(self, cluster_name:str) -> None:
        '''Delete a dataproc cluster object'''
        cluster = self.get(cluster_name)
        self.clusters.remove(cluster)
        
ClusterOperator = ClusterOperator()
#ClusterOperator.create({'cluster_name': 'data-preparation-cluster-1'})
#ClusterOperator.create({'cluster_name': 'data-preparation-cluster-2'})
#ClusterOperator.create({'cluster_name': 'data-validation-cluster-1'})

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
        #TODO: optimizie that users do not need to wait the result
        new_cluster = ClusterOperator.create(api.payload)
        cluster_uuid = create_cluster(project_id=gcp_project_id, region=region, 
        cluster_name=new_cluster['cluster_name'], config_bucket=dataproc_staging_bucket, temp_bucket=dataproc_temp_bucket)
        new_cluster['cluster_uuid'] = cluster_uuid
        new_cluster['status'] = 'created'
        return new_cluster, 201


@api.route('/cluster/<string:cluster_name>')
@api.response(404, 'cluster not found')
@api.param('cluster_name', 'The cluster identifier')
class Cluster(Resource):
    '''Show a single cluster item and lets you delete them'''
    @api.doc('get_cluster')
    @api.marshal_with(cluster_model)
    def get(self, cluster_name):
        '''Get a cluster'''
        return ClusterOperator.get(cluster_name)


    @api.doc('delete_cluster')
    @api.response(204, 'cluster deleted')
    def delete(self, cluster_name):
        '''Delete a cluster given its identifier'''
        delete_cluster(project_id=gcp_project_id, region=region, cluster_name=cluster_name)
        ClusterOperator.delete(cluster_name)
        return '', 204
        
if __name__ == '__manin__':
    app.run(host='127.0.0.1', port=5000)

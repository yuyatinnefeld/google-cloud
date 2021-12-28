import os

from flask import Flask
from flask_restful import reqparse, abort, Api, Resource


app = Flask(__name__)
api = Api(app)

CLUSTERS = {
    'cluster1': {'cluster_name': 'data_collection_cluster'},
    'cluster2': {'cluster_name': 'data_processing_cluster'},
    'cluster3': {'cluster_name': 'data_validation_cluster'},
}


def abort_if_cluster_doesnt_exist(cluster_name):
    if cluster_name not in CLUSTERS:
        abort(404, message="Cluster {} doesn't exist".format(cluster_name))

parser = reqparse.RequestParser()
parser.add_argument('cluster_name')


# Cluster
# shows a single Cluster item and lets you delete a Cluster item
class Cluster(Resource):
    def get(self, cluster_name):
        abort_if_cluster_doesnt_exist(cluster_name)
        return CLUSTERS[cluster_name]

    def delete(self, cluster_name):
        abort_if_cluster_doesnt_exist(cluster_name)
        del CLUSTERS[cluster_name]
        return '', 204

    def put(self, cluster_name):
        args = parser.parse_args()
        cluster_name = {'cluster_name': args['cluster_name']}
        CLUSTERS[cluster_name] = cluster_name
        return cluster_name, 201


# ClusterList
# shows a list of all CLUSTERS, and lets you POST to add new cluster
class ClusterList(Resource):
    def get(self):
        return CLUSTERS

    def post(self):
        args = parser.parse_args()
        cluster_name = int(max(CLUSTERS.keys()).lstrip('cluster')) + 1
        cluster_name = 'cluster%i' % cluster_name
        CLUSTERS[cluster_name] = {'cluster_name': args['cluster_name']}
        return CLUSTERS[cluster_name], 201

##
## Actually setup the Api resource routing here
##
api.add_resource(ClusterList, '/cluster_list')
api.add_resource(Cluster, '/cluster/<cluster_name>')

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))


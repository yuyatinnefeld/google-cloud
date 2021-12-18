from flask_restplus import Namespace, fields, Resource, marshal

import gcp
from apis.cluster_operator import ClusterOperator
from apis.wf_temp_operator import WorkflowTemplateOperator
from logger import logger

ClusterOperator = ClusterOperator()
WorkflowTemplateOperator = WorkflowTemplateOperator()

# Namespace definition
# ============================================
cluster_ns = Namespace('cluster', description='Cluster')
job_ns = Namespace('job', description='Job')
wf_temp_ns = Namespace('workflow template', description='Workflow Template')


# API Model
# ============================================
cluster_model = cluster_ns.model('Cluster', {
    'cluster_name': fields.String(required=True, description='The cluster name which you can define'),
    'cluster_uuid': fields.String(readonly=True, required=False, description='The cluster uuid which will be generated automatically by GCP Dataproc'),
    'status': fields.String(readonly=True, required=False, description='The status of cluster')
})

wf_temp_model = wf_temp_ns.model('Workflow Template', {
    'template_name': fields.String(required=True, description='The workflow tempalte name which you can define'),
    'parameters': fields.String(required=False, description='The optinal parameters for workflow template settings'),
    'workflow_id': fields.String(readonly=True, required=False, description='The workflow template id which will be generated automatically by GCP Dataproc'),
    'status': fields.String(readonly=True, required=False, description='The status of workflow template'),
})

job_model = job_ns.model('Job', {
    'job_name': fields.String(required=False, description='The job unique identifier'),
    'cluster_name': fields.String(required=True, description='The cluster name'),
    'main_python_file_uri': fields.String(required=True, description='The uri of GCP bucket where is stored pyspark file'),
    'parameters': fields.List(fields.String(required=False, description='The optional parameters for the Dataproc job'))    ,
})

# "Cluster" resource RESTful API definition
# ============================================
@cluster_ns.route('/cluster/<string:cluster_name>')
@cluster_ns.response(404, 'cluster not found')
@cluster_ns.param('cluster_name', 'The cluster identifier')
class Cluster(Resource):
    """Show a single cluster item and lets you delete them"""
    @cluster_ns.doc('get_cluster')
    @cluster_ns.marshal_with(cluster_model)
    def get(self, cluster_name):
        """Get a cluster"""
        header = ClusterOperator.get(cluster_name)
        body = header[1]
        return body

    @cluster_ns.doc('delete_cluster')
    @cluster_ns.response(204, 'cluster deleted')
    def delete(self, cluster_name):
        """Delete a cluster given its identifier"""
        header = ClusterOperator.delete(cluster_name)
        body = header[1]
        return body

# "ClusterList" resource RESTful API definition
# ============================================
@cluster_ns.route('/clusters')
class ClusterList(Resource):
    """Shows a list of all clusters, and lets you POST to add new clusters"""
    @cluster_ns.doc('list_clusters')
    @cluster_ns.marshal_list_with(cluster_model)
    def get(self):
        """List all clusters"""
        header = ClusterOperator.get_list_clusters()
        body = header[1]
        return body

    @cluster_ns.doc('create_cluster')
    @cluster_ns.expect(cluster_model)
    @cluster_ns.marshal_with(cluster_model, code=201)
    def post(self):
        """Create a new cluster"""
        header = ClusterOperator.create(cluster_ns.payload)
        body = header[1]
        return body


# "ClusterYaml" resource RESTful API definition
# ============================================
@cluster_ns.route('/yaml_cluster')
class ClusterYaml(Resource):
    @cluster_ns.doc('create_cluster_with_yaml_conf')
    def post(self):
        """Create a new cluster with a YAML config file"""
        header = ClusterOperator.create_with_yaml()
        body = header[1]
        return body


# "Job" resource RESTful API definition
# ============================================
@job_ns.route('/job_submit')
class Job(Resource):
    @job_ns.doc('submit_dataproc_job')
    @job_ns.expect(job_model)
    def post(self):
        """Submit Dataproc Pyspark Job
        
        example:
            cluster_name: tomato-cluster
            job_name: tomato-attack
            main_python_file_uri: gs://yt-demo-dev-dataproc-app/spark/simple_spark_job3.py
            parameters: "iam source bucket", "iam target bucket", "iam source format"
        """
        header = ClusterOperator.submit_job(job_ns.payload)
        body = header[1]
        return body


# "WorkflowTemplate" resource RESTful API definition
# ============================================
@wf_temp_ns.route('/workflowtemplate')
class WorkflowTemplate(Resource):
    """Select an existing dataproc workflow template to execute a specific pyspark jobs.    
    example: yt-demo-dev-workflow-template
    """
    @wf_temp_ns.doc('instantiate_wf_templ')
    @wf_temp_ns.expect(wf_temp_model)
    @wf_temp_ns.marshal_with(wf_temp_model, code=201)
    def post(self):
        """Instantiate a Workflow template """
        workflow_template = WorkflowTemplateOperator.start(wf_temp_ns.payload)
        return workflow_template, 201
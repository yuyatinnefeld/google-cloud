from flask import Flask
from flask_restful import Resource, Api, reqparse
from google.cloud import bigquery


app = Flask(__name__)
api = Api(app)

class PrintUserCount(Resource):
    def get(self):
        client = bigquery.Client() 
        print("Last 10 jobs:")
        results = []

        for job in client.list_jobs(max_results=10):
            result = {'Job ID': job.job_id, 'Job Type': job.job_type, 'Labels':job.labels, 'State':job.state, 'User':job.user_email}
            results.append(result)

        return results

api.add_resource(PrintUserCount, '/')


if __name__ == '__main__':
    app.run(debug=True, port = 1123)






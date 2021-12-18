from typing import Tuple, Optional

import gcp
from logger import logger


class WorkflowTemplateOperator(object):
    def start(self, input_data:str) -> Optional[dict]:
        """Select a workflow template and start the job"""
        workflow_template = input_data
        template_name = workflow_template['template_name']
        
        parameters = workflow_template['parameters']
        if (parameters):
            #TODO: parameters read 
            print("do with arg")
            print(parameters)
        else:
            print("do without args")

        #op = gcp.start_workflow_template(template_name)
        #return workflow_template


    def start_with_args(self, input_data:str) -> Optional[dict]:
        """Select a workflow template and start the job with args"""
        workflow_template = input_data
        template_name = workflow_template['template_name']
        source_bucket = workflow_template['source_bucket']
        source_format = workflow_template['source_format']
        destination = workflow_template['destination']
        destination_name = workflow_template['destination_name']
        opt_params = workflow_template['opt_params']

        parameters = {
            "SOURCE_BUCKET": source_bucket,
            "SOURCE_FORMAT": source_format,
            "DESTINATION": destination,
            "DESTINATION_NAME": destination_name,
            "OPT_PARAMS": opt_params,
        }

        op = gcp.start_workflow_template_with_args(template_name, parameters)
        return workflow_template
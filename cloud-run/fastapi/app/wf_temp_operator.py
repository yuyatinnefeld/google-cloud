from typing import Dict, List, Optional

from app.gcp import start_workflow_template
from app.logger import logger


class WorkflowTemplateOperator(object):
    def start(self, wf_temp_name: str) -> None:
        """Select a workflow template and start the job

        Args:
            wf_temp_name (str): The name of workflow template

        Returns:
            None
        """
        
        try:
            op = start_workflow_template(wf_temp_name)
            logger.info("workflow template: %s is running", wf_temp_name)

        except Exception as e:
            logger.exception(e)
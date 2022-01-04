import yaml

from typing import Optional, Dict, Any


def read_yaml_config(path: str) -> Dict[str, Any]:
    """Read a YAML file and return a dictionary"""
    with open(path, "r") as f:
        try:
            config = yaml.safe_load(f)
        except yaml.YAMLError as exc:
            print(exc)
    return config


config = read_yaml_config("./resources/app_conf.yaml")

project_id = config['project_id']
region = config['region']
config_bucket = config['dataproc_staging_bucket']
temp_bucket = config['dataproc_temp_bucket']
dataproc_api_endpoint=config['dataproc_api_endpoint']

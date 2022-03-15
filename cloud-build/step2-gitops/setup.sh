# Managing infrastructure as code with Terraform, Cloud Build, and GitOps 

# source: https://cloud.google.com/architecture/managing-infrastructure-as-code


########### setup environment ###########
export PROJECT_ID=$(gcloud config get-value project)
gcloud config set project $PROJECT_ID

# enable API
gcloud services enable cloudbuild.googleapis.com compute.googleapis.com

# git config setup
git config --global user.email "yuya@yuyatinnefeld.com"
git config --global user.name "yuyatinnefeld"

# github setup
#  fork
https://github.com/GoogleCloudPlatform/solutions-terraform-cloudbuild-gitops

# clone
cd ~
git clone https://github.com/yuyatinnefeld/solutions-terraform-cloudbuild-gitops.git
cd ~/solutions-terraform-cloudbuild-gitops


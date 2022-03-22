# User Authentication: Identity-Aware Proxy
# Source: https://codelabs.developers.google.com/codelabs/user-auth-with-iap#0
# Source2: https://www.cloudskillsboost.google/focuses/5562?parent=catalog

# Overview
- GAE app using Python (Flask)
- enable and disable IAP
- user identity from IAP

######### setup environment ##########

# download the repo
git clone https://github.com/googlecodelabs/user-authentication-with-iap.git
cd user-authentication-with-iap

######### project 1 hello world app ##########

cd 1-HelloWorld
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# local test
python main.py

# deploy
gcloud app deploy
gcloud app browse

# enable identity-aware proxy api + consent screen

1. security > identity-aware-proxy
2. click GO TO IDENTITY-AWARE PROXY
3. click CONFIGURE CONSENT SCREEN
4. select internal
5. OAuth consent screen (e.g. PROJECT_ID=yuyatinnefeld-dev)
- application home page: https://$PROJECT_ID.ew.r.appspot.com
- privacy: https://$PROJECT_ID.ew.r.appspot.com/privacy
- authorized domains: $PROJECT_ID.ew.r.appspot.com

# disable GAE flex api
gcloud services disable appengineflex.googleapis.com

# turn on the iap
1. security > identity-aware-proxy
2. click TURN ON
3. open the website > You dont have access

# add users 
IAP > App Engine app > click check box > Add Principal
- Email: your email
- Role: IAP-secured web app User

# test
gcloud app browse

https://$PROJECT_ID.ew.r.appspot.com/_gcp_iap/clear_login_cookie.

######### project 2 hello user app ##########

# switch the project
cd 2-HelloUser

# deploy
gcloud app deploy

# test
gcloud app browse

# turn off IAP
Security > Identity-Aware Proxy > TURN OFF

# retry
gcloud app browse
PROJECT_ID=yuyatinnefeld-dev
curl -X GET https://$PROJECT_ID.ew.r.appspot.com -H "X-Goog-Authenticated-User-Email: totally fake email"


######### project 3 hello verified user app (for the case to turn off the IAP) ##########

# switch the project
cd 3-HelloVerifiedUser

# deploy the service
gcloud app deploy

# verify
gcloud app browse
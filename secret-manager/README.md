# Secret Manager (Python)

1. Use VC Codoe + Cloud Code

2. Open Secret Manager (Cloud Code)

3. Create 2 Secrets
- Name: PROJECT_ID, Value: yt-demo-dev
- Name: PROJECT_USER, Value: yuya

4. Enable Secret Manager API

5. Create a python module

6. Install a package
```bash
pip install google-cloud-secret-manager
```

7. Setup the environment variable
```bash
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/conf/yt-demo-dev-sa.json"
```

8. Test run
```bash
python secrets_call.py
```
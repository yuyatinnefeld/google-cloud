# create a few todos

curl http://127.0.0.1:5000/todo1 -d "data=create dataproc cluster1" -X PUT
curl http://127.0.0.1:5000/todo2 -d "data=create a dataproc job" -X PUT
curl http://127.0.0.1:5000/todo3 -d "data=submit the dataproc job" -X PUT

# read the todos

curl http://localhost:5000/todo1
curl http://localhost:5000/todo2
curl http://localhost:5000/todo3
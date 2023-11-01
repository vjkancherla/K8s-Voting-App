kubectl port-forward -n vote service/vote-service 5000:5000 &

kubectl port-forward -n vote service/result 5001:5001 &
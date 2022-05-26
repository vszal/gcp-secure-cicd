# Cleanup script to delete the clusters created by the gke-init.sh script
# bail if PROJECT_ID is not set
if [[ -z "${PROJECT_ID}" ]]; then
  echo "The value of PROJECT_ID is not set. Be sure to run export PROJECT_ID=YOUR-PROJECT first"
  return
fi
# sets the current project for gcloud
gcloud config set project $PROJECT_ID
# Test cluster
echo "Deleting test cluster..."
gcloud container clusters delete test-sec --region "us-central1" --async
# Staging cluster 
echo "Deleting prod cluster..."
gcloud container clusters delete prod-sec --region "us-central1" --async
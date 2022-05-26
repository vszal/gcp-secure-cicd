# Creates 2 GKE clusters
# bail if PROJECT_ID is not set
if [[ -z "${PROJECT_ID}" ]]; then
  echo "The value of PROJECT_ID is not set. Be sure to run \"export PROJECT_ID=YOUR-PROJECT\" first"
  return
fi

# Test cluster
echo "creating test-sec..."
gcloud beta container --project "$PROJECT_ID" clusters create "test-sec" \
--region "us-central1" --no-enable-basic-auth --cluster-version "1.22.7-gke.1500" \
--release-channel "rapid" --machine-type "e2-medium" --image-type "COS_CONTAINERD" \
--disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true \
--scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
--max-pods-per-node "110" --num-nodes "2" --logging=SYSTEM,WORKLOAD \
--monitoring=SYSTEM --enable-ip-alias --network "projects/$PROJECT_ID/global/networks/default" \
--subnetwork "projects/$PROJECT_ID/regions/us-central1/subnetworks/default" \
--no-enable-intra-node-visibility --default-max-pods-per-node "110" --no-enable-master-authorized-networks \
--addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver \
--enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 \
--enable-shielded-nodes --enable-binauthz --async

# Test cluster
echo "creating prod-sec..."
gcloud beta container --project "$PROJECT_ID" clusters create "prod-sec" \
--region "us-central1" --no-enable-basic-auth --cluster-version "1.22.7-gke.1500" \
--release-channel "rapid" --machine-type "e2-medium" --image-type "COS_CONTAINERD" \
--disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true \
--scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
--max-pods-per-node "110" --num-nodes "2" --logging=SYSTEM,WORKLOAD \
--monitoring=SYSTEM --enable-ip-alias --network "projects/$PROJECT_ID/global/networks/default" \
--subnetwork "projects/$PROJECT_ID/regions/us-central1/subnetworks/default" \
--no-enable-intra-node-visibility --default-max-pods-per-node "110" --no-enable-master-authorized-networks \
--addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver \
--enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 \
--enable-shielded-nodes --enable-binauthz --async
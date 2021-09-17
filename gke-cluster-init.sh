# Creates 3 GKE autopilot clusters
# Test cluster
echo "creating testcluster..."
gcloud beta container --project "vsz-cd-preview" clusters create-auto "testcluster" \
--region "us-central1" --release-channel "regular" --network "projects/vsz-cd-preview/global/networks/default" \
--subnetwork "projects/vsz-cd-preview/regions/us-central1/subnetworks/default" \
--cluster-ipv4-cidr "/17" --services-ipv4-cidr "/22"
# Staging cluster
echo "creating stagingcluster..."
gcloud beta container --project "vsz-cd-preview" clusters create-auto "stagingcluster" \
--region "us-central1" --release-channel "regular" --network "projects/vsz-cd-preview/global/networks/default" \
--subnetwork "projects/vsz-cd-preview/regions/us-central1/subnetworks/default" \
--cluster-ipv4-cidr "/17" --services-ipv4-cidr "/22"
# Prod cluster
echo "creating prodcluster..."
gcloud beta container --project "vsz-cd-preview" clusters create-auto "stagingcluster" \
--region "us-central1" --release-channel "regular" --network "projects/vsz-cd-preview/global/networks/default" \
--subnetwork "projects/vsz-cd-preview/regions/us-central1/subnetworks/default" \
--cluster-ipv4-cidr "/17" --services-ipv4-cidr "/22"
echo "Done creating clusters!"
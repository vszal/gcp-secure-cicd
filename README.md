# Google Cloud CI/CD End-to-End Demo
The purpose of this repository is to showcase Google Cloud DevOps products in an end-to-end CI/CD workflow. Google Cloud Deploy, Cloud Build, and Artifact Registry are featured.

## Create a repo
This demo relies on you making git check-ins to simulate a developer workflow. Fork this repo, or otherwise copy it into your own Github repo.

## Customize Cloud Deploy yaml

1. In `clouddeploy.yaml`, replace `project-id-here` with your actual project for each of the three targets.

## Bootstrap
Bootstrap scripts are in the `bootstrap` folder.

The `init.sh` script is provided to bootstrap much of the configuration setup. You'll still need to do some steps manually after this script runs though.

1. Replace project-id-here with your Google Cloud project-id on line 3.
2. run `. ./init.sh`
3. Verify that the Google Cloud Deploy pipeline was created in [Google Cloud Deploy UI](https://console.google.com/deploy/delivery-pipelines)
4. Setup a Cloud Build trigger for your repo
  * Navigate to [Cloud Build triggers page](https://console.google.com/cloud-build/triggers)
  * Follow the [docs](https://cloud.google.com/build/docs/automating-builds/build-repos-from-github) and create a Github App connected repo and trigger.

## Create GKE clusters
You'll need GKE clusters to deploy out to as part of the demo. This repo refers to three clusters:
* testcluster
* stagingcluster
* productcluster

If you have/want different cluster names update cluster definitions in the gke-cluster-init.sh bash script and in clouddeploy.yaml

To create the clusters, edit `bootstrap/gke-cluster-init.sh`:
1. Replace `project-id-here` with your project-id on line 3.
2. Run `. .bootstrap/gke-cluster-init.sh`

## IAM and service account setup
You must give Cloud Build explicit permission to trigger a Cloud Deploy release.
1. Read the [docs](https://cloud.google.com/deploy/docs/integrating)
2. Navigate to IAM and locate your Cloud Build service account
3. Add these two roles
  * Cloud Deploy Releaser
  * Service Account User

## Demo
The demo is very simple at this stage.
1. User commits a change the main branch of the repo
2. Cloud Build is automatically triggered, which:
  * builds and pushes impages to Artifact Registry
  * creates a Cloud Deploy release in the pipeline
3. User then navigates to Cloud Deploy UI and shows promotion events:
  * test cluster to staging clusters
  * staging cluster to product cluster, with approval gate

## Tear down
To remove the three running GKE clusters, edit `bootstrap/gke-cluster-delete.sh`:
1. Replace `project-id-here` with your project-id on line 3.
2. Run `. .bootstrap/gke-cluster-delete.sh`

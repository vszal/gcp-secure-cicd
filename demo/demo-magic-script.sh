#!/bin/bash

########################
# include the magic
# https://github.com/paxtonhare/demo-magic
########################
. ../scripts/demo-magic.sh

# demo settings
TYPE_SPEED=30
DEMO_PROMPT="${BLUE}[demo] $ "
DEMO_CMD_COLOR=$BLACK

#hide the evidence
clear

# EDIT THESE VALUES
# env variables
export PROJECT_ID=YOUR-PROJECT-ID
export CLUSTER_CONTEXT=gke_project-name_zone-region_test-cluster
export WORKING_DIR=/path/to/your/repo

# Change directories to the working dir of the repo
cd $WORKING_DIR

# Kritis policy

pe "cat policy/kritis/vulnz-signing-policy.yaml"

# Kritis signer in CI: vulnerable images fail CI

pe "ls -l samples/"

pe "cp samples/bad.Dockerfile app/Dockerfile"

pe "head -n 15 app/Dockerfile"

pe "clear"

pe "gcloud builds submit --config=cloudbuild-ci-only.yaml"

#Kritis signer in CI: passing image
pe "clear"

pe "cp samples/good.Dockerfile app/Dockerfile"

pe "head -n 15 app/Dockerfile"

pe "clear"

pe "gcloud builds submit --config=cloudbuild-ci-only.yaml"

## BinAuthz / policy demo

# Set kubernetes context
pe "clear"

pe "kubectx ${CLUSTER_CONTEXT}"

# Type of policies

pe "ls -l policy/binauthz"

# Allowlist policy demo: random images will be denied admission

pe "cat policy/binauthz/allowlist-policy.yaml"

pe "gcloud container binauthz policy import policy/binauthz/allowlist-policy.yaml"

pe "kubectl create deployment nginx --image=nginx@sha256:1761fb5661e4d77e107427d8012ad3a5955007d997e0f4a3d41acc9ff20467c7 && \
kubectl rollout status deployment nginx"

# Attestation-based policy demo: 
pe "clear"

pe "cat policy/binauthz/attestor-policy.yaml"

pe "gcloud container binauthz policy import policy/binauthz/attestor-policy.yaml"

pe "gcloud container binauthz attestations list --project="${PROJECT_ID}" --attestor="projects/${PROJECT_ID}/attestors/built-by-cloud-build" --sort-by=createTime"

pe "gcloud container binauthz attestations list --project="${PROJECT_ID}" --attestor="projects/${PROJECT_ID}/attestors/build-vuln-check" --sort-by=createTime"

pe "clear"
# enter the provenance command this next prompt
cmd

pe ""
pe ""
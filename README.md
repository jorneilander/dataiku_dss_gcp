# Dataiku - DSS cluster in GCP using Terraform and Ansible

This repository spins up a customized Linux based DSS instance in GCP, including a Terraform managed GKE-cluster for workloads.
Additionally, a global HTTPS-Proxy will be spun-up with a managed certificate for `dataiku.azorion.com`.
The cluster itself will be (mostly) pre-configured for connecting to GCS and GKE, including Spark.

Two users will be added to both the VM running the DSS instance, as well as in the DSS instance itself: `jane.example` and `bob.example`.
This allows for 1:1-mapping of users for the `User Isolation Framework`.

Check the `README.md` in both [/terraform](./terraform/) and [/ansible](./ansible/) for more information on how this setup is created.

The example project in [DSS - Projects](./DSS%20-%20Projects/) should showcase the following scenarios

- Running Python using `UIF`
- Running containerized Spark using secured settings (e.g., dynamic service accounts, seperate namespaces)
- Storing data on GCS
- Running a Jupyter notebook using a kernel in a containerized environment

## Requirements

The following applications are required to execute and/or debug all the elements:

- `terraform`
- `ansible`
- `direnv`
- `gcloud`
- `helm`
- `kubectl`

## How to use - tl;dr

- Place GCP credentials .json-file at `terraform/gcp-credentials.json`
- Run `terraform apply` in `terraform/cluster`
- Copy `public_ip` from Terraform's output to `ansible/inventory/hosts.yaml` at `all.hosts.dss.ansible_host`
- Run `ansible-playbook site.yaml`
- Visit [dataiku.azorion.com](https://dataiku.azorion.com) and login with default credentials for the `admin` user
- In `Administration -> Settings -> Containerized execution` click `[PUSH BASE IMAGES]` and `[TEST]` afterwards to see if it works
- In `Administration -> Settings -> Spark` click `[PUSH BASE IMAGES]` at the bottom
- In `Administration -> Code Envs` create a new Python environment by clicking `[NEW PYTHON ENV]` based on Python 3.6
- Under `Packages to install` add `watermark` and `pandas_profiling`
- Logout as `admin` and login as `jane.example`
- Create a new project and import `BEER.zip`
- Run all flows

## Design decisions

- EKS cluster managed by Terraform  
  This allows for easy up- and downscaling via Terraform, and prevents useless use of resources for this example deployment.
  It also prevented to automate the installation and configuration of the `EKS cluster` plugin.
- Global GCP HTTPS Proxy  
  A `global` HTTPS Proxy allows for a managed certificate for the domain to be used.
- Idempotent Ansible role playbook (under certain conditions)  
  The Ansible playbook in `site.yaml` is idempotent up to a point.
  DSS has a tendency to not format the JSON configuration(s) as Ansible's `to_nice_json`, so any change by DSS to these files will create a change during a re-run of the playbook.
  The changes by Ansible to the files should not be destructive, so any changes by DSS should persist.
- Using `direnv` to set `${TF_VAR_public_access_cidrs}`  
  In `.envrc` the `${TF_VAR_public_access_cidrs}` is set with the user's public IP-address.
  Terraform uses this variable to set the `public_access_cidrs` variable which is used for to allow specific traffic to the DSS virtual machine.
  This prevents direct access to DSS virtual machine to a greater audience.

## Things to note

- CentOS 8.5 `which2.sh` bug breaks Jupyter notebooks in a containerized environment
  Somehow CentOS 8.5 adds `which2.sh` to `/etc/profile.d/` which adds an environment functions called `BASH_FUNC_WHICH%%` which somehow winds up as a string literal in container/pod names of Jupyter kernels.
  Since it doesn't adhere to the allowed character set, kernel pods won't start.

# Terraform - Cluster

The Terraform module found in `terraform/cluster` does the following.

## Variables

| name                  | type           | default | description                                                                                                     |
| --------------------- | -------------- | ------- | --------------------------------------------------------------------------------------------------------------- |
| `public_access_cidrs` | `list(string)` | ''      | List of public IP-addresses allowed direct access to the DSS instance virtual machine via port `22` and `10000` |

## Outputs

| name                   | type     | description                                             |
| ---------------------- | -------- | ------------------------------------------------------- |
| `public_ip`            | `string` | Public IP-address of DSS instance virtual machine       |
| `dss_internal_ip`      | `string` | Internal IP-address of the DSS instance virtual machine |
| `image_registry_url`   | `string` | URL of the created GCP image registry                   |
| `gke_dss_cluster_name` | `string` | GKE cluster name                                        |
| `gcp_zone`             | `string` | GCP Zone                                                |
| `https_proxy_ip`       | `string` | Public IP-address of the HTTPS-proxy                    |

## Files

### providers.tf

- Initialize Terraform providers
- Permanently enable several GCP API's required for running the module

### locals.tf

- Set several local variables used throughout the module

### ssh_access.tf

- Create an SSH keypair and place it on the local filesystem, used by the virtual machine instance for user access
- Create a data variable containing a reference to the GCP user to configure SSH access to the virtual machine using the generated SSH keypair

### network.tf

- Create a VPC
- Reserve an external IP-address for the DSS VM
- Create a firewall rule to allow external SSH access from any IP in the environment variable: `public_access_cidrs`
- Create a firewall rule to allow TCP traffic to port `10000` from any IP in the environment variable: `public_access_cidrs`
- Create a firewall rule to allow any traffic inside the VPC (`10.0.0.0/8`)
- Create a firewall rule to allow TCP traffic to ports `443` and `10000` for traffic from the HTTPS Proxy CIDRS

### iam_sa_dssuser.tf

- Create a service account called `dssuser` which will be the primary service account for the installation
- Make `dssuser` member of several roles to allow access to GCP's API

### iam_sa_dssgcs.tf

- Create a service account called `dssgcs`
- Make `dssuser` member of `roles/storage.admin` to allow access to GCP's GCS API used by DSS to connect to GCS
- Create an account key required for configuring DSS's GCS connection

### gce.tf

- Create storage disk of 100GB
- Set the default compute service account to `dssuser`
- Create a virtual machine based on `almalinux` linked to:
  - The 100GB storage
  - The generated SSH-keypair linked to the user for remote access from `ssh_access.tf`
  - The public IP-address reserved in `network.tf`
  - The `dssuser` service account allowed access to the `cloud-platform` scope
- Create a compute instance group containing the DSS virtual machine
- Create a compute backend service linked to both the health check as the instance group

### gke.tf

- Create a GCS storage bucked to be used by both the image registry as DSS's GCS connection
- Create container registry
- Create a container cluster and delete its default node pool
- Create a container node pool linked to the GKE cluster

### outputs.tf

- Create several output variable to be used by both the user for access as well as Ansible for use in the playbook

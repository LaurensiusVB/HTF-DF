# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "299a3aefaa5b4b5d95b7e7b04745e15f/1014222"
resource "ovh_cloud_project_user" "attacker_debug_admin" {
  description = "debug-admin"
  openstack_rc = {
    OS_AUTH_URL    = "https://auth.cloud.ovh.net/v3"
    OS_TENANT_ID   = "299a3aefaa5b4b5d95b7e7b04745e15f"
    OS_TENANT_NAME = "5554752731516767"
    OS_USERNAME    = "user"
  }
  password_reset = null
  role_name      = null
  role_names     = null
  service_name   = "299a3aefaa5b4b5d95b7e7b04745e15f"
}

# __generated__ by Terraform from "299a3aefaa5b4b5d95b7e7b04745e15f/1013903/52f5b33434154f89875b775143b024a8"
resource "ovh_cloud_project_user_s3_credential" "attacker_stolen_key" {
  service_name = "299a3aefaa5b4b5d95b7e7b04745e15f"
  user_id      = "1013903"
}

# __generated__ by Terraform from "299a3aefaa5b4b5d95b7e7b04745e15f/e087d842-ef48-41b3-98b5-fb7d15403d8e/14b40e70-bb51-4b36-8fc6-72e69614d7bb"
resource "ovh_cloud_project_kube_nodepool" "ghost_hotfix_pool" {
  anti_affinity                                = false
  autoscale                                    = false
  autoscaling_scale_down_unneeded_time_seconds = 600
  autoscaling_scale_down_unready_time_seconds  = 1200
  autoscaling_scale_down_utilization_threshold = 0.5
  availability_zones                           = []
  desired_nodes                                = 1
  flavor_name                                  = "b3-8"
  kube_id                                      = "e087d842-ef48-41b3-98b5-fb7d15403d8e"
  max_nodes                                    = 1
  min_nodes                                    = 1
  monthly_billed                               = false
  name                                         = "hotfix-pool"
  service_name                                 = "299a3aefaa5b4b5d95b7e7b04745e15f"
}

# The Kube API's IP allow-list, owned by Terraform so manual changes are reverted.
# It was set by hand (twice) to 198.51.100.0/24, a documentation-only range that
# locks everyone out. 0.0.0.0/0 = no restriction (the pipeline's runners need access).
import {
  to = ovh_cloud_project_kube_iprestrictions.api
  id = "299a3aefaa5b4b5d95b7e7b04745e15f/e087d842-ef48-41b3-98b5-fb7d15403d8e"
}

resource "ovh_cloud_project_kube_iprestrictions" "api" {
  service_name = var.service_name
  kube_id      = ovh_cloud_project_kube.this.id
  ips          = ["0.0.0.0/0"]
}

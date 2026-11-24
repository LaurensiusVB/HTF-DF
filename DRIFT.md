# Drift report: Level 1

Found with `terraform plan` (what Terraform tracks) and `ghost-hunt.sh` (OVH API,
which also catches what Terraform can't see). Every decision is applied through
Git and the pipeline; the hourly drift check re-applies it if it changes again.

| # | Resource | Code | Live (manual) | Decision | Why |
|---|---|---|---|---|---|
| 1 | Kube `update_policy` | MINIMAL_DOWNTIME | NEVER_UPDATE | **Revert** | Blocks security patches |
| 2 | Node pool `min_nodes` | 1 | 2 | **Keep → code updated** | `anti_affinity` is on; 2 nodes = workloads survive a node loss |
| 3 | Node pool `max_nodes` | 3 | 5 | **Revert** | No load justifies it; cost |
| 4 | Node pool labels | managed-by=terraform | managed-by=console, owner=night-shift | **Revert** | Hides who owns the resource |
| 5 | Gateway model | S | M | **Revert** | S is enough for this traffic; cost |
| 6 | Kube API IP allow-list | none | 198.51.100.0/24 (came back twice) | **Revert, now owned by Terraform** | Documentation-only range: locked everyone out |
| 7 | Bucket `scrolls` encryption | AES256 | plaintext | **Revert** | Data at rest must be encrypted |
| 8 | Bucket `scrolls` versioning | ENABLED | suspended | **Revert** | No recovery from deletes |
| 9 | `scrolls-app` S3 policy | 1 bucket, RW | `s3:*` on `*` ("TempFixAllAccess") | **Revert** | Could read the Terraform state bucket (all secrets) |
| 10 | Extra S3 key on `scrolls-app` | 1 key | 2 keys | **Remove + rotate** | Unknown key = compromised credential (Level 2) |
| 11 | User `debug-admin` (administrator) | absent | present | **Remove** | Admin backdoor, ghost resource |
| 12 | Node pool `hotfix-pool` | absent | present | **Remove** | Ghost resource; the autoscaler covers capacity |

Note: #7–#9 do not show in `terraform plan`. The OVH provider doesn't read them
back, so we verify with the API and force them with `-replace` in the pipeline.

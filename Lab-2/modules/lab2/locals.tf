locals {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name

  public_security_list_name  = "${var.environment}-public-security-list"
  private_security_list_name = "${var.environment}-private-security-list"
  public_route_table_name    = "${var.environment}-public-route-table"
  private_route_table_name   = "${var.environment}-private-route-table"
  internet_gateway_name      = "${var.environment}-internet-gateway"
  nat_gateway_name           = "${var.environment}-nat-gateway"

  app_port      = 8080
  listener_port = 80
  nfs_port      = 2049
  export_path   = "/${var.environment}-app"
  mount_point   = "/mnt/fss"
  mount_options = "vers=4.1,proto=tcp"

  load_balancer_name = "${var.environment}-alb"
  backend_set_name   = "${var.environment}-backend-set"
  listener_name      = "${var.environment}-listener"

  export_set_name   = "${var.environment}-export-set"
  file_system_name  = "${var.environment}-file-system"
  mount_target_name = "${var.environment}-mount-target"

  private_instance_cloud_init = <<-EOT
    #cloud-config
    package_update: true
    packages:
      - nfs-common
      - python3
    write_files:
      - path: /usr/local/bin/bootstrap-app.sh
        permissions: "0755"
        content: |
          #!/bin/bash
          set -euxo pipefail

          mount_point="${local.mount_point}"
          export_path="${local.export_path}"
          mount_target_ip="${oci_file_storage_mount_target.fss_mount_target.private_ip_ids[0]}"

          mkdir -p "$${mount_point}"

          for attempt in $(seq 1 30); do
            if mount -t nfs -o ${local.mount_options} "$${mount_target_ip}:$${export_path}" "$${mount_point}"; then
              break
            fi
            sleep 10
          done

          mkdir -p "$${mount_point}/app"

          cat > "$${mount_point}/app/index.html" <<'EOF'
          <html>
            <head>
              <title>Lab 2 Application</title>
            </head>
            <body>
              <h1>Lab 2 private application</h1>
              <p>The application files are stored on OCI File Storage Service.</p>
            </body>
          </html>
          EOF

          nohup python3 -m http.server ${local.app_port} --directory "$${mount_point}/app" >/var/log/lab2-app.log 2>&1 &
    runcmd:
      - [bash, /usr/local/bin/bootstrap-app.sh]
  EOT
}
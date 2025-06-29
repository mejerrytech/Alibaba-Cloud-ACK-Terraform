# ------------------------------------------------------------
# Namespace
# ------------------------------------------------------------
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

# ------------------------------------------------------------
# Prometheus ConfigMap
# ------------------------------------------------------------
resource "kubernetes_config_map" "prometheus_config" {
  metadata {
    name      = "prometheus-config"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  data = {
    "prometheus.yml" = templatefile("${path.module}/manifests/prometheus_config.yaml.tpl", {})
  }
}

# ------------------------------------------------------------
# Prometheus Deployment
# ------------------------------------------------------------
resource "kubernetes_deployment" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    labels = {
      app = "prometheus"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "prometheus"
      }
    }

    template {
      metadata {
        labels = {
          app = "prometheus"
        }
      }

      spec {
        container {
          name  = "prometheus"
          image = "prom/prometheus:v2.46.0"

          args = ["--config.file=/etc/prometheus/prometheus.yml"]

          port {
            container_port = 9090
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/prometheus"
          }
        }

        volume {
          name = "config-volume"

          config_map {
            name = kubernetes_config_map.prometheus_config.metadata[0].name
          }
        }
      }
    }
  }
}

# ------------------------------------------------------------
# Prometheus Service (INTERNAL)
# ------------------------------------------------------------
resource "kubernetes_service" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  spec {
    selector = {
      app = "prometheus"
    }

    port {
      port        = 9090
      target_port = 9090
    }

    type = "ClusterIP"  # 🔐 Internal only
  }
}

# ------------------------------------------------------------
# Loki ConfigMap
# ------------------------------------------------------------
resource "kubernetes_config_map" "loki_config" {
  metadata {
    name      = "loki-config"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  data = {
    "local-config.yaml" = templatefile("${path.module}/manifests/loki_config.yaml.tpl", {})
  }
}

# ------------------------------------------------------------
# Loki Deployment
# ------------------------------------------------------------
resource "kubernetes_deployment" "loki" {
  metadata {
    name      = "loki"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    labels = {
      app = "loki"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "loki"
      }
    }

    template {
      metadata {
        labels = {
          app = "loki"
        }
      }

      spec {
        container {
          name  = "loki"
          image = "grafana/loki:2.8.2"

          args = ["-config.file=/etc/loki/local-config.yaml"]

          port {
            container_port = 3100
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/loki"
          }

          volume_mount {
            name       = "loki-data"
            mount_path = "/tmp/loki"
          }

          # Mount new writable WAL volume here
          volume_mount {
            name       = "wal"
            mount_path = "/wal"
          }
        }

        volume {
          name = "config-volume"

          config_map {
            name = kubernetes_config_map.loki_config.metadata[0].name
          }
        }

        volume {
          name = "loki-data"

          empty_dir {}
        }

        # Add emptyDir for wal volume
        volume {
          name = "wal"

          empty_dir {}
        }
      }
    }
  }
}
# ------------------------------------------------------------
# Loki Service (INTERNAL)
# ------------------------------------------------------------
resource "kubernetes_service" "loki" {
  metadata {
    name      = "loki"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  spec {
    selector = {
      app = "loki"
    }

    port {
      port        = 3100
      target_port = 3100
    }

    type = "ClusterIP"
  }
}

# ------------------------------------------------------------
# Grafana Deployment
# ------------------------------------------------------------
resource "kubernetes_deployment" "grafana" {
  metadata {
    name      = "grafana"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    labels = {
      app = "grafana"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "grafana"
      }
    }

    template {
      metadata {
        labels = {
          app = "grafana"
        }
      }

      spec {
        container {
          name  = "grafana"
          image = "grafana/grafana:9.5.2"

          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

# ------------------------------------------------------------
# Grafana Service (PUBLIC)
# ------------------------------------------------------------
resource "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  spec {
    selector = {
      app = "grafana"
    }

    port {
      port        = 3000
      target_port = 3000
    }

    type = "LoadBalancer"  # ✅ Exposed externally
  }
}

# ------------------------------------------------------------
# Promtail ConfigMap
# ------------------------------------------------------------
resource "kubernetes_config_map" "promtail_config" {
  metadata {
    name      = "promtail-config"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  data = {
    "promtail.yaml" = <<EOF
server:
  http_listen_port: 9080
clients:
  - url: http://loki.monitoring.svc.cluster.local:3100/loki/api/v1/push
positions:
  filename: /tmp/positions.yaml
scrape_configs:
  - job_name: kubernetes-pods
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_label_app]
        target_label: app
EOF
  }
}

# ------------------------------------------------------------
# Promtail DaemonSet
# ------------------------------------------------------------
resource "kubernetes_daemonset" "promtail" {
  metadata {
    name      = "promtail"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    labels = {
      app = "promtail"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "promtail"
      }
    }

    template {
      metadata {
        labels = {
          app = "promtail"
        }
      }

      spec {
        container {
          name  = "promtail"
          image = "grafana/promtail:2.8.2"
          args  = ["-config.file=/etc/promtail/promtail.yaml"]

          volume_mount {
            name       = "config"
            mount_path = "/etc/promtail"
          }

          volume_mount {
            name       = "varlog"
            mount_path = "/var/log"
          }

          volume_mount {
            name       = "dockerlogs"
            mount_path = "/var/lib/docker/containers"
            read_only  = true
          }
        }

        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map.promtail_config.metadata[0].name
          }
        }

        volume {
          name = "varlog"
          host_path {
            path = "/var/log"
          }
        }

        volume {
          name = "dockerlogs"
          host_path {
            path = "/var/lib/docker/containers"
          }
        }
      }
    }
  }
}
resource "kubernetes_daemonset" "node_exporter" {
  metadata {
    name      = "node-exporter"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    labels = {
      app = "node-exporter"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "node-exporter"
      }
    }

    template {
      metadata {
        labels = {
          app = "node-exporter"
        }
      }

      spec {
        host_network = true  # Allows scraping on host IP

        container {
          name  = "node-exporter"
          image = "prom/node-exporter:v1.7.0"
          args  = ["--path.rootfs=/host"]

          port {
            container_port = 9100
            host_port      = 9100
          }

          volume_mount {
            name       = "rootfs"
            mount_path = "/host"
            read_only  = true
          }
        }

        volume {
          name = "rootfs"
          host_path {
            path = "/"
          }
        }
      }
    }
  }
}
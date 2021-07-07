variable deploy_name {}
variable deploy_label {}
variable pod_replicas {type = number}
variable pod_label {}
variable pod_img {}
resource "kubernetes_persistent_volume_claim" "wp_pvc" {
  metadata {
    name = "wp-pvc"
    labels = {
      app = "wp-pvc"
    }
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}
resource "kubernetes_deployment" "wp_deploy" {
  depends_on = [kubernetes_persistent_volume_claim.wp_pvc,]
  metadata {
    name = var.deploy_name
    labels = {
      app = var.deploy_label
    }
  }
  
  spec {
    
    # Defining no. of replicas
    replicas = var.pod_replicas
    
    selector {
      match_labels = {
        app = var.pod_label
      }
    }
    
    template {
      
      metadata {
        labels = {
          app = var.pod_label
        }
      }
      
      spec {
        volume {
          name = "wp-pv"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.wp_pvc.metadata.0.name
          }
        }
        
        container {
          # Defining the image 
          image = var.pod_img
          name = "wp-container"
          port {
            container_port = 80
          }
          volume_mount {
            name       = "wp-pv"
            mount_path = "/var/www/html"
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "wp_svc" {
  depends_on = [kubernetes_deployment.wp_deploy]
  metadata {
    name = "wp-svc"
    labels = {
      app = var.pod_label
    }
  }
  spec {
    selector = {
      app = var.pod_label
    }
    port {
      port        = 8080
      target_port = 80
      node_port   = 30303
    }
    type = "NodePort"
  }
}

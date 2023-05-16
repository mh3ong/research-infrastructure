resource "null_resource" "kubectl" {
  depends_on = [module.eks.eks_managed_node_groups]
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.cluster_name} --profile default"
  }
}

resource "helm_release" "nginx-ingress-controller" {
  depends_on = [null_resource.kubectl]
  name       = "nginx-ingress-controller"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  # provisioner "local-exec" {
  #   when    = destroy
  #   command = "helm delete nginx-ingress-controller"
  # }
}

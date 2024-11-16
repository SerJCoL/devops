terraform {
  required_version = ">= 1.8"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.128.0"
    }
  }
}

provider "yandex" {
  token     = var.yandex_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}

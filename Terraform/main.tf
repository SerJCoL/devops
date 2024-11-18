resource "yandex_compute_instance" "srv" {
  # Configuration srv
  name = "srv"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd874d4jo8jbroqs6d7i"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.srv_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "ubuntu"
    private_key = file(var.private_key_path)
  }

  scheduling_policy {
    preemptible = true
  }
  
  provisioner "file" {
    source      = "setup.yml"
    destination = "/home/ubuntu/setup.yml"
  }
}

resource "yandex_vpc_network" "srv_network" {
  name = "srv-network"
}

resource "yandex_vpc_subnet" "srv_subnet" {
  name           = "srv-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.srv_network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "srv_ip" {
  value = yandex_compute_instance.srv.network_interface.0.ip_address
}

resource "yandex_compute_instance" "master" {
  # Конфигурация master
  name = "master"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd874d4jo8jbroqs6d7i"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.srv_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "ubuntu"
    private_key = file(var.private_key_path)
  }
}

resource "yandex_compute_instance" "app" {
  count      = 1
  depends_on = [yandex_compute_instance.master]

  name = "app-node-${count.index}"

  resources {
    core_fraction = 20  
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd874d4jo8jbroqs6d7i"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.srv_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "ubuntu"
    private_key = file(var.private_key_path)
  }
}

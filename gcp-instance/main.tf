#TODO - move the state to a backend
#TODO - move the creds to an env variable (No hard keys)

#Google Provider - https://www.terraform.io/docs/providers/google/index.html
#Google Provider - proper reference https://www.terraform.io/docs/providers/google/provider_reference.html
provider "google" {
  #Handle credentials better here - https://www.terraform.io/docs/providers/google/provider_reference.html#credentials-1
  credentials = var.credentials_file

  project = var.project
  region  = var.region
  zone    = "australia-southeast1-b"
  #   version = "~> 2.14" (You can do this to lockin to a certain version)

}

#Google compute network reference - https://www.terraform.io/docs/providers/google/r/compute_network.html
resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

#Google compute instance - https://www.terraform.io/docs/providers/google/r/compute_instance.html
resource "google_compute_instance" "example11" {
  #name must be of regex - '(?:[a-z](?:[-a-z0-9]{0,61}[a-z0-9])?)'
  name         = "example-instance11"
  machine_type = var.machine_types[var.environment]
  tags         = ["personal", "test"]

  boot_disk {
    initialize_params {
      #Test updating the image in place and watch the resource get nuked and rebuilt
      image = "cos-cloud/cos-stable"
      # image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    # Here we import the name of the above VPC resource into the compute instances configuration
    # This enforces dependency - the instance will not begin provisioning until the VPC is deployed
    # You can get the ID of a resource by referencing it directly "google_compute_network.vpc_network"
    network = google_compute_network.vpc_network.name
    access_config {
      nat_ip = google_compute_address.vm_static_ip.address
    }
  }

  # https://www.terraform.io/docs/provisioners/index.html
  # The local-exec provisioner executes a command locally on the machine running Terraform, not the VM instance itself.
  # You can use remote connections to SSH onto the box - https://www.terraform.io/docs/provisioners/connection.html
  provisioner "local-exec" {
    # https://www.terraform.io/docs/providers/google/r/compute_instance.html#network_interface
    command = "echo ${google_compute_instance.example11.name}:  ${google_compute_instance.example11.network_interface[0].access_config[0].nat_ip} >> ip_address.txt"
  }
}

resource "google_compute_address" "vm_static_ip" {
  name   = "terraform-static-ip"
  region = "australia-southeast1"
}

# https://www.terraform.io/docs/providers/google/r/storage_bucket.html
resource "google_storage_bucket" "example-test" {
  name     = "steve-test-16-10-2019"
  location = "australia-southeast1"
}

resource "google_compute_instance" "example22" {
  name         = "example-instance22"
  machine_type = "f1-micro"
  tags         = ["personal", "test"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    # Example of an implicit dependency (Dont by referncing another resource in the terraform script)
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }

  # Example of a depends on (Explicit dependency)
  depends_on = [google_storage_bucket.example-test]

}
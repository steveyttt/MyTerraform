#TODO - move the state to a backend
#TODO - move the creds to an env variable (No hard keys)

#Google Provider - https://www.terraform.io/docs/providers/google/index.html
#Google Provider - proper reference https://www.terraform.io/docs/providers/google/provider_reference.html
provider "google" {
  #Handle credentials better here - https://www.terraform.io/docs/providers/google/provider_reference.html#credentials-1
  credentials = file("gcp-personal-test-241601-4ba9abd9b6f7.json")

  project = "gcp-personal-test-241601"
  region  = "australia-southeast-1"
  zone    = "australia-southeast1-b"
  #   version = "~> 2.14" (You can do this to lockin to a certain version)

}

#Google compute network reference - https://www.terraform.io/docs/providers/google/r/compute_network.html
resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

#Google compute instance - https://www.terraform.io/docs/providers/google/r/compute_instance.html
resource "google_compute_instance" "example1" {
  #name must be of regex - '(?:[a-z](?:[-a-z0-9]{0,61}[a-z0-9])?)'
  name         = "exmaple-instance"
  machine_type = "f1-micro"
  tags         = ["personal", "test"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
      #Test updating the image in place and watch the resource get nuked and rebuilt
      # image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    # Here we import the name of the above VPC resource into the compute instances configuration
    # This enforces dependency - the instance will not begin provisioning until the VPC is deployed
    # You can get the ID of a resource by referencing it directly "google_compute_network.vpc_network"
    network = google_compute_network.vpc_network.name
    access_config {

    }
  }
}


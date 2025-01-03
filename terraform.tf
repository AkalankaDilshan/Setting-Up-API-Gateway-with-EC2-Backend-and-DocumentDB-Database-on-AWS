terraform {
  cloud {

    organization = "ZeroCloud"

    workspaces {
      name = "first-nosql-db"
    }
  }
}

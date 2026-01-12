# Reading CSV File
locals {
    users_details = csvdecode(file("./users.csv"))
}

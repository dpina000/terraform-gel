# terraform-gel
terraform module to produce gel task

## How it works

object --> s3 bucket a -- (event) --> lambda -- (edits object) --> s3 bucket b

Each new object created in bucket a will raise an event that will trigger the lambda. The lambda then opens the file, edits it to remove metadata and saves it on destination bucket b

## Usage

Create lambda, sqs, permissions and users
```
module "gel" {
  source = "./terraform-gel"
  bucket_a = "bucket_a_gel"
  bucket_b = "bucket_b_gel"
  user_a = "user_a"
  user_b = "user_b"
}
```

Create lambda, sqs, permissions, users and example buckets
```
module "gel" {
  source = "./terraform-gel"
  create_bucket = true
  bucket_a      = "bucket_a_gel"
  bucket_b      = "bucket_b_gel"
  user_a        = "user_a"
  user_b        = "user_b"
}
```

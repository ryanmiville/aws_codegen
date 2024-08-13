import dot_env/env

pub type Error {
  UnknownError(message: String)
  ServiceError(message: String)
}

pub type Config {
  Config(access_key_id: String, secret_access_key: String, region: String)
}

pub fn default_credentials_provider() -> Config {
  let assert Ok(access_key_id) = env.get("AWS_ACCESS_KEY_ID")
  let assert Ok(secret_access_key) = env.get("AWS_SECRET_ACCESS_KEY")
  let region = "us-east-1"
  Config(access_key_id, secret_access_key, region)
}

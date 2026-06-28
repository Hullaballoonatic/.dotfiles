if (which gcloud | is-not-empty) {
  $env.path ++= ['/opt/homebrew/share/google-cloud-sdk/bin']
}


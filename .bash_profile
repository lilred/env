# BEGIN ANSIBLE MANAGED BLOCK
export PIP_INDEX_URL="https://artifactory.svc.internal.zone/api/pypi/pypi/simple"
export PIP_EXTRA_INDEX_URL="https://artifactory.svc.internal.zone/wheelhouse/"
export PIP_TRUSTED_HOST="artifactory.svc.internal.zone"
export REQUESTS_CA_BUNDLE="/usr/local/etc/ca-cert.pem"
export SBT_CREDENTIALS="/Users/cppoulin/.sbt/.credentials"
export GRADLE_USER_HOME="/Users/cppoulin/.gradle/"
# END ANSIBLE MANAGED BLOCK

[ -r "$HOME/.profile" ] && . "$HOME/.profile"

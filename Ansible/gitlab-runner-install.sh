# Добавляем официальный репозиторий GitLab Runner
curl -L --output /etc/apt/trusted.gpg.d/gitlab-runner.gpg https://packages.gitlab.com/gitlab/gitlab-runner/gpg.key
echo "deb https://packages.gitlab.com/gitlab/gitlab-runner/ubuntu/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/gitlab-runner.list
apt-get update

# Устанавливаем GitLab Runner
apt-get install -y gitlab-runner
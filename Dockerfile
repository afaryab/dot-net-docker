FROM mcr.microsoft.com/dotnet/sdk:8.0

WORKDIR /app

# Tools + SSH server
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
  && rm -rf /var/lib/apt/lists/*

# dotnet-ef
RUN dotnet tool install --global dotnet-ef --version 8.0.10
ENV PATH="$PATH:/root/.dotnet/tools"

# SSH runtime dirs
RUN mkdir -p /run/sshd /root/.ssh && chmod 700 /root/.ssh

# Expose both app and ssh (ssh stays internal; do NOT publish it)
EXPOSE 8080 22
ENV ASPNETCORE_URLS=http://+:8080

# Start sshd + dotnet watch
CMD bash -lc '\
  set -e; \
  ssh-keygen -A; \
  sed -i "s/^#\\?PasswordAuthentication.*/PasswordAuthentication no/" /etc/ssh/sshd_config; \
  sed -i "s/^#\\?ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/" /etc/ssh/sshd_config || true; \
  sed -i "s/^#\\?KbdInteractiveAuthentication.*/KbdInteractiveAuthentication no/" /etc/ssh/sshd_config || true; \
  sed -i "s/^#\\?PubkeyAuthentication.*/PubkeyAuthentication yes/" /etc/ssh/sshd_config; \
  sed -i "s/^#\\?PermitRootLogin.*/PermitRootLogin yes/" /etc/ssh/sshd_config; \
  if [ -f /run/gateway.pub ]; then cat /run/gateway.pub > /root/.ssh/authorized_keys; chmod 600 /root/.ssh/authorized_keys; fi; \
  /usr/sbin/sshd; \
  exec dotnet watch run \
'

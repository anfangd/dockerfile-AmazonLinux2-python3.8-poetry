# dockerfile-AmazonLinux2-python3.8-poetry

|Item|Content|
|:--|:--|
|OS|amazonlinux:2|
|Python|3.8.2|
|Pip|pip3.8|
|Poetry|1.0.5|
|OpenSSH|OpenSSH_7.4p1, OpenSSL 1.0.2k-fips  26 Jan 2017|
|Git|2.23.3|

## How to use

### Preparation

```bash
# Create keys
ssh-keygen -t rsa -b 4096 -C "hoge@example.com" -f ~/.ssh/id_rsa
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in id_rsa.
Your public key has been saved in id_rsa.pub.

ls ~/.ssh
id_rsa  id_rsa.pub

cp ~/.ssh/id_rsa.pub <PROJECT_ROOT>/authorized_keys
```

### Build

```bash
# Build
docker build -t "amazon-linux2/python" .
```

### Start Container

```bash
# Start Container
docker run --privileged --rm -d -p 10000:22 --name amazonlinux2-sshd-container amazon-linux2/python /sbin/init
```

### SSH Access to Container

```bash
# SSH Access
ssh ec2-user@localhost -p 10000 -i ~/.ssh/private_key
```

### Stop Container

```bash
# Stop Container
docker stop amazonlinux2-sshd-container
```

### Example: Poetry install Django | Flask

```bash
# Example: Poetry install Django
mkdir django-demo && cd $_
poetry init --no-interaction --dependency django
poetry install
poetry run django-admin.py startproject django-demo
```

```bash
# Example: Poetry install Flask
mkdir flask-demo && cd $_
poetry init --no-interaction --dependency flask
poetry install
```

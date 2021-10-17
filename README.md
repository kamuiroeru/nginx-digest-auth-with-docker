# nginx-digest-auth-with-docker
Digest 認証が可能な nginx を docker で利用する。

## Example
### Requirements
- docker-compose

```sh
# 1. pull this repository
git clone https://github.com/kamuiroeru/nginx-digest-auth-with-docker
cd nginx-digest-auth-with-docker
# 2. create .htdigest
touch .htdigest
htdigest .htdigest "secret_area" username
# Adding user username in realm secret_area
# New password:
# Re-type new password:
# 3. start with docker-compose
docker-compose up -d
# 4. access to localhost:8888
```

Enjoy!
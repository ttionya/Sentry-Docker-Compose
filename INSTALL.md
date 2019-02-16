## 安装

```bash
docker-compose build
docker-compose run --rm web config generate-secret-key
docker-compose run --rm web upgrade
docker-compose up -d
```

## 更新

```bash
docker-compose build
docker-compose run --rm web upgrade
docker-compose up -d
```
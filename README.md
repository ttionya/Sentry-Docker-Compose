## 修改 postgresql 密码

```shell
# 启动 postgresql 服务
docker run --name pg -v /data/sentry/onpremise/data/postgres:/var/lib/postgresql/data --rm -d postgres:9.5

# 执行 psql
docker run -it --rm --link pg:postgres postgres:9.5 psql -h postgres -U postgres

# 修改密码
ALTER USER postgres WITH PASSWORD 'postgres';
```

## 开放 postgresql 端口的安全设置

不开放端口时没关系，一旦需要开放 postgresql 的端口，需要修改 `./data/postgres/pg_hba.conf` 文件，禁用全部 `trust` 设置，添加 `host postgres postgres all md5`。不再信任本地连接，全部使用密码登录。

## 修复 `invalid memory alloc request size XXXX` 错误

经过测试，发现重置 xlog 可恢复。

```shell
# 通过 docker exec 进入容器操作，还要切换用户到 postgres
pg_resetxlog -f /var/lib/postgresql/data
```

## 链接

- [getsentry/onpremise](https://github.com/getsentry/onpremise)
- [postgres xlog误删除](http://blog.itpub.net/29898569/viewspace-1847657/)
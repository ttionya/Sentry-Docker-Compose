#!/bin/bash
# Version 1.0.1

export PATH=$PATH:/usr/local/bin

# Add backup directory
mkdir -p ./backup

log_file=./backup/backup.log
current_time=`date '+%Y%m%d'`
days_7ago_time=`date -d -7days '+%Y%m%d'`

# Do
echo "" >> $log_file
echo 【`date '+%Y-%m-%d %H:%M:%S'`】 正在停止 docker >> $log_file
docker-compose stop > /dev/null 2>&1
if [ $? != 0 ]; then
    echo 【`date '+%Y-%m-%d %H:%M:%S'`】 失败！正在重新启动 docker >> $log_file
    docker-compose restart > /dev/null 2>&1
    if [ $? == 0 ]; then
        echo 【`date '+%Y-%m-%d %H:%M:%S'`】 docker 已重新启动，跳过此次备份 >> $log_file
    else
        echo 【`date '+%Y-%m-%d %H:%M:%S'`】 docker 重新启动失败！！！ >> $log_file
    fi
    exit 1
fi
echo 【`date '+%Y-%m-%d %H:%M:%S'`】 成功！ >> $log_file

echo 【`date '+%Y-%m-%d %H:%M:%S'`】 开始备份 data 文件夹 >> $log_file
tar -Jcf ./backup/sentry-data.$current_time.tar.xz ./data > /dev/null 2>&1
if [ $? != 0 ]; then
    echo 【`date '+%Y-%m-%d %H:%M:%S'`】 失败，正在重新启动 docker >> $log_file
    docker-compose restart > /dev/null 2>&1
    if [ $? == 0 ]; then
        echo 【`date '+%Y-%m-%d %H:%M:%S'`】 docker 已重新启动，跳过此次备份 >> $log_file
    else
        echo 【`date '+%Y-%m-%d %H:%M:%S'`】 docker 重新启动失败！！！ >> $log_file
    fi
    exit 1
fi
echo 【`date '+%Y-%m-%d %H:%M:%S'`】 成功！ >> $log_file

echo 【`date '+%Y-%m-%d %H:%M:%S'`】 正在启动 docker >> $log_file
docker-compose start > /dev/null 2>&1
if [ $? != 0 ]; then
    echo 【`date '+%Y-%m-%d %H:%M:%S'`】 失败，正在重新启动 docker >> $log_file
    docker-compose restart > /dev/null 2>&1
    if [ $? == 0 ]; then
        echo 【`date '+%Y-%m-%d %H:%M:%S'`】 docker 已重新启动 >> $log_file
    else
        echo 【`date '+%Y-%m-%d %H:%M:%S'`】 docker 重新启动失败！！！ >> $log_file
        exit 1
    fi
fi
echo 【`date '+%Y-%m-%d %H:%M:%S'`】 成功！ >> $log_file


rm -rf ./backup/sentry-data.$days_7ago_time.tar.xz > /dev/null 2>&1
echo 【`date '+%Y-%m-%d %H:%M:%S'`】 移除历史备份文件 >> $log_file

echo 【`date '+%Y-%m-%d %H:%M:%S'`】 备份完成！ >> $log_file

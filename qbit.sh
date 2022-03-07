#!/bin/bash
echo "qbit..."
url=$1
# 地址端口
qbHost='http://localhost:9090'
if [ -z "$url" ]; then
    echo "无效链接"
    exit 8
fi
if [ -z $(echo $url | grep "http") ]; then
    if [ -z $(echo $url | grep "magnet:") ]; then
        echo "无效链接2"
        exit 2
    fi
fi
echo `添加下载任务：${url}`
# 账号密码
respHead=`curl -i --X POST --url ${qbHost}/api/v2/auth/login --data 'username=admin&password=cAnden' -s|grep 'SID'`
SIDStr=$(echo "$respHead")
# 获取sid set-cookie: SID=ga3u3Bl3PSt7Eu/1WTxkrrEHWynJtODG; HttpOnly; path=/; SameSite=Strict
# echo "获取SIDStr->${SIDStr}"
t=$(echo ${SIDStr%; HttpOnly*})
#echo $t
SID=$(echo ${t#*SID=}) 

if [ -z "$SID" ]; then
    echo "认证失败"
    exit 8
fi

echo "认证成功 SID：${SID}"
params=$(echo "urls=${url}&savepath=/downloads/&autoTMM=false")

addCurl=`curl --cookie SID=${SID} --X POST --data ${params} --url ${qbHost}/api/v2/torrents/add -s | grep 'Ok.'`
s=$(echo "${addCurl}")
echo $s
if [ -z "$s"]
then
    echo '添加失败！'
    exit 9
else
    echo '添加成功！'
fi

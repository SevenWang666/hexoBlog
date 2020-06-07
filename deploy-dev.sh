#!/bin/bash
cd /xincheng/blog
echo "拉取github中代码"
git pull
echo "安装依赖"
npm i
echo "编译项目"
npm run build

echo done!

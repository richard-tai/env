/usr/bin/env bash
docker run --net=host --mount type=bind,source=/home/xxx/,target=/home/xxx --rm -it zoo:v0.34

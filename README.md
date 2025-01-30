```bash
docker build . --platform=linux/amd64 -t shim
docker run --platform=linux/amd64 --rm -it shim
```

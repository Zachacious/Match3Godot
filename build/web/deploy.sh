# Build and deploy

# bump the minor version automatically
# in case I forget to manually bump version
./version.sh -p

version=$(./version.sh -v)

# build the docker image, login, push to docker hub
docker build -t zachacious/deathmatch3:latest -t zachacious/deathmatch3:${version} .
docker login
docker push zachacious/deathmatch3:latest
docker push zachacious/deathmatch3:${version}

# force kubernetes deployment to re-pull the image
#kubectl rollout restart deploy deathmatch3 -n public
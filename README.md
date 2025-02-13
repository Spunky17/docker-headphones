
Anyway, for those seeing this I'm just doing this as I regularly use this product and I find it useful and wanted the latest version of the Headphones application avaialble in a docker image again so I can deploy it to my TrueNAS server.

I simply renamed the original README.md as README-ORG.md so please DON'T believe anything contained in it reflects to this project!

For now the only way to get the updated version is to clone this repository, do a docker build on the code and then create a custom yaml file to reference the new image.  I'm currently testing this on my TrueNAS system and have it working well with a few minor issues that need sorting out.

Install:
git clone https://github.com/Spunky17/docker-headphones.git
cd docker-headphones
docker build --no-cache -t headphones .

Once the above it build you should have an image called "headphones:latest" in your docker image list.

My YAML File:
services:
  headphones:
    container_name: headphones
    environment:
      - PUID=568
      - PGID=568
      - TZ=Etc/UTC
    image: headphones:latest
    labels:
      - diun.enable=true
    ports:
      - 8181:8181
    restart: unless-stopped
    volumes:
      - <local path to headphones config data>:/config
      - <local path to downloader downloads>:/media/downloads
      - <local path to music files>:/media/music
      - <local path to recycle bin location>:/media/recycle.bin

I have also forked the headphones repository and created my own version as it needed some updates due to some errors related to alpine:3.21.  If you want you can run with the original version from rembo10 or from my forked version.  The Dockerfile above is setup to reference my build and will require updating your headphones config.ini file to reflect my forked copy.  Currently in the config.ini file the "git_user" is set to rembo10.  To use my forked copy you need to update it to "Spunky17".

Headphones config.ini:
Before:
git_user = rembo10
After:
git_user = Spunky17

Also note that I'm not really coding or updating anything major in the original application.  This is just so that I can continue using the application for the forseeable future.

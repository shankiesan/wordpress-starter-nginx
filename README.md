# Proper Design WordPress nginx starter

This is [Proper Design](http://properdesign.rs)'s hack of two great projects:

* Visible's [WordPress starter](https://github.com/visiblevc/wordpress-starter) – a wonderful approach to file persistence for local WordPress development. Almost all of this repo is based on a fork of their project
* eugeneware's excellent [docker-wordpress-nginx](https://github.com/eugeneware/docker-wordpress-nginx)

The purpose is the same as Visible's – to create a less shitty WordPress development workflow that exposes and persists files to the host. But here, we add nginx to (close to) replicate our server environment.

We also expose the entire wp-content directory as we often work with assets locally and aren't as clued up with S3 as Visible are.

## Requirements

- Docker
- Docker Compose 1.6+

## Getting started

```
# clone this project
git clone https://github.com/shankiesan/wordpress-starter-nginx
# build the image. We could use Docker Hub, but I think it's more useful to be able to hack your dockerfile
docker build -t wordpress-nginx
# start the containers
docker-compose up
# visit localhost:8080
```

## Documentation

This is based on Visible's excellent [WordPress starter](https://github.com/visiblevc/wordpress-starter). Here are their blog posts explaining how it all works:

- [Intro: A slightly less shitty WordPress developer workflow](https://visible.vc/engineering/wordpress-developer-workflow/)
- [Part 1: Setup a local development environment for WordPress with Docker](https://visible.vc/engineering/docker-environment-for-wordpress/)
- [Part 2: Setup an asset pipeline for WordPress theme development](https://visible.vc/engineering/asset-pipeline-for-wordpress-theme-development/)
- [Part 3: Optimize your wordpress theme assets and deploy to S3](https://visible.vc/engineering/optimize-wordpress-theme-assets-and-deploy-to-s3-cloudfront/)
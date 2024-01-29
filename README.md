## Getting Started

#### Install Docker

Linux: https://docs.docker.com/get-started/
Windows and Mac: https://www.docker.com/products/docker-desktop

To avoid having to specify CLI flags on every command:
`export COMPOSE_PROJECT_NAME=free-it-for-all`

To bring network/containers/volumes up:
`docker compose up -d --build`

Setup initial data:
`docker compose exec app rails db:setup`

Reset data:
`docker compose restart app`
`docker compose exec app rails db:reset`

---

#### Use HTTPs locally

`docker compose cp caddy:/data/caddy/pki/authorities/local/root.crt ~/Desktop/free-it-for-all-caddy.crt`

1. `sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/Desktop/free-it-for-all-caddy.crt`
    • OR •
   - [Add certificates to a keychain using Keychain Access on Mac](https://support.apple.com/guide/keychain-access/add-certificates-to-a-keychain-kyca2431/mac)
   - [Change the trust settings of a certificate in Keychain Access on Mac](https://support.apple.com/guide/keychain-access/change-the-trust-settings-of-a-certificate-kyca11871/mac)
1. [Use dnsmasq to setup a local domain for development on Mac](https://gist.github.com/ogrrd/5831371)
   • OR •
   - Add `127.0.0.1 app.free_it_for_all.test` to your `/etc/hosts` file

---

#### Run Specs

To run specs:
`docker compose exec -e RAILS_ENV=test app rails db:schema:load`
`docker compose exec -e RAILS_ENV=test app rspec`

To see system specs run in the browser:

Visit: http://localhost:7900
password: `secret`
and run:

`docker compose exec -e RAILS_ENV=test -e DISABLE_HEADLESS=true app rspec`

---

#### Debugging

To access a debug session:
`docker attach free-it-for-all-app-1`

To exit a debug session:

- Enter the escape sequence: `ctrl+p->q`
- Continue execution with `ctrl+d`, don't `exit!` or `ctrl+c`, else you'll exit the container and will need to start it after

---

#### Miscellaneous

Fix 'Failed to Compile - random.js module not found' error:

Shell into the container with `docker compose exec app bash`, enter `bundle exec rails yarn:install`,
then stop and restart the container.

See all running containers:
`docker compose ps`

Shell into a container:
`docker compose exec app bash`

See all logs:
`docker compose logs --tail=100 -f`

See all logs for specific services:
`docker compose logs --tail=100 -f app job`

Run a one off command on a separate, new, ephemeral container:
`docker compose run --rm app bundle`

Stop all containers:
`docker compose stop`

Remove all containers:
`docker compose down`

Remove all volumes (persisted data):
`docker volume rm $(docker volume ls -q | grep free-it-for-all)`

Remove all images:
`docker rmi free-it-for-all-app`

##### Deploy

See [Infra README.md](./infra/README.md)

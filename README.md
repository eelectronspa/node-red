# Node-RED

[Node-RED](https://nodered.org/)

> **Note:** This is a general and minimal guide for setting up a Node-RED instance for development and testing purposes.  
> **DO NOT USE IN PRODUCTION!**

To ensure that the container runs with the permissions of the current user, we created a bash script named `docker.bash`.

```bash
cd ./containers/
./docker.bash compose up
```

## Add credentials

Once the containers have started for the first time, Node-RED will create its initial data in the folder `containers/nodered/data`. Now it's time to configure authentication.

For more info go to [Securing-Node-RED](https://nodered.org/docs/user-guide/runtime/securing-node-red)

### Generate the password hash

Node-RED requires passwords to be hashed with **bcrypt**. Generate the hash by running
the following command inside the running container:

```bash
# admin password hash
docker exec -it lab-nodered node-red admin hash-pw
# credentialSecret key
docker exec -it lab-nodered node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

You will be prompted to enter a password. Copy the resulting hash (it starts with `$`).

e.g. password == `$2y$08$BkSIDDp1C0L5wBfjgBoyNeYLuErcZSXw.niRgVTdDtab4sexYpS0u`

e.g. credentialSecret == `699170146222dc48ddbf21cc3e8d8de484d99bb170ee57be8016b2cc06306d66`

### Edit settings.js

Open `containers/nodered/data/settings.js` and locate the commented-out `adminAuth` and `credentialSecret` blocks. Uncomment  both of them and fill them in:

```js
adminAuth: {
    type: "credentials",
    users: [
        {
            username: "admin",
            password: "your-hashed-password-here",
            permissions: "*"
        }
    ]
},

credentialSecret: "your-secret-key-here",
```

> **Note:** The `permissions: "*"` field grants full access. You can add more users with
> `permissions: "read"` for read-only access.

> **Note:** `credentialSecret` is the key used by Node-RED to encrypt sensitive data
> stored in flows (e.g. passwords, API keys, tokens inside nodes). Choose a strong
> random string and keep it safe — if you lose it or change it, all encrypted
> credentials in your flows will be unreadable.

### Restart the container

For the changes to take effect, restart Node-RED:

```bash
cd ./containers/
./docker.bash compose restart lab-nodered
```

You can now open Node-RED at `http://localhost:1880` and log in with your credentials.


## Install node-red-contrib-eelectron-knxip

[`node-red-contrib-eelectron-knxip`](https://github.com/eelectronspa/node-red-contrib-eelectron-knxip) is a Node-RED package providing nodes for KNX/IP communication.

Since this package is not published on the npm registry, it must be installed directly from the GitHub repository.

### Install via the container shell

Run the following command to install the package directly from GitHub inside the
running container:

```bash
docker exec -it lab-nodered sh -c "
  cd /tmp && \
  git clone https://github.com/eelectronspa/node-red-contrib-eelectron-knxip.git && \
  cd node-red-contrib-eelectron-knxip && \
  npm install --cache /tmp/npm-cache && \
  npm run build && \
  cp -r . /data/node_modules/node-red-contrib-eelectron-knxip
"
```

If you need to reinstall it or download a new version

```bash
docker exec -it lab-nodered rm -rf /data/node_modules/node-red-contrib-eelectron-knxip
```

> **Note:** The `--cache /tmp/npm-cache` flag avoids permission errors on the default
> npm cache directory (`/.npm`) which is owned by root inside the container.
> The `--prefix /data` flag ensures the package is installed in the Node-RED user data
> directory (`containers/nodered/data`), so it persists across container recreations.

Then restart the container for Node-RED to load the new nodes:

```bash
cd ./containers/
./docker.bash compose restart lab-nodered
```

> **Note:** The `--prefix /data` flag ensures the package is installed in the Node-RED
> user data directory (`containers/nodered/data`), so it persists across container
> recreations.
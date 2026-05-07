# MQTT Broker

[Node-RED](https://nodered.org/)

> **Note:** This is a general and minimal guide for setting up a Node-RED instance for development and testing purposes.  
> **DO NOT USE IN PRODUCTION!**

To ensure that the container runs with the permissions of the current user, we created a bash script named `docker.bash`.

```bash
cd ./containers/
./docker.bash compose up
```
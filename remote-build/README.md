# Remote build via Sylabs cloud

This feature allows users to perform a remote build of a container when they dont have access to virtual machine with sudo privileges.

## Step 01

Get an account on https://cloud.sylabs.io/


## Step 02

* Click on your username to the right and select access tokens.
* Then enter Label for a new token e.g. raad2 and press create a new access token.
* Copy the token you have generated to a secure location as it wont be visible again

## Step 03
In the next step we will login to a machine where we don't have sudo privileges. E.g. raad2
Login to raad2 and issue following;

```sh

raad2a:~> singularity remote login
INFO:    Authenticating with default remote.
Generate an API Key at https://cloud.sylabs.io/auth/tokens, and paste here:

# Paste your token here which was generated from cloud.sylabs.io
# Please note that when you paste your token, nothing will appear on screen. Just hit enter and you should see a message "INFO: API Key Verified!"
```

Now we are all set for remote builds

## Step 04
Create a definition file which lists all your requirements for the container
```sh
singularity build --remote myapp.sif myapp.def
```
## Step 05
Interact with the container
```sh
singularity exec myapp.sif python3 --version
```

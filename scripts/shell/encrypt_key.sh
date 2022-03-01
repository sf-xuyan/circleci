#!/bin/bash
# get started -> bash scripts/shell/encrypt_key.sh

# openssl enc -aes-256-cbc -k 'ilovecode' -P -md sha1 -nosalt
#   key=E5E9FA1BA31ECD1AE84F75CAAA474F3A663F05F412028F81DA65D26EE56424B2
#   iv=E93DA465B309C53FEC5FF93C9637DA58

# output
key=9ED60A402D471AF649D34B30A573EC4A015437B9E6F0DA4655F292988385DA79
iv=1ADD791F1279BA6DCEF1A8742437F1D7

openssl enc -nosalt -aes-256-cbc -in secretfile/server.key -out secretfile/server.key.enc -base64 -K $key -iv $iv

# decrypt ket
# openssl enc -nosalt -aes-256-cbc -d -in secretfile/server.key.enc -out secretfile/server1.key -base64 -K $key -iv $iv
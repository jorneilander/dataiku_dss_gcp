#!/bin/bash
# Keychain query fields.
# LABEL is the value you put for "Keychain Item Name" in Keychain.app.
LABEL="ansible-vault-password-dataiku"
ACCOUNT_NAME="$(whoami)"

# security add-generic-password -a $(whoami) -s ${LABEL} -w

/usr/bin/security find-generic-password -w -a "$ACCOUNT_NAME" -l "$LABEL"

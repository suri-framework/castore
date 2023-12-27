# Changes

## 0.0.2

This release pre-processes the .pem file into a list of pem certificate strings
that can be easily parsed with `X509` to build chains of trust.

You can access the whole pem file on `Ca_store.pem` and the individual
certificates in the `Ca_store.certificates` list.

## 0.0.1

Initial release of CAStore including a PEM file generated on Dec 12.

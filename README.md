# CAStore 🦫 

A portable pure OCaml CA Store, with no dependencies, inspired by Elixir's
[:castore][castore].

[castore]: https://github.com/elixir-mint/castore

## Getting Started

First, install `castore` in your switch:

```zsh
# latest published version
opam install castore

# latest development version
opam pin castore git+https://github.com/leostera/castore
```

Now we can add it to your dune project dependencies:

```
(package
 ;...
 (depends
   (castore (>= "0.0.0"))
   ;...)
 ;...)
```

And to your dune stanzas:

```
(executable
  (name my_app)
  (libraries castore))
```

And finally we can use it by decoding the certificates, and building a chain of
trust we can build our Tls config with.

Here's an example of how to do it:

<!-- $MDX file=decode_test.ml,part=main -->
```ocaml
let decode_pem ca =
  let ca = Cstruct.of_string ca in
  let cert = X509.Certificate.decode_pem ca in
  Result.get_ok cert
in
let cas = List.map decode_pem Ca_store.cas in
let authenticator = X509.Authenticator.chain_of_trust ~time cas in
(* ... *)
```

## Acknowledgements

This project would not be possible without `ocaml-tls` and `ca-certs`, in fact,
we use `ca-certs` to generate the `Ca_store.cas` with code taken from the
implementation of `ca-certs`.

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

```ocaml
(package
 ;...
 (depends
   (castore (>= "0.0.0")
   ...)
 ...)
```

And to your dune stanzas:

```ocaml
(executable
  (name my_app)
  (libraries castore))
```

And finally we can use it by decoding the certificates, and building a chain of
trust we can build our Tls config with:

```ocaml
let decode ca = 
    let cs = Cstruct.of_string ca in
    X509.Authenticator.decode_pem cs
    |> Result.get_ok
in
let cas = List.map X509.Authenticator.decode_pem Ca_store.cas in
let authenticator = X509.Authenticator.chain_of_trust ~time cas in
let tls_config = Tls.Config.client ~authenticator () in
(* ... *)
```

For an example of how to use this, check out the [Blink.Transport.Ssl.Auth][blink_ssl] module.

[blink_ssl]: https://github.com/leostera/blink/blob/main/blink/ssl.ml#L154-L201

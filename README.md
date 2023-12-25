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

And finally we can use it when creating your applications TLs config:

```ocaml
let authenticator = make_auth Ca_store.pem in
(* ... *)
```

For an example of how to use this, check out the [Blink.Transport.Ssl.Auth][blink_ssl] module.

[blink_ssl]:https://github.com/leostera/blink/blob/main/blink/ssl.ml#L89-L136

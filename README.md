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
let authenticator = X509.authenticator Ca_store.certificate in
(* ... *)
```

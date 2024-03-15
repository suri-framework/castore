(lang dune 3.11)
(using mdx 0.4)

(name castore)

(generate_opam_files true)

(source (github leostera/castore))

(authors "Leandro Ostera <leandro@abstractmachines.dev>")

(maintainers "Leandro Ostera <leandro@abstractmachines.dev>")

(license MIT)

(package
 (name castore)
 (synopsis "A portable CA Store with a global .crt and .pem files")
 (depends 
   (ocaml (>="5.1")) 
   (mdx (and :with-test (>= "2.3.1")))
   (x509 (>= "0.16.5"))
   dune)
 (tags (https tls cert crt pem ca "ca store")))

let time () = None in
(* $MDX part-begin=main *)
let decode_pem ca =
  let ca = Cstruct.of_string ca in
  let cert = X509.Certificate.decode_pem ca in
  Result.get_ok cert
in
let cas = List.map decode_pem Ca_store.certificates in
let authenticator = X509.Authenticator.chain_of_trust ~time cas in
(* ... *)
(* $MDX part-end *)
ignore authenticator;

print_endline "decode_test: OK"

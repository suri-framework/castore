val pem : string
(** The Mozilla CA certificate store in PEM format. *)

val cas : string list
(** The Mozilla CA certificate list ready to be used with libraries like [X509]. *)

let pem =
  let ic = open_in "cacert.pem" in
  let pem = In_channel.input_all ic in
  close_in ic;
  pem

let generate_pem pem =
  let file = Format.sprintf "let pem = {|%s|}" pem in
  let oc = open_out "pem.ml" in
  Out_channel.output_string oc file;
  Printf.printf "🔑 Generated pem.ml\n";
  close_out oc

(******************************************************************************

    The X509 and Auth modules below were ported from `ca-certs`, specifically
    from:

      * https://github.com/mirage/ca-certs/blob/main/lib/ca_certs.ml

    under this license:

      Copyright (c) 2014, David Kaloper and Hannes Mehnert
      All rights reserved.

      Redistribution and use in source and binary forms, with or without modification,
      are permitted provided that the following conditions are met:

      * Redistributions of source code must retain the above copyright notice, this
        list of conditions and the following disclaimer.

      * Redistributions in binary form must reproduce the above copyright notice, this
        list of conditions and the following disclaimer in the documentation and/or
        other materials provided with the distribution.

      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
      ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
      WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
      DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
      ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
      (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
      LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
      ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
      (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
      SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

  *******************************************************************************)
let generate_cas pem =
  let d = "-----" in
  let new_cert = d ^ "BEGIN CERTIFICATE" ^ d
  and end_of_cert = d ^ "END CERTIFICATE" ^ d in
  let len_new = String.length new_cert
  and len_end = String.length end_of_cert in
  let lines = String.split_on_char '\n' pem in
  let it, cas =
    List.fold_left
      (fun (acc, cas) line ->
        match acc with
        | None
          when String.length line >= len_new
               && String.(equal (sub line 0 len_new) new_cert) ->
            (Some [ line ], cas)
        | None -> (None, cas)
        | Some lines
          when String.length line >= len_end
               && String.(equal (sub line 0 len_end) end_of_cert) -> (
            let data = String.concat "\n" (List.rev (line :: lines)) in
            match X509.Certificate.decode_pem (Cstruct.of_string data) with
            | Ok _ca -> (None, data :: cas)
            | Error (`Msg msg) ->
                Printf.printf "Failed to decode a trust anchor %s.\n" msg;
                Printf.printf "Full certificate:@.%s\n" data;
                (None, cas))
        | Some lines -> (Some (line :: lines), cas))
      (None, []) lines
  in
  (match it with
  | None -> ()
  | Some lines ->
      Printf.printf "ignoring leftover data: %s\n"
        (String.concat "\n" (List.rev lines)));

  let cas = List.rev cas in
  let cas =
    String.concat ";\n" (List.map (fun ca -> Format.asprintf "{|%s|}" ca) cas)
  in
  let file = Format.sprintf "let cas = [\n%s\n] " cas in
  let oc = open_out "cas.ml" in
  Out_channel.output_string oc file;
  Printf.printf "🔒 Generated cas.ml\n";
  close_out oc

let () =
  Printf.printf "Regenerating modules:\n";
  generate_pem pem;
  generate_cas pem;
  Printf.printf "OK\n"


(** Code for scip.proto *)

(* generated from "scip.proto", do not edit *)



(** {2 Types} *)

type protocol_version =
  | Unspecified_protocol_version 

type tool_info = private {
  mutable _presence: Pbrt.Bitfield.t; (** presence for 2 fields *)
  mutable name : string;
  mutable version : string;
  mutable arguments : string list;
}

type text_encoding =
  | Unspecified_text_encoding 
  | Utf8 
  | Utf16 

type metadata = private {
  mutable _presence: Pbrt.Bitfield.t; (** presence for 3 fields *)
  mutable version : protocol_version;
  mutable tool_info : tool_info option;
  mutable project_root : string;
  mutable text_document_encoding : text_encoding;
}

type syntax_kind =
  | Unspecified_syntax_kind 
  | Comment 
  | Punctuation_delimiter 
  | Punctuation_bracket 
  | Keyword 
  | Identifier_keyword 
  | Identifier_operator 
  | Identifier 
  | Identifier_builtin 
  | Identifier_null 
  | Identifier_constant 
  | Identifier_mutable_global 
  | Identifier_parameter 
  | Identifier_local 
  | Identifier_shadowed 
  | Identifier_namespace 
  | Identifier_module 
  | Identifier_function 
  | Identifier_function_definition 
  | Identifier_macro 
  | Identifier_macro_definition 
  | Identifier_type 
  | Identifier_builtin_type 
  | Identifier_attribute 
  | Regex_escape 
  | Regex_repeated 
  | Regex_wildcard 
  | Regex_delimiter 
  | Regex_join 
  | String_literal 
  | String_literal_escape 
  | String_literal_special 
  | String_literal_key 
  | Character_literal 
  | Numeric_literal 
  | Boolean_literal 
  | Tag 
  | Tag_attribute 
  | Tag_delimiter 

type severity =
  | Unspecified_severity 
  | Error 
  | Warning 
  | Information 
  | Hint 

type diagnostic_tag =
  | Unspecified_diagnostic_tag 
  | Unnecessary 
  | Deprecated 

type diagnostic = private {
  mutable _presence: Pbrt.Bitfield.t; (** presence for 4 fields *)
  mutable severity : severity;
  mutable code : string;
  mutable message : string;
  mutable source : string;
  mutable tags : diagnostic_tag list;
}

type occurrence = private {
  mutable _presence: Pbrt.Bitfield.t; (** presence for 3 fields *)
  mutable range : int32 list;
  mutable symbol : string;
  mutable symbol_roles : int32;
  mutable override_documentation : string list;
  mutable syntax_kind : syntax_kind;
  mutable diagnostics : diagnostic list;
}

type relationship = private {
  mutable _presence: Pbrt.Bitfield.t; (** presence for 5 fields *)
  mutable symbol : string;
  mutable is_reference : bool;
  mutable is_implementation : bool;
  mutable is_type_definition : bool;
  mutable is_definition : bool;
}

type symbol_information = private {
  mutable _presence: Pbrt.Bitfield.t; (** presence for 1 fields *)
  mutable symbol : string;
  mutable documentation : string list;
  mutable relationships : relationship list;
}

type document = private {
  mutable _presence: Pbrt.Bitfield.t; (** presence for 2 fields *)
  mutable language : string;
  mutable relative_path : string;
  mutable occurrences : occurrence list;
  mutable symbols : symbol_information list;
}

type index = private {
  mutable metadata : metadata option;
  mutable documents : document list;
  mutable external_symbols : symbol_information list;
}

type package = private {
  mutable _presence: Pbrt.Bitfield.t; (** presence for 3 fields *)
  mutable manager : string;
  mutable name : string;
  mutable version : string;
}

type descriptor_suffix =
  | Unspecified_suffix 
  | Namespace 
  | Package 
  | Type 
  | Term 
  | Method 
  | Type_parameter 
  | Parameter 
  | Macro 
  | Meta 
  | Local 

type descriptor = private {
  mutable _presence: Pbrt.Bitfield.t; (** presence for 3 fields *)
  mutable name : string;
  mutable disambiguator : string;
  mutable suffix : descriptor_suffix;
}

type symbol = private {
  mutable _presence: Pbrt.Bitfield.t; (** presence for 1 fields *)
  mutable scheme : string;
  mutable package : package option;
  mutable descriptors : descriptor list;
}

type symbol_role =
  | Unspecified_symbol_role 
  | Definition 
  | Import 
  | Write_access 
  | Read_access 
  | Generated 
  | Test 

type language =
  | Unspecified_language 
  | Abap 
  | Apl 
  | Ada 
  | Agda 
  | Ascii_doc 
  | Assembly 
  | Awk 
  | Bat 
  | Bib_te_x 
  | C 
  | Cobol 
  | Cpp 
  | Css 
  | Csharp 
  | Clojure 
  | Coffeescript 
  | Common_lisp 
  | Coq 
  | Dart 
  | Delphi 
  | Diff 
  | Dockerfile 
  | Dyalog 
  | Elixir 
  | Erlang 
  | Fsharp 
  | Fish 
  | Flow 
  | Fortran 
  | Git_commit 
  | Git_config 
  | Git_rebase 
  | Go 
  | Groovy 
  | Html 
  | Hack 
  | Handlebars 
  | Haskell 
  | Idris 
  | Ini 
  | J 
  | Json 
  | Java 
  | Java_script 
  | Java_script_react 
  | Jsonnet 
  | Julia 
  | Kotlin 
  | La_te_x 
  | Lean 
  | Less 
  | Lua 
  | Makefile 
  | Markdown 
  | Matlab 
  | Nix 
  | Ocaml 
  | Objective_c 
  | Objective_cpp 
  | Php 
  | Plsql 
  | Perl 
  | Power_shell 
  | Prolog 
  | Python 
  | R 
  | Racket 
  | Raku 
  | Razor 
  | Re_st 
  | Ruby 
  | Rust 
  | Sas 
  | Scss 
  | Sml 
  | Sql 
  | Sass 
  | Scala 
  | Scheme 
  | Shell_script 
  | Skylark 
  | Swift 
  | Toml 
  | Te_x 
  | Type_script 
  | Type_script_react 
  | Visual_basic 
  | Vue 
  | Wolfram 
  | Xml 
  | Xsl 
  | Yaml 
  | Zig 


(** {2 Basic values} *)

val default_protocol_version : unit -> protocol_version
(** [default_protocol_version ()] is a new empty value for type [protocol_version] *)

val default_tool_info : unit -> tool_info 
(** [default_tool_info ()] is a new empty value for type [tool_info] *)

val default_text_encoding : unit -> text_encoding
(** [default_text_encoding ()] is a new empty value for type [text_encoding] *)

val default_metadata : unit -> metadata 
(** [default_metadata ()] is a new empty value for type [metadata] *)

val default_syntax_kind : unit -> syntax_kind
(** [default_syntax_kind ()] is a new empty value for type [syntax_kind] *)

val default_severity : unit -> severity
(** [default_severity ()] is a new empty value for type [severity] *)

val default_diagnostic_tag : unit -> diagnostic_tag
(** [default_diagnostic_tag ()] is a new empty value for type [diagnostic_tag] *)

val default_diagnostic : unit -> diagnostic 
(** [default_diagnostic ()] is a new empty value for type [diagnostic] *)

val default_occurrence : unit -> occurrence 
(** [default_occurrence ()] is a new empty value for type [occurrence] *)

val default_relationship : unit -> relationship 
(** [default_relationship ()] is a new empty value for type [relationship] *)

val default_symbol_information : unit -> symbol_information 
(** [default_symbol_information ()] is a new empty value for type [symbol_information] *)

val default_document : unit -> document 
(** [default_document ()] is a new empty value for type [document] *)

val default_index : unit -> index 
(** [default_index ()] is a new empty value for type [index] *)

val default_package : unit -> package 
(** [default_package ()] is a new empty value for type [package] *)

val default_descriptor_suffix : unit -> descriptor_suffix
(** [default_descriptor_suffix ()] is a new empty value for type [descriptor_suffix] *)

val default_descriptor : unit -> descriptor 
(** [default_descriptor ()] is a new empty value for type [descriptor] *)

val default_symbol : unit -> symbol 
(** [default_symbol ()] is a new empty value for type [symbol] *)

val default_symbol_role : unit -> symbol_role
(** [default_symbol_role ()] is a new empty value for type [symbol_role] *)

val default_language : unit -> language
(** [default_language ()] is a new empty value for type [language] *)


(** {2 Make functions} *)

val make_tool_info : 
  ?name:string ->
  ?version:string ->
  ?arguments:string list ->
  unit ->
  tool_info
(** [make_tool_info … ()] is a builder for type [tool_info] *)

val copy_tool_info : tool_info -> tool_info

val tool_info_has_name : tool_info -> bool
  (** presence of field "name" in [tool_info] *)

val tool_info_set_name : tool_info -> string -> unit
  (** set field name in tool_info *)

val tool_info_has_version : tool_info -> bool
  (** presence of field "version" in [tool_info] *)

val tool_info_set_version : tool_info -> string -> unit
  (** set field version in tool_info *)

val tool_info_set_arguments : tool_info -> string list -> unit
  (** set field arguments in tool_info *)

val make_metadata : 
  ?version:protocol_version ->
  ?tool_info:tool_info ->
  ?project_root:string ->
  ?text_document_encoding:text_encoding ->
  unit ->
  metadata
(** [make_metadata … ()] is a builder for type [metadata] *)

val copy_metadata : metadata -> metadata

val metadata_has_version : metadata -> bool
  (** presence of field "version" in [metadata] *)

val metadata_set_version : metadata -> protocol_version -> unit
  (** set field version in metadata *)

val metadata_has_tool_info : metadata -> bool
  (** presence of field "tool_info" in [metadata] *)

val metadata_set_tool_info : metadata -> tool_info -> unit
  (** set field tool_info in metadata *)

val metadata_has_project_root : metadata -> bool
  (** presence of field "project_root" in [metadata] *)

val metadata_set_project_root : metadata -> string -> unit
  (** set field project_root in metadata *)

val metadata_has_text_document_encoding : metadata -> bool
  (** presence of field "text_document_encoding" in [metadata] *)

val metadata_set_text_document_encoding : metadata -> text_encoding -> unit
  (** set field text_document_encoding in metadata *)

val make_diagnostic : 
  ?severity:severity ->
  ?code:string ->
  ?message:string ->
  ?source:string ->
  ?tags:diagnostic_tag list ->
  unit ->
  diagnostic
(** [make_diagnostic … ()] is a builder for type [diagnostic] *)

val copy_diagnostic : diagnostic -> diagnostic

val diagnostic_has_severity : diagnostic -> bool
  (** presence of field "severity" in [diagnostic] *)

val diagnostic_set_severity : diagnostic -> severity -> unit
  (** set field severity in diagnostic *)

val diagnostic_has_code : diagnostic -> bool
  (** presence of field "code" in [diagnostic] *)

val diagnostic_set_code : diagnostic -> string -> unit
  (** set field code in diagnostic *)

val diagnostic_has_message : diagnostic -> bool
  (** presence of field "message" in [diagnostic] *)

val diagnostic_set_message : diagnostic -> string -> unit
  (** set field message in diagnostic *)

val diagnostic_has_source : diagnostic -> bool
  (** presence of field "source" in [diagnostic] *)

val diagnostic_set_source : diagnostic -> string -> unit
  (** set field source in diagnostic *)

val diagnostic_set_tags : diagnostic -> diagnostic_tag list -> unit
  (** set field tags in diagnostic *)

val make_occurrence : 
  ?range:int32 list ->
  ?symbol:string ->
  ?symbol_roles:int32 ->
  ?override_documentation:string list ->
  ?syntax_kind:syntax_kind ->
  ?diagnostics:diagnostic list ->
  unit ->
  occurrence
(** [make_occurrence … ()] is a builder for type [occurrence] *)

val copy_occurrence : occurrence -> occurrence

val occurrence_set_range : occurrence -> int32 list -> unit
  (** set field range in occurrence *)

val occurrence_has_symbol : occurrence -> bool
  (** presence of field "symbol" in [occurrence] *)

val occurrence_set_symbol : occurrence -> string -> unit
  (** set field symbol in occurrence *)

val occurrence_has_symbol_roles : occurrence -> bool
  (** presence of field "symbol_roles" in [occurrence] *)

val occurrence_set_symbol_roles : occurrence -> int32 -> unit
  (** set field symbol_roles in occurrence *)

val occurrence_set_override_documentation : occurrence -> string list -> unit
  (** set field override_documentation in occurrence *)

val occurrence_has_syntax_kind : occurrence -> bool
  (** presence of field "syntax_kind" in [occurrence] *)

val occurrence_set_syntax_kind : occurrence -> syntax_kind -> unit
  (** set field syntax_kind in occurrence *)

val occurrence_set_diagnostics : occurrence -> diagnostic list -> unit
  (** set field diagnostics in occurrence *)

val make_relationship : 
  ?symbol:string ->
  ?is_reference:bool ->
  ?is_implementation:bool ->
  ?is_type_definition:bool ->
  ?is_definition:bool ->
  unit ->
  relationship
(** [make_relationship … ()] is a builder for type [relationship] *)

val copy_relationship : relationship -> relationship

val relationship_has_symbol : relationship -> bool
  (** presence of field "symbol" in [relationship] *)

val relationship_set_symbol : relationship -> string -> unit
  (** set field symbol in relationship *)

val relationship_has_is_reference : relationship -> bool
  (** presence of field "is_reference" in [relationship] *)

val relationship_set_is_reference : relationship -> bool -> unit
  (** set field is_reference in relationship *)

val relationship_has_is_implementation : relationship -> bool
  (** presence of field "is_implementation" in [relationship] *)

val relationship_set_is_implementation : relationship -> bool -> unit
  (** set field is_implementation in relationship *)

val relationship_has_is_type_definition : relationship -> bool
  (** presence of field "is_type_definition" in [relationship] *)

val relationship_set_is_type_definition : relationship -> bool -> unit
  (** set field is_type_definition in relationship *)

val relationship_has_is_definition : relationship -> bool
  (** presence of field "is_definition" in [relationship] *)

val relationship_set_is_definition : relationship -> bool -> unit
  (** set field is_definition in relationship *)

val make_symbol_information : 
  ?symbol:string ->
  ?documentation:string list ->
  ?relationships:relationship list ->
  unit ->
  symbol_information
(** [make_symbol_information … ()] is a builder for type [symbol_information] *)

val copy_symbol_information : symbol_information -> symbol_information

val symbol_information_has_symbol : symbol_information -> bool
  (** presence of field "symbol" in [symbol_information] *)

val symbol_information_set_symbol : symbol_information -> string -> unit
  (** set field symbol in symbol_information *)

val symbol_information_set_documentation : symbol_information -> string list -> unit
  (** set field documentation in symbol_information *)

val symbol_information_set_relationships : symbol_information -> relationship list -> unit
  (** set field relationships in symbol_information *)

val make_document : 
  ?language:string ->
  ?relative_path:string ->
  ?occurrences:occurrence list ->
  ?symbols:symbol_information list ->
  unit ->
  document
(** [make_document … ()] is a builder for type [document] *)

val copy_document : document -> document

val document_has_language : document -> bool
  (** presence of field "language" in [document] *)

val document_set_language : document -> string -> unit
  (** set field language in document *)

val document_has_relative_path : document -> bool
  (** presence of field "relative_path" in [document] *)

val document_set_relative_path : document -> string -> unit
  (** set field relative_path in document *)

val document_set_occurrences : document -> occurrence list -> unit
  (** set field occurrences in document *)

val document_set_symbols : document -> symbol_information list -> unit
  (** set field symbols in document *)

val make_index : 
  ?metadata:metadata ->
  ?documents:document list ->
  ?external_symbols:symbol_information list ->
  unit ->
  index
(** [make_index … ()] is a builder for type [index] *)

val copy_index : index -> index

val index_has_metadata : index -> bool
  (** presence of field "metadata" in [index] *)

val index_set_metadata : index -> metadata -> unit
  (** set field metadata in index *)

val index_set_documents : index -> document list -> unit
  (** set field documents in index *)

val index_set_external_symbols : index -> symbol_information list -> unit
  (** set field external_symbols in index *)

val make_package : 
  ?manager:string ->
  ?name:string ->
  ?version:string ->
  unit ->
  package
(** [make_package … ()] is a builder for type [package] *)

val copy_package : package -> package

val package_has_manager : package -> bool
  (** presence of field "manager" in [package] *)

val package_set_manager : package -> string -> unit
  (** set field manager in package *)

val package_has_name : package -> bool
  (** presence of field "name" in [package] *)

val package_set_name : package -> string -> unit
  (** set field name in package *)

val package_has_version : package -> bool
  (** presence of field "version" in [package] *)

val package_set_version : package -> string -> unit
  (** set field version in package *)

val make_descriptor : 
  ?name:string ->
  ?disambiguator:string ->
  ?suffix:descriptor_suffix ->
  unit ->
  descriptor
(** [make_descriptor … ()] is a builder for type [descriptor] *)

val copy_descriptor : descriptor -> descriptor

val descriptor_has_name : descriptor -> bool
  (** presence of field "name" in [descriptor] *)

val descriptor_set_name : descriptor -> string -> unit
  (** set field name in descriptor *)

val descriptor_has_disambiguator : descriptor -> bool
  (** presence of field "disambiguator" in [descriptor] *)

val descriptor_set_disambiguator : descriptor -> string -> unit
  (** set field disambiguator in descriptor *)

val descriptor_has_suffix : descriptor -> bool
  (** presence of field "suffix" in [descriptor] *)

val descriptor_set_suffix : descriptor -> descriptor_suffix -> unit
  (** set field suffix in descriptor *)

val make_symbol : 
  ?scheme:string ->
  ?package:package ->
  ?descriptors:descriptor list ->
  unit ->
  symbol
(** [make_symbol … ()] is a builder for type [symbol] *)

val copy_symbol : symbol -> symbol

val symbol_has_scheme : symbol -> bool
  (** presence of field "scheme" in [symbol] *)

val symbol_set_scheme : symbol -> string -> unit
  (** set field scheme in symbol *)

val symbol_has_package : symbol -> bool
  (** presence of field "package" in [symbol] *)

val symbol_set_package : symbol -> package -> unit
  (** set field package in symbol *)

val symbol_set_descriptors : symbol -> descriptor list -> unit
  (** set field descriptors in symbol *)


(** {2 Formatters} *)

val pp_protocol_version : Format.formatter -> protocol_version -> unit 
(** [pp_protocol_version v] formats v *)

val pp_tool_info : Format.formatter -> tool_info -> unit 
(** [pp_tool_info v] formats v *)

val pp_text_encoding : Format.formatter -> text_encoding -> unit 
(** [pp_text_encoding v] formats v *)

val pp_metadata : Format.formatter -> metadata -> unit 
(** [pp_metadata v] formats v *)

val pp_syntax_kind : Format.formatter -> syntax_kind -> unit 
(** [pp_syntax_kind v] formats v *)

val pp_severity : Format.formatter -> severity -> unit 
(** [pp_severity v] formats v *)

val pp_diagnostic_tag : Format.formatter -> diagnostic_tag -> unit 
(** [pp_diagnostic_tag v] formats v *)

val pp_diagnostic : Format.formatter -> diagnostic -> unit 
(** [pp_diagnostic v] formats v *)

val pp_occurrence : Format.formatter -> occurrence -> unit 
(** [pp_occurrence v] formats v *)

val pp_relationship : Format.formatter -> relationship -> unit 
(** [pp_relationship v] formats v *)

val pp_symbol_information : Format.formatter -> symbol_information -> unit 
(** [pp_symbol_information v] formats v *)

val pp_document : Format.formatter -> document -> unit 
(** [pp_document v] formats v *)

val pp_index : Format.formatter -> index -> unit 
(** [pp_index v] formats v *)

val pp_package : Format.formatter -> package -> unit 
(** [pp_package v] formats v *)

val pp_descriptor_suffix : Format.formatter -> descriptor_suffix -> unit 
(** [pp_descriptor_suffix v] formats v *)

val pp_descriptor : Format.formatter -> descriptor -> unit 
(** [pp_descriptor v] formats v *)

val pp_symbol : Format.formatter -> symbol -> unit 
(** [pp_symbol v] formats v *)

val pp_symbol_role : Format.formatter -> symbol_role -> unit 
(** [pp_symbol_role v] formats v *)

val pp_language : Format.formatter -> language -> unit 
(** [pp_language v] formats v *)


(** {2 Protobuf Encoding} *)

val encode_pb_protocol_version : protocol_version -> Pbrt.Encoder.t -> unit
(** [encode_pb_protocol_version v encoder] encodes [v] with the given [encoder] *)

val encode_pb_tool_info : tool_info -> Pbrt.Encoder.t -> unit
(** [encode_pb_tool_info v encoder] encodes [v] with the given [encoder] *)

val encode_pb_text_encoding : text_encoding -> Pbrt.Encoder.t -> unit
(** [encode_pb_text_encoding v encoder] encodes [v] with the given [encoder] *)

val encode_pb_metadata : metadata -> Pbrt.Encoder.t -> unit
(** [encode_pb_metadata v encoder] encodes [v] with the given [encoder] *)

val encode_pb_syntax_kind : syntax_kind -> Pbrt.Encoder.t -> unit
(** [encode_pb_syntax_kind v encoder] encodes [v] with the given [encoder] *)

val encode_pb_severity : severity -> Pbrt.Encoder.t -> unit
(** [encode_pb_severity v encoder] encodes [v] with the given [encoder] *)

val encode_pb_diagnostic_tag : diagnostic_tag -> Pbrt.Encoder.t -> unit
(** [encode_pb_diagnostic_tag v encoder] encodes [v] with the given [encoder] *)

val encode_pb_diagnostic : diagnostic -> Pbrt.Encoder.t -> unit
(** [encode_pb_diagnostic v encoder] encodes [v] with the given [encoder] *)

val encode_pb_occurrence : occurrence -> Pbrt.Encoder.t -> unit
(** [encode_pb_occurrence v encoder] encodes [v] with the given [encoder] *)

val encode_pb_relationship : relationship -> Pbrt.Encoder.t -> unit
(** [encode_pb_relationship v encoder] encodes [v] with the given [encoder] *)

val encode_pb_symbol_information : symbol_information -> Pbrt.Encoder.t -> unit
(** [encode_pb_symbol_information v encoder] encodes [v] with the given [encoder] *)

val encode_pb_document : document -> Pbrt.Encoder.t -> unit
(** [encode_pb_document v encoder] encodes [v] with the given [encoder] *)

val encode_pb_index : index -> Pbrt.Encoder.t -> unit
(** [encode_pb_index v encoder] encodes [v] with the given [encoder] *)

val encode_pb_package : package -> Pbrt.Encoder.t -> unit
(** [encode_pb_package v encoder] encodes [v] with the given [encoder] *)

val encode_pb_descriptor_suffix : descriptor_suffix -> Pbrt.Encoder.t -> unit
(** [encode_pb_descriptor_suffix v encoder] encodes [v] with the given [encoder] *)

val encode_pb_descriptor : descriptor -> Pbrt.Encoder.t -> unit
(** [encode_pb_descriptor v encoder] encodes [v] with the given [encoder] *)

val encode_pb_symbol : symbol -> Pbrt.Encoder.t -> unit
(** [encode_pb_symbol v encoder] encodes [v] with the given [encoder] *)

val encode_pb_symbol_role : symbol_role -> Pbrt.Encoder.t -> unit
(** [encode_pb_symbol_role v encoder] encodes [v] with the given [encoder] *)

val encode_pb_language : language -> Pbrt.Encoder.t -> unit
(** [encode_pb_language v encoder] encodes [v] with the given [encoder] *)


(** {2 Protobuf Decoding} *)

val decode_pb_protocol_version : Pbrt.Decoder.t -> protocol_version
(** [decode_pb_protocol_version decoder] decodes a [protocol_version] binary value from [decoder] *)

val decode_pb_tool_info : Pbrt.Decoder.t -> tool_info
(** [decode_pb_tool_info decoder] decodes a [tool_info] binary value from [decoder] *)

val decode_pb_text_encoding : Pbrt.Decoder.t -> text_encoding
(** [decode_pb_text_encoding decoder] decodes a [text_encoding] binary value from [decoder] *)

val decode_pb_metadata : Pbrt.Decoder.t -> metadata
(** [decode_pb_metadata decoder] decodes a [metadata] binary value from [decoder] *)

val decode_pb_syntax_kind : Pbrt.Decoder.t -> syntax_kind
(** [decode_pb_syntax_kind decoder] decodes a [syntax_kind] binary value from [decoder] *)

val decode_pb_severity : Pbrt.Decoder.t -> severity
(** [decode_pb_severity decoder] decodes a [severity] binary value from [decoder] *)

val decode_pb_diagnostic_tag : Pbrt.Decoder.t -> diagnostic_tag
(** [decode_pb_diagnostic_tag decoder] decodes a [diagnostic_tag] binary value from [decoder] *)

val decode_pb_diagnostic : Pbrt.Decoder.t -> diagnostic
(** [decode_pb_diagnostic decoder] decodes a [diagnostic] binary value from [decoder] *)

val decode_pb_occurrence : Pbrt.Decoder.t -> occurrence
(** [decode_pb_occurrence decoder] decodes a [occurrence] binary value from [decoder] *)

val decode_pb_relationship : Pbrt.Decoder.t -> relationship
(** [decode_pb_relationship decoder] decodes a [relationship] binary value from [decoder] *)

val decode_pb_symbol_information : Pbrt.Decoder.t -> symbol_information
(** [decode_pb_symbol_information decoder] decodes a [symbol_information] binary value from [decoder] *)

val decode_pb_document : Pbrt.Decoder.t -> document
(** [decode_pb_document decoder] decodes a [document] binary value from [decoder] *)

val decode_pb_index : Pbrt.Decoder.t -> index
(** [decode_pb_index decoder] decodes a [index] binary value from [decoder] *)

val decode_pb_package : Pbrt.Decoder.t -> package
(** [decode_pb_package decoder] decodes a [package] binary value from [decoder] *)

val decode_pb_descriptor_suffix : Pbrt.Decoder.t -> descriptor_suffix
(** [decode_pb_descriptor_suffix decoder] decodes a [descriptor_suffix] binary value from [decoder] *)

val decode_pb_descriptor : Pbrt.Decoder.t -> descriptor
(** [decode_pb_descriptor decoder] decodes a [descriptor] binary value from [decoder] *)

val decode_pb_symbol : Pbrt.Decoder.t -> symbol
(** [decode_pb_symbol decoder] decodes a [symbol] binary value from [decoder] *)

val decode_pb_symbol_role : Pbrt.Decoder.t -> symbol_role
(** [decode_pb_symbol_role decoder] decodes a [symbol_role] binary value from [decoder] *)

val decode_pb_language : Pbrt.Decoder.t -> language
(** [decode_pb_language decoder] decodes a [language] binary value from [decoder] *)

[@@@ocaml.warning "-23-27-30-39-44"]

type protocol_version =
  | Unspecified_protocol_version 

type tool_info = {
  mutable _presence: Pbrt.Bitfield.t; (** presence for 2 fields *)
  mutable name : string;
  mutable version : string;
  mutable arguments : string list;
}

type text_encoding =
  | Unspecified_text_encoding 
  | Utf8 
  | Utf16 

type metadata = {
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

type diagnostic = {
  mutable _presence: Pbrt.Bitfield.t; (** presence for 4 fields *)
  mutable severity : severity;
  mutable code : string;
  mutable message : string;
  mutable source : string;
  mutable tags : diagnostic_tag list;
}

type occurrence = {
  mutable _presence: Pbrt.Bitfield.t; (** presence for 3 fields *)
  mutable range : int32 list;
  mutable symbol : string;
  mutable symbol_roles : int32;
  mutable override_documentation : string list;
  mutable syntax_kind : syntax_kind;
  mutable diagnostics : diagnostic list;
}

type relationship = {
  mutable _presence: Pbrt.Bitfield.t; (** presence for 5 fields *)
  mutable symbol : string;
  mutable is_reference : bool;
  mutable is_implementation : bool;
  mutable is_type_definition : bool;
  mutable is_definition : bool;
}

type symbol_information = {
  mutable _presence: Pbrt.Bitfield.t; (** presence for 1 fields *)
  mutable symbol : string;
  mutable documentation : string list;
  mutable relationships : relationship list;
}

type document = {
  mutable _presence: Pbrt.Bitfield.t; (** presence for 2 fields *)
  mutable language : string;
  mutable relative_path : string;
  mutable occurrences : occurrence list;
  mutable symbols : symbol_information list;
}

type index = {
  mutable metadata : metadata option;
  mutable documents : document list;
  mutable external_symbols : symbol_information list;
}

type package = {
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

type descriptor = {
  mutable _presence: Pbrt.Bitfield.t; (** presence for 3 fields *)
  mutable name : string;
  mutable disambiguator : string;
  mutable suffix : descriptor_suffix;
}

type symbol = {
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

let default_protocol_version () = (Unspecified_protocol_version:protocol_version)

let default_tool_info (): tool_info =
{
  _presence=Pbrt.Bitfield.empty;
  name="";
  version="";
  arguments=[];
}

let default_text_encoding () = (Unspecified_text_encoding:text_encoding)

let default_metadata (): metadata =
{
  _presence=Pbrt.Bitfield.empty;
  version=default_protocol_version ();
  tool_info=None;
  project_root="";
  text_document_encoding=default_text_encoding ();
}

let default_syntax_kind () = (Unspecified_syntax_kind:syntax_kind)

let default_severity () = (Unspecified_severity:severity)

let default_diagnostic_tag () = (Unspecified_diagnostic_tag:diagnostic_tag)

let default_diagnostic (): diagnostic =
{
  _presence=Pbrt.Bitfield.empty;
  severity=default_severity ();
  code="";
  message="";
  source="";
  tags=[];
}

let default_occurrence (): occurrence =
{
  _presence=Pbrt.Bitfield.empty;
  range=[];
  symbol="";
  symbol_roles=0l;
  override_documentation=[];
  syntax_kind=default_syntax_kind ();
  diagnostics=[];
}

let default_relationship (): relationship =
{
  _presence=Pbrt.Bitfield.empty;
  symbol="";
  is_reference=false;
  is_implementation=false;
  is_type_definition=false;
  is_definition=false;
}

let default_symbol_information (): symbol_information =
{
  _presence=Pbrt.Bitfield.empty;
  symbol="";
  documentation=[];
  relationships=[];
}

let default_document (): document =
{
  _presence=Pbrt.Bitfield.empty;
  language="";
  relative_path="";
  occurrences=[];
  symbols=[];
}

let default_index (): index =
{
  metadata=None;
  documents=[];
  external_symbols=[];
}

let default_package (): package =
{
  _presence=Pbrt.Bitfield.empty;
  manager="";
  name="";
  version="";
}

let default_descriptor_suffix () = (Unspecified_suffix:descriptor_suffix)

let default_descriptor (): descriptor =
{
  _presence=Pbrt.Bitfield.empty;
  name="";
  disambiguator="";
  suffix=default_descriptor_suffix ();
}

let default_symbol (): symbol =
{
  _presence=Pbrt.Bitfield.empty;
  scheme="";
  package=None;
  descriptors=[];
}

let default_symbol_role () = (Unspecified_symbol_role:symbol_role)

let default_language () = (Unspecified_language:language)


(** {2 Make functions} *)

let[@inline] tool_info_has_name (self:tool_info) : bool = (Pbrt.Bitfield.get self._presence 0)
let[@inline] tool_info_has_version (self:tool_info) : bool = (Pbrt.Bitfield.get self._presence 1)

let[@inline] tool_info_set_name (self:tool_info) (x:string) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 0); self.name <- x
let[@inline] tool_info_set_version (self:tool_info) (x:string) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 1); self.version <- x
let[@inline] tool_info_set_arguments (self:tool_info) (x:string list) : unit =
  self.arguments <- x

let copy_tool_info (self:tool_info) : tool_info =
  { self with name = self.name }

let make_tool_info 
  ?(name:string option)
  ?(version:string option)
  ?(arguments=[])
  () : tool_info  =
  let _res = default_tool_info () in
  (match name with
  | None -> ()
  | Some v -> tool_info_set_name _res v);
  (match version with
  | None -> ()
  | Some v -> tool_info_set_version _res v);
  tool_info_set_arguments _res arguments;
  _res

let[@inline] metadata_has_version (self:metadata) : bool = (Pbrt.Bitfield.get self._presence 0)
let[@inline] metadata_has_tool_info (self:metadata) : bool = self.tool_info != None
let[@inline] metadata_has_project_root (self:metadata) : bool = (Pbrt.Bitfield.get self._presence 1)
let[@inline] metadata_has_text_document_encoding (self:metadata) : bool = (Pbrt.Bitfield.get self._presence 2)

let[@inline] metadata_set_version (self:metadata) (x:protocol_version) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 0); self.version <- x
let[@inline] metadata_set_tool_info (self:metadata) (x:tool_info) : unit =
  self.tool_info <- Some x
let[@inline] metadata_set_project_root (self:metadata) (x:string) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 1); self.project_root <- x
let[@inline] metadata_set_text_document_encoding (self:metadata) (x:text_encoding) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 2); self.text_document_encoding <- x

let copy_metadata (self:metadata) : metadata =
  { self with version = self.version }

let make_metadata 
  ?(version:protocol_version option)
  ?(tool_info:tool_info option)
  ?(project_root:string option)
  ?(text_document_encoding:text_encoding option)
  () : metadata  =
  let _res = default_metadata () in
  (match version with
  | None -> ()
  | Some v -> metadata_set_version _res v);
  (match tool_info with
  | None -> ()
  | Some v -> metadata_set_tool_info _res v);
  (match project_root with
  | None -> ()
  | Some v -> metadata_set_project_root _res v);
  (match text_document_encoding with
  | None -> ()
  | Some v -> metadata_set_text_document_encoding _res v);
  _res

let[@inline] diagnostic_has_severity (self:diagnostic) : bool = (Pbrt.Bitfield.get self._presence 0)
let[@inline] diagnostic_has_code (self:diagnostic) : bool = (Pbrt.Bitfield.get self._presence 1)
let[@inline] diagnostic_has_message (self:diagnostic) : bool = (Pbrt.Bitfield.get self._presence 2)
let[@inline] diagnostic_has_source (self:diagnostic) : bool = (Pbrt.Bitfield.get self._presence 3)

let[@inline] diagnostic_set_severity (self:diagnostic) (x:severity) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 0); self.severity <- x
let[@inline] diagnostic_set_code (self:diagnostic) (x:string) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 1); self.code <- x
let[@inline] diagnostic_set_message (self:diagnostic) (x:string) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 2); self.message <- x
let[@inline] diagnostic_set_source (self:diagnostic) (x:string) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 3); self.source <- x
let[@inline] diagnostic_set_tags (self:diagnostic) (x:diagnostic_tag list) : unit =
  self.tags <- x

let copy_diagnostic (self:diagnostic) : diagnostic =
  { self with severity = self.severity }

let make_diagnostic 
  ?(severity:severity option)
  ?(code:string option)
  ?(message:string option)
  ?(source:string option)
  ?(tags=[])
  () : diagnostic  =
  let _res = default_diagnostic () in
  (match severity with
  | None -> ()
  | Some v -> diagnostic_set_severity _res v);
  (match code with
  | None -> ()
  | Some v -> diagnostic_set_code _res v);
  (match message with
  | None -> ()
  | Some v -> diagnostic_set_message _res v);
  (match source with
  | None -> ()
  | Some v -> diagnostic_set_source _res v);
  diagnostic_set_tags _res tags;
  _res

let[@inline] occurrence_has_symbol (self:occurrence) : bool = (Pbrt.Bitfield.get self._presence 0)
let[@inline] occurrence_has_symbol_roles (self:occurrence) : bool = (Pbrt.Bitfield.get self._presence 1)
let[@inline] occurrence_has_syntax_kind (self:occurrence) : bool = (Pbrt.Bitfield.get self._presence 2)

let[@inline] occurrence_set_range (self:occurrence) (x:int32 list) : unit =
  self.range <- x
let[@inline] occurrence_set_symbol (self:occurrence) (x:string) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 0); self.symbol <- x
let[@inline] occurrence_set_symbol_roles (self:occurrence) (x:int32) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 1); self.symbol_roles <- x
let[@inline] occurrence_set_override_documentation (self:occurrence) (x:string list) : unit =
  self.override_documentation <- x
let[@inline] occurrence_set_syntax_kind (self:occurrence) (x:syntax_kind) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 2); self.syntax_kind <- x
let[@inline] occurrence_set_diagnostics (self:occurrence) (x:diagnostic list) : unit =
  self.diagnostics <- x

let copy_occurrence (self:occurrence) : occurrence =
  { self with range = self.range }

let make_occurrence 
  ?(range=[])
  ?(symbol:string option)
  ?(symbol_roles:int32 option)
  ?(override_documentation=[])
  ?(syntax_kind:syntax_kind option)
  ?(diagnostics=[])
  () : occurrence  =
  let _res = default_occurrence () in
  occurrence_set_range _res range;
  (match symbol with
  | None -> ()
  | Some v -> occurrence_set_symbol _res v);
  (match symbol_roles with
  | None -> ()
  | Some v -> occurrence_set_symbol_roles _res v);
  occurrence_set_override_documentation _res override_documentation;
  (match syntax_kind with
  | None -> ()
  | Some v -> occurrence_set_syntax_kind _res v);
  occurrence_set_diagnostics _res diagnostics;
  _res

let[@inline] relationship_has_symbol (self:relationship) : bool = (Pbrt.Bitfield.get self._presence 0)
let[@inline] relationship_has_is_reference (self:relationship) : bool = (Pbrt.Bitfield.get self._presence 1)
let[@inline] relationship_has_is_implementation (self:relationship) : bool = (Pbrt.Bitfield.get self._presence 2)
let[@inline] relationship_has_is_type_definition (self:relationship) : bool = (Pbrt.Bitfield.get self._presence 3)
let[@inline] relationship_has_is_definition (self:relationship) : bool = (Pbrt.Bitfield.get self._presence 4)

let[@inline] relationship_set_symbol (self:relationship) (x:string) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 0); self.symbol <- x
let[@inline] relationship_set_is_reference (self:relationship) (x:bool) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 1); self.is_reference <- x
let[@inline] relationship_set_is_implementation (self:relationship) (x:bool) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 2); self.is_implementation <- x
let[@inline] relationship_set_is_type_definition (self:relationship) (x:bool) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 3); self.is_type_definition <- x
let[@inline] relationship_set_is_definition (self:relationship) (x:bool) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 4); self.is_definition <- x

let copy_relationship (self:relationship) : relationship =
  { self with symbol = self.symbol }

let make_relationship 
  ?(symbol:string option)
  ?(is_reference:bool option)
  ?(is_implementation:bool option)
  ?(is_type_definition:bool option)
  ?(is_definition:bool option)
  () : relationship  =
  let _res = default_relationship () in
  (match symbol with
  | None -> ()
  | Some v -> relationship_set_symbol _res v);
  (match is_reference with
  | None -> ()
  | Some v -> relationship_set_is_reference _res v);
  (match is_implementation with
  | None -> ()
  | Some v -> relationship_set_is_implementation _res v);
  (match is_type_definition with
  | None -> ()
  | Some v -> relationship_set_is_type_definition _res v);
  (match is_definition with
  | None -> ()
  | Some v -> relationship_set_is_definition _res v);
  _res

let[@inline] symbol_information_has_symbol (self:symbol_information) : bool = (Pbrt.Bitfield.get self._presence 0)

let[@inline] symbol_information_set_symbol (self:symbol_information) (x:string) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 0); self.symbol <- x
let[@inline] symbol_information_set_documentation (self:symbol_information) (x:string list) : unit =
  self.documentation <- x
let[@inline] symbol_information_set_relationships (self:symbol_information) (x:relationship list) : unit =
  self.relationships <- x

let copy_symbol_information (self:symbol_information) : symbol_information =
  { self with symbol = self.symbol }

let make_symbol_information 
  ?(symbol:string option)
  ?(documentation=[])
  ?(relationships=[])
  () : symbol_information  =
  let _res = default_symbol_information () in
  (match symbol with
  | None -> ()
  | Some v -> symbol_information_set_symbol _res v);
  symbol_information_set_documentation _res documentation;
  symbol_information_set_relationships _res relationships;
  _res

let[@inline] document_has_language (self:document) : bool = (Pbrt.Bitfield.get self._presence 0)
let[@inline] document_has_relative_path (self:document) : bool = (Pbrt.Bitfield.get self._presence 1)

let[@inline] document_set_language (self:document) (x:string) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 0); self.language <- x
let[@inline] document_set_relative_path (self:document) (x:string) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 1); self.relative_path <- x
let[@inline] document_set_occurrences (self:document) (x:occurrence list) : unit =
  self.occurrences <- x
let[@inline] document_set_symbols (self:document) (x:symbol_information list) : unit =
  self.symbols <- x

let copy_document (self:document) : document =
  { self with language = self.language }

let make_document 
  ?(language:string option)
  ?(relative_path:string option)
  ?(occurrences=[])
  ?(symbols=[])
  () : document  =
  let _res = default_document () in
  (match language with
  | None -> ()
  | Some v -> document_set_language _res v);
  (match relative_path with
  | None -> ()
  | Some v -> document_set_relative_path _res v);
  document_set_occurrences _res occurrences;
  document_set_symbols _res symbols;
  _res

let[@inline] index_has_metadata (self:index) : bool = self.metadata != None

let[@inline] index_set_metadata (self:index) (x:metadata) : unit =
  self.metadata <- Some x
let[@inline] index_set_documents (self:index) (x:document list) : unit =
  self.documents <- x
let[@inline] index_set_external_symbols (self:index) (x:symbol_information list) : unit =
  self.external_symbols <- x

let copy_index (self:index) : index =
  { self with metadata = self.metadata }

let make_index 
  ?(metadata:metadata option)
  ?(documents=[])
  ?(external_symbols=[])
  () : index  =
  let _res = default_index () in
  (match metadata with
  | None -> ()
  | Some v -> index_set_metadata _res v);
  index_set_documents _res documents;
  index_set_external_symbols _res external_symbols;
  _res

let[@inline] package_has_manager (self:package) : bool = (Pbrt.Bitfield.get self._presence 0)
let[@inline] package_has_name (self:package) : bool = (Pbrt.Bitfield.get self._presence 1)
let[@inline] package_has_version (self:package) : bool = (Pbrt.Bitfield.get self._presence 2)

let[@inline] package_set_manager (self:package) (x:string) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 0); self.manager <- x
let[@inline] package_set_name (self:package) (x:string) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 1); self.name <- x
let[@inline] package_set_version (self:package) (x:string) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 2); self.version <- x

let copy_package (self:package) : package =
  { self with manager = self.manager }

let make_package 
  ?(manager:string option)
  ?(name:string option)
  ?(version:string option)
  () : package  =
  let _res = default_package () in
  (match manager with
  | None -> ()
  | Some v -> package_set_manager _res v);
  (match name with
  | None -> ()
  | Some v -> package_set_name _res v);
  (match version with
  | None -> ()
  | Some v -> package_set_version _res v);
  _res

let[@inline] descriptor_has_name (self:descriptor) : bool = (Pbrt.Bitfield.get self._presence 0)
let[@inline] descriptor_has_disambiguator (self:descriptor) : bool = (Pbrt.Bitfield.get self._presence 1)
let[@inline] descriptor_has_suffix (self:descriptor) : bool = (Pbrt.Bitfield.get self._presence 2)

let[@inline] descriptor_set_name (self:descriptor) (x:string) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 0); self.name <- x
let[@inline] descriptor_set_disambiguator (self:descriptor) (x:string) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 1); self.disambiguator <- x
let[@inline] descriptor_set_suffix (self:descriptor) (x:descriptor_suffix) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 2); self.suffix <- x

let copy_descriptor (self:descriptor) : descriptor =
  { self with name = self.name }

let make_descriptor 
  ?(name:string option)
  ?(disambiguator:string option)
  ?(suffix:descriptor_suffix option)
  () : descriptor  =
  let _res = default_descriptor () in
  (match name with
  | None -> ()
  | Some v -> descriptor_set_name _res v);
  (match disambiguator with
  | None -> ()
  | Some v -> descriptor_set_disambiguator _res v);
  (match suffix with
  | None -> ()
  | Some v -> descriptor_set_suffix _res v);
  _res

let[@inline] symbol_has_scheme (self:symbol) : bool = (Pbrt.Bitfield.get self._presence 0)
let[@inline] symbol_has_package (self:symbol) : bool = self.package != None

let[@inline] symbol_set_scheme (self:symbol) (x:string) : unit =
  self._presence <- (Pbrt.Bitfield.set self._presence 0); self.scheme <- x
let[@inline] symbol_set_package (self:symbol) (x:package) : unit =
  self.package <- Some x
let[@inline] symbol_set_descriptors (self:symbol) (x:descriptor list) : unit =
  self.descriptors <- x

let copy_symbol (self:symbol) : symbol =
  { self with scheme = self.scheme }

let make_symbol 
  ?(scheme:string option)
  ?(package:package option)
  ?(descriptors=[])
  () : symbol  =
  let _res = default_symbol () in
  (match scheme with
  | None -> ()
  | Some v -> symbol_set_scheme _res v);
  (match package with
  | None -> ()
  | Some v -> symbol_set_package _res v);
  symbol_set_descriptors _res descriptors;
  _res

[@@@ocaml.warning "-23-27-30-39"]

(** {2 Formatters} *)

let rec pp_protocol_version fmt (v:protocol_version) =
  match v with
  | Unspecified_protocol_version -> Format.fprintf fmt "Unspecified_protocol_version"

let rec pp_tool_info fmt (v:tool_info) = 
  let pp_i fmt () =
    Pbrt.Pp.pp_record_field ~absent:(not (tool_info_has_name v)) ~first:true "name" Pbrt.Pp.pp_string fmt v.name;
    Pbrt.Pp.pp_record_field ~absent:(not (tool_info_has_version v)) ~first:false "version" Pbrt.Pp.pp_string fmt v.version;
    Pbrt.Pp.pp_record_field ~first:false "arguments" (Pbrt.Pp.pp_list Pbrt.Pp.pp_string) fmt v.arguments;
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_text_encoding fmt (v:text_encoding) =
  match v with
  | Unspecified_text_encoding -> Format.fprintf fmt "Unspecified_text_encoding"
  | Utf8 -> Format.fprintf fmt "Utf8"
  | Utf16 -> Format.fprintf fmt "Utf16"

let rec pp_metadata fmt (v:metadata) = 
  let pp_i fmt () =
    Pbrt.Pp.pp_record_field ~absent:(not (metadata_has_version v)) ~first:true "version" pp_protocol_version fmt v.version;
    Pbrt.Pp.pp_record_field ~first:false "tool_info" (Pbrt.Pp.pp_option pp_tool_info) fmt v.tool_info;
    Pbrt.Pp.pp_record_field ~absent:(not (metadata_has_project_root v)) ~first:false "project_root" Pbrt.Pp.pp_string fmt v.project_root;
    Pbrt.Pp.pp_record_field ~absent:(not (metadata_has_text_document_encoding v)) ~first:false "text_document_encoding" pp_text_encoding fmt v.text_document_encoding;
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_syntax_kind fmt (v:syntax_kind) =
  match v with
  | Unspecified_syntax_kind -> Format.fprintf fmt "Unspecified_syntax_kind"
  | Comment -> Format.fprintf fmt "Comment"
  | Punctuation_delimiter -> Format.fprintf fmt "Punctuation_delimiter"
  | Punctuation_bracket -> Format.fprintf fmt "Punctuation_bracket"
  | Keyword -> Format.fprintf fmt "Keyword"
  | Identifier_keyword -> Format.fprintf fmt "Identifier_keyword"
  | Identifier_operator -> Format.fprintf fmt "Identifier_operator"
  | Identifier -> Format.fprintf fmt "Identifier"
  | Identifier_builtin -> Format.fprintf fmt "Identifier_builtin"
  | Identifier_null -> Format.fprintf fmt "Identifier_null"
  | Identifier_constant -> Format.fprintf fmt "Identifier_constant"
  | Identifier_mutable_global -> Format.fprintf fmt "Identifier_mutable_global"
  | Identifier_parameter -> Format.fprintf fmt "Identifier_parameter"
  | Identifier_local -> Format.fprintf fmt "Identifier_local"
  | Identifier_shadowed -> Format.fprintf fmt "Identifier_shadowed"
  | Identifier_namespace -> Format.fprintf fmt "Identifier_namespace"
  | Identifier_module -> Format.fprintf fmt "Identifier_module"
  | Identifier_function -> Format.fprintf fmt "Identifier_function"
  | Identifier_function_definition -> Format.fprintf fmt "Identifier_function_definition"
  | Identifier_macro -> Format.fprintf fmt "Identifier_macro"
  | Identifier_macro_definition -> Format.fprintf fmt "Identifier_macro_definition"
  | Identifier_type -> Format.fprintf fmt "Identifier_type"
  | Identifier_builtin_type -> Format.fprintf fmt "Identifier_builtin_type"
  | Identifier_attribute -> Format.fprintf fmt "Identifier_attribute"
  | Regex_escape -> Format.fprintf fmt "Regex_escape"
  | Regex_repeated -> Format.fprintf fmt "Regex_repeated"
  | Regex_wildcard -> Format.fprintf fmt "Regex_wildcard"
  | Regex_delimiter -> Format.fprintf fmt "Regex_delimiter"
  | Regex_join -> Format.fprintf fmt "Regex_join"
  | String_literal -> Format.fprintf fmt "String_literal"
  | String_literal_escape -> Format.fprintf fmt "String_literal_escape"
  | String_literal_special -> Format.fprintf fmt "String_literal_special"
  | String_literal_key -> Format.fprintf fmt "String_literal_key"
  | Character_literal -> Format.fprintf fmt "Character_literal"
  | Numeric_literal -> Format.fprintf fmt "Numeric_literal"
  | Boolean_literal -> Format.fprintf fmt "Boolean_literal"
  | Tag -> Format.fprintf fmt "Tag"
  | Tag_attribute -> Format.fprintf fmt "Tag_attribute"
  | Tag_delimiter -> Format.fprintf fmt "Tag_delimiter"

let rec pp_severity fmt (v:severity) =
  match v with
  | Unspecified_severity -> Format.fprintf fmt "Unspecified_severity"
  | Error -> Format.fprintf fmt "Error"
  | Warning -> Format.fprintf fmt "Warning"
  | Information -> Format.fprintf fmt "Information"
  | Hint -> Format.fprintf fmt "Hint"

let rec pp_diagnostic_tag fmt (v:diagnostic_tag) =
  match v with
  | Unspecified_diagnostic_tag -> Format.fprintf fmt "Unspecified_diagnostic_tag"
  | Unnecessary -> Format.fprintf fmt "Unnecessary"
  | Deprecated -> Format.fprintf fmt "Deprecated"

let rec pp_diagnostic fmt (v:diagnostic) = 
  let pp_i fmt () =
    Pbrt.Pp.pp_record_field ~absent:(not (diagnostic_has_severity v)) ~first:true "severity" pp_severity fmt v.severity;
    Pbrt.Pp.pp_record_field ~absent:(not (diagnostic_has_code v)) ~first:false "code" Pbrt.Pp.pp_string fmt v.code;
    Pbrt.Pp.pp_record_field ~absent:(not (diagnostic_has_message v)) ~first:false "message" Pbrt.Pp.pp_string fmt v.message;
    Pbrt.Pp.pp_record_field ~absent:(not (diagnostic_has_source v)) ~first:false "source" Pbrt.Pp.pp_string fmt v.source;
    Pbrt.Pp.pp_record_field ~first:false "tags" (Pbrt.Pp.pp_list pp_diagnostic_tag) fmt v.tags;
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_occurrence fmt (v:occurrence) = 
  let pp_i fmt () =
    Pbrt.Pp.pp_record_field ~first:true "range" (Pbrt.Pp.pp_list Pbrt.Pp.pp_int32) fmt v.range;
    Pbrt.Pp.pp_record_field ~absent:(not (occurrence_has_symbol v)) ~first:false "symbol" Pbrt.Pp.pp_string fmt v.symbol;
    Pbrt.Pp.pp_record_field ~absent:(not (occurrence_has_symbol_roles v)) ~first:false "symbol_roles" Pbrt.Pp.pp_int32 fmt v.symbol_roles;
    Pbrt.Pp.pp_record_field ~first:false "override_documentation" (Pbrt.Pp.pp_list Pbrt.Pp.pp_string) fmt v.override_documentation;
    Pbrt.Pp.pp_record_field ~absent:(not (occurrence_has_syntax_kind v)) ~first:false "syntax_kind" pp_syntax_kind fmt v.syntax_kind;
    Pbrt.Pp.pp_record_field ~first:false "diagnostics" (Pbrt.Pp.pp_list pp_diagnostic) fmt v.diagnostics;
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_relationship fmt (v:relationship) = 
  let pp_i fmt () =
    Pbrt.Pp.pp_record_field ~absent:(not (relationship_has_symbol v)) ~first:true "symbol" Pbrt.Pp.pp_string fmt v.symbol;
    Pbrt.Pp.pp_record_field ~absent:(not (relationship_has_is_reference v)) ~first:false "is_reference" Pbrt.Pp.pp_bool fmt v.is_reference;
    Pbrt.Pp.pp_record_field ~absent:(not (relationship_has_is_implementation v)) ~first:false "is_implementation" Pbrt.Pp.pp_bool fmt v.is_implementation;
    Pbrt.Pp.pp_record_field ~absent:(not (relationship_has_is_type_definition v)) ~first:false "is_type_definition" Pbrt.Pp.pp_bool fmt v.is_type_definition;
    Pbrt.Pp.pp_record_field ~absent:(not (relationship_has_is_definition v)) ~first:false "is_definition" Pbrt.Pp.pp_bool fmt v.is_definition;
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_symbol_information fmt (v:symbol_information) = 
  let pp_i fmt () =
    Pbrt.Pp.pp_record_field ~absent:(not (symbol_information_has_symbol v)) ~first:true "symbol" Pbrt.Pp.pp_string fmt v.symbol;
    Pbrt.Pp.pp_record_field ~first:false "documentation" (Pbrt.Pp.pp_list Pbrt.Pp.pp_string) fmt v.documentation;
    Pbrt.Pp.pp_record_field ~first:false "relationships" (Pbrt.Pp.pp_list pp_relationship) fmt v.relationships;
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_document fmt (v:document) = 
  let pp_i fmt () =
    Pbrt.Pp.pp_record_field ~absent:(not (document_has_language v)) ~first:true "language" Pbrt.Pp.pp_string fmt v.language;
    Pbrt.Pp.pp_record_field ~absent:(not (document_has_relative_path v)) ~first:false "relative_path" Pbrt.Pp.pp_string fmt v.relative_path;
    Pbrt.Pp.pp_record_field ~first:false "occurrences" (Pbrt.Pp.pp_list pp_occurrence) fmt v.occurrences;
    Pbrt.Pp.pp_record_field ~first:false "symbols" (Pbrt.Pp.pp_list pp_symbol_information) fmt v.symbols;
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_index fmt (v:index) = 
  let pp_i fmt () =
    Pbrt.Pp.pp_record_field ~first:true "metadata" (Pbrt.Pp.pp_option pp_metadata) fmt v.metadata;
    Pbrt.Pp.pp_record_field ~first:false "documents" (Pbrt.Pp.pp_list pp_document) fmt v.documents;
    Pbrt.Pp.pp_record_field ~first:false "external_symbols" (Pbrt.Pp.pp_list pp_symbol_information) fmt v.external_symbols;
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_package fmt (v:package) = 
  let pp_i fmt () =
    Pbrt.Pp.pp_record_field ~absent:(not (package_has_manager v)) ~first:true "manager" Pbrt.Pp.pp_string fmt v.manager;
    Pbrt.Pp.pp_record_field ~absent:(not (package_has_name v)) ~first:false "name" Pbrt.Pp.pp_string fmt v.name;
    Pbrt.Pp.pp_record_field ~absent:(not (package_has_version v)) ~first:false "version" Pbrt.Pp.pp_string fmt v.version;
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_descriptor_suffix fmt (v:descriptor_suffix) =
  match v with
  | Unspecified_suffix -> Format.fprintf fmt "Unspecified_suffix"
  | Namespace -> Format.fprintf fmt "Namespace"
  | Package -> Format.fprintf fmt "Package"
  | Type -> Format.fprintf fmt "Type"
  | Term -> Format.fprintf fmt "Term"
  | Method -> Format.fprintf fmt "Method"
  | Type_parameter -> Format.fprintf fmt "Type_parameter"
  | Parameter -> Format.fprintf fmt "Parameter"
  | Macro -> Format.fprintf fmt "Macro"
  | Meta -> Format.fprintf fmt "Meta"
  | Local -> Format.fprintf fmt "Local"

let rec pp_descriptor fmt (v:descriptor) = 
  let pp_i fmt () =
    Pbrt.Pp.pp_record_field ~absent:(not (descriptor_has_name v)) ~first:true "name" Pbrt.Pp.pp_string fmt v.name;
    Pbrt.Pp.pp_record_field ~absent:(not (descriptor_has_disambiguator v)) ~first:false "disambiguator" Pbrt.Pp.pp_string fmt v.disambiguator;
    Pbrt.Pp.pp_record_field ~absent:(not (descriptor_has_suffix v)) ~first:false "suffix" pp_descriptor_suffix fmt v.suffix;
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_symbol fmt (v:symbol) = 
  let pp_i fmt () =
    Pbrt.Pp.pp_record_field ~absent:(not (symbol_has_scheme v)) ~first:true "scheme" Pbrt.Pp.pp_string fmt v.scheme;
    Pbrt.Pp.pp_record_field ~first:false "package" (Pbrt.Pp.pp_option pp_package) fmt v.package;
    Pbrt.Pp.pp_record_field ~first:false "descriptors" (Pbrt.Pp.pp_list pp_descriptor) fmt v.descriptors;
  in
  Pbrt.Pp.pp_brk pp_i fmt ()

let rec pp_symbol_role fmt (v:symbol_role) =
  match v with
  | Unspecified_symbol_role -> Format.fprintf fmt "Unspecified_symbol_role"
  | Definition -> Format.fprintf fmt "Definition"
  | Import -> Format.fprintf fmt "Import"
  | Write_access -> Format.fprintf fmt "Write_access"
  | Read_access -> Format.fprintf fmt "Read_access"
  | Generated -> Format.fprintf fmt "Generated"
  | Test -> Format.fprintf fmt "Test"

let rec pp_language fmt (v:language) =
  match v with
  | Unspecified_language -> Format.fprintf fmt "Unspecified_language"
  | Abap -> Format.fprintf fmt "Abap"
  | Apl -> Format.fprintf fmt "Apl"
  | Ada -> Format.fprintf fmt "Ada"
  | Agda -> Format.fprintf fmt "Agda"
  | Ascii_doc -> Format.fprintf fmt "Ascii_doc"
  | Assembly -> Format.fprintf fmt "Assembly"
  | Awk -> Format.fprintf fmt "Awk"
  | Bat -> Format.fprintf fmt "Bat"
  | Bib_te_x -> Format.fprintf fmt "Bib_te_x"
  | C -> Format.fprintf fmt "C"
  | Cobol -> Format.fprintf fmt "Cobol"
  | Cpp -> Format.fprintf fmt "Cpp"
  | Css -> Format.fprintf fmt "Css"
  | Csharp -> Format.fprintf fmt "Csharp"
  | Clojure -> Format.fprintf fmt "Clojure"
  | Coffeescript -> Format.fprintf fmt "Coffeescript"
  | Common_lisp -> Format.fprintf fmt "Common_lisp"
  | Coq -> Format.fprintf fmt "Coq"
  | Dart -> Format.fprintf fmt "Dart"
  | Delphi -> Format.fprintf fmt "Delphi"
  | Diff -> Format.fprintf fmt "Diff"
  | Dockerfile -> Format.fprintf fmt "Dockerfile"
  | Dyalog -> Format.fprintf fmt "Dyalog"
  | Elixir -> Format.fprintf fmt "Elixir"
  | Erlang -> Format.fprintf fmt "Erlang"
  | Fsharp -> Format.fprintf fmt "Fsharp"
  | Fish -> Format.fprintf fmt "Fish"
  | Flow -> Format.fprintf fmt "Flow"
  | Fortran -> Format.fprintf fmt "Fortran"
  | Git_commit -> Format.fprintf fmt "Git_commit"
  | Git_config -> Format.fprintf fmt "Git_config"
  | Git_rebase -> Format.fprintf fmt "Git_rebase"
  | Go -> Format.fprintf fmt "Go"
  | Groovy -> Format.fprintf fmt "Groovy"
  | Html -> Format.fprintf fmt "Html"
  | Hack -> Format.fprintf fmt "Hack"
  | Handlebars -> Format.fprintf fmt "Handlebars"
  | Haskell -> Format.fprintf fmt "Haskell"
  | Idris -> Format.fprintf fmt "Idris"
  | Ini -> Format.fprintf fmt "Ini"
  | J -> Format.fprintf fmt "J"
  | Json -> Format.fprintf fmt "Json"
  | Java -> Format.fprintf fmt "Java"
  | Java_script -> Format.fprintf fmt "Java_script"
  | Java_script_react -> Format.fprintf fmt "Java_script_react"
  | Jsonnet -> Format.fprintf fmt "Jsonnet"
  | Julia -> Format.fprintf fmt "Julia"
  | Kotlin -> Format.fprintf fmt "Kotlin"
  | La_te_x -> Format.fprintf fmt "La_te_x"
  | Lean -> Format.fprintf fmt "Lean"
  | Less -> Format.fprintf fmt "Less"
  | Lua -> Format.fprintf fmt "Lua"
  | Makefile -> Format.fprintf fmt "Makefile"
  | Markdown -> Format.fprintf fmt "Markdown"
  | Matlab -> Format.fprintf fmt "Matlab"
  | Nix -> Format.fprintf fmt "Nix"
  | Ocaml -> Format.fprintf fmt "Ocaml"
  | Objective_c -> Format.fprintf fmt "Objective_c"
  | Objective_cpp -> Format.fprintf fmt "Objective_cpp"
  | Php -> Format.fprintf fmt "Php"
  | Plsql -> Format.fprintf fmt "Plsql"
  | Perl -> Format.fprintf fmt "Perl"
  | Power_shell -> Format.fprintf fmt "Power_shell"
  | Prolog -> Format.fprintf fmt "Prolog"
  | Python -> Format.fprintf fmt "Python"
  | R -> Format.fprintf fmt "R"
  | Racket -> Format.fprintf fmt "Racket"
  | Raku -> Format.fprintf fmt "Raku"
  | Razor -> Format.fprintf fmt "Razor"
  | Re_st -> Format.fprintf fmt "Re_st"
  | Ruby -> Format.fprintf fmt "Ruby"
  | Rust -> Format.fprintf fmt "Rust"
  | Sas -> Format.fprintf fmt "Sas"
  | Scss -> Format.fprintf fmt "Scss"
  | Sml -> Format.fprintf fmt "Sml"
  | Sql -> Format.fprintf fmt "Sql"
  | Sass -> Format.fprintf fmt "Sass"
  | Scala -> Format.fprintf fmt "Scala"
  | Scheme -> Format.fprintf fmt "Scheme"
  | Shell_script -> Format.fprintf fmt "Shell_script"
  | Skylark -> Format.fprintf fmt "Skylark"
  | Swift -> Format.fprintf fmt "Swift"
  | Toml -> Format.fprintf fmt "Toml"
  | Te_x -> Format.fprintf fmt "Te_x"
  | Type_script -> Format.fprintf fmt "Type_script"
  | Type_script_react -> Format.fprintf fmt "Type_script_react"
  | Visual_basic -> Format.fprintf fmt "Visual_basic"
  | Vue -> Format.fprintf fmt "Vue"
  | Wolfram -> Format.fprintf fmt "Wolfram"
  | Xml -> Format.fprintf fmt "Xml"
  | Xsl -> Format.fprintf fmt "Xsl"
  | Yaml -> Format.fprintf fmt "Yaml"
  | Zig -> Format.fprintf fmt "Zig"

[@@@ocaml.warning "-23-27-30-39"]

(** {2 Protobuf Encoding} *)

let rec encode_pb_protocol_version (v:protocol_version) encoder =
  match v with
  | Unspecified_protocol_version -> Pbrt.Encoder.int_as_varint (0) encoder

let rec encode_pb_tool_info (v:tool_info) encoder = 
  if tool_info_has_name v then (
    Pbrt.Encoder.string v.name encoder;
    Pbrt.Encoder.key 1 Pbrt.Bytes encoder; 
  );
  if tool_info_has_version v then (
    Pbrt.Encoder.string v.version encoder;
    Pbrt.Encoder.key 2 Pbrt.Bytes encoder; 
  );
  Pbrt.List_util.rev_iter_with (fun x encoder ->
    Pbrt.Encoder.string x encoder;
    Pbrt.Encoder.key 3 Pbrt.Bytes encoder; 
  ) v.arguments encoder;
  ()

let rec encode_pb_text_encoding (v:text_encoding) encoder =
  match v with
  | Unspecified_text_encoding -> Pbrt.Encoder.int_as_varint (0) encoder
  | Utf8 -> Pbrt.Encoder.int_as_varint 1 encoder
  | Utf16 -> Pbrt.Encoder.int_as_varint 2 encoder

let rec encode_pb_metadata (v:metadata) encoder = 
  if metadata_has_version v then (
    encode_pb_protocol_version v.version encoder;
    Pbrt.Encoder.key 1 Pbrt.Varint encoder; 
  );
  begin match v.tool_info with
  | Some x -> 
    Pbrt.Encoder.nested encode_pb_tool_info x encoder;
    Pbrt.Encoder.key 2 Pbrt.Bytes encoder; 
  | None -> ();
  end;
  if metadata_has_project_root v then (
    Pbrt.Encoder.string v.project_root encoder;
    Pbrt.Encoder.key 3 Pbrt.Bytes encoder; 
  );
  if metadata_has_text_document_encoding v then (
    encode_pb_text_encoding v.text_document_encoding encoder;
    Pbrt.Encoder.key 4 Pbrt.Varint encoder; 
  );
  ()

let rec encode_pb_syntax_kind (v:syntax_kind) encoder =
  match v with
  | Unspecified_syntax_kind -> Pbrt.Encoder.int_as_varint (0) encoder
  | Comment -> Pbrt.Encoder.int_as_varint 1 encoder
  | Punctuation_delimiter -> Pbrt.Encoder.int_as_varint 2 encoder
  | Punctuation_bracket -> Pbrt.Encoder.int_as_varint 3 encoder
  | Keyword -> Pbrt.Encoder.int_as_varint 4 encoder
  | Identifier_keyword -> Pbrt.Encoder.int_as_varint 4 encoder
  | Identifier_operator -> Pbrt.Encoder.int_as_varint 5 encoder
  | Identifier -> Pbrt.Encoder.int_as_varint 6 encoder
  | Identifier_builtin -> Pbrt.Encoder.int_as_varint 7 encoder
  | Identifier_null -> Pbrt.Encoder.int_as_varint 8 encoder
  | Identifier_constant -> Pbrt.Encoder.int_as_varint 9 encoder
  | Identifier_mutable_global -> Pbrt.Encoder.int_as_varint 10 encoder
  | Identifier_parameter -> Pbrt.Encoder.int_as_varint 11 encoder
  | Identifier_local -> Pbrt.Encoder.int_as_varint 12 encoder
  | Identifier_shadowed -> Pbrt.Encoder.int_as_varint 13 encoder
  | Identifier_namespace -> Pbrt.Encoder.int_as_varint 14 encoder
  | Identifier_module -> Pbrt.Encoder.int_as_varint 14 encoder
  | Identifier_function -> Pbrt.Encoder.int_as_varint 15 encoder
  | Identifier_function_definition -> Pbrt.Encoder.int_as_varint 16 encoder
  | Identifier_macro -> Pbrt.Encoder.int_as_varint 17 encoder
  | Identifier_macro_definition -> Pbrt.Encoder.int_as_varint 18 encoder
  | Identifier_type -> Pbrt.Encoder.int_as_varint 19 encoder
  | Identifier_builtin_type -> Pbrt.Encoder.int_as_varint 20 encoder
  | Identifier_attribute -> Pbrt.Encoder.int_as_varint 21 encoder
  | Regex_escape -> Pbrt.Encoder.int_as_varint 22 encoder
  | Regex_repeated -> Pbrt.Encoder.int_as_varint 23 encoder
  | Regex_wildcard -> Pbrt.Encoder.int_as_varint 24 encoder
  | Regex_delimiter -> Pbrt.Encoder.int_as_varint 25 encoder
  | Regex_join -> Pbrt.Encoder.int_as_varint 26 encoder
  | String_literal -> Pbrt.Encoder.int_as_varint 27 encoder
  | String_literal_escape -> Pbrt.Encoder.int_as_varint 28 encoder
  | String_literal_special -> Pbrt.Encoder.int_as_varint 29 encoder
  | String_literal_key -> Pbrt.Encoder.int_as_varint 30 encoder
  | Character_literal -> Pbrt.Encoder.int_as_varint 31 encoder
  | Numeric_literal -> Pbrt.Encoder.int_as_varint 32 encoder
  | Boolean_literal -> Pbrt.Encoder.int_as_varint 33 encoder
  | Tag -> Pbrt.Encoder.int_as_varint 34 encoder
  | Tag_attribute -> Pbrt.Encoder.int_as_varint 35 encoder
  | Tag_delimiter -> Pbrt.Encoder.int_as_varint 36 encoder

let rec encode_pb_severity (v:severity) encoder =
  match v with
  | Unspecified_severity -> Pbrt.Encoder.int_as_varint (0) encoder
  | Error -> Pbrt.Encoder.int_as_varint 1 encoder
  | Warning -> Pbrt.Encoder.int_as_varint 2 encoder
  | Information -> Pbrt.Encoder.int_as_varint 3 encoder
  | Hint -> Pbrt.Encoder.int_as_varint 4 encoder

let rec encode_pb_diagnostic_tag (v:diagnostic_tag) encoder =
  match v with
  | Unspecified_diagnostic_tag -> Pbrt.Encoder.int_as_varint (0) encoder
  | Unnecessary -> Pbrt.Encoder.int_as_varint 1 encoder
  | Deprecated -> Pbrt.Encoder.int_as_varint 2 encoder

let rec encode_pb_diagnostic (v:diagnostic) encoder = 
  if diagnostic_has_severity v then (
    encode_pb_severity v.severity encoder;
    Pbrt.Encoder.key 1 Pbrt.Varint encoder; 
  );
  if diagnostic_has_code v then (
    Pbrt.Encoder.string v.code encoder;
    Pbrt.Encoder.key 2 Pbrt.Bytes encoder; 
  );
  if diagnostic_has_message v then (
    Pbrt.Encoder.string v.message encoder;
    Pbrt.Encoder.key 3 Pbrt.Bytes encoder; 
  );
  if diagnostic_has_source v then (
    Pbrt.Encoder.string v.source encoder;
    Pbrt.Encoder.key 4 Pbrt.Bytes encoder; 
  );
  Pbrt.List_util.rev_iter_with (fun x encoder ->
    encode_pb_diagnostic_tag x encoder;
    Pbrt.Encoder.key 5 Pbrt.Varint encoder; 
  ) v.tags encoder;
  ()

let rec encode_pb_occurrence (v:occurrence) encoder = 
  Pbrt.Encoder.nested (fun lst encoder ->
    Pbrt.List_util.rev_iter_with (fun x encoder ->
      Pbrt.Encoder.int32_as_varint x encoder;
    ) lst encoder;
  ) v.range encoder;
  Pbrt.Encoder.key 1 Pbrt.Bytes encoder; 
  if occurrence_has_symbol v then (
    Pbrt.Encoder.string v.symbol encoder;
    Pbrt.Encoder.key 2 Pbrt.Bytes encoder; 
  );
  if occurrence_has_symbol_roles v then (
    Pbrt.Encoder.int32_as_varint v.symbol_roles encoder;
    Pbrt.Encoder.key 3 Pbrt.Varint encoder; 
  );
  Pbrt.List_util.rev_iter_with (fun x encoder ->
    Pbrt.Encoder.string x encoder;
    Pbrt.Encoder.key 4 Pbrt.Bytes encoder; 
  ) v.override_documentation encoder;
  if occurrence_has_syntax_kind v then (
    encode_pb_syntax_kind v.syntax_kind encoder;
    Pbrt.Encoder.key 5 Pbrt.Varint encoder; 
  );
  Pbrt.List_util.rev_iter_with (fun x encoder ->
    Pbrt.Encoder.nested encode_pb_diagnostic x encoder;
    Pbrt.Encoder.key 6 Pbrt.Bytes encoder; 
  ) v.diagnostics encoder;
  ()

let rec encode_pb_relationship (v:relationship) encoder = 
  if relationship_has_symbol v then (
    Pbrt.Encoder.string v.symbol encoder;
    Pbrt.Encoder.key 1 Pbrt.Bytes encoder; 
  );
  if relationship_has_is_reference v then (
    Pbrt.Encoder.bool v.is_reference encoder;
    Pbrt.Encoder.key 2 Pbrt.Varint encoder; 
  );
  if relationship_has_is_implementation v then (
    Pbrt.Encoder.bool v.is_implementation encoder;
    Pbrt.Encoder.key 3 Pbrt.Varint encoder; 
  );
  if relationship_has_is_type_definition v then (
    Pbrt.Encoder.bool v.is_type_definition encoder;
    Pbrt.Encoder.key 4 Pbrt.Varint encoder; 
  );
  if relationship_has_is_definition v then (
    Pbrt.Encoder.bool v.is_definition encoder;
    Pbrt.Encoder.key 5 Pbrt.Varint encoder; 
  );
  ()

let rec encode_pb_symbol_information (v:symbol_information) encoder = 
  if symbol_information_has_symbol v then (
    Pbrt.Encoder.string v.symbol encoder;
    Pbrt.Encoder.key 1 Pbrt.Bytes encoder; 
  );
  Pbrt.List_util.rev_iter_with (fun x encoder ->
    Pbrt.Encoder.string x encoder;
    Pbrt.Encoder.key 3 Pbrt.Bytes encoder; 
  ) v.documentation encoder;
  Pbrt.List_util.rev_iter_with (fun x encoder ->
    Pbrt.Encoder.nested encode_pb_relationship x encoder;
    Pbrt.Encoder.key 4 Pbrt.Bytes encoder; 
  ) v.relationships encoder;
  ()

let rec encode_pb_document (v:document) encoder = 
  if document_has_language v then (
    Pbrt.Encoder.string v.language encoder;
    Pbrt.Encoder.key 4 Pbrt.Bytes encoder; 
  );
  if document_has_relative_path v then (
    Pbrt.Encoder.string v.relative_path encoder;
    Pbrt.Encoder.key 1 Pbrt.Bytes encoder; 
  );
  Pbrt.List_util.rev_iter_with (fun x encoder ->
    Pbrt.Encoder.nested encode_pb_occurrence x encoder;
    Pbrt.Encoder.key 2 Pbrt.Bytes encoder; 
  ) v.occurrences encoder;
  Pbrt.List_util.rev_iter_with (fun x encoder ->
    Pbrt.Encoder.nested encode_pb_symbol_information x encoder;
    Pbrt.Encoder.key 3 Pbrt.Bytes encoder; 
  ) v.symbols encoder;
  ()

let rec encode_pb_index (v:index) encoder = 
  begin match v.metadata with
  | Some x -> 
    Pbrt.Encoder.nested encode_pb_metadata x encoder;
    Pbrt.Encoder.key 1 Pbrt.Bytes encoder; 
  | None -> ();
  end;
  Pbrt.List_util.rev_iter_with (fun x encoder ->
    Pbrt.Encoder.nested encode_pb_document x encoder;
    Pbrt.Encoder.key 2 Pbrt.Bytes encoder; 
  ) v.documents encoder;
  Pbrt.List_util.rev_iter_with (fun x encoder ->
    Pbrt.Encoder.nested encode_pb_symbol_information x encoder;
    Pbrt.Encoder.key 3 Pbrt.Bytes encoder; 
  ) v.external_symbols encoder;
  ()

let rec encode_pb_package (v:package) encoder = 
  if package_has_manager v then (
    Pbrt.Encoder.string v.manager encoder;
    Pbrt.Encoder.key 1 Pbrt.Bytes encoder; 
  );
  if package_has_name v then (
    Pbrt.Encoder.string v.name encoder;
    Pbrt.Encoder.key 2 Pbrt.Bytes encoder; 
  );
  if package_has_version v then (
    Pbrt.Encoder.string v.version encoder;
    Pbrt.Encoder.key 3 Pbrt.Bytes encoder; 
  );
  ()

let rec encode_pb_descriptor_suffix (v:descriptor_suffix) encoder =
  match v with
  | Unspecified_suffix -> Pbrt.Encoder.int_as_varint (0) encoder
  | Namespace -> Pbrt.Encoder.int_as_varint 1 encoder
  | Package -> Pbrt.Encoder.int_as_varint 1 encoder
  | Type -> Pbrt.Encoder.int_as_varint 2 encoder
  | Term -> Pbrt.Encoder.int_as_varint 3 encoder
  | Method -> Pbrt.Encoder.int_as_varint 4 encoder
  | Type_parameter -> Pbrt.Encoder.int_as_varint 5 encoder
  | Parameter -> Pbrt.Encoder.int_as_varint 6 encoder
  | Macro -> Pbrt.Encoder.int_as_varint 9 encoder
  | Meta -> Pbrt.Encoder.int_as_varint 7 encoder
  | Local -> Pbrt.Encoder.int_as_varint 8 encoder

let rec encode_pb_descriptor (v:descriptor) encoder = 
  if descriptor_has_name v then (
    Pbrt.Encoder.string v.name encoder;
    Pbrt.Encoder.key 1 Pbrt.Bytes encoder; 
  );
  if descriptor_has_disambiguator v then (
    Pbrt.Encoder.string v.disambiguator encoder;
    Pbrt.Encoder.key 2 Pbrt.Bytes encoder; 
  );
  if descriptor_has_suffix v then (
    encode_pb_descriptor_suffix v.suffix encoder;
    Pbrt.Encoder.key 3 Pbrt.Varint encoder; 
  );
  ()

let rec encode_pb_symbol (v:symbol) encoder = 
  if symbol_has_scheme v then (
    Pbrt.Encoder.string v.scheme encoder;
    Pbrt.Encoder.key 1 Pbrt.Bytes encoder; 
  );
  begin match v.package with
  | Some x -> 
    Pbrt.Encoder.nested encode_pb_package x encoder;
    Pbrt.Encoder.key 2 Pbrt.Bytes encoder; 
  | None -> ();
  end;
  Pbrt.List_util.rev_iter_with (fun x encoder ->
    Pbrt.Encoder.nested encode_pb_descriptor x encoder;
    Pbrt.Encoder.key 3 Pbrt.Bytes encoder; 
  ) v.descriptors encoder;
  ()

let rec encode_pb_symbol_role (v:symbol_role) encoder =
  match v with
  | Unspecified_symbol_role -> Pbrt.Encoder.int_as_varint (0) encoder
  | Definition -> Pbrt.Encoder.int_as_varint 1 encoder
  | Import -> Pbrt.Encoder.int_as_varint 2 encoder
  | Write_access -> Pbrt.Encoder.int_as_varint 4 encoder
  | Read_access -> Pbrt.Encoder.int_as_varint 8 encoder
  | Generated -> Pbrt.Encoder.int_as_varint 16 encoder
  | Test -> Pbrt.Encoder.int_as_varint 32 encoder

let rec encode_pb_language (v:language) encoder =
  match v with
  | Unspecified_language -> Pbrt.Encoder.int_as_varint (0) encoder
  | Abap -> Pbrt.Encoder.int_as_varint 60 encoder
  | Apl -> Pbrt.Encoder.int_as_varint 49 encoder
  | Ada -> Pbrt.Encoder.int_as_varint 39 encoder
  | Agda -> Pbrt.Encoder.int_as_varint 45 encoder
  | Ascii_doc -> Pbrt.Encoder.int_as_varint 86 encoder
  | Assembly -> Pbrt.Encoder.int_as_varint 58 encoder
  | Awk -> Pbrt.Encoder.int_as_varint 66 encoder
  | Bat -> Pbrt.Encoder.int_as_varint 68 encoder
  | Bib_te_x -> Pbrt.Encoder.int_as_varint 81 encoder
  | C -> Pbrt.Encoder.int_as_varint 34 encoder
  | Cobol -> Pbrt.Encoder.int_as_varint 59 encoder
  | Cpp -> Pbrt.Encoder.int_as_varint 35 encoder
  | Css -> Pbrt.Encoder.int_as_varint 26 encoder
  | Csharp -> Pbrt.Encoder.int_as_varint 1 encoder
  | Clojure -> Pbrt.Encoder.int_as_varint 8 encoder
  | Coffeescript -> Pbrt.Encoder.int_as_varint 21 encoder
  | Common_lisp -> Pbrt.Encoder.int_as_varint 9 encoder
  | Coq -> Pbrt.Encoder.int_as_varint 47 encoder
  | Dart -> Pbrt.Encoder.int_as_varint 3 encoder
  | Delphi -> Pbrt.Encoder.int_as_varint 57 encoder
  | Diff -> Pbrt.Encoder.int_as_varint 88 encoder
  | Dockerfile -> Pbrt.Encoder.int_as_varint 80 encoder
  | Dyalog -> Pbrt.Encoder.int_as_varint 50 encoder
  | Elixir -> Pbrt.Encoder.int_as_varint 17 encoder
  | Erlang -> Pbrt.Encoder.int_as_varint 18 encoder
  | Fsharp -> Pbrt.Encoder.int_as_varint 42 encoder
  | Fish -> Pbrt.Encoder.int_as_varint 65 encoder
  | Flow -> Pbrt.Encoder.int_as_varint 24 encoder
  | Fortran -> Pbrt.Encoder.int_as_varint 56 encoder
  | Git_commit -> Pbrt.Encoder.int_as_varint 91 encoder
  | Git_config -> Pbrt.Encoder.int_as_varint 89 encoder
  | Git_rebase -> Pbrt.Encoder.int_as_varint 92 encoder
  | Go -> Pbrt.Encoder.int_as_varint 33 encoder
  | Groovy -> Pbrt.Encoder.int_as_varint 7 encoder
  | Html -> Pbrt.Encoder.int_as_varint 30 encoder
  | Hack -> Pbrt.Encoder.int_as_varint 20 encoder
  | Handlebars -> Pbrt.Encoder.int_as_varint 90 encoder
  | Haskell -> Pbrt.Encoder.int_as_varint 44 encoder
  | Idris -> Pbrt.Encoder.int_as_varint 46 encoder
  | Ini -> Pbrt.Encoder.int_as_varint 72 encoder
  | J -> Pbrt.Encoder.int_as_varint 51 encoder
  | Json -> Pbrt.Encoder.int_as_varint 75 encoder
  | Java -> Pbrt.Encoder.int_as_varint 6 encoder
  | Java_script -> Pbrt.Encoder.int_as_varint 22 encoder
  | Java_script_react -> Pbrt.Encoder.int_as_varint 93 encoder
  | Jsonnet -> Pbrt.Encoder.int_as_varint 76 encoder
  | Julia -> Pbrt.Encoder.int_as_varint 55 encoder
  | Kotlin -> Pbrt.Encoder.int_as_varint 4 encoder
  | La_te_x -> Pbrt.Encoder.int_as_varint 83 encoder
  | Lean -> Pbrt.Encoder.int_as_varint 48 encoder
  | Less -> Pbrt.Encoder.int_as_varint 27 encoder
  | Lua -> Pbrt.Encoder.int_as_varint 12 encoder
  | Makefile -> Pbrt.Encoder.int_as_varint 79 encoder
  | Markdown -> Pbrt.Encoder.int_as_varint 84 encoder
  | Matlab -> Pbrt.Encoder.int_as_varint 52 encoder
  | Nix -> Pbrt.Encoder.int_as_varint 77 encoder
  | Ocaml -> Pbrt.Encoder.int_as_varint 41 encoder
  | Objective_c -> Pbrt.Encoder.int_as_varint 36 encoder
  | Objective_cpp -> Pbrt.Encoder.int_as_varint 37 encoder
  | Php -> Pbrt.Encoder.int_as_varint 19 encoder
  | Plsql -> Pbrt.Encoder.int_as_varint 70 encoder
  | Perl -> Pbrt.Encoder.int_as_varint 13 encoder
  | Power_shell -> Pbrt.Encoder.int_as_varint 67 encoder
  | Prolog -> Pbrt.Encoder.int_as_varint 71 encoder
  | Python -> Pbrt.Encoder.int_as_varint 15 encoder
  | R -> Pbrt.Encoder.int_as_varint 54 encoder
  | Racket -> Pbrt.Encoder.int_as_varint 11 encoder
  | Raku -> Pbrt.Encoder.int_as_varint 14 encoder
  | Razor -> Pbrt.Encoder.int_as_varint 62 encoder
  | Re_st -> Pbrt.Encoder.int_as_varint 85 encoder
  | Ruby -> Pbrt.Encoder.int_as_varint 16 encoder
  | Rust -> Pbrt.Encoder.int_as_varint 40 encoder
  | Sas -> Pbrt.Encoder.int_as_varint 61 encoder
  | Scss -> Pbrt.Encoder.int_as_varint 29 encoder
  | Sml -> Pbrt.Encoder.int_as_varint 43 encoder
  | Sql -> Pbrt.Encoder.int_as_varint 69 encoder
  | Sass -> Pbrt.Encoder.int_as_varint 28 encoder
  | Scala -> Pbrt.Encoder.int_as_varint 5 encoder
  | Scheme -> Pbrt.Encoder.int_as_varint 10 encoder
  | Shell_script -> Pbrt.Encoder.int_as_varint 64 encoder
  | Skylark -> Pbrt.Encoder.int_as_varint 78 encoder
  | Swift -> Pbrt.Encoder.int_as_varint 2 encoder
  | Toml -> Pbrt.Encoder.int_as_varint 73 encoder
  | Te_x -> Pbrt.Encoder.int_as_varint 82 encoder
  | Type_script -> Pbrt.Encoder.int_as_varint 23 encoder
  | Type_script_react -> Pbrt.Encoder.int_as_varint 94 encoder
  | Visual_basic -> Pbrt.Encoder.int_as_varint 63 encoder
  | Vue -> Pbrt.Encoder.int_as_varint 25 encoder
  | Wolfram -> Pbrt.Encoder.int_as_varint 53 encoder
  | Xml -> Pbrt.Encoder.int_as_varint 31 encoder
  | Xsl -> Pbrt.Encoder.int_as_varint 32 encoder
  | Yaml -> Pbrt.Encoder.int_as_varint 74 encoder
  | Zig -> Pbrt.Encoder.int_as_varint 38 encoder

[@@@ocaml.warning "-23-27-30-39"]

(** {2 Protobuf Decoding} *)

let rec decode_pb_protocol_version d : protocol_version = 
  match Pbrt.Decoder.int_as_varint d with
  | 0 -> Unspecified_protocol_version
  | _ -> Pbrt.Decoder.malformed_variant "protocol_version"

let rec decode_pb_tool_info d =
  let v = default_tool_info () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
      (* put lists in the correct order *)
      tool_info_set_arguments v (List.rev v.arguments);
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      tool_info_set_name v (Pbrt.Decoder.string d);
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "tool_info" 1 pk
    | Some (2, Pbrt.Bytes) -> begin
      tool_info_set_version v (Pbrt.Decoder.string d);
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "tool_info" 2 pk
    | Some (3, Pbrt.Bytes) -> begin
      tool_info_set_arguments v ((Pbrt.Decoder.string d) :: v.arguments);
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "tool_info" 3 pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  (v : tool_info)

let rec decode_pb_text_encoding d : text_encoding = 
  match Pbrt.Decoder.int_as_varint d with
  | 0 -> Unspecified_text_encoding
  | 1 -> Utf8
  | 2 -> Utf16
  | _ -> Pbrt.Decoder.malformed_variant "text_encoding"

let rec decode_pb_metadata d =
  let v = default_metadata () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Varint) -> begin
      metadata_set_version v (decode_pb_protocol_version d);
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "metadata" 1 pk
    | Some (2, Pbrt.Bytes) -> begin
      metadata_set_tool_info v (decode_pb_tool_info (Pbrt.Decoder.nested d));
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "metadata" 2 pk
    | Some (3, Pbrt.Bytes) -> begin
      metadata_set_project_root v (Pbrt.Decoder.string d);
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "metadata" 3 pk
    | Some (4, Pbrt.Varint) -> begin
      metadata_set_text_document_encoding v (decode_pb_text_encoding d);
    end
    | Some (4, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "metadata" 4 pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  (v : metadata)

let rec decode_pb_syntax_kind d : syntax_kind = 
  match Pbrt.Decoder.int_as_varint d with
  | 0 -> Unspecified_syntax_kind
  | 1 -> Comment
  | 2 -> Punctuation_delimiter
  | 3 -> Punctuation_bracket
  | 4 -> Keyword
  | 4 -> Identifier_keyword
  | 5 -> Identifier_operator
  | 6 -> Identifier
  | 7 -> Identifier_builtin
  | 8 -> Identifier_null
  | 9 -> Identifier_constant
  | 10 -> Identifier_mutable_global
  | 11 -> Identifier_parameter
  | 12 -> Identifier_local
  | 13 -> Identifier_shadowed
  | 14 -> Identifier_namespace
  | 14 -> Identifier_module
  | 15 -> Identifier_function
  | 16 -> Identifier_function_definition
  | 17 -> Identifier_macro
  | 18 -> Identifier_macro_definition
  | 19 -> Identifier_type
  | 20 -> Identifier_builtin_type
  | 21 -> Identifier_attribute
  | 22 -> Regex_escape
  | 23 -> Regex_repeated
  | 24 -> Regex_wildcard
  | 25 -> Regex_delimiter
  | 26 -> Regex_join
  | 27 -> String_literal
  | 28 -> String_literal_escape
  | 29 -> String_literal_special
  | 30 -> String_literal_key
  | 31 -> Character_literal
  | 32 -> Numeric_literal
  | 33 -> Boolean_literal
  | 34 -> Tag
  | 35 -> Tag_attribute
  | 36 -> Tag_delimiter
  | _ -> Pbrt.Decoder.malformed_variant "syntax_kind"

let rec decode_pb_severity d : severity = 
  match Pbrt.Decoder.int_as_varint d with
  | 0 -> Unspecified_severity
  | 1 -> Error
  | 2 -> Warning
  | 3 -> Information
  | 4 -> Hint
  | _ -> Pbrt.Decoder.malformed_variant "severity"

let rec decode_pb_diagnostic_tag d : diagnostic_tag = 
  match Pbrt.Decoder.int_as_varint d with
  | 0 -> Unspecified_diagnostic_tag
  | 1 -> Unnecessary
  | 2 -> Deprecated
  | _ -> Pbrt.Decoder.malformed_variant "diagnostic_tag"

let rec decode_pb_diagnostic d =
  let v = default_diagnostic () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
      (* put lists in the correct order *)
      diagnostic_set_tags v (List.rev v.tags);
    ); continue__ := false
    | Some (1, Pbrt.Varint) -> begin
      diagnostic_set_severity v (decode_pb_severity d);
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "diagnostic" 1 pk
    | Some (2, Pbrt.Bytes) -> begin
      diagnostic_set_code v (Pbrt.Decoder.string d);
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "diagnostic" 2 pk
    | Some (3, Pbrt.Bytes) -> begin
      diagnostic_set_message v (Pbrt.Decoder.string d);
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "diagnostic" 3 pk
    | Some (4, Pbrt.Bytes) -> begin
      diagnostic_set_source v (Pbrt.Decoder.string d);
    end
    | Some (4, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "diagnostic" 4 pk
    | Some (5, Pbrt.Varint) -> begin
      diagnostic_set_tags v ((decode_pb_diagnostic_tag d) :: v.tags);
    end
    | Some (5, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "diagnostic" 5 pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  (v : diagnostic)

let rec decode_pb_occurrence d =
  let v = default_occurrence () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
      (* put lists in the correct order *)
      occurrence_set_diagnostics v (List.rev v.diagnostics);
      occurrence_set_override_documentation v (List.rev v.override_documentation);
      occurrence_set_range v (List.rev v.range);
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      occurrence_set_range v @@ Pbrt.Decoder.packed_fold (fun l d -> (Pbrt.Decoder.int32_as_varint d)::l) [] d;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "occurrence" 1 pk
    | Some (2, Pbrt.Bytes) -> begin
      occurrence_set_symbol v (Pbrt.Decoder.string d);
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "occurrence" 2 pk
    | Some (3, Pbrt.Varint) -> begin
      occurrence_set_symbol_roles v (Pbrt.Decoder.int32_as_varint d);
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "occurrence" 3 pk
    | Some (4, Pbrt.Bytes) -> begin
      occurrence_set_override_documentation v ((Pbrt.Decoder.string d) :: v.override_documentation);
    end
    | Some (4, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "occurrence" 4 pk
    | Some (5, Pbrt.Varint) -> begin
      occurrence_set_syntax_kind v (decode_pb_syntax_kind d);
    end
    | Some (5, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "occurrence" 5 pk
    | Some (6, Pbrt.Bytes) -> begin
      occurrence_set_diagnostics v ((decode_pb_diagnostic (Pbrt.Decoder.nested d)) :: v.diagnostics);
    end
    | Some (6, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "occurrence" 6 pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  (v : occurrence)

let rec decode_pb_relationship d =
  let v = default_relationship () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      relationship_set_symbol v (Pbrt.Decoder.string d);
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "relationship" 1 pk
    | Some (2, Pbrt.Varint) -> begin
      relationship_set_is_reference v (Pbrt.Decoder.bool d);
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "relationship" 2 pk
    | Some (3, Pbrt.Varint) -> begin
      relationship_set_is_implementation v (Pbrt.Decoder.bool d);
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "relationship" 3 pk
    | Some (4, Pbrt.Varint) -> begin
      relationship_set_is_type_definition v (Pbrt.Decoder.bool d);
    end
    | Some (4, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "relationship" 4 pk
    | Some (5, Pbrt.Varint) -> begin
      relationship_set_is_definition v (Pbrt.Decoder.bool d);
    end
    | Some (5, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "relationship" 5 pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  (v : relationship)

let rec decode_pb_symbol_information d =
  let v = default_symbol_information () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
      (* put lists in the correct order *)
      symbol_information_set_relationships v (List.rev v.relationships);
      symbol_information_set_documentation v (List.rev v.documentation);
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      symbol_information_set_symbol v (Pbrt.Decoder.string d);
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "symbol_information" 1 pk
    | Some (3, Pbrt.Bytes) -> begin
      symbol_information_set_documentation v ((Pbrt.Decoder.string d) :: v.documentation);
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "symbol_information" 3 pk
    | Some (4, Pbrt.Bytes) -> begin
      symbol_information_set_relationships v ((decode_pb_relationship (Pbrt.Decoder.nested d)) :: v.relationships);
    end
    | Some (4, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "symbol_information" 4 pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  (v : symbol_information)

let rec decode_pb_document d =
  let v = default_document () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
      (* put lists in the correct order *)
      document_set_symbols v (List.rev v.symbols);
      document_set_occurrences v (List.rev v.occurrences);
    ); continue__ := false
    | Some (4, Pbrt.Bytes) -> begin
      document_set_language v (Pbrt.Decoder.string d);
    end
    | Some (4, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "document" 4 pk
    | Some (1, Pbrt.Bytes) -> begin
      document_set_relative_path v (Pbrt.Decoder.string d);
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "document" 1 pk
    | Some (2, Pbrt.Bytes) -> begin
      document_set_occurrences v ((decode_pb_occurrence (Pbrt.Decoder.nested d)) :: v.occurrences);
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "document" 2 pk
    | Some (3, Pbrt.Bytes) -> begin
      document_set_symbols v ((decode_pb_symbol_information (Pbrt.Decoder.nested d)) :: v.symbols);
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "document" 3 pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  (v : document)

let rec decode_pb_index d =
  let v = default_index () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
      (* put lists in the correct order *)
      index_set_external_symbols v (List.rev v.external_symbols);
      index_set_documents v (List.rev v.documents);
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      index_set_metadata v (decode_pb_metadata (Pbrt.Decoder.nested d));
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "index" 1 pk
    | Some (2, Pbrt.Bytes) -> begin
      index_set_documents v ((decode_pb_document (Pbrt.Decoder.nested d)) :: v.documents);
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "index" 2 pk
    | Some (3, Pbrt.Bytes) -> begin
      index_set_external_symbols v ((decode_pb_symbol_information (Pbrt.Decoder.nested d)) :: v.external_symbols);
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "index" 3 pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  (v : index)

let rec decode_pb_package d =
  let v = default_package () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      package_set_manager v (Pbrt.Decoder.string d);
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "package" 1 pk
    | Some (2, Pbrt.Bytes) -> begin
      package_set_name v (Pbrt.Decoder.string d);
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "package" 2 pk
    | Some (3, Pbrt.Bytes) -> begin
      package_set_version v (Pbrt.Decoder.string d);
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "package" 3 pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  (v : package)

let rec decode_pb_descriptor_suffix d : descriptor_suffix = 
  match Pbrt.Decoder.int_as_varint d with
  | 0 -> Unspecified_suffix
  | 1 -> Namespace
  | 1 -> Package
  | 2 -> Type
  | 3 -> Term
  | 4 -> Method
  | 5 -> Type_parameter
  | 6 -> Parameter
  | 9 -> Macro
  | 7 -> Meta
  | 8 -> Local
  | _ -> Pbrt.Decoder.malformed_variant "descriptor_suffix"

let rec decode_pb_descriptor d =
  let v = default_descriptor () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      descriptor_set_name v (Pbrt.Decoder.string d);
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "descriptor" 1 pk
    | Some (2, Pbrt.Bytes) -> begin
      descriptor_set_disambiguator v (Pbrt.Decoder.string d);
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "descriptor" 2 pk
    | Some (3, Pbrt.Varint) -> begin
      descriptor_set_suffix v (decode_pb_descriptor_suffix d);
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "descriptor" 3 pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  (v : descriptor)

let rec decode_pb_symbol d =
  let v = default_symbol () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
      (* put lists in the correct order *)
      symbol_set_descriptors v (List.rev v.descriptors);
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      symbol_set_scheme v (Pbrt.Decoder.string d);
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "symbol" 1 pk
    | Some (2, Pbrt.Bytes) -> begin
      symbol_set_package v (decode_pb_package (Pbrt.Decoder.nested d));
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "symbol" 2 pk
    | Some (3, Pbrt.Bytes) -> begin
      symbol_set_descriptors v ((decode_pb_descriptor (Pbrt.Decoder.nested d)) :: v.descriptors);
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload_message "symbol" 3 pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  (v : symbol)

let rec decode_pb_symbol_role d : symbol_role = 
  match Pbrt.Decoder.int_as_varint d with
  | 0 -> Unspecified_symbol_role
  | 1 -> Definition
  | 2 -> Import
  | 4 -> Write_access
  | 8 -> Read_access
  | 16 -> Generated
  | 32 -> Test
  | _ -> Pbrt.Decoder.malformed_variant "symbol_role"

let rec decode_pb_language d : language = 
  match Pbrt.Decoder.int_as_varint d with
  | 0 -> Unspecified_language
  | 60 -> Abap
  | 49 -> Apl
  | 39 -> Ada
  | 45 -> Agda
  | 86 -> Ascii_doc
  | 58 -> Assembly
  | 66 -> Awk
  | 68 -> Bat
  | 81 -> Bib_te_x
  | 34 -> C
  | 59 -> Cobol
  | 35 -> Cpp
  | 26 -> Css
  | 1 -> Csharp
  | 8 -> Clojure
  | 21 -> Coffeescript
  | 9 -> Common_lisp
  | 47 -> Coq
  | 3 -> Dart
  | 57 -> Delphi
  | 88 -> Diff
  | 80 -> Dockerfile
  | 50 -> Dyalog
  | 17 -> Elixir
  | 18 -> Erlang
  | 42 -> Fsharp
  | 65 -> Fish
  | 24 -> Flow
  | 56 -> Fortran
  | 91 -> Git_commit
  | 89 -> Git_config
  | 92 -> Git_rebase
  | 33 -> Go
  | 7 -> Groovy
  | 30 -> Html
  | 20 -> Hack
  | 90 -> Handlebars
  | 44 -> Haskell
  | 46 -> Idris
  | 72 -> Ini
  | 51 -> J
  | 75 -> Json
  | 6 -> Java
  | 22 -> Java_script
  | 93 -> Java_script_react
  | 76 -> Jsonnet
  | 55 -> Julia
  | 4 -> Kotlin
  | 83 -> La_te_x
  | 48 -> Lean
  | 27 -> Less
  | 12 -> Lua
  | 79 -> Makefile
  | 84 -> Markdown
  | 52 -> Matlab
  | 77 -> Nix
  | 41 -> Ocaml
  | 36 -> Objective_c
  | 37 -> Objective_cpp
  | 19 -> Php
  | 70 -> Plsql
  | 13 -> Perl
  | 67 -> Power_shell
  | 71 -> Prolog
  | 15 -> Python
  | 54 -> R
  | 11 -> Racket
  | 14 -> Raku
  | 62 -> Razor
  | 85 -> Re_st
  | 16 -> Ruby
  | 40 -> Rust
  | 61 -> Sas
  | 29 -> Scss
  | 43 -> Sml
  | 69 -> Sql
  | 28 -> Sass
  | 5 -> Scala
  | 10 -> Scheme
  | 64 -> Shell_script
  | 78 -> Skylark
  | 2 -> Swift
  | 73 -> Toml
  | 82 -> Te_x
  | 23 -> Type_script
  | 94 -> Type_script_react
  | 63 -> Visual_basic
  | 25 -> Vue
  | 53 -> Wolfram
  | 31 -> Xml
  | 32 -> Xsl
  | 74 -> Yaml
  | 38 -> Zig
  | _ -> Pbrt.Decoder.malformed_variant "language"

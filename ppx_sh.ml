open Ast_helper
open Ast_mapper
open Asttypes
open Longident
open Parsetree

let create_list_exp (args:Parsetree.expression list) (loc:Ast_helper.loc) :
    Parsetree.expression =
  let rec aux args =
    begin match args with
      | [] ->
        Exp.construct ~loc ({
          txt = Lident "[]";
          loc
        }) None
      | x::xs ->
        let next = Exp.tuple ~loc [
          x;
          (aux xs)
        ] in
        Exp.construct ~loc ({
          txt = Lident "::";
          loc
        }) (Some next)
    end in
  aux args

let create_apply_exp (args:Parsetree.expression) (loc:Ast_helper.loc) :
    Parsetree.expression =
  let expr = Exp.ident ~loc ({
    txt = Ldot (Lident "Sh", "exec");
    loc
  }) in
  Exp.apply ~loc expr [("", args)]

let sh_expr mapper expr =
  begin match expr with
    | {
        pexp_desc = Pexp_extension(
          { txt = "sh"; loc },
          PStr[{ pstr_desc = Pstr_eval({ pexp_desc = expr }, _) }]
        )
      } ->
      begin match expr with
        | Pexp_constant const ->
          let const = Exp.constant ~loc const in
          let args = create_list_exp [const] loc in
          create_apply_exp args loc
        | Pexp_ident ident ->
          let ident = Exp.ident ~loc ident in
          let args = create_list_exp [ident] loc in
          create_apply_exp args loc
        | Pexp_apply (expr, args) ->
          let _, args = List.split args in
          let args = expr::args in
          let args = create_list_exp args loc in
          create_apply_exp args loc
        | _ ->
          raise (Location.Error (Location.error ~loc "Need an expression."))
      end
    | x -> default_mapper.expr mapper x
  end

let sh_mapper argv = {
  default_mapper with expr = sh_expr
}

let () = register "sh" sh_mapper

(* Prefix for the temporary file to store the output of the shell command. *)
let temp_file_prefix = "sh"

(* Read the contents of the file at the given `file_path`. *)
let read_file (file_path:string) : (string list) =
  (* Open the file. *)
  let file = open_in file_path in
  (* Read the file line-by-line. *)
  let rec aux () =
    try
      let line = input_line file in
      line::(aux ())
    with _ ->
      [] in
  aux ()

(* Execute a shell command with the given `args` and return its exit code
   and output as a tuple. *)
let exec (args:string list) : (int * string list) =
  (* Concat `args`. *)
  let args = String.concat " " args in
  (* Resolve a name for `temp_file`. *)
  let temp_file = Filename.temp_file temp_file_prefix "" in
  (* Execute the command, piping its output to `temp_file`. *)
  let exit_code = Sys.command (args ^ " > " ^ temp_file) in
  (* Read the output from `temp_file` only if `exit_code` is 0. *)
  let output =
    if exit_code = 0 then
      read_file temp_file
    else
      [] in
  (* Delete `temp_file`. *)
  let _ = Sys.remove temp_file in
  (exit_code, output)

open OUnit2

let () = run_test_tt_main ("ppx_sh" >::: [

  "valid; returns a zero exit code and the output of the command" >:: (fun _ ->
    let exit_code, output = [%sh "echo" "foo"] in
      assert (exit_code = 0);
      assert (output = ["foo"]);
  );

  "valid; allows identifiers" >:: (fun _ ->
    let str = "foo" in
    let exit_code, output = [%sh "echo" str] in
      assert (exit_code = 0);
      assert (output = ["foo"]);
  );

  "invalid; returns a non-zero exit code and empty output" >:: (fun _ ->
    let exit_code, output = [%sh "foo 2>/dev/null"] in
      assert (exit_code <> 0);
      assert (output = []);
  );

])

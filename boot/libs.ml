let executables = [ "main" ]

let external_libraries = [ "unix"; "threads" ]

let local_libraries =
  [ ("otherlibs/ordering", Some "Ordering", false, None)
  ; ("vendor/pp/src", Some "Pp", false, None)
  ; ("otherlibs/dyn", Some "Dyn", false, None)
  ; ("otherlibs/stdune/dune_filesystem_stubs", Some "Dune_filesystem_stubs",
    false, None)
  ; ("vendor/csexp/src", Some "Csexp", false, None)
  ; ("otherlibs/stdune/src", Some "Stdune", false, None)
  ; ("src/dune_graph", Some "Dune_graph", false, None)
  ; ("vendor/incremental-cycles/src", Some "Incremental_cycles", false, None)
  ; ("src/dag", Some "Dag", false, None)
  ; ("otherlibs/fiber/src", Some "Fiber", false, None)
  ; ("src/dune_console", Some "Dune_console", false, None)
  ; ("src/memo", Some "Memo", false, None)
  ; ("src/dune_metrics", Some "Dune_metrics", false, None)
  ; ("src/dune_digest", Some "Dune_digest", false, None)
  ; ("src/dune_sexp", Some "Dune_sexp", false, None)
  ; ("src/ocaml-config", Some "Ocaml_config", false, None)
  ; ("src/ocaml", Some "Ocaml", false, None)
  ; ("vendor/re/src", Some "Dune_re", false, None)
  ; ("otherlibs/dune-glob/src", Some "Dune_glob", false, None)
  ; ("otherlibs/xdg", Some "Xdg", false, None)
  ; ("otherlibs/dune-rpc/private", Some "Dune_rpc_private", false, None)
  ; ("vendor/build_path_prefix_map/src", Some "Build_path_prefix_map", false,
    None)
  ; ("src/dune_util", Some "Dune_util", false, None)
  ; ("src/dune_lang", Some "Dune_lang", false, None)
  ; ("src/fiber_util", Some "Fiber_util", false, None)
  ; ("src/dune_cache_storage", Some "Dune_cache_storage", false, None)
  ; ("src/dune_cache", Some "Dune_cache", false, None)
  ; ("vendor/opam-file-format/src", None, false, None)
  ; ("otherlibs/action-plugin/src", Some "Dune_action_plugin", false, None)
  ; ("otherlibs/chrome-trace/src", Some "Chrome_trace", false, None)
  ; ("vendor/spawn/src", Some "Spawn", false, None)
  ; ("src/dune_stats", Some "Dune_stats", false, None)
  ; ("src/section", Some "Dune_section", false, None)
  ; ("otherlibs/site/src/private", Some "Dune_site_private", false, None)
  ; ("src/meta_parser", Some "Dune_meta_parser", false, None)
  ; ("src/csexp_rpc", Some "Csexp_rpc", false, None)
  ; ("src/dune_rpc_server", Some "Dune_rpc_server", false, None)
  ; ("src/dune_rpc_client", Some "Dune_rpc_client", false, None)
  ; ("src/thread_pool", Some "Dune_thread_pool", false, None)
  ; ("otherlibs/ocamlc_loc/src", Some "Ocamlc_loc", false, None)
  ; ("src/fsevents", Some "Fsevents", false, None)
  ; ("vendor/ocaml-inotify/src", Some "Ocaml_inotify", false, None)
  ; ("src/async_inotify_for_dune", Some "Async_inotify_for_dune", false,
    None)
  ; ("src/fswatch_win", Some "Fswatch_win", false, None)
  ; ("src/dune_file_watcher", Some "Dune_file_watcher", false, None)
  ; ("src/dune_engine", Some "Dune_engine", false, None)
  ; ("src/dune_threaded_console", Some "Dune_threaded_console", false, None)
  ; ("vendor/uutf", None, false, None)
  ; ("vendor/notty/src", None, true, None)
  ; ("vendor/notty/src-unix", None, true, None)
  ; ("src/dune_tui", Some "Dune_tui", false, None)
  ; ("src/dune_config_file", Some "Dune_config_file", false, None)
  ; ("src/dune_rules", Some "Dune_rules", true, None)
  ; ("src/upgrader", Some "Dune_upgrader", false, None)
  ; ("vendor/cmdliner/src", None, false, None)
  ; ("otherlibs/build-info/src", Some "Build_info", false,
    Some "Build_info_data")
  ; ("src/dune_rpc_impl", Some "Dune_rpc_impl", false, None)
  ]

let link_flags =
  [ ("macosx",
    [ "-cclib"
    ; "-framework CoreFoundation"
    ; "-cclib"
    ; "-framework CoreServices"
    ])
  ; ("win32",
    [ "-cclib"; "-lshell32"; "-cclib"; "-lole32"; "-cclib"; "-luuid" ])
  ; ("win64",
    [ "-cclib"; "-lshell32"; "-cclib"; "-lole32"; "-cclib"; "-luuid" ])
  ; ("mingw",
    [ "-cclib"; "-lshell32"; "-cclib"; "-lole32"; "-cclib"; "-luuid" ])
  ; ("mingw64",
    [ "-cclib"; "-lshell32"; "-cclib"; "-lole32"; "-cclib"; "-luuid" ])
  ]

Test that the target directory exists

  $ cat > dune-project <<EOF
  > (lang dune 3.7)
  > (using melange 0.1)
  > EOF

  $ cat > dune <<EOF
  > (melange.emit
  >  (alias melange)
  >  (target output))
  > EOF

Create the target dir

  $ mkdir ./output
  $ cat > output/dune <<EOF
  > (rule
  >  (with-stdout-to index.txt (echo "hello")))
  > (alias (name melange) (deps index.txt))
  > EOF
  $ cat > hello.ml <<EOF
  > let () = Js.log "hello"
  > EOF

  $ dune build @melange
  $ ls _build/default/output
  hello.js
  index.txt

Target promotion works

  $ dune clean
  $ cat > dune <<EOF
  > (melange.emit
  >  (alias melange)
  >  (target output)
  >  (promote (until-clean)))
  > EOF

  $ dune build @melange
  $ ls _build/default/output
  hello.js
  index.txt



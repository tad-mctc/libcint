#!/usr/bin/env clisp
;;;; Copyright (C) 2013-  Qiming Sun <osirpt.sun@gmail.com>

(load "gen-code.cl")

(gen-cint "intor1.c"
  '("int1e_z"                   ( \| zc \| ))
  '("int1e_zz"                  ( \| zc zc \| ))
  '("int1e_z_origj"             ( \| z \| ))
  '("int1e_zz_origj"            ( \| z z \| ))
  '("int1e_r"                   ( \| rc \| ))
  '("int1e_rr"                  ( \| rc rc \| ))
  '("int1e_rrr"                 ( \| rc rc rc \| ))
  '("int1e_rrrr"                ( \| rc rc rc rc \| ))
  ;
  ; multipole integrals
  '("int1e_j"                   ( \| r \| ))
  '("int1e_jj"                  ( \| r r \| ))
  ; position derivative of multipole integrals
  '("int1e_ipj"                 ( nabla \| r \| ))
  '("int1e_jip"                 ( \| r \| nabla ))
  '("int1e_ipjj"                ( nabla \| r r \| ))
  '("int1e_jjip"                ( \| r r \| nabla ))
  '("int1e_ipjjip"              ( nabla \| r r \| nabla ))
  '("int1e_ipipjj"              ( nabla nabla \| r r \| ))
)

(gen-cint "overlap.c"
  ; position derivative
  ; 1st order derivatives
  '("int1e_ipovlp"              (nabla \|))
  '("int1e_ovlpip"              (\| nabla))
  ; 2nd order derivatives
  '("int1e_ipipovlp"            ( nabla nabla \| ))
  '("int1e_ipovlpip"            ( nabla \| nabla ))
  ; 3rd order derivatives
  '("int1e_ipipipovlp"          ( nabla nabla nabla \| ))
  '("int1e_ipipovlpip"          ( nabla nabla \| nabla ))
  ; 4th order derivatives
  '("int1e_ipipipipovlp"        ( nabla nabla nabla nabla \| ))
  '("int1e_ipipipovlpip"        ( nabla nabla nabla \| nabla ))
  '("int1e_ipipovlpipip"        ( nabla nabla \| nabla nabla ))
  ;
  ; basis derivative
  '("int1e_rrovlp"              (ri dot ri \| ))
  '("int1e_rrrrovlp"            (ri dot ri ri dot ri \| ))
  '("int1e_rrovlprr"            (ri dot ri \| rj dot rj))
)

(gen-cint "dipole.c"
  '("int1e_r0"                  ( \| r0 \| ))
  ; position derivative
  '("int1e_ipr0"                ( nabla \| r0 \| ))
  '("int1e_ipipr0"              ( nabla nabla \| r0 \| ))
  '("int1e_ipr0ip"              ( nabla \| r0 \| nabla ))
  '("int1e_ipipipr0"            ( nabla nabla nabla \| r0 \| ))
  '("int1e_ipipr0ip"            ( nabla nabla \| r0 \| nabla ))
  ; basis derivative
  '("int1e_rrr0"                ( ri dot ri \| r0 \| ))
  '("int1e_rrr0rr"              ( ri dot ri \| r0 \| rj dot rj ))
  '("int1e_rrrrr0"              ( ri dot ri ri dot ri \| r0 \| ))
)

(gen-cint "quadrupole.c"
  '("int1e_r0r0"                ( \| r0 r0 \| ))
  ; position derivative
  '("int1e_ipr0r0"              ( nabla \| r0 r0 \| ))
  '("int1e_ipipr0r0"            ( nabla nabla \| r0 r0 \| ))
  '("int1e_ipr0r0ip"            ( nabla \| r0 r0 \| nabla ))
  '("int1e_ipipipr0r0"          ( nabla nabla nabla \| r0 r0 \| ))
  '("int1e_ipipr0r0ip"          ( nabla nabla \| r0 r0 \| nabla ))
  ; basis derivative
  '("int1e_rrr0r0"              ( ri dot ri \| r0 r0 \| ))
  '("int1e_rrr0r0rr"            ( ri dot ri \| r0 r0 \| rj dot rj ))
  '("int1e_rrrrr0r0"            ( ri dot ri ri dot ri \| r0 r0 \| ))
)

(gen-cint "octupole.c"
  '("int1e_r0r0r0"              ( \| r0 r0 r0 \| ))
  ; position derivative
  '("int1e_ipr0r0r0"            ( nabla \| r0 r0 r0 \| ))
  '("int1e_ipipr0r0r0"          ( nabla nabla \| r0 r0 r0 \| ))
  '("int1e_ipr0r0r0ip"          ( nabla \| r0 r0 r0 \| nabla ))
  ; basis derivative
  '("int1e_rrr0r0r0"            ( ri dot ri \| r0 r0 r0 \| ))
  '("int1e_rrrrr0r0r0"          ( ri dot ri ri dot ri \| r0 r0 r0 \| ))
  '("int1e_rrr0r0r0rr"          ( ri dot ri \| r0 r0 r0 \| rj dot rj ))
)

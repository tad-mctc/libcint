#!/usr/bin/env clisp
;;;; Copyright (C) 2013-  Qiming Sun <osirpt.sun@gmail.com>

(load "gen-code.cl")

;;; Integrals required by dxtb (via tad-libcint).
;;;
;;; tad-libcint differentiates an integral by prepending an operator to the
;;; bra or ket of its name:
;;;   - "ip" (nabla) for derivatives w.r.t. the basis function centers,
;;;   - "rr" (ri dot ri) for derivatives w.r.t. the primitive exponents.
;;; A missing ket derivative of a bra/ket symmetric operator (ovlp, r0, r0r0)
;;; is obtained by transposing the bra derivative. The operators j and jj
;;; (r - R_j) are not symmetric and need all ket derivatives explicitly; the
;;; derivative of the operator itself requires the integral of the operator
;;; of rank n - 1 with the same derivative operators (j -> ovlp, jj -> j),
;;; again with the transpose fallback for the symmetric ovlp.
;;;
;;; Provided derivatives (ovlp, r0, r0r0, j, jj):
;;;   - position:  up to 3rd order
;;;   - exponent:  one exponent derivative on top of up to 2nd order position
;;;                derivatives (force and hessian training of parameters)
;;;   - exponent:  up to 2nd order
;;;
;;; NOTE: libcint applies the operators of the bra and of the ket from right
;;; to left, e.g., (nabla ri dot ri |) is nabla (r_i^2 i). Exponent and
;;; position derivatives commute, so every mixed derivative is written with
;;; the nablas outermost and the r^2 innermost, independent of the order of
;;; the operators in tad-libcint's name (e.g. "rripovlp").

(gen-cint "intor1.c"
  ; multipole integrals with origin at the center of basis j
  '("int1e_j"                   ( \| r \| ))
  ;
  ; position derivative (j)
  ; 1st order derivatives
  '("int1e_ipj"                 ( nabla \| r \| ))
  '("int1e_jip"                 ( \| r \| nabla ))
  ; 2nd order derivatives
  '("int1e_ipipj"               ( nabla nabla \| r \| ))
  '("int1e_ipjip"               ( nabla \| r \| nabla ))
  '("int1e_jipip"               ( \| r \| nabla nabla ))
  ; 3rd order derivatives
  '("int1e_ipipipj"             ( nabla nabla nabla \| r \| ))
  '("int1e_ipipjip"             ( nabla nabla \| r \| nabla ))
  '("int1e_ipjipip"             ( nabla \| r \| nabla nabla ))
  '("int1e_jipipip"             ( \| r \| nabla nabla nabla ))
  ;
  ; basis derivative (j)
  ; 1st order derivatives
  '("int1e_jrr"                 ( \| r \| rj dot rj ))
  '("int1e_rrj"                 ( ri dot ri \| r \| ))
  ; 2nd order derivatives
  '("int1e_jrrrr"               ( \| r \| rj dot rj rj dot rj ))
  '("int1e_rrjrr"               ( ri dot ri \| r \| rj dot rj ))
  '("int1e_rrrrj"               ( ri dot ri ri dot ri \| r \| ))
  ;
  ; basis derivative of position derivatives (j)
  ; 1st order position derivatives
  '("int1e_ipjrr"               ( nabla \| r \| rj dot rj ))
  '("int1e_jrrip"               ( \| r \| nabla rj dot rj ))
  '("int1e_rripj"               ( nabla ri dot ri \| r \| ))
  '("int1e_rrjip"               ( ri dot ri \| r \| nabla ))
  ; 2nd order position derivatives
  '("int1e_ipipjrr"             ( nabla nabla \| r \| rj dot rj ))
  '("int1e_ipjrrip"             ( nabla \| r \| nabla rj dot rj ))
  '("int1e_jrripip"             ( \| r \| nabla nabla rj dot rj ))
  '("int1e_rripipj"             ( nabla nabla ri dot ri \| r \| ))
  '("int1e_rripjip"             ( nabla ri dot ri \| r \| nabla ))
  '("int1e_rrjipip"             ( ri dot ri \| r \| nabla nabla ))
  ;
  '("int1e_jj"                  ( \| r r \| ))
  ;
  ; position derivative (jj)
  ; 1st order derivatives
  '("int1e_ipjj"                ( nabla \| r r \| ))
  '("int1e_jjip"                ( \| r r \| nabla ))
  ; 2nd order derivatives
  '("int1e_ipipjj"              ( nabla nabla \| r r \| ))
  '("int1e_ipjjip"              ( nabla \| r r \| nabla ))
  '("int1e_jjipip"              ( \| r r \| nabla nabla ))
  ; 3rd order derivatives
  '("int1e_ipipipjj"            ( nabla nabla nabla \| r r \| ))
  '("int1e_ipipjjip"            ( nabla nabla \| r r \| nabla ))
  '("int1e_ipjjipip"            ( nabla \| r r \| nabla nabla ))
  '("int1e_jjipipip"            ( \| r r \| nabla nabla nabla ))
  ;
  ; basis derivative (jj)
  ; 1st order derivatives
  '("int1e_jjrr"                ( \| r r \| rj dot rj ))
  '("int1e_rrjj"                ( ri dot ri \| r r \| ))
  ; 2nd order derivatives
  '("int1e_jjrrrr"              ( \| r r \| rj dot rj rj dot rj ))
  '("int1e_rrjjrr"              ( ri dot ri \| r r \| rj dot rj ))
  '("int1e_rrrrjj"              ( ri dot ri ri dot ri \| r r \| ))
  ;
  ; basis derivative of position derivatives (jj)
  ; 1st order position derivatives
  '("int1e_ipjjrr"              ( nabla \| r r \| rj dot rj ))
  '("int1e_jjrrip"              ( \| r r \| nabla rj dot rj ))
  '("int1e_rripjj"              ( nabla ri dot ri \| r r \| ))
  '("int1e_rrjjip"              ( ri dot ri \| r r \| nabla ))
  ; 2nd order position derivatives
  '("int1e_ipipjjrr"            ( nabla nabla \| r r \| rj dot rj ))
  '("int1e_ipjjrrip"            ( nabla \| r r \| nabla rj dot rj ))
  '("int1e_jjrripip"            ( \| r r \| nabla nabla rj dot rj ))
  '("int1e_rripipjj"            ( nabla nabla ri dot ri \| r r \| ))
  '("int1e_rripjjip"            ( nabla ri dot ri \| r r \| nabla ))
  '("int1e_rrjjipip"            ( ri dot ri \| r r \| nabla nabla ))
  ;
  ; no derivatives (not yet used in dxtb)
  '("int1e_jjj"                 ( \| r r r \| ))
)

(gen-cint "overlap.c"
  ; position derivative
  ; 1st order derivatives
  '("int1e_ipovlp"              ( nabla \| ))
  ; 2nd order derivatives
  '("int1e_ipipovlp"            ( nabla nabla \| ))
  '("int1e_ipovlpip"            ( nabla \| nabla ))
  ; 3rd order derivatives
  '("int1e_ipipipovlp"          ( nabla nabla nabla \| ))
  '("int1e_ipipovlpip"          ( nabla nabla \| nabla ))
  ;
  ; basis derivative
  ; 1st order derivatives
  '("int1e_rrovlp"              ( ri dot ri \| ))
  ; 2nd order derivatives
  '("int1e_rrovlprr"            ( ri dot ri \| rj dot rj ))
  '("int1e_rrrrovlp"            ( ri dot ri ri dot ri \| ))
  ;
  ; basis derivative of position derivatives
  ; 1st order position derivatives
  '("int1e_ipovlprr"            ( nabla \| rj dot rj ))
  '("int1e_rripovlp"            ( nabla ri dot ri \| ))
  ; 2nd order position derivatives
  '("int1e_ipipovlprr"          ( nabla nabla \| rj dot rj ))
  '("int1e_rripipovlp"          ( nabla nabla ri dot ri \| ))
  '("int1e_rripovlpip"          ( nabla ri dot ri \| nabla ))
)

(gen-cint "dipole.c"
  '("int1e_r0"                  ( \| r0 \| ))
  ;
  ; position derivative
  ; 1st order derivatives
  '("int1e_ipr0"                ( nabla \| r0 \| ))
  ; 2nd order derivatives
  '("int1e_ipipr0"              ( nabla nabla \| r0 \| ))
  '("int1e_ipr0ip"              ( nabla \| r0 \| nabla ))
  ; 3rd order derivatives
  '("int1e_ipipipr0"            ( nabla nabla nabla \| r0 \| ))
  '("int1e_ipipr0ip"            ( nabla nabla \| r0 \| nabla ))
  ;
  ; basis derivative
  ; 1st order derivatives
  '("int1e_rrr0"                ( ri dot ri \| r0 \| ))
  ; 2nd order derivatives
  '("int1e_rrr0rr"              ( ri dot ri \| r0 \| rj dot rj ))
  '("int1e_rrrrr0"              ( ri dot ri ri dot ri \| r0 \| ))
  ;
  ; basis derivative of position derivatives
  ; 1st order position derivatives
  '("int1e_ipr0rr"              ( nabla \| r0 \| rj dot rj ))
  '("int1e_rripr0"              ( nabla ri dot ri \| r0 \| ))
  ; 2nd order position derivatives
  '("int1e_ipipr0rr"            ( nabla nabla \| r0 \| rj dot rj ))
  '("int1e_rripipr0"            ( nabla nabla ri dot ri \| r0 \| ))
  '("int1e_rripr0ip"            ( nabla ri dot ri \| r0 \| nabla ))
)

(gen-cint "quadrupole.c"
  '("int1e_r0r0"                ( \| r0 r0 \| ))
  ;
  ; position derivative
  ; 1st order derivatives
  '("int1e_ipr0r0"              ( nabla \| r0 r0 \| ))
  ; 2nd order derivatives
  '("int1e_ipipr0r0"            ( nabla nabla \| r0 r0 \| ))
  '("int1e_ipr0r0ip"            ( nabla \| r0 r0 \| nabla ))
  ; 3rd order derivatives
  '("int1e_ipipipr0r0"          ( nabla nabla nabla \| r0 r0 \| ))
  '("int1e_ipipr0r0ip"          ( nabla nabla \| r0 r0 \| nabla ))
  ;
  ; basis derivative
  ; 1st order derivatives
  '("int1e_rrr0r0"              ( ri dot ri \| r0 r0 \| ))
  ; 2nd order derivatives
  '("int1e_rrr0r0rr"            ( ri dot ri \| r0 r0 \| rj dot rj ))
  '("int1e_rrrrr0r0"            ( ri dot ri ri dot ri \| r0 r0 \| ))
  ;
  ; basis derivative of position derivatives
  ; 1st order position derivatives
  '("int1e_ipr0r0rr"            ( nabla \| r0 r0 \| rj dot rj ))
  '("int1e_rripr0r0"            ( nabla ri dot ri \| r0 r0 \| ))
  ; 2nd order position derivatives
  '("int1e_ipipr0r0rr"          ( nabla nabla \| r0 r0 \| rj dot rj ))
  '("int1e_rripipr0r0"          ( nabla nabla ri dot ri \| r0 r0 \| ))
  '("int1e_rripr0r0ip"          ( nabla ri dot ri \| r0 r0 \| nabla ))
)

(gen-cint "octupole.c"
  ; no derivatives (not yet used in dxtb)
  '("int1e_r0r0r0"              ( \| r0 r0 r0 \| ))
)

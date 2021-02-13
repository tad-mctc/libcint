/*
 * This code computes incomplete gamma function.  It is based on Xin
 * Wu's implementation.
 *
 *
 * List of Abbreviation(s)
 *
 * THO:
 * Gaussian-Expansion Methods for Molecular Integrals,
 * Hiroshi Taketa, Sigeru Huzinaga, and Kiyosi O-ohata,
 * Journal of the Physical Society of Japan,
 * Vol. 21, No. 11, 1966, 2313 - 2324.
 *
 */

#include <math.h>
#define SML_FLOAT64   1.0e-16
#define SML_FLOAT80   1.0e-20
#define SQRTPIE4      .8862269254527580136490837416705725913987747280611935641069038949264
#define SQRTPIE4l     .8862269254527580136490837416705725913987747280611935641069038949264l
#define ERFC_bound    705

#ifdef HAVE_QUADMATH_H
#include <quadmath.h>
#define SQRTPIE4q     .8862269254527580136490837416705725913987747280611935641069038949264q
#define SML_FLOAT128  1.0e-34
#endif

/*
 * Name
 *
 * fmtpse
 *
 * Synopsis
 *
 * double fmtpse(FINT m, double t)
 *
 * Description
 *
 * This function evaluates the auxiliary integral,
 *
 *             _ 1           2
 *            /     2 m  -t u
 * F (t)  =   |    u    e      du,
 *  m        _/  0
 *
 * by a power series expansion
 *
 *                    _                    2                     3                _
 *           exp(-t) |       t            t                     t                  |
 * F (t)  =  ------- | 1 + ----- + --------------- + ----------------------- + ... |
 *  m          2 b   |_    b + 1   (b + 1) (b + 2)   (b + 1) (b + 2) (b + 3)      _|,
 *
 * where b = m + 1 / 2. This power series expansion converges fast, when t is less than b + 1,
 * namely t < m + 3 / 2.
 *
 * Argument(s)
 *
 * FINT m:
 * F_m(t), see the Description section.
 *
 * double t:
 * F_m(t), see the Description section.
 *
 * Return Value
 * double:
 * F_m(t), see the Description section.
 *
 */

/*
 * Name
 *
 * fmt
 *
 * Synopsis
 *
 * double fmt(FINT m, double t)
 *
 * Description
 *
 * This function evaluates the auxiliary integral, see Eq. 2.11 in THO,
 *
 *             _ 1           2
 *            /     2 m  -t u
 * F (t)  =   |    u    e      du,
 *  m        _/  0
 *
 * where m replaces ν for more convenient typesetting.
 *
 * If t is less than SML16 or equals 0, then
 *
 *              1
 * F (t)  =  -------.
 *  m        2 m + 1
 *
 * If t is less than m + 3 / 2, the auxiliary integral is evaluated by
 * a power series expansion (see fmtpse.c for details).
 *
 * Otherwise F (t) is calculated first
 *            0
 *                    1
 *                    -
 *           1 /  π  \2       _
 * F (t)  =  - | --- |  erf( /t ).
 *  0        2 \  t  /
 *
 * Then the upward recurrence relation is used for F (t) of higher m
 *                                                  m
 *
 *            (2 m - 1) F     (t) - exp( -t )
 *                       m - 1
 *  F (t)  =  -------------------------------.
 *   m                      2 t
 *
 * Argument(s)
 *
 * FINT m:
 * F_m(t), see the Description section.
 *
 * double t:
 * F_m(t), see the Description section.
 *
 * Return Value
 *
 * double:
 * F_m(t), see the Description section.
 *
 */
void gamma_inc_like(double *f, double t, FINT m)
{
        FINT i;
        double turnover_point;
        if (m < 3) {
                turnover_point = m + 1.5;
        } else {
                turnover_point = 5;
        }

        if (t < turnover_point) {
                double b = m + 0.5;
                double bi;
                double e = .5 * exp(-t);
                double x = e;
                double s = e;
                for (bi = b + 1.; x > SML_FLOAT64; bi += 1.) {
                        x *= t / bi;
                        s += x;
                }
                f[m] = s / b;
                for (i = m; i > 0; i--) {
                        b -= 1.;
                        f[i-1] = (e + t * f[i]) / b;
                }
        } else {
                double tt = sqrt(t);
                f[0] = SQRTPIE4 / tt * erf(tt);
                if (m > 0) {
                        double e = exp(-t);
                        double b = .5 / t;
                        for (i = 1; i <= m; i++)
                                f[i] = b * ((2*i-1) * f[i-1] - e);
                }
        }
}

void lgamma_inc_like(long double *f, long double t, FINT m)
{
        FINT i;
        long double turnover_point;
        if (m < 3) {
                turnover_point = m + 1.5;
        } else {
                turnover_point = 5;
        }

        if (t < turnover_point) {
                long double b = m + 0.5l;
                long double bi;
                long double e = .5l * expl(-t);
                long double x = e;
                long double s = e;
                for (bi = b + 1.; x > SML_FLOAT80; bi += 1.) {
                        x *= t / bi;
                        s += x;
                }
                f[m] = s / b;
                for (i = m; i > 0; i--) {
                        b -= 1;
                        f[i-1] = (e + t * f[i]) / b;
                }
        } else {
                long double tt = sqrtl(t);
                f[0] = SQRTPIE4l / tt * erfl(tt);
                if (m > 0) {
                        long double e = expl(-t);
                        long double b = .5l / t;
                        for (i = 1; i <= m; i++)
                                f[i] = b * ((2*i-1) * f[i-1] - e);
                }
        }
}

#ifdef HAVE_QUADMATH_H
void qgamma_inc_like(__float128 *f, __float128 t, FINT m)
{
        FINT i;
        __float128 turnover_point;
        if (m < 3) {
                turnover_point = m + 1.5;
        } else {
                turnover_point = 5;
        }

        if (t < turnover_point) {
                __float128 b = m + .5q;
                __float128 bi;
                __float128 e = .5q * expq(-t);
                __float128 x = e;
                __float128 s = e;
                for (bi = b + 1.; x > SML_FLOAT128; bi += 1.) {
                        x *= t / bi;
                        s += x;
                }
                f[m] = s / b;
                for (i = m; i > 0; i--) {
                        b -= 1;
                        f[i-1] = (e + t * f[i]) / b;
                }
        } else {
                __float128 tt = sqrtq(t);
                f[0] = SQRTPIE4q / tt * erfq(tt);
                if (m > 0) {
                        __float128 e = expq(-t);
                        __float128 b = .5q / t;
                        for (i = 1; i <= m; i++)
                                f[i] = b * ((2*i-1) * f[i-1] - e);
                }
        }
}
#endif

inline double _pow(double base, FINT exponent)
{
        FINT i;
        double result = 1;
        for (i = 1; i <= exponent; i <<= 1) {
                if (i & exponent) {
                        result *= base;
                }
                base *= base;
        }
        return result;
}

/* This function evaluates the auxiliary integral,
 *
 *     2  _ 1           2
 *  t s  /     2 m  -t u
 * e     |    u    e      du,
 *      _/  s
 *
 * by a power series expansion
 *
 * F[m] = e^{t s^2} int_l^1 u^{2m} e^{-t u^2} du
 *      = e^{t s^2} /(2m+1) int e^{-t u^2} d u^{2m+1}
 *      = e^{t s^2} /(2m+1) [e^{-t u^2} u^{2m+1}]_l^1 + (2t)/(2m+1) int u^{2m+2} e^{-t u^2} du
 *      = e^{t s^2} /(m+.5) (.5*e^{-t} - .5*e^{-t l^2} l^{2m+1}) + t F[m+1])
 */
void fmt_erfc_like(double *f, double t, double lower, FINT m)
{
        FINT i;
        double lower2 = lower * lower;
#ifdef WITH_RANGE_COULOMB
        // F[m] < .5*sqrt(pi/t) * erfc(low*tt)
        if (t * lower2 > ERFC_bound) {
                for (i = 0; i <= m; i++) {
                        f[i] = 0;
                }
                return;
        }
#endif

        double turnover_point;
        if (m < 3) {
                turnover_point = m + .5;
        } else {
                turnover_point = 4;
        }

        if (t < turnover_point) {
                double b = m + 0.5;
                double bi;
                double e = .5 * exp(-t);
                double e1 = .5 * exp(-t * lower2) * lower;
                e1 *= _pow(lower2, m);
                double x = e;
                double x1 = e1;
                double s = e - e1;
                double div = 1;
                double delta = s;
                for (bi = b + 1.; fabs(delta) > SML_FLOAT64; bi += 1.) {
                        div *= t / bi;
                        x1 *= lower2;
                        delta = (x - x1) * div;
                        s += delta;
                }
                double val = s / b;
                f[m] = val;
                for (i = m; i > 0; i--) {
                        b -= 1.;
                        e1 /= lower2;
                        val = (e - e1 + t * val) / b;
                        f[i-1] = val;
                }
        } else {
                double tt = sqrt(t);
                // erfc(a) - erfc(b) is more accurate than erf(b) - erf(a)
                double val = SQRTPIE4 / tt * (erfc(lower * tt) - erfc(tt));
                f[0] = val;
                if (m > 0) {
                        double e = exp(-t);
                        double e1 = exp(-t*lower2) * lower;
                        double b = .5 / t;
                        for (i = 0; i < m; i++) {
                                val = b * ((2*i+1) * val - e + e1);
                                e1 *= lower2;
                                f[i+1] = val;
                        }
                }
        }
}


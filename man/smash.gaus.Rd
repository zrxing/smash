% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/smash.R
\name{smash.gaus}
\alias{smash.gaus}
\title{Estimate underlying mean function from noisy Gaussian data.}
\usage{
smash.gaus(
  x,
  sigma = NULL,
  v.est = FALSE,
  joint = FALSE,
  v.basis = FALSE,
  post.var = FALSE,
  filter.number = 1,
  family = "DaubExPhase",
  return.loglr = FALSE,
  jash = FALSE,
  SGD = TRUE,
  weight = 0.5,
  min.var = 1e-08,
  ashparam = list(),
  homoskedastic = FALSE,
  reflect = FALSE
)
}
\arguments{
\item{x}{A vector of observations. Reflection is done automatically
if length of \code{x} is not a power of 2.}

\item{sigma}{A vector of standard deviations. Can be provided if
known or estimated beforehand.}

\item{v.est}{Boolean indicating if variance estimation should be
performed instead.}

\item{joint}{Boolean indicating if results of mean and variance
estimation should be returned together.}

\item{v.basis}{Boolean indicating if the same wavelet basis should
be used for variance estimation as mean estimation. If false,
defaults to Haar basis for variance estimation (this is much faster
than other bases).}

\item{post.var}{Boolean indicating if the posterior variance should
be returned for the mean and/or variance estiamtes.}

\item{filter.number}{Choice of wavelet basis to be used, as in
\code{wavethresh}.}

\item{family}{Choice of wavelet basis to be used, as in
\code{wavethresh}.}

\item{return.loglr}{Boolean indicating if a logLR should be returned.}

\item{jash}{Indicates if the prior from method JASH should be
used. This will often provide slightly better variance estimates
(especially for nonsmooth variance functions), at the cost of
computational efficiency. Defaults to FALSE.}

\item{SGD}{Boolean indicating if stochastic gradient descent should
be used in the EM. Only applicable if jash=TRUE.}

\item{weight}{Optional parameter used in estimating overall
variance. Only works for Haar basis. Defaults to 0.5. Setting this
to 1 might improve variance estimation slightly.}

\item{min.var}{The minimum positive value to be set if the
variance estimates are non-positive.}

\item{ashparam}{A list of parameters to be passed to \code{ash};
default values are set by function \code{setAshParam.gaus}.}

\item{homoskedastic}{indicates whether to assume constant variance
(if v.est is true)}

\item{reflect}{A logical indicating if the signals should be
reflected.}
}
\value{
By default \code{smash.gaus} simply returns a vector of estimated means.
 However, if more outputs are requested (eg if return.loglr or v.est is TRUE) then
 the output is a list with one or more of the following elements:

  \item{mu.res}{A list with the mean estimate, its posterior variance
  if \code{post.var} is TRUE, the logLR if \code{return.loglr} is
  TRUE, or a vector of mean estimates if neither \code{post.var} nor
  \code{return.loglr} are TRUE.}

  If \code{v.est} is TRUE, then \code{smash.gaus} returns the
  following:

  \item{var.res}{A list with the variance estimate, its posterior
  variance if \code{post.var} is TRUE, or a vector of variance
  estimates if \code{post.var} is \code{FALSE} In addition, if
  \code{joint} is TRUE, then both \code{mu.res} and \code{var.res}
  are returned.}
}
\description{
This function performs
  non-parametric regression (signal denoising) using
  Empirical Bayes wavelet-based methods.
}
\details{
We assume that the data come from the model \eqn{Y_t =
  \mu_t + \epsilon_t} for \eqn{t=1,...,T}, where \eqn{\mu_t} is an
  underlying mean, assumed to be spatially structured (or treated as
  points sampled from a smooth continous function), and
  \eqn{\epsilon_t \sim N(0, \sigma_t)}, and are independent. Smash
  provides estimates of \eqn{\mu_t} and \eqn{\sigma_t^2} (and their
  posterior variances if desired).
}
\examples{

n=2^10
t=1:n/n
spike.f = function(x) (0.75*exp(-500*(x-0.23)^2) +
  1.5*exp(-2000*(x-0.33)^2) + 3*exp(-8000*(x-0.47)^2) +
  2.25*exp(-16000*(x-0.69)^2)+0.5*exp(-32000*(x-0.83)^2))
mu.s = spike.f(t)

# Gaussian case
mu.t = (1+mu.s)/5
plot(mu.t,type='l')
var.fn = (0.0001 + 4*(exp(-550*(t-0.2)^2) + exp(-200*(t-0.5)^2) +
  exp(-950*(t-0.8)^2)))/1.35
plot(var.fn,type='l')
rsnr=sqrt(5)
sigma.t=sqrt(var.fn)/mean(sqrt(var.fn))*sd(mu.t)/rsnr^2
X.s=rnorm(n,mu.t,sigma.t)
mu.est=smash.gaus(X.s)
plot(mu.t,type='l')
lines(mu.est,col=2)

}

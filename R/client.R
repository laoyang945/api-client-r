.ADJUST.HOST <- 'https://api.adjust.com'
.ROOT.PATH <- 'kpis/v1'
.TRACKERS.ROUTE <- 'trackers'
.ACCEPT.HEADER <- 'text/csv'
.AUTHORIZATION.HEADER <- 'Token token=%s'
.LIST.QUERY.PARAMS <- c('kpis', 'countries', 'os_names', 'device_types', 'grouping', 'events')
.VALUE.QUERY.PARAMS <- c('start_date', 'end_date', 'sandbox', 'period')

.AdjustRuntimeEnv <- new.env()

#' Convenience function for initiating a session with a user token and app token, generally required for the start of an Adjust API
#' session.
#' @seealso \code{\link{set.user.token}}, \code{\link{user.token}}, \code{\link{set.app.token}}, \code{\link{app.token}}
#' @export
adjust.setup <- function(user.token, app.token=NULL) {
  set.user.token(user.token)

  if (!is.null(app.token)) { set.app.token(app.token) }
}

#' Set an Adjust app.token once using this function and you can issue multiple API requests saving yourself having to
#' pass the token every time.
#' @seealso \code{\link{set.user.token}}, \code{\link{user.token}}, \code{\link{adjust.setup}}, \code{\link{app.token}}
#' @export
set.app.token <- function(app.token) {
  assign('app.token', app.token, envir=.AdjustRuntimeEnv)
}

#' Get the currently set app.token.
#' @seealso \code{\link{set.user.token}}, \code{\link{user.token}}, \code{\link{set.app.token}}, \code{\link{adjust.setup}}
#' @export
app.token <- function() {
  if (!exists('app.token', envir=.AdjustRuntimeEnv)) {
    stop('App token needs to be setup first through set.app.token()')
  }

  get('app.token', envir=.AdjustRuntimeEnv)
}

#' Set an Adjust user.token, required for authorization.
#' @seealso \code{\link{adjust.setup}}, \code{\link{user.token}}, \code{\link{set.app.token}}, \code{\link{app.token}}
#' @export
set.user.token <- function(user.token) {
  assign('user.token', user.token, envir=.AdjustRuntimeEnv)
}

#' Get the currently set authorization user.token.
#' @seealso \code{\link{set.user.token}}, \code{\link{adjust.setup}}, \code{\link{set.app.token}}, \code{\link{app.token}}
#' @export
user.token <- function() {
  get('user.token', envir=.AdjustRuntimeEnv)
}

#' Enable the verbose setting. Doing this will print out additional meta data on the API requests.
#' @seealso \code{\link{adjust.disable.verbose}}
#' @export
adjust.enable.verbose <- function() {
  assign('adjust.verbose', TRUE, envir=.AdjustRuntimeEnv)
}

#' Disable the verbose setting. Doing this will stop printing out additional meta data on the API requests.
#' @seealso \code{\link{adjust.enable.verbose}}
#' @export
adjust.disable.verbose <- function() {
  assign('adjust.verbose', FALSE, envir=.AdjustRuntimeEnv)
}

#' Delivers data for Adjust App KPIs. Refer to the KPI service docs under https://docs.adjust.com/en/kpi-service/
#' together with this help entry.
#' @param app.token pass it here or set it up once with \code{\link{set.app.token}}
#' @param tracker.token If you want data for a specific parent tracker, pass its token.
#' @param start_date YYYY-MM-DD The start date of the selected period.
#' @param end_date YYYY-MM-DD The end date of the selected period.
#' @param kpis A vector of App KPIs. See KPI service docs for more.
#' @param sandbox Boolean request only sandbox data
#' @param countries A vector of ISO 3166 alpha-2 country names.
#' @param os_names A vector of OS names. See KPI service docs for more.
#' @param device_types A vector of supported device types.
#' @param grouping A vector of supported grouping. E.g. \code{c('trackers', 'countries')}. For more on grouping, see the
#' KPI service docs.
#' @export
#' @examples
#' adjust.deliverables() # perhaps the simplest query, it uses the default request parameters on the setup app token.
#' adjust.deliverables(countries=c('us', 'de')) # scope by countries.
adjust.deliverables <- function(app.token=NULL, tracker.token=NULL, ...) {
  .api.query(NULL, app.token=app.token, tracker.token=tracker.token, ...)
}

#' Delivers data for Adjust Event KPIs. Refer to the KPI service docs under https://docs.adjust.com/en/kpi-service/
#' together with this help entry.
#' @param app.token pass it here or set it up once with \code{\link{set.app.token}}
#' @param tracker.token If you want data for a given parent tracker, pass its token.
#' @param start_date YYYY-MM-DD The start date of the selected period.
#' @param end_date YYYY-MM-DD The end date of the selected period.
#' @param kpis A vector of App KPIs. See KPI service documentation https://docs.adjust.com/en/kpi-service/ for a
#' list of supported App KPIs.
#' @param events A vector of event tokens for Event-specific queries.
#' @param sandbox Boolean request only sandbox data
#' @param countries A vector of ISO 3166 alpha-2 country names.
#' @param os_names A vector of OS names. See KPI service documentation https://docs.adjust.com/en/kpi-service/ for a
#' list of supported OS names.
#' @param device_types A vector of supported device types.
#' @param grouping A vector of supported grouping. E.g. \code{c('trackers', 'countries')}. For more on grouping, see the
#' KPI service docs.
#' @export
#' @examples
#' adjust.events() # perhaps the simplest query, it uses the default request parameters on the setup app token.
#' adjust.events(countries=c('us', 'de')) # scope by countries.
adjust.events <- function(app.token=NULL, tracker.token=NULL, ...) {
  .api.query('events', app.token=app.token, tracker.token=tracker.token, ...)
}

#' Delivers data for Adjust Cohorts. Refer to the KPI service docs under https://docs.adjust.com/en/kpi-service/
#' together with this help entry.
#' @param app.token pass it here or set it up once with \code{\link{set.app.token}}
#' @param tracker.token If you want data for a given parent tracker, pass its token.
#' @param start_date YYYY-MM-DD The start date of the selected period.
#' @param end_date YYYY-MM-DD The end date of the selected period.
#' @param kpis A vector of App KPIs. See KPI service documentation https://docs.adjust.com/en/kpi-service/ for a
#' list of supported App KPIs.
#' @param period The cohort period - one of day/week/month.
#' @param events A vector of event tokens for Event-specific queries.
#' @param sandbox Boolean request only sandbox data
#' @param countries A vector of ISO 3166 alpha-2 country names.
#' @param os_names A vector of OS names. See KPI service documentation https://docs.adjust.com/en/kpi-service/ for a
#' list of supported OS names.
#' @param device_types A vector of supported device types.
#' @param grouping A vector of supported grouping. E.g. \code{c('trackers', 'countries')}. For more on grouping, see the
#' KPI service docs.
#' @export
adjust.cohorts <- function(app.token=NULL, tracker.token=NULL, ...) {
  .api.query('cohorts', app.token=app.token, tracker.token=tracker.token, ...)
}

.api.query <- function (resource, app.token, tracker.token, ...) {
  if (is.null(app.token) && !exists('app.token', envir=.AdjustRuntimeEnv)) {
    stop('You need to pass an app.token or set one using set.app.token()')
  }

  if (is.null(app.token)) { app.token <- app.token() }

  .get.request(path=.api.path(app.token, tracker.token=tracker.token, resource=resource),
               query=.query.list(...))
}

.get.request <- function(...) {
  resp <- GET(.ADJUST.HOST, ..., add_headers(
    'Accept'=.ACCEPT.HEADER,
    'Authorization'=sprintf(.AUTHORIZATION.HEADER, user.token())
  ))

  if (.verbose()) {
    cat(sprintf("Request URL:\n%s\n", URLdecode(resp$url)))
  }

  if (status_code(resp) != 200) {
    stop(content(resp))
  }

  data.table(content(resp,encoding="UTF-8"))
}

.api.path <- function(app.token, resource=NULL, tracker.token=NULL) {
  components <- c(.ROOT.PATH, app.token)

  if (! is.null(tracker.token)) { components <- c(components, .TRACKERS.ROUTE, tracker.token) }

  if (! is.null(resource)) { components <- c(components, resource) }

  sprintf('%s.csv', paste(components, collapse='/'))
}

.query.list <- function(...) {
  args <- list(...)
  arg.names <- names(args)

  res <- list()

  for(param in .LIST.QUERY.PARAMS) {
    if (param %in% arg.names) {
      res[param] <- tolower(paste(args[[param]], collapse=','))
    }
  }

  for(param in .VALUE.QUERY.PARAMS) {
    if (param %in% arg.names) {
      res[param] <- tolower(toString(args[[param]]))
    }
  }

  res
}

.verbose <- function() {
  if (exists('adjust.verbose', envir=.AdjustRuntimeEnv)) {
    get('adjust.verbose', envir=.AdjustRuntimeEnv)
  } else {
    FALSE
  }
}
